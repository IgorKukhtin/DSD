-- Function: zfcalc_determentpaymentdate (integer, integer, tdatetime)

DROP FUNCTION IF EXISTS zfcalc_determentpaymentdate (integer, integer, tdatetime);

-- DROP FUNCTION zfcalc_determentpaymentdate(integer, integer, tdatetime);

CREATE OR REPLACE FUNCTION zfcalc_determentpaymentdate (incontractconditionid integer, indaycount integer, indate tdatetime)
  RETURNS tdatetime AS
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
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION zfcalc_determentpaymentdate(integer, integer, tdatetime)  OWNER TO postgres;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 31.03.15                         * 
*/

-- òåñò
-- SELECT * FROM gpUpdate_IsMedoc (ioId:= 0, inSession:= '2')
