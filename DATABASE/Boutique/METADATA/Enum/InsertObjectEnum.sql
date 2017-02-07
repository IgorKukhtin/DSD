-- создаются функции
DO $$
BEGIN

   -- Добавляем роли:
   -- zc_Enum_Role_Admin
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= 'Роль администратора', inEnumName:= 'zc_Enum_Role_Admin');

END $$;



DO $$
DECLARE ioId integer;
DECLARE UserId integer;
BEGIN
   -- Нельзя вставить штатными средствами потому что не сработает проверка прав!!!
   SELECT Id INTO UserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';

   IF COALESCE(UserId, 0) = 0 THEN
     -- Создаем администратора
     UserId := lpInsertUpdate_Object(0, zc_Object_User(), 0, 'Админ');

     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), UserId, 'Админ');
   END IF;

   IF NOT EXISTS(SELECT * FROM OBJECT

     JOIN ObjectLink AS UserRole_Role
       ON UserRole_Role.descid = zc_ObjectLink_UserRole_Role()
      AND UserRole_Role.childobjectid = zc_Enum_Role_Admin()
      AND UserRole_Role.objectid = OBJECT.id

     JOIN ObjectLink AS UserRole_User
       ON UserRole_User.descid = zc_ObjectLink_UserRole_User()
      AND UserRole_User.childobjectid = UserId
      AND UserRole_User.objectid = OBJECT.id
  WHERE OBJECT.descid = zc_Object_UserRole()) THEN

     -- Соединяем пользователя с ролью
     ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_Role(), ioId, zc_Enum_Role_Admin());

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_User(), ioId, UserId);
   END IF;
END $$;




/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
*/
