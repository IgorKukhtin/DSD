-- Function: gpSelect_Object_ProdOptItems()

--DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptItems(
    IN inIsShowAll   Boolean,       -- признак показать все (уникальные по всему справочнику)
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет
    IN inIsSale      Boolean,       -- признак показать проданные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , PriceIn TFloat, PriceOut TFloat
             , PartNumber TVarChar, Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , ProdOptPatternId Integer, ProdOptPatternName TVarChar
             , Color_fon Integer
             , InsertName TVarChar
             , InsertDate TDateTime
             , isSale Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptItems());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- Результат
     RETURN QUERY
     WITH
         --базовые цены
         tmpPriceBasis AS (SELECT tmp.GoodsId
                                , tmp.ValuePrice
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                    , inOperDate   := CURRENT_DATE) AS tmp
                          )
           -- все лодки + определяем продана да/нет
         , tmpProduct AS (SELECT Object_Product.*
                               , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                          FROM Object AS Object_Product
                               LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                                    ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                                   AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()
                          WHERE Object_Product.DescId = zc_Object_Product()
                           AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                          )
        -- существующие элементы Boat Structure - добавить как Опция
      , tmpProdColorItems AS
                   (SELECT Object_ProdColorItems.Id         AS Id
                         , Object_ProdColorItems.ObjectCode AS Code
                         , Object_ProdColorItems.ValueData  AS Name
                         , Object_ProdColorItems.isErased   AS isErased

                         , ObjectLink_Product.ChildObjectId          AS ProductId
                         , ObjectLink_Goods.ChildObjectId            AS GoodsId
                         , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId

                           -- Цена вх. без НДС
                         , ObjectFloat_EKPrice.ValueData AS EKPrice
                           -- Цена вх. с НДС
                         , CAST (ObjectFloat_EKPrice.ValueData
                                * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT

                           -- Цена продажи без ндс
                         , CASE WHEN vbPriceWithVAT = FALSE
                                THEN tmpPriceBasis.ValuePrice
                                ELSE CAST (tmpPriceBasis.ValuePrice * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                           END  :: TFloat AS BasisPrice
                           -- Цена продажи с ндс
                         , CASE WHEN vbPriceWithVAT = FALSE
                                THEN CAST (tmpPriceBasis.ValuePrice * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                ELSE tmpPriceBasis.ValuePrice
                           END ::TFloat AS BasisPriceWVAT

                    FROM Object AS Object_ProdColorItems
                         -- Лодка
                         LEFT JOIN ObjectLink AS ObjectLink_Product
                                              ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
                         INNER JOIN tmpProduct ON tmpProduct.Id = ObjectLink_Product.ChildObjectId

                         -- условие что надо добавить в Опцию
                         INNER JOIN ObjectBoolean AS ObjectBoolean_ProdOptions
                                                  ON ObjectBoolean_ProdOptions.ObjectId  = Object_ProdColorItems.Id
                                                 AND ObjectBoolean_ProdOptions.DescId    = zc_ObjectBoolean_ProdColorItems_ProdOptions()
                                                 AND ObjectBoolean_ProdOptions.ValueData = TRUE

                         -- если меняли на другой товар, не тот что в ReceiptGoodsChild
                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                              ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
                         -- Элемент
                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                              ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()

                         LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Goods.ChildObjectId

                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                               ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Goods.ChildObjectId
                                              AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                         LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                              ON ObjectLink_Goods_TaxKind.ObjectId = ObjectLink_Goods.ChildObjectId
                                             AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                         LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

                         LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                               ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods.ChildObjectId
                                              AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

                    WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                     AND (Object_ProdColorItems.isErased = FALSE OR inIsErased = TRUE)
                   )
         -- существующие элементы ProdOptItems
       , tmpRes AS (SELECT Object_ProdOptItems.Id           AS Id
                         , Object_ProdOptItems.ObjectCode   AS Code
                         , Object_ProdOptItems.ValueData    AS Name
                         , Object_ProdOptItems.isErased     AS isErased

                         , ObjectLink_Product.ChildObjectId        AS ProductId
                         , 0                            :: Integer AS GoodsId
                         , ObjectLink_ProdOptPattern.ChildObjectId AS ProdOptPatternId

                         , ObjectFloat_PriceIn.ValueData      ::TFloat    AS PriceIn
                         , 0                                  ::TFloat    AS PriceInWVAT
                         , ObjectFloat_PriceOut.ValueData     ::TFloat    AS PriceOut
                         , 0                                  ::TFloat    AS PriceOutWVAT

                    FROM Object AS Object_ProdOptItems
                         -- Лодка
                         LEFT JOIN ObjectLink AS ObjectLink_Product
                                              ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdOptItems_Product()
                         INNER JOIN tmpProduct ON tmpProduct.Id = ObjectLink_Product.ChildObjectId

                         -- Элемент
                         LEFT JOIN ObjectLink AS ObjectLink_ProdOptPattern
                                              ON ObjectLink_ProdOptPattern.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectLink_ProdOptPattern.DescId   = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                        --
                        LEFT JOIN ObjectFloat AS ObjectFloat_PriceIn
                                              ON ObjectFloat_PriceIn.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectFloat_PriceIn.DescId = zc_ObjectFloat_ProdOptItems_PriceIn()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                              ON ObjectFloat_PriceOut.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectFloat_PriceOut.DescId = zc_ObjectFloat_ProdOptItems_PriceOut()

                    WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                     AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
                   UNION ALL
                    SELECT (-1 * tmpProdColorItems.Id) :: Integer AS Id
                         , tmpProdColorItems.Code
                         , tmpProdColorItems.Name
                         , tmpProdColorItems.isErased

                         , tmpProdColorItems.ProductId
                         , tmpProdColorItems.GoodsId
                           -- переименовали поле
                         , tmpProdColorItems.ProdColorPatternId AS ProdOptPatternId

                           -- Цена вх. без НДС
                         , tmpProdColorItems.EKPrice        AS PriceIn
                           -- Цена вх. с НДС                
                         , tmpProdColorItems.EKPriceWVAT    AS PriceInWVAT
                                                            
                           -- Цена продажи без ндс          
                         , tmpProdColorItems.BasisPrice     AS PriceOut
                           -- Цена продажи с ндс
                         , tmpProdColorItems.BasisPriceWVAT AS PriceOutWVAT

                    FROM tmpProdColorItems
                   )
     -- Результат
     SELECT
           Object_ProdOptItems.Id
         , Object_ProdOptItems.Code
         , Object_ProdOptItems.Name
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdOptPattern.ObjectCode ASC, Object_ProdOptPattern.Id ASC) :: Integer AS NPP

         , Object_ProdOptItems.PriceIn
         , Object_ProdOptItems.PriceOut
         , ObjectString_PartNumber.ValueData  ::TVarChar  AS PartNumber
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_ProdOptions.Id            AS ProdOptionsId
         , CASE WHEN Object_ProdOptItems.Id < 0
                     THEN Object_ProdColorGroup.ValueData || ' ~' || Object_ProdColorPattern.ValueData || ' ~' || Object_ProdColor.ValueData
                ELSE Object_ProdOptions.ValueData
           END :: TVarChar AS ProdOptionsName

         , Object_ProdOptPattern.Id           ::Integer  AS ProdOptPatternId
         , Object_ProdOptPattern.ValueData    ::TVarChar AS ProdOptPatternName

         , CASE WHEN CEIL (Object_ProdOptItems.Code / 2) * 2 <> Object_ProdOptItems.Code
                     THEN zc_Color_Aqua()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS Color_fon

         , Object_Insert.ValueData            ::TVarChar  AS InsertName
         , ObjectDate_Insert.ValueData        ::TDateTime AS InsertDate
         , Object_Product.isSale              ::Boolean   AS isSale
         , Object_ProdOptItems.isErased       ::Boolean   AS isErased

     FROM tmpRes AS Object_ProdOptItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptItems_Comment()
          LEFT JOIN ObjectString AS ObjectString_PartNumber
                                 ON ObjectString_PartNumber.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_PartNumber.DescId = zc_ObjectString_ProdOptItems_PartNumber()

          LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                               ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN tmpProduct AS Object_Product    ON Object_Product.Id        = Object_ProdOptItems.ProductId
          LEFT JOIN Object AS Object_ProdOptPattern ON Object_ProdOptPattern.Id = Object_ProdOptItems.ProdOptPatternId

          -- Boat Structure - добавить как Опция
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = Object_ProdOptItems.ProdOptPatternId
          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdOptItems.ProdOptPatternId
                              AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_ProdOptItems.GoodsId
                              AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdOptItems (false, false, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ProdOptItems (false, false,true, zfCalc_UserAdmin())
