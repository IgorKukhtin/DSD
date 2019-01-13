-- Function: gpInsertUpdate_Movement_IncomeCost()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeCost (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeCost(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- От кого (в документе)
    IN inMovementId          Integer   , --
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());


     PERFORM lpInsertUpdate_Movement_IncomeCost (ioId         := ioId
                                               , inParentId   := inParentId          -- док приход
                                               , inMovementId := inMovementId        -- док услуг
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
