﻿-- Function: gpInsertUpdate_Object_RoleProcess()

-- DROP FUNCTION gpInsertUpdate_Object_RoleProcess();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleProcess(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inRoleId         Integer   ,     -- Роль
    IN inProcessId      Integer   ,     -- Процесс
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_RoleProcess());

   UserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');

   -- сохранили связь с <Ролью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleRight_Role(), ioId, inRoleId);
   -- сохранили связь с <Действием>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleRight_Process(), ioId, inProcessId);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RoleProcess (Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RoleProcess()