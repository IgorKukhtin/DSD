-- Function: gpGet_Object_ImportType()

DROP FUNCTION IF EXISTS gpGet_Object_ImportType(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportType(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ProcedureName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ImportType());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_ImportType()) AS Code
           , CAST ('' as TVarChar) AS Name

           , CAST ('' as TVarChar) AS ProcedureName     
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ImportType.Id           AS Id
           , Object_ImportType.ObjectCode   AS Code
           , Object_ImportType.ValueData    AS Name

           , ObjectString_ProcedureName.ValueData AS ProcedureName
           
           , Object_ImportType.isErased       AS isErased
           
       FROM Object AS Object_ImportType
           LEFT JOIN ObjectString AS ObjectString_ProcedureName 
                                  ON ObjectString_ProcedureName.ObjectId = Object_ImportType.Id
                                 AND ObjectString_ProcedureName.DescId = zc_ObjectString_ImportType_ProcedureName()
                                  
      WHERE Object_ImportType.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ImportType (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ImportType(0,'2')