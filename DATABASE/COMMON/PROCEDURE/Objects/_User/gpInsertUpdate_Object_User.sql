-- Function: gpInsertUpdate_Object_User()

-- DROP FUNCTION gpInsertUpdate_Object_User();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId	         Integer   ,   	-- ключ объекта <Пользователь> 
    IN inUserName    TVarChar  ,    -- главное Название пользователя объекта <Пользователь> 
    IN inLogin       TVarChar  ,    -- логин пользователя 
    IN inPassword    TVarChar  ,    -- пароль пользователя 
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer 
  AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;  
     
BEGIN
   UserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- проверка уникальности для свойства <Наименование Пользователя>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_User(), inUserName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), 0, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Login(), ioId, inLogin);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);

   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol(ioId, UserId);
 
END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            