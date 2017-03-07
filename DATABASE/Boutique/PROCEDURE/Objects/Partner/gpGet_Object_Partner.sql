-- Function: gpGet_Object_Partner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Partner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
    IN inId          Integer,       -- Состав товара
    IN inSession     TVarChar       -- Cессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, BrandId Integer, BrandName TVarChar, FabrikaId Integer, FabrikaName TVarChar, PeriodId Integer, PeriodName TVarChar, PeriodYear TFloat) 
AS
$BODY$

BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer    AS Id
           , NEXTVAL ('Object_Measure_seq') :: Integer AS Code
           , '' :: TVarChar   AS Name
           ,  0 :: Integer    AS BrandId
           , '' :: TVarChar   AS BrandName
           ,  0 :: Integer    AS FabrikaId
           , '' :: TVarChar   AS FabrikaName
           ,  0 :: Integer    AS PeriodId
           , '' :: TVarChar   AS PeriodName
           ,  0 :: TFloat     AS PeriodYear
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_Partner.Id                  AS Id
           , Object_Partner.ObjectCode          AS Code
           , Object_Partner.ValueData           AS Name
           , Object_Brand.Id                    AS BrandId
           , Object_Brand.ValueData             AS BrandName
           , Object_Fabrika.Id                  AS FabrikaId
           , Object_Fabrika.ValueData           AS FabrikaName
           , Object_Period.Id                   AS PeriodId
           , Object_Period.ValueData            AS PeriodName
           , ObjectFloat_PeriodYear.ValueData   AS PeriodYear
           
       FROM Object AS Object_Partner

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                 ON ObjectLink_Partner_Brand.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Brand.DescId = zc_ObjectLink_Partner_Brand()
            LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Partner_Brand.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                 ON ObjectLink_Partner_Fabrika.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Fabrika.DescId = zc_ObjectLink_Partner_Fabrika()
            LEFT JOIN Object AS Object_Fabrika ON Object_Fabrika.Id = ObjectLink_Partner_Fabrika.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                 ON ObjectLink_Partner_Period.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
            LEFT JOIN Object AS Object_Period ON Object_Period.Id = ObjectLink_Partner_Period.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear 
                                  ON ObjectFloat_PeriodYear.ObjectId = Object_Partner.Id 
                                 AND ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()

       WHERE Object_Partner.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
24.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Partner(1,'2')
