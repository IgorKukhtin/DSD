-- Function: gpReComplete_Movement_BankSecondNum(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_BankSecondNum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_BankSecondNum(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_BankSecondNum());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_BankSecondNum())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


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
 10.03.24         * 
*/

-- тест