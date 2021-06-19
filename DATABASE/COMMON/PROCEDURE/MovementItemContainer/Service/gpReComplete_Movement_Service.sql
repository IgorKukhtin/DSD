-- Function: gpReComplete_Movement_Service(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Service (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Service(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Service());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Service())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Service_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_Service (inMovementId     := inMovementId
                                        , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.21        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 1794 , inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1794 , inSession:= '2')

