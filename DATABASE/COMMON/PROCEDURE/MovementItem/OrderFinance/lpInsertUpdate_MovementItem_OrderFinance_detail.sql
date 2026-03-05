-- Function: lpInsertUpdate_MovementItem_OrderFinance_detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance_detail (Integer, Integer, Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderFinance_detail(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , --
    IN inAmount                TFloat    , --
    IN inOperDate_Amount       TDateTime , --
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert       Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- сохранили <Элемент документа> - Первичный план на неделю
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), NULL, inMovementId, inAmount, inParentId);

     -- сохранили свойство <Дата Согласовано к оплате>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Amount(), ioId, inOperDate_Amount);


     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     -- PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);

     -- сохранили протокол
     -- !!! времнно откл.!!!
     IF inUserId <> 5 OR vbIsInsert = TRUE THEN PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert); END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.03.26                                        *
*/

-- тест
--
