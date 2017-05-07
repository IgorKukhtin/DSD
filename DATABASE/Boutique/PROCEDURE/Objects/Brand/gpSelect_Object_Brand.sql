-- Торговая марка

DROP FUNCTION IF EXISTS gpSelect_Object_Brand (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Brand(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, CountryBrandName TVarChar, isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Brand());
      PERFORM lpGetUserBySession (inSession);

   -- результат
   RETURN QUERY
       SELECT
             Object_Brand.Id                      AS Id
           , Object_Brand.ObjectCode              AS Code
           , Object_Brand.ValueData               AS Name
           , Object_CountryBrand.ValueData        AS CountryBrandName
           , Object_Brand.isErased                      AS isErased
       FROM Object AS Object_Brand

            LEFT JOIN ObjectLink AS Object_Brand_CountryBrand
                                 ON Object_Brand_CountryBrand.ObjectId = Object_Brand.Id
                                AND Object_Brand_CountryBrand.DescId = zc_ObjectLink_Brand_CountryBrand()
            LEFT JOIN Object AS Object_CountryBrand ON Object_CountryBrand.Id = Object_Brand_CountryBrand.ChildObjectId
      
       WHERE Object_Brand.DescId = zc_Object_Brand()
         AND (Object_Brand.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
02.03.17                                                         *
19.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Brand (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
