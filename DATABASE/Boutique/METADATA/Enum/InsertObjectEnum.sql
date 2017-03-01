DO $$
BEGIN
   -- Добавляем роли:
   -- zc_Enum_Role_Admin
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= 'Роль администратора', inEnumName:= 'zc_Enum_Role_Admin');
END $$;


DO $$
DECLARE vbId integer;
DECLARE vbUserId integer;
BEGIN
   -- !!!Нельзя вставить штатными средствами потому что не сработает проверка прав!!!
   vbUserId:= (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ');

   IF COALESCE(vbUserId, 0) = 0
   THEN
       -- Создаем - Админ
       vbUserId := lpInsertUpdate_Object(0, zc_Object_User(), 0, 'Админ');
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), vbUserId, 'Админ');
   END IF;

   IF NOT EXISTS(SELECT 1
                 FROM Object
                      JOIN ObjectLink AS UserRole_Role
                                      ON UserRole_Role.descId = zc_ObjectLink_UserRole_Role()
                                     AND UserRole_Role.childObjectId = zc_Enum_Role_Admin()
                                     AND UserRole_Role.ObjectId = Object.Id
                      JOIN ObjectLink AS UserRole_User
                                      ON UserRole_User.descId = zc_ObjectLink_UserRole_User()
                                     AND UserRole_User.childObjectId = vbUserId
                                     AND UserRole_User.ObjectId = Object.Id
                 WHERE Object.descId = zc_Object_UserRole()
                )
   THEN
       -- Соединяем пользователя с ролью
       vbId := lpInsertUpdate_Object (vbId, zc_Object_UserRole(), 0, '');
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), vbId, zc_Enum_Role_Admin());
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), vbId, vbUserId);

   END IF;

END $$;


DO $$
BEGIN
     -- !!! Типы счетов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Active(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Активный', inEnumName:= 'zc_Enum_AccountKind_Active');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Passive(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Пассивный', inEnumName:= 'zc_Enum_AccountKind_Passive');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_All(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Активно/Пассивный', inEnumName:= 'zc_Enum_AccountKind_All');
END $$;

DO $$
BEGIN
 -- !!! Виды форм оплаты
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Var(), inDescId:= zc_Object_DiscountKind(), inCode:= 1, inName:= 'По накопительной системе' , inEnumName:= 'zc_Enum_DiscountKind_Var');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Const(), inDescId:= zc_Object_DiscountKind(), inCode:= 3, inName:= 'Постоянная скидка' , inEnumName:= 'zc_Enum_DiscountKind_Const');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Not(), inDescId:= zc_Object_DiscountKind(), inCode:= 2, inName:= 'Нет скидки' , inEnumName:= 'zc_Enum_DiscountKind_Not');

END $$;
