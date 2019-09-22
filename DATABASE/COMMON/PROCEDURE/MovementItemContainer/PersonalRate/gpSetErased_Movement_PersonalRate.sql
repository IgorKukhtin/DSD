-- Function: gpSetErased_Movement_PersonalRate (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PersonalRate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PersonalRate(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PersonalRate());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.19         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_PersonalRate (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
