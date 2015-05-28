-- Function: gpSetErased_Movement_WeighingPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_WeighingPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_WeighingPartner(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_WeighingPartner());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.05.15                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_WeighingPartner (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
