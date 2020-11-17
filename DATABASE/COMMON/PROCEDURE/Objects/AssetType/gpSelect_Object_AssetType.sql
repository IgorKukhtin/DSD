-- Function: gpSelect_Object_AssetType()

DROP FUNCTION IF EXISTS gpSelect_Object_AssetType(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AssetType(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_AssetType()());

   RETURN QUERY 
   SELECT Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name
        , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_AssetType();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AssetType(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.20         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AssetType('2')