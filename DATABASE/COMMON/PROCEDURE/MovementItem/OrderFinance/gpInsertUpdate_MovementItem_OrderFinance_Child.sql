-- Function: gpInsertUpdate_MovementItem_OrderFinance_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance_Child (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinance_Child(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , -- Ключ объекта <главный элемент>
    IN inMovementId            Integer   , -- Ключ объекта <Документ> 
    IN inMovementItemId_Order  Integer   , -- MovementItemId OrderIncome
    IN inGoodsName             TVarChar  , -- Товары
    IN inInvNumber             TVarChar  , -- 
    IN inComment               TVarChar  , --
    IN inAmount                TFloat    , -- 
    IN inisSign                Boolean   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     -- проверка
     IF TRIM (COALESCE (inInvNumber, '')) = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <№ заявки (1С)>.';
     END IF;
     -- проверка
     IF TRIM (COALESCE (inGoodsName, '')) = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Товар (Заявка ТМЦ)>.';
     END IF;
     -- проверка
     IF COALESCE (inAmount, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Сумма>.';
     END IF;
     -- проверка
     IF NOT EXISTS (SELECT 1 FROM inParentId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Сумма>.';
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;    

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), Null, inMovementId, inAmount, inParentId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMovementItemId_Order);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumber(), ioId, inInvNumber);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), ioId, inGoodsName);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили свойство <>
     -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Sign(), ioId, inisSign);

     -- сохранили <Итого>
     PERFORM lpInsertUpdate_MovementItem (zc_MIBoolean_Sign(), ioId, inisSign)
     FROM MovementItem
     WHERE MovementItem

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.26         *
*/

-- тест
--