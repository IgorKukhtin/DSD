-- Function: gpUpdate_Movement_Check_RefusalConfirmed()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_RefusalConfirmed(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_RefusalConfirmed(
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inisRefusalConfirmed   Boolean   , -- Подтвержден отказ покупателя
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  -- Подтвержден отказ покупателя
  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RefusalConfirmed(), inMovementId, True);
  
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
  
  -- !!!ВРЕМЕННО для ТЕСТА!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inisRefusalConfirmed, inSession;
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.06.22                                                       *
*/

-- тест select * from gpUpdate_Movement_Check_RefusalConfirmed(inMovementId := 20526322 , inisConfirmedByPhoneCall := 'True' ,  inSession := '3');
