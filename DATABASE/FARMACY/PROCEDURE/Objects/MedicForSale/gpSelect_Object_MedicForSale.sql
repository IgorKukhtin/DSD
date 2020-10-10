-- Function: gpSelect_Object_MedicForSale()

DROP FUNCTION IF EXISTS gpSelect_Object_MedicForSale(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicForSale(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_MedicForSale.Id                        AS Id 
        , Object_MedicForSale.ObjectCode                AS Code
        , Object_MedicForSale.ValueData                 AS Name
        , Object_MedicForSale.isErased                  AS isErased
   FROM Object AS Object_MedicForSale
   WHERE Object_MedicForSale.DescId = zc_Object_MedicForSale();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MedicForSale(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.10.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MedicForSale('3')