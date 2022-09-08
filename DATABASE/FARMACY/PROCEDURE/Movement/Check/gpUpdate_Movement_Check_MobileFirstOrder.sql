-- Function: gpUpdate_Movement_Check__MobileFirstOrder()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_MobileFirstOrder(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_MobileFirstOrder(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inisMobileFirstOrder  Boolean   , -- Первая покупка и мобильном приложении
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF NOT EXISTS(SELECT 1
                FROM MovementBoolean
                WHERE MovementBoolean.DescId = zc_MovementBoolean_MobileFirstOrder()
                  AND MovementBoolean.MovementId = inMovementId
                  AND MovementBoolean.ValueData = inisMobileFirstOrder) 
  THEN

    -- Меняем признак Первая покупка и мобильном приложении
    Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_MobileFirstOrder(), inMovementId, inisMobileFirstOrder);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
    
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 23.01.20                                                                    *
*/

-- тест