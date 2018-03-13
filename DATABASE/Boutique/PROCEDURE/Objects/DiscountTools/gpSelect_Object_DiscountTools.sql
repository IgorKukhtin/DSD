-- Настройка процентов по накопительным скидкам

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountTools(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountTools(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id           Integer
             , StartSumm    TFloat
             , EndSumm      TFloat
             , DiscountTax  TFloat
             , DiscountId   Integer
             , DiscountName TVarChar
             , isErased     Boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountTools());


   -- результат
   RETURN QUERY
      SELECT
             Object.Id                              AS Id
           , OS_DiscountTools_StartSumm.ValueData   AS StartSumm
           , OS_DiscountTools_EndSumm.ValueData     AS EndSumm
           , OS_DiscountTools_DiscountTax.ValueData AS DiscountTax
           , Object_Discount.ID                     AS DiscountId
           , Object_Discount.ValueData              AS DiscountName 
           , Object.isErased                        AS isErased
      FROM Object
           LEFT JOIN ObjectFloat AS OS_DiscountTools_StartSumm
                                 ON OS_DiscountTools_StartSumm.ObjectId = Object.Id
                                AND OS_DiscountTools_StartSumm.DescId = zc_ObjectFloat_DiscountTools_StartSumm()
           LEFT JOIN ObjectFloat AS OS_DiscountTools_EndSumm
                                 ON OS_DiscountTools_EndSumm.ObjectId = Object.Id
                                AND OS_DiscountTools_EndSumm.DescId = zc_ObjectFloat_DiscountTools_EndSumm()
           LEFT JOIN ObjectFloat AS OS_DiscountTools_DiscountTax
                                 ON OS_DiscountTools_DiscountTax.ObjectId = Object.Id
                                AND OS_DiscountTools_DiscountTax.DescId = zc_ObjectFloat_DiscountTools_DiscountTax()
           LEFT JOIN ObjectLink AS ObjectLink_DiscountTools_Discount 
                                ON ObjectLink_DiscountTools_Discount.ObjectId = Object.Id
                               AND ObjectLink_DiscountTools_Discount.DescId = zc_ObjectLink_DiscountTools_Discount()
           LEFT JOIN Object AS Object_Discount ON Object_Discount.Id = ObjectLink_DiscountTools_Discount.ChildObjectId
        
      WHERE Object.DescId = zc_Object_DiscountTools()
          AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
23.02.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountTools (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
