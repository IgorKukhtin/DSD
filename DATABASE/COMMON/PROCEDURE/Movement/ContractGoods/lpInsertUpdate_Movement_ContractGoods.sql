-- Function: lpInsertUpdate_Movement_ContractGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ContractGoods(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа / С какой даты действует
    IN inEndBeginDate        TDateTime , -- По какую дату действует
    IN inContractId          Integer   , --
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF vbIsInsert = TRUE
     THEN
         ioInvNumber := CAST (NEXTVAL ('Movement_ContractGoods_seq') AS TVarChar);
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ContractGoods(), ioInvNumber, inOperDate, NULL, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили свойство <Дата создания>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, inEndBeginDate);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.21         *
*/

-- тест
-- 