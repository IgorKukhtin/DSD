-- Function: gpGet_Object_AreaContract()

DROP FUNCTION IF EXISTS gpGet_Object_AreaContract(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_AreaContract(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , BranchId Integer, BranchName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_AreaContract()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)    AS BranchId
           , CAST ('' as TVarChar)  AS BranchName
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id               AS Id
           , Object.ObjectCode       AS Code
           , Object.ValueData        AS Name
           , Object_Branch.Id        AS BranchId
           , Object_Branch.ValueData AS BranchName
           , Object.isErased         AS isErased
       FROM Object
         LEFT JOIN ObjectLink AS ObjectLink_AreaContract_Branch
                              ON ObjectLink_AreaContract_Branch.ObjectId = Object.Id
                             AND ObjectLink_AreaContract_Branch.DescId = zc_ObjectLink_AreaContract_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_AreaContract_Branch.ChildObjectId
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_AreaContract(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.22         *
 06.11.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_AreaContract (0, '2')