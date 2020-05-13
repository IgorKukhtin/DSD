-- Function: gpSetErased_Movement_ProjectsImprovements (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ProjectsImprovements (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ProjectsImprovements(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Удаление вам запрещено, обратитесь к системному администратору';
    END IF;

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.05.20                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_ProjectsImprovements (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
