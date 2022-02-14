-- Function:  gpReport_CommodityStock

DROP FUNCTION IF EXISTS gpReport_CommodityStock (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CommodityStock (
  inSession TVarChar
)
RETURNS TABLE (GoodsId integer, GoodsCode integer, GoodsName TVarChar
             , Sale TFloat, Saldo TFloat, AmountUnit integer, AmountUnitSaldo integer
             , SaleDay TFloat,  CommodityStock TFloat
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY
   WITH tmpContainer AS (SELECT AnalysisContainer.GoodsId
                              , 0::TFloat                    AS Sale   
                              , Sum(AnalysisContainer.Saldo) AS Saldo
                              , 0                            AS AmountUnit
                              , COUNT(DISTINCT AnalysisContainer.UnitId)::Integer AS AmountUnitSaldo
                         FROM AnalysisContainer
                              INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = AnalysisContainer.GoodsId
                                                            AND Object_Goods_Retail.Retailid = 4
                         WHERE AnalysisContainer.Saldo <> 0
                         GROUP BY AnalysisContainer.GoodsId
                         UNION ALL
                         SELECT AnalysisContainerItem.GoodsId                         AS GoodsId
                              , Sum(AnalysisContainerItem.AmountCheck)                AS Sale
                              , 0::TFloat                                             AS Saldo
                              , COUNT(DISTINCT AnalysisContainerItem.UnitId)::Integer AS AmountUnit
                              , 0                                                     AS AmountUnitSaldo
                         FROM AnalysisContainerItem AS AnalysisContainerItem
                              INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = AnalysisContainerItem.GoodsId
                                                            AND Object_Goods_Retail.Retailid = 4
                         WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - INTERVAL '180 DAY'
                           AND AnalysisContainerItem.AmountCheck > 0
                          GROUP BY AnalysisContainerItem.GoodsId)
      , tmpRemains AS (SELECT tmpContainer.GoodsId
                            , Sum(tmpContainer.Sale)::TFloat              AS Sale
                            , Sum(tmpContainer.Saldo)::TFloat             AS Saldo
                            , Max(COALESCE(tmpContainer.AmountUnit, 0))::Integer       AS AmountUnit
                            , Max(COALESCE(tmpContainer.AmountUnitSaldo, 0))::Integer  AS AmountUnitSaldo
                       FROM tmpContainer
                       GROUP BY tmpContainer.GoodsId
                       HAVING Sum(tmpContainer.Sale) <> 0 OR Sum(tmpContainer.Saldo) <> 0)
                          
   SELECT tmpRemains.GoodsId
        , Object_Goods_Main.ObjectCode
        , Object_Goods_Main.Name
        , tmpRemains.Sale
        , tmpRemains.Saldo
        , tmpRemains.AmountUnit
        , tmpRemains.AmountUnitSaldo
        , CASE WHEN tmpRemains.AmountUnit <> 0 
               THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
               ELSE 0 END::TFloat                                     AS SaleDay
        , CASE WHEN CASE WHEN tmpRemains.AmountUnit <> 0 
                         THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                         ELSE 0 END <> 0 AND tmpRemains.AmountUnitSaldo <> 0
               THEN tmpRemains.Saldo / CASE WHEN tmpRemains.AmountUnit <> 0 
                                            THEN tmpRemains.Sale / tmpRemains.AmountUnit / 180
                                            ELSE 0 END / tmpRemains.AmountUnitSaldo
               ELSE 0 END::TFloat
   FROM tmpRemains
   
        INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpRemains.GoodsId
                                      AND Object_Goods_Retail.Retailid = 4
                                      
        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
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