-- Function: gpSelect_Object_Partner (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner(
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (
             Id               Integer
           , Code             Integer
           , Name             TVarChar
           , UnitName         TVarChar
           , ValutaName       TVarChar
           , BrandName        TVarChar
           , FabrikaName      TVarChar
           , PeriodName       TVarChar
           , KindAccount      TFloat
           , PeriodYear       TFloat
           , isErased         boolean
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Partner.Id                  AS Id
           , Object_Partner.ObjectCode          AS Code
           , Object_Partner.ValueData           AS Name
           , Object_Unit.ValueData              AS UnitName
           , Object_Valuta.ValueData            AS ValutaName
           , Object_Brand.ValueData             AS BrandName    
           , Object_Fabrika.ValueData           AS FabrikaName       
           , Object_Period.ValueData            AS PeriodName
           , ObjectFloat_KindAccount.ValueData  AS KindAccount
           , ObjectFloat_PeriodYear.ValueData   AS PeriodYear
           , Object_Partner.isErased            AS isErased
           
       FROM Object AS Object_Partner
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                 ON ObjectLink_Goods_Unit.ObjectId = Object_Partner.Id
                                AND ObjectLink_Goods_Unit.DescId = zc_ObjectLink_Goods_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Goods_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Valuta
                                 ON ObjectLink_Goods_Valuta.ObjectId = Object_Partner.Id
                                AND ObjectLink_Goods_Valuta.DescId = zc_ObjectLink_Goods_Valuta()
            LEFT JOIN Object AS Object_Valuta ON Object_Valuta.Id = ObjectLink_Goods_Valuta.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Brand
                                 ON ObjectLink_Goods_Brand.ObjectId = Object_Partner.Id
                                AND ObjectLink_Goods_Brand.DescId = zc_ObjectLink_Goods_Brand()
            LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Goods_Brand.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Fabrika
                                 ON ObjectLink_Goods_Fabrika.ObjectId = Object_Partner.Id
                                AND ObjectLink_Goods_Fabrika.DescId = zc_ObjectLink_Goods_Fabrika()
            LEFT JOIN Object AS Object_Fabrika ON Object_Fabrika.Id = ObjectLink_Goods_Fabrika.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Period
                                 ON ObjectLink_Goods_Period.ObjectId = Object_Partner.Id
                                AND ObjectLink_Goods_Period.DescId = zc_ObjectLink_Goods_Period()
            LEFT JOIN Object AS Object_Period ON Object_Period.Id = ObjectLink_Goods_Period.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_KindAccount 
                                  ON ObjectFloat_KindAccount.ObjectId = Object_Partner.Id 
                                 AND ObjectFloat_KindAccount.DescId = zc_ObjectFloat_Partner_KindAccount()

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