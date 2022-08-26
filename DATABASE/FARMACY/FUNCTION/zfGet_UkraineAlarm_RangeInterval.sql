-- Function: zfGet_UkraineAlarm_RangeInterval()

  DROP FUNCTION IF EXISTS zfGet_UkraineAlarm_RangeInterval (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION zfGet_UkraineAlarm_RangeInterval(
    IN inUnitId            Integer ,  --
    IN inStartDate         TDateTime, 
    IN inEndDate           TDateTime, 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbResult TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    WITH tmpUkraineAlarm AS (SELECT MAX(CASE WHEN COALESCE(UkraineAlarm.endDate, inEndDate) > inEndDate THEN inEndDate ELSE COALESCE(UkraineAlarm.endDate, inEndDate) END) - 
                                    MIN(CASE WHEN inStartDate > UkraineAlarm.startDate THEN inStartDate ELSE UkraineAlarm.startDate END) AS Interv
                             FROM UkraineAlarm
                             WHERE UkraineAlarm.startDate > inStartDate - INTERVAL '2 DAY'
                               AND (UkraineAlarm.endDate IS NULL OR UkraineAlarm.endDate >= inStartDate)
                               AND UkraineAlarm.startDate < inEndDate
                               AND (inUnitId in (3457773, 6741875) AND UkraineAlarm.regionId in (9, 47, 351) OR
                                    inUnitId in (1529734, 8156016) AND UkraineAlarm.regionId in (9, 42, 300) OR
                                    inUnitId NOT in (3457773, 6741875, 1529734, 8156016) AND UkraineAlarm.regionId in (9, 44, 332)
                                   ))
                                   
    SELECT tmpUkraineAlarm.Interv::TVarChar
    INTO vbResult
    FROM tmpUkraineAlarm;
    
    RETURN COALESCE (vbResult, '');

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.08.22                                                       *
*/

-- тест
-- 

SELECT * FROM zfGet_UkraineAlarm_RangeInterval (3457773, '25.08.2022 13:09', '25.08.2022 14:12', inSession:= '3')