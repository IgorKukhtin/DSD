-- Function: gpSelect_Object_ReceiptProdModel_Print ()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModel_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModel_Print(
    IN inReceiptProdModelId           Integer   ,   --    
    IN inReceiptLevelId               Integer   ,   --    
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbPriceWithVAT_pl    Boolean;
    DECLARE vbTaxKindValue_basis TFloat;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Признак в Базовом Прайсе
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!Базовый % НДС!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());


     -- Результат
     OPEN Cursor1 FOR
     WITH
          -- Цены
          tmpPriceBasis AS (SELECT lfSelect.GoodsId
                                   -- Цена продажи без НДС
                                 , CASE WHEN vbPriceWithVAT_pl = FALSE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- расчет
                                        ELSE zfCalc_Summ_NoVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePrice
                                   -- Цена продажи с НДС
                                 , CASE WHEN vbPriceWithVAT_pl = TRUE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- расчет
                                        ELSE zfCalc_SummWVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePriceWVAT
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate := CURRENT_DATE) AS lfSelect
                           )
          -- элементы ReceiptProdModelChild
        , tmpReceiptProdModelChild AS
                     (SELECT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                           , Object_ReceiptProdModelChild.Id           AS ReceiptProdModelChildId
                             -- элемент который будем раскладывать
                           , ObjectLink_Object.ChildObjectId           AS ObjectId
                             -- значение
                           , COALESCE (ObjectFloat_Value.ValueData, 0)   :: TFloat AS Value

                             -- Цена вх. без НДС
                           , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
                             -- Цена вх. с НДС
                           , zfCalc_SummWVAT ( COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0), ObjectFloat_TaxKind_Value.ValueData) AS EKPriceWVAT
                      FROM Object AS Object_ReceiptProdModelChild
                           INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                 ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                                AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                                AND ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId

                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()

                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                 ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value()

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Object.ChildObjectId
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                              -- цены для Работы/Услуги вход. без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                                 ON ObjectFloat_ReceiptService_EKPrice.ObjectId = ObjectLink_Object.ChildObjectId
                                                AND ObjectFloat_ReceiptService_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()
                              -- цены для Работы/Услуги продажи без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                                 ON ObjectFloat_ReceiptService_SalePrice.ObjectId = ObjectLink_Object.ChildObjectId
                                                AND ObjectFloat_ReceiptService_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() --Object_TaxKind.Id
                                                AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

                      WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                        AND Object_ReceiptProdModelChild.isErased = FALSE
                     )

          -- раскладываем ReceiptProdModelChild
        , tmpReceiptGoodsChild AS
                     (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
                             -- Сумма вх. без НДС
                           , zfCalc_SummIn (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0), COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0),1) :: TFloat AS EKPrice_summ
                             -- Сумма вх. с НДС
                           , zfCalc_SummWVAT (zfCalc_SummIn (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0), COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0),1)
                                            , ObjectFloat_TaxKind_Value.ValueData)  AS EKPriceWVAT_summ
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
                           -- Комплектующие / Работы/Услуги
                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                           -- с этой структурой
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                ON ObjectLink_ProdColorPattern.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                               AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                           -- значение в сборке
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                 ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()

                           -- !!!с этой структурой!!!
                           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                              -- цены для Работы/Услуги вход. без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                                 ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_ReceiptService_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()
                              -- цены для Работы/Услуги продажи без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                                 ON ObjectFloat_ReceiptService_SalePrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_ReceiptService_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() --Object_TaxKind.Id
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                     )

       , tmpChild AS (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                             --
                           , SUM (tmpReceiptProdModelChild.EKPrice_summ)     :: TFloat AS EKPrice_summ
                           , SUM (tmpReceiptProdModelChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
                      FROM (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                   --
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPrice)        AS EKPrice_summ
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPriceWVAT)    AS EKPriceWVAT_summ
                            FROM tmpReceiptProdModelChild
                                 LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                            WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL
                            GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                           UNION ALL
                            SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                   --
                                 , SUM (tmpReceiptGoodsChild.EKPrice_summ)     AS EKPrice_summ
                                 , SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) AS EKPriceWVAT_summ
                            FROM tmpReceiptProdModelChild
                                 INNER JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                            GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                           ) AS tmpReceiptProdModelChild
                      GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                     )


     SELECT
           Object_ReceiptProdModel.Id         AS Id
         , Object_ReceiptProdModel.ObjectCode AS Code
         , Object_ReceiptProdModel.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectBoolean_Main.ValueData       ::Boolean   AS isMain

         , Object_Model.Id           ::Integer  AS ModelId
         , Object_Model.ValueData    ::TVarChar AS ModelName
         , Object_Brand.Id                      AS BrandId
         , Object_Brand.ValueData               AS BrandName
         , Object_ProdEngine.Id                 AS EngineId
         , Object_ProdEngine.ValueData          AS EngineName

         , tmpChild.EKPrice_summ
         , tmpChild.EKPriceWVAT_summ

         , '' ::TVarChar AS ModelGroupName
         , ObjectFloat_Power.ValueData               ::TFloat   AS EnginePower
         , ObjectFloat_Volume.ValueData              ::TFloat   AS EngineVolume

         , '' ::TVarChar AS Text2
         , '' ::TVarChar AS Text3

         , '' ::TVarChar AS TaxNumber
         
         , tmpInfo.Footer1        ::TVarChar AS Footer1
         , tmpInfo.Footer2        ::TVarChar AS Footer2
         , tmpInfo.Footer3        ::TVarChar AS Footer3
         , tmpInfo.Footer4        ::TVarChar AS Footer4

     FROM Object AS Object_ReceiptProdModel
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptProdModel.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptProdModel_Code()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_ReceiptProdModel.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptProdModel_Main()

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
          LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                ON ObjectFloat_Volume.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume()

          LEFT JOIN tmpChild ON tmpChild.ReceiptProdModelId = Object_ReceiptProdModel.Id
          
          LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_ReceiptProdModel.Id

          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1

     WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
      AND Object_ReceiptProdModel.Id = inReceiptProdModelId
          ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR  
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
                                        AND ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId
                                        AND (ObjectLink_ReceiptLevel.ChildObjectId = inReceiptLevelId OR inReceiptLevelId = 0)
                                     )

          -- раскладываем ReceiptProdModelChild
        , tmpProdColorPattern AS (SELECT tmpReceiptProdModelChild.ReceiptProdModelId     AS ReceiptProdModelId
                                       , Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                                       , Object_ReceiptGoodsChild.isErased               AS isErased
                                         -- если меняли на другой товар, не тот что в Boat Structure
                                       , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                         -- нашли Элемент Boat Structure
                                       , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
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
                                       -- значение в сборке
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                 )

     -- Результат
     SELECT tmpProdColorPattern.ReceiptGoodsChildId       AS Id
          , tmpProdColorPattern.ReceiptProdModelId        AS ReceiptProdModelId
          , tmpProdColorPattern.Value         :: TFloat   AS Value
          , ROW_NUMBER() OVER (PARTITION BY tmpProdColorPattern.ReceiptProdModelId ORDER BY Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP

          , Object_ProdColorPattern.Id              AS ProdColorPatternId
          , Object_ProdColorPattern.ObjectCode      AS ProdColorPatternCode
          , Object_ProdColorPattern.ValueData       AS ProdColorPatternName

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
          , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
          , Object_Measure.ValueData                   AS MeasureName

     FROM tmpProdColorPattern
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpProdColorPattern.ProdColorPatternId

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

     ;

     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22          *
*/

-- тест
--