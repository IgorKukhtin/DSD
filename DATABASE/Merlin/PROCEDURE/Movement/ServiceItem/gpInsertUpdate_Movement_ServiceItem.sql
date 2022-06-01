-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_ServiceItem (ioId                   := ioId
                                               , inInvNumber            := inInvNumber
                                               , inOperDate             := inOperDate
                                               , inUserId               := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.22         *
 */

-- тест
--