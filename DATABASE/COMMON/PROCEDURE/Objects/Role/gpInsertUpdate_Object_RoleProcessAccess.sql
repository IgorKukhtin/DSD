-- Function: gpInsertUpdate_Object_RoleProcessAccess()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RoleProcessAccess(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleProcessAccess(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inRoleId         Integer   ,     -- Роль
    IN inProcessId      Integer   ,     -- Процесс
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_RoleProcess());

   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleProcessAccess(), 0, '');

   -- сохранили связь с <Ролью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleProcessAccess_Role(), ioId, inRoleId);
   -- сохранили связь с <Действием>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleProcessAccess_Process(), ioId, inProcessId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RoleProcessAccess (Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.13                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RoleProcessAccess()
