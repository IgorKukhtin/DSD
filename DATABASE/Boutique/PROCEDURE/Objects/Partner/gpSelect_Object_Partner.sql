-- Поcтавщики

DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner(
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id               Integer
             , Code             Integer
             , Name             TVarChar
             , BrandName        TVarChar
             , FabrikaName      TVarChar
             , PeriodName       TVarChar
             , PeriodYear       TFloat
             , isErased         Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       SELECT
             Object_Partner.Id                  AS Id
           , Object_Partner.ObjectCode          AS Code
           , (COALESCE (Object_Brand.ValueData, '') || COALESCE ( '-' || Object_Period.ValueData, '') || COALESCE ('-' || (ObjectFloat_PeriodYear.ValueData :: Integer) :: TVarChar,'')) :: TVarChar AS Name
           , Object_Brand.ValueData             AS BrandName
           , Object_Fabrika.ValueData           AS FabrikaName
           , Object_Period.ValueData            AS PeriodName
           , ObjectFloat_PeriodYear.ValueData   AS PeriodYear
           , Object_Partner.isErased            AS isErased

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


     WHERE Object_Partner.DescId = zc_Object_Partner()
           AND (Object_Partner.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
24.02.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner (TRUE, zfCalc_UserAdmin())
