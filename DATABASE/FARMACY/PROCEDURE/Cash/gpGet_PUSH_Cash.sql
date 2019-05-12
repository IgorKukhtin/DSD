-- Function: gpGet_PUSH_Cash(TVarChar)

DROP FUNCTION IF EXISTS gpGet_PUSH_Cash(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PUSH_Cash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Text TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbMovementID Integer;
   DECLARE vbEmployeeSchedule TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    CREATE TEMP TABLE _PUSH (Id  Integer
                           , Text TBlob) ON COMMIT DROP;

     -- Отметка посещаемости
    vbEmployeeSchedule := '';
    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN

      SELECT Movement.ID
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
        AND Movement.DescId = zc_Movement_EmployeeSchedule();

      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementID
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = vbUserId)
      THEN

        SELECT MovementItemString.ValueData
        INTO vbEmployeeSchedule
        FROM MovementItem

             INNER JOIN MovementItemString ON MovementItemString.DescId = zc_MIString_ComingValueDayUser()
                                          AND MovementItemString.MovementItemId = MovementItem.ID

        WHERE MovementItem.MovementId = vbMovementID
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = vbUserId;
      END IF;
    END IF;

    IF COALESCE (vbEmployeeSchedule, '') = ''
    THEN
      vbEmployeeSchedule := '0000000000000000000000000000000';
    END IF;

   IF SUBSTRING(vbEmployeeSchedule, date_part('day',  CURRENT_DATE)::Integer, 1) = '0'
   THEN
      INSERT INTO _PUSH (Id, Text) VALUES (1, 'Уважаемые коллеги, не забудьте сегодня поставить отметку времени прихода в  график (Ctrl+T) исходя из персонального графика работы (07:00, 08:00, 10:00)');
   END IF;
   
   -- Уведомление по рецептам Хелси и Фармасикеш
   IF vbUnitId in (9951517, 375627, 183289) 
     AND date_part('HOUR',  CURRENT_TIME)::Integer = 17 
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 30
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 50
   THEN
      INSERT INTO _PUSH (Id, Text) VALUES (1, 'В конце рабочего дня проверить соотвествие рецептов, прошедших по Хелси и Фармасикеш! За качество сверки  фармацевт несет полную отвественность!"');
   END IF;

   -- PUSH уведомления
   WITH tmpMovementItemUnit AS (SELECT DISTINCT Movement.Id AS MovementId
                                FROM Movement

                                    INNER JOIN MovementItem 
                                           ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId = zc_MI_Child()
                                          AND MovementItem.IsErased = False
                                          
                                    LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                                                           ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                                                          AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()
                                                          
                                WHERE Movement.OperDate <= CURRENT_TIMESTAMP
                                  AND CURRENT_TIMESTAMP < COALESCE(MovementDate_DateEndPUSH.ValueData, date_trunc('day', Movement.OperDate + INTERVAL '1 DAY'))			
                                  AND Movement.DescId = zc_Movement_PUSH()
                                  AND Movement.StatusId = zc_Enum_Status_Complete())
   
   INSERT INTO _PUSH (Id, Text)
   SELECT
          Movement.Id                              AS ID
        , MovementBlob_Message.ValueData           AS Message

   FROM Movement

        LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                               ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                              AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()
                                              
        LEFT JOIN MovementFloat AS MovementFloat_Replays
                                ON MovementFloat_Replays.MovementId = Movement.Id
                               AND MovementFloat_Replays.DescId = zc_MovementFloat_Replays()

        LEFT JOIN MovementBlob AS MovementBlob_Message
                               ON MovementBlob_Message.MovementId = Movement.Id
                              AND MovementBlob_Message.DescId = zc_MovementBlob_Message()
                              
        LEFT JOIN MovementBoolean AS MovementBoolean_Daily
                                  ON MovementBoolean_Daily.MovementId = Movement.Id
                                 AND MovementBoolean_Daily.DescId = zc_MovementBoolean_PUSHDaily()
                              
        LEFT JOIN MovementItem AS MovementItem_Child
                               ON MovementItem_Child.MovementId = Movement.Id
                              AND MovementItem_Child.DescId = zc_MI_Child()
                              AND MovementItem_Child.ObjectId = vbUnitId

        LEFT JOIN tmpMovementItemUnit AS MovementItemUnit
                                      ON MovementItemUnit.MovementId = Movement.Id

   WHERE Movement.OperDate <= CURRENT_TIMESTAMP
     AND make_time(date_part('hour', Movement.OperDate)::integer, date_part('minute', Movement.OperDate)::integer, date_part('second', Movement.OperDate)::integer) <= CURRENT_TIME
     AND CURRENT_TIMESTAMP < COALESCE(MovementDate_DateEndPUSH.ValueData, date_trunc('day', Movement.OperDate + INTERVAL '1 DAY'))			
     AND Movement.DescId = zc_Movement_PUSH()
     AND Movement.StatusId = zc_Enum_Status_Complete()
     AND (COALESCE(MovementItemUnit.MovementId, 0) = 0 OR COALESCE(MovementItem_Child.ObjectId, 0) = vbUnitId)
     AND (COALESCE (MovementBoolean_Daily.ValueData, FALSE) = FALSE
          AND COALESCE(MovementFloat_Replays.ValueData, 1) >
              COALESCE ((SELECT SUM(MovementItem.Amount) 
                         FROM MovementItem 
                         WHERE MovementItem.MovementId = Movement.Id
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.ObjectId = vbUserId), 0)
          OR
          COALESCE (MovementBoolean_Daily.ValueData, FALSE) = TRUE
          AND COALESCE(MovementFloat_Replays.ValueData, 1) >
              COALESCE ((SELECT SUM(MovementItem.Amount) 
                         FROM MovementItem 
              
                              LEFT JOIN MovementItemDate AS MID_Viewed
                                     ON MID_Viewed.MovementItemId = MovementItem.Id
                                    AND MID_Viewed.DescId = zc_MIDate_Viewed()

                         WHERE MovementItem.MovementId = Movement.Id
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.ObjectId = vbUserId
                           AND MID_Viewed.ValueData >= CURRENT_DATE
                           AND MID_Viewed.ValueData < CURRENT_DATE + INTERVAL '1 DAY'), 0));


   RETURN QUERY
     SELECT _PUSH.Id                     AS Id
          , _PUSH.Text                   AS Text
     FROM _PUSH;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.05.19                                                       *
 13.03.18                                                       *
 04.03.18                                                       *

*/

-- тест
-- SELECT * FROM gpGet_PUSH_Cash('3')