-- Function: gpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StoreReal(
 INOUT ioId           Integer   , -- Ключ объекта <Документ Перемещение>
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
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

      -- Сохранение
      ioId:= lpInsertUpdate_Movement_StoreReal (ioId        := ioId
                                              , inInvNumber := inInvNumber
                                              , inOperDate  := inOperDate
                                              , inUserId    := vbUserId
                                              , inPartnerId := inPartnerId
                                              , inGUID      := NULL
                                              , inComment   := inComment
                                               );

      SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inPartnerId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_StoreReal (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inPartnerId:= 0, inComment:= 'тестовый факт', inSession:= '5')
