-- Function: gpGet_Object_Partner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Partner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
    IN inId          Integer,       -- Состав товара
    IN inSession     TVarChar       -- Cессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, BrandId Integer, BrandName TVarChar, FabrikaId Integer, FabrikaName TVarChar, PeriodId Integer, PeriodName TVarChar, PeriodYear TFloat) 
AS
$BODY$
DECLARE vbCode_max Integer;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());
  PERFORM lpGetUserBySession (inSession);

 -- пытаемся найти код
   IF inId <> 0 AND COALESCE (vbCode_max, 0) = 0 THEN vbCode_max := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = inId); END IF;


  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)    AS BrandId
           , CAST ('' as TVarChar)  AS BrandName
           , CAST (0 as Integer)    AS FabrikaId
           , CAST ('' as TVarChar)  AS FabrikaName
           , CAST (0 as Integer)    AS PeriodId
           , CAST ('' as TVarChar)  AS PeriodName
           , CAST (0 as TFloat)     AS PeriodYear

       FROM Object
       WHERE Object.DescId = zc_Object_Partner();
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
24.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Partner(1,'2')
