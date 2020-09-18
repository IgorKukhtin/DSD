-- Function: gpSetErased_Movement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement(
    IN inMovementId Integer               , -- ключ объекта <Документ>
    IN inSession    TVarChar                -- текущий пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Movement());
      vbUserId:= lpGetUserBySession (inSession);
/*
     -- !!!Для Админа отключаем эти проверки, иначе из Sybase не загрузить!!!
     IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- проверка - если <Master> Проведен, то <Ошибка>
         PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

         -- проверка - если есть <Child> Проведен, то <Ошибка>
         PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');
     END IF;
*/
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income())
     THEN
         -- Удаляем Документ
         PERFORM gpSetErased_Movement_Income (inMovementId := inMovementId
                                            , inSession    := inSession);
     ELSE
         -- Удаляем Документ
         PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                     , inUserId     := vbUserId);
     END IF;

/*
     -- Удаляем подчиненные Документы
     PERFORM lpSetErased_Movement (inMovementId := Movement.Id
                                 , inUserId     := vbUserId)
     FROM Movement
     WHERE ParentId = inMovementId;
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.14                                        * add !!!Для Админа отключаем эти проверки, иначе из Sybase не загрузить!!!
 12.10.13                                        * del Удаляем подчиненные Документы
 12.10.13                                        * add lfCheck_Movement_ParentStatus and lfCheck_Movement_ChildStatus
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement (inMovementId:= 0, inIsChild := TRUE, inSession:= '2')
