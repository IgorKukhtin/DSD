-- Function: gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserRole(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inUserId         Integer   ,     -- Пользователь
    IN inRoleId         Integer   ,     -- Роль
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS Integer AS
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
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <User>.';
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

   -- сохранили связь с <Пользователем>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), ioId, inUserId);
   -- сохранили связь с <Ролью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), ioId, inRoleId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UserRole()