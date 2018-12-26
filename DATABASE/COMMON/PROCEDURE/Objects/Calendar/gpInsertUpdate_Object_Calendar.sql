-- Function: lpInsertUpdate_Object_Calendar(Integer, Boolean, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Calendar(Integer, TDateTime, TDateTime, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Calendar( TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Calendar(
   -- IN inId                Integer   , -- ключ объекта <Календарь рабочих дней>
    IN inStartDate         TDateTime , -- Дата начала
    IN inEndDate           TDateTime , -- Дата окончания
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer AS   --void
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     PERFORM lpInsertUpdate_Object_Calendar (ioId        := 0
                                           , inisWorking := tmpCalendar.isWork
                                           , inisHoliday := tmpCalendar.isHoliday
                                           , inValue     := tmpCalendar.OperDate
                                           , inUserId    := inSession
                                           )
      -- 
     FROM (SELECT OperDate
                , CASE WHEN date_part ('isodow', OperDate) IN (6, 7) THEN FALSE ELSE TRUE END AS isWork
                , COALESCE (isHoliday, FALSE) AS isHoliday
           FROM  
                (SELECT generate_series (inStartDate, inEndDate, '1 day'::interval) AS OperDate
                 ) AS Period 
                 LEFT JOIN (SELECT Object_Calendar.Id                  AS Id
                                 , ObjectBoolean_Working.ValueData     AS isWorking  
                                 , ObjectBoolean_Holiday.ValueData     AS isHoliday
                                 , ObjectDate_Value.ValueData          AS Value
                                 , Object_Calendar.isErased AS isErased
                            FROM ObjectDate AS ObjectDate_Period
                                 LEFT JOIN ObjectDate AS ObjectDate_Value
                                                      ON ObjectDate_Value.ObjectId = ObjectDate_Period.ObjectId
                                                     AND ObjectDate_Value.DescId = zc_ObjectDate_Calendar_Value()
                                 LEFT JOIN Object AS Object_Calendar ON Object_Calendar.Id = ObjectDate_Value.ObjectId
         
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Working 
                                                         ON ObjectBoolean_Working.ObjectId = Object_Calendar.Id 
                                                        AND ObjectBoolean_Working.DescId = zc_ObjectBoolean_Calendar_Working()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Holiday 
                                                         ON ObjectBoolean_Holiday.ObjectId = Object_Calendar.Id 
                                                        AND ObjectBoolean_Holiday.DescId = zc_ObjectBoolean_Calendar_Holiday()
                            WHERE ObjectDate_Period.ValueData BETWEEN inStartDate AND inEndDate
                              AND Object_Calendar.DescId = zc_Object_Calendar()
                            ) AS Object_find ON Object_find.Value = Period.OperDate
           WHERE Object_find.Value IS NULL
           ) AS tmpCalendar
     ;   
   
   
   -- сохранили протокол
   return 0;
   --PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.18         *
 27.11.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Calendar ('12.11.2013', '12.12.2013', '2')