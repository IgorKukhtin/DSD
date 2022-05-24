-- Function: gpInsertUpdate_Object_NewUser()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_NewUser (Integer, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_NewUser(
 INOUT ioId          Integer ,      -- Id
    IN inName        TVarChar,      -- ФИО
    IN inPhone       TVarChar,      -- Нномер телефона
    IN inPositionId  Integer ,      -- Должность
    IN inUnitId      Integer ,      -- Подразделение
    IN inLogin       TVarChar,      -- Логин 
    IN inPassword    TVarChar,      -- Пароль 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMember Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 1633980))
   THEN
     RAISE EXCEPTION 'Создание нового пользователя вам запрещено.';
   END IF;
   
   inName := TRIM(inName);     
   inLogin := TRIM(inLogin);     
   inPassword := TRIM(inPassword);     
   WHILE POSITION ('  ' in inName) > 0 LOOP
     inName := REPLACE (inName, '  ', ' ');
   END LOOP;
   
   IF EXISTS (SELECT 1
              FROM Object AS Object_User
              WHERE Object_User.DescId = zc_Object_User()
                AND upper(TRIM(Object_User.ValueData)) = upper(inLogin))
   THEN
     RAISE EXCEPTION 'Логин <%> уже занят.', inLogin;
   END IF;  
   
   IF COALESCE (inName, '') = ''
   THEN
     RAISE EXCEPTION 'Не заполнено <ФИО>.';
   END IF;

   IF COALESCE (inPhone, '') = ''
   THEN
     RAISE EXCEPTION 'Не заполнен <Номер телефона>.';
   END IF;

   IF NOT EXISTS (SELECT 1
                  FROM Object AS Object_Position
                  WHERE Object_Position.DescId = zc_Object_Position()
                    AND Object_Position.ObjectCode in (1, 2)
                    AND Object_Position.Id = inPositionId)
   THEN
     RAISE EXCEPTION 'Должность длжна быть <%> или <%>.'
           , (SELECT Object_Position.ValueData
                  FROM Object AS Object_Position
                  WHERE Object_Position.DescId = zc_Object_Position()
                    AND Object_Position.ObjectCode = 1)
           , (SELECT Object_Position.ValueData
                  FROM Object AS Object_Position
                  WHERE Object_Position.DescId = zc_Object_Position()
                    AND Object_Position.ObjectCode = 2);
   END IF;
  
   IF NOT EXISTS (SELECT 1
                  FROM Object AS Object_Unit
                  WHERE Object_Unit.DescId = zc_Object_Unit()
                    AND Object_Unit.Id = inUnitId)
   THEN
     RAISE EXCEPTION 'Не выбрано <Подразделение>.';
   END IF;

   IF COALESCE (inLogin, '') = ''
   THEN
     RAISE EXCEPTION 'Не заполнен <Логин>.';
   END IF;

   IF COALESCE (inPassword, '') = ''
   THEN
     RAISE EXCEPTION 'Не заполнен <Пароль>.';
   END IF;
   
   vbMember := gpInsertUpdate_Object_Member_Lite(ioId            := 0
                                               , inName          := inName
                                               , inPhone         := inPhone
                                               , inPositionID    := inPositionId
                                               , inUnitID        := inUnitId
                                               , inSession       := inSession);
                                               
   if inPositionId = (SELECT Object_Position.Id  FROM Object AS Object_Position
                      WHERE Object_Position.DescId = zc_Object_Position()
                        AND Object_Position.ObjectCode = 1)
   THEN
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Education(), vbMember, 1658917);   
   END IF;
                                               
   ioId := gpInsertUpdate_Object_User_Lite(ioId          := 0
                                         , inUserName    := inLogin
                                         , inPassword    := inPassword
                                         , inMemberId    := vbMember
                                         , inisNewUser   := True
                                         , inSession     := inSession);
                                         
   PERFORM gpInsertUpdate_Object_UserRole(ioId	     := 0
                                        , inUserId   := ioId
                                        , inRoleId   := 59588
                                        , inSession  := inSession);

   PERFORM gpInsertUpdate_Object_UserRole(ioId	     := 0
                                        , inUserId   := ioId
                                        , inRoleId   := zc_Enum_Role_CashierPharmacy()
                                        , inSession  := inSession);
   
   -- !!!ВРЕМЕННО для ТЕСТА!!!
   IF inSession = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%>', ioId, vbMember, inSession;
   END IF;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_NewUser (Integer, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.04.22                                                       *
*/

-- тест
-- 
select * from gpInsertUpdate_Object_NewUser(ioId := 0 , inName := 'Иванов Иван Иванович' , inPhone := '067 553-20-77' , inPositionId := 1672498 , inUnitId := 183289 , inLogin := 'Иванов Иван' , inPassword := '123456' ,  inSession := '3');
