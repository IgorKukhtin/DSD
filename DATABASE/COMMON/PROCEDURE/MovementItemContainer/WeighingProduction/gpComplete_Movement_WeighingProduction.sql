-- Function: gpComplete_Movement_WeighingProduction (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_WeighingProduction (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_WeighingProduction(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_WeighingProduction());

     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingProduction()
                                , inUserId     := vbUserId
                                 );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.15                                        *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_WeighingProduction (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
