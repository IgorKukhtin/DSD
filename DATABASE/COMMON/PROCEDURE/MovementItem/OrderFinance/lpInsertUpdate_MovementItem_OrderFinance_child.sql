-- Function: lpInsertUpdate_MovementItem_OrderFinance_child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance_child (Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderFinance_child(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , --
    IN inAmount                TFloat    , --
    IN inAmount_next           TFloat    , --
    IN inOperDate_Amount_next  TDateTime , --
    IN inGoodsName             TVarChar  , -- Товары
    IN inInvNumber             TVarChar  , --
    IN inInvNumber_Invoice     TVarChar  , --
    IN inComment               TVarChar  , --
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert       Boolean;
   DECLARE vbOperDate_start TDateTime;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- Проверка - <Ожидание Согласования-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignWait_1() AND MB.ValueData = TRUE)
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Отправлено на Согласование Руководителю>.';
     END IF;
     -- Проверка - <Согласован-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign_1() AND MB.ValueData = TRUE)
        AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Согласовано Руководителем>.';
     END IF;
     -- Проверка - <Виза СБ>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignSB() AND MB.ValueData = TRUE)
        AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Виза СБ>.';
     END IF;


     -- проверка - № заявки (1С)
     IF TRIM (COALESCE (inInvNumber, '')) = '' -- AND vbUserId <> '9457'
        AND EXISTS (SELECT 1
                    FROM MovementLinkObject AS MovementLinkObject_OrderFinance
                         -- если Заполнение № заявки 1С = ДА
                         INNER JOIN ObjectBoolean AS ObjectBoolean_InvNumber
                                                  ON ObjectBoolean_InvNumber.ObjectId  = MovementLinkObject_OrderFinance.ObjectId
                                                 AND ObjectBoolean_InvNumber.DescId    = zc_ObjectBoolean_OrderFinance_InvNumber()
                                                 AND ObjectBoolean_InvNumber.ValueData = TRUE
                    WHERE MovementLinkObject_OrderFinance.MovementId = inMovementId
                      AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                   )

     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <№ заявки (1С)>.';
     END IF;

     -- проверка - <Товар (Заявка ТМЦ)>
     IF TRIM (COALESCE (inGoodsName, '')) = '' -- AND vbUserId <> '9457'
        AND EXISTS (SELECT 1
                    FROM MovementLinkObject AS MovementLinkObject_OrderFinance
                         -- если Заполнение № заявки 1С = ДА
                         INNER JOIN ObjectBoolean AS ObjectBoolean_InvNumber
                                                  ON ObjectBoolean_InvNumber.ObjectId  = MovementLinkObject_OrderFinance.ObjectId
                                                 AND ObjectBoolean_InvNumber.DescId    = zc_ObjectBoolean_OrderFinance_InvNumber()
                                                 AND ObjectBoolean_InvNumber.ValueData = TRUE

                    WHERE MovementLinkObject_OrderFinance.MovementId = inMovementId
                      AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Товар (Заявка ТМЦ)>.';
     END IF;

     -- нашли дату начала недели
     vbOperDate_start:= (SELECT zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData)
                         FROM Movement
                              LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                      ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                     AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                         WHERE Movement.Id = inMovementId
                        );

     -- проверка
     IF COALESCE (inOperDate_Amount_next, zc_DateStart()) NOT BETWEEN vbOperDate_start + INTERVAL '0 DAY' AND vbOperDate_start + INTERVAL '4 DAY'
     THEN
 	   RAISE EXCEPTION 'Ошибка.Дата План = <%>%.Должна быть в периоде с <%> по <%>.'
                        , zfConvert_DateToString (inOperDate_Amount_next)
                        , CHR (13)
                        , zfConvert_DateToString (vbOperDate_start)
                        , zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY')
                         ;
     END IF;


     -- сохранили <Элемент документа> - Первичный план на неделю
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), NULL, inMovementId, inAmount, inParentId);

     -- сохранили свойство <Платежный план на неделю>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_next(), ioId, inAmount_next);
     -- сохранили свойство <Дата Платежный план на неделю>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Amount_next(), ioId, inOperDate_Amount_next);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), ioId, CASE WHEN COALESCE (inGoodsName,'') = '' THEN NULL ELSE inGoodsName END);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumber(), ioId, CASE WHEN COALESCE (inInvNumber,'') = '' THEN NULL ELSE inInvNumber END);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumber_Invoice(), ioId, CASE WHEN COALESCE (inInvNumber_Invoice,'') = '' THEN NULL ELSE inInvNumber_Invoice END);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


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
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);

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
