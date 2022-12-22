-- Function: gpSelect_Object_Product_StructureGoodsPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_StructureGoodsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_StructureGoodsPrint(
    IN inMovementId_OrderClient       Integer   ,   --
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS TABLE (GroupId Integer, GroupName TVarChar
             , ObjectId Integer, ObjectCode Integer, Article_Object TVarChar, ObjectName TVarChar, DescName TVarChar, ProdColorName TVarChar
             , ObjectId_dt Integer, ObjectCode_dt Integer, Article_Object_dt TVarChar, ObjectName_dt TVarChar, DescName_dt TVarChar, ProdColorName_dt TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , PartnerId_dt Integer, PartnerName_dt TVarChar
             , Amount_ch TFloat, Amount_unit_ch TFloat, Value_service_ch TFloat, Amount_partner_ch TFloat
             , Amount_dt NUMERIC(16, 8), Amount_unit_dt TFloat, Value_service_dt TFloat, Amount_partner_dt TFloat
             , GoodsGroupId Integer, GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , GoodsGroupId_dt Integer, GoodsGroupNameFull_dt TVarChar, GoodsGroupName_dt TVarChar
             , ReceiptLevelName TVarChar, ReceiptLevelName_dt TVarChar
             , NPP_1 Integer, NPP_2 Integer
             , NPP_pcp Integer,ProdColorPatternId Integer, ProdColorPatternCode Integer, ProdColorPatternName TVarChar
             , Color_Value Integer
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbProductId          Integer;
    DECLARE vbReceiptProdModelId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- поиск лодки
     SELECT MovementLinkObject_Product.ObjectId               AS ProductId
          , ObjectLink_Product_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
            INTO vbProductId
               , vbReceiptProdModelId
     FROM Movement AS Movement_OrderClient
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                       ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                      AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
          LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                               ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                              AND ObjectLink_Product_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
     WHERE Movement_OrderClient.Id     = inMovementId_OrderClient
       AND Movement_OrderClient.DescId = zc_Movement_OrderClient();

     -- ProdColorItems
     CREATE TEMP TABLE tmpProdColorItems ON COMMIT DROP
        AS (SELECT gpSelect.Npp
                   -- Boat Structure
                 , gpSelect.ProdColorPatternId, gpSelect.ProdColorPatternName_sh AS ProdColorPatternName
                 , gpSelect.ProdColorGroupId, gpSelect.ProdColorGroupName
                   -- Категория Опций
                 , gpSelect.MaterialOptionsId, gpSelect.MaterialOptionsName
                   --
                 , gpSelect.GoodsId
                   --
                 , gpSelect.ProdColorName, gpSelect.Color_Value
            FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS gpSelect
            WHERE gpSelect.ProductId              = vbProductId
              AND gpSelect.MovementId_OrderClient = inMovementId_OrderClient
           );
     -- ProdOptItems
     CREATE TEMP TABLE tmpProdOptItems ON COMMIT DROP
        AS (SELECT gpSelect.Npp
                 , gpSelect.ProdOptionsId, gpSelect.ProdOptionsName
                 , gpSelect.ProdOptPatternId, gpSelect.ProdOptPatternName
                 , gpSelect.MaterialOptionsId, gpSelect.MaterialOptionsName
                 , gpSelect.GoodsId, gpSelect.GoodsCode, gpSelect.GoodsName
                 , gpSelect.ProdColorName
                 , gpSelect.ProdColorPatternId
            FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS gpSelect
            WHERE gpSelect.ProductId              = vbProductId
              AND gpSelect.MovementId_OrderClient = inMovementId_OrderClient
           );


     -- Результат
     RETURN QUERY
      WITH -- Элементы - шаблон сборка Модели
           tmpItem_Сhild AS (SELECT MovementItem.Id                           AS MovementItemId
                                  , MILinkObject_Partner.ObjectId             AS PartnerId
                                    --
                                  , MILinkObject_Goods_basis.ObjectId         AS ObjectId_basis
                                    --
                                  , COALESCE (MILinkObject_ProdOptions.ObjectId, 0) AS ProdOptionsId
                                    -- Узел / Комплектующие / Работы/Услуги
                                  , MovementItem.ObjectId                     AS ObjectId
                                    -- Количество шаблон сборки
                                  , MovementItem.Amount / CASE WHEN MIFloat_ForCount.ValueData > 0 THEN MIFloat_ForCount.ValueData ELSE 1 END AS Amount
                                    -- Количество заказ поставщику
                                  , MIFloat_AmountPartner.ValueData           AS AmountPartner

                             FROM MovementItem
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                   ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                                   ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                                   ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()

                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                  LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                              ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                             WHERE MovementItem.MovementId = inMovementId_OrderClient
                               AND MovementItem.DescId     = zc_MI_Child()
                               AND MovementItem.isErased   = FALSE
                            )
     -- Элементы - Комплектующие сборка узла
   , tmpItem_Detail AS (SELECT MovementItem.Id                           AS MovementItemId
                               -- Поставщик
                             , MILinkObject_Partner.ObjectId             AS PartnerId

                               -- какой узел собирается = zc_MI_Child.ObjectId, всегда заполнен
                             , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                             , COALESCE (MILinkObject_Goods_basis.ObjectId, 0) AS GoodsId_basis
                               -- Комплектующие / Работы/Услуги
                             , MovementItem.ObjectId                     AS ObjectId
                               --  Опция
                             , MILinkObject_ProdOptions.ObjectId         AS ProdOptionsId
                               -- Шаблон Boat Structure
                             , MILinkObject_ColorPattern.ObjectId        AS ColorPatternId
                               --  Boat Structure
                             , MILinkObject_ProdColorPattern.ObjectId    AS ProdColorPatternId
                               --
                             , MILinkObject_ReceiptLevel.ObjectId        AS ReceiptLevelId
                               -- Количество для сборки Узла
                             , MovementItem.Amount / CASE WHEN MIFloat_ForCount.ValueData > 0 THEN MIFloat_ForCount.ValueData ELSE 1 END AS Amount
                               -- Количество заказ поставщику
                             , MIFloat_AmountPartner.ValueData           AS AmountPartner

                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                              ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                              ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                              ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                              ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                              ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                              ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                              ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                             LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                         ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                        AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                        WHERE MovementItem.MovementId = inMovementId_OrderClient
                          AND MovementItem.DescId     = zc_MI_Detail()
                          AND MovementItem.isErased   = FALSE
                       )

    , tmpReceiptLevel AS (-- уровень ReceiptProdModel
                          SELECT DISTINCT
                                 -- лодка
                                 0                             AS GoodsId_parent
                                 -- комплектующие/узел
                               , tmpItem_Сhild.ObjectId        AS GoodsId
                                 -- LevelName
                               , Object_ReceiptLevel.ValueData AS ReceiptLevelName
                                 --
                               , 0                             AS Value
                                 -- "виртуальный" узел
                               , 0                             AS GoodsId_child
                               , ROW_NUMBER() OVER (ORDER BY Object_ReceiptLevel.ValueData) :: Integer AS NPP_1
                          FROM tmpItem_Сhild
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                    ON ObjectLink_ReceiptProdModelChild_Object.ChildObjectId = CASE WHEN tmpItem_Сhild.ObjectId_basis > 0 THEN tmpItem_Сhild.ObjectId_basis ELSE tmpItem_Сhild.ObjectId END
                                                   AND ObjectLink_ReceiptProdModelChild_Object.DescId        = zc_ObjectLink_ReceiptProdModelChild_Object()
                               --- берем не удаленные
                               INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                                                AND Object_ReceiptProdModelChild.IsErased = FALSE
                               -- ReceiptProdModel по лодке
                               INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                     ON ObjectLink_ReceiptProdModel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                    AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                                    AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId

                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptLevel
                                                    ON ObjectLink_ReceiptProdModelChild_ReceiptLevel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                   AND ObjectLink_ReceiptProdModelChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                               LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptProdModelChild_ReceiptLevel.ChildObjectId
                        /* UNION
                          -- уровень ReceiptGoods
                          SELECT DISTINCT
                                 -- какой узел собирается
                                 tmpItem.GoodsId                     AS GoodsId_parent
                                 -- комплектующие
                               , tmpItem.ObjectId                    AS GoodsId
                                 -- LevelName
                               , Object_ReceiptLevel.ValueData       AS ReceiptLevelName
                                 --
                               , ObjectFloat_ReceiptGoodsChild_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
                                 -- "виртуальный" узел
                               , ObjectLink_GoodsChild.ChildObjectId AS GoodsId_child
                          FROM tmpItem_Detail AS tmpItem
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                                    ON ObjectLink_ReceiptGoodsChild_Object.ChildObjectId = tmpItem.ObjectId
                                                   AND ObjectLink_ReceiptGoodsChild_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
                               -- ReceiptGoodsChild не удаленные
                               INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_Object.ObjectId
                                                                            AND Object_ReceiptGoodsChild.IsErased = FALSE
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptLevel
                                                    ON ObjectLink_ReceiptGoodsChild_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                   AND ObjectLink_ReceiptGoodsChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                               LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptGoodsChild_ReceiptLevel.ChildObjectId
                               LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                    ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                   AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                               -- значение в сборке
                               LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptGoodsChild_Value
                                                     ON ObjectFloat_ReceiptGoodsChild_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                    AND ObjectFloat_ReceiptGoodsChild_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                               LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                     ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                                    AND ObjectFloat_ForCount.DescId = zc_ObjectFloat_ReceiptGoodsChild_ForCount()

                               -- ReceiptGoods
                               INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                     ON ObjectLink_ReceiptGoods.ObjectId      = Object_ReceiptGoodsChild.Id
                                                    AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                               -- ReceiptGoods не удаленный
                               INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_ReceiptGoods.ChildObjectId
                                                                       AND Object_ReceiptGoods.IsErased = FALSE
                               INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                     ON ObjectLink_ReceiptGoods_Object.ObjectId      = Object_ReceiptGoods.Id
                                                    AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                                    AND ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpItem.GoodsId*/
                         )
      -- Результат
      -- 1. ProdColorItems
      SELECT
             CASE WHEN tmpReceiptLevel.NPP_1 = 1  THEN 22
                  WHEN tmpReceiptLevel.NPP_1 = 2  THEN 24
                  WHEN tmpItem_Сhild.GroupId = 22 THEN 23
                  ELSE tmpItem_Сhild.GroupId
             END :: Integer AS GroupId
           , CASE WHEN tmpItem_Сhild.GroupId = 1
                      THEN 'Конфигуратор'

                  WHEN tmpItem_Сhild.GroupId = 2
                      THEN 'Опции'

                  WHEN tmpItem_Сhild.GroupId = 3
                      THEN 'Сборка Лодки'

                  WHEN tmpItem_Сhild.GroupId = 11
                      THEN 'Сборка узлов Level 1'

                  WHEN tmpItem_Сhild.GroupId = 22
                      THEN 'Сборка узлов Level 2'
             END                              :: TVarChar AS GroupName
           , Object_ch.Id                                 AS ObjectId
           , Object_ch.ObjectCode                         AS ObjectCode
           , ObjectString_Article_ch.ValueData            AS Article_Object
           , Object_ch.ValueData                          AS ObjectName
           , ObjectDesc_ch.ItemName                       AS DescName
           , Object_ProdColor_ch.ValueData                AS ProdColorName

           , Object_dt.Id                                 AS ObjectId_dt
           , Object_dt.ObjectCode                         AS ObjectCode_dt
           , ObjectString_Article_dt.ValueData            AS Article_Object_dt
           , Object_dt.ValueData                          AS ObjectName_dt
         --, (Object_dt.ValueData || ' '  || tmpItem_Detail.GoodsId_basis :: TVarChar) :: TVarChar AS ObjectName_dt

           , ObjectDesc_dt.ItemName                       AS DescName_dt
           , Object_ProdColor_dt.ValueData                AS ProdColorName_dt

           , Object_Partner_ch.Id                         AS PartnerId
           , Object_Partner_ch.ValueData                  AS PartnerName

           , Object_Partner_dt.Id                         AS PartnerId_dt
           , Object_Partner_dt.ValueData                  AS PartnerName_dt

             -- Количество шаблон сборки
           , tmpItem_Сhild.Amount               :: TFloat AS Amount_ch
             -- Количество
           , CASE WHEN ObjectDesc_ch.Id = zc_Object_Goods()          THEN tmpItem_Сhild.Amount ELSE 0 END :: TFloat AS Amount_unit_ch
             -- работы/услуги
           , CASE WHEN ObjectDesc_ch.Id = zc_Object_ReceiptService() THEN tmpItem_Сhild.Amount ELSE 0 END :: TFloat AS Value_service_ch
             -- Количество заказ поставщику
           , tmpItem_Сhild.AmountPartner        :: TFloat AS Amount_partner_ch

             -- Количество сборка узла
           , CAST (tmpItem_Detail.Amount AS NUMERIC(16, 8))  AS Amount_dt
             -- Количество
           , CASE WHEN ObjectDesc_dt.Id = zc_Object_Goods()          THEN tmpItem_Detail.Amount ELSE 0 END :: TFloat AS Amount_unit_dt
             -- работы/услуги
           , CASE WHEN ObjectDesc_dt.Id = zc_Object_ReceiptService() THEN tmpItem_Detail.Amount ELSE 0 END :: TFloat AS Value_service_dt
             -- Количество заказ поставщику
           , tmpItem_Detail.AmountPartner       :: TFloat AS Amount_partner_dt

           , ObjectLink_GoodsGroup_ch.ChildObjectId   AS GoodsGroupId
           , ObjectString_GoodsGroupFull_ch.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup_ch.ValueData           AS GoodsGroupName
           , ObjectLink_GoodsGroup_dt.ChildObjectId   AS GoodsGroupId_dt
           , ObjectString_GoodsGroupFull_dt.ValueData AS GoodsGroupNameFull_dt
           , Object_GoodsGroup_dt.ValueData           AS GoodsGroupName_dt

           , tmpReceiptLevel.ReceiptLevelName    :: TVarChar AS ReceiptLevelName
           , COALESCE (Object_ReceiptLevel_dt.ValueData, tmpReceiptLevel_dt.ReceiptLevelName) :: TVarChar AS ReceiptLevelName_dt

           , COALESCE (tmpReceiptLevel.NPP_1, Object_ch.Id) :: Integer AS NPP_1
           , ROW_NUMBER() OVER (PARTITION BY tmpItem_Сhild.GroupId, tmpItem_Сhild.ObjectId
                                ORDER BY -- для сборки Hypalon
                                         CASE WHEN tmpItem_Detail.ProdColorPatternId > 0 AND tmpItem_Сhild.GroupId <> 11
                                              THEN 0
                                              ELSE 1
                                         END
                                         -- № п/п для сборки Hypalon
                                       , CASE WHEN tmpItem_Сhild.GroupId <> 11
                                              THEN COALESCE (tmpProdColorItems.Npp, 0)
                                              ELSE 1000
                                         END

                                         -- для артикулов ПФ - в начало
                                       , CASE WHEN ObjectString_Article_dt.ValueData ILIKE '%ПФ' THEN 0 ELSE 1 END
                                         -- для товаров ПФ - в начало
                                       , CASE WHEN Object_dt.ValueData ILIKE 'ПФ%' THEN 0 ELSE 1 END
                                         -- для сборки модели 01+02+03 и для сборки узлов 1+2+3
                                       , COALESCE (Object_ReceiptLevel_dt.ValueData, tmpReceiptLevel_dt.ReceiptLevelName)

                                         -- для сборки Hypalon
                                       , CASE WHEN tmpItem_Detail.ProdColorPatternId > 0 AND tmpItem_Сhild.GroupId = 11
                                              THEN 0
                                              ELSE 1
                                         END
                                         -- № п/п для сборки Hypalon
                                       , COALESCE (tmpProdColorItems.Npp, 0)

                                         -- для сборки модели - сначала узлы
                                       , CASE WHEN EXISTS (SELECT 1 FROM tmpItem_Detail AS tmp WHERE tmp.GoodsId = tmpItem_Detail.ObjectId)
                                                   THEN 0
                                              ELSE 1
                                         END
                                       , Object_dt.ValueData
                               ) :: Integer AS NPP_2

           , tmpProdColorItems.Npp   :: Integer AS NPP_pcp
           , Object_ProdColorPattern.Id         AS ProdColorPatternId
           , Object_ProdColorPattern.ObjectCode AS ProdColorPatternCode
           , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName

           , zc_Color_White() :: Integer AS Color_Value


       FROM (-- уровень 3 - собираем Лодку
             SELECT DISTINCT
                    3 AS GroupId
                  , -1 AS ObjectId
                  , 0 AS PartnerId
                  , 0 AS Amount
                  , 0 AS AmountPartner

            UNION ALL
             -- уровень 1 - собираем только "виртуальные" узлы
             SELECT DISTINCT
                    11 AS GroupId
                  , tmpItem_Detail.GoodsId_basis AS ObjectId
                  , 0 AS PartnerId
                  , 1 AS Amount
                  , 0 AS AmountPartner
             FROM tmpItem_Detail
             WHERE tmpItem_Detail.GoodsId_basis > 0

            UNION ALL
             -- уровень 2 - собираем узлы и подставляем "виртуальные" узлы
             SELECT 22 AS GroupId
                  , tmpItem_Сhild.ObjectId
                  , tmpItem_Сhild.PartnerId
                  , tmpItem_Сhild.Amount
                  , tmpItem_Сhild.AmountPartner
             FROM tmpItem_Сhild

            ) AS tmpItem_Сhild
            -- Элементы - сборки Модели
            LEFT JOIN Object AS Object_ch ON Object_ch.Id = tmpItem_Сhild.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_ch
                                   ON ObjectString_Article_ch.ObjectId = tmpItem_Сhild.ObjectId
                                  AND ObjectString_Article_ch.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_ch ON ObjectDesc_ch.Id = Object_ch.DescId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull_ch
                                   ON ObjectString_GoodsGroupFull_ch.ObjectId = tmpItem_Сhild.ObjectId
                                  AND ObjectString_GoodsGroupFull_ch.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor_ch
                                 ON ObjectLink_ProdColor_ch.ObjectId = tmpItem_Сhild.ObjectId
                                AND ObjectLink_ProdColor_ch.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_ch
                                 ON ObjectLink_GoodsGroup_ch.ObjectId = tmpItem_Сhild.ObjectId
                                AND ObjectLink_GoodsGroup_ch.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_Partner_ch    ON Object_Partner_ch.Id    = tmpItem_Сhild.PartnerId
            LEFT JOIN Object AS Object_GoodsGroup_ch ON Object_GoodsGroup_ch.Id = ObjectLink_GoodsGroup_ch.ChildObjectId
            LEFT JOIN Object AS Object_ProdColor_ch  ON Object_ProdColor_ch.Id  = ObjectLink_ProdColor_ch.ChildObjectId

            LEFT JOIN tmpReceiptLevel ON tmpReceiptLevel.GoodsId = tmpItem_Сhild.ObjectId
                                     AND tmpItem_Сhild.GroupId   = 22
            -- Комплектующие сборка узла
            INNER JOIN (-- уровень 3 - собираем Лодку
                        SELECT
                               -1 AS GoodsId
                             , tmpItem_Сhild.ObjectId
                             , tmpItem_Сhild.PartnerId
                             , tmpItem_Сhild.Amount
                             , tmpItem_Сhild.AmountPartner
                             , 0 AS GoodsId_basis
                             , 0 AS ReceiptLevelId
                             , 0 AS ProdColorPatternId
                        FROM tmpItem_Сhild
                        WHERE tmpItem_Сhild.ProdOptionsId = 0

                       UNION ALL
                        -- уровень 1 - собираем только "виртуальные" узлы
                        SELECT
                               tmpItem_Detail.GoodsId_basis AS GoodsId
                             , tmpItem_Detail.ObjectId
                             , tmpItem_Detail.PartnerId
                             , tmpItem_Detail.Amount
                             , tmpItem_Detail.AmountPartner
                             , tmpItem_Detail.GoodsId_basis
                             , tmpItem_Detail.ReceiptLevelId
                             , tmpItem_Detail.ProdColorPatternId
                        FROM tmpItem_Detail
                        WHERE tmpItem_Detail.GoodsId_basis > 0

                       UNION ALL
                        -- уровень 2 - собираем узлы и подставляем "виртуальные" узлы
                        SELECT DISTINCT
                               tmpItem_Detail.GoodsId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN tmpItem_Detail.GoodsId_basis ELSE tmpItem_Detail.ObjectId END AS ObjectId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.PartnerId     END AS PartnerId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 1 ELSE tmpItem_Detail.Amount        END AS Amount
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.AmountPartner END AS AmountPartner
                             , 0 AS GoodsId_basis
                             , 0 AS ReceiptLevelId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.ProdColorPatternId END AS ProdColorPatternId
                        FROM tmpItem_Detail

                       ) AS tmpItem_Detail
                         ON tmpItem_Detail.GoodsId = tmpItem_Сhild.ObjectId

            LEFT JOIN tmpProdColorItems ON tmpProdColorItems.ProdColorPatternId = tmpItem_Detail.ProdColorPatternId
                                       AND tmpProdColorItems.GoodsId            = tmpItem_Detail.ObjectId
                    --AND 1=0

            -- Boat Structure
            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpItem_Detail.ProdColorPatternId
            -- Шаблон Boat Structure
            LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                 ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
            LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Model
                                 ON ObjectLink_Model.ObjectId = Object_ColorPattern.Id
                                AND ObjectLink_Model.DescId = zc_ObjectLink_ColorPattern_Model()
            LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
            -- Категория/Группа Boat Structure
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                 ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId


            LEFT JOIN Object AS Object_dt ON Object_dt.Id = tmpItem_Detail.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_dt
                                   ON ObjectString_Article_dt.ObjectId = Object_dt.Id
                                  AND ObjectString_Article_dt.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_dt ON ObjectDesc_dt.Id = Object_dt.DescId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull_dt
                                   ON ObjectString_GoodsGroupFull_dt.ObjectId = Object_dt.Id
                                  AND ObjectString_GoodsGroupFull_dt.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor_dt
                                 ON ObjectLink_ProdColor_dt.ObjectId = Object_dt.Id
                                AND ObjectLink_ProdColor_dt.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_dt
                                 ON ObjectLink_GoodsGroup_dt.ObjectId = Object_dt.Id
                                AND ObjectLink_GoodsGroup_dt.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_Partner_dt    ON Object_Partner_dt.Id    = tmpItem_Detail.PartnerId
            LEFT JOIN Object AS Object_GoodsGroup_dt ON Object_GoodsGroup_dt.Id = ObjectLink_GoodsGroup_dt.ChildObjectId
            LEFT JOIN Object AS Object_ProdColor_dt  ON Object_ProdColor_dt.Id  = ObjectLink_ProdColor_dt.ChildObjectId

            LEFT JOIN Object AS Object_ReceiptLevel_dt ON Object_ReceiptLevel_dt.Id = tmpItem_Detail.ReceiptLevelId
            LEFT JOIN tmpReceiptLevel AS tmpReceiptLevel_dt ON tmpReceiptLevel_dt.GoodsId = Object_dt.Id
            /*LEFT JOIN tmpReceiptLevel AS tmpReceiptLevel_dt ON tmpReceiptLevel_dt.GoodsId = Object_dt.Id
                                                           AND (tmpReceiptLevel_dt.Value = tmpItem_Detail.Amount
                                                             OR tmpItem_Detail.GoodsId   = -1
                                                               )*/

       WHERE ObjectDesc_dt.Id = zc_Object_Goods()

      UNION ALL
       SELECT
             1  :: Integer AS GroupId
           , 'Конфигуратор' :: TVarChar AS GroupName
           , -2  :: Integer  AS ObjectId
           , 0  :: Integer  AS ObjectCode
           , '' :: TVarChar AS Article_Object
           , 'Конфигуратор' :: TVarChar AS ObjectName
           , '' :: TVarChar AS DescName
           , '' :: TVarChar AS ProdColorName

           , tmpProdColorItems.ProdColorPatternId        AS ObjectId_dt
           , 0  :: Integer  AS ObjectCode_dt
           , '' :: TVarChar AS Article_Object_dt
           , ('' || ''  || '') :: TVarChar AS ObjectName_dt

           , '' :: TVarChar AS DescName_dt
           , tmpProdColorItems.ProdColorName AS ProdColorName_dt

           , 0  :: Integer  AS PartnerId
           , '' :: TVarChar AS PartnerName

           , 0  :: Integer  AS PartnerId_dt
           , '' :: TVarChar AS PartnerName_dt

             -- Количество шаблон сборки
           , 0  :: TFloat   AS Amount_ch
             -- Количество
           , 0  :: TFloat   AS Amount_unit_ch
             -- работы/услуги
           , 0  :: TFloat   AS Value_service_ch
             -- Количество заказ поставщику
           , 0  :: TFloat   AS Amount_partner_ch

             -- Количество сборка узла
           , CAST (0  AS NUMERIC(16, 8)) AS Amount_dt
             -- Количество
           , 0  :: TFloat   AS Amount_unit_dt
             -- работы/услуги
           , 0  :: TFloat   AS Value_service_dt
             -- Количество заказ поставщику
           , 0  :: TFloat   AS Amount_partner_dt

           , 0  :: Integer  AS GoodsGroupId
           , '' :: TVarChar AS GoodsGroupNameFull
           , '' :: TVarChar AS GoodsGroupName
           , 0  :: Integer  AS GoodsGroupId_dt
           , '' :: TVarChar AS GoodsGroupNameFull_dt
           , '' :: TVarChar AS GoodsGroupName_dt

           , '' :: TVarChar AS ReceiptLevelName
           , tmpProdColorItems.ProdColorPatternName :: TVarChar AS ReceiptLevelName_dt

           , -2                    :: Integer AS NPP_1
           , tmpProdColorItems.Npp :: Integer AS NPP_2

           , tmpProdColorItems.Npp :: Integer AS NPP_pcp
           , 0  :: Integer  AS ProdColorPatternId
           , 0  :: Integer  AS ProdColorPatternCode
           , '' :: TVarChar AS ProdColorPatternName

           , tmpProdColorItems.Color_Value

       FROM tmpProdColorItems

      UNION ALL
       SELECT
             1  :: Integer AS GroupId
           , 'Опции' :: TVarChar AS GroupName
           , -1 :: Integer  AS ObjectId
           , 0  :: Integer  AS ObjectCode
           , '' :: TVarChar AS Article_Object
           , 'Опции' :: TVarChar AS ObjectName
           , '' :: TVarChar AS DescName
           , '' :: TVarChar AS ProdColorName

           , tmpProdOptItems.ProdOptPatternId AS ObjectId_dt
           , 0  :: Integer  AS ObjectCode_dt
           , '' :: TVarChar AS Article_Object_dt
           , (tmpProdOptItems.ProdOptionsName || ''  || '') :: TVarChar AS ObjectName_dt

           , '' :: TVarChar AS DescName_dt
           , tmpProdOptItems.ProdColorName AS ProdColorName_dt

           , 0  :: Integer  AS PartnerId
           , '' :: TVarChar AS PartnerName

           , 0  :: Integer  AS PartnerId_dt
           , '' :: TVarChar AS PartnerName_dt

             -- Количество шаблон сборки
           , 0  :: TFloat   AS Amount_ch
             -- Количество
           , 0  :: TFloat   AS Amount_unit_ch
             -- работы/услуги
           , 0  :: TFloat   AS Value_service_ch
             -- Количество заказ поставщику
           , 0  :: TFloat   AS Amount_partner_ch

             -- Количество сборка узла
           , CAST (1  AS NUMERIC(16, 8)) AS Amount_dt
             -- Количество
           , 0  :: TFloat   AS Amount_unit_dt
             -- работы/услуги
           , 0  :: TFloat   AS Value_service_dt
             -- Количество заказ поставщику
           , 0  :: TFloat   AS Amount_partner_dt

           , 0  :: Integer  AS GoodsGroupId
           , '' :: TVarChar AS GoodsGroupNameFull
           , '' :: TVarChar AS GoodsGroupName
           , 0  :: Integer  AS GoodsGroupId_dt
           , '' :: TVarChar AS GoodsGroupNameFull_dt
           , '' :: TVarChar AS GoodsGroupName_dt

           , '' :: TVarChar AS ReceiptLevelName
           , '' :: TVarChar AS ReceiptLevelName_dt

           , -1                  :: Integer AS NPP_1
           , tmpProdOptItems.Npp :: Integer AS NPP_2

           , 0  :: Integer  AS NPP_pcp
           , 0  :: Integer  AS ProdColorPatternId
           , 0  :: Integer  AS ProdColorPatternCode
           , '' :: TVarChar AS ProdColorPatternName

           , zc_Color_White()    :: Integer AS Color_Value

       FROM tmpProdOptItems
       WHERE COALESCE (tmpProdOptItems.ProdColorPatternId, 0) = 0

       ORDER BY 1
              , 35
              , 36
            --, tmpItem_Detail.Amount
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Product_StructureGoodsPrint (inMovementId_OrderClient:= 662, inSession:= zfCalc_UserAdmin())
