-- Function: gpInsertUpdate_Movement_PersonalTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalTransport (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalTransport(
 INOUT ioId                     Integer   , -- Ключ объекта <Документ>
    IN inInvNumber              TVarChar  , -- Номер документа
    IN inOperDate               TDateTime , -- Дата документа
    IN inServiceDate            TDateTime , -- Месяц начислений
    IN inPersonalServiceListId  Integer   , -- Ведомости начисления
    IN inComment                TVarChar  , -- Примечание
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalTransport());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_PersonalTransport (ioId                      := ioId
                                                      , inInvNumber               := inInvNumber
                                                      , inOperDate                := inOperDate
                                                      , inServiceDate             := inServiceDate
                                                      , inPersonalServiceListId   := inPersonalServiceListId 
                                                      , inComment                 := inComment
                                                      , inUserId                  := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.22         *
*/

-- тест
--