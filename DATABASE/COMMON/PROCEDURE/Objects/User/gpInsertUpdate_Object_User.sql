-- Function: gpInsertUpdate_Object_User()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId               Integer   ,    -- ключ объекта <Пользователь> 
    IN inCode             Integer   ,    -- 
    IN inUserName         TVarChar  ,    -- главное Название пользователя объекта <Пользователь> 
    IN inPassword         TVarChar  ,    -- пароль пользователя 
    IN inSign             TVarChar  ,    -- Электронная подпись
    IN inSeal             TVarChar  ,    -- Электронная печать
    IN inKey              TVarChar  ,    -- Электроный Ключ 
    IN inProjectMobile    TVarChar  ,    -- Серийный № моб устр-ва
    IN inPhoneAuthent     TVarChar  ,    -- № телефона для Аутентификации
    IN inisProjectMobile  Boolean   ,    -- признак - это Торговый агент
    IN inisProjectAuthent Boolean   ,    -- Аутентификация
    IN inMemberId         Integer   ,    -- физ. лицо
    IN inSession          TVarChar       -- сессия пользователя
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

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), inCode, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Sign(), ioId, inSign);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Seal(), ioId, inSeal);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Key(), ioId, inKey);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_ProjectMobile(), ioId, inProjectMobile);
   
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_PhoneAuthent(), ioId, inPhoneAuthent);
   
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_ProjectAuthent(), ioId, inisProjectAuthent);

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


   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.21         *
 21.04.17         *
 12.09.16         *
 07.06.13                                        * lpCheckRight
*/

-- select ObjectCode from Object where DescId = zc_Object_User() group by ObjectCode having count (*) > 1
-- select ValueData from Object where DescId = zc_Object_User() group by ValueData having count (*) > 1

-- тест
-- SELECT * FROM gpInsertUpdate_Object_User ('2')
