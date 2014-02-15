-- Function: gpInsertUpdate_Object_RoleAction()

-- DROP FUNCTION gpInsertUpdate_Object_RoleAction();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleAction(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inRoleId         Integer   ,     -- Роль
    IN inActionId       Integer   ,     -- действие
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_RoleAction());

   UserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleAction(), 0, '');

   -- сохранили связь с <Ролью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleAction_Role(), ioId, inRoleId);
   -- сохранили связь с <Действием>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleAction_Action(), ioId, inActionId);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RoleAction (Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RoleAction()