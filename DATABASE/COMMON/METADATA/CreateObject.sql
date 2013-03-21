DO $$
BEGIN
   -- Добавляем процессы
   PERFORM lpInsertUpdate_Object(zc_Object_Process_User(), zc_Object_Process(), 0, 'Изменение пользователей');

   -- Добавляем роли
   PERFORM lpInsertUpdate_Object(zc_Object_Role_Admin(), zc_Object_Role(), 0, 'Роль администратора');

   -- Добавляем формы оплаты
   PERFORM lpInsertUpdate_Object(zc_Object_PaidType_FirstForm(),  zc_Object_PaidType(), 0, 'Первая форма');
   PERFORM lpInsertUpdate_Object(zc_Object_PaidType_SecondForm(), zc_Object_PaidType(), 0, 'Вторая форма');

   --  Добавляем статусы
   PERFORM lpInsertUpdate_Object(zc_Object_Status_UnComplete(), zc_Object_Status(), 0, 'Не проведен');
   PERFORM lpInsertUpdate_Object(zc_Object_Status_Complete(), zc_Object_Status(), 0, 'Проведен');
   PERFORM lpInsertUpdate_Object(zc_Object_Status_Erased(), zc_Object_Status(), 0, 'Удален');

   -- Формируем план счетов
   PERFORM lpInsertUpdate_Object(zc_Object_AccountPlan_Active(), zc_Object_AccountPlan(), 0, 'Активы');
   PERFORM lpInsertUpdate_Object(zc_Object_AccountPlan_Passive(), zc_Object_AccountPlan(), 0, 'Пассивы');

   -- Увеличиваем последовательность
   PERFORM setval('object_id_seq', (select max( id ) + 1 from Object));

END $$;

DO $$
DECLARE ioId integer;
BEGIN
   -- Создаем права администратору
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Role(), ioId, zc_Object_Role_Admin());

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Process(), ioId, zc_Object_Process_User());
END $$;

DO $$
DECLARE ioId integer;
DECLARE UserId integer;
BEGIN

   -- Создаем администратора
   UserId := lpInsertUpdate_Object(0, zc_Object_User(), 0, 'Админ');

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Login(), UserId, 'Админ');

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), UserId, 'Админ');

   -- Соединяем пользователя с ролью
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_Role(), ioId, zc_Object_Role_Admin());

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_User(), ioId, UserId);
END $$;