-- Function: gpUpdate_Movement_Check_DateMessage()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_DateMessage(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_DateMessage(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inCheckSourceKindId   Integer   , -- Источник
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF COALESCE(inCheckSourceKindId, 0) <> zc_Enum_CheckSourceKind_Tabletki()
  THEN
    RETURN 0;
  END IF;

  raise notice 'Value 05: % % %', inMovementId, inCheckSourceKindId, inSession;
  
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) OR
    NOT EXISTS(SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_CashierPharmacy()) 
  THEN
    RETURN 0;
  END IF;

  IF EXISTS(SELECT * FROM MovementBoolean 
            WHERE MovementBoolean.DescId = zc_MovementBoolean_AccruedFine()
              AND MovementBoolean.MovementId = inMovementId)
  THEN
    RETURN 0;
  END IF;

   
  IF NOT EXISTS(SELECT * FROM MovementDate 
                WHERE MovementDate.DescId = zc_MovementDate_Message()
                  AND MovementDate.MovementId = inMovementId)
  THEN
    --Меняем признак Дата время сообщения
    PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Message(), inMovementId, CURRENT_TIMESTAMP);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
    
  ELSEIF (SELECT MovementDate.ValueData FROM MovementDate 
          WHERE MovementDate.DescId = zc_MovementDate_Message()
            AND MovementDate.MovementId = inMovementId) < CURRENT_TIMESTAMP - INTERVAL '31 MINUTE'
  THEN 
    --Меняем признак Начислить штраф
    PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_AccruedFine(), inMovementId, TRUE);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);  
  END IF;

  -- !!!ВРЕМЕННО для ТЕСТА!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION 'Тест прошел успешно для % % %', inMovementId, inCheckSourceKindId, inSession;
  END IF;
              
  RETURN 1;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 15.04.21                                                                    *
*/

-- тест