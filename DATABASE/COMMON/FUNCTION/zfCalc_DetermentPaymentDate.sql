-- Function: zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DetermentPaymentDate (inContractConditionId Integer, inDayCount Integer, inDate TDateTime)
RETURNS TDateTime
AS
$BODY$
BEGIN

     CASE inContractConditionId
         WHEN 0 THEN RETURN (inDate);
         WHEN zc_Enum_ContractConditionKind_DelayDayCalendar() THEN RETURN (inDate::Date - inDayCount);
         WHEN zc_Enum_ContractConditionKind_DelayDayBank()
              THEN
                RETURN (SELECT MIN (CalendarDate)
                        FROM (SELECT ObjectDate_Value.valuedata AS CalendarDate
                              FROM ObjectDate AS ObjectDate_Value
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Working
                                          ON ObjectBoolean_Working.ObjectId = ObjectDate_Value.ObjectId
                                         AND ObjectBoolean_Working.DescId   = zc_ObjectBoolean_Calendar_Working()
                              WHERE ObjectDate_Value.DescId    = zc_ObjectDate_Calendar_Value()
                                AND ObjectDate_Value.valuedata < inDate
                                AND ObjectBoolean_Working.ValueData = TRUE
                              ORDER BY CalendarDate DESC
                              LIMIT inDayCount
                             ) AS Result
                       );
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 31.03.15                         *
*/

-- òåñò
-- SELECT * FROM zfCalc_DetermentPaymentDate (inContractConditionId:= zc_Enum_ContractConditionKind_DelayDayBank(), inDayCount:= 10, inDate:= CURRENT_DATE)
