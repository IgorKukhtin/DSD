DROP FUNCTION IF EXISTS gpSelectPeriodList(TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectPeriodList(inStartDate TDateTime, inEndDate TDateTime, inPeriodType TVarChar, inSession TVarChar) 
RETURNS TABLE(StartDate TDateTime, EndDate TDateTime)
AS $BODY$
BEGIN

  RETURN QUERY
   SELECT StartPeriod.StartDate::TDateTime, EndPeriod.EndDate::TDateTime
     FROM 
       (SELECT ROW_NUMBER()OVER () AS RowNumber, s.StartDate FROM generate_series(inStartDate, inEndDate, '1 day') AS s(StartDate)) AS StartPeriod
      JOIN (SELECT ROW_NUMBER()OVER () AS RowNumber, EndPeriod.EndDate FROM(
              SELECT s.EndDate FROM generate_series(inStartDate + ('1 day')::INTERVAL - ('1 second')::interval,
                              inEndDate, '1 day') AS s(EndDate)
              UNION SELECT inEndDate ORDER BY 1) AS EndPeriod) AS EndPeriod ON StartPeriod.rownumber = EndPeriod.rowNumber;

END;
$BODY$LANGUAGE plpgsql;