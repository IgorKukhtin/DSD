-- Function: gpInsertUpdate_Movement_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Visit (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Visit(
 INOUT ioId           Integer   , -- Ключ объекта <Документ>
    IN inInvNumber    TVarChar  , -- Номер документа
    IN inOperDate     TDateTime , -- Дата документа
    IN inPartnerId    Integer   , -- Контрагент
   OUT outPartnerName TVarChar  , -- Контрагент
    IN inComment      TVarChar  , -- Примечание
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS RECORD 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Visit());

      -- Сохранение
      ioId:= lpInsertUpdate_Movement_Visit (ioId        := ioId
                                              , inInvNumber := inInvNumber
                                              , inOperDate  := inOperDate
                                              , inPartnerId := inPartnerId
                                              , inComment   := inComment
                                              , inUserId    := vbUserId
                                               );

      SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inPartnerId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 26.03.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Visit (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inPartnerId:= 0, inComment:= 'тестовый факт', inSession:= '5')
