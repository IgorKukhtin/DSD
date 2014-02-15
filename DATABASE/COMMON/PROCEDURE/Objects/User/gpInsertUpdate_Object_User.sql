-- Function: gpInsertUpdate_Object_User()

-- DROP FUNCTION gpInsertUpdate_Object_User();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId          Integer   ,    -- ключ объекта <Пользователь> 
    IN inCode        Integer   ,    -- 
    IN inUserName    TVarChar  ,    -- главное Название пользователя объекта <Пользователь> 
    IN inPassword    TVarChar  ,    -- пароль пользователя 
    IN inMemberId    Integer   ,    -- физ. лицо
    IN inSession     TVarChar       -- сессия пользователя
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

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), inCode, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);
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
 07.06.13                                        * lpCheckRight
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_User ('2')
