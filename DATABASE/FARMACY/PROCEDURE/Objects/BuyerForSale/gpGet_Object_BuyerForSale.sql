-- Function: gpGet_Object_BuyerForSale()

DROP FUNCTION IF EXISTS gpGet_Object_BuyerForSale(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BuyerForSale(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Phone TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_BuyerForSale()) AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST ('' as TVarChar)   AS Phone
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_BuyerForSale.Id                        AS Id
            , Object_BuyerForSale.ObjectCode                AS Code
            , Object_BuyerForSale.ValueData                 AS Name
            , ObjectString_BuyerForSale_Phone.ValueData     AS Phone
            , Object_BuyerForSale.isErased                  AS isErased
       FROM Object AS Object_BuyerForSale
        LEFT JOIN ObjectString AS ObjectString_BuyerForSale_Phone
                               ON ObjectString_BuyerForSale_Phone.ObjectId = Object_BuyerForSale.Id 
                              AND ObjectString_BuyerForSale_Phone.DescId = zc_ObjectString_BuyerForSale_Phone()
       WHERE Object_BuyerForSale.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_BuyerForSale(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.06.22                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_BuyerForSale (0, '3')