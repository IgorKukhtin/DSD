-- Function: gpInsertUpdate_Object_RoleProcess()

-- DROP FUNCTION gpInsertUpdate_Object_RoleProcess();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleProcess(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inRoleId         Integer   ,     -- Роль
    IN inProcessId      Integer   ,     -- Процесс
    IN inSession        TVarChar        -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inRoleId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Role>.';
   END IF;
   -- проверка
   IF COALESCE (inProcessId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Process>.';
   END IF;


   -- пытаемся найти
   IF COALESCE (ioId, 0) = 0
   THEN
       ioId:= (SELECT ObjectLink_RoleRight_Role.ObjectId
               FROM ObjectLink AS ObjectLink_RoleRight_Role
                    INNER JOIN ObjectLink AS ObjectLink_RoleRight_Process
                                          ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                         AND ObjectLink_RoleRight_Process.ChildObjectId = inProcessId
                                         AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
               WHERE ObjectLink_RoleRight_Role.ChildObjectId = inRoleId
                 AND ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
               LIMIT 1
              );
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');

   -- сохранили связь с <Ролью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleRight_Role(), ioId, inRoleId);
   -- сохранили связь с <Действием>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleRight_Process(), ioId, inProcessId);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RoleProcess()
