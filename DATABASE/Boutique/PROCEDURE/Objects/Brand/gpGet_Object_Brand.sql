-- Function: gpGet_Object_Brand()

DROP FUNCTION IF EXISTS gpGet_Object_Brand (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Brand(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, CountryBrandId Integer, CountryBrandName TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Brand());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           , NEXTVAL ('Object_Brand_seq') :: Integer   AS Code
           , '' :: TVarChar                            AS Name
           ,  0 :: Integer                             AS CountryBrandId
           , '' :: TVarChar                            AS CountryBrandName
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Brand.Id                      AS Id
           , Object_Brand.ObjectCode              AS Code
           , Object_Brand.ValueData               AS Name
           , Object_CountryBrand.Id               AS CountryBrandId
           , Object_CountryBrand.ValueData        AS CountryBrandName
       FROM Object AS Object_Brand
            LEFT JOIN ObjectLink AS Object_Brand_CountryBrand
                                 ON Object_Brand_CountryBrand.ObjectId = Object_Brand.Id
                                AND Object_Brand_CountryBrand.DescId = zc_ObjectLink_Brand_CountryBrand()
            LEFT JOIN Object AS Object_CountryBrand ON Object_CountryBrand.Id = Object_Brand_CountryBrand.ChildObjectId
       WHERE Object_Brand.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
02.03.17                                                          *
19.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Brand (1,'2')
