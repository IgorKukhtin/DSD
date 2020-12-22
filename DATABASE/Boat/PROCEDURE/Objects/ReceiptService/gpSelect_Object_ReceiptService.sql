-- Страна производитель

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptService (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptService(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Article TVarChar
             , Comment TVarChar
             , TaxKindId Integer, TaxKindName TVarChar, TaxKind_Value TFloat
             , EKPrice TFloat, EKPriceWVAT TFloat
             , SalePrice TFloat, SalePriceWVAT TFloat
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptService());


   -- результат
   RETURN QUERY
      SELECT Object_ReceiptService.Id               AS Id
           , Object_ReceiptService.ObjectCode       AS Code
           , Object_ReceiptService.ValueData        AS Name
           , ObjectString_Article.ValueData         AS Article
           , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment

           , Object_TaxKind.Id                      AS TaxKindId
           , Object_TaxKind.ValueData               AS TaxKindName
           , ObjectFloat_TaxKind_Value.ValueData    AS TaxKind_Value
           --цена Вх. цена без ндс
           , COALESCE (ObjectFloat_EKPrice.ValueData,0)   ::TFloat AS EKPrice
           --цена Вх. цена с ндс
           , CAST (COALESCE (ObjectFloat_EKPrice.ValueData,0) 
                   * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT
           --цена Цена продажи без ндс
           , COALESCE (ObjectFloat_SalePrice.ValueData,0) ::TFloat AS SalePrice
           --цена Цена продажи с ндс
           , CAST (COALESCE (ObjectFloat_SalePrice.ValueData,0) 
                   * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS SalePriceWVAT

           , Object_Insert.ValueData                AS InsertName
           , ObjectDate_Insert.ValueData            AS InsertDate
           , Object_ReceiptService.isErased         AS isErased
       FROM Object AS Object_ReceiptService
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptService_Comment()

           LEFT JOIN ObjectString AS ObjectString_Article
                                  ON ObjectString_Article.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                 ON ObjectFloat_EKPrice.ObjectId = Object_ReceiptService.Id
                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()

           LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                 ON ObjectFloat_SalePrice.ObjectId = Object_ReceiptService.Id
                                AND ObjectFloat_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

           LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                ON ObjectLink_TaxKind.ObjectId = Object_ReceiptService.Id
                               AND ObjectLink_TaxKind.DescId = zc_ObjectLink_ReceiptService_TaxKind()
           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                 ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = Object_ReceiptService.Id
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_Insert
                                ON ObjectDate_Insert.ObjectId = Object_ReceiptService.Id
                               AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_ReceiptService.DescId = zc_Object_ReceiptService()
         AND (Object_ReceiptService.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
11.12.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptService (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
