-- Function: gpSelect_Object_UnionLoadObject()

DROP FUNCTION IF EXISTS gpSelect_Object_UnionLoadObject(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnionLoadObject(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY 
       SELECT 
             Object.Id           AS Id
           , Object.ObjectCode   AS Code
           , Object.ValueData    AS Name
         
           , Object.isErased           AS isErased
           
       FROM Object 
       WHERE Object.DescId IN (zc_Object_Juridical(), zc_Object_Unit());
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnionLoadObject(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.14                        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_UnionLoadObject ('2')