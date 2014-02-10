-- Function: zfCalc_RateFuelValue

DROP FUNCTION IF EXISTS zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DetermentPaymentDate(
    IN inContractConditionId Integer   , -- Тип отсрочки
    IN inDayCount            Integer   , -- Дней отсрочки
    IN inDate                TDateTime   -- Дата от которой надо посчитать начало действия отсрочки
)
RETURNS TDateTime AS
$BODY$
BEGIN

     CASE inContractConditionId
         WHEN 0 THEN Return(inDate);
         WHEN zc_Enum_ContractConditionKind_DelayDayCalendar() THEN RETURN(inDate::Date - inDayCount);
         WHEN zc_Enum_ContractConditionKind_DelayDayBank() THEN 
              BEGIN
                RETURN(SELECT 
                   MIN(CalendarDate)
                FROM
                  (SELECT ObjectDate_Value.valuedata AS CalendarDate
                     FROM ObjectDate AS ObjectDate_Value
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Working 
                       ON ObjectBoolean_Working.ObjectId = ObjectDate_Value.ObjectId 
                      AND ObjectBoolean_Working.DescId = zc_ObjectBoolean_Calendar_Working()
                    WHERE ObjectDate_Value.DescId = zc_ObjectDate_Calendar_Value()
                      AND ObjectDate_Value.valuedata < inDate 
                      AND ObjectBoolean_Working.ValueData = true
                 ORDER BY CalendarDate DESC
                 LIMIT inDayCount) AS Result);                                       	
              END;
     END CASE;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.14                        * 
*/
/*
-- тест
SELECT * FROM zfCalc_DetermentPaymentDate (zc_Enum_ContractConditionKind_DelayDayCalendar(), 7, current_date);
SELECT * FROM zfCalc_DetermentPaymentDate (zc_Enum_ContractConditionKind_DelayDayBank(), 7, current_date);
*/