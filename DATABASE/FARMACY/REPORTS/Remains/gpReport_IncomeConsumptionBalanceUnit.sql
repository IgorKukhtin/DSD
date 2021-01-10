-- Function: gpReport_IncomeConsumptionBalanceUnit()

DROP FUNCTION IF EXISTS gpReport_IncomeConsumptionBalanceUnit (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeConsumptionBalanceUnit(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (UnitId Integer
              )
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());


  RETURN QUERY
  SELECT DISTINCT AnalysisContainer.UnitID                                                      AS UnitID
  FROM AnalysisContainer AS AnalysisContainer
  ORDER BY AnalysisContainer.UnitID ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
             ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 07.01.20                                                      *
*/

-- ����
--
-- 
select * from gpReport_IncomeConsumptionBalanceUnit(inSession := '3');