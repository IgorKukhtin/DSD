-- Function: lpReport_MovementCheck_PromoLight()

DROP FUNCTION IF EXISTS lpReport_MovementCheck_PromoLight (Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpReport_MovementCheck_PromoLight(
    IN inMakerId       Integer     -- Производитель
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inUserId        Integer    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer      --ИД Документа
             , OperDate TDateTime      --Дата документа
             , InvNumber TVarChar      --№ документа
             , UnitId Integer
             , GoodsId Integer         --Код товара

             , TotalAmount TFloat      --итого продажа шт
               
             , Summa TFloat
             , SummaWithVAT TFloat
             , SummaSale TFloat
             , SummSIP TFloat          --Сумма СИП
              )
AS
$BODY$
BEGIN
    
    RETURN QUERY
      WITH
          -- Id строк Маркетинговых контрактов inMakerId
          tmpGoodsPromo AS (SELECT DISTINCT
                                   MI_Goods.ObjectId  AS GoodsId        -- здесь товар
                                 , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                 , MovementDate_EndPromo.ValueData    AS EndDate_Promo 
                                 , MIFloat_Price.ValueData            AS Price
                            FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                            ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                           AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                           AND (MovementLinkObject_Maker.ObjectId = inMakerId OR inMakerId = 0)
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

                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_Promo()
                       )
        -- товары промо
   ,  tmpGoods_All AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                            , tmpGoodsPromo.StartDate_Promo
                            , tmpGoodsPromo.EndDate_Promo 
                            , tmpGoodsPromo.Price               AS PriceSIP
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
                              FROM tmpGoods_All
                              WHERE tmpGoods_All.StartDate_Promo <= inEndDate
                                AND tmpGoods_All.EndDate_Promo >= inStartDate
                              )

     -- выбираем все чеки с товарами маркетингового контракта
   ,   tmpMIContainer AS (SELECT MIContainer.MovementId                         AS MovementId_Check
                              , COALESCE (MIContainer.AnalyzerId,0)             AS MovementItemId_Income
                              , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                              , MIContainer.ObjectId_analyzer                   AS GoodsId
                              , tmpListGodsMarket.PriceSIP 

                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                              
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
                           --AND COALESCE (inMakerId, 0) <> 0
                         GROUP BY MIContainer.MovementId
                                , COALESCE (MIContainer.WhereObjectId_analyzer,0)
                                , COALESCE (MIContainer.AnalyzerId,0)
                                , MIContainer.ObjectId_analyzer 
                                , tmpListGodsMarket.PriceSIP
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                         )
  
       , tmpData_all AS (SELECT tmp.MovementId_Check
                              , tmp.UnitId 
                              , tmp.MovementItemId_Income
                              , tmp.GoodsId
                              , tmp.PriceSIP 
                              , tmp.TotalAmount
                              , tmp.SummaSale
                         FROM tmpMIContainer AS tmp
                         ) 
           -- 
       , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                  FROM MovementItemFloat
                                  WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId_Income FROM tmpData_all)
                                    AND MovementItemFloat.DescId IN (zc_MIFloat_JuridicalPrice(), zc_MIFloat_PriceWithVAT())
                                  )

       , tmpData AS (SELECT tmpData_all.MovementId_Check
                          , tmpData_all.UnitId
                          , tmpData_all.GoodsId
                          , tmpData_all.PriceSIP
                          , SUM (tmpData_all.TotalAmount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                          , SUM (tmpData_all.TotalAmount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                          , SUM (tmpData_all.SummaSale)   AS SummaSale
                          , SUM (tmpData_all.TotalAmount) AS TotalAmount
                     FROM tmpData_all
                          -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                          LEFT JOIN tmpMovementItemFloat AS MIFloat_JuridicalPrice
                                                         ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId_Income
                                                        AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                                        AND 1=0
                          -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                          LEFT JOIN tmpMovementItemFloat AS MIFloat_PriceWithVAT
                                                         ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId_Income
                                                        AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                                        AND 1=0

                     GROUP BY tmpData_all.MovementId_Check
                            , tmpData_all.GoodsId
                            , tmpData_all.UnitId
                            , tmpData_all.PriceSIP
                    )
      
       , tmpMovement AS (SELECT Movement.*
                         FROM Movement
                         WHERE Movement.Id IN (SELECT DISTINCT tmpData.MovementId_Check FROM tmpData )
                        )

      -- Результат
      SELECT tmpData.MovementId_Check                 AS MovementId
           , Movement.OperDate                        AS OperDate
           , Movement.InvNumber                       AS InvNumber
           , tmpData.UnitId                           AS UnitId
           , tmpData.GoodsId                          AS GoodsId

           , tmpData.TotalAmount          :: TFloat   AS TotalAmount

           , tmpData.Summa        :: TFloat
           , tmpData.SummaWithVAT :: TFloat
           , tmpData.SummaSale    :: TFloat
           , Round(tmpData.TotalAmount * tmpData.PriceSIP, 2) ::TFloat  AS SummSIP

     FROM tmpData 
        LEFT JOIN tmpMovement AS Movement ON Movement.Id = tmpData.MovementId_Check
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 07.08.19         *
*/

-- тест
-- select * from lpReport_MovementCheck_PromoLight(inMakerId := 2336655 , inStartDate := ('01.07.2019')::TDateTime , inEndDate := ('30.07.2019')::TDateTime ,  inUserId := 3);