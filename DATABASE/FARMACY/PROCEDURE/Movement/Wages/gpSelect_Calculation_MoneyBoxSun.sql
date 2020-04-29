-- Function: gpSelect_Calculation_MoneyBoxSun()

DROP FUNCTION IF EXISTS gpSelect_Calculation_MoneyBoxSun (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_MoneyBoxSun(
    IN inUnitID      Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
   
 vbOperDate := date_trunc('month', CURRENT_DATE);

 PERFORM lpInsertUpdate_MovementItem_WagesMoneyBoxSun(vbOperDate, T1.UnitID, COALESCE(T1.Summa, 0), vbUserId)
 FROM (
   WITH
            -- Текущее значение
       tmpSUNSaleDates AS (SELECT UnitId
                                , ROUND(SUM(COALESCE(SUNSaleDates.Summa, 0) - COALESCE(SUNSaleDates.SummaSendTheir, 0) - COALESCE(SUNSaleDates.SummaSend, 0)) * 0.1, 2) AS Summa
                           FROM gpReport_SUNSaleDates(inStartDate := CASE WHEN  vbOperDate >= ('01.04.2020')::TDateTime
                                                                          THEN date_trunc('month', vbOperDate - INTERVAL '1 DAY')
                                                                          ELSE ('01.06.2019')::TDateTime END,
                                                      inEndDate := vbOperDate - INTERVAL '1 DAY',
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
     FROM (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit) AS Unit

          LEFT JOIN tmpSUNSaleDates ON tmpSUNSaleDates.UnitId = Unit.UnitId

          LEFT JOIN tmpMoneyBoxSun ON tmpMoneyBoxSun.ObjectId = Unit.UnitId) AS T1
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_MoneyBoxSun (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.03.20                                                        *
*/

-- SELECT * FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_Unit_MoneyBoxSun()
-- 
-- select * from gpSelect_Calculation_MoneyBoxSun(11769526 , '3');
-- select * from gpSelect_Calculation_MoneyBoxSun(0, '3');