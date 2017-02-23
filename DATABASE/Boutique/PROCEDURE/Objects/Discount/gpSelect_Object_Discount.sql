-- Function: gpSelect_Object_Discount()

DROP FUNCTION IF EXISTS gpSelect_Object_Discount (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Discount(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, KindDiscount Integer, isErased boolean)
  AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());


   -- результат
   RETURN QUERY
      SELECT Object.Id                                    AS Id
           , Object.ObjectCode                            AS Code
           , Object.ValueData                             AS Name
           , OS_Discount_KindDiscount.ValueData::Integer  AS KindDiscount
           , Object.isErased                              AS isErased
       FROM Object
            LEFT JOIN ObjectFloat AS OS_Discount_KindDiscount
                                   ON OS_Discount_KindDiscount.ObjectId = Object.Id
                                  AND OS_Discount_KindDiscount.DescId = zc_ObjectFloat_Discount_KindDiscount()
       WHERE Object.DescId = zc_Object_Discount()
         AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
22.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Discount (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
