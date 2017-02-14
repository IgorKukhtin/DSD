-- Function: gpSelect_Object_RoleAction()

--DROP FUNCTION gpSelect_Object_RoleAction();

CREATE OR REPLACE FUNCTION gpSelect_Object_RoleAction(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, RoleId Integer, RoleActionId Integer) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Action());

   RETURN QUERY 
   SELECT 
     ObjectAction.Id         AS Id 
   , ObjectAction.ObjectCode AS Code
   , ObjectAction.ValueData  AS Name
   , ObjectLink_RoleAction_Role.ChildObjectId AS RoleId
   , ObjectLink_RoleAction_Action.ObjectId AS RoleActionId
   FROM ObjectLink AS ObjectLink_RoleAction_Role
   JOIN ObjectLink AS ObjectLink_RoleAction_Action ON ObjectLink_RoleAction_Action.ObjectId = ObjectLink_RoleAction_Role.ObjectId
    AND ObjectLink_RoleAction_Action.DescId = zc_ObjectLink_RoleAction_Action()

   JOIN Object AS ObjectAction ON ObjectAction.Id = ObjectLink_RoleAction_Action.ChildObjectId
   WHERE ObjectLink_RoleAction_Role.DescId = zc_ObjectLink_RoleAction_Role();        
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RoleAction(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Role('2')
/*SELECT  
  Role.ItemName AS RoleName,
  Process.ItemName AS ProcessName
FROM 
  Object 
  JOIN ObjectEnum RoleRight_Role 
    ON RoleRight_Role.ObjectId = Object.Id AND RoleRight_Role.DescId = zc_Object_RoleRight_Role()
  JOIN Enum Role 
    ON Role.Id = RoleRight_Role.EnumId
  JOIN ObjectEnum RoleRight_Process
    ON RoleRight_Process.ObjectId = Object.Id AND RoleRight_Process.DescId = zc_Object_RoleRight_Process()
  JOIN Enum Process 
    ON Process.Id = RoleRight_Process.EnumId


WHERE Object.DescId = zc_Object_RoleRight()*/
