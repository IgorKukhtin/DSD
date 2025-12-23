-- Function: spGet_Period_byWeekNumber()

DROP FUNCTION IF EXISTS spGet_Period_byWeekNumber (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION spGet_Period_byWeekNumber(
    IN inWeekNumber1       Integer , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (WeekNumber2 Integer
             , StartDate_WeekNumber TDateTime, EndDate_WeekNumber TDateTime
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY

     SELECT inWeekNumber1                                                 :: Integer AS WeekNumber2
          , zfCalc_Week_StartDate (CURRENT_DATE, inWeekNumber1 :: TFloat)            AS StartDate_WeekNumber
          , zfCalc_Week_EndDate   (CURRENT_DATE, inWeekNumber1 :: TFloat)            AS EndDate_WeekNumber

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.                                     
 20.11.25         *
*/

-- тест
-- SELECT * FROM spGet_Period_byWeekNumber (inWeekNumber1:= 1, inSession:= '2')
