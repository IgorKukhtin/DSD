-- Function: gpSelect_Object_TaxKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TaxKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TaxKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NDS TFloat
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_TaxKind());

   RETURN QUERY 
   SELECT
        Object_TaxKind.Id           AS Id 
      , Object_TaxKind.ObjectCode   AS Code
      , Object_TaxKind.ValueData    AS Name
      
      , ObjectFloat_TaxKind_Value.ValueData   AS Value
      
      , Object_TaxKind.isErased     AS isErased
      
   FROM OBJECT AS Object_TaxKind
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                              ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id 
                             AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()   
                              
   WHERE Object_TaxKind.DescId = zc_Object_TaxKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TaxKind('2')