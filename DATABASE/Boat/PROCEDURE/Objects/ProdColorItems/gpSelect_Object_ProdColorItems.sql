 -- Function: gpSelect_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorItems(
    IN inMovementId_OrderClient  Integer, --
    IN inIsShowAll               Boolean,       -- признак показать все (уникальные по всему справочнику)
    IN inIsErased                Boolean,       -- признак показать удаленные да / нет
    IN inIsSale                  Boolean,       -- признак показать проданные да / нет
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId_OrderClient Integer
             , Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , Comment TVarChar

             , KeyId TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ReceiptProdModelChildId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsId_Receipt Integer

               -- Boat Structure
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
               -- Категория Опций
             , MaterialOptionsId Integer, MaterialOptionsName TVarChar

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
             , EKPrice TFloat, EKPrice_summ TFloat
             , Amount TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorItems());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
     WITH -- элементы ReceiptProdModelChild
          tmpReceiptProdModelChild AS(SELECT ObjectLink_ReceiptProdModel_master.ObjectId     AS ProductId
                                           , Object_ReceiptProdModel.Id                      AS ReceiptProdModelId
                                           , Object_ReceiptProdModelChild.Id                 AS ReceiptProdModelChildId
                                             -- Модель лодки у шаблона ProdModel
                                           , ObjectLink_Model.ChildObjectId                  AS ModelId
                                             -- элемент который будем раскладывать
                                           , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                             -- значение
                                           , ObjectFloat_Value.ValueData                     AS Value

                                      FROM ObjectLink AS ObjectLink_ReceiptProdModel_master

                                           INNER JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id       = ObjectLink_ReceiptProdModel_master.ChildObjectId
                                                                                    -- !!!ВСЕ!!!
                                                                                    -- AND Object_ReceiptProdModel.isErased = FALSE
                                           -- это главный шаблон ProdModel
                                         --INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                         --                         ON ObjectBoolean_Main.ObjectId  = Object_ReceiptProdModel.Id
                                         --                        AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptProdModel_Main()
                                         --                        AND ObjectBoolean_Main.ValueData = TRUE
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

                                      WHERE ObjectLink_ReceiptProdModel_master.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                                     )
          -- раскладываем ReceiptProdModelChild - для каждой ModelId
        , tmpProdColorPattern AS (SELECT tmpReceiptProdModelChild.ProductId                AS ProductId
                                       , tmpReceiptProdModelChild.ModelId                  AS ModelId
                                       , tmpReceiptProdModelChild.ReceiptProdModelId       AS ReceiptProdModelId
                                       , tmpReceiptProdModelChild.ReceiptProdModelChildId  AS ReceiptProdModelChildId
                                       , Object_ReceiptGoodsChild.Id                       AS ReceiptGoodsChildId
                                         -- всегда Цвет - у ReceiptGoodsChild or у Boat Structure  (когда нет GoodsId)
                                       , CASE WHEN Object_ReceiptGoodsChild.ValueData <> '' THEN Object_ReceiptGoodsChild.ValueData ELSE ObjectString_ProdColorPattern_Comment.ValueData END AS Comment
                                         -- если меняли на другой товар, не тот что в Boat Structure
                                       , ObjectLink_Object.ChildObjectId                   AS GoodsId
                                         -- нашли Элемент Boat Structure
                                       , ObjectLink_ProdColorPattern.ChildObjectId         AS ProdColorPatternId
                                         -- Категория Опций
                                       , ObjectLink_MaterialOptions.ChildObjectId          AS MaterialOptionsId
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
                                       -- Категория Опций
                                       LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                            ON ObjectLink_MaterialOptions.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                                       -- значение в сборке
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                       -- всегда Цвет
                                       LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                                              ON ObjectString_ProdColorPattern_Comment.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                             AND ObjectString_ProdColorPattern_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()
                                 )
      -- ??ВСЕ?? документы Заказ Клиента
    , tmpOrderClient AS (SELECT Movement.Id                              AS MovementId
                              , MovementLinkObject_Product.ObjectId      AS ProductId
                         FROM MovementLinkObject AS MovementLinkObject_Product
                              INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                 AND Movement.DescId = zc_Movement_OrderClient()
                                               --AND Movement.StatusId <> zc_Enum_Status_Erased()
                         -- !!!временно, надо будет как-то выбирать НЕ ВСЕ!!!
                         WHERE MovementLinkObject_Product.ObjectId > 0
                           AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                        )
     -- все лодки + определяем продана да/нет
   , tmpProduct AS (SELECT COALESCE (tmpOrderClient.MovementId, 0) AS MovementId_OrderClient
                         , Object_Product.Id
                         , Object_Product.ObjectCode
                         , Object_Product.ValueData
                         , Object_Product.isErased
                         , ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                         , ObjectLink_Model.ChildObjectId AS ModelId
                         , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                    FROM Object AS Object_Product
                         -- Модель лодки
                         LEFT JOIN ObjectLink AS ObjectLink_Model
                                              ON ObjectLink_Model.ObjectId = Object_Product.Id
                                             AND ObjectLink_Model.DescId   = zc_ObjectLink_Product_Model()
                         -- Шаблон сборки Модели
                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                              ON ObjectLink_ReceiptProdModel.ObjectId = Object_Product.Id
                                             AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                         LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId

                         -- продана да/нет
                         LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                              ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                             AND ObjectDate_DateSale.DescId   = zc_ObjectDate_Product_DateSale()
                        -- Заказы клиента
                         LEFT JOIN tmpOrderClient ON tmpOrderClient.ProductId = Object_Product.Id

                    WHERE Object_Product.DescId = zc_Object_Product()
                     AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                     AND (COALESCE (tmpOrderClient.MovementId, 0) = inMovementId_OrderClient OR inMovementId_OrderClient = 0)
                     AND (Object_Product.isErased = FALSE OR inIsErased = TRUE)
                   )

      -- существующие элементы ProdOptItems
    , tmpProdOptItems AS (SELECT ObjectLink_ProdOptions.ChildObjectId       AS ProdOptionsId
                               , ObjectLink_Product.ChildObjectId           AS ProductId

                               , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
                               , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId

                               , tmpProduct.MovementId_OrderClient

                          FROM Object AS Object_ProdOptItems
                               -- Лодка
                               INNER JOIN ObjectLink AS ObjectLink_Product
                                                     ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdOptItems_Product()
                               -- Заказ Клиента
                               INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                      ON ObjectFloat_MovementId_OrderClient.ObjectId = Object_ProdOptItems.Id
                                                     AND ObjectFloat_MovementId_OrderClient.DescId   = zc_ObjectFloat_ProdOptItems_OrderClient()
                               -- Заказ Клиента + Лодка
                               INNER JOIN tmpProduct ON tmpProduct.Id                     = ObjectLink_Product.ChildObjectId
                                                    AND tmpProduct.MovementId_OrderClient = ObjectFloat_MovementId_OrderClient.ValueData :: Integer
                               -- Опции
                               LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                                    ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                                                   AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()

                               -- Только с Boat Structure
                               LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                    ON ObjectLink_ProdColorPattern.ObjectId = ObjectLink_ProdOptions.ChildObjectId
                                                   AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()
                               -- Только с Категорией Опций
                               INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                    ON ObjectLink_MaterialOptions.ObjectId      = ObjectLink_ProdOptions.ChildObjectId
                                                   AND ObjectLink_MaterialOptions.DescId        = zc_ObjectLink_ProdOptions_MaterialOptions()
                                                   AND ObjectLink_MaterialOptions.ChildObjectId > 0

                          WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                            AND Object_ProdOptItems.isErased = FALSE
                            AND (tmpProduct.MovementId_OrderClient = inMovementId_OrderClient OR inMovementId_OrderClient = 0)
                         )
     -- существующие элементы Boat Structure
   , tmpRes_all AS (SELECT Object_ProdColorItems.Id         AS Id
                         , Object_ProdColorItems.ObjectCode AS Code
                         , Object_ProdColorItems.ValueData  AS Name
                         , Object_ProdColorItems.isErased   AS isErased

                         , ObjectLink_Product.ChildObjectId          AS ProductId
                         , tmpProduct.ReceiptProdModelId             AS ReceiptProdModelId
                         , ObjectLink_Goods.ChildObjectId            AS GoodsId
                         , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId

                         , tmpProduct.MovementId_OrderClient

                    FROM Object AS Object_ProdColorItems
                         -- Лодка
                         INNER JOIN ObjectLink AS ObjectLink_Product
                                               ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                              AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
                         -- Заказ Клиента
                         INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                ON ObjectFloat_MovementId_OrderClient.ObjectId = Object_ProdColorItems.Id
                                               AND ObjectFloat_MovementId_OrderClient.DescId   = zc_ObjectFloat_ProdColorItems_OrderClient()

                         INNER JOIN tmpProduct ON tmpProduct.Id = ObjectLink_Product.ChildObjectId
                                              AND tmpProduct.MovementId_OrderClient = ObjectFloat_MovementId_OrderClient.ValueData :: Integer

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
                     AND (tmpProduct.MovementId_OrderClient = inMovementId_OrderClient OR inMovementId_OrderClient = 0)
                   )
       , tmpRes AS (SELECT tmpRes_all.Id
                         , tmpRes_all.Code
                         , tmpRes_all.Name

                         , CASE WHEN tmpProdColorPattern.ProdColorPatternId > 0 AND COALESCE (tmpProdColorPattern.GoodsId, 0) <> COALESCE (tmpRes_all.GoodsId, 0)
                                     THEN TRUE

                                WHEN tmpProdColorPattern.ProdColorPatternId > 0 AND COALESCE (tmpRes_all.GoodsId, 0) = 0
                                 AND ObjectString_Comment.ValueData <> COALESCE (tmpProdColorPattern.Comment, '')
                                 AND ObjectString_Comment.ValueData <> ''
                                     THEN TRUE

                                WHEN tmpProdOptItems.MaterialOptionsId <> COALESCE (tmpProdColorPattern.MaterialOptionsId, 0)
                                 AND tmpProdOptItems.MaterialOptionsId > 0
                                     THEN TRUE

                                ELSE FALSE
                           END  :: Boolean AS isDiff
                         , TRUE :: Boolean AS isEnabled
                         , tmpRes_all.isErased

                         , tmpRes_all.ProductId                        AS ProductId
                         , tmpRes_all.ReceiptProdModelId               AS ReceiptProdModelId
                         , tmpProdColorPattern.ReceiptProdModelChildId AS ReceiptProdModelChildId

                         , tmpRes_all.GoodsId
                         , tmpRes_all.ProdColorPatternId
                           -- Категория Опций
                         , CASE WHEN tmpProdOptItems.MaterialOptionsId > 0 THEN tmpProdOptItems.MaterialOptionsId ELSE tmpProdColorPattern.MaterialOptionsId END AS MaterialOptionsId

                         , tmpProdColorPattern.GoodsId AS GoodsId_Receipt
                         , tmpProdColorPattern.Value   AS Value_Receipt
                         , tmpProdColorPattern.Comment AS Comment_Receipt

                         , tmpRes_all.MovementId_OrderClient

                     FROM tmpRes_all
                          LEFT JOIN tmpProdColorPattern ON tmpProdColorPattern.ProductId          = tmpRes_all.ProductId
                                                       AND tmpProdColorPattern.ProdColorPatternId = tmpRes_all.ProdColorPatternId
                                                     --AND tmpProdColorPattern.ModelId            = tmpProduct.ModelId
                                                     --AND tmpProdColorPattern.ReceiptProdModelId = tmpRes_all.ReceiptProdModelId

                         -- если меняли на другой MaterialOptionsId, не тот что в ReceiptGoodsChild
                         LEFT JOIN tmpProdOptItems ON tmpProdOptItems.MovementId_OrderClient = tmpRes_all.MovementId_OrderClient
                                                  AND tmpProdOptItems.ProductId              = tmpRes_all.ProductId
                                                  -- только такой элемент из Boat Structure
                                                  AND tmpProdOptItems.ProdColorPatternId     = tmpRes_all.ProdColorPatternId

                          -- здесь цвет (когда нет GoodsId)
                          LEFT JOIN ObjectString AS ObjectString_Comment
                                                 ON ObjectString_Comment.ObjectId = tmpRes_all.Id
                                                AND ObjectString_Comment.DescId    = zc_ObjectString_ProdColorItems_Comment()
                   UNION ALL
                    SELECT
                           0     :: Integer  AS Id
                         , 0     :: Integer  AS Code
                         , ''    :: TVarChar AS Name
                         , FALSE :: Boolean  AS isDiff
                         , FALSE :: Boolean  AS isEnabled
                         , FALSE :: Boolean  AS isErased

                         , tmpProduct.Id                               AS ProductId
                         , tmpProduct.ReceiptProdModelId               AS ReceiptProdModelId
                         , tmpProdColorPattern.ReceiptProdModelChildId AS ReceiptProdModelChildId

                         , tmpProdColorPattern.GoodsId
                         , tmpProdColorPattern.ProdColorPatternId
                         , tmpProdColorPattern.MaterialOptionsId
                         , tmpProdColorPattern.GoodsId AS GoodsId_Receipt
                         , tmpProdColorPattern.Value   AS Value_Receipt
                         , tmpProdColorPattern.Comment AS Comment_Receipt

                         , tmpProduct.MovementId_OrderClient

                    FROM tmpProdColorPattern
                         JOIN tmpProduct ON tmpProduct.Id = tmpProdColorPattern.ProductId
                                      --AND tmpProduct.ModelId = tmpProdColorPattern.ModelId
                                      --AND tmpProduct.ReceiptProdModelId = tmpProdColorPattern.ReceiptProdModelId
                         LEFT JOIN tmpRes_all ON tmpRes_all.ProductId              = tmpProduct.Id
                                             AND tmpRes_all.MovementId_OrderClient = tmpProduct.MovementId_OrderClient
                                             AND tmpRes_all.ProdColorPatternId     = tmpProdColorPattern.ProdColorPatternId
                                           --AND tmpRes_all.ReceiptProdModelId     = tmpProdColorPattern.ReceiptProdModelId
                    WHERE tmpRes_all.ProductId IS NULL
                      AND inIsShowAll          = TRUE
                   )

     -- Результат
     SELECT
           Object_ProdColorItems.MovementId_OrderClient
         , Object_ProdColorItems.Id    AS Id
         , Object_ProdColorItems.Code  AS Code
         , Object_ProdColorItems.Name  AS Name
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdColorPattern.ObjectCode ASC, Object_ProdColorPattern.Id ASC) :: Integer AS NPP

           -- "иногда" - цвет
         , CASE WHEN Object_ProdColorItems.GoodsId > 0
                     -- показываем что ввели - т.е. для Товара это Comment
                     THEN ObjectString_Comment.ValueData

                WHEN ObjectString_Comment.ValueData <> ''
                     -- показываем что ввели - здесь Цвет
                     THEN ObjectString_Comment.ValueData

                WHEN COALESCE (Object_ProdColorItems.Id, 0) = 0 AND Object_ProdColorItems.Comment_Receipt <> ''
                     THEN Object_ProdColorItems.Comment_Receipt

           END :: TVarChar AS Comment

         , (Object_Product.Id :: TVarChar || '_' || Object_ProdColorItems.MovementId_OrderClient :: TVarChar) :: TVarChar AS KeyId

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ObjectCode          ::Integer   AS ProductCode
         , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName

         , Object_ReceiptProdModel.Id                    :: Integer  AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData             :: TVarChar AS ReceiptProdModelName
         , Object_ProdColorItems.ReceiptProdModelChildId :: Integer  AS ReceiptProdModelChildId

         , Object_Goods.Id           ::Integer   AS GoodsId
         , Object_Goods.ObjectCode   ::Integer   AS GoodsCode
         , Object_Goods.ValueData    ::TVarChar  AS GoodsName

         , Object_ProdColorItems.GoodsId_Receipt

           -- Boat Structure
         , Object_ProdColorPattern.Id         ::Integer   AS ProdColorPatternId
         , Object_ProdColorPattern.ValueData  ::TVarChar  AS ProdColorPatternName
         , Object_ProdColorGroup.Id           ::Integer   AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar  AS ProdColorGroupName

           -- Категория Опций
         , Object_MaterialOptions.Id          ::Integer  AS MaterialOptionsId
         , Object_MaterialOptions.ValueData   ::TVarChar AS MaterialOptionsName

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
           -- цвет
         , (CASE WHEN Object_MaterialOptions.ValueData <> '' THEN Object_MaterialOptions.ValueData || ' ' ELSE '' END
         || CASE WHEN Object_ProdColorItems.GoodsId > 0
                      -- у Товара
                      THEN Object_ProdColor.ValueData

                 WHEN TRIM (ObjectString_Comment.ValueData) <> ''
                      -- если было изменение для Лодки (когда нет GoodsId)
                      THEN TRIM (ObjectString_Comment.ValueData)

                 -- у Receipt (когда нет GoodsId)
                 WHEN Object_ProdColorItems.Comment_Receipt <> ''
                      THEN Object_ProdColorItems.Comment_Receipt

                 ELSE ''

            END
            --|| ' ' || Object_Goods.Id ::TVarChar || ' '  || Object_ProdColorItems.GoodsId_Receipt::TVarChar
           ) :: TVarChar AS ProdColorName
           --
         , Object_Measure.ValueData                   AS MeasureName

           -- Цена вх. без НДС
         , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
           -- Сумма вх. без НДС
         , (Object_ProdColorItems.Value_Receipt * ObjectFloat_EKPrice.ValueData)   ::TFloat   AS EKPrice_summ

           -- кол-во в сборке
         , Object_ProdColorItems.Value_Receipt ::TFloat AS Amount

     FROM tmpRes AS Object_ProdColorItems
          -- здесь цвет (когда нет GoodsId)
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                AND ObjectString_Comment.DescId    = zc_ObjectString_ProdColorItems_Comment()
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
          LEFT JOIN Object AS Object_MaterialOptions  ON Object_MaterialOptions.Id  = Object_ProdColorItems.MaterialOptionsId
          LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = Object_ProdColorItems.ReceiptProdModelId

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

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
                                ON ObjectFloat_EKPrice.ObjectId = Object_ProdColorItems.GoodsId_Receipt -- Object_Goods.Id
                               AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
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
-- SELECT * FROM gpSelect_Object_ProdColorItems (0,false,false,false, zfCalc_UserAdmin())
