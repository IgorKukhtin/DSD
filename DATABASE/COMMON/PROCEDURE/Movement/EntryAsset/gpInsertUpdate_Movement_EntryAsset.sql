-- Function: gpInsertUpdate_Movement_EntryAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EntryAsset (Integer, TVarChar, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EntryAsset(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EntryAsset());
                                              
    -- определяем ключ доступа
    -- vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_EntryAsset());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_EntryAsset(), inInvNumber, inOperDate, NULL);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.08.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EntryAsset (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
