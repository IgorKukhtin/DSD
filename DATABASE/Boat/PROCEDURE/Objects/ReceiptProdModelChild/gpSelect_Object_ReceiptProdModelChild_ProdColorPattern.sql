-- Function: gpSelect_Object_ReceiptProdModelChild_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_ProdColorPattern (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_ProdColorPattern (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModelChild_ProdColorPattern(
    IN inReceiptLevelId  Integer,
    IN inIsErased        Boolean,       -- признак показать удаленные да / нет
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ReceiptProdModelId Integer
             , Value TFloat
             , isErased Boolean
             , NPP Integer

             , MaterialOptionsId Integer, MaterialOptionsName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternCode Integer, ProdColorPatternName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , EKPrice TFloat, EKPriceWVAT TFloat
             , EKPrice_summ TFloat, EKPriceWVAT_summ TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModelChild());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
     WITH
          -- элементы ReceiptProdModelChild
          tmpReceiptProdModelChild AS(SELECT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                                             -- элемент который будем раскладывать
                                           , ObjectLink_Object.ChildObjectId           AS ObjectId
                                             -- значение
                                           , ObjectFloat_Value.ValueData               AS Value
                                      FROM Object AS Object_ReceiptProdModelChild

                                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                                ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                                           -- из чего собирается
                                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                           -- шаблон ProdModel
                                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                                ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                            -- значение в сборке
                                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                                 ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptProdModelChild_Value()

                                      WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                                        AND Object_ReceiptProdModelChild.isErased = FALSE
                                        AND (ObjectLink_ReceiptLevel.ChildObjectId = inReceiptLevelId OR inReceiptLevelId = 0)
                                     )

          -- раскладываем ReceiptProdModelChild
        , tmpProdColorPattern AS (SELECT tmpReceiptProdModelChild.ReceiptProdModelId     AS ReceiptProdModelId
                                       , Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                                       , Object_ReceiptGoodsChild.ValueData              AS Comment
                                       , Object_ReceiptGoodsChild.isErased               AS isErased
                                         -- если меняли на другой товар, не тот что в Boat Structure
                                       , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                         -- нашли Элемент Boat Structure
                                       , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
                                         -- Категория Опций
                                       , ObjectLink_MaterialOptions.ChildObjectId        AS MaterialOptionsId
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
                                       -- элемент не удален
                                       INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                    AND Object_ReceiptGoodsChild.isErased = FALSE
                                       -- только с такой структурой
                                       INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                             ON ObjectLink_ProdColorPattern.ObjectId      = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                                            AND ObjectLink_ProdColorPattern.ChildObjectId <> 0
                                       -- если была "замена" - "Комплектующего"
                                       LEFT JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId      = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
                                       -- Категория Опций
                                       LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                            ON ObjectLink_MaterialOptions.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                                       -- значение в сборке
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                 )

     -- Результат
     SELECT tmpProdColorPattern.ReceiptGoodsChildId       AS Id
          , tmpProdColorPattern.ReceiptProdModelId        AS ReceiptProdModelId
          , tmpProdColorPattern.Value         :: TFloat   AS Value
          , tmpProdColorPattern.isErased      :: Boolean  AS isErased
          , ROW_NUMBER() OVER (PARTITION BY tmpProdColorPattern.ReceiptProdModelId ORDER BY Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP

          , Object_MaterialOptions.Id          ::Integer  AS MaterialOptionsId
          , Object_MaterialOptions.ValueData   ::TVarChar AS MaterialOptionsName

          , Object_ProdColorPattern.Id              AS ProdColorPatternId
          , Object_ProdColorPattern.ObjectCode      AS ProdColorPatternCode
          --, Object_ProdColorPattern.ValueData       AS ProdColorPatternName
          , (Object_ProdColorGroup.ValueData || CASE WHEN LENGTH (Object_ProdColorPattern.ValueData) > 1 THEN ' ' || Object_ProdColorPattern.ValueData ELSE '' END || ' (' || Object_Model_pcp.ValueData || ')') :: TVarChar  AS  ProdColorPatternName

          , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
          , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName
          , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
          , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName
          
          , Object_Goods.Id                    ::Integer  AS GoodsId
          , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
          , Object_Goods.ValueData             ::TVarChar AS GoodsName

          , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
          , Object_GoodsGroup.ValueData                AS GoodsGroupName
          , ObjectString_Article.ValueData             AS Article
            -- значение Farbe
          , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL AND tmpProdColorPattern.Comment <> ''
                      THEN tmpProdColorPattern.Comment
                 WHEN ObjectLink_Goods.ChildObjectId IS NULL
                      THEN ObjectString_Comment.ValueData
                 ELSE Object_ProdColor.ValueData
            END :: TVarChar AS ProdColorName
          , Object_Measure.ValueData                   AS MeasureName

            -- Цена вх. без НДС
          , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
            -- Цена вх. с НДС
          , zfCalc_SummWVAT (COALESCE (ObjectFloat_EKPrice.ValueData, 0), ObjectFloat_TaxKind_Value.ValueData) ::TFloat AS EKPriceWVAT

            -- Сумма вх. без НДС
          , zfCalc_SummIn (tmpProdColorPattern.Value, ObjectFloat_EKPrice.ValueData, 1)   ::TFloat AS EKPrice_summ
            -- Сумма вх. с НДС
          , zfCalc_SummWVAT (zfCalc_SummIn (tmpProdColorPattern.Value, ObjectFloat_EKPrice.ValueData, 1)
                           , ObjectFloat_TaxKind_Value.ValueData)  ::TFloat AS EKPriceWVAT_summ

     FROM tmpProdColorPattern
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpProdColorPattern.ProdColorPatternId
          
          LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = tmpProdColorPattern.MaterialOptionsId
          

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                    ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ColorPattern.ChildObjectId
                                   AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
               LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
          -- !!!замена!!!
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpProdColorPattern.ObjectId, ObjectLink_Goods.ChildObjectId)

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
                              AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                               AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() --Object_TaxKind.Id
                               AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptProdModelChild_ProdColorPattern (0, FALSE, zfCalc_UserAdmin())
