-- Function: gpSelect_Object_ReceiptCost (TVarChar)

-- DROP FUNCTION gpSelect_Object_ReceiptCost (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptCost(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ReceiptCost());

   RETURN QUERY 
   SELECT
         Object_ReceiptCost.Id         AS Id 
       , Object_ReceiptCost.ObjectCode AS Code
       , Object_ReceiptCost.ValueData  AS Name
       , Object_ReceiptCost.isErased   AS isErased
   FROM Object AS Object_ReceiptCost
   WHERE Object_ReceiptCost.DescId = zc_Object_ReceiptCost();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReceiptCost (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptCost('2')
