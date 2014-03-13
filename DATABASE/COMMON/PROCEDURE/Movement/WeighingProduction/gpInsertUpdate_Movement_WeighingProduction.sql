-- Function: gpInsertUpdate_Movement_WeighingProduction()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingProduction(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ  Взвешивание (производство)>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

    IN inParentId            Integer   , -- Документ родитель
    IN inStartWeighing       TDateTime , -- Протокол начало взвешивания
    IN inEndWeighing         TDateTime , -- Протокол окончание взвешивания

    IN inMovementDesc        TFloat    , -- Вид документа
 
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inUserId              Integer   , -- Пользователь

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingProduction(), inInvNumber, inOperDate, inParentId, vbAccessKeyId);

     -- сохранили свойство <Протокол начало взвешиванияа>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, inStartWeighing);
     -- сохранили свойство <Протокол окончание взвешивания>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighingr(), ioId, inEndWeighingr);
     
     -- сохранили свойство <Вид документа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDesc);
 
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Пользователь>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, inUserId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_WeighingProduction (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
