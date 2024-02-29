-- Function: gpSetErased_Movement_PersonalGroupSummAdd (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PersonalGroupSummAdd (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PersonalGroupSummAdd(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PersonalGroupSummAdd());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.02.24         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_PersonalGroupSummAdd (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
