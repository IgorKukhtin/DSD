-- Function: gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionUnion(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inIsPeresort          Boolean   , -- пересорт
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());


   -- определяем ключ доступа
   vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Документ>
   ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProductionUnion(), inInvNumber, inOperDate, vbAccessKeyId);

   -- сохранили связь с <От кого (в документе)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
   -- сохранили связь с <Кому (в документе)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

   -- сохранили свойство <пересорт>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Peresort(), ioId, inIsPeresort);


   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.12.14                                        * add inIsPeresort
 03.06.14                                                        *
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProductionUnion (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
