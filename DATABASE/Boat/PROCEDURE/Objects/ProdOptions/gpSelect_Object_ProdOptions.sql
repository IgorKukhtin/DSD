-- Function: gpSelect_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions(Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptions(
    IN inModelId     Integer,
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ModelId Integer, ModelCode Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar
             , ProdColorPatternId Integer
             , GoodsId Integer, GoodsId_choice Integer, GoodsCode Integer, GoodsName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar, TaxKind_Value TFloat
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , SalePrice TFloat, SalePriceWVAT TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , MaterialOptionsName TVarChar
             , Id_Site TVarChar
             , CodeVergl Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptions());
     vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     RETURN QUERY
     WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )
          -- Опции, которые определены как Boat Structure
        , tmpProdColorPattern AS (SELECT ObjectLink_ProdOptions.ObjectId      AS ProdColorPatternId
                                       , ObjectLink_ProdOptions.ChildObjectId AS ProdOptionsId

                                       , Object_Goods.Id                    ::Integer  AS GoodsId
                                       , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
                                       , Object_Goods.ValueData             ::TVarChar AS GoodsName

                                       , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
                                       , Object_GoodsGroup.ValueData                AS GoodsGroupName
                                       , ObjectString_Article.ValueData             AS Article
                                       , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
                                       , Object_Measure.ValueData                   AS MeasureName

                                       , Object_TaxKind.Id                   AS TaxKindId
                                       , Object_TaxKind.ValueData            AS TaxKindName
                                       , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value

                                         -- Цена вх. без НДС
                                       , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                                        -- Цена вх. с НДС
                                      , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                            * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

                                        -- Цена продажи без НДС
                                      , CASE WHEN vbPriceWithVAT = FALSE
                                             THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                             ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                        END ::TFloat  AS BasisPrice
                                        -- Цена продажи с НДС
                                      , CASE WHEN vbPriceWithVAT = FALSE
                                             THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                             ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                                        END ::TFloat  AS BasisPriceWVAT

                                        -- № п/п - на всякий случай
                                      , ROW_NUMBER() OVER (PARTITION BY Object_ProdOptions.Id ORDER BY Object_ProdColorPattern.Id ASC) AS Ord

                                  FROM ObjectLink AS ObjectLink_ProdOptions
                                       INNER JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId
                                       -- Элемент Boat Structure не удален
                                       INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id       = ObjectLink_ProdOptions.ObjectId
                                                                                   AND Object_ProdColorPattern.isErased = FALSE
                                       LEFT JOIN ObjectString AS ObjectString_Comment
                                                              ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                                             AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()
                                       -- Комплектующие
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                            ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                                                           AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
                                       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
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
                                                             ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                            AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                                       LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

                                  WHERE ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdColorPattern_ProdOptions()
                                 )
     -- Результат
     SELECT
           Object_ProdOptions.Id           AS Id
         , Object_ProdOptions.ObjectCode   AS Code
         , Object_ProdOptions.ValueData    AS Name

         , Object_Model.Id         ::Integer  AS ModelId
         , Object_Model.ObjectCode ::Integer  AS ModelCode
         , Object_Model.ValueData  ::TVarChar AS ModelName
         , Object_Brand.Id                    AS BrandId
         , Object_Brand.ValueData             AS BrandName
         , Object_ProdEngine.Id               AS ProdEngineId
         , Object_ProdEngine.ValueData        AS ProdEngineName

         , COALESCE (tmpProdColorPattern.ProdColorPatternId, 0) :: Integer  AS ProdColorPatternId

         , Object_Goods.Id                                                   :: Integer  AS GoodsId
         , COALESCE (tmpProdColorPattern.GoodsId, Object_Goods.Id)           :: Integer  AS GoodsId_choice
         , COALESCE (tmpProdColorPattern.GoodsCode, Object_Goods.ObjectCode) :: Integer  AS GoodsCode
         , COALESCE (tmpProdColorPattern.GoodsName, Object_Goods.ValueData)  :: TVarChar AS GoodsName

         , Object_TaxKind.Id                                                                 AS TaxKindId
         , COALESCE (tmpProdColorPattern.TaxKindName, Object_TaxKind.ValueData)              AS TaxKindName
         , COALESCE (tmpProdColorPattern.TaxKind_Value, ObjectFloat_TaxKind_Value.ValueData) AS TaxKind_Value

           -- Цена вх. без НДС - всегда из товара
         , COALESCE (tmpProdColorPattern.EKPrice, ObjectFloat_EKPrice.ValueData) :: TFloat AS EKPrice
           -- Цена вх. с НДС
         , COALESCE (tmpProdColorPattern.EKPriceWVAT,
           CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
              * (1 + (COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT

           -- Цена продажи без НДС - всегда из товара
         , COALESCE (tmpProdColorPattern.BasisPrice,
           CASE WHEN vbPriceWithVAT = FALSE
                THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
           END) :: TFloat AS BasisPrice

           -- Цена продажи с НДС
         , COALESCE (tmpProdColorPattern.BasisPrice,
           CASE WHEN vbPriceWithVAT = FALSE
                THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
           END) :: TFloat  AS BasisPriceWVAT

           -- цена продажи без НДС - если товар указан то берем цену товара, иначе это Boat Structure тогда берем SalePrice
         , CASE WHEN ObjectLink_Goods.ChildObjectId > 0
                     THEN CASE WHEN vbPriceWithVAT = FALSE
                               THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                               ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                          END
                ELSE -- опция - Цена продажи без НДС
                     ObjectFloat_SalePrice.ValueData

           END :: TFloat AS SalePrice

           -- цена продажи с НДС - если товар указан то берем цену товара, иначе это Boat Structure тогда берем SalePrice
         , CASE WHEN ObjectLink_Goods.ChildObjectId > 0
                     THEN CASE WHEN vbPriceWithVAT = FALSE
                               THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                               ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                          END
                ELSE -- опция - Цена продажи с НДС
                     CAST (COALESCE (ObjectFloat_SalePrice.ValueData, 0)
                        * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))
           END :: TFloat AS SalePriceWVAT

         , ObjectString_Comment.ValueData  AS Comment

         , Object_Insert.ValueData         AS InsertName
         , ObjectDate_Insert.ValueData     AS InsertDate
         , Object_ProdOptions.isErased     AS isErased

         , COALESCE (tmpProdColorPattern.GoodsGroupNameFull, ObjectString_GoodsGroupFull.ValueData) ::TVarChar  AS GoodsGroupNameFull
         , COALESCE (tmpProdColorPattern.GoodsGroupName, Object_GoodsGroup.ValueData)               ::TVarChar  AS GoodsGroupName
         , COALESCE (tmpProdColorPattern.Article, ObjectString_Article.ValueData)                   ::TVarChar  AS Article
         , COALESCE (tmpProdColorPattern.ProdColorName, Object_ProdColor.ValueData)                 ::TVarChar  AS ProdColorName
         , COALESCE (tmpProdColorPattern.MeasureName, Object_Measure.ValueData)                     ::TVarChar  AS MeasureName

         , Object_MaterialOptions.ValueData                       AS MaterialOptionsName
         , ObjectString_Id_Site.ValueData                         AS Id_Site
         , ObjectFloat_ProdOptions_CodeVergl.ValueData :: Integer AS CodeVergl

     FROM Object AS Object_ProdOptions
          LEFT JOIN ObjectString AS ObjectString_Comment
          
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptions.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptions_Comment()

          -- Boat Structure
          LEFT JOIN tmpProdColorPattern ON tmpProdColorPattern.ProdOptionsId = Object_ProdOptions.Id
                                       -- на всякий случай
                                       AND tmpProdColorPattern.Ord           = 1

          -- Цена продажи Опции
          LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_SalePrice.DescId = zc_ObjectFloat_ProdOptions_SalePrice()
          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_ProdOptions_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                               AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

          LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                               ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
          LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Id_Site
                                 ON ObjectString_Id_Site.ObjectId = Object_ProdOptions.Id
                                AND ObjectString_Id_Site.DescId = zc_ObjectString_Id_Site()
          LEFT JOIN ObjectFloat AS ObjectFloat_ProdOptions_CodeVergl
                                ON ObjectFloat_ProdOptions_CodeVergl.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_ProdOptions_CodeVergl.DescId = zc_ObjectFloat_ProdOptions_CodeVergl()

          -- Модель
          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

          -- Комплектующие
          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdOptions_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
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

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_goods
                                ON ObjectFloat_TaxKind_Value_goods.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                               AND ObjectFloat_TaxKind_Value_goods.DescId = zc_ObjectFloat_TaxKind_Value()

          LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

          --
          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdOptions.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdOptions.DescId = zc_Object_ProdOptions()
      AND (ObjectLink_Model.ChildObjectId = inModelId OR inModelId = 0 OR COALESCE (ObjectLink_Model.ChildObjectId,0) = 0)
      AND (Object_ProdOptions.isErased = FALSE OR inIsShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.12.20         *
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdOptions (0, False, zfCalc_UserAdmin())
