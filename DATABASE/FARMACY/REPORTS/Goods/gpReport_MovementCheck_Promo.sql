-- Function: gpReport_MovementCheck_Promo()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_Promo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_Promo(
    IN inMakerId       Integer     -- Производитель
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer      --ИД Документа
              ,ItemName TVarChar       --Название(тип) документа
              ,Amount TFloat           --Кол-во маркетинговогго товара в документе
              ,Amount2 TFloat          --Кол-во не маркет. товара в документе
              ,Amount3 TFloat          --Кол-во маркет. товара вне периода действия маркет.договора
              ,Amount4 TFloat          --
              ,TotalAmount TFloat      --итого продажа шт
              ,Code Integer            --Код товара
              ,Name TVarChar           --Наименование товара
              ,NDSKindName TVarChar    --вид ндс
              ,NDS TFloat              --% ндс
              ,OperDate TDateTime      --Дата документа
              ,InvNumber TVarChar      --№ документа
              ,StatusName TVarChar     --Состояние документа
              ,UnitName TVarChar       --Подразделение
              ,MainJuridicalName TVarChar  --Наше Юр. лицо
              ,JuridicalName TVarChar  --Юр. лицо
              ,RetailName TVarChar     --Торговая сеть
              ,Price TFloat            --Цена в документе
              ,PriceWithVAT TFloat     --Цена прихода с НДС 
              ,PriceSale TFloat        --Цена продажи
              ,Summa TFloat
              ,SummaWithVAT TFloat
              ,SummaSale TFloat

              ,Comment  TVarChar       --Комментарий к документу
              ,PartionGoods TVarChar   --№ серии препарата
              ,ExpirationDate TDateTime--Срок годности
              ,InsertDate TDateTime    --Дата (созд.)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
    vbUserId:= lpGetUserBySession (inSession);
 
    RETURN QUERY
      WITH
          -- Id строк Маркетинговых контрактов inMakerId
     /*     tmpMIPromo AS (SELECT DISTINCT MI_Goods.Id AS MI_Id
                            FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                            ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                           AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                           AND MovementLinkObject_Maker.ObjectId = inMakerId 
                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_Promo()
                             )
       -- Товары из Маркетинговых контрактов
       ,*/  tmpGoodsPromo AS (SELECT DISTINCT
                                   MI_Goods.ObjectId  AS GoodsId        -- здесь товар
                                 , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                 , MovementDate_EndPromo.ValueData    AS EndDate_Promo 
                            FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                            ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                           AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                           AND MovementLinkObject_Maker.ObjectId = inMakerId
                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_Promo()
                       )
        -- товары промо
   ,  tmpGoods_All AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                            , tmpGoodsPromo.StartDate_Promo
                            , tmpGoodsPromo.EndDate_Promo 
                       FROM tmpGoodsPromo
                               -- !!!
                              INNER JOIN ObjectLink AS ObjectLink_Child
                                                    ON ObjectLink_Child.ChildObjectId = tmpGoodsPromo.GoodsId 
                                                   AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                        AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                         AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                        WHERE  ObjectLink_Child_R.ChildObjectId<>0
                      ) 
    ,   tmpGoods AS (SELECT DISTINCT tmpGoods_All.GoodsId FROM tmpGoods_All)

    ,   tmpListGodsMarket AS (SELECT DISTINCT tmpGoods_All.GoodsId
                                   , tmpGoods_All.StartDate_Promo 
                                   , tmpGoods_All.EndDate_Promo 
                              FROM tmpGoods_All
                              WHERE tmpGoods_All.StartDate_Promo <= inEndDate
                                AND tmpGoods_All.EndDate_Promo >= inStartDate
                              )

     -- выбираем все чеки с товарами маркетингового контракта
   ,   tmpMIContainer AS (SELECT MIContainer.MovementId  AS MovementId_Check
                              , COALESCE (MIContainer.AnalyzerId,0)  AS MovementItemId_Income
                              , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                              , MIContainer.ObjectId_analyzer AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                              
                              , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0 AND COALESCE (tmpListGodsMarket.GoodsId,0) <> 0 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END ) AS Amount
                              , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0)  = 0 AND COALESCE (tmpListGodsMarket.GoodsId,0) <> 0 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END ) AS Amount2
                              , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0 AND COALESCE (tmpListGodsMarket.GoodsId,0)  = 0 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END ) AS Amount3
                              , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0)  = 0 AND COALESCE (tmpListGodsMarket.GoodsId,0)  = 0 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END ) AS Amount4
                              
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS TotalAmount
                         FROM MovementItemContainer AS MIContainer
                            --INNER JOIN tmpMIPromo ON tmpMIPromo.MI_Id = MIContainer.ObjectIntId_analyzer
                             INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                             LEFT JOIN tmpListGodsMarket ON tmpListGodsMarket.GoodsId = MIContainer.ObjectId_Analyzer
                                                        AND tmpListGodsMarket.StartDate_Promo <= MIContainer.OperDate
                                                        AND tmpListGodsMarket.EndDate_Promo >= MIContainer.OperDate
                         WHERE MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.MovementDescId = zc_Movement_Check()
                           AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                          -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                          -- AND COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0 
                           AND COALESCE (inMakerId, 0) <> 0
                         GROUP BY MIContainer.MovementId
                                , COALESCE (MIContainer.WhereObjectId_analyzer,0)
                                , COALESCE (MIContainer.AnalyzerId,0)
                                , MIContainer.ObjectId_analyzer 
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                         )
  
       -- находим поставщика
       , tmpData_all AS (SELECT tmp.MovementId_Check
                              , tmp.UnitId 
                              , tmp.MovementItemId_Income
                              , tmp.GoodsId
                              , tmp.Amount
                              , tmp.Amount2
                              , tmp.Amount3
                              , tmp.Amount4
                              , tmp.TotalAmount
                              , tmp.SummaSale
                              , MovementLinkObject_From_Income.ObjectId AS JuridicalId_Income
                         FROM tmpMIContainer AS tmp
                              INNER JOIN MovementItem AS MI_Income ON MI_Income.Id = tmp.MovementItemId_Income
                              INNER JOIN Movement AS Movement_Income ON Movement_Income.Id = MI_Income.MovementId
                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                            ON MovementLinkObject_From_Income.MovementId = Movement_Income.Id 
                                                           AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                         ) 
           -- 
           , tmpData AS (SELECT tmpData_all.MovementId_Check
                              , tmpData_all.UnitId
                              , tmpData_all.JuridicalId_Income
                              , tmpData_all.GoodsId
                              , MIString_PartionGoods.ValueData          AS PartionGoods
                              , MIDate_ExpirationDate.ValueData          AS ExpirationDate
                              , SUM (tmpData_all.TotalAmount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.TotalAmount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)      AS Amount
                              , SUM (tmpData_all.SummaSale)   AS SummaSale
                              , SUM (tmpData_all.Amount2)     AS Amount2
                              , SUM (tmpData_all.Amount3)     AS Amount3
                              , SUM (tmpData_all.Amount4)     AS Amount4
                              , SUM (tmpData_all.TotalAmount) AS TotalAmount
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
                       
                         GROUP BY tmpData_all.JuridicalId_Income
                                , tmpData_all.MovementId_Check
                                , tmpData_all.GoodsId
                                , tmpData_all.UnitId
                                , MIString_PartionGoods.ValueData
                                , MIDate_ExpirationDate.ValueData
                        )

      
      -- Результат
      SELECT Movement.Id                              AS MovementId
            ,'Продажи касс'               :: TVarChar AS ItemName
            ,tmpData.Amount               :: TFloat   AS Amount
            ,tmpData.Amount2              :: TFloat   AS Amount2
            ,tmpData.Amount3              :: TFloat   AS Amount3
            ,tmpData.Amount4              :: TFloat   AS Amount4
            ,tmpData.TotalAmount          :: TFloat   AS TotalAmount
            ,Object.ObjectCode                        AS Code
            ,Object.ValueData                         AS Name
            ,Object_NDSKind.ValueData                 AS NDSKindName
            ,ObjectFloat_NDSKind_NDS.ValueData        AS NDS
            ,Movement.OperDate                        AS OperDate
            ,Movement.InvNumber                       AS InvNumber
            ,Object_Status.ValueData                  AS StatusName
            ,Object_Unit.ValueData                    AS UnitName
            ,Object_MainJuridical.ValueData           AS MainJuridicalName
            ,Object_From.ValueData                    AS JuridicalName
            ,Object_Retail.ValueData                  AS RetailName 
            ,CASE WHEN tmpData.TotalAmount <> 0 THEN tmpData.Summa / tmpData.TotalAmount ELSE 0 END        :: TFloat AS Price
            ,CASE WHEN tmpData.TotalAmount <> 0 THEN tmpData.SummaWithVAT / tmpData.TotalAmount ELSE 0 END :: TFloat AS PriceWithVAT

            ,CASE WHEN tmpData.TotalAmount <> 0 THEN tmpData.SummaSale    / tmpData.TotalAmount ELSE 0 END :: TFloat AS PriceSale

            ,tmpData.Summa        :: TFloat
            ,tmpData.SummaWithVAT :: TFloat
            ,tmpData.SummaSale    :: TFloat

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

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_MainJuridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.JuridicalId_Income

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.DescId = zc_MovementString_Comment()
                                AND MovementString_Comment.MovementId = tmpData.MovementId_Check
  -- WHERE (tmpData.Amount+ tmpData.Amount2+tmpData.Amount3) <> 0
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.01.18         *
 23.03.17         *
 09.01.17         * на проводках
 23.11.16         *
 08.11.16         *
*/

-- тест
--select * from gpReport_MovementCheck_Promo(inMakerId := 2336655 , inStartDate := ('01.11.2016')::TDateTime , inEndDate := ('30.11.2016')::TDateTime ,  inSession := '3');