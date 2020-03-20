-- Function: gpSelect_Calculation_MoneyBoxSun()

DROP FUNCTION IF EXISTS gpSelect_Calculation_MoneyBoxSun (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_MoneyBoxSun(
    IN inUnitID      Integer,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

 PERFORM lpInsertUpdate_MovementItem_WagesMoneyBoxSun(date_trunc('month', CURRENT_DATE), T1.UnitID, COALESCE(T1.Summa, 0), vbUserId)
 FROM (
   WITH
            -- ������� ��������
       tmpSUNSaleDates AS (SELECT UnitId
                                , ROUND(SUM(COALESCE(SUNSaleDates.Summa, 0) - COALESCE(SUNSaleDates.SummaSendTheir, 0) - COALESCE(SUNSaleDates.SummaSend, 0)) * 0.1, 2) AS Summa
                           FROM gpReport_SUNSaleDates(inStartDate := CASE WHEN  date_trunc('month', CURRENT_DATE) >= ('01.04.2020')::TDateTime
                                                                          THEN date_trunc('month', date_trunc('month', CURRENT_DATE) - INTERVAL '1 DAY')
                                                                          ELSE ('01.06.2019')::TDateTime END,
                                                      inEndDate := date_trunc('month', CURRENT_DATE) - INTERVAL '1 DAY',
                                                      inUnitId := inUnitID,
                                                      inSession := inSession) AS SUNSaleDates
                           GROUP BY SUNSaleDates.UnitId)
     , tmpMoneyBoxSun AS (SELECT *
                          FROM ObjectFloat
                          WHERE ObjectFloat.DescId = zc_ObjectFloat_Unit_MoneyBoxSun()
                            AND (ObjectFloat.ObjectId = inUnitID OR inUnitID = 0))
     , tmpUnit  AS (SELECT tmpSUNSaleDates.UnitId FROM tmpSUNSaleDates
                    UNION ALL
                    SELECT tmpMoneyBoxSun.ObjectId FROM tmpMoneyBoxSun)

     SELECT Unit.UnitId, tmpSUNSaleDates.Summa
     FROM (SELECT tmpUnit.UnitId FROM tmpUnit) AS Unit

          LEFT JOIN tmpSUNSaleDates ON tmpSUNSaleDates.UnitId = Unit.UnitId

          LEFT JOIN tmpMoneyBoxSun ON tmpMoneyBoxSun.ObjectId = Unit.UnitId) AS T1
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_MoneyBoxSun (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.03.20                                                        *
*/

-- SELECT * FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_Unit_MoneyBoxSun()
-- select * from gpSelect_Calculation_MoneyBoxSun(183292, '3');
-- select * from gpSelect_Calculation_MoneyBoxSun(0, '3');