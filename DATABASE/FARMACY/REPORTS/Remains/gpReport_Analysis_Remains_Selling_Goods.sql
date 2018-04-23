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
      AnalysisRemainsUnit.GoodsId         AS GoodsId,
      AnalysisRemainsUnit.GoodsName       AS GoodsName
   FROM AnalysisRemainsUnit
     LEFT OUTER JOIN
       (SELECT
          AnalysisSellingDeyUnit.UnitId,
          AnalysisSellingDeyUnit.GoodsId,
          AnalysisSellingDeyUnit.PromoID,
          AnalysisSellingDeyUnit.JuridicalID,
          Sum(AnalysisSellingDeyUnit.Saldo) as Saldo
        FROM AnalysisSellingDeyUnit
        WHERE AnalysisSellingDeyUnit.OperDate > inEndDate and
            AnalysisSellingDeyUnit.Saldo <> 0
        GROUP BY AnalysisSellingDeyUnit.UnitId, AnalysisSellingDeyUnit.GoodsId,
          AnalysisSellingDeyUnit.PromoID, AnalysisSellingDeyUnit.JuridicalID)
        AS AnalysisSellingDeyUnitIn
        ON AnalysisRemainsUnit.UnitId = AnalysisSellingDeyUnitIn.UnitId AND
           AnalysisRemainsUnit.GoodsId = AnalysisSellingDeyUnitIn.GoodsId AND
           COALESCE(AnalysisRemainsUnit.PromoID, '') = COALESCE(AnalysisSellingDeyUnitIn.PromoId, '') AND
           AnalysisRemainsUnit.JuridicalID = AnalysisSellingDeyUnitIn.JuridicalID
     LEFT OUTER JOIN
       (SELECT
          AnalysisSellingDeyUnit.UnitId,
          AnalysisSellingDeyUnit.GoodsId,
          AnalysisSellingDeyUnit.PromoID,
          AnalysisSellingDeyUnit.JuridicalID,
          Sum(-AnalysisSellingDeyUnit.Amount) as Amount
       FROM AnalysisSellingDeyUnit
       WHERE AnalysisSellingDeyUnit.OperDate >= inStartDate AND
          AnalysisSellingDeyUnit.OperDate <= inEndDate AND
          AnalysisSellingDeyUnit.Amount <> 0
       GROUP BY AnalysisSellingDeyUnit.UnitId, AnalysisSellingDeyUnit.GoodsId,
          AnalysisSellingDeyUnit.PromoID, AnalysisSellingDeyUnit.JuridicalID)
       AS AnalysisSellingDeyUnitAmmount
       ON AnalysisRemainsUnit.UnitId = AnalysisSellingDeyUnitAmmount.UnitId AND
          AnalysisRemainsUnit.GoodsId = AnalysisSellingDeyUnitAmmount.GoodsId AND
          COALESCE(AnalysisRemainsUnit.PromoID, '') = COALESCE(AnalysisSellingDeyUnitIn.PromoId, '') AND
          AnalysisRemainsUnit.JuridicalID = AnalysisSellingDeyUnitIn.JuridicalID
    WHERE ((AnalysisRemainsUnit.Saldo - COALESCE(AnalysisSellingDeyUnitIn.Saldo, 0)) <> 0 OR
           COALESCE(AnalysisSellingDeyUnitAmmount.Amount, 0) <> 0);
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.04.18        *                                                                         *

*/

-- тест
-- select * from gpReport_Analysis_Remains_Selling_Goods ('2017-09-01'::TDateTime, '2017-09-30'::TDateTime, '3')
