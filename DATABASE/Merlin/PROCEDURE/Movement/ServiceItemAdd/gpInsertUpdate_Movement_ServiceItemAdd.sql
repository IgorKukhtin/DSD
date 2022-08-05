-- Function: gpInsertUpdate_Movement_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItemAdd(Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItemAdd(Integer, TVarChar, TDateTime, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ServiceItemAdd(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inComment              TVarChar  , --
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ServiceItemAdd());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_ServiceItemAdd (ioId        := ioId
                                                  , inInvNumber := inInvNumber
                                                  , inOperDate  := inOperDate
                                                  , inComment   := inComment
                                                  , inUserId    := vbUserId
                                                   );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.08.22         *
 10.06.22         *
 */

-- тест
--