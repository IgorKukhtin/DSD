-- Торговая марка

DROP FUNCTION IF EXISTS gpSelect_Object_Brand (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Brand(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, CountryBrandName TVarChar, isOLAP Boolean, isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Brand());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       WITH tmpReportOLAP AS (SELECT ObjectLink_Object.ChildObjectId AS BrandId
                              FROM Object
                                   INNER JOIN ObjectLink AS ObjectLink_User
                                                         ON ObjectLink_User.ObjectId      = Object.Id
                                                        AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                        AND ObjectLink_User.ChildObjectId = vbUserId
                                   INNER JOIN ObjectLink AS ObjectLink_Object
                                                         ON ObjectLink_Object.ObjectId      = Object.Id
                                                        AND ObjectLink_Object.DescId        = zc_ObjectLink_ReportOLAP_Object()
                              WHERE Object.DescId     = zc_Object_ReportOLAP()
                                AND Object.ObjectCode = 1
                                AND Object.isErased   = FALSE
                             )
       -- результат
       SELECT
             Object_Brand.Id                      AS Id
           , Object_Brand.ObjectCode              AS Code
           , Object_Brand.ValueData               AS Name
           , Object_CountryBrand.ValueData        AS CountryBrandName
           , CASE WHEN tmpReportOLAP.BrandId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isOLAP
           , Object_Brand.isErased                      AS isErased
       FROM Object AS Object_Brand
            LEFT JOIN tmpReportOLAP ON tmpReportOLAP.BrandId = Object_Brand.Id

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
