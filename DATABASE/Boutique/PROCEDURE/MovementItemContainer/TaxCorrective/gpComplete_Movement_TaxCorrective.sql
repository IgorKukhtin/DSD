-- Function: gpComplete_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpComplete_Movement_TaxCorrective (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_TaxCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TaxCorrective(
    IN inMovementId        Integer               , -- ключ Документа
   OUT ouStatusCode        Integer               , -- Статус документа. Возвращается который должен быть
   OUT outMessageText      Text                  ,
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TaxCorrective());

     -- Проводим Документ
     outMessageText:= lpComplete_Movement_TaxCorrective (inMovementId := inMovementId
                                                       , inUserId     := vbUserId);

     -- Вернули статус (вдруг он не изменился)
     ouStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Манько Д.А.
 06.05.14                                        * add lpComplete_Movement_TaxCorrective
 14.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_TaxCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
