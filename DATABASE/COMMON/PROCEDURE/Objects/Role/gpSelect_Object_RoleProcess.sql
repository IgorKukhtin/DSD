-- Function: gpSelect_Object_RoleProcess()

DROP FUNCTION IF EXISTS gpSelect_Object_RoleProcess (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RoleProcess(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, RoleId Integer, RoleProcessId Integer, Process_EnumName TVarChar) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Process());

   RETURN QUERY 
   SELECT 
     ObjectProcess.Id         AS Id 
   , ObjectProcess.ObjectCode AS Code
   , ObjectProcess.ValueData  AS Name
   , ObjectLink_RoleRight_Role.ChildObjectId AS RoleId
   , ObjectLink_RoleRight_Role.ObjectId AS RoleProcessId

   , ObjectString.ValueData AS Process_EnumName

   FROM ObjectLink AS ObjectLink_RoleRight_Role
   JOIN ObjectLink AS ObjectLink_RoleRight_Process ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
    AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()

   JOIN Object AS ObjectProcess ON ObjectProcess.Id = ObjectLink_RoleRight_Process.ChildObjectId

        LEFT JOIN ObjectString ON ObjectString.ObjectId = ObjectLink_RoleRight_Process.ChildObjectId
                              AND ObjectString.DescId = zc_ObjectString_Enum()

   WHERE ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role();        
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RoleProcess(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.13                                        *
 23.09.13                         *
*/
-- тест
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


WHERE Object.DescId = zc_Object_RoleRight()
*/

-- SELECT * FROM gpSelect_Object_RoleProcess ('2')
