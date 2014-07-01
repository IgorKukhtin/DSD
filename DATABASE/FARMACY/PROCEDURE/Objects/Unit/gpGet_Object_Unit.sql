-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ParentId Integer, ParentName TVarChar,
               BranchId Integer, BranchName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               isLeaf boolean,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Unit());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Unit()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS ParentId
           , CAST ('' as TVarChar) AS ParentName 

           , CAST (0 as Integer)   AS BranchId
           , CAST ('' as TVarChar) AS BranchName
         
           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
         
           , CAST (NULL AS Boolean) AS isLeaf     
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Unit.Id           AS Id
           , Object_Unit.ObjectCode   AS Code
           , Object_Unit.ValueData    AS Name
         
           , ObjectLink_Unit_Parent.ChildObjectId  AS ParentId
           , Object_Parent.ValueData  AS ParentName 

           , Object_Branch.Id         AS BranchId
           , Object_Branch.ValueData  AS BranchName
         
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName

           , ObjectBoolean_isLeaf.ValueData AS isLeaf
           
           , Object_Unit.isErased           AS isErased
           
       FROM Object AS Object_Unit
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                   ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                  AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
      WHERE Object_Unit.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.14         *
 11.06.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')