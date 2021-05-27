-- Function: gpInsert_Object_RoleMask()

-- DROP FUNCTION gpInsert_Object_RoleMask (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_RoleMask(
 INOUT ioId	            Integer   ,     -- ключ объекта <Действия> 
    IN inCode           Integer   ,     -- Код объекта <Действия> 
    IN inName           TVarChar  ,     -- Название объекта <Действия>
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Role());

   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode(inCode, zc_Object_Role()); 
   
   -- проверка уникальности для свойства <Наименование Действия>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Role(), inName);
   -- проверка уникальности для свойства <Код Марки Действия>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Role(), inCode);


   -- сохранили <Объект>
   vbId  := lpInsertUpdate_Object(0, zc_Object_Role(), inCode, inName);
   
   PERFORM gpInsertUpdate_Object_RoleAction (ioId       := 0
                                           , inRoleId   := vbId
                                           , inActionId := tmp.id
                                           , inSession := inSession) 
   FROM gpSelect_Object_RoleAction(inSession) AS tmp
   WHERE tmp.roleId = ioId; 
   
   PERFORM gpInsertUpdate_Object_RoleProcess(ioId := 0
                                           , inRoleId := vbId 
                                           , inProcessId := tmp.id 
                                           , inSession := inSession)
   FROM gpSelect_Object_RoleProcess(inSession) AS tmp
   WHERE tmp.roleId = ioId; 
/*   
   PERFORM gpInsertUpdate_Object_UserRole (ioId := 0 
                                        , inUserId := tmp.id
                                        , inRoleId := vbId
                                        , inSession := inSession)
   FROM gpSelect_Object_RoleUser(inSession) AS tmp
   WHERE tmp.roleId = ioId;
 */


   --select * from gpInsertUpdate_Object_UserRole(ioId := 14257 , inUserId := 78433 , RoleId := 9805 ,  inSession := '5');

   PERFORM gpInsertUpdate_Object_RoleProcessAccess(ioid := 0 
                                                 , inroleid := vbId 
                                                 , inprocessid := tmp.id 
                                                 , inSession := inSession)
   FROM gpSelect_Object_RoleProcessAccess(inSession) AS tmp
   WHERE tmp.roleId = ioId;

    ioId := vbId;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsert_Object_RoleMask (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.15         *

*/

-- тест
-- SELECT * FROM gpInsert_Object_RoleMask()

--select * from gpInsert_Object_RoleMask(ioId := 9805 , inCode := 9004 , inName := 'маска2' ,  inSession := '5');

