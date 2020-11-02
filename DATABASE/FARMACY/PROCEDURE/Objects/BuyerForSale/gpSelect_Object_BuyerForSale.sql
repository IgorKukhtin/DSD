-- Function: gpSelect_Object_BuyerForSale()

DROP FUNCTION IF EXISTS gpSelect_Object_BuyerForSale(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BuyerForSale(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Phone TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

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
   WHERE Object_BuyerForSale.DescId = zc_Object_BuyerForSale();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_BuyerForSale(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.10.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_BuyerForSale('3')