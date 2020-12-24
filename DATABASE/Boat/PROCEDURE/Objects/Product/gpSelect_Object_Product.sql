-- Function: gpSelect_Object_Product()

DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inIsSale      Boolean,       -- признак показать проданные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ProdColorName TVarChar
             , Hours TFloat
             , DateStart TDateTime, DateBegin TDateTime, DateSale TDateTime
             , Article TVarChar, CIN TVarChar, EngineNum TVarChar
             , Comment TVarChar
             , ProdGroupId Integer, ProdGroupName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ModelId Integer, ModelName TVarChar
             , EngineId Integer, EngineName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isSale Boolean
             , PriceIn TFloat, PriceOut TFloat
             , PriceIn2 TFloat, PriceOut2 TFloat
             , PriceIn3 TFloat, PriceOut3 TFloat

             , EKPrice_summ1     TFloat
             , EKPriceWVAT_summ1 TFloat
             , Basis_summ1       TFloat
             , BasisWVAT_summ1   TFloat

             , EKPrice_summ2     TFloat
             , EKPriceWVAT_summ2 TFloat
             , Basis_summ2       TFloat
             , BasisWVAT_summ2   TFloat

             , EKPrice_summ     TFloat
             , EKPriceWVAT_summ TFloat
             , Basis_summ       TFloat
             , BasisWVAT_summ   TFloat

             , isBasicConf Boolean
             , Color_fon Integer
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


     RETURN QUERY
     WITH 
     tmpProdColorItems AS (SELECT ObjectLink_Product.ChildObjectId AS ProductId
                                , Object_ProdColorItems.ObjectCode AS ProdColorItemsCode
                                , Object_ProdColorItems.ValueData  AS ProdColorItemsName
                                , Object_ProdColorGroup.ObjectCode AS ProdColorGroupCode
                                , Object_ProdColorGroup.ValueData  AS ProdColorGroupName
                                , Object_ProdColor.ValueData       AS ProdColorName
                                , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Product.ChildObjectId ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorItems.ObjectCode ASC) :: Integer AS NPP
                            FROM Object AS Object_ProdColorItems
                                 -- Лодка
                                 LEFT JOIN ObjectLink AS ObjectLink_Product
                                                      ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                     AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()
                                 -- Товар - если была замена
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                      ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                                     AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorItems_Goods()
                                 -- Boat Structure
                                 LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                      ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                                     AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()

                                 -- Категория/Группа Boat Structure
                                 LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                      ON ObjectLink_ProdColorGroup.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                     AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                 LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

                                 -- Товар Boat Structure
                                 LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_Goods
                                                      ON ObjectLink_ProdColorPattern_Goods.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                     AND ObjectLink_ProdColorPattern_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
                                 -- Цвет Или/Или
                                 LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                      ON ObjectLink_ProdColor.ObjectId = COALESCE (ObjectLink_Goods.ChildObjectId, ObjectLink_ProdColorPattern_Goods.ChildObjectId)
                                                     AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                 LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId


                            WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                              AND Object_ProdColorItems.isErased = FALSE
                           )
   -- базовые цены
   , tmpPriceBasis AS (SELECT tmp.GoodsId
                            , tmp.ValuePrice
                       FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                , inOperDate   := CURRENT_DATE) AS tmp
                      )
   -- элементы Product
   , tmpProduct AS (SELECT Object_Product.*
                        , ObjectDate_DateSale.ValueData    AS DateSale
                        , ObjectLink_Model.ChildObjectId   AS ModelId
                        , ObjectLink_ReceiptProdModel_Model.ObjectId AS ReceiptProdModelId
                        , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                        , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) :: Boolean AS isBasicConf
                    FROM Object AS Object_Product
                         LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                              ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                             AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()
 
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                                 ON ObjectBoolean_BasicConf.ObjectId = Object_Product.Id
                                                AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()
                                               
                         LEFT JOIN ObjectLink AS ObjectLink_Model
                                              ON ObjectLink_Model.ObjectId = Object_Product.Id
                                             AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()

                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                              ON ObjectLink_ReceiptProdModel_Model.ChildObjectId = ObjectLink_Model.ChildObjectId
                                             AND ObjectLink_ReceiptProdModel_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()

                    WHERE Object_Product.DescId = zc_Object_Product()
                     AND (Object_Product.isErased = FALSE OR inIsShowAll = TRUE)
                     AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                   )
   --
   , tmpProdOptItemsAll AS (SELECT tmpProduct.Id AS ProductId
                                 , Object_ProdOptItems.Id AS ProdOptItemsId
                            FROM tmpProduct
                                 INNER JOIN ObjectLink AS ObjectLink_Product
                                                       ON ObjectLink_Product.ChildObjectId = tmpProduct.Id
                                                      AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
                                                 
                                 INNER JOIN Object AS Object_ProdOptItems
                                                   ON Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                                                  AND Object_ProdOptItems.isErased = FALSE 
                            )

   , tmpProdOptItems AS (SELECT tmpProdOptItemsAll.ProductId
                                  , SUM (COALESCE (ObjectFloat_PriceIn.ValueData, 0))     ::TFloat    AS PriceIn
                                  , SUM (COALESCE (ObjectFloat_PriceOut.ValueData, 0))     ::TFloat    AS PriceOut
                             FROM tmpProdOptItemsAll
                                  LEFT JOIN ObjectFloat AS ObjectFloat_PriceIn
                                                        ON ObjectFloat_PriceIn.ObjectId = tmpProdOptItemsAll.ProdOptItemsId
                                                       AND ObjectFloat_PriceIn.DescId = zc_ObjectFloat_ProdOptItems_PriceIn()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                                        ON ObjectFloat_PriceOut.ObjectId = tmpProdOptItemsAll.ProdOptItemsId
                                                       AND ObjectFloat_PriceOut.DescId = zc_ObjectFloat_ProdOptItems_PriceOut()
                             GROUP BY tmpProdOptItemsAll.ProductId
                            )

   -- цены для ProdOptItems
   , tmpProdOptItemsPrice AS (SELECT tmpProdOptItemsAll.ProductId
                                   , SUM (COALESCE (ObjectFloat_EKPrice.ValueData,0))   ::TFloat   AS EKPrice_summ
                                   , SUM (CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                              * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)))  ::TFloat AS EKPriceWVAT_summ-- расчет входной цены с НДС

                                    -- расчет базовой цены без НДС, до 2 знаков
                                   , SUM (CASE WHEN vbPriceWithVAT = FALSE
                                               THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                               ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                          END) ::TFloat  AS Basis_summ

                                     -- расчет базовой цены с НДС, до 2 знаков
                                   , SUM (CASE WHEN vbPriceWithVAT = FALSE
                                               THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                               ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
                                          END) ::TFloat  AS BasisWVAT_summ

                              FROM tmpProdOptItemsAll
                                  INNER JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ObjectId = tmpProdOptItemsAll.ProdOptItemsId
                                                       AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdOptItems_Goods()
                
                                  LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                        ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Goods.ChildObjectId
                                                       AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                       ON ObjectLink_Goods_TaxKind.ObjectId = ObjectLink_Goods.ChildObjectId
                                                      AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                
                                  LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                        ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                       AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                
                                  LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Goods.ChildObjectId
                              GROUP BY tmpProdOptItemsAll.ProductId
                              )
   
   ------------------

   , tmpObjAll AS (SELECT Object_Product.*
                        , ROW_NUMBER() OVER (ORDER BY Object_Product.Id DESC) AS Ord
                   FROM Object AS Object_Product
                   WHERE Object_Product.DescId = zc_Object_Product()
                     AND Object_Product.isErased = FALSE
                  )

   -- получение цен для ModelId
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
                           , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)
                                  * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT

                             -- Цена продажи без ндс
                           , CASE WHEN vbPriceWithVAT = FALSE
                                  THEN COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                  ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                             END  :: TFloat AS BasisPrice
                             -- Цена продажи с ндс
                           , CASE WHEN vbPriceWithVAT = FALSE
                                  THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                  ELSE COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                             END ::TFloat AS BasisPriceWVAT

                      FROM (SELECT DISTINCT tmpProduct.ReceiptProdModelId FROM tmpProduct WHERE tmpProduct.isBasicConf = TRUE) AS tmpReceiptProdModel

                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                ON ObjectLink_ReceiptProdModel.ChildObjectId = tmpReceiptProdModel.ReceiptProdModelId
                                               AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()

                           INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                    ON ObjectBoolean_Main.ObjectId = tmpReceiptProdModel.ReceiptProdModelId
                                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptProdModel_Main()
                                                   AND ObjectBoolean_Main.ValueData = TRUE

                           INNER JOIN Object AS Object_ReceiptProdModelChild
                                             ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModel.ObjectId
                                            AND Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                                            AND Object_ReceiptProdModelChild.isErased = FALSE

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

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = ObjectLink_Object.ChildObjectId
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           -- Работы / услуги тип НДС
                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptService_TaxKind
                                                ON ObjectLink_ReceiptService_TaxKind.ObjectId = ObjectLink_Object.ChildObjectId
                                               AND ObjectLink_ReceiptService_TaxKind.DescId = zc_ObjectLink_ReceiptService_TaxKind()
                           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId)

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                                AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Object.ChildObjectId
                     )

          -- раскладываем ReceiptProdModelChild
        , tmpReceiptGoodsChild AS
                     (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
                             -- Сумма вх. без НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0) * COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)) :: TFloat AS EKPrice_summ
                             -- Сумма вх. с НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                                  * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)
                                         * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ

                             -- Сумма продажи без НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                              * CASE WHEN vbPriceWithVAT = FALSE
                                     THEN COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                     ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                END) AS Basis_summ
                             -- Сумма продажи с НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                              * CASE WHEN vbPriceWithVAT = FALSE
                                      THEN CAST (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                      ELSE COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                END) AS BasisWVAT_summ

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

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           -- Работы / услуги тип НДС
                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptService_TaxKind
                                                ON ObjectLink_ReceiptService_TaxKind.ObjectId = Object_Goods.Id
                                               AND ObjectLink_ReceiptService_TaxKind.DescId = zc_ObjectLink_ReceiptService_TaxKind()
                           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId)

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id
                     )
         -- группируем все по ReceiptProdModelId
       , tmpPrice AS (SELECT tmpProduct.Id AS ProductId
                             --
                           , SUM (tmp.EKPrice_summ)     :: TFloat AS EKPrice_summ
                           , SUM (tmp.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
                           , SUM (tmp.Basis_summ)       :: TFloat AS Basis_summ
                           , SUM (tmp.BasisWVAT_summ)   :: TFloat AS BasisWVAT_summ

                      FROM tmpProduct
                           LEFT JOIN (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                             --
                                           , SUM (tmpReceiptProdModelChild.EKPrice_summ)     :: TFloat AS EKPrice_summ
                                           , SUM (tmpReceiptProdModelChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
                                           , SUM (tmpReceiptProdModelChild.Basis_summ)       :: TFloat AS Basis_summ
                                           , SUM (tmpReceiptProdModelChild.BasisWVAT_summ)   :: TFloat AS BasisWVAT_summ

                                      FROM (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                                   --
                                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPrice)        AS EKPrice_summ
                                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPriceWVAT)    AS EKPriceWVAT_summ
                                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.BasisPrice)     AS Basis_summ
                                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.BasisPriceWVAT) AS BasisWVAT_summ

                                            FROM tmpReceiptProdModelChild
                                                 LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                                            WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL
                                            GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId

                                           UNION ALL
                                            SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                                   --
                                                 , SUM (tmpReceiptGoodsChild.EKPrice_summ)     AS EKPrice_summ
                                                 , SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) AS EKPriceWVAT_summ
                                                 , SUM (tmpReceiptGoodsChild.Basis_summ)       AS Basis_summ
                                                 , SUM (tmpReceiptGoodsChild.BasisWVAT_summ)   AS BasisWVAT_summ

                                            FROM tmpReceiptProdModelChild
                                                 INNER JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                                            GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                                           ) AS tmpReceiptProdModelChild
                                      GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                                     ) AS tmp ON tmp.ReceiptProdModelId = tmpProduct.ReceiptProdModelId
                      GROUP BY tmpProduct.Id
                     )
 ------

   , tmpResAll AS(SELECT Object_Product.Id               AS Id
                       , Object_Product.ObjectCode       AS Code
                       , Object_Product.ValueData        AS Name
                       , CASE WHEN tmpProdColorItems_1.ProdColorName ILIKE tmpProdColorItems_2.ProdColorName
                              THEN tmpProdColorItems_1.ProdColorName
                              ELSE COALESCE (tmpProdColorItems_1.ProdColorName, '') || ' / ' || COALESCE (tmpProdColorItems_2.ProdColorName, '')
                         END :: TVarChar AS ProdColorName
              
                       , ObjectFloat_Hours.ValueData      AS Hours
                       , ObjectDate_DateStart.ValueData   AS DateStart
                       , ObjectDate_DateBegin.ValueData   AS DateBegin
                       --, ObjectDate_DateSale.ValueData    AS DateSale
                       , Object_Product.DateSale          AS DateSale
                       , ObjectString_Article.ValueData   AS Article
                       , ObjectString_CIN.ValueData       AS CIN
                       , ObjectString_EngineNum.ValueData AS EngineNum
                       , ObjectString_Comment.ValueData   AS Comment
              
                       , Object_ProdGroup.Id             AS ProdGroupId
                       , Object_ProdGroup.ValueData      AS ProdGroupName
              
                       , Object_Brand.Id                 AS BrandId
                       , Object_Brand.ValueData          AS BrandName
              
                       , Object_Model.Id                 AS ModelId
                       , Object_Model.ValueData          AS ModelName
              
                       , Object_Engine.Id                AS EngineId
                       , Object_Engine.ValueData         AS EngineName
              
                       , Object_Insert.ValueData         AS InsertName
                       , ObjectDate_Insert.ValueData     AS InsertDate
                       --, CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                       , Object_Product.isSale ::Boolean AS isSale
                       , Object_Product.isErased         AS isErased
              
                       , CASE WHEN tmpObjAll.Ord = 1 THEN 4750 
                              WHEN tmpObjAll.Ord = 2 THEN 4560 
                              WHEN tmpObjAll.Ord = 3 THEN 25456 
                              WHEN tmpObjAll.Ord = 4 THEN 29357
                              WHEN tmpObjAll.Ord = 5 THEN 32347
                              ELSE 0
                         END :: TFloat AS PriceIn
              
                       , CASE WHEN tmpObjAll.Ord = 1 THEN 4750  + 1645
                              WHEN tmpObjAll.Ord = 2 THEN 4560  + 1345 
                              WHEN tmpObjAll.Ord = 3 THEN 25456  + 14234
                              WHEN tmpObjAll.Ord = 4 THEN 29357  + 21700
                              WHEN tmpObjAll.Ord = 5 THEN 32347  + 18345
                              ELSE 0
                         END :: TFloat AS PriceOut

                       , tmpPrice.EKPrice_summ     :: TFloat AS EKPrice_summ
                       , tmpPrice.EKPriceWVAT_summ :: TFloat AS EKPriceWVAT_summ
                       , tmpPrice.Basis_summ       :: TFloat AS Basis_summ
                       , tmpPrice.BasisWVAT_summ   :: TFloat AS BasisWVAT_summ

                       --, COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) :: Boolean AS isBasicConf
                       , Object_Product.isBasicConf      AS isBasicConf
 
                   FROM tmpProduct AS Object_Product
                        LEFT JOIN tmpObjAll ON tmpObjAll.Id =  Object_Product.Id
                        LEFT JOIN tmpProdColorItems AS tmpProdColorItems_1
                                                    ON tmpProdColorItems_1.ProductId = Object_Product.Id
                                                   AND tmpProdColorItems_1.NPP = 1
                        LEFT JOIN tmpProdColorItems AS tmpProdColorItems_2
                                                    ON tmpProdColorItems_2.ProductId = Object_Product.Id
                                                   AND tmpProdColorItems_2.NPP = 2
              
                        /*LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                                ON ObjectBoolean_BasicConf.ObjectId = Object_Product.Id
                                               AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf() 
                        */ 
              
                        LEFT JOIN ObjectFloat AS ObjectFloat_Hours
                                              ON ObjectFloat_Hours.ObjectId = Object_Product.Id
                                             AND ObjectFloat_Hours.DescId = zc_ObjectFloat_Product_Hours()
              
                        LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                             ON ObjectDate_DateStart.ObjectId = Object_Product.Id
                                            AND ObjectDate_DateStart.DescId = zc_ObjectDate_Product_DateStart()
              
                        LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                             ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                                            AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()
              
                        /*LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                             ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                            AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()*/

                        LEFT JOIN ObjectString AS ObjectString_Article
                                               ON ObjectString_Article.ObjectId = Object_Product.Id
                                              AND ObjectString_Article.DescId = zc_ObjectString_Article()

                        LEFT JOIN ObjectString AS ObjectString_CIN
                                               ON ObjectString_CIN.ObjectId = Object_Product.Id
                                              AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                        LEFT JOIN ObjectString AS ObjectString_EngineNum
                                               ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                              AND ObjectString_EngineNum.DescId = zc_ObjectString_Product_EngineNum()

                        LEFT JOIN ObjectString AS ObjectString_Comment
                                               ON ObjectString_Comment.ObjectId = Object_Product.Id
                                              AND ObjectString_Comment.DescId = zc_ObjectString_Product_Comment()

                        LEFT JOIN ObjectLink AS ObjectLink_ProdGroup
                                             ON ObjectLink_ProdGroup.ObjectId = Object_Product.Id
                                            AND ObjectLink_ProdGroup.DescId = zc_ObjectLink_Product_ProdGroup()
                        LEFT JOIN Object AS Object_ProdGroup ON Object_ProdGroup.Id = ObjectLink_ProdGroup.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Brand
                                             ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                            AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
                        LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

                        /*LEFT JOIN ObjectLink AS ObjectLink_Model
                                             ON ObjectLink_Model.ObjectId = Object_Product.Id
                                            AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
                        LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
                        */
                        LEFT JOIN Object AS Object_Model ON Object_Model.Id = Object_Product.ModelId
                        

                        LEFT JOIN ObjectLink AS ObjectLink_Engine
                                             ON ObjectLink_Engine.ObjectId = Object_Product.Id
                                            AND ObjectLink_Engine.DescId = zc_ObjectLink_Product_Engine()
                        LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Insert
                                             ON ObjectLink_Insert.ObjectId = Object_Product.Id
                                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

                        LEFT JOIN ObjectDate AS ObjectDate_Insert
                                             ON ObjectDate_Insert.ObjectId = Object_Product.Id
                                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

                        LEFT JOIN tmpPrice ON tmpPrice.ProductId = Object_Product.Id

                   /*WHERE Object_Product.DescId = zc_Object_Product()
                    AND (Object_Product.isErased = FALSE OR inIsShowAll = TRUE)
                    AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                    */
                  )
     -- Результат
    SELECT
           tmpResAll.Id
         , tmpResAll.Code
         , tmpResAll.Name
         , tmpResAll.ProdColorName

         , tmpResAll.Hours
         , tmpResAll.DateStart
         , tmpResAll.DateBegin
         , tmpResAll.DateSale
         , tmpResAll.Article
         , tmpResAll.CIN
         , tmpResAll.EngineNum
         , tmpResAll.Comment

         , tmpResAll.ProdGroupId
         , tmpResAll.ProdGroupName

         , tmpResAll.BrandId
         , tmpResAll.BrandName

         , tmpResAll.ModelId
         , tmpResAll.ModelName

         , tmpResAll.EngineId
         , tmpResAll.EngineName

         , tmpResAll.InsertName
         , tmpResAll.InsertDate
         , tmpResAll.isSale

         , tmpResAll.PriceIn
         , tmpResAll.PriceOut

         , tmpProdOptItems.PriceIn AS PriceIn2
         , tmpProdOptItems.PriceOut AS PriceOut2

         , (COALESCE (tmpResAll.PriceIn, 0) + COALESCE (tmpProdOptItems.PriceIn, 0))   :: TFloat AS PriceIn3
         , (COALESCE (tmpResAll.PriceOut, 0) + COALESCE (tmpProdOptItems.PriceOut, 0)) :: TFloat AS PriceOut3


         , tmpResAll.EKPrice_summ     :: TFloat AS EKPrice_summ1
         , tmpResAll.EKPriceWVAT_summ :: TFloat AS EKPriceWVAT_summ1
         , tmpResAll.Basis_summ       :: TFloat AS Basis_summ1
         , tmpResAll.BasisWVAT_summ   :: TFloat AS BasisWVAT_summ1

/*         , tmpProdOptItemsPrice.EKPrice_summ     :: TFloat AS EKPrice_summ2
         , tmpProdOptItemsPrice.EKPriceWVAT_summ :: TFloat AS EKPriceWVAT_summ2
         , tmpProdOptItemsPrice.Basis_summ       :: TFloat AS Basis_summ2
         , tmpProdOptItemsPrice.BasisWVAT_summ   :: TFloat AS BasisWVAT_summ2
         , (COALESCE (tmpResAll.EKPrice_summ, 0)     + COALESCE (tmpProdOptItemsPrice.EKPrice_summ, 0))      :: TFloat AS EKPrice_summ
         , (COALESCE (tmpResAll.EKPriceWVAT_summ, 0) + COALESCE (tmpProdOptItemsPrice.EKPriceWVAT_summ, 0))  :: TFloat AS EKPriceWVAT_summ
         , (COALESCE (tmpResAll.Basis_summ, 0)       + COALESCE (tmpProdOptItemsPrice.Basis_summ, 0))        :: TFloat AS Basis_summ
         , (COALESCE (tmpResAll.BasisWVAT_summ, 0)   + COALESCE (tmpProdOptItemsPrice.BasisWVAT_summ, 0))    :: TFloat AS BasisWVAT_summ        
         
         
*/
         , tmpProdOptItems.PriceIn     :: TFloat AS EKPrice_summ2
         , (tmpProdOptItems.PriceIn * (1.16)) :: TFloat AS EKPriceWVAT_summ2
         , tmpProdOptItems.PriceOut       :: TFloat AS Basis_summ2
         , (tmpProdOptItems.PriceOut * (1.16))                              :: TFloat AS BasisWVAT_summ2  -- 16% НДС

         , (COALESCE (tmpResAll.EKPrice_summ, 0)     + COALESCE (tmpProdOptItems.PriceIn, 0))      :: TFloat AS EKPrice_summ
         , (COALESCE (tmpResAll.EKPriceWVAT_summ, 0) + COALESCE (tmpProdOptItems.PriceIn, 0)* (1.16))  :: TFloat AS EKPriceWVAT_summ
         , (COALESCE (tmpResAll.Basis_summ, 0)       + COALESCE (tmpProdOptItems.PriceOut, 0))        :: TFloat AS Basis_summ
         , (COALESCE (tmpResAll.BasisWVAT_summ, 0)   + COALESCE (tmpProdOptItems.PriceOut, 0)* (1.16))    :: TFloat AS BasisWVAT_summ

         , tmpResAll.isBasicConf
         
         , CASE WHEN tmpResAll.isSale
                     THEN zc_Color_Lime()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS Color_fon

         , tmpResAll.isErased

     FROM tmpResAll
          LEFT JOIN tmpProdOptItems ON tmpProdOptItems.ProductId = tmpResAll.Id
          LEFT JOIN tmpProdOptItemsPrice ON tmpProdOptItemsPrice.ProductId = tmpResAll.Id
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
--
 --SELECT * FROM gpSelect_Object_Product (false, true, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Product (false, false, zfCalc_UserAdmin())
