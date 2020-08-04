-- Function: gpComplete_Movement_ProfitIncomeService()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProfitIncomeService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProfitIncomeService(
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

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

/*
     -- !!!временно - округляем!!!
     UPDATE MovementItem SET Amount = CAST (MovementItem.Amount AS NUMERIC (16, 2))
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount <> CAST (MovementItem.Amount AS NUMERIC (16, 2))
    ;
*/

     -- проводим Документ
     PERFORM lpComplete_Movement_Service (inMovementId := inMovementId
                                        , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.07.20         * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProfitIncomeService (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
