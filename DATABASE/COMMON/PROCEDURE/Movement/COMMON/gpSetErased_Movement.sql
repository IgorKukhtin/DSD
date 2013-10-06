-- Function: gpSetErased_Movement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSetErased_Movement (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement(
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
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_Movement());
     vbUserId:=2; -- CAST (inSession AS Integer);


     -- проверка - связанные документы Удалять нельзя
     PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'удалить');

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- Удаляем подчиненные Документы
     PERFORM lpSetErased_Movement (inMovementId := Movement.Id
                                 , inUserId     := vbUserId)
     FROM Movement
     WHERE ParentId = inMovementId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement (inMovementId:= 55, inIsChild := TRUE, inSession:= '2')
