-- Function: gpUnComplete_Movement_GoodsQuality (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_GoodsQuality (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_GoodsQuality(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_GoodsQuality());

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.15                                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_GoodsQuality (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
