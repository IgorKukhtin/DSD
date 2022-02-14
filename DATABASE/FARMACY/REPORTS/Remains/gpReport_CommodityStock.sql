-- Function:  gpReport_CommodityStock

DROP FUNCTION IF EXISTS gpReport_CommodityStock (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CommodityStock (
  inSession TVarChar
)
RETURNS TABLE (GoodsId integer, GoodsCode integer, GoodsName TVarChar
             , Sale TFloat, Saldo TFloat, Summa TFloat, AmountUnit integer, AmountUnitSaldo integer
             , SaleDay TFloat,  CommodityStock TFloat
             , Sale90 TFloat, AmountUnit90 integer, SaleDay90 TFloat, CommodityStock90 TFloat
             , CommodityStockDelta TFloat, SummaNot90 TFloat
             , isPromo Boolean, MakerName TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY
   WITH tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                         , Object_Juridical.Id                AS JuridicalId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical

                       INNER JOIN Object AS Object_Juridical
                                         ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                        AND Object_Juridical.isErased = False

                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053
                    )
      , tmpContainer AS (SELECT AnalysisContainer.GoodsId
                              , 0::TFloat                    AS Sale   
                              , Sum(AnalysisContainer.Saldo) AS Saldo
                              , 0                            AS AmountUnit
                              , COUNT(DISTINCT AnalysisContainer.UnitId)::Integer AS AmountUnitSaldo
                              , Sum(AnalysisContainer.Saldo * AnalysisContainer.Price) AS Summa
                         FROM AnalysisContainer
                         WHERE AnalysisContainer.Saldo <> 0 AND AnalysisContainer.UnitID in (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                         GROUP BY AnalysisContainer.GoodsId
                         UNION ALL
                         SELECT AnalysisContainerItem.GoodsId                         AS GoodsId
                              , Sum(AnalysisContainerItem.AmountCheck)                AS Sale
                              , 0::TFloat                                             AS Saldo
                              , COUNT(DISTINCT AnalysisContainerItem.UnitId)::Integer AS AmountUnit
                              , 0                                                     AS AmountUnitSaldo
                              , 0::TFloat                                             AS Summa
                         FROM AnalysisContainerItem AS AnalysisContainerItem
                         WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - INTERVAL '180 DAY'
                           AND AnalysisContainerItem.UnitID in (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                           AND AnalysisContainerItem.AmountCheck > 0
                          GROUP BY AnalysisContainerItem.GoodsId)
      , tmpSale90 AS (SELECT AnalysisContainerItem.GoodsId                         AS GoodsId
                           , Sum(AnalysisContainerItem.AmountCheck)::TFloat        AS Sale
                           , COUNT(DISTINCT AnalysisContainerItem.UnitId)::Integer AS AmountUnit
                      FROM AnalysisContainerItem AS AnalysisContainerItem
                           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = AnalysisContainerItem.GoodsId
                                                         AND Object_Goods_Retail.Retailid = 4
                      WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - INTERVAL '90 DAY'
                        AND AnalysisContainerItem.UnitID in (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                        AND AnalysisContainerItem.AmountCheck > 0
                      GROUP BY AnalysisContainerItem.GoodsId)
      , tmpRemains AS (SELECT tmpContainer.GoodsId
                            , Sum(tmpContainer.Sale)::TFloat              AS Sale
                            , Sum(tmpContainer.Summa)::TFloat             AS Summa
                            , Sum(tmpContainer.Saldo)::TFloat             AS Saldo
                            , Max(COALESCE(tmpContainer.AmountUnit, 0))::Integer       AS AmountUnit
                            , Max(COALESCE(tmpContainer.AmountUnitSaldo, 0))::Integer  AS AmountUnitSaldo
                       FROM tmpContainer
                       GROUP BY tmpContainer.GoodsId
                       HAVING Sum(tmpContainer.Sale) <> 0 OR Sum(tmpContainer.Saldo) <> 0)
      , GoodsPromo AS (SELECT tmp.GoodsId   -- здесь товар "сети"
                            , Max(tmp.MakerId)       AS MakerId
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp
                       GROUP BY tmp.GoodsId
                      )

                          
   SELECT tmpRemains.GoodsId
        , Object_Goods_Main.ObjectCode
        , Object_Goods_Main.Name
        , tmpRemains.Sale
        , tmpRemains.Saldo
        , tmpRemains.Summa
        , tmpRemains.AmountUnit
        , tmpRemains.AmountUnitSaldo
        , CASE WHEN tmpRemains.AmountUnit <> 0 
               THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
               ELSE 0 END::TFloat                                     AS SaleDay
        , ROUND(CASE WHEN CASE WHEN tmpRemains.AmountUnit <> 0 
                               THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                               ELSE 0 END <> 0 AND tmpRemains.AmountUnitSaldo <> 0
                     THEN tmpRemains.Saldo / CASE WHEN tmpRemains.AmountUnit <> 0 
                                                  THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                                                  ELSE 0 END / tmpRemains.AmountUnitSaldo
                     ELSE 0 END)::TFloat

        , tmpSale90.Sale
        , tmpSale90.AmountUnit
        , CASE WHEN tmpSale90.AmountUnit <> 0 
               THEN tmpSale90.Sale / tmpSale90.AmountUnit / 180
               ELSE 0 END::TFloat                                     AS SaleDay90
        , ROUND(CASE WHEN CASE WHEN tmpSale90.AmountUnit <> 0 
                               THEN tmpSale90.Sale / tmpSale90.AmountUnit / 180
                               ELSE 0 END <> 0 AND tmpRemains.AmountUnitSaldo <> 0
                     THEN tmpRemains.Saldo / CASE WHEN tmpSale90.AmountUnit <> 0 
                                                  THEN tmpSale90.Sale / tmpSale90.AmountUnit / 180
                                                  ELSE 0 END / tmpRemains.AmountUnitSaldo
                     ELSE 0 END)::TFloat

        , /*CASE WHEN ROUND(CASE WHEN CASE WHEN tmpRemains.AmountUnit <> 0 
                               THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                               ELSE 0 END <> 0 AND tmpRemains.AmountUnitSaldo <> 0
                     THEN tmpRemains.Saldo / CASE WHEN tmpRemains.AmountUnit <> 0 
                                                  THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                                                  ELSE 0 END / tmpRemains.AmountUnitSaldo
                     ELSE 0 END - 
                 CASE WHEN CASE WHEN tmpSale90.AmountUnit <> 0 
                               THEN tmpSale90.Sale / tmpSale90.AmountUnit / 180
                               ELSE 0 END <> 0 AND tmpRemains.AmountUnitSaldo <> 0
                     THEN tmpRemains.Saldo / CASE WHEN tmpSale90.AmountUnit <> 0 
                                                  THEN tmpSale90.Sale / tmpSale90.AmountUnit / 180
                                                  ELSE 0 END / tmpRemains.AmountUnitSaldo
                     ELSE 0 END)> 0
                THEN*/ ROUND(CASE WHEN CASE WHEN tmpRemains.AmountUnit <> 0 
                               THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                               ELSE 0 END <> 0 AND tmpRemains.AmountUnitSaldo <> 0
                     THEN tmpRemains.Saldo / CASE WHEN tmpRemains.AmountUnit <> 0 
                                                  THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                                                  ELSE 0 END / tmpRemains.AmountUnitSaldo
                     ELSE 0 END - 
                 CASE WHEN CASE WHEN tmpSale90.AmountUnit <> 0 
                               THEN tmpSale90.Sale / tmpSale90.AmountUnit / 180
                               ELSE 0 END <> 0 AND tmpRemains.AmountUnitSaldo <> 0
                     THEN tmpRemains.Saldo / CASE WHEN tmpSale90.AmountUnit <> 0 
                                                  THEN tmpSale90.Sale / tmpSale90.AmountUnit / 180
                                                  ELSE 0 END / tmpRemains.AmountUnitSaldo
                     ELSE 0 END)/* END*/ ::TFloat
        , CASE WHEN tmpRemains.Saldo > 0 
               THEN ROUND(/*CASE WHEN tmpRemains.Saldo - tmpSale90.Sale > 0 THEN*/ (tmpRemains.Saldo - tmpSale90.Sale) /*ELSE 0 END*/ *
                          tmpRemains.Summa / tmpRemains.Saldo, 2)
               ELSE 0 END::TFloat
        , COALESCE (GoodsPromo.GoodsId, 0) <> 0
        , Object_Maker.ValueData
   FROM tmpRemains
   
        LEFT JOIN tmpSale90 ON tmpSale90.GoodsId = tmpRemains.GoodsId
   
        INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpRemains.GoodsId
                                      AND Object_Goods_Retail.Retailid = 4
                                      
        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
        
        LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpRemains.GoodsId
        LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = GoodsPromo.MakerId
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий 0.В.
 14.02.22                                                     *

*/

-- тест
-- 
select * from gpReport_CommodityStock ('3'); -- where GoodsId = 2408