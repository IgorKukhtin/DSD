-- Function: gpReComplete_Movement_SendOnPrice(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SendOnPrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SendOnPrice(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendOnPrice());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendOnPrice())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.08.15                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_SendOnPrice (inMovementId:= 2688640, inSession:= zfCalc_UserAdmin()) -- zc_Enum_Process_Auto_PrimeCost() :: TVarChar
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
