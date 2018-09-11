-- Function: lpInsertUpdate_Movement_TestingUser()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TestingUser (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TestingUser(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PriceList());
     vbUserId := inSession;

     -- приводим дату к первому числу месяца
     inOperDate := date_trunc('month', inOperDate);

     -- Ищем может уже создан Movement
     IF (COALESCE (ioId, 0) = 0) AND EXISTS(SELECT Id FROM Movement WHERE DescId = zc_Movement_TestingUser() AND OperDate = inOperDate)
     THEN
       SELECT Id
       INTO ioId
       FROM Movement
       WHERE DescId = zc_Movement_TestingUser()
         AND OperDate = inOperDate;
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TestingUser(), NULL, inOperDate, NULL);

     -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = TRUE
     THEN
       -- сохранили свойство <Дата создания>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
       -- сохранили свойство <Пользователь (создание)>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     END IF;

     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 11.09.18         *                                               *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TestingUser (ioId:= 0, inOperDate:= '01.09.2018', inSession:= '3')