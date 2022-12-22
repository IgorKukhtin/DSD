-- Function: gpComplete_Movement_Payment()

DROP FUNCTION IF EXISTS gpComplete_Movement_Payment  (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Payment  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Payment(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_BankAccount());
    
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);
	
    -- собственно проводки
    PERFORM lpComplete_Movement_Payment(inMovementId, -- ключ Документа
                                     vbUserId);    -- Пользователь  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
	
    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inMovementId, inSession;
    END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 13.10.15                                                         *
 */

-- select * from gpComplete_Movement_Payment(inMovementId := 30410865 ,  inSession := '3');