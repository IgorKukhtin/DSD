-- Function: lpInsertUpdate_Movement_TestingTuning()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TestingTuning (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TestingTuning(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inTimeTest            Integer   , -- Время на тест (сек)
    IN inTimeTestStorekeeper Integer   , -- Время на тест Кладовщик (сек) 
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TestingTuning());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TestingTuning(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили <Комментарий маркетинга>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Time(), ioId, inTimeTest);
     -- сохранили <Комментарий маркетинга>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TimeStorekeeper(), ioId, inTimeTestStorekeeper);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.21                                                       *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TestingTuning (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticleTestingTuningId:= 1, inSession:= '3')