-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_Promo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_Promo(
    IN inMakerId       Integer     -- Производитель
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer      --ИД Документа
              ,ItemName TVarChar       --Название(тип) документа
              ,Amount TFloat           --Кол-во товара в документе
              ,Code Integer            --Код товара
              ,Name TVarChar           --Наименование товара
  --            ,PartnerGoodsName TVarChar  --Наименование поставщика
  --            ,MakerName  TVarChar     --Производитель
              ,NDSKindName TVarChar    --вид ндс
              ,OperDate TDateTime      --Дата документа
              ,InvNumber TVarChar      --№ документа
              ,StatusName TVarChar     --Состояние документа
              ,UnitName TVarChar       --Подразделение
              ,JuridicalName TVarChar  --Юр. лицо
              ,Price TFloat            --Цена в документе
              ,PriceWithVAT TFloat     --Цена прихода с НДС 
              ,PriceSale TFloat        --Цена продажи
              ,Comment  TVarChar       --Комментарий к документу
              ,PartionGoods TVarChar   --№ серии препарата
              ,ExpirationDate TDateTime--Срок годности
              ,InsertDate TDateTime    --Дата (созд.)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' OR vbUserId = 3 THEN
      vbUnitKey := '0';
    END IF;   
    vbUnitId := vbUnitKey::Integer;

    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    RETURN QUERY
      WITH
               tmpMI AS (SELECT MIContainer.ContainerId
                              , Movement_Check.Id                   AS MovementId_Check
                              , MovementLinkObject_Unit.ObjectId    AS UnitId
                              , MI_Check.ObjectId                   AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND ((MovementLinkObject_Unit.ObjectId = vbUnitId) OR (vbUnitId = 0)) 
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                           AND COALESCE (inMakerId, 0) <> 0
                         GROUP BY MI_Check.ObjectId
                                , Movement_Check.Id
                                , MovementLinkObject_Unit.ObjectId
                                , MIContainer.ContainerId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )
       , tmpData_1 AS (SELECT tmpMI.MovementId_Check
                              , tmpMI.UnitId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId_Income
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM tmpMI
                              -- нашли партию
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId

                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                        )
           -- здесь ограничиваем товарами маркетингового контракта
       , tmpData_all AS (SELECT tmpData_1.MovementId_Check
                              , tmpData_1.UnitId
                              , tmpData_1.MovementItemId_Income
                              , tmpData_1.GoodsId
                              , tmpData_1.Amount
                              , tmpData_1.SummaSale
                              , MovementLinkObject_From_Income.ObjectId AS JuridicalId_Income
                         FROM tmpData_1
                              INNER JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData_1.MovementId
                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_1.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                                                    
                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON /*MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND */MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                     AND MovementDate_StartPromo.ValueData <= Movement_Income.OperDate
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON /*MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND */MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                     AND MovementDate_EndPromo.ValueData >= Movement_Income.OperDate
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                            ON MovementLinkObject_Maker.MovementId = MovementDate_StartPromo.MovementId
                                                           AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                           AND MovementLinkObject_Maker.ObjectId = inMakerId
                              INNER JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementDate_StartPromo.MovementId
                                                                   AND Movement_Promo.DescId = zc_Movement_Promo()
                                                                   AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement_Promo.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                                                                 AND MI_Goods.ObjectId = tmpData_1.GoodsId
                              INNER JOIN MovementItem AS MI_Juridical ON MI_Juridical.MovementId = Movement_Promo.Id
                                                                     AND MI_Juridical.DescId = zc_MI_Child()
                                                                     AND MI_Juridical.isErased = FALSE
                                                                     AND MI_Juridical.ObjectId = MovementLinkObject_From_Income.ObjectId
                             ) 

           , tmpData AS (SELECT tmpData_all.MovementId_Check
                              , tmpData_all.UnitId
                              , tmpData_all.JuridicalId_Income
                              , tmpData_all.GoodsId
                              , MIString_PartionGoods.ValueData          AS PartionGoods
                              , MIDate_ExpirationDate.ValueData          AS ExpirationDate
                              --, MI_Income_View.PartnerGoodsName          AS PartnerGoodsName
                              --, MI_Income_View.MakerName                 AS MakerName
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                         FROM tmpData_all
                              -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId_Income
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                          ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId_Income
                                                         AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              -- № партии препарата
                              LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                           ON MIString_PartionGoods.MovementItemId = tmpData_all.MovementItemId_Income
                                                          AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                              -- Срок годности
                              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = tmpData_all.MovementItemId_Income
                                                        AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                          
                             -- LEFT JOIN MovementItem_Income_View AS MI_Income_View ON MI_Income_View.Id = tmpData_all.MovementItemId_Income

                         GROUP BY tmpData_all.JuridicalId_Income
                                , tmpData_all.MovementId_Check
                                , tmpData_all.GoodsId
                                , tmpData_all.UnitId
                                , MIString_PartionGoods.ValueData
                                , MIDate_ExpirationDate.ValueData
                             --   , MI_Income_View.PartnerGoodsName
                             --   , MI_Income_View.MakerName
                        )


      SELECT Movement.Id                              AS MovementId
            ,'Продажи касс'               :: TVarChar AS ItemName
            ,tmpData.Amount               :: TFloat   AS Amount
            ,Object.ObjectCode                        AS Code
            ,Object.ValueData                         AS Name
       --     ,tmpData.PartnerGoodsName     :: TVarChar
       --     ,tmpData.MakerName            :: TVarChar

            ,Object_NDSKind.ValueData                 AS NDSKindName
            ,Movement.OperDate                        AS OperDate
            ,Movement.InvNumber                       AS InvNumber
            ,Object_Status.ValueData                  AS StatusName
            ,Object_Unit.ValueData                    AS UnitName
            ,Object_From.ValueData                    AS JuridicalName
            ,CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa / tmpData.Amount ELSE 0 END        :: TFloat AS Price
            ,CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT

            ,CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale

            ,MovementString_Comment.ValueData  :: TVarChar        AS Comment

            ,tmpData.PartionGoods
            ,tmpData.ExpirationDate
           
            ,MovementDate_Insert.ValueData            AS InsertDate

      FROM tmpData 
        LEFT JOIN Movement ON Movement.Id = tmpData.MovementId_Check
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId 
                   
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = tmpData.MovementId_Check
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

        LEFT JOIN Object ON Object.Id = tmpData.GoodsId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
        LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.JuridicalId_Income

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.DescId = zc_MovementString_Comment()
                                AND MovementString_Comment.MovementId = tmpData.MovementId_Check
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 08.11.16         *
*/

-- тест
--SELECT * FROM gpReport_MovementCheck_Promo (inMakerId:= 2336604  , inStartDate:= '08.11.2016', inEndDate:= '08.11.2016', inSession:= '2')
