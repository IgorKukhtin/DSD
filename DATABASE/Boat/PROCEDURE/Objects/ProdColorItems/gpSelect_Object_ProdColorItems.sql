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
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
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
             , EKPrice TFloat, EKPriceWVAT TFloat
             , EmpfPrice TFloat, EmpfPriceWVAT TFloat
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

     RETURN QUERY
     WITH
     --базовые цены
     tmpPriceBasis AS (SELECT tmp.GoodsId
                            , tmp.ValuePrice
                       FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                , inOperDate   := CURRENT_DATE) AS tmp
                      )
     -- получили все шаблоны
   , tmpProdColorPattern AS (SELECT Object_ProdColorPattern.Id      AS ProdColorPatternId
                                  , ObjectLink_Goods.ChildObjectId  AS GoodsId
                             FROM Object AS Object_ProdColorPattern
                                  INNER JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                                                       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
                             WHERE Object_ProdColorPattern.DescId   = zc_Object_ProdColorPattern()
                               AND Object_ProdColorPattern.isErased = FALSE
                               AND inIsShowAll = TRUE
                            )
   -- выбираем все лодки + определяем продана да/нет
   , tmpProduct AS (SELECT Object_Product.*
                         , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                    FROM Object AS Object_Product
                         LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                              ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                             AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()
                    WHERE Object_Product.DescId = zc_Object_Product()
                     AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                    )

   , tmpRes_all AS (SELECT Object_ProdColorItems.Id         AS Id
                         , Object_ProdColorItems.ObjectCode AS Code
                         , Object_ProdColorItems.ValueData  AS Name
                         , Object_ProdColorItems.isErased   AS isErased

                         , ObjectLink_Product.ChildObjectId          AS ProductId
                         , ObjectLink_Goods.ChildObjectId            AS GoodsId
                         , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId

                    FROM Object AS Object_ProdColorItems
                         LEFT JOIN ObjectLink AS ObjectLink_Product
                                              ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
                         INNER JOIN tmpProduct ON tmpProduct.Id = ObjectLink_Product.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                              ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()

                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                              ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()

                    WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                     AND (Object_ProdColorItems.isErased = FALSE OR inIsErased = TRUE)
                   )
       , tmpRes AS (SELECT tmpRes_all.Id
                         , tmpRes_all.Code
                         , tmpRes_all.Name
                         , tmpRes_all.isErased
                         , tmpRes_all.ProductId
                         , tmpRes_all.GoodsId
                         , tmpRes_all.ProdColorPatternId
                     FROM tmpRes_all

                   UNION ALL
                    SELECT
                          0     :: Integer  AS Id
                        , 0     :: Integer  AS Code
                        , ''    :: TVarChar AS Name
                        , FALSE :: Boolean  AS isErased

                        , Object_Product.Id AS ProductId
                        , tmpProdColorPattern.GoodsId
                        , tmpProdColorPattern.ProdColorPatternId
                    FROM tmpProdColorPattern
                         JOIN tmpProduct AS Object_Product ON Object_Product.isErased = FALSE
                         LEFT JOIN tmpRes_all ON tmpRes_all.ProductId = Object_Product.Id
                                             AND COALESCE (tmpRes_all.GoodsId,0) = COALESCE (tmpProdColorPattern.GoodsId,0)
                                             AND tmpRes_all.ProdColorPatternId = tmpProdColorPattern.ProdColorPatternId
                    WHERE tmpRes_all.ProductId IS NULL
                   )

     -- Результат
     SELECT
           Object_ProdColorItems.Id    AS Id
         , Object_ProdColorItems.Code  AS Code
         , Object_ProdColorItems.Name  AS Name
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_Goods.ObjectCode ASC, Object_ProdColorPattern.ObjectCode ASC, Object_ProdColorPattern.Id ASC) :: Integer AS NPP

         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_Goods.Id           ::Integer   AS GoodsId
         , Object_Goods.ObjectCode   ::Integer   AS GoodsCode
         , Object_Goods.ValueData    ::TVarChar  AS GoodsName

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
         , Object_Product.isSale ::Boolean  AS isSale
         , Object_ProdColorItems.isErased   AS isErased

         --
         , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Article.ValueData             AS Article
         , CASE WHEN Object_ProdColorItems.GoodsId IS NULL THEN ObjectString_ProdColorPattern_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
         , Object_Measure.ValueData                   AS MeasureName

         , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
         , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
              * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

         , ObjectFloat_EmpfPrice.ValueData ::TFloat   AS EmpfPrice
         , CAST (COALESCE (ObjectFloat_EmpfPrice.ValueData, 0)
              * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100) ) AS NUMERIC (16, 2)) ::TFloat AS EmpfPriceWVAT-- расчет рекомендованной цены с НДС, до 4 знаков

          -- расчет базовой цены без НДС, до 2 знаков
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
               ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
          END ::TFloat  AS BasisPrice   -- сохраненная цена - цена без НДС

          -- расчет базовой цены с НДС, до 2 знаков
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
               ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
          END ::TFloat  AS BasisPriceWVAT

     FROM tmpRes AS Object_ProdColorItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorItems_Comment()

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
          LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                               AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

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
