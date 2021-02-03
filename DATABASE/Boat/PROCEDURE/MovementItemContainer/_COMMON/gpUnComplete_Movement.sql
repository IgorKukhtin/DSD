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


     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


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
