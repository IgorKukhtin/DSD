-- Function: lpComplete_Movement_PersonalGroup (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalGroup (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalGroup(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbPersonalGroupId Integer;
   DECLARE vbPairDayId Integer;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Параметры документа
     SELECT Movement.OperDate                         AS OperDate
          , MovementLinkObject_Unit.ObjectId          AS UnitId
          , MovementLinkObject_PersonalGroup.ObjectId AS PersonalGroupId
          , MovementLinkObject_PairDay.ObjectId       AS PairDayId
            INTO vbOperDate, vbUnitId, vbPersonalGroupId, vbPairDayId
     FROM MovementLinkObject AS MovementLinkObject_Unit
          JOIN Movement ON Movement.Id = inMovementId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                       ON MovementLinkObject_PersonalGroup.MovementId = inMovementId
                                      AND MovementLinkObject_PersonalGroup.DescId     = zc_MovementLinkObject_PersonalGroup()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                       ON MovementLinkObject_PairDay.MovementId = inMovementId
                                      AND MovementLinkObject_PairDay.DescId     = zc_MovementLinkObject_PairDay()
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
    ;


    -- проверка
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Подразделение не установлено.';
    END IF;

    --
    IF EXISTS (SELECT 1
               FROM Movement
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                 ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                AND MovementLinkObject_PersonalGroup.DescId     = zc_MovementLinkObject_PersonalGroup()
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                                 ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                                AND MovementLinkObject_PairDay.DescId     = zc_MovementLinkObject_PairDay()
               WHERE Movement.OperDate = vbOperDate
                 AND Movement.DescId   = zc_Movement_PersonalGroup()
                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                 AND Movement.Id       <> inMovementId
                 AND MovementLinkObject_Unit.ObjectId = vbUnitId
                 AND COALESCE (MovementLinkObject_PersonalGroup.ObjectId, 0) = vbPersonalGroupId
                 AND COALESCE (MovementLinkObject_PairDay.ObjectId, 0) = vbPairDayId
              )
    THEN
        RAISE EXCEPTION 'Ошибка.Найден другой документ <Список бригады> № <%> за <%>%для <%>%<%>%<%>.%Может быть только один документ.'
                       , (SELECT Movement.InvNumber
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                            ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                           AND MovementLinkObject_PersonalGroup.DescId     = zc_MovementLinkObject_PersonalGroup()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                                            ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                                           AND MovementLinkObject_PairDay.DescId     = zc_MovementLinkObject_PairDay()
                          WHERE Movement.OperDate = vbOperDate
                            AND Movement.DescId   = zc_Movement_PersonalGroup()
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                            AND Movement.Id       <> inMovementId
                            AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            AND COALESCE (MovementLinkObject_PersonalGroup.ObjectId, 0) = vbPersonalGroupId
                            AND COALESCE (MovementLinkObject_PairDay.ObjectId, 0) = vbPairDayId
                         )
                       , zfConvert_DateToString (vbOperDate)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbUnitId)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbPersonalGroupId)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbPairDayId)
                       , CHR (13)
                        ;
    END IF;


     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalGroup()
                                , inUserId     := inUserId
                                 );


IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.test' ;
END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalGroup (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
