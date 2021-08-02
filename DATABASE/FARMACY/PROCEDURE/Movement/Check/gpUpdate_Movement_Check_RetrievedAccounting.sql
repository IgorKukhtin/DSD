-- Function: gpUpdate_Movement_Check_RetrievedAccounting()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_RetrievedAccounting(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_RetrievedAccounting(
    IN inMovementId                Integer   , -- Ключ объекта <Документ>
    IN inisRetrievedAccounting     Boolean   , -- Получено бухгалтерией
   OUT outisRetrievedAccounting    Boolean   , -- Получено бухгалтерией
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 6534523))
  THEN
    RAISE EXCEPTION 'Изменение признака <Получено бухгалтерией> вам запрещено.';
  END IF;
  
  IF COALESCE(inisRetrievedAccounting, False) = False AND
     EXISTS(SELECT * FROM  MovementFloat AS MovementFloat_SummaReceivedFact
            WHERE MovementFloat_SummaReceivedFact.MovementId =  inMovementId
              AND MovementFloat_SummaReceivedFact.DescId = zc_MovementFloat_SummaReceivedFact()
              AND COALESCE(MovementFloat_SummaReceivedFact.ValueData, 0) <> 0)
  THEN
    RAISE EXCEPTION 'Заполнена <Сумма получено по факту> признака <Получено бухгалтерией> устанавливать нельзя.';
  END IF;
  
      
  --Меняем Получено бухгалтерией
  Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_RetrievedAccounting(), inMovementId, NOT inisRetrievedAccounting);
  
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

  outisRetrievedAccounting := NOT inisRetrievedAccounting;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 29.07.21                                                                    *
*/

-- тест