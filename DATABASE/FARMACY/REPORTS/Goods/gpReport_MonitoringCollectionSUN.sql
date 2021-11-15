-- Function: gpReport_MonitoringCollectionSUN()

DROP FUNCTION IF EXISTS gpReport_MonitoringCollectionSUN (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MonitoringCollectionSUN(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (DateSUN TDateTime, UnitCode Integer, UnitName TVarChar
             , CountSend Integer
             , CountDeferred Integer, DateDeferred TDateTime
             , CountSent Integer, DateSent TDateTime
             , CountReceived Integer, DateReceived TDateTime
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
  inOperDate := inOperDate - ((date_part('isodow', inOperDate) - 1)||' day')::INTERVAL;
  
  IF NOT EXISTS(SELECT Movement.ID
                     , Movement.InvNumber
                     , Movement.StatusId
                     , Movement.OperDate
                FROM Movement
                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                             ON MovementBoolean_SUN.MovementId = Movement.Id
                            AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                            AND MovementBoolean_SUN.ValueData = TRUE
                     INNER JOIN MovementDate AS MovementDate_Insert
                                             ON MovementDate_Insert.MovementId = Movement.Id
                                            AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                WHERE MovementDate_Insert.ValueData BETWEEN inOperDate AND inOperDate + INTERVAL '7 DAY'
                  AND Movement.DescId = zc_Movement_Send())  
  THEN
    RAISE EXCEPTION 'В неделе с % по % перемещения по СУН не найдены', zfConvert_DateShortToString(inOperDate), zfConvert_DateShortToString(inOperDate + INTERVAL '6 DAY');  
  END IF;

  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , DATE_TRUNC('DAY', MovementDate_Insert.ValueData)::TDateTime AS DateSUN
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                            LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                   ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                  AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()
                       WHERE MovementDate_Insert.ValueData BETWEEN inOperDate AND inOperDate + INTERVAL '7 DAY'
                         AND Movement.DescId = zc_Movement_Send()
                         AND COALESCE (MovementBoolean_NotDisplaySUN.valuedata, FALSE) = FALSE)
    , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                   , MIN(CASE WHEN MovementProtocol.ProtocolData ILIKE '%"Отложен" FieldValue = "true"%'
                                              THEN MovementProtocol.OperDate END)::TDateTime AS DateDeferred
                                   , MIN(CASE WHEN MovementProtocol.ProtocolData ILIKE '%"Отправлено" FieldValue = "true"%'
                                              THEN MovementProtocol.OperDate END)::TDateTime AS DateSent
                                   , MIN(CASE WHEN MovementProtocol.ProtocolData ILIKE '%"Получено" FieldValue = "true"%'
                                              THEN MovementProtocol.OperDate END)::TDateTime AS DateReceived
                              FROM tmpMovement AS Movement
   
                                   INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                                              AND COALESCE(MovementProtocol.UserId, 0) <> 0
                              GROUP BY MovementProtocol.MovementId)
     , tmpMovementUnit AS (SELECT Movement.DateSUN
                                , MovementLinkObject_From.ObjectId                    AS UnitFromId
                                , COUNT(*)::Integer                                   AS CountSend
                                , SUM(CASE WHEN tmpMovementProtocol.DateDeferred IS NULL THEN 0 ELSE 1 END)::Integer AS CountDeferred
                                , MAX(tmpMovementProtocol.DateDeferred)::TDateTime    AS DateDeferred
                                , SUM(CASE WHEN tmpMovementProtocol.DateSent IS NULL THEN 0 ELSE 1 END)::Integer AS CountSent
                                , MAX(tmpMovementProtocol.DateSent)::TDateTime        AS DateSent
                           FROM tmpMovement AS Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                           GROUP BY Movement.DateSUN
                                  , MovementLinkObject_From.ObjectId) 
     , tmpReceived AS (SELECT Movement.DateSUN
                                , MovementLinkObject_To.ObjectId                      AS UnitToId
                                , SUM(CASE WHEN tmpMovementProtocol.DateReceived IS NULL THEN 0 ELSE 1 END)::Integer AS CountReceived
                                , MAX(tmpMovementProtocol.DateReceived)::TDateTime    AS DateReceived
                           FROM tmpMovement AS Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                           GROUP BY Movement.DateSUN
                                  , MovementLinkObject_To.ObjectId) 

  SELECT MovementUnit.DateSUN
       , Object_From.ObjectCode                                                           AS UnitCode
       , Object_From.ValueData                                                            AS UnitName       
       , MovementUnit.CountSend
       , MovementUnit.CountDeferred
       , MovementUnit.DateDeferred
       , MovementUnit.CountSent
       , MovementUnit.DateSent
       , tmpReceived.CountReceived
       , tmpReceived.DateReceived
  FROM tmpMovementUnit AS MovementUnit

       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementUnit.UnitFromId

       LEFT JOIN tmpReceived AS tmpReceived ON tmpReceived.DateSUN = MovementUnit.DateSUN
                                           AND tmpReceived.UnitToId = MovementUnit.UnitFromId 
       
  ORDER BY MovementUnit.DateSUN, Object_From.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_MonitoringCollectionSUN (TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.11.21                                                       *
*/

-- тест
--

select * from gpReport_MonitoringCollectionSUN(inOperDate := CURRENT_DATE::TDateTime , inSession := '3');