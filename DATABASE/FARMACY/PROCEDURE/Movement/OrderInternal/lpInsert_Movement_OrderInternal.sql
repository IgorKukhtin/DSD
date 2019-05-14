-- Function: lpInsert_Movement_OrderInternal()
DROP FUNCTION IF EXISTS lpInsert_Movement_OrderInternal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_OrderInternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделения
    IN inOrderKindId         Integer   , -- 
    IN inMasterId            Integer   , -- документ Заявка внутренняя (маркет-товары)
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0; 

    IF (COALESCE(ioId, 0) = 0) AND (COALESCE(inInvNumber, '') = '') THEN
        inInvNumber := (NEXTVAL ('movement_OrderInternal_seq'))::TVarChar;
    END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternal(), inInvNumber, inOperDate, NULL);

    -- сохранили связь с <Подразделения>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

    -- сохранили связь с Тип заказа>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_OrderKind(), ioId, inOrderKindId);

    -- сохранили связь с <документом заявкой>
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), ioId, inMasterId);
     
    -- !!!протокол через свойства конкретного объекта!!!
    IF vbIsInsert = TRUE
    THEN
        -- сохранили свойство <Дата создания>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
        -- сохранили свойство <Пользователь (создание)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.19         *
*/

-- тест
-- 