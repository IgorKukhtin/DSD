-- Function: gpReComplete_Movement_TransportGoods(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_TransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_TransportGoods(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TransportGoods());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_TransportGoods())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_TransportGoods()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.03.15                                        *
*/

-- тест
-- SELECT * FROM gpReComplete_Movement_TransportGoods (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
