-- Function: gpSetErased_wms_Movement_WeighingProduction (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_wms_Movement_WeighingProduction (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_wms_Movement_WeighingProduction (
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_WeighingProduction());

     -- Удаляем Документ
     UPDATE wms_Movement_WeighingProduction
            SET StatusId = zc_Enum_Status_Erased()
     WHERE wms_Movement_WeighingProduction.Id = inMovementId;

     /*PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);
     */


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.19         *
*/

-- тест
--