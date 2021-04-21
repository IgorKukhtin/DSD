-- Function: gpSelect_Object_ProductPhoto(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ProductPhoto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProductPhoto(
    IN inProductId      Integer, 
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName TVarChar) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProductCondition());

   RETURN QUERY 
     SELECT 
           Object_ProductPhoto.Id        AS Id,
           Object_ProductPhoto.ValueData AS FileName
     FROM Object AS Object_ProductPhoto
          JOIN ObjectLink AS ObjectLink_ProductPhoto_Product
            ON ObjectLink_ProductPhoto_Product.ObjectId = Object_ProductPhoto.Id
           AND ObjectLink_ProductPhoto_Product.DescId = zc_ObjectLink_ProductPhoto_Product()
           AND ObjectLink_ProductPhoto_Product.ChildObjectId = inProductId
     WHERE Object_ProductPhoto.DescId = zc_Object_ProductPhoto(); 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProductCondition ('2')