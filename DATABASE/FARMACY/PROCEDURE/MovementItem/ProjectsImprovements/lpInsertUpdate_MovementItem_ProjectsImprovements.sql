-- Function: lpInsertUpdate_MovementItem_ProjectsImprovements()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProjectsImprovements(Integer, Integer, TDateTime, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProjectsImprovements(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата
    IN inTitle               TVarChar  , -- Название
    IN inDescription         TVarChar  , -- Описание задания 
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
 DECLARE vbIsInsert Boolean;
 DECLARE vbAmount TFloat;
BEGIN

     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     if vbIsInsert = TRUE
     THEN
       vbAmount := 0;
     ELSE
       vbAmount := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId);
     END IF;
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), Null, inMovementId, vbAmount, Null);

     -- Сохранили <Пояснение>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

     -- Сохранили <Описание задания>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inTitle);
     -- Сохранили < Описание задания >
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Description(), ioId, inDescription);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/

-- тест

