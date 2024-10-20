-- Function: gpInsert_Movement_PersonalRate_Mask()

DROP FUNCTION IF EXISTS gpInsert_Movement_PersonalRate_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_PersonalRate_Mask(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ >
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalRate());

           -- сохранили <Документ>
     vbInvNumber := CAST (NEXTVAL ('movement_PersonalRate_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_PersonalRate(), vbInvNumber, inOperDate, NULL, 0);

     PERFORM gpInsertUpdate_Movement_PersonalRate (ioId           := vbMovementId
                                                 , inInvNumber    := vbInvNumber
                                                 , inOperDate     := inOperDate
                                                 , inComment      := '' ::TVarChar
                                                 , inPersonalServiceListId   := tmp.PersonalServiceListId
                                                 , inSession       := inSession
                                                  )
     FROM gpGet_Movement_PersonalRate (ioId, inOperDate, FALSE, inSession) AS tmp;


     -- записываем строки PersonalRateGoods документа
     PERFORM lpInsertUpdate_MovementItem_PersonalRate (ioId          := 0        
                                                     , inMovementId  := vbMovementId
                                                     , inPersonalId  := tmp.PersonalId
                                                     , inAmount      := tmp.Amount
                                                     , inComment     := tmp.Comment
                                                     , inUserId      := vbUserId
                                                      ) 
   FROM gpSelect_MovementItem_PersonalRate (ioId, False, False, inSession)  AS tmp;

   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  15.09.23        *
*/

-- тест
--