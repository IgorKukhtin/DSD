-- Function: gpComplete_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderIncome (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderIncome(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderIncome());

     -- Проводим Документ
     PERFORM lpComplete_Movement_OrderIncome (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.07.16         *
 */

-- тест
--