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
   
 vbOperDate := date_trunc('month', CURRENT_DATE) - INTERVAL '1 DAY';

 PERFORM lpInsertUpdate_MovementItem_WagesMoneyBoxSun(date_trunc('month', vbOperDate), T1.UnitID, COALESCE(T1.Summa, 0), vbUserId)
 FROM (
   WITH
            -- Текущее значение
       tmpSUNSaleDates AS (SELECT UnitId
                                , ROUND(SUM(COALESCE(SUNSaleDates.Summa, 0) - COALESCE(SUNSaleDates.SummaSendTheir, 0) - COALESCE(SUNSaleDates.SummaSend, 0)) * 0.1, 2) AS Summa
                           FROM gpReport_SUNSaleDates(inStartDate := CASE WHEN date_trunc('month', vbOperDate) = ('01.03.2020')::TDateTime THEN ('01.06.2019')::TDateTime 
                                                                          ELSE date_trunc('month', vbOperDate) END,
                                                      inEndDate := vbOperDate,
                                                      inUnitId := inUnitID,
                                                      inSession := inSession) AS SUNSaleDates
                           GROUP BY SUNSaleDates.UnitId)
     , tmpMoneyBoxCur AS (SELECT MovementItem.ObjectId                                AS UnitID
                               , COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0)    AS MoneyBoxMonth
                          FROM  Movement
                          
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Sign()


                                INNER JOIN MovementItemFloat AS MIFloat_SummaMoneyBoxMonth
                                                            ON MIFloat_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()

                          WHERE Movement.DescId = zc_Movement_Wages()
                            AND Movement.OperDate = date_trunc('month', vbOperDate))
     , tmpUnit  AS (SELECT tmpSUNSaleDates.UnitId FROM tmpSUNSaleDates
                    UNION ALL
                    SELECT tmpMoneyBoxCur.UnitId FROM tmpMoneyBoxCur)

     SELECT Unit.UnitId, tmpSUNSaleDates.Summa
     FROM (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit) AS Unit

          LEFT JOIN tmpSUNSaleDates ON tmpSUNSaleDates.UnitId = Unit.UnitId

          LEFT JOIN tmpMoneyBoxCur ON tmpMoneyBoxCur.UnitId = Unit.UnitId
     WHERE COALESCE(tmpSUNSaleDates.Summa, 0) <> COALESCE(tmpMoneyBoxCur.MoneyBoxMonth, 0)) AS T1
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
-- select * from gpSelect_Calculation_MoneyBoxSun(472116 , '3');
-- select * from gpSelect_Calculation_MoneyBoxSun(0, '3');
