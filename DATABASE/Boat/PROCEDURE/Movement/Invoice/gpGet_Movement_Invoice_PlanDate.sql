-- Function: gpGet_Movement_Invoice_PlanDate()

DROP FUNCTION IF EXISTS gpGet_Movement_Invoice_PlanDate(TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Invoice_PlanDate(TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Invoice_PlanDate(
    IN inOperDate              TDateTime ,
   OUT outPlanDate             TDateTime ,
    IN inObjectId              Integer   ,
    IN inSession               TVarChar       -- сессия пользователя
)
RETURNS TDateTime
AS
$BODY$
  DECLARE vbDayCalendar TFloat;
BEGIN
  
   vbDayCalendar := (SELECT ObjectFloat_DayCalendar.ValueData
                     FROM ObjectFloat AS ObjectFloat_DayCalendar
                     WHERE ObjectFloat_DayCalendar.ObjectId = inObjectId
                       AND ObjectFloat_DayCalendar.DescId IN (zc_ObjectFloat_Partner_DayCalendar(),zc_ObjectFloat_Client_DayCalendar())
                    );
                      
   outPlanDate := inOperDate + (vbDayCalendar||' DAY') ::INTERVAL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Invoice_PlanDate('01.02.2021' ::TDateTime, 3 ::Integer , '5'::TVarChar)