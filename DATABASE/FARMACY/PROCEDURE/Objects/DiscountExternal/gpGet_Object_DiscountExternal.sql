-- Function: gpGet_Object_DiscountExternal()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternal(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , URL     TVarChar
             , Service TVarChar
             , Port    TVarChar
             , isGoodsForProject Boolean
             , isOneSupplier Boolean
             , isTwoPackages Boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternal());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_DiscountExternal()) AS Code
           , CAST ('' AS TVarChar)  AS Name
          
           , CAST ('' AS TVarChar)  AS URL
           , CAST ('' AS TVarChar)  AS Service
           , CAST ('' AS TVarChar)  AS Port
           , False                  AS isGoodsForProject  
           , False                  AS isOneSupplier  
           , False                  AS isTwoPackages  
         ;
   ELSE
       RETURN QUERY
       SELECT
             Object_DiscountExternal.Id         AS Id
           , Object_DiscountExternal.ObjectCode AS Code
           , Object_DiscountExternal.ValueData  AS Name

           , ObjectString_URL.ValueData       AS URL
           , ObjectString_Service.ValueData   AS Service
           , ObjectString_Port.ValueData      AS Port
           , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
           , COALESCE(ObjectBoolean_OneSupplier.ValueData, False)      AS isOneSupplier
           , COALESCE(ObjectBoolean_TwoPackages.ValueData, False)      AS isTwoPackages

       FROM Object AS Object_DiscountExternal
            LEFT JOIN ObjectString AS ObjectString_URL
                                   ON ObjectString_URL.ObjectId = Object_DiscountExternal.Id 
                                  AND ObjectString_URL.DescId = zc_ObjectString_DiscountExternal_URL()
            LEFT JOIN ObjectString AS ObjectString_Service
                                   ON ObjectString_Service.ObjectId = Object_DiscountExternal.Id 
                                  AND ObjectString_Service.DescId = zc_ObjectString_DiscountExternal_Service()
            LEFT JOIN ObjectString AS ObjectString_Port
                                   ON ObjectString_Port.ObjectId = Object_DiscountExternal.Id 
                                  AND ObjectString_Port.DescId = zc_ObjectString_DiscountExternal_Port()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                    ON ObjectBoolean_GoodsForProject.ObjectId = Object_DiscountExternal.Id 
                                   AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_OneSupplier
                                    ON ObjectBoolean_OneSupplier.ObjectId = Object_DiscountExternal.Id 
                                   AND ObjectBoolean_OneSupplier.DescId = zc_ObjectBoolean_DiscountExternal_OneSupplier()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_TwoPackages
                                    ON ObjectBoolean_TwoPackages.ObjectId = Object_DiscountExternal.Id 
                                   AND ObjectBoolean_TwoPackages.DescId = zc_ObjectBoolean_DiscountExternal_TwoPackages()
       WHERE Object_DiscountExternal.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountExternal (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.07.16         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountExternal (2488964, zfCalc_UserAdmin())