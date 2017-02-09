-- Function: gpSelect_Object_UserRole (TVarChar)

-- DROP FUNCTION gpSelect_Object_UserRole (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserRole(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, UserId Integer, UserRoleId Integer)
AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     ObjectRole.Id         AS Id 
   , ObjectRole.ObjectCode AS Code
   , ObjectRole.ValueData  AS Name
   , ObjectLink_UserRole_User.ChildObjectId AS UserId
   , ObjectLink_UserRole_User.ObjectId      AS UserRoleId
   FROM ObjectLink AS ObjectLink_UserRole_Role
   JOIN ObjectLink AS ObjectLink_UserRole_User ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
    AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()

   JOIN Object AS ObjectRole ON ObjectRole.Id = ObjectLink_UserRole_Role.ChildObjectId
   WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role();        
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UserRole (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *
*/
-- SELECT * FROM gpSelect_Object_UserRole ('2')
