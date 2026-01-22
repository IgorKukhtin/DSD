 -- Function: gpSelect_Week_Date()

DROP FUNCTION IF EXISTS gpSelect_Week_Date (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Week_Date(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (WeekNumber           Integer
             , StartDate_WeekNumber TDateTime
             , EndDate_WeekNumber   TDateTime
             , StartDate            TDateTime
             , EndDate              TDateTime
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- inStartDate:= DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', inStartDate));
     inStartDate:= DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', inStartDate));
     inEndDate  := DATE_TRUNC ('WEEK', inStartDate + INTERVAL '1 YEAR' + INTERVAL '1 WEEK');

     -- Результат
     RETURN QUERY
     WITH
          --
          tmpDataWeek AS (SELECT GENERATE_SERIES (inStartDate, inEndDate, '1 WEEK' :: INTERVAL) AS OperDate)
          -- Результат
          SELECT EXTRACT (WEEK FROM tmp.OperDate)  :: Integer   AS WeekNumber
               , tmp.OperDate                      :: TDateTime AS StartDate_WeekNumber
               , (tmp.OperDate + INTERVAL '6 DAY') :: TDateTime AS EndDate_WeekNumber
               , inStartDate                                    AS StartDate
               , inEndDate                                      AS EndDate
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
