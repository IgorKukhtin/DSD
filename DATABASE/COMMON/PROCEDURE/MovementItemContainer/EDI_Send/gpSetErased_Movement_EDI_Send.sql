-- Function: gpSetErased_Movement_EDI_Send (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_EDI_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_EDI_Send(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_EDI_Send());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.18         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_EDI_Send (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
