-- Function: gpSelect_Object_ActionByUser()

--DROP FUNCTION gpSelect_Object_ActionByUser();

CREATE OR REPLACE FUNCTION gpSelect_Object_ActionByUser(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (ActionName TVarChar) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- Получаем пользователя
  vbUserId := lpGetUserBySession(inSession);
  -- Проверяем нет ли случайно у него прав Админа
  PERFORM 1 FROM UserRole_View 
           WHERE UserRole_View.UserId = vbUserId AND UserRole_View.RoleId = zc_Enum_Role_Admin();
  IF FOUND THEN
     -- возвращаем все 
     RETURN QUERY 
     SELECT 
        Object.ValueData  AS Name
     FROM Object
     WHERE Object.DescId = zc_Object_Action();
  ELSE
     -- Выбираем действия пользователя
     RETURN QUERY
     SELECT DISTINCT Object_Action.ValueData 
       FROM Object AS Object_Action
       JOIN roleaction_view ON roleaction_view.ActionId = Object_Action.Id
       JOIN userrole_view ON userrole_view.RoleId = roleaction_view.RoleId
        AND userrole_view.UserId = vbUserId;
  END IF;
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ActionByUser(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Action('2')