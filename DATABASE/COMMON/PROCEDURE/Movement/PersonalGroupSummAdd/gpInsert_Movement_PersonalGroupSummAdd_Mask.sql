-- Function: gpInsert_Movement_PersonalGroupSummAdd_Mask()

DROP FUNCTION IF EXISTS gpInsert_Movement_PersonalGroupSummAdd_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_PersonalGroupSummAdd_Mask(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ >
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd());

           -- сохранили <Документ>
     vbInvNumber := CAST (NEXTVAL ('movement_PersonalGroupSummAdd_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_PersonalGroupSummAdd(), vbInvNumber, inOperDate, NULL, 0);

     PERFORM gpInsertUpdate_Movement_PersonalGroupSummAdd (ioId              := vbMovementId
                                                         , inInvNumber       := vbInvNumber
                                                         , inOperDate        := inOperDate 
                                                         , inNormHour        := tmp.NormHour
                                                         , inComment         := '' ::TVarChar
                                                         , inPersonalServiceListId := tmp.PersonalServiceListId 
                                                         , inUnitId          := tmp.UnitId
                                                         , inPersonalGroupId := tmp.PersonalGroupId
                                                         , inSession         := inSession
                                                          )
     FROM gpGet_Movement_PersonalGroupSummAdd (ioId, inOperDate, FALSE, inSession) AS tmp;

     -- записываем строки PersonalGroupSummAddGoods документа
     PERFORM lpInsertUpdate_MovementItem_PersonalGroupSummAdd (ioId          := 0        
                                                             , inMovementId  := vbMovementId
                                                             , inPositionId  := tmp.PositionId
                                                             , inPositionLevelId := tmp.PositionLevelId
                                                             , inAmount      := tmp.Amount
                                                             , inComment     := tmp.Comment
                                                             , inUserId      := vbUserId
                                                              ) 
   FROM gpSelect_MovementItem_PersonalGroupSummAdd (ioId, False, False, inSession)  AS tmp;

   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.24         *
*/

-- тест
--