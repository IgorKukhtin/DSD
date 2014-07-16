-- Function: gpGet_Object_FileTypeKind()

DROP FUNCTION IF EXISTS gpGet_Object_FileTypeKind(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_FileTypeKind(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_FileTypeKind());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_FileTypeKind()) AS Code
           , CAST ('' as TVarChar) AS Name

           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_FileTypeKind.Id           AS Id
           , Object_FileTypeKind.ObjectCode   AS Code
           , Object_FileTypeKind.ValueData    AS Name
         
           , Object_FileTypeKind.isErased       AS isErased
           
       FROM Object AS Object_FileTypeKind
  
      WHERE Object_FileTypeKind.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_FileTypeKind (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_FileTypeKind(0,'2')