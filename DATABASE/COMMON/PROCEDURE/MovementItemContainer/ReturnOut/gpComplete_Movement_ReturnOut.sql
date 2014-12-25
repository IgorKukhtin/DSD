-- Function: gpComplete_Movement_ReturnOut(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnOut(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnOut());


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ReturnOut_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_ReturnOut (inMovementId     := inMovementId
                                          , inUserId         := vbUserId
                                          , inIsLastComplete := inIsLastComplete);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.08.14                                        * add MovementDescId
 26.04.14                                        * !!!RESTORE!!!
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnOut (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
