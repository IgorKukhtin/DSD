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
              ,UnitId Integer          --ID Подразделение
              ,UnitName TVarChar       --Подразделение
              ,MainJuridicalId integer  --Наше Юр. лицо
              ,MainJuridicalName TVarChar  --Наше Юр. лицо
              ,JuridicalId integer     --Юр. лицо
              ,JuridicalName TVarChar  --Юр. лицо
              ,RetailName TVarChar     --Торговая сеть
              ,Price TFloat            --Цена в документе
              ,PriceWithVAT TFloat     --Цена прихода с НДС 
              ,PriceSale TFloat        --Цена продажи
              , PriceSIP TFloat         --Цена СИП
              ,Summa TFloat
              ,SummaWithVAT TFloat
              ,SummaSale TFloat
              ,SummSIP TFloat          --Сумма СИП

              ,Comment  TVarChar       --Комментарий к документу
              ,PartionGoods TVarChar   --№ серии препарата
              ,ExpirationDate TDateTime--Срок годности
              ,InsertDate TDateTime    --Дата (созд.)

              , isChecked  Boolean      -- для маркетинга
              , isReport   Boolean      -- для отчета              
              , isSendMaker Boolean     -- для отчета производителю
              , GoodsGroupPromoName TVarChar -- Группы товаров для маркетинга
              , UserNameInsert TVarChar -- Кто создал или подтвердил
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
                                 , MIFloat_Price.ValueData            AS Price
                                 , COALESCE (MIBoolean_Checked.ValueData, FALSE)                                           ::Boolean  AS isChecked
                                 , CASE WHEN COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE THEN FALSE ELSE TRUE END ::Boolean  AS isReport
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
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                            ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                           AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_Promo()
                       )
        -- товары промо
   ,  tmpGoods_All AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                            , tmpGoodsPromo.StartDate_Promo
                            , tmpGoodsPromo.EndDate_Promo 
                            , tmpGoodsPromo.Price               AS PriceSIP
                            , tmpGoodsPromo.isChecked
                            , tmpGoodsPromo.isReport
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
                                   , tmpGoods_All.PriceSIP 
                                   , tmpGoods_All.isChecked
                                   , tmpGoods_All.isReport
                              FROM tmpGoods_All
                              WHERE tmpGoods_All.StartDate_Promo <= inEndDate
                                AND tmpGoods_All.EndDate_Promo >= inStartDate
                              )

     -- выбираем все чеки с товарами маркетингового контракта
   ,   tmpMIContainer AS (SELECT MIContainer.MovementId  AS MovementId_Check
                              , COALESCE (MIContainer.AnalyzerId,0)  AS MovementItemId_Income
                              , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                              , MIContainer.ObjectId_analyzer AS GoodsId
                              , tmpListGodsMarket.PriceSIP 
                              , tmpListGodsMarket.isChecked
                              , tmpListGodsMarket.isReport

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
                                , tmpListGodsMarket.PriceSIP
                                , tmpListGodsMarket.isChecked
                                , tmpListGodsMarket.isReport
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                         )
  
       -- находим поставщика
       , tmpData_all AS (SELECT tmp.MovementId_Check
                              , tmp.UnitId 
                              , tmp.MovementItemId_Income
                              , tmp.GoodsId
                              , tmp.PriceSIP 
                              , tmp.isChecked
                              , tmp.isReport
                              , tmp.Amount
                              , tmp.Amount2
                              , tmp.Amount3
                              , tmp.Amount4
                              , tmp.TotalAmount
                              , tmp.SummaSale
                              , MovementLinkObject_From_Income.ObjectId :: Integer AS JuridicalId_Income
                         FROM tmpMIContainer AS tmp
                              INNER JOIN MovementItem AS MI_Income ON MI_Income.Id = tmp.MovementItemId_Income
                              INNER JOIN Movement AS Movement_Income ON Movement_Income.Id = MI_Income.MovementId
                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                            ON MovementLinkObject_From_Income.MovementId = Movement_Income.Id 
                                                           AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                         ) 
           -- 
       , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                  FROM MovementItemFloat
                                  WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId_Income FROM tmpData_all)
                                    AND MovementItemFloat.DescId IN (zc_MIFloat_JuridicalPrice(), zc_MIFloat_PriceWithVAT())
                                  )
       , tmpMovementItemString AS (SELECT MovementItemString.*
                                   FROM MovementItemString
                                   WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId_Income FROM tmpData_all)
                                     AND MovementItemString.DescId = zc_MIString_PartionGoods()
                                  )
       , tmpMovementItemDate AS (SELECT MovementItemDate.*
                                 FROM MovementItemDate
                                 WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId_Income FROM tmpData_all)
                                   AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                                 )

       , tmpData AS (SELECT tmpData_all.MovementId_Check
                          , tmpData_all.UnitId
                          , tmpData_all.JuridicalId_Income
                          , tmpData_all.GoodsId
                          , tmpData_all.PriceSIP
                          , tmpData_all.isChecked
                          , tmpData_all.isReport
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
                          LEFT JOIN tmpMovementItemFloat AS MIFloat_JuridicalPrice
                                                         ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId_Income
                                                        AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                          -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                          LEFT JOIN tmpMovementItemFloat AS MIFloat_PriceWithVAT
                                                         ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId_Income
                                                        AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                          -- № партии препарата
                          LEFT JOIN tmpMovementItemString AS MIString_PartionGoods
                                                          ON MIString_PartionGoods.MovementItemId = tmpData_all.MovementItemId_Income
                                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                          -- Срок годности
                          LEFT JOIN tmpMovementItemDate AS MIDate_ExpirationDate
                                                        ON MIDate_ExpirationDate.MovementItemId = tmpData_all.MovementItemId_Income
                                                       AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                   
                     GROUP BY tmpData_all.JuridicalId_Income
                            , tmpData_all.MovementId_Check
                            , tmpData_all.GoodsId
                            , tmpData_all.UnitId
                            , MIString_PartionGoods.ValueData
                            , MIDate_ExpirationDate.ValueData
                            , tmpData_all.PriceSIP
                            , tmpData_all.isChecked
                            , tmpData_all.isReport
                    )

      
       , tmpMovementDate AS (SELECT MovementDate.*
                             FROM MovementDate
                             WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpData.MovementId_Check FROM tmpData)
                               AND MovementDate.DescId = zc_MovementDate_Insert()
                             )

       , tmpMovementString AS (SELECT MovementString.*
                               FROM MovementString
                               WHERE MovementString.MovementId IN (SELECT DISTINCT tmpData.MovementId_Check FROM tmpData)
                                 AND MovementString.DescId = zc_MovementString_Comment()
                               )
      
       , tmpStatus AS ( SELECT * FROM Object WHERE descid = zc_Object_Status())
       
       , tmpMovement AS (SELECT Movement.*
                              , Object_Status.ValueData  AS StatusName
                              , Object_User.ValueData                             AS UserNameInsert
                         FROM Movement
                              LEFT JOIN tmpStatus AS Object_Status ON Object_Status.Id = Movement.StatusId-- and Object_Status.descid = zc_Object_Status()
                              LEFT JOIN MovementLinkObject AS MLO_Insert
                                                           ON MLO_Insert.MovementId = Movement.Id
                                                          AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                                           
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                                           ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()
                               
                              LEFT JOIN Object AS Object_User ON Object_User.Id = COALESCE(MLO_Insert.ObjectId, MovementLinkObject_UserConfirmedKind.ObjectId)
                         WHERE Movement.Id IN (SELECT DISTINCT tmpData.MovementId_Check FROM tmpData )
                        )
                        
       , tmpGoodsParam AS (SELECT ObjectLink_Goods_NDSKind.ObjectId      AS GoodsId
                                , Object.ObjectCode                      AS Code
                                , Object.ValueData                       AS Name
                                , ObjectLink_Goods_NDSKind.ChildObjectId AS NDSKindId
                                , Object_NDSKind.ValueData               AS NDSKindName
                                , ObjectFloat_NDSKind_NDS.ValueData      AS NDS
                           FROM ObjectLink AS ObjectLink_Goods_NDSKind
                                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                                LEFT JOIN Object ON Object.Id = ObjectLink_Goods_NDSKind.ObjectId
                           WHERE ObjectLink_Goods_NDSKind.ObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                             AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                              )
      
       , tmpUnitParam AS (SELECT Object_Unit.Id                           AS UnitId
                               , Object_Unit.ValueData                    AS UnitName
                               , Object_MainJuridical.Id                  AS MainJuridicalId
                               , Object_MainJuridical.ValueData           AS MainJuridicalName
                               , Object_Retail.ValueData                  AS RetailName 
                          FROM ObjectLink AS ObjectLink_Unit_Juridical
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Juridical.ObjectId
                               LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                               
                               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                                       
                          WHERE ObjectLink_Unit_Juridical.ObjectId IN (SELECT DISTINCT tmpData.UnitId FROM tmpData)
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                         )

      -- Результат
      SELECT Movement.Id                              AS MovementId
            , 'Продажи касс'               :: TVarChar AS ItemName
            , tmpData.Amount               :: TFloat   AS Amount
            , tmpData.Amount2              :: TFloat   AS Amount2
            , tmpData.Amount3              :: TFloat   AS Amount3

            , tmpData.Amount4              :: TFloat   AS Amount4
            , tmpData.TotalAmount          :: TFloat   AS TotalAmount
            , tmpGoodsParam.Code                       AS Code
            , tmpGoodsParam.Name                       AS Name
            , tmpGoodsParam.NDSKindName                AS NDSKindName
            , tmpGoodsParam.NDS                        AS NDS
            , Movement.OperDate                        AS OperDate
            , Movement.InvNumber                       AS InvNumber
            , Movement.StatusName                      AS StatusName
            , tmpUnitParam.UnitID                      AS UnitID
            , tmpUnitParam.UnitName                    AS UnitName
            , tmpUnitParam.MainJuridicalId             AS MainJuridicalId
            , tmpUnitParam.MainJuridicalName           AS MainJuridicalName
            , Object_From.Id                           AS JuridicalId
            , Object_From.ValueData                    AS JuridicalName
            , tmpUnitParam.RetailName                  AS RetailName 
            , CASE WHEN tmpData.TotalAmount <> 0 THEN tmpData.Summa / tmpData.TotalAmount ELSE 0 END        :: TFloat AS Price
            , CASE WHEN tmpData.TotalAmount <> 0 THEN tmpData.SummaWithVAT / tmpData.TotalAmount ELSE 0 END :: TFloat AS PriceWithVAT
            , CASE WHEN tmpData.TotalAmount <> 0 THEN tmpData.SummaSale    / tmpData.TotalAmount ELSE 0 END :: TFloat AS PriceSale
            , tmpData.PriceSIP

            , tmpData.Summa        :: TFloat
            , tmpData.SummaWithVAT :: TFloat
            , tmpData.SummaSale    :: TFloat
            , Round(tmpData.TotalAmount * tmpData.PriceSIP, 2) ::TFloat  AS SummSIP

            , MovementString_Comment.ValueData  :: TVarChar AS Comment

            , tmpData.PartionGoods
            , tmpData.ExpirationDate
           
            , MovementDate_Insert.ValueData                 AS InsertDate

            , tmpData.isChecked    :: Boolean
            , tmpData.isReport     :: Boolean
            , CASE WHEN COALESCE(MakerReport.JuridicalId, 0) = 0 THEN True ELSE False END  AS isSendMaker  
            , Object_GoodsGroupPromo.ValueData       AS GoodsGroupPromoName
            , Movement.UserNameInsert

     FROM tmpData 
        LEFT JOIN tmpMovement AS Movement ON Movement.Id = tmpData.MovementId_Check
        LEFT JOIN tmpUnitParam ON tmpUnitParam.UnitId = tmpData.UnitId
    
        LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.JuridicalId_Income

        LEFT JOIN tmpMovementString AS MovementString_Comment
                                    ON MovementString_Comment.DescId = zc_MovementString_Comment()
                                   AND MovementString_Comment.MovementId = tmpData.MovementId_Check
                   
        LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                  ON MovementDate_Insert.MovementId = tmpData.MovementId_Check
                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        
        LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpData.GoodsId

        LEFT JOIN (SELECT DISTINCT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                       FROM Object AS Object_MakerReport
   
                            LEFT JOIN ObjectLink AS ObjectLink_Maker 
                                ON ObjectLink_Maker.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Maker.DescId = zc_ObjectLink_MakerReport_Maker()

                            INNER JOIN ObjectLink AS ObjectLink_Juridical 
                                ON ObjectLink_Juridical.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Juridical.DescId = zc_ObjectLink_MakerReport_Juridical()

                       WHERE Object_MakerReport.DescId = zc_Object_MakerReport()
                         AND COALESCE (ObjectLink_Maker.ChildObjectid, inMakerId) = inMakerId
                         AND Object_MakerReport.isErased = False) AS MakerReport
                                                                  ON MakerReport.JuridicalId = tmpData.JuridicalId_Income
                                                                  
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo 
                             ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = tmpData.GoodsId
                            AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()
        LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = ObjectLink_Goods_GoodsGroupPromo.ChildObjectId
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В. 
 18.04.19                                                      *
 01.02.19                                                      *
 27.01.19                                                      *
 24.01.19                                                      *
 17.01.19                                                      *
 12.11.18         *
 22.10.18         *
 07.01.18         *
 23.03.17         *
 09.01.17         * на проводках
 23.11.16         *
 08.11.16         *
*/

-- тест
--select * from gpReport_MovementCheck_Promo(inMakerId := 2336655 , inStartDate := ('01.11.2016')::TDateTime , inEndDate := ('30.11.2016')::TDateTime ,  inSession := '3');
-- select * from gpReport_MovementCheck_Promo(2336605 , '01.01.2019', '31.01.2019', '3') 


select * from gpReport_MovementCheck_Promo(inMakerId := 8341223 , inStartDate := ('01.01.2021')::TDateTime , inEndDate := ('31.01.2021')::TDateTime ,  inSession := '3');

