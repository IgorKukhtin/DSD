-- Function: gpInsertUpdate_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalService (Integer, TVarChar, TDateTime, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalService(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inServiceDate         TDateTime , -- Дата начисления
    IN inComment             TVarChar  , -- Комментерий
    IN inPersonalServiceListId  Integer  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());
     vbUserId:= inSession;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_PersonalService (ioId           := ioId
                                         , inInvNumber               := inInvNumber
                                         , inOperDate                := inOperDate
                                         , inServiceDate             := inServiceDate
                                         , inComment                 := inComment
                                         , inPersonalServiceListId   := inPersonalServiceListId 
                                         , inUserId                  := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.09.14         *
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PersonalService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inServiceDate:= '01.01.2013', inComment:= 'xxx', inSession:= '2')