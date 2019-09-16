-- Function: gpSetErased_Movement_Wages (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Wages (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Wages(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.09.19                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_Wages (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
