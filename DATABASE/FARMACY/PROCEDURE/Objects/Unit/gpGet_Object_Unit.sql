-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ParentId Integer, ParentName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar, isLeaf boolean) AS
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

           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
           , false AS isLeaf;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Unit_View.Id
           , Object_Unit_View.Code
           , Object_Unit_View.Name
           , Object_Unit_View.ParentId
           , Object_Unit_View.ParentName
           , Object_Unit_View.JuridicalId
           , Object_Unit_View.JuridicalName
           , Object_Unit_View.isLeaf 
       FROM Object_Unit_View
      WHERE Object_Unit_View.Id = inId;
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