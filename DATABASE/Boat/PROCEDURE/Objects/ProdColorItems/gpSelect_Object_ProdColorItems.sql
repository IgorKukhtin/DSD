 -- Function: gpSelect_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorItems(
    IN inIsShowAll   Boolean,       -- признак показать все (уникальные по всему справочнику)
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет
    IN inIsSale      Boolean,       -- признак показать проданные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , Comment TVarChar

             , ProductId Integer, ProductName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsId_Receipt Integer
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar

             , Color_fon Integer

             , InsertName TVarChar
             , InsertDate TDateTime

             , isProdOptions Boolean
             , isDiff Boolean
             , isEnabled Boolean
             , isSale Boolean
             , isErased Boolean

             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorItems());
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
          -- элементы ReceiptProdModelChild
        , tmpReceiptProdModelChild AS(SELECT Object_ReceiptProdModel.Id                      AS ReceiptProdModelId
                                           , Object_ReceiptProdModelChild.Id                 AS ReceiptProdModelChildId
                                             -- Модель лодки у шаблона ProdModel
                                           , ObjectLink_Model.ChildObjectId                  AS ModelId
                                             -- элемент который будем раскладывать
                                           , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                             -- значение                                     
                                           , ObjectFloat_Value.ValueData                     AS Value

                                      FROM Object AS Object_ReceiptProdModel
                                           -- это главный шаблон ProdModel
                                           INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                    ON ObjectBoolean_Main.ObjectId  = Object_ReceiptProdModel.Id
                                                                   AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptProdModel_Main()
                                                                   AND ObjectBoolean_Main.ValueData = TRUE
                                           -- Модель лодки у шаблона ProdModel
                                           LEFT JOIN ObjectLink AS ObjectLink_Model
                                                                ON ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                                                               AND ObjectLink_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()
                                           -- элементы ReceiptProdModelChild
                                           INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                                 ON ObjectLink_ReceiptProdModel.ChildObjectId = Object_ReceiptProdModel.Id
                                                                AND ObjectLink_ReceiptProdModel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                           -- элемент не удален
                                           INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModel.ObjectId
                                                                                            AND Object_ReceiptProdModelChild.isErased = FALSE
                                           -- из чего собирается
                                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                           -- значение в сборке
                                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                                 ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptProdModelChild_Value()

                                      WHERE Object_ReceiptProdModel.DescId   = zc_Object_ReceiptProdModel()
                                        AND Object_ReceiptProdModel.isErased = FALSE
                                     )
          -- раскладываем ReceiptProdModelChild - для каждой ModelId
        , tmpProdColorPattern AS (SELECT tmpReceiptProdModelChild.ModelId                  AS ModelId
                                       , tmpReceiptProdModelChild.ReceiptProdModelId       AS ReceiptProdModelId
                                       , tmpReceiptProdModelChild.ReceiptProdModelChildId  AS ReceiptProdModelChildId
                                       , Object_ReceiptGoodsChild.Id                       AS ReceiptGoodsChildId
                                         -- если меняли на другой товар, не тот что в Boat Structure
                                       , ObjectLink_Object.ChildObjectId                   AS GoodsId
                                         -- нашли Элемент Boat Structure
                                       , ObjectLink_ProdColorPattern.ChildObjectId         AS ProdColorPatternId
                                         -- умножили
                                       , tmpReceiptProdModelChild.Value * ObjectFloat_Value.ValueData AS Value
                                  FROM tmpReceiptProdModelChild
                                       -- нашли его в сборке узлов
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                             ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                                            AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                       -- это главный шаблон
                                       INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                ON ObjectBoolean_Main.ObjectId  = ObjectLink_ReceiptGoods_Object.ObjectId
                                                               AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                                               AND ObjectBoolean_Main.ValueData = TRUE
                                       -- из чего состоит
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                             ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = ObjectLink_ReceiptGoods_Object.ObjectId
                                                            AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                       -- не удален
                                       INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                    AND Object_ReceiptGoodsChild.isErased = FALSE
                                       -- только с такой структурой
                                       INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                             ON ObjectLink_ProdColorPattern.ObjectId      = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                                            AND ObjectLink_ProdColorPattern.ChildObjectId <> 0
                                       -- если была "замена" - "Комплектующего"
                                       LEFT JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                       -- значение в сборке
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                 )
     -- все лодки + определяем продана да/нет
   , tmpProduct AS (SELECT Object_Product.*
                         , ObjectLink_Model.ChildObjectId AS ModelId
                         , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                    FROM Object AS Object_Product
                         -- Модель лодки
                         LEFT JOIN ObjectLink AS ObjectLink_Model
                                              ON ObjectLink_Model.ObjectId = Object_Product.Id
                                             AND ObjectLink_Model.DescId   = zc_ObjectLink_Product_Model()
                         -- продана да/нет
                         LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                              ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                             AND ObjectDate_DateSale.DescId   = zc_ObjectDate_Product_DateSale()
                    WHERE Object_Product.DescId = zc_Object_Product()
                     AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                   )
     -- существующие элементы Boat Structure
   , tmpRes_all AS (SELECT Object_ProdColorItems.Id         AS Id
                         , Object_ProdColorItems.ObjectCode AS Code
                         , Object_ProdColorItems.ValueData  AS Name
                         , Object_ProdColorItems.isErased   AS isErased

                         , ObjectLink_Product.ChildObjectId          AS ProductId
                         , ObjectLink_Goods.ChildObjectId            AS GoodsId
                         , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId

                    FROM Object AS Object_ProdColorItems
                         -- Лодка
                         INNER JOIN ObjectLink AS ObjectLink_Product
                                              ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
                         INNER JOIN tmpProduct ON tmpProduct.Id = ObjectLink_Product.ChildObjectId

                         -- если меняли на другой товар, не тот что в ReceiptGoodsChild
                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                              ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
                         -- Элемент
                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                              ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()

                    WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                     AND (Object_ProdColorItems.isErased = FALSE OR inIsErased = TRUE)
                   )
       , tmpRes AS (SELECT tmpRes_all.Id
                         , tmpRes_all.Code
                         , tmpRes_all.Name
                         , CASE WHEN tmpProdColorPattern.ProdColorPatternId > 0 AND COALESCE (tmpProdColorPattern.GoodsId, 0) <> COALESCE (tmpRes_all.GoodsId, 0)
                                     THEN TRUE
                                ELSE FALSE
                           END  :: Boolean AS isDiff
                         , TRUE :: Boolean AS isEnabled
                         , tmpRes_all.isErased
                         , tmpRes_all.ProductId
                         , tmpRes_all.GoodsId
                         , tmpRes_all.ProdColorPatternId
                         , tmpProdColorPattern.GoodsId AS GoodsId_Receipt
                     FROM tmpRes_all
                          LEFT JOIN tmpProduct ON tmpProduct.Id = tmpRes_all.ProductId
                          LEFT JOIN tmpProdColorPattern ON tmpProdColorPattern.ModelId            = tmpProduct.ModelId
                                                       AND tmpProdColorPattern.ProdColorPatternId = tmpRes_all.ProdColorPatternId

                   UNION ALL
                    SELECT
                           0     :: Integer  AS Id
                         , 0     :: Integer  AS Code
                         , ''    :: TVarChar AS Name
                         , FALSE :: Boolean  AS isDiff
                         , FALSE :: Boolean  AS isEnabled
                         , FALSE :: Boolean  AS isErased
 
                         , tmpProduct.Id     AS ProductId
                         , tmpProdColorPattern.GoodsId
                         , tmpProdColorPattern.ProdColorPatternId
                         , tmpProdColorPattern.GoodsId AS GoodsId_Receipt
                    FROM tmpProdColorPattern
                         JOIN tmpProduct ON tmpProduct.ModelId = tmpProdColorPattern.ModelId
                         LEFT JOIN tmpRes_all ON tmpRes_all.ProductId          = tmpProduct.Id
                                             AND tmpRes_all.ProdColorPatternId = tmpProdColorPattern.ProdColorPatternId
                    WHERE tmpRes_all.ProductId IS NULL
                      AND inIsShowAll          = TRUE
                   )

     -- Результат
     SELECT
           Object_ProdColorItems.Id    AS Id
         , Object_ProdColorItems.Code  AS Code
         , Object_ProdColorItems.Name  AS Name
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdColorPattern.ObjectCode ASC, Object_ProdColorPattern.Id ASC) :: Integer AS NPP

         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_Goods.Id           ::Integer   AS GoodsId
         , Object_Goods.ObjectCode   ::Integer   AS GoodsCode
         , Object_Goods.ValueData    ::TVarChar  AS GoodsName
         
         , Object_ProdColorItems.GoodsId_Receipt

         , Object_ProdColorPattern.Id         ::Integer   AS ProdColorPatternId
         , Object_ProdColorPattern.ValueData  ::TVarChar  AS ProdColorPatternName
         , Object_ProdColorGroup.Id           ::Integer   AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar  AS ProdColorGroupName
         
         , CASE WHEN CEIL (Object_ProdColorGroup.ObjectCode / 2) * 2 <> Object_ProdColorGroup.ObjectCode
                     THEN zc_Color_Yelow() -- zc_Color_Lime() -- zc_Color_Aqua()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS Color_fon

         , Object_Insert.ValueData          AS InsertName
         , ObjectDate_Insert.ValueData      AS InsertDate

         , COALESCE (ObjectBoolean_ProdOptions.ValueData, FALSE) :: Boolean AS isProdOptions
         , Object_ProdColorItems.isDiff     AS isDiff
         , Object_ProdColorItems.isEnabled  AS isEnabled
         , Object_Product.isSale            AS isSale
         , Object_ProdColorItems.isErased   AS isErased

         --
         , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Article.ValueData             AS Article
         , CASE WHEN Object_ProdColorItems.GoodsId IS NULL THEN ObjectString_ProdColorPattern_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
         , Object_Measure.ValueData                   AS MeasureName

          -- Цена вх. без НДС
         , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
           -- Цена вх. с НДС                
         , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
              * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

          -- Цена продажи без ндс          
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
               ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
          END ::TFloat  AS BasisPrice   -- сохраненная цена - цена без НДС

          -- Цена продажи с ндс
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
               ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
          END ::TFloat  AS BasisPriceWVAT

     FROM tmpRes AS Object_ProdColorItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorItems_Comment()
          -- добавить как Опцию (да/нет)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_ProdOptions
                                  ON ObjectBoolean_ProdOptions.ObjectId = Object_ProdColorItems.Id
                                 AND ObjectBoolean_ProdOptions.DescId   = zc_ObjectBoolean_ProdColorItems_ProdOptions()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdColorItems.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN tmpProduct AS Object_Product      ON Object_Product.Id          = Object_ProdColorItems.ProductId
          LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = Object_ProdColorItems.GoodsId
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = Object_ProdColorItems.ProdColorPatternId

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                 ON ObjectString_ProdColorPattern_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_ProdColorPattern_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          --        
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Goods.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                               AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                               ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                               AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

          LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id
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
--  SELECT * FROM gpSelect_Object_ProdColorItems (false,false,false, zfCalc_UserAdmin())
