-- Function: gpSelect_Week_Date()

DROP FUNCTION IF EXISTS gpSelect_Week_Date (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Week_Date(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (WeekNumber TFloat
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
     WITH
     -- 
     tmpDataWeek AS (SELECT GENERATE_SERIES (inStartDate, inEndDate, '1 week' :: INTERVAL) AS OperDate)
     
     SELECT (EXTRACT (Week FROM tmp.OperDate) )                   :: TFloat   AS WeekNumber
          , DATE_TRUNC ('WEEK', tmp.OperDate)                     :: TDateTime AS StartDate_WeekNumber
          , (DATE_TRUNC ('WEEK', tmp.OperDate)+ INTERVAL '6 DAY') :: TDateTime AS EndDate_WeekNumber
     FROM tmpDataWeek AS tmp
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
-- SELECT * FROM gpSelect_Week_Date (inStartDate:= '02.11.2025', inEndDate:= '30.11.2025', inSession:= '2')
