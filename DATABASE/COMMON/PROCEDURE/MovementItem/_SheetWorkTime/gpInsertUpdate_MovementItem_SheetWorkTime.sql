-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime(
 INOUT ioPersonalId          Integer   , -- Ключ Сотрудник
    IN inPositionId          Integer   , -- Должность
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inStartDate           TDateTime , -- начальная дата

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_1 Integer;
   DECLARE vbMovementItemId_1 Integer;

BEGIN
	-- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_SheetWorkTime());
    vbUserId := inSession;
     
     -- сохранили <Элемент документа>
     --ioId := lpInsertUpdate_MovementItem (vbMovementItemId_1, zc_MI_Master(), ioPersonalId, vbMovementId_1, inAmount_1, NULL);
     -- сохранили связь с <Типы рабочего времени>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), vbMovementItemId_1, inWorkTimeKindId_1);

     PERFORM lpInsertUpdate_MovementItem_SheetWorkTime (InMovementItemId:= vbMovementItemId_1, inOperDate = inStartDate, inMovementId:= vbMovementId_1
                                                      , inPersonalId:= ioPersonalId, inPositionId:= inPositionId, inPersonalGroupId=inPersonalGroupId, inUnitId=inUnitId
                                                      , inAmount:= inAmount_1, inWorkTimeKindId:= inWorkTimeKindId_1);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.10.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTime (, inSession:= '2')
