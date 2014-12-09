-- Function: gpComplete_Movement_TransportIncome()

DROP FUNCTION IF EXISTS gpComplete_Movement_TransportIncome (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TransportIncome(
    IN inMovementId        Integer                , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT False , -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TransportIncome_noFind());


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.10.13         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_TransportIncome (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_TransportIncome (inMovementId:= 149639, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_TransportIncome (inMovementId:= 149639, inSession:= '2')
