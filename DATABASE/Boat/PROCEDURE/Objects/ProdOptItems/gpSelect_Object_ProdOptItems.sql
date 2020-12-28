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
             --, PriceIn TFloat, PriceOut TFloat
             , PartNumber TVarChar, Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , ProdOptPatternId Integer, ProdOptPatternName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Color_fon Integer
             , InsertName TVarChar
             , InsertDate TDateTime
             , isSale Boolean
             , isErased Boolean

             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , EKPrice        TFloat
             , EKPriceWVAT    TFloat
             , BasisPrice     TFloat
             , BasisPriceWVAT TFloat

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

                           -- Цена продажи без НДС
                         , CASE WHEN vbPriceWithVAT = FALSE
                                THEN tmpPriceBasis.ValuePrice
                                ELSE CAST (tmpPriceBasis.ValuePrice * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                           END  :: TFloat AS BasisPrice
                           -- Цена продажи с НДС
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
                         , ObjectLink_Goods.ChildObjectId          AS GoodsId
                         , ObjectLink_ProdOptPattern.ChildObjectId AS ProdOptPatternId
                         , ObjectLink_ProdOptions.ChildObjectId    AS ProdOptionsId

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
                         -- Комплектующие
                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                              ON ObjectLink_Goods.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdOptItems_Goods()
                         -- Опции
                         LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                              ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
                         LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId

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
                         , 0 ::Integer AS ProdOptionsId

                           -- Цена вх. без НДС
                         , tmpProdColorItems.EKPrice        AS PriceIn
                           -- Цена вх. с НДС                
                         , tmpProdColorItems.EKPriceWVAT    AS PriceInWVAT
                                                            
                           -- Цена продажи без НДС          
                         , tmpProdColorItems.BasisPrice     AS PriceOut
                           -- Цена продажи с НДС
                         , tmpProdColorItems.BasisPriceWVAT AS PriceOutWVAT

                    FROM tmpProdColorItems
                   )
       -- свойства для комплектующих
       , tmpParams AS (SELECT tmpObject.ProdOptionsId
                            , tmpObject.GoodsId
                            , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
                            , Object_GoodsGroup.ValueData                AS GoodsGroupName
                            , ObjectString_Article.ValueData             AS Article
                            , Object_ProdColor.ValueData                 AS ProdColorName
                            , Object_Measure.ValueData                   AS MeasureName

                            -- вх. цена всегда берем у товара
                            , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                            , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                 * (1 + (COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

                             -- цена продажи  если товар указан то берем цену товара, только если нет товара берем SalePrice 
                             -- расчет базовой цены без НДС, до 2 знаков
                           , CASE WHEN COALESCE (tmpObject.GoodsId,0) <> 0 THEN CASE WHEN vbPriceWithVAT = FALSE
                                                                                     THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                                                                     ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                                                                END
                                  ELSE COALESCE (ObjectFloat_SalePrice.ValueData,0)
                             END ::TFloat  AS BasisPrice   -- сохраненная цена - цена без НДС

                             -- расчет базовой цены с НДС, до 2 знаков
                           , CASE WHEN COALESCE (tmpObject.GoodsId,0) <> 0 THEN CASE WHEN vbPriceWithVAT = FALSE
                                                                                     THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                                                                     ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                                                                                END
                                  ELSE CAST (COALESCE (ObjectFloat_SalePrice.ValueData, 0) * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))
                             END ::TFloat  AS BasisPriceWVAT

                       FROM (SELECT DISTINCT tmpRes.ProdOptionsId, tmpRes.GoodsId FROM tmpRes) AS tmpObject
                            -- Options
                            LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                                  ON ObjectFloat_SalePrice.ObjectId = tmpObject.ProdOptionsId
                                                 AND ObjectFloat_SalePrice.DescId = zc_ObjectFloat_ProdOptions_SalePrice()

                            LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                                 ON ObjectLink_TaxKind.ObjectId = tmpObject.ProdOptionsId
                                                AND ObjectLink_TaxKind.DescId = zc_ObjectLink_ProdOptions_TaxKind()

                            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                  ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                                                   
                            -- goods
                            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpObject.GoodsId
                                                  AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                            LEFT JOIN ObjectString AS ObjectString_Article
                                                   ON ObjectString_Article.ObjectId = tmpObject.GoodsId
                                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpObject.GoodsId
                                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                 ON ObjectLink_Goods_ProdColor.ObjectId = tmpObject.GoodsId
                                                AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = tmpObject.GoodsId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                  ON ObjectFloat_EKPrice.ObjectId = tmpObject.GoodsId
                                                 AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                 ON ObjectLink_Goods_TaxKind.ObjectId = tmpObject.GoodsId
                                                AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()

                            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_goods
                                                  ON ObjectFloat_TaxKind_Value_goods.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                 AND ObjectFloat_TaxKind_Value_goods.DescId = zc_ObjectFloat_TaxKind_Value()

                            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpObject.GoodsId
                       )

     -- Результат
     SELECT
           Object_ProdOptItems.Id
         , Object_ProdOptItems.Code
         , Object_ProdOptItems.Name
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdOptPattern.ObjectCode ASC, Object_ProdOptPattern.Id ASC) :: Integer AS NPP

         --, Object_ProdOptItems.PriceIn
         --, Object_ProdOptItems.PriceOut
         , ObjectString_PartNumber.ValueData  ::TVarChar  AS PartNumber
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_ProdOptions.Id            AS ProdOptionsId
         , CASE WHEN Object_ProdOptItems.Id < 0
                     THEN Object_ProdColorGroup.ValueData || ' ~' || Object_ProdColorPattern.ValueData || ' ~' || tmpParams.ProdColorName /*Object_ProdColor.ValueData*/
                ELSE Object_ProdOptions.ValueData
           END :: TVarChar AS ProdOptionsName

         , Object_ProdOptPattern.Id           ::Integer  AS ProdOptPatternId
         , Object_ProdOptPattern.ValueData    ::TVarChar AS ProdOptPatternName
         
         , Object_Goods.Id                    ::Integer  AS GoodsId
         , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
         , Object_Goods.ValueData             ::TVarChar AS GoodsName

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

         , tmpParams.GoodsGroupNameFull
         , tmpParams.GoodsGroupName
         , tmpParams.Article
         , tmpParams.ProdColorName
         , tmpParams.MeasureName

           -- Цена вх.
         , tmpParams.EKPrice        ::TFloat
         , tmpParams.EKPriceWVAT    ::TFloat
           -- Цена продажи
         , tmpParams.BasisPrice     ::TFloat
         , tmpParams.BasisPriceWVAT ::TFloat

     FROM tmpRes AS Object_ProdOptItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptItems_Comment()
          LEFT JOIN ObjectString AS ObjectString_PartNumber
                                 ON ObjectString_PartNumber.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_PartNumber.DescId = zc_ObjectString_ProdOptItems_PartNumber()

          /*LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                               ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
          */
          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = Object_ProdOptItems.ProdOptionsId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN tmpProduct AS Object_Product    ON Object_Product.Id        = Object_ProdOptItems.ProductId
          LEFT JOIN Object AS Object_ProdOptPattern ON Object_ProdOptPattern.Id = Object_ProdOptItems.ProdOptPatternId
          LEFT JOIN Object AS Object_Goods          ON Object_Goods.Id = Object_ProdOptItems.GoodsId

          -- Boat Structure - добавить как Опция
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = Object_ProdOptItems.ProdOptPatternId
          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdOptItems.ProdOptPatternId
                              AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          LEFT JOIN tmpParams ON tmpParams.ProdOptionsId = Object_ProdOptItems.ProdOptionsId
                             AND tmpParams.GoodsId = Object_ProdOptItems.GoodsId

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
