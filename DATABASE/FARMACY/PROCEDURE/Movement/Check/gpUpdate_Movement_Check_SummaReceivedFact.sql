-- Function: gpUpdate_Movement_Check_SummaReceivedFact()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SummaReceivedFact(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SummaReceivedFact(
    IN inMovementId                Integer   , -- Ключ объекта <Документ>
    IN inSummaReceivedFact         TFloat    , --Сумма получено по факту
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 6534523))
  THEN
    RAISE EXCEPTION 'Изменение признака <Сумма получено по факту> вам запрещено.';
  END IF;
      
  IF COALESCE(inSummaReceivedFact, 0) < 0
  THEN
    RAISE EXCEPTION 'Сумма <Сумма получено по факту> должна быть положительной.';
  END IF;
  
  IF COALESCE(inSummaReceivedFact, 0) <> 0 AND
     EXISTS(SELECT * FROM  MovementBoolean AS MovementBoolean_RetrievedAccounting
            WHERE MovementBoolean_RetrievedAccounting.MovementId =  inMovementId
              AND MovementBoolean_RetrievedAccounting.DescId = zc_MovementBoolean_RetrievedAccounting()
              AND COALESCE(MovementBoolean_RetrievedAccounting.ValueData, False) = True)
  THEN
    RAISE EXCEPTION 'Установлен признак <Получено бухгалтерией> заполнена <Сумма получено по факту> нельзя.';
  END IF;
    
  IF COALESCE(inSummaReceivedFact, 0) >= COALESCE((SELECT MovementFloat_TotalSumm.ValueData FROM  MovementFloat AS MovementFloat_TotalSumm
                                                  WHERE MovementFloat_TotalSumm.MovementId =  inMovementId
                                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()), 0)
  THEN
    RAISE EXCEPTION 'Сумма <Сумма получено по факту> должна быть меньше суммы чека.';
  END IF;
  
  --Меняем Сумма получено по факту
  Perform lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), inMovementId, inSummaReceivedFact);
  
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 29.07.21                                                                    *
*/

-- тест