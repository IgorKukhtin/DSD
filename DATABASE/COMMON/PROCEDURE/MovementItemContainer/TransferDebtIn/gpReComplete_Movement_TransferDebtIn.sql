-- Function: gpReComplete_Movement_TransferDebtIn(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_TransferDebtIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_TransferDebtIn(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outMessageText      Text                  ,
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TransferDebtIn());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_TransferDebtIn())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_TransferDebt_all_CreateTemp();
     -- Проводим Документ
     outMessageText:= lpComplete_Movement_TransferDebt_all (inMovementId     := inMovementId
                                                          , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.04.15                                        *
*/

-- тест
-- SELECT * FROM gpReComplete_Movement_TransferDebtIn (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
