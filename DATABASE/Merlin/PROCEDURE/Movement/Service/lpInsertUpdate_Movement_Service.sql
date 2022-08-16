-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Service(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmount               TFloat    , -- Сумма
    IN inUnitId               Integer   , -- отдел
    IN inInfoMoneyId          Integer   , -- Статьи 
    IN inCommentInfoMoneyId   Integer   , -- Примечание
    IN inUserId               Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN

     if COALESCE (ioId, 0) = 0 then RAISE EXCEPTION 'Ошибка.insert. <%> <%> <%>', lfGet_Object_ValueData_sh (inUnitId), lfGet_Object_ValueData_sh (inInfoMoneyId), zfConvert_DateToString (inOperDate); END IF;
     if inOperDate <> (select OperDate from Movement where Id = ioId) then RAISE EXCEPTION 'Ошибка.OperDate. <%> <%> <%>  old = <%>', lfGet_Object_ValueData_sh (inUnitId), lfGet_Object_ValueData_sh (inInfoMoneyId), zfConvert_DateToString (inOperDate), zfConvert_DateToString ((select OperDate from Movement where Id = ioId)); END IF;

    -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.<Статья> не выбрана.';
     END IF;

     -- расчет - 1-ое число месяца
     -- inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- !!!замена!!!
     inServiceDate:= DATE_TRUNC ('MONTH', inOperDate);
     

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Service(), inInvNumber, inOperDate, NULL, inUserId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inUnitId, ioId, inAmount, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, inCommentInfoMoneyId);

     -- сохранили свойство <Дата начисления>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);

 
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
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

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