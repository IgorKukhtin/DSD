-- Function: gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionUnion(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inDocumentKindId      Integer   , -- Тип документа (в документе)
    IN inSubjectDocId        Integer               , --
    IN inIsPeresort          Boolean   , -- пересорт
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());

   -- сохранили <Документ>
   ioId := lpInsertUpdate_Movement_ProductionUnion (ioId             := ioId
                                                  , inInvNumber      := inInvNumber
                                                  , inOperDate       := inOperDate
                                                  , inFromId         := inFromId
                                                  , inToId           := inToId
                                                  , inDocumentKindId := inDocumentKindId 
                                                  , inIsPeresort     := inIsPeresort
                                                  , inUserId         := vbUserId
                                                   );
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.10.23         * inSubjectDocId
 13.06.16         *
 20.03.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProductionUnion (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
