-- Function: lpInsertUpdate_MovementItem_SheetWorkTime ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SheetWorkTime(
 INOUT InMovementItemId      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inPersonalId          Integer   , -- Сотрудник
    IN inPositionId          Integer   , -- Должность
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inAmount              TFloat    , -- Количество часов факт
    IN inWorkTimeKindId      Integer     -- Типы рабочего времени
)                              
RETURNS Integer AS
$BODY$
BEGIN
     
     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (InMovementItemId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);
     
     -- сохранили связь с <Группировки Сотрудников>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalGroup(), InMovementItemId, inPersonalGroupId);
     -- сохранили связь с <Должностью>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), InMovementItemId, inPositionId);
     -- сохранили связь с <Типы рабочего времени>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), InMovementItemId, inWorkTimeKindId);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.10.13         * 

*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_SheetWorkTime (InMovementItemId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:= 0, inSession:= '2')
