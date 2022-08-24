-- Function: gpGet_Cash_ActiveAlerts()

  DROP FUNCTION IF EXISTS gpGet_Cash_ActiveAlerts (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Cash_ActiveAlerts(
   OUT outActiveAlerts     TVarChar ,  --
   OUT outstartDate        TDateTime, 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    WITH tmpUkraineAlarm AS (SELECT UkraineAlarm.alertType, MIN(UkraineAlarm.startDate) AS startDate
                             FROM UkraineAlarm
                             WHERE UkraineAlarm.startDate > CURRENT_DATE - INTERVAL '2 DAY'
                               AND UkraineAlarm.endDate IS NULL
                               AND (vbUnitId in (3457773, 6741875) AND UkraineAlarm.regionId in (9, 47, 351) OR
                                    vbUnitId in (1529734, 8156016) AND UkraineAlarm.regionId in (9, 42, 300) OR
                                    vbUnitId NOT in (3457773, 6741875, 1529734, 8156016) AND UkraineAlarm.regionId in (9, 44, 332)
                                   )
                             GROUP BY UkraineAlarm.alertType)
    SELECT string_agg(CASE WHEN alertType = 'ARTILLERY' THEN 'Угроза артобстрела' ELSE 'Воздушная тревога' END, ',')
         , Min(tmpUkraineAlarm.startDate)
    INTO outActiveAlerts, outstartDate
    FROM tmpUkraineAlarm;
    
    outActiveAlerts := COALESCE (outActiveAlerts, '');

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

SELECT * FROM gpGet_Cash_ActiveAlerts (inSession:= '3')