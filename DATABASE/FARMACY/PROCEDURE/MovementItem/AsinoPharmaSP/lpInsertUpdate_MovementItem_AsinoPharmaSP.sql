-- Function: lpInsertUpdate_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_AsinoPharmaSP (Integer, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_AsinoPharmaSP(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   ,
    IN inQueue                Integer   , -- Очередность
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), Null, inMovementId, inQueue, NULL);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.02.23                                                       *
 */