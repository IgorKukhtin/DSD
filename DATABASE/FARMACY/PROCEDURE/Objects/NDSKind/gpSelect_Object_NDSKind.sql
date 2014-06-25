-- Function: gpSelect_Object_NDSKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_NDSKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_NDSKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_NDSKind());

   RETURN QUERY 
   SELECT
        Object_NDSKind.Id           AS Id 
      , Object_NDSKind.ObjectCode   AS Code
      , Object_NDSKind.ValueData    AS NAME
      
      , ObjectFloat_NDS.ValueData   AS NDS
      
      , Object_NDSKind.isErased     AS isErased
      
   FROM OBJECT AS Object_NDSKind
        LEFT JOIN ObjectFloat AS ObjectFloat_NDS
                              ON ObjectFloat_NDS.ObjectId = Object_NDSKind.Id 
                             AND ObjectFloat_NDS.DescId = zc_ObjectFloat_NDS()   
                              
   WHERE Object_NDSKind.DescId = zc_Object_NDSKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_NDSKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.14         *             

*/

-- тест
-- SELECT * FROM gpSelect_Object_NDSKind('2')
