-- Function: gpReComplete_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Inventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Inventory());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Inventory())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- Временно - для филиалов
     IF vbUserId = 5 AND 1=0
     THEN PERFORM gpInsertUpdate_MovementItem_Inventory_Amount (inMovementId := inMovementId
                                                              , inSession    := inSession
                                                               );
     END IF;


     -- Проводим Документ
     PERFORM gpComplete_Movement_Inventory (inMovementId     := inMovementId
                                          , inIsLastComplete := TRUE
                                          , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.05.15                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_Inventory (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
