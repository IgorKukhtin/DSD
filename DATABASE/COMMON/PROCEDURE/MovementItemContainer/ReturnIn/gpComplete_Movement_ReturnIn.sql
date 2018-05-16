-- Function: gpComplete_Movement_ReturnIn()

-- DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ключ Документа
    IN inStartDateSale     TDateTime             , --
   OUT outMessageText      Text                  ,
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
     -- Проводим Документ
     outMessageText:= lpComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                                  , inStartDateSale  := inStartDateSale
                                                  , inUserId         := vbUserId
                                                  , inIsLastComplete := inIsLastComplete
                                                   );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.05.18         *
 08.11.14                                        * add _tmpList_Alternative
 17.08.14                                        * add MovementDescId
 22.07.14                                        * add ...Price
 05.05.14                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnIn (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
