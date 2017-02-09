-- Function: gpSelect_Object_ReceiptKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ReceiptKind());

   RETURN QUERY 
   SELECT
        Object_ReceiptKind.Id           AS Id 
      , Object_ReceiptKind.ObjectCode   AS Code
      , Object_ReceiptKind.ValueData    AS NAME
      
      , Object_ReceiptKind.isErased     AS isErased
      
   FROM Object AS Object_ReceiptKind
                              
   WHERE Object_ReceiptKind.DescId = zc_Object_ReceiptKind();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReceiptKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.12.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptKind('2')
