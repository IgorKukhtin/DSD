-- Function: gpInsertUpdate_MovementItem_OrderFinance_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance_Child (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance_Child (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinance_Child(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , -- Ключ объекта <главный элемент>
    IN inMovementId            Integer   , -- Ключ объекта <Документ> 
    IN inMovementItemId_Order  Integer   , -- MovementItemId OrderIncome
    IN inGoodsName             TVarChar  , -- Товары
    IN inInvNumber             TVarChar  , -- 
    IN inComment               TVarChar  , --
    IN inAmount                TFloat    , -- 
   OUT outSumm_parent          TFloat    , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbSumm_child TFloat;
   DECLARE vbIsInsert   Boolean;
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
     IF COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не выбран "главный" Элемент - Юр.Лицо + договор.';
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


     -- Только после сохранения
     outSumm_parent:= COALESCE ((SELECT SUM (MovementItem.Amount) AS Amount
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Child()
                                  AND MovementItem.ParentId   = inParentId
                                  AND MovementItem.isErased   = FALSE
                               ), 0);

     -- сохранили <Итого>
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Master(), MovementItem.ObjectId, MovementItem.MovementId, outSumm_parent, MovementItem.ParentId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.Id         = inParentId
      ;

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