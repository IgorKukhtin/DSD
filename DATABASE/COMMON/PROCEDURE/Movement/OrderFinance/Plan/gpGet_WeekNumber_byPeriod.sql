-- Function: gpGet_WeekNumber_byPeriod()

DROP FUNCTION IF EXISTS gpGet_WeekNumber_byPeriod (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_WeekNumber_byPeriod(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
--   OUT outWeekNumber1      TFloat    ,
--   OUT outWeekNumber2      TFloat    ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (WeekNumber1 Integer
             , WeekNumber2 Integer
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY

     SELECT EXTRACT (Week FROM inStartDate)   :: Integer   AS WeekNumber1
          , EXTRACT (Week FROM inEndDate)     :: Integer   AS WeekNumber2
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
-- SELECT * FROM gpGet_WeekNumber_byPeriod (inStartDate:= '02.11.2025', inEndDate:= '30.11.2025', inSession:= '2')
