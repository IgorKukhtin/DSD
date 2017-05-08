-- Function: gpInsertUpdate_Movement_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Loss(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inCurrencyDocumentId   Integer   , -- Валюта (документа)
   OUT outCurrencyValue       TFloat    , -- курс валюты
   OUT outParValue            TFloat    , -- Номинал для перевода в валюту баланса
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Loss());
     
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_loss_seq') AS TVarChar);  
     END IF;

     outCurrencyValue := 1;
     outParValue := 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Loss (ioId                := ioId
                                         , inInvNumber         := ioInvNumber
                                         , inOperDate          := inOperDate
                                         , inFromId            := inFromId
                                         , inToId              := inToId
                                         , inCurrencyDocumentId:= inCurrencyDocumentId
                                         , inCurrencyValue     := outCurrencyValue
                                         , inParValue          := outParValue
                                         , inComment           := inComment
                                         , inUserId            := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.05.17         *
 25.04.17         *
 */

-- тест
-- select * from gpInsertUpdate_Movement_Loss(ioId := 17 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 311 , inToId := 311 , inCurrencyDocumentId := 353 , inComment := 'rfff' ,  inSession := '2');