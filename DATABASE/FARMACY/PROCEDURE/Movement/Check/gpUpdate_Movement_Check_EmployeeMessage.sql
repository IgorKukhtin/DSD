-- Function: gpUpdate_Movement_Check_EmployeeMessage()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_EmployeeMessage(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_EmployeeMessage(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inisEmployeeMessage     Boolean   , -- ОС от аптеки
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin()))
  THEN
    RAISE EXCEPTION 'Изменение признака <ОС от аптеки> вам запрещено.';
  END IF;
  
  --Меняем Получено бухгалтерией
  PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_EmployeeMessage(), inMovementId, not inisEmployeeMessage);
    
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 01.09.22                                                                    *
*/

-- тест

select * from gpUpdate_Movement_Check_EmployeeMessage(inMovementId := 28983728 , inisEmployeeMessage := 'False' ,  inSession := '3');