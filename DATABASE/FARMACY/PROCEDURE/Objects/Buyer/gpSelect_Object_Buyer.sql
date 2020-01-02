-- Function: gpSelect_Object_Buyer()

DROP FUNCTION IF EXISTS gpSelect_Object_Buyer(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Buyer(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Phone TVarChar
             , Name TVarChar 
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_Buyer.Id                      AS Id 
        , Object_Buyer.ObjectCode              AS Code
        , Object_Buyer.ValueData               AS Phone
        , ObjectString_Buyer_Name.ValueData    AS Name
        , Object_Buyer.isErased                AS isErased
   FROM Object AS Object_Buyer
        LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                               ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()
   WHERE Object_Buyer.DescId = zc_Object_Buyer();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Buyer(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.12.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Buyer('3')