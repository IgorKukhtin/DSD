-- Function: gpInsertUpdate_Object_User()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId                     Integer   ,    -- ключ объекта <Пользователь> 
    IN inCode                   Integer   ,    -- 
    IN inUserName               TVarChar  ,    -- главное Название пользователя объекта <Пользователь> 
    IN inPassword               TVarChar  ,    -- пароль пользователя 
    IN inSign                   TVarChar  ,    -- Электронная подпись
    IN inSeal                   TVarChar  ,    -- Электронная печать
    IN inKey                    TVarChar  ,    -- Электроный Ключ 
    IN inProjectMobile          TVarChar  ,    -- Серийный № моб устр-ва
    IN inisProjectMobile        Boolean   ,    -- признак - это Торговый агент
    IN inisSite                 Boolean   ,    -- признак - Для сайта
    IN inMemberId               Integer   ,    -- физ. лицо
    IN inPasswordWages          TVarChar  ,    -- пароль пользователя 
    IN inisWorkingMultiple      Boolean   ,    -- Работа на нескольких аптеках
    IN inisNewUser              Boolean   ,    -- Новый сотрудник
    IN inisDismissedUser        Boolean   ,    -- Уволенный сотрудник
    IN inisInternshipCompleted  Boolean   ,    -- Стажировка проведена
    IN inSession                TVarChar       -- сессия пользователя
)
  RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- проверка уникальности для свойства <Наименование Пользователя>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_User(), inCode);

   IF COALESCE (ioId, 0) = 0
   THEN
     inisNewUser := TRUE;
     inisDismissedUser := FALSE;
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), inCode, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Sign(), ioId, inSign);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Seal(), ioId, inSeal);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Key(), ioId, inKey);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_ProjectMobile(), ioId, inProjectMobile);

   IF COALESCE (inisSite, FALSE) = TRUE AND COALESCE (inisNewUser, FALSE) = TRUE AND
      NOT EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId 
                                                AND ObjectBoolean.DescId = zc_ObjectBoolean_User_Site() 
                                                AND ObjectBoolean.ValueData = TRUE)
   THEN
     inisNewUser := FALSE;
   END IF;

   -- свойство <Для сайта>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_Site(), ioId, inisSite);
       
   -- свойство <Работа на нескольких аптеках>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_WorkingMultiple(), ioId, inisWorkingMultiple);
       
   IF inisProjectMobile = TRUE
   THEN
       -- всегда меняем
       PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_ProjectMobile(), ioId, inisProjectMobile);
   ELSEIF EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile())
   THEN
       -- тогда меняем
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_ProjectMobile(), ioId, inisProjectMobile);
   -- ИНАЧЕ - останется NULL
   END IF;

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_Member(), ioId, inMemberId);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_PasswordWages(), ioId, inPasswordWages);

   -- свойство <Новый сотрудник>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_NewUser(), ioId, inisNewUser);
   -- свойство <Уволенный сотрудник>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_DismissedUser(), ioId, inisDismissedUser);

   IF COALESCE (inisInternshipCompleted, FALSE) <>
      COALESCE((SELECT ObjectBoolean.ValueData 
                FROM ObjectBoolean 
                WHERE ObjectBoolean.ObjectId = ioId 
                  AND ObjectBoolean.DescId = zc_ObjectBoolean_User_InternshipCompleted()), FALSE)
   THEN
     -- свойство <Стажировка проведена>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_InternshipCompleted(), ioId, inisInternshipCompleted);
     
     if COALESCE (inisInternshipCompleted, FALSE) = TRUE
     THEN
       -- свойство <Подтверждение стажировки>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_User_InternshipConfirmation(), ioId, 0);
       -- свойство <Дата подтверждения стажировки>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_InternshipCompleted(), ioId, CURRENT_DATE);
     ELSE
       IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       THEN
         RAISE EXCEPTION 'Отменить <Стажировка проведена>. Разрешено только системному администратору';
       END IF;     
     END IF;
   END IF;


   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.08.19                                                       *
 06.11.17         * inisSite
 21.04.17         *
 12.09.16         *
 07.06.13                                        * lpCheckRight
*/

-- select ObjectCode from Object where DescId = zc_Object_User() group by ObjectCode having count (*) > 1
-- select ValueData from Object where DescId = zc_Object_User() group by ValueData having count (*) > 1

-- тест
-- SELECT * FROM gpInsertUpdate_Object_User ('2')