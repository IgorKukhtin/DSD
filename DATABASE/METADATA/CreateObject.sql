DO $$
DECLARE ioId integer;
BEGIN
   -- Создаем права администратору
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');

   PERFORM lpInsertUpdate_ObjectEnum(zc_Object_RoleRight_Role(), ioId, zc_Enum_Role_Admin());

   PERFORM lpInsertUpdate_ObjectEnum(zc_Object_RoleRight_Process(), ioId, zc_Enum_Process_User());
END $$;

DO $$
DECLARE ioId integer;
DECLARE UserId integer;
BEGIN

   -- Создаем администратора
   UserId := lpInsertUpdate_Object(ioId, zc_Object_User(), 0, 'Админ');

   PERFORM lpInsertUpdate_ObjectString(zc_Object_User_Login(), UserId, 'Админ');

   PERFORM lpInsertUpdate_ObjectString(zc_Object_User_Password(), UserId, 'Админ');

   -- Соединяем пользователя с ролью
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

   PERFORM lpInsertUpdate_ObjectEnum(zc_Object_UserRole_Role(), ioId, zc_Enum_Role_Admin());

   PERFORM lpInsertUpdate_ObjectLink(zc_Object_UserRole_User(), ioId, UserId);
END $$;

