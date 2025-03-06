-- Function: gpSelect_Object_ActionByUser()

-- DROP FUNCTION gpSelect_Object_ActionByUser (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ActionByUser(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (ActionName TVarChar, OperDate TDateTime)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- Получаем пользователя
  vbUserId := lpGetUserBySession(inSession);
  -- Проверяем нет ли случайно у него прав Админа
  PERFORM 1 FROM ObjectLink_UserRole_View 
           WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId IN (zc_Enum_Role_Admin(), 296580); -- Admin + Просмотр ВСЕ (руководство)
  IF FOUND THEN
     -- возвращаем все 
     RETURN QUERY 
     SELECT 
            Object.ValueData  AS Name
          , CURRENT_DATE :: TDateTime
     FROM Object
     WHERE Object.DescId = zc_Object_Action();
  ELSE
     -- Выбираем действия пользователя
     RETURN QUERY
     SELECT DISTINCT
            Object_Action.ValueData
          , CURRENT_DATE :: TDateTime
       FROM Object AS Object_Action
       JOIN ObjectLink_RoleAction_View ON ObjectLink_RoleAction_View.ActionId = Object_Action.Id
       JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.RoleId = ObjectLink_RoleAction_View.RoleId
                                    AND ObjectLink_UserRole_View.UserId = vbUserId;
  END IF;
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ActionByUser(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.13                                        * rename RoleAction_View -> ObjectLink_RoleAction_View
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 25.09.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Action ('9461')
