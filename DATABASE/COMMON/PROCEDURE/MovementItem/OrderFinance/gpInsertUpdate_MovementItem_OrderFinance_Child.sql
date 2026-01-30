-- Function: gpInsertUpdate_MovementItem_OrderFinance_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance_Child (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance_Child (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance_Child (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinance_Child(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , -- Ключ объекта <главный элемент>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId_Order  Integer   , -- MovementItemId OrderIncome
    IN inGoodsName             TVarChar  , -- Товары
    IN inInvNumber             TVarChar  , --
    IN inInvNumber_Invoice     TVarChar  , --
    IN inComment               TVarChar  , --
    IN inAmount                TFloat    , --
   OUT outSumm_parent          TFloat    , --
   OUT outInvNumber_parent     TVarChar  , --
   OUT outGoodsName_parent     TVarChar  , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbSumm_child     TFloat;
   DECLARE vbOrderFinanceId Integer;
   DECLARE vbIsInsert       Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     -- проверка
     IF TRIM (COALESCE (inInvNumber, '')) = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <№ заявки (1С)>.';
     END IF;
     -- проверка
   /*  IF TRIM (COALESCE (inInvNumber_Invoice, '')) = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <№ счета>.';
     END IF;
     */
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


     -- Проверка - <Ожидание Согласования-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignWait_1() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Отправлено на Согласование Руководителю>.';
     END IF;
     -- Проверка - <Согласован-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign_1() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Согласовано Руководителем>.';
     END IF;
     -- Проверка - <Виза СБ>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignSB() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Виза СБ>.';
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

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumber_Invoice(), ioId, inInvNumber_Invoice);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), ioId, inGoodsName);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- Только после сохранения
    SELECT STRING_AGG (tmpMI.InvNumber, '; ') AS InvNumber
         , STRING_AGG (tmpMI.GoodsName, '; ') AS GoodsName
         , SUM (tmpMI.Amount)          AS Amount
           INTO outInvNumber_parent, outGoodsName_parent, outSumm_parent
    FROM (SELECT COALESCE (MIString_GoodsName.ValueData, '') AS GoodsName
               , COALESCE (MIString_InvNumber.ValueData, '') AS InvNumber
               , MovementItem.Amount
          FROM MovementItem
              LEFT JOIN MovementItemString AS MIString_InvNumber
                                           ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                          AND MIString_InvNumber.DescId = zc_MIString_InvNumber()
              LEFT JOIN MovementItemString AS MIString_GoodsName
                                           ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                          AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE
            AND MovementItem.ParentId   = inParentId
            -- Важно - Сортировать
          ORDER BY MovementItem.Id ASC
        ) AS tmpMI;


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
 30.01.26         *
 14.01.26         *
*/

-- тест
--