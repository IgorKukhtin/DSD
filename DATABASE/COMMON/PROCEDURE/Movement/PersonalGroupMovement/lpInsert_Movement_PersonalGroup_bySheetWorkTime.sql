-- Function: lpInsert_Movement_PersonalGroup_bySheetWorkTime()

DROP FUNCTION IF EXISTS lpInsert_Movement_PersonalGroup_bySheetWorkTime (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_PersonalGroup_bySheetWorkTime(
    IN inOperDate              TDateTime ,
    IN inUnitId                Integer   , 
    IN inPersonalGroupId       Integer   , 
    IN inPairDayId             Integer   , 
    IN inPersonalId            Integer   , 
    IN inPositionId            Integer   , 
    IN inPositionLevelId       Integer   , 
    IN inWorkTimeKindId        Integer   , 
    IN inAmount                TFloat    ,
    IN inUserId                Integer    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbMI_Id Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroup());

     --пробуем найти сохраненный документ ключ дата +подразделение +Группа + Вид Смены
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND MovementLinkObject_Unit.ObjectId = inUnitId
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
                                                        --AND MovementLinkObject_PersonalGroup.ObjectId = inPersonalGroupId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                                         ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                                        AND MovementLinkObject_PairDay.DescId = zc_MovementLinkObject_PairDay()
                                                        AND MovementLinkObject_PairDay.ObjectId = inPairDayId
                      WHERE Movement.OperDate = inOperDate
                         AND Movement.DescId = zc_Movement_PersonalGroup()
                         AND Movement.StatusId = zc_Enum_Status_UnComplete()
                         AND COALESCE (MovementLinkObject_PersonalGroup.ObjectId,0) = COALESCE (inPersonalGroupId,0)
                      );

     IF COALESCE (vbMovementId,0) = 0
     THEN
          vbInvNumber := (CAST (NEXTVAL ('movement_PersonalGroup_seq') AS TVarChar));
          --если нет док то сохраняем новый
          vbMovementId := lpInsertUpdate_Movement_PersonalGroup (ioId              := 0
                                                               , inInvNumber       := vbInvNumber
                                                               , inOperDate        := inOperDate
                                                               , inUnitId          := inUnitId
                                                               , inPersonalGroupId := inPersonalGroupId
                                                               , inPairDayId       := inPairDayId
                                                               , inUserId          := inUserId
                                                                )AS tmp;
     END IF;
     
     
     
     --пробуем найти строку док, если уже сохранили сотрудника
     vbMI_Id := (SELECT MovementItem.Id
                 FROM MovementItem
                      INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                        ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                       AND MILinkObject_Position.ObjectId = inPositionId

                      INNER JOIN MovementItemLinkObject AS MILinkObject_WorkTimeKind
                                                        ON MILinkObject_WorkTimeKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                                       AND MILinkObject_WorkTimeKind.ObjectId = inWorkTimeKindId
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                        ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()

                 WHERE MovementItem.MovementId = vbMovementId
                     AND MovementItem.isErased = False
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.ObjectId = inPersonalId
                     AND COALESCE (MILinkObject_PositionLevel.ObjectId,0) = COALESCE (inPositionLevelId,0)
                );

     IF COALESCE (vbMI_Id,0) = 0
     THEN
         --сохраняем строку
         PERFORM lpInsertUpdate_MovementItem_PersonalGroup (ioId              := 0
                                                          , inMovementId      := vbMovementId
                                                          , inPersonalId      := inPersonalId
                                                          , inPositionId      := inPositionId
                                                          , inPositionLevelId := inPositionLevelId
                                                          , inWorkTimeKindId  := inWorkTimeKindId
                                                          , inAmount          := inAmount
                                                          , inUserId          := inUserId
                                                          );
     END IF;
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.21         *
*/

-- тест
--