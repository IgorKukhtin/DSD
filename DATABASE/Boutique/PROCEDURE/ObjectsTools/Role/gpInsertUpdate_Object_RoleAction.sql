-- Function: gpInsertUpdate_Object_RoleAction()

-- DROP FUNCTION gpInsertUpdate_Object_RoleAction();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleAction(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inRoleId         Integer   ,     -- Роль
    IN inActionId       Integer   ,     -- действие
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
   IF COALESCE (inActionId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Action>.';
   END IF;

   -- пытаемся найти
   IF COALESCE (ioId, 0) = 0
   THEN
       ioId:= (SELECT ObjectLink_RoleAction_Role.ObjectId
               FROM ObjectLink AS ObjectLink_RoleAction_Role
                    INNER JOIN ObjectLink AS ObjectLink_RoleAction_Action
                                          ON ObjectLink_RoleAction_Action.ObjectId = ObjectLink_RoleAction_Role.ObjectId
                                         AND ObjectLink_RoleAction_Action.ChildObjectId = inActionId
                                         AND ObjectLink_RoleAction_Action.DescId = zc_ObjectLink_RoleAction_Action()
               WHERE ObjectLink_RoleAction_Role.ChildObjectId = inRoleId
                 AND ObjectLink_RoleAction_Role.DescId = zc_ObjectLink_RoleAction_Role()
               LIMIT 1
              );
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleAction(), 0, '');

   -- сохранили связь с <Ролью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleAction_Role(), ioId, inRoleId);
   -- сохранили связь с <Действием>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleAction_Action(), ioId, inActionId);

   
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
-- SELECT * FROM gpInsertUpdate_Object_RoleAction()
