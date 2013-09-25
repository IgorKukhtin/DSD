-- Function: gpInsertUpdate_Object_UserRole()

-- DROP FUNCTION gpInsertUpdate_Object_UserRole();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserRole(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inUserId         Integer   ,     -- Пользователь
    IN inRoleId         Integer   ,     -- Роль
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UserRole());

   UserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

   -- сохранили связь с <Пользователем>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), ioId, inUserId);
   -- сохранили связь с <Ролью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), ioId, inRoleId);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_UserRole (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UserRole()