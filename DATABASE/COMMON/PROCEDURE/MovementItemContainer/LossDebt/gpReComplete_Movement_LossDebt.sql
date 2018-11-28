-- Function: gpReComplete_Movement_LossDebt (Integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_LossDebt(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossDebt());

     IF inMovementId = 123096 -- № 15 от 31.12.2013
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не может быть распроведен.';
     END IF;


     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_LossDebt())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_LossDebt (inMovementId     := inMovementId
                                         , inUserId         := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 11541130, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_LossDebt (inMovementId:= 11541130, inSession:= zfCalc_UserAdmin())
