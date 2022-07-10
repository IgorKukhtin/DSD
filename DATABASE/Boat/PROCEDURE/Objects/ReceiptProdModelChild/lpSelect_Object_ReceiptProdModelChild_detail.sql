-- Function: gpSelect_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptProdModelChild_detail (Integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_ReceiptProdModelChild_detail(
    IN inUserId      Integer        -- пользователь
)
RETURNS TABLE (ModelId Integer, ModelName TVarChar
               --
             , isMain Boolean
             , ReceiptProdModelId Integer, ReceiptProdModelChildId Integer
               -- элемент который раскладывали
             , ObjectId_parent Integer, ObjectCode_parent Integer, ObjectName_parent TVarChar, ObjectDescId_parent Integer, DescName_parent TVarChar
               -- значение
             , Value_parent TFloat
               -- на что разложили /либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, ObjectDescId Integer, DescName TVarChar
               -- значение
             , Value TFloat
               --
             , ReceiptGoodsChildId Integer
               -- Boat Structure
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
               -- Цвет /либо Comment из Boat Structure
             , ProdColorId Integer, ProdColorName TVarChar
               -- если это Boat Structure и этот элемент может идти как опция
           --, ProdOptionsId Integer, ProdOptionsCode Integer, ProdOptionsName TVarChar

               -- Категория Опций
             , MaterialOptionsId Integer, MaterialOptionsCode Integer, MaterialOptionsName TVarChar
 
               --
             , TaxKindId_parent Integer, TaxKindValue_parent TFloat
             , EKPrice_parent TFloat, EKPriceWVAT_parent TFloat
             , BasisPrice_parent TFloat, BasisPriceWVAT_parent TFloat
               --
             , TaxKindId Integer --, TaxKindId_opt Integer
             , TaxKindValue TFloat --, TaxKindValue_opt TFloat
               --
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat

           --, SalePrice_opt TFloat, SalePriceWVAT_opt TFloat
              )
AS
$BODY$
   DECLARE vbPriceWithVAT_pl Boolean;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN

     -- Признак в Базовом Прайсе
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!Базовый % НДС!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

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
        , tmpReceiptProdModelChild AS(SELECT COALESCE (ObjectBoolean_Main.ValueData, FALSE)  AS isMain
                                           , Object_ReceiptProdModel.Id                      AS ReceiptProdModelId
                                           , Object_ReceiptProdModelChild.Id                 AS ReceiptProdModelChildId
                                             -- Модель лодки у шаблона ProdModel
                                           , ObjectLink_Model.ChildObjectId                  AS ModelId
                                             -- элемент который будем раскладывать
                                           , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                             -- значение
                                           , ObjectFloat_Value.ValueData                     AS Value

                                      FROM Object AS Object_ReceiptProdModel
                                           -- признак главный Yes/no шаблон ProdModel
                                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                   ON ObjectBoolean_Main.ObjectId = Object_ReceiptProdModel.Id
                                                                  AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_ReceiptProdModel_Main()
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
       , tmpReceiptGoodsChild AS (SELECT tmpReceiptProdModelChild.ModelId                  AS ModelId
                                         -- признак главный Yes/no шаблон ProdModel
                                       , tmpReceiptProdModelChild.isMain                   AS isMain
                                         --
                                       , tmpReceiptProdModelChild.ReceiptProdModelId       AS ReceiptProdModelId
                                       , tmpReceiptProdModelChild.ReceiptProdModelChildId  AS ReceiptProdModelChildId
                                       , tmpReceiptProdModelChild.ObjectId                 AS ObjectId_parent
                                       , Object_ReceiptGoodsChild.Id                       AS ReceiptGoodsChildId
                                         -- всегда Цвет - у ReceiptGoodsChild
                                       , Object_ReceiptGoodsChild.ValueData                AS Comment
                                         -- разложили или если меняли "Комплектующее", не тот что в Boat Structure
                                       , ObjectLink_Object.ChildObjectId                   AS GoodsId
                                         -- нашли Элемент Boat Structure
                                       , COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) AS ProdColorPatternId
                                         -- Категория Опций
                                       , ObjectLink_MaterialOptions.ChildObjectId          AS MaterialOptionsId
                                         -- значение ProdModelChild
                                       , tmpReceiptProdModelChild.Value                    AS Value_parent
                                         -- умножили
                                       , tmpReceiptProdModelChild.Value * ObjectFloat_Value.ValueData AS Value

                                  FROM tmpReceiptProdModelChild
                                       -- нашли его в сборке узлов
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                             ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                                            AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                       -- это главный шаблон сборки узлов
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
                                       -- может быть такая структура
                                       LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                            ON ObjectLink_ProdColorPattern.ObjectId      = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                       -- разложили или если была "замена" - "Комплектующее" в ReceiptGoodsChild, т.е. он не такой как в zc_ObjectLink_ProdColorPattern_Goods
                                       LEFT JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                       -- Категория Опций
                                       LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                            ON ObjectLink_MaterialOptions.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                                       -- значение в сборке
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                 )

                           -- элементы ReceiptProdModelChild
                         , tmpRes AS (SELECT -- Модель лодки у шаблона ProdModel
                                             tmpReceiptProdModelChild.ModelId
                                             --
                                           , tmpReceiptProdModelChild.isMain
                                           , tmpReceiptProdModelChild.ReceiptProdModelId
                                           , tmpReceiptProdModelChild.ReceiptProdModelChildId
                                             -- элемент который НЕ раскладывается
                                           , tmpReceiptProdModelChild.ObjectId AS ObjectId_parent
                                             -- элемент ReceiptProdModelChild
                                           , tmpReceiptProdModelChild.ObjectId
                                             --
                                           , '' AS Comment_Receipt
                                             -- значение
                                           , tmpReceiptProdModelChild.Value AS Value_parent
                                           , tmpReceiptProdModelChild.Value
                                             --
                                           , 0 AS ReceiptGoodsChildId
                                           , 0 AS ProdColorPatternId
                                           , 0 AS MaterialOptionsId

                                      FROM tmpReceiptProdModelChild
                                           LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                                      WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL

                                     UNION ALL
                                      SELECT tmpReceiptGoodsChild.ModelId
                                           , tmpReceiptGoodsChild.isMain
                                           , tmpReceiptGoodsChild.ReceiptProdModelId
                                           , tmpReceiptGoodsChild.ReceiptProdModelChildId
                                             -- элемент который раскладываем
                                           , tmpReceiptGoodsChild.ObjectId_parent
                                             -- на что раскладываем
                                           , tmpReceiptGoodsChild.GoodsId AS ObjectId
                                             --
                                           , tmpReceiptGoodsChild.Comment AS Comment_Receipt
                                             -- значение
                                           , tmpReceiptGoodsChild.Value_parent
                                           , tmpReceiptGoodsChild.Value
                                             --
                                           , tmpReceiptGoodsChild.ReceiptGoodsChildId
                                           , tmpReceiptGoodsChild.ProdColorPatternId
                                           , tmpReceiptGoodsChild.MaterialOptionsId

                                      FROM tmpReceiptGoodsChild
                                     )
       --
       SELECT tmpRes.ModelId
            , Object_Model.ValueData AS ModelName
              --
            , tmpRes.isMain
            , tmpRes.ReceiptProdModelId
            , tmpRes.ReceiptProdModelChildId
              -- элемент ReceiptProdModelChild
            , tmpRes.ObjectId_parent, Object_parent.ObjectCode AS ObjectCode_parent, Object_parent.ValueData AS ObjectName_parent, Object_parent.DescId AS ObjectDescId_parent, ObjectDesc_parent.ItemName AS DescName_parent
              -- значение ReceiptProdModelChild
            , tmpRes.Value_parent :: TFloat AS Value_parent
              -- элемент ReceiptProdModelChild или разложили на ReceiptGoodsChild
            , tmpRes.ObjectId, Object.ObjectCode, Object.ValueData AS ObjectName, Object.DescId AS ObjectDescId, ObjectDesc.ItemName AS DescName
              -- значение
            , tmpRes.Value :: TFloat AS Value
              --
            , tmpRes.ReceiptGoodsChildId

            , Object_ProdColorGroup.Id AS ProdColorGroupId, Object_ProdColorGroup.ValueData AS ProdColorGroupName
            , tmpRes.ProdColorPatternId
            --, Object_ProdColorPattern.ValueData AS ProdColorPatternName
            , (Object_ProdColorGroup.ValueData || CASE WHEN LENGTH (Object_ProdColorPattern.ValueData) > 1 THEN ' ' || Object_ProdColorPattern.ValueData ELSE '' END || ' (' || Object_Model_pcp.ValueData || ')') :: TVarChar  AS  ProdColorPatternName

              -- значение Farbe
            , Object_ProdColor.Id           AS ProdColorId
              -- если у Boat Structure нет товара, тогда значение Farbe
            , CASE WHEN ObjectLink_ProdColorPattern_Goods.ChildObjectId IS NULL AND tmpRes.ProdColorPatternId > 0 AND tmpRes.Comment_Receipt <> ''
                        -- всегда Цвет - у ReceiptGoodsChild
                        THEN tmpRes.Comment_Receipt

                   WHEN ObjectLink_ProdColorPattern_Goods.ChildObjectId IS NULL AND tmpRes.ProdColorPatternId > 0
                        -- у Boat Structure  (когда нет GoodsId)
                        THEN ObjectString_ProdColorPattern_Comment.ValueData

                   -- иначе Цвет у Товара
                   ELSE Object_ProdColor.ValueData

              END :: TVarChar AS ProdColorName

          --, Object_ProdOptions.Id         AS ProdOptionsId
          --, Object_ProdOptions.ObjectCode AS ProdOptionsCode
          --, Object_ProdOptions.ValueData  AS ProdOptionsName

            , Object_MaterialOptions.Id         AS MaterialOptionsId
            , Object_MaterialOptions.ObjectCode AS MaterialOptionsCode
            , Object_MaterialOptions.ValueData  AS MaterialOptionsName
          

             -- Тип НДС - !!!ReceiptProdModelChild!!!
            , COALESCE (ObjectLink_Goods_TaxKind_parent.ChildObjectId, ObjectLink_ReceiptService_TaxKind_parent.ChildObjectId) AS TaxKindId_parent
             -- % НДС
            , ObjectFloat_TaxKind_Value_parent.ValueData AS TaxKindValue_parent

             -- Цена вх. без НДС
            , COALESCE (ObjectFloat_EKPrice_parent.ValueData, ObjectFloat_ReceiptService_EKPrice_parent.ValueData, 0) :: TFloat AS EKPrice_parent
              -- Цена вх. с НДС
            , zfCalc_SummWVAT (COALESCE (ObjectFloat_EKPrice_parent.ValueData, ObjectFloat_ReceiptService_EKPrice_parent.ValueData, 0)
                              , COALESCE (ObjectFloat_TaxKind_Value_parent.ValueData, 0))  ::TFloat AS EKPriceWVAT_parent

             -- Цена продажи без ндс
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN COALESCE (tmpPriceBasis_parent.ValuePrice, ObjectFloat_ReceiptService_SalePrice_parent.ValueData, 0)
                   ELSE zfCalc_Summ_NoVAT (COALESCE (tmpPriceBasis_parent.ValuePrice, ObjectFloat_ReceiptService_SalePrice_parent.ValueData, 0)
                                         , vbTaxKindValue_basis)
             END ::TFloat  AS BasisPrice_parent

             -- Цена продажи с ндс
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN zfCalc_SummWVAT (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                       , vbTaxKindValue_basis)
                   ELSE COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
             END ::TFloat  AS BasisPriceWVAT_parent


             -- Тип НДС - !!!ReceiptGooldsChild!!!
            , COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId) AS TaxKindId
          --, ObjectLink_ProdOptions_TaxKind_opt.ChildObjectId                                                   AS TaxKindId_opt
             -- % НДС
            , ObjectFloat_TaxKind_Value.ValueData     AS TaxKindValue
          --, ObjectFloat_TaxKind_Value_opt.ValueData AS TaxKindValue_opt

             -- Цена вх. без НДС
            , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
              -- Цена вх. с НДС
            , zfCalc_SummWVAT ( COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)
                              , COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) )  ::TFloat AS EKPriceWVAT

             -- Цена продажи без ндс
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                   ELSE zfCalc_Summ_NoVAT (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                          , vbTaxKindValue_basis)
             END ::TFloat  AS BasisPrice

             -- Цена продажи с ндс
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN zfCalc_SummWVAT (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                       , vbTaxKindValue_basis)
                   ELSE COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
             END ::TFloat  AS BasisPriceWVAT

             -- Цена продажи без ндс - ОПЦИЯ
         --, CASE WHEN vbPriceWithVAT_pl = FALSE
         --        THEN ObjectFloat_SalePrice_opt.ValueData
         --        ELSE zfCalc_Summ_NoVAT (ObjectFloat_SalePrice_opt.ValueData, vbTaxKindValue_basis)
         --  END ::TFloat  AS SalePrice_opt

             -- Цена продажи с ндс - ОПЦИЯ
         --, CASE WHEN vbPriceWithVAT_pl = FALSE
         --        THEN zfCalc_SummWVAT (ObjectFloat_SalePrice_opt.ValueData, vbTaxKindValue_basis)
         --        ELSE ObjectFloat_SalePrice_opt.ValueData
         --  END ::TFloat  AS SalePriceWVAT_opt

       FROM tmpRes
            -- Boat Structure
            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpRes.ProdColorPatternId
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                 ON ObjectLink_ProdColorGroup.ObjectId = tmpRes.ProdColorPatternId
                                AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                                    ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                   AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()

               LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                    ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                                   AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
               LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId


            LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                   ON ObjectString_ProdColorPattern_Comment.ObjectId = tmpRes.ProdColorPatternId
                                  AND ObjectString_ProdColorPattern_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()

            -- если у Boat Structure нет товара, тогда значение Farbe берем = Comment
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_Goods
                                 ON ObjectLink_ProdColorPattern_Goods.ObjectId = tmpRes.ProdColorPatternId
                                AND ObjectLink_ProdColorPattern_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor_parent
                                 ON ObjectLink_Goods_ProdColor_parent.ObjectId = tmpRes.ObjectId_parent
                                AND ObjectLink_Goods_ProdColor_parent.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                 ON ObjectLink_Goods_ProdColor.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = COALESCE (ObjectLink_Goods_ProdColor.ChildObjectId, ObjectLink_Goods_ProdColor_parent.ChildObjectId)

            -- Boat Structure -> ProdOptions
          --LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
          --                     ON ObjectLink_ProdOptions.ObjectId = tmpRes.ProdColorPatternId
          --                    AND ObjectLink_ProdOptions.DescId   = zc_ObjectLink_ProdColorPattern_ProdOptions()
          --LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId

            --
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = tmpRes.MaterialOptionsId

            --
            LEFT JOIN Object AS Object_Model ON Object_Model.Id = tmpRes.ModelId

            -- элемент ReceiptProdModelChild
            LEFT JOIN Object AS Object_parent ON Object_parent.Id = tmpRes.ObjectId_parent
            LEFT JOIN ObjectDesc AS ObjectDesc_parent ON ObjectDesc_parent.Id = Object_parent.DescId
            -- элемент ReceiptProdModelChild или разложили на ReceiptGoodsChild
            LEFT JOIN Object ON Object.Id = tmpRes.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId

            -- Options
          --LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice_opt
          --                      ON ObjectFloat_SalePrice_opt.ObjectId = Object_ProdOptions.Id
          --                     AND ObjectFloat_SalePrice_opt.DescId   = zc_ObjectFloat_ProdOptions_SalePrice()
          --LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_TaxKind_opt
          --                     ON ObjectLink_ProdOptions_TaxKind_opt.ObjectId = Object_ProdOptions.Id
          --                    AND ObjectLink_ProdOptions_TaxKind_opt.DescId   = zc_ObjectLink_ProdOptions_TaxKind()
          --LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_opt
          --                      ON ObjectFloat_TaxKind_Value_opt.ObjectId = ObjectLink_ProdOptions_TaxKind_opt.ChildObjectId
          --                     AND ObjectFloat_TaxKind_Value_opt.DescId   = zc_ObjectFloat_TaxKind_Value()

            -- цены для Работы/Услуги вход. без ндс
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice_parent
                                  ON ObjectFloat_ReceiptService_EKPrice_parent.ObjectId = tmpRes.ObjectId_parent
                                 AND ObjectFloat_ReceiptService_EKPrice_parent.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                  ON ObjectFloat_ReceiptService_EKPrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()
            -- цены для Работы/Услуги продажи без ндс
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice_parent
                                  ON ObjectFloat_ReceiptService_SalePrice_parent.ObjectId = tmpRes.ObjectId_parent
                                 AND ObjectFloat_ReceiptService_SalePrice_parent.DescId   = zc_ObjectFloat_ReceiptService_SalePrice()
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                  ON ObjectFloat_ReceiptService_SalePrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_ReceiptService_SalePrice.DescId   = zc_ObjectFloat_ReceiptService_SalePrice()
            -- Работы / услуги тип НДС
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptService_TaxKind_parent
                                 ON ObjectLink_ReceiptService_TaxKind_parent.ObjectId = tmpRes.ObjectId_parent
                                AND ObjectLink_ReceiptService_TaxKind_parent.DescId   = zc_ObjectLink_ReceiptService_TaxKind()
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptService_TaxKind
                                 ON ObjectLink_ReceiptService_TaxKind.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_ReceiptService_TaxKind.DescId   = zc_ObjectLink_ReceiptService_TaxKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice_parent
                                  ON ObjectFloat_EKPrice_parent.ObjectId = tmpRes.ObjectId_parent
                                 AND ObjectFloat_EKPrice_parent.DescId   = zc_ObjectFloat_Goods_EKPrice()
            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                  ON ObjectFloat_EKPrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind_parent
                                 ON ObjectLink_Goods_TaxKind_parent.ObjectId = tmpRes.ObjectId_parent
                                AND ObjectLink_Goods_TaxKind_parent.DescId   = zc_ObjectLink_Goods_TaxKind()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                 ON ObjectLink_Goods_TaxKind.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_Goods_TaxKind.DescId   = zc_ObjectLink_Goods_TaxKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_parent
                                  ON ObjectFloat_TaxKind_Value_parent.ObjectId = COALESCE (ObjectLink_Goods_TaxKind_parent.ChildObjectId, ObjectLink_ReceiptService_TaxKind_parent.ChildObjectId)
                                 AND ObjectFloat_TaxKind_Value_parent.DescId   = zc_ObjectFloat_TaxKind_Value()
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId)
                                 AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

            LEFT JOIN tmpPriceBasis AS tmpPriceBasis_parent ON tmpPriceBasis_parent.GoodsId = tmpRes.ObjectId_parent
            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpRes.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.12.20                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Object_ReceiptProdModelChild_detail (zfCalc_UserAdmin() :: Integer) ORDER BY ModelId
