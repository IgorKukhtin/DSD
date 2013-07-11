-- Function: gpGet_Object_ReceiptCost (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_ReceiptCost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptCost(
    IN inId             Integer,       -- ключ объекта <Затраты в рецептурах>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_ReceiptCost());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_ReceiptCost.ObjectCode), 0) + 1  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_ReceiptCost
       WHERE Object_ReceiptCost.DescId = zc_Object_ReceiptCost();
   ELSE
       RETURN QUERY 
       SELECT
             Object_ReceiptCost.Id         AS Id
           , Object_ReceiptCost.ObjectCode AS Code
           , Object_ReceiptCost.ValueData  AS Name
           , Object_ReceiptCost.isErased   AS isErased
       FROM Object AS Object_ReceiptCost
       WHERE Object_ReceiptCost.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ReceiptCost (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.13          *                

*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptCost (2, '')
