-- Function: gpInsertUpdate_Movement_Cash_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash_Child (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash_Child(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inMI_Id                Integer   , -- идентификатор строки
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmount               TFloat    , -- Сумма
    IN inCashId               Integer   , -- касса 
    IN inUnitId               Integer   , -- отдел
    IN inInfoMoneyId          Integer   , -- Статьи
    IN inInfoMoneyDetailId    Integer   , -- Детали
    IN inCommentInfoMoneyId   Integer   , -- Примечание
    IN inUserId               Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.<Статья> не выбрана.';
     END IF;

     -- проверка
     IF COALESCE (ioId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.MovementId = 0.';
     END IF;

     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- сохранили <Документ>
     -- ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Cash(), inInvNumber, inOperDate, Null, inUserId);

     -- определяем <Элемент документа>
     --SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inMI_Id, 0) = 0;

     -- сохранили <Элемент документа>
     inMI_Id := lpInsertUpdate_MovementItem (inMI_Id, zc_MI_Child(), inCashId, ioId, inAmount, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), inMI_Id, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), inMI_Id, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoneyDetail(), inMI_Id, inInfoMoneyDetailId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), inMI_Id, inCommentInfoMoneyId);

     -- сохранили свойство <Дата начисления>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), inMI_Id, inServiceDate);

 
      -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMI_Id, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.22         *
 */

-- тест
--