-- Function: InsertPrimeCostTestData()

-- DROP FUNCTION InsertPrimeCostTestData();

CREATE OR REPLACE FUNCTION InsertPrimeCostTestData()
RETURNS TABLE (PrimeCostId Integer, InfoMoneyId Integer, Summ TFloat)
AS
$BODY$DECLARE
BEGIN
  -- tmp таблички
  CREATE TEMP TABLE _tmpMasterPrimeCostAmount (PrimeCostId Integer, RemainsAmount TFloat, IncomeAmount TFloat, CalcAmount TFloat) ON COMMIT DROP;
  CREATE TEMP TABLE _tmpMasterPrimeCostSumm   (PrimeCostId Integer, InfoMoneyId Integer, RemainsSumm TFloat, IncomeSumm TFloat, CalcSumm TFloat) ON COMMIT DROP;
  CREATE TEMP TABLE _tmpDetailPrimeCost (ParentPrimeCostId Integer, PrimeCostId Integer, Amount TFloat) ON COMMIT DROP;

  INSERT INTO _tmpMasterPrimeCostAmount (PrimeCostId, RemainsAmount, IncomeAmount, CalcAmount)
       SELECT 1, 10, 20,  0
 UNION SELECT 2, 20, 30,  0
 UNION SELECT 3,  0,  0, 20
 UNION SELECT 4,  4,  0, 13
 UNION SELECT 5,  5,  0, 15;

  INSERT INTO _tmpMasterPrimeCostSumm (PrimeCostId, InfoMoneyId, RemainsSumm, IncomeSumm, CalcSumm)
       SELECT 1, 1, 100,  180, 0
 UNION SELECT 2, 1, 100,  240, 0
 UNION SELECT 3, 1,   0,    0, 0
 UNION SELECT 4, 1,  14,    0, 0
 UNION SELECT 5, 1,  20,    0, 0;

  INSERT INTO _tmpDetailPrimeCost (ParentPrimeCostId, PrimeCostId, Amount)
       SELECT 3, 1,  5
 UNION SELECT 3, 2,  7
 UNION SELECT 3, 5,  2
 UNION SELECT 4, 3, 10
 UNION SELECT 5, 1,  4
 UNION SELECT 5, 2,  6
 UNION SELECT 5, 3,  2
 UNION SELECT 5, 4,  1;

  -- здесь собственно процедура расчета с\с

  RETURN QUERY 
  SELECT _tmpMasterPrimeCostSumm.PrimeCostId, 
         _tmpMasterPrimeCostSumm.InfoMoneyId, 
         cast(RemainsSumm + IncomeSumm + CalcSumm as TFloat) AS Summ 
  FROM _tmpMasterPrimeCostSumm;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION InsertPrimeCostTestData()
  OWNER TO postgres;
