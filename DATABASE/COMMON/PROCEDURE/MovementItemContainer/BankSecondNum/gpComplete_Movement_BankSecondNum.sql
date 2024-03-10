-- Function: gpComplete_Movement_BankSecondNum (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_BankSecondNum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_BankSecondNum(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_BankSecondNum());

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_BankSecondNum (inMovementId := inMovementId
                                                     , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.02.24         *
*/

-- тест