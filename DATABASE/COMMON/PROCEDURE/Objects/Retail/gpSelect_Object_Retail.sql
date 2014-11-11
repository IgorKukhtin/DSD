-- Function: gpSelect_Object_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Retail(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Retail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GLNCode TVarChar 
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Retail()());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS NAME
   , GLNCode.ValueData AS GLNCode
   , Object.isErased   AS isErased
   FROM Object
        LEFT JOIN ObjectString AS GLNCode
                               ON GLNCode.ObjectId = Object.Id 
                              AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
   WHERE Object.DescId = zc_Object_Retail();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Retail(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.14         * add GLNCode
 23.05.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Retail('2')