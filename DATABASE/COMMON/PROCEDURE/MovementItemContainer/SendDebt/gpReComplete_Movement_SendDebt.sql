-- Function: gpReComplete_Movement_SendDebt(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SendDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SendDebt(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebt());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendDebt())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_SendDebt (inMovementId     := inMovementId
                                        , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.24                                        *
*/

-- тест
-- SELECT * FROM gpReComplete_Movement_SendDebt (inMovementId:= 29491314, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar)
