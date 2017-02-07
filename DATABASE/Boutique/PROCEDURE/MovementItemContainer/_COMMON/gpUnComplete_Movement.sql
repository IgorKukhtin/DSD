-- Function: gpUnComplete_Movement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement(
    IN inMovementId Integer               , -- ключ объекта <Документ>
--    IN inIsChild    Boolean  DEFAULT TRUE , -- есть ли у этого документа Подчиненные документы !!!ни в коем случае не ставить FALSE!!!
    IN inSession    TVarChar DEFAULT ''     -- текущий пользователь
)                              
  RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UnComplete_Movement());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

/*
     -- Распроводим подчиненные Документы
     PERFORM lpUnComplete_Movement (inMovementId := Movement.Id
                                  , inUserId     := vbUserId)
     FROM Movement
     WHERE ParentId = inMovementId;
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUnComplete_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.13                                        * del Распроводим подчиненные Документы
 12.10.13                                        * add lfCheck_Movement_ParentStatus
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 55, inIsChild := TRUE, inSession:= '2')
