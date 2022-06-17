-- Function: gpUpdate_Movement_Check_ConfirmedByPhoneCall()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ConfirmedByPhoneCall(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ConfirmedByPhoneCall(
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inisConfirmedByPhoneCall   Boolean   , -- Подтверждено по телефонному звонку
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  --Подтверждено по телефонному звонку
  IF inisConfirmedByPhoneCall = TRUE
  THEN
      -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), inMovementId, zc_Enum_ConfirmedKind_PhoneCall());
  ELSE
      -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), inMovementId, zc_Enum_ConfirmedKind_SmsNo());
  END IF;
  
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
  
  -- !!!ВРЕМЕННО для ТЕСТА!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inisConfirmedByPhoneCall, inSession;
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.06.22                                                       *
*/

-- тест select * from gpUpdate_Movement_Check_ConfirmedByPhoneCall(inMovementId := 20526322 , inisConfirmedByPhoneCall := 'True' ,  inSession := '3');

