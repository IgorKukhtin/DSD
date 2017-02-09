-- Function: gpComplete_Movement_Cost()

DROP FUNCTION IF EXISTS gpComplete_Movement_Cost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Cost(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());

     vbDescId := (SELECT CASE WHEN Movement.DescId = zc_Movement_Service() THEN zc_Movement_CostService() 
                              WHEN Movement.DescId = zc_Movement_Transport() THEN zc_Movement_CostTransport()
                         END 
                  FROM Movement WHERE Movement.Id = inMovementId);

     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbDescId
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.04.16         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Cost (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
