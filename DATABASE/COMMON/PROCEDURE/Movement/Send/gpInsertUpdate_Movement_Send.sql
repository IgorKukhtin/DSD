-- Function: gpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inDocumentKindId      Integer   , -- Тип документа (в документе)
    IN inSubjectDocId        Integer   , -- Основание для перемещения
    IN inComment             TVarChar   , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Send (ioId               := ioId
                                         , inInvNumber        := inInvNumber
                                         , inOperDate         := inOperDate
                                         , inFromId           := inFromId
                                         , inToId             := inToId
                                         , inDocumentKindId   := inDocumentKindId
                                         , inSubjectDocId     := inSubjectDocId
                                         , inComment          := inComment
                                         , inUserId           := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.02.20         *
 06.02.20         * inDocumentKindId
 03.10.17         *
 17.06.16         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inDocumentKindId:= 1, inSubjectDocId:= 0, inComment:= '', inSession:= '2')
