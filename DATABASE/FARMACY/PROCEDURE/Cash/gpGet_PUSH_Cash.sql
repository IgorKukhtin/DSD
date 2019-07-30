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
      INSERT INTO _PUSH (Id, Text) VALUES (2, 'В конце рабочего дня проверить соотвествие рецептов, прошедших по Хелси и Фармасикеш! За качество сверки  фармацевт несет полную отвественность!"');
   END IF;
   
   -- Уведомление по перемещениям на склад просрочки
   IF date_part('DOW',     CURRENT_DATE)::Integer = 5 
     AND date_part('HOUR',    CURRENT_TIME)::Integer = 16 
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
   THEN
      IF EXISTS(SELECT 1 FROM Object AS Object_Unit

                   INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                            ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                           AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                          AND ObjectBoolean_DividePartionDate.ValueData = True

                   INNER JOIN ObjectLink AS ObjectLink_Unit_UnitOverdue
                                         ON ObjectLink_Unit_UnitOverdue.ObjectId = Object_Unit.Id 
                                        AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()
                                        AND COALESCE (ObjectLink_Unit_UnitOverdue.ChildObjectId, 0) <> 0 

                WHERE Object_Unit.ID = vbUnitId) 
         AND EXISTS(WITH
                     -- просрочка
                     tmpContainer AS (SELECT Container.Id                                         AS Id,
                                             Container.ObjectId                                   AS GoodsID,
                                             Container.Amount                                     AS Amount,
                                             Container.ParentId                                   AS ParentId,
                                             ContainerLinkObject.ObjectId                         AS PartionGoodsId,
                                             ObjectDate_ExpirationDate.ValueData                  AS ExpirationDate

                                      FROM Container

                                         LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

                                         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                        AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                              ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                                ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                               AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5() 

                                    WHERE Container.DescId = zc_Container_CountPartionDate()
                                      AND Container.WhereObjectId = vbUnitId
                                      AND Container.Amount > 0
                                      AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE + interval '1 day' 
                                      AND  COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE)
                     -- Контейнера в не проведенных документах
                   , tmpMovement AS (SELECT DISTINCT MIFloat_ContainerId.ValueData::Integer  AS ContainerId
                                     FROM Movement

                                          INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                    AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                       AND MovementLinkObject_From.ObjectId = vbUnitId

                                          INNER JOIN MovementItem AS MovementItemMaster
                                                                  ON MovementItemMaster.MovementId = Movement.Id
                                                                 AND MovementItemMaster.DescId = zc_MI_Master()
                                                                 AND MovementItemMaster.IsErased = FALSE

                                          INNER JOIN MovementItem AS MovementItemChild
                                                                  ON MovementItemChild.MovementId = Movement.Id
                                                                 AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                                 AND MovementItemChild.DescId = zc_MI_Child()
                                                                 AND MovementItemChild.IsErased = FALSE

                                        LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                    ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                                   AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                    WHERE Movement.DescId = zc_Movement_Send()
                                      AND Movement.StatusId = zc_Enum_Status_UnComplete())

                SELECT Container.Id,
                       Container.GoodsID,
                       Container.Amount,

                       Container.ExpirationDate

                FROM tmpContainer AS Container
                     LEFT JOIN tmpMovement ON tmpMovement.ContainerId = Container.Id
                WHERE COALESCE (tmpMovement.ContainerId, 0) = 0)
      THEN
         INSERT INTO _PUSH (Id, Text) VALUES (3, 'Коллеги, информируем вас, что завтра на товар по вашей 4 категории (просрочка) будет создано перемещение на виртуальный склад "Сроки", если есть необходимость, проработайте данный товар!');
      END IF;
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
 25.07.19                                                       *
 11.05.19                                                       *
 13.03.18                                                       *
 04.03.18                                                       *

*/

-- тест
-- SELECT * FROM gpGet_PUSH_Cash('3')