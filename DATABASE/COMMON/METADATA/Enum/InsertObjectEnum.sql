DO $$
BEGIN
   -- Добавляем процессы
   PERFORM lpInsertUpdate_Object(zc_Object_Process_User(), zc_Object_Process(), 0, 'Изменение пользователей');

   -- Добавляем роли
   PERFORM lpInsertUpdate_Object(zc_Object_Role_Admin(), zc_Object_Role(), 0, 'Роль администратора');

   -- Добавляем формы оплаты
   PERFORM lpInsertUpdate_Object(zc_Object_PaidKind_FirstForm(),  zc_Object_PaidKind(), 1, 'Первая форма');
   PERFORM lpInsertUpdate_Object(zc_Object_PaidKind_SecondForm(), zc_Object_PaidKind(), 2, 'Вторая форма');

   -- Добавляем статусы !!! уже есть в НОВОЙ СХЕМЕ, надо будет потом удалить !!!
   PERFORM lpInsertUpdate_Object(zc_Object_Status_UnComplete(), zc_Object_Status(), 0, 'Не проведен');
   PERFORM lpInsertUpdate_Object(zc_Object_Status_Complete(), zc_Object_Status(), 1, 'Проведен');
   PERFORM lpInsertUpdate_Object(zc_Object_Status_Erased(), zc_Object_Status(), 2, 'Удален');

   -- Вставляем группы счетов
   PERFORM lpInsertUpdate_Object(zc_Object_AccountGroup_Inventory(), zc_Object_AccountGroup(), 1, 'Запасы');
   
   -- Вставляем аналитики счетов (место)
   PERFORM lpInsertUpdate_Object(zc_Object_AccountDirection_Store(), zc_Object_AccountDirection(), 1, 'на складах');
   
   -- Будем вставлять счета   
   PERFORM lpInsertUpdate_Object(zc_Object_Account_InventoryStoreEmpties(), zc_Object_Account(), 1, 'Запасы - на складахГП - Оборотная тара');
   PERFORM lpInsertUpdate_Object(zc_Object_Account_CreditorsSupplierMeat(), zc_Object_Account(), 1, 'Кредиторы - поставщики - Мясное сырье');

   -- Увеличиваем последовательность
   PERFORM setval('object_id_seq', (select max( id ) + 1 from Object));

END $$;

DO $$
DECLARE ioId integer;
BEGIN
   
   IF NOT EXISTS(SELECT * FROM OBJECT 
   JOIN ObjectLink AS RoleRight_Role 
     ON RoleRight_Role.descid = zc_ObjectLink_RoleRight_Role() 
    AND RoleRight_Role.childobjectid = zc_Object_Role_Admin()
    AND RoleRight_Role.objectid = OBJECT.id 
 
   JOIN ObjectLink AS RoleRight_Process 
     ON RoleRight_Process.descid = zc_ObjectLink_RoleRight_Process() 
    AND RoleRight_Process.childobjectid = zc_Object_Process_User()
    AND RoleRight_Process.objectid = OBJECT.id 
  WHERE OBJECT.descid = zc_Object_RoleRight()) THEN
     -- Создаем права роли администратора
     ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Role(), ioId, zc_Object_Role_Admin());
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Process(), ioId, zc_Object_Process_User());
   END IF;
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

     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Login(), UserId, 'Админ');

     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), UserId, 'Админ');
   END IF;

   IF NOT EXISTS(SELECT * FROM OBJECT 

     JOIN ObjectLink AS UserRole_Role 
       ON UserRole_Role.descid = zc_ObjectLink_UserRole_Role() 
      AND UserRole_Role.childobjectid = zc_Object_Role_Admin()
      AND UserRole_Role.objectid = OBJECT.id 
 
     JOIN ObjectLink AS UserRole_User 
       ON UserRole_User.descid = zc_ObjectLink_UserRole_User() 
      AND UserRole_User.childobjectid = UserId
      AND UserRole_User.objectid = OBJECT.id 
  WHERE OBJECT.descid = zc_Object_UserRole()) THEN

     -- Соединяем пользователя с ролью
     ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_Role(), ioId, zc_Object_Role_Admin());

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_User(), ioId, UserId);
   END IF;
END $$;


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

-- !!! Меняем автоинкрементное поле !!!
DO $$
BEGIN
PERFORM setval('object_id_seq', (select max (id) + 1 from Object));
END $$;

DO $$
BEGIN
     -- !!! ОБЯЗАТЕЛЬНО НАДО ЗАМЕНИТЬ zc_Object_Status_UnComplete -> zc_Enum_Status_UnComplete
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Object_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= 1, inName:= 'Не проведен', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Object_Status_Complete(), inDescId:= zc_Object_Status(), inCode:= 2, inName:= 'Проведен', inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Object_Status_Erased(), inDescId:= zc_Object_Status(), inCode:= 3, inName:= 'Удален', inEnumName:= 'zc_Enum_Status_Erased');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Active(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Не проведен', inEnumName:= 'zc_Enum_AccountKind_Active');


     -- !!! 
     -- !!! 1-уровень Управленческих Счетов
     -- !!! 
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_10000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_20000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_30000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_40000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_50000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_60000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_70000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_80000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 90000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_90000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 100000, inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_100000');

     -- !!! 
     -- !!! 2-уровень Управленческих Счетов
     -- !!! 
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30500,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30600,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30700,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30700');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70500,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70600,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70700,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70700');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70800,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70800');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70900,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70900');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 71000,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_71000');

     -- !!! 
     -- !!! 2-уровень Управленческих назначений
     -- !!! 
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10200');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20600, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20700, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20700');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_30100');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 02.07.13                                        * add 1-уровень Управленческих Счетов
 01.07.13                                        * add 2-уровень Управленческих назначений
 28.06.13                                        *
*/
