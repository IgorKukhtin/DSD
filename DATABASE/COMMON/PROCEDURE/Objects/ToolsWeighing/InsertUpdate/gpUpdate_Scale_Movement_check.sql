-- Function: gpUpdate_Scale_Movement_check()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_check(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (isOk        Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     IF EXISTS (SELECT MovementId FROM MovementItem WHERE MovementId = inMovementId AND isErased = FALSE)
     THEN
         -- Результат
         RETURN QUERY
           SELECT FALSE;
     ELSE
         -- Результат
         RETURN QUERY
           SELECT TRUE;
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.02.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_Movement_check (inMovementId:= 0, inSession:= '2')
