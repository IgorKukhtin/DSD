-- Function: gpUpdate_Movement_Check_UserReferals()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_UserReferals (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_UserReferals(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUserReferalsId    Integer   , -- Участие сотрудника
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin()))
    THEN
      RAISE EXCEPTION 'Изменение признака <Участие сотрудника> вам запрещено.';
    END IF;
    
    IF NOT EXISTS(SELECT MovementBoolean_MobileFirstOrder.MovementId 
                  FROM MovementBoolean AS MovementBoolean_MobileFirstOrder
                  WHERE MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                    AND MovementBoolean_MobileFirstOrder.MovementId = inMovementId
                    AND MovementBoolean_MobileFirstOrder.ValueData = TRUE)
    THEN
      RAISE EXCEPTION 'Изменение признака <Участие сотрудника> можно только на первую покупку.';
    END IF;    
        
    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserReferals(), inMovementId, inUserReferalsId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> ', inSession;
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.10.22                                                       *
*/
-- тест
-- 
select * from gpUpdate_Movement_Check_UserReferals(inMovementId := 29868898 , inUserReferalsId := 14468719 ,  inSession := '3');