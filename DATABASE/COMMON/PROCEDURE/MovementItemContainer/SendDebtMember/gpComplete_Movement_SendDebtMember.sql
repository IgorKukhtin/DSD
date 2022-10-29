-- Function: gpComplete_Movement_SendDebtMember (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_SendDebtMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SendDebtMember(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebtMember());

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_SendDebtMember (inMovementId := inMovementId
                                               , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.22         * 
*/

-- тест
-- 