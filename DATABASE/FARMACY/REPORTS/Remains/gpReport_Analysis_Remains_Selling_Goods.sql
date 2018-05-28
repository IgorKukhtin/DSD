-- Function:  gpReport_Analysis_Remains_Selling_Goods

DROP FUNCTION IF EXISTS gpReport_Analysis_Remains_Selling_Goods (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Analysis_Remains_Selling_Goods (
  inStartDate TDateTime,
  inEndDate TDateTime,
  inSession TVarChar
)
RETURNS TABLE (
  GoodsId integer,
  GoodsName TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- для остальных...
   RETURN QUERY
    SELECT DISTINCT
           Object_Goods.ObjectCode       AS GoodsId
         , Object_Goods.ValueData        AS GoodsName
    FROM
     (SELECT 
        AnalysisContainer.GoodsId
      FROM (SELECT
           AnalysisContainer.UnitId, 
           AnalysisContainer.GoodsId,
           Sum(AnalysisContainer.Saldo) AS Saldo
         FROM AnalysisContainer
         GROUP BY AnalysisContainer.UnitId, AnalysisContainer.GoodsId) AS AnalysisContainer

         LEFT OUTER JOIN
         (SELECT AnalysisContainerItem.UnitID                                               AS UnitID
               , AnalysisContainerItem.GoodsId                                              AS GoodsId
               , Sum(CASE WHEN AnalysisContainerItem.OperDate <= inEndDate THEN 
                    AnalysisContainerItem.AmountCheck END)                                  AS Amount
               , Sum(CASE WHEN AnalysisContainerItem.OperDate > inEndDate THEN 
                   AnalysisContainerItem.Saldo END)                                         AS Saldo
          FROM AnalysisContainerItem AS AnalysisContainerItem
          WHERE AnalysisContainerItem.OperDate >= inStartDate
          GROUP BY AnalysisContainerItem.UnitID
                 , AnalysisContainerItem.GoodsId) AS AnalysisContainerItem
          ON AnalysisContainer.UnitId = AnalysisContainerItem.UnitId AND
             AnalysisContainer.GoodsId = AnalysisContainerItem.GoodsId

      WHERE ((AnalysisContainer.Saldo - COALESCE(AnalysisContainerItem.Saldo, 0)) <> 0 OR
             COALESCE(AnalysisContainerItem.Amount, 0) <> 0)) AS T1

         INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = T1.GoodsId
      ORDER BY Object_Goods.ValueData;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.04.18        *                                                                         *

*/

-- тест
-- select * from gpReport_Analysis_Remains_Selling_Goods ('2018-04-01'::TDateTime, '2018-04-30'::TDateTime, '3') where GoodsId = 2408
