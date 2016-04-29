-- Function: gpInsertUpdate_Movement_Cost()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cost (Integer, TVarChar, TDateTime, Integer, Tfloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cost (Integer, Integer, Tfloat, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cost(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- От кого (в документе)
    IN inMovementId          Tfloat    , -- 
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());

     
     PERFORM lpInsertUpdate_Movement_Cost ( ioId         := ioId
                                          , inParentId   := inParentId          --- док приход 
                                          , inMovementId := inMovementId        --- док сервис
                                          , inComment    := inComment
                                          , inUserId     := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.04.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cost (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inParentId:= 0, inMovementId:= 0, inComment:= 'xfdf', inSession:= '2')
