-- Function: gpSelect_Object_BuyerForSite()

DROP FUNCTION IF EXISTS gpSelect_Object_BuyerForSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BuyerForSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Phone TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_BuyerForSite.Id                        AS Id 
        , Object_BuyerForSite.ObjectCode                AS Code
        , Object_BuyerForSite.ValueData                 AS Name
        , ObjectString_BuyerForSite_Phone.ValueData     AS Phone
        , Object_BuyerForSite.isErased                  AS isErased
   FROM Object AS Object_BuyerForSite
        LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                               ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                              AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
   WHERE Object_BuyerForSite.DescId = zc_Object_BuyerForSite();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_BuyerForSite(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.04.21                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_BuyerForSite('3')