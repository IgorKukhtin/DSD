-- Названия накопительных скидок

DROP FUNCTION IF EXISTS gpSelect_Object_Discount (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Discount(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DiscountKindName TVarChar, isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());


   -- результат
   RETURN QUERY
       SELECT
             Object_Discount.Id              AS Id
           , Object_Discount.ObjectCode      AS Code
           , Object_Discount.ValueData       AS Name
           , Object_DiscountKind.ValueData   AS DiscountKindName
           , Object_Discount.isErased        AS isErased

       FROM Object as Object_Discount
            LEFT JOIN ObjectLink AS ObjectLink_Discount_DiscountKind
                                 ON ObjectLink_Discount_DiscountKind.ObjectId = Object_Discount.Id
                                AND ObjectLink_Discount_DiscountKind.DescId = zc_ObjectLink_Discount_DiscountKind()
            LEFT JOIN Object AS Object_DiscountKind ON Object_DiscountKind.Id = ObjectLink_Discount_DiscountKind.ChildObjectId

       WHERE Object_Discount.DescId = zc_Object_Discount()
         AND (Object_Discount.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
22.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Discount (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
