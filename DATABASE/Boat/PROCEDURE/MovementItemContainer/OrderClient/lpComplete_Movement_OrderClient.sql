-- Function: lpComplete_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderClient(
    IN inMovementId        Integer  , -- ключ Документа
    IN inIsChild_Recalc    Boolean  , -- Пересчет Комплектующих
    IN inUserId            Integer    -- Пользователь
)
RETURNS TABLE (MovementItemId         Integer
             , ContainerId_Goods      Integer
             , ObjectId_parent        Integer
             , ObjectId_parent_find   Integer
             , ObjectId               Integer
             , PartionId              Integer
             , ProdOptionsId          Integer
             , ColorPatternId         Integer
             , ProdColorPatternId     Integer
             , ProdColorName          TVarChar
             , OperCount              TFloat
             , OperCountPartner       TFloat
             , OperPrice              TFloat
              )
AS
$BODY$
  DECLARE vbProductId      Integer;
  DECLARE vbPartionId_1    Integer;
  DECLARE vbPartionId_2    Integer;
  DECLARE vbClientId_From  Integer;
  DECLARE vbUnitId_To      Integer;
BEGIN

     -- нашли Лодку
     vbProductId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product());

     -- Параметры из документа
     SELECT MovementLinkObject_From.ObjectId AS ClientId_From
          , MovementLinkObject_To.ObjectId   AS UnitId_To
            INTO vbClientId_From, vbUnitId_To
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
     WHERE Movement.Id       = inMovementId
       AND Movement.DescId   = zc_Movement_OrderClient()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
    ;

     -- проверка - Kunden
     IF COALESCE (vbClientId_From, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Kunden>.';
     END IF;
     -- проверка - Подразделение
     IF COALESCE (vbUnitId_To, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Подразделение (Кому)>.';
     END IF;
     -- проверка - Подразделение - Производство
     IF vbUnitId_To <> zc_Unit_Production() AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product() AND MLO.ObjectId > 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Для <Подразделение (Кому)> необходимо установить значение = <%>.', lfGet_Object_ValueData_sh (zc_Unit_Production());
     END IF;


     -- !!!Только если нужен пересчет!!!
     -- !!!еще добавить если в заказе только запчасти!!!
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product() AND MLO.ObjectId > 0)
        AND (inIsChild_Recalc = TRUE
          OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
            )
     THEN
         -- таблица - в этом списке будем искать
         CREATE TEMP TABLE _tmpReceiptItems_new (ReceiptGoodsChildId Integer, ReceiptGoodsId Integer
                                               , ObjectId_parent_old Integer, ObjectId_parent Integer, ObjectId Integer, ProdColorPatternId Integer
                                               , MaterialOptionsId Integer, ColorPatternId Integer
                                               , ProdColorName TVarChar
                                               , Key_Id TVarChar, Key_Id_text TVarChar
                                                ) ON COMMIT DROP;
         -- таблица - в этом списке будем искать
         CREATE TEMP TABLE _tmpReceiptItems_Key (ReceiptGoodsChildId Integer, ReceiptGoodsId Integer
                                               , ObjectId_parent Integer, ObjectId Integer, ObjectId_pcp Integer, ProdColorPatternId Integer
                                               , MaterialOptionsId Integer, ColorPatternId Integer
                                               , ProdColorName TVarChar, ProdColorName_pcp TVarChar
                                               , Key_Id TVarChar, Key_Id_text TVarChar
                                                ) ON COMMIT DROP;
         -- таблица - элементы документа, со всеми свойствами
         CREATE TEMP TABLE _tmpItem_all (ObjectId_parent_find Integer, ObjectId_parent Integer, ObjectId Integer, ObjectDescId Integer
                                       , ProdOptionsId Integer
                                       , ColorPatternId Integer
                                        -- Boat Structure
                                       , ProdColorPatternId Integer
                                         -- Категория Опций
                                       , MaterialOptionsId Integer
                                         -- Цвет - только Примечание
                                       , ProdColorName TVarChar
                                         --
                                       , OperCount_parent TFloat, OperCount TFloat
                                       , OperPrice TFloat
                                         --
                                       , Key_Id TVarChar, Key_Id_text TVarChar
                                        ) ON COMMIT DROP;
         -- таблица - элементы документа, по партиям
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Goods Integer
                                   , ObjectId Integer, PartionId Integer
                                     -- Boat Structure
                                   , ProdColorPatternId  Integer
                                     -- Категория Опций
                                   , MaterialOptionsId Integer
                                     --
                                   , OperCount TFloat
                                   , OperCountPartner TFloat
                                   , OperPricePartner TFloat
                                   , ObjectDescId Integer
                                    ) ON COMMIT DROP;


         -- таблица - в этом списке будем искать
         INSERT INTO _tmpReceiptItems_Key (ReceiptGoodsChildId, ReceiptGoodsId, ObjectId_parent, ObjectId, ObjectId_pcp, ProdColorPatternId, MaterialOptionsId, ColorPatternId, ProdColorName, ProdColorName_pcp, Key_Id, Key_Id_text)
           WITH -- шаблон сборки Узла - элементы Boat Structure
                tmpReceiptItems AS (SELECT Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                                         , ObjectLink_ReceiptGoods.ChildObjectId           AS ReceiptGoodsId
                                           -- узел
                                         , ObjectLink_Goods.ChildObjectId                  AS ObjectId_parent
                                           -- если меняли на другой товар, не тот что в Boat Structure
                                         , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                           -- товар в Boat Structure
                                         , ObjectLink_ProdColorPattern_Goods.ChildObjectId AS ObjectId_pcp
                                           -- Boat Structure
                                         , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
                                           -- Категория Опций
                                         , ObjectLink_MaterialOptions.ChildObjectId        AS MaterialOptionsId
                                           -- Шаблон Boat Structure
                                         , ObjectLink_ColorPattern.ChildObjectId           AS ColorPatternId
                                           -- цвет
                                         , CASE WHEN Object_ReceiptGoodsChild.ValueData <> ''
                                                     THEN Object_ReceiptGoodsChild.ValueData
                                                ELSE COALESCE (ObjectString_Comment_pcp.ValueData, '')
                                           END AS ProdColorName
                                           -- цвет
                                         , COALESCE (ObjectString_Comment_pcp.ValueData, '') AS ProdColorName_pcp

                                    FROM -- цвет
                                         Object AS Object_ReceiptGoodsChild
                                         -- Boat Structure
                                         INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                               ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                              AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                                              -- !!!если это Boat Structure
                                                              AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                                         -- Категория Опций
                                         LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                              ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                                         -- Шаблон сборки узла
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                              ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                         -- узел - что собирается
                                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                              ON ObjectLink_Goods.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                         -- составляющие - из чего собирается
                                         LEFT JOIN ObjectLink AS ObjectLink_Object
                                                              ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                         -- цвет
                                         LEFT JOIN ObjectString AS ObjectString_Comment_pcp
                                                                ON ObjectString_Comment_pcp.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                               AND ObjectString_Comment_pcp.DescId   = zc_ObjectString_ProdColorPattern_Comment()
                                         -- Шаблон Boat Structure
                                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                              ON ObjectLink_ColorPattern.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                             AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                         -- составляющие - из Boat Structure
                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_Goods
                                                              ON ObjectLink_ProdColorPattern_Goods.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                             AND ObjectLink_ProdColorPattern_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()

                                    WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                      AND Object_ReceiptGoodsChild.isErased = FALSE
                                    ORDER BY ObjectLink_ColorPattern.ChildObjectId
                                           , ObjectLink_Goods.ChildObjectId
                                           , COALESCE (ObjectLink_Object.ChildObjectId, -1) DESC
                                           , COALESCE (ObjectLink_MaterialOptions.ChildObjectId, 0)
                                           , Object_ReceiptGoodsChild.ValueData
                                           , COALESCE (ObjectString_Comment_pcp.ValueData, '')
                                   )
           -- в этом списке будем искать
         , tmpReceiptItems_key AS (SELECT tmpReceiptItems.ColorPatternId
                                        , tmpReceiptItems.ObjectId_parent
                                        , STRING_AGG (CASE WHEN tmpReceiptItems.MaterialOptionsId > 0 THEN tmpReceiptItems.MaterialOptionsId :: TVarChar || '-' ELSE '' END
                                                   || CASE WHEN tmpReceiptItems.ObjectId > 0 THEN tmpReceiptItems.ObjectId :: TVarChar ELSE UPPER (tmpReceiptItems.ProdColorName) END, ';') AS Key_Id
                                        , STRING_AGG (CASE WHEN tmpReceiptItems.MaterialOptionsId > 0 THEN lfGet_Object_ValueData_sh (tmpReceiptItems.MaterialOptionsId) || '-' ELSE '' END
                                                   || CASE WHEN tmpReceiptItems.ObjectId > 0 THEN lfGet_Object_ValueData_sh (tmpReceiptItems.ObjectId) ELSE UPPER (tmpReceiptItems.ProdColorName) END, ';') AS Key_Id_text
                                   FROM tmpReceiptItems
                                   GROUP BY tmpReceiptItems.ColorPatternId
                                          , tmpReceiptItems.ObjectId_parent
                                  )
           -- Результат
           SELECT tmpReceiptItems.ReceiptGoodsChildId
                , tmpReceiptItems.ReceiptGoodsId
                , tmpReceiptItems.ObjectId_parent
                , tmpReceiptItems.ObjectId
                , tmpReceiptItems.ObjectId_pcp
                , tmpReceiptItems.ProdColorPatternId
                , tmpReceiptItems.MaterialOptionsId
                , tmpReceiptItems.ColorPatternId
                  -- Цвет - только Примечание
                , tmpReceiptItems.ProdColorName
                  -- Цвет - только Примечание
                , tmpReceiptItems.ProdColorName_pcp
                  --
                , tmpReceiptItems_key.Key_Id
                , tmpReceiptItems_key.Key_Id_text
           FROM tmpReceiptItems
                LEFT JOIN tmpReceiptItems_key ON tmpReceiptItems_key.ColorPatternId  = tmpReceiptItems.ColorPatternId
                                             AND tmpReceiptItems_key.ObjectId_parent = tmpReceiptItems.ObjectId_parent
          ;

         -- Результат - элементы документа
         WITH -- Лодка + Шаблон её сборки
              tmpProduct AS (SELECT vbProductId                                            AS ProductId
                                  , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId
                                  , CASE WHEN ObjectLink_Product_Model.ChildObjectId = ObjectLink_ReceiptProdModel_Model.ChildObjectId THEN ObjectLink_Product_Model.ChildObjectId ELSE 0 END AS ModelId
                                    -- !!!учитываем ли в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                                  , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) AS isBasicConf
                             FROM -- Модель
                                  ObjectLink AS ObjectLink_Product_Model
                                  -- Шаблон сборки модели
                                  LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                       ON ObjectLink_ReceiptProdModel.ObjectId = vbProductId
                                                      AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
                                  -- Еще раз модель, для проверки
                                  LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                                       ON ObjectLink_ReceiptProdModel_Model.ObjectId = ObjectLink_ReceiptProdModel.ChildObjectId
                                                      AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()

                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                                          ON ObjectBoolean_BasicConf.ObjectId = vbProductId
                                                         AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()

                             WHERE ObjectLink_Product_Model.ObjectId = vbProductId
                               AND ObjectLink_Product_Model.DescId   = zc_ObjectLink_Product_Model()
                            )
              -- все Элементы сборки Модели - здесь вся база
            , tmpReceiptProdModelChild_all AS (SELECT tmpProduct.ProductId   AS ProductId
                                                    , tmpProduct.ModelId     AS ModelId
                                                    , tmpProduct.isBasicConf AS isBasicConf
                                                      --
                                                    , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                                      -- !!!замена - оставляем только для Сборки
                                                    , CASE WHEN lpSelect.ObjectId_parent <> COALESCE (lpSelect.ObjectId, 0) THEN lpSelect.ObjectId_parent ELSE 0 END AS ObjectId_parent
                                                      -- либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure /либо ПУСТО
                                                    , lpSelect.ObjectId
                                                      -- значение
                                                    , lpSelect.Value_parent
                                                      -- значение - Элемент
                                                    , lpSelect.Value
                                                      -- цена вх. без НДС - Элемент
                                                    , lpSelect.EKPrice
                                                      -- Boat Structure
                                                    , lpSelect.ProdColorPatternId

                                               FROM lpSelect_Object_ReceiptProdModelChild_detail (inUserId) AS lpSelect
                                                    JOIN tmpProduct ON tmpProduct.ReceiptProdModelId = lpSelect.ReceiptProdModelId
                                              )
            -- существующие элементы ProdOptItems - у Лодки
          , tmpProdOptItems AS (SELECT lpSelect.ProductId
                                     , tmpProduct.ModelId
                                     , lpSelect.ProdOptionsId
                                       -- Boat Structure
                                     , lpSelect.ProdColorPatternId
                                       -- Категория Опций
                                     , lpSelect.MaterialOptionsId
                                       --
                                     , lpSelect.GoodsId
                                       --
                                     , lpSelect.AmountBasis
                                     , lpSelect.Amount
                                     , lpSelect.EKPrice

                                FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= 0
                                                                 , inIsShowAll:= FALSE
                                                                 , inIsErased := FALSE
                                                                 , inIsSale   := TRUE
                                                                 , inSession  := inUserId :: TVarChar
                                                                  ) AS lpSelect
                                     JOIN tmpProduct ON tmpProduct.ProductId = lpSelect.ProductId
                                WHERE lpSelect.MovementId_OrderClient = inMovementId
                               )

         -- существующие элементы ProdColorItems - у Лодки (здесь Boat Structure)
       , tmpProdColorItems AS (SELECT ObjectLink_Product.ChildObjectId          AS ProductId
                                    , ObjectLink_Goods.ChildObjectId            AS GoodsId
                                       -- Boat Structure
                                    , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
                                       -- Категория Опций
                                    , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
                                      -- Цвет - только Примечание (когда нет GoodsId)
                                    , CASE WHEN TRIM (ObjectString_Comment.ValueData) <> ''
                                                THEN TRIM (ObjectString_Comment.ValueData)
                                           ELSE -- нет, т.к. в ReceiptGoodsChild могли изменить
                                                ''
                                                -- TRIM (COALESCE (ObjectString_ProdColorPattern_Comment.ValueData, ''))
                                      END AS ProdColorName

                               FROM Object AS Object_ProdColorItems
                                    -- Лодка
                                    INNER JOIN ObjectLink AS ObjectLink_Product
                                                          ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                         AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
                                    -- Заказ Клиента
                                    INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                           ON ObjectFloat_MovementId_OrderClient.ObjectId = Object_ProdColorItems.Id
                                                          AND ObjectFloat_MovementId_OrderClient.DescId   = zc_ObjectFloat_ProdColorItems_OrderClient()
                                                          AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId

                                    -- здесь цвет, если было изменение для Лодки (когда нет GoodsId)
                                    LEFT JOIN ObjectString AS ObjectString_Comment
                                                           ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                                          AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorItems_Comment()

                                    -- если меняли на другой товар, не тот что в ReceiptGoodsChild
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                                        AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
                                    -- Элемент
                                    LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                         ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                                        AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                    -- Категория Опций
                                    LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                         ON ObjectLink_MaterialOptions.ObjectId = Object_ProdColorItems.Id
                                                        AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ProdColorItems_MaterialOptions()
                                    -- здесь цвет из Boat Structure (когда нет GoodsId)
                                    LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                                           ON ObjectString_ProdColorPattern_Comment.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                          AND ObjectString_ProdColorPattern_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()

                               WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                                 AND Object_ProdColorItems.isErased = FALSE
                              )
                      -- Комплектующие - у Лодки
                    , tmpRes AS (-- 1. Базовая - ВСЯ
                                 SELECT lpSelect.ProductId              AS ProductId
                                      , lpSelect.ModelId                AS ModelId
                                      , TRUE                            AS isBasis
                                        --
                                      , COALESCE (lpSelect.Value_parent, 0)                     AS OperCount_parent
                                      , COALESCE (lpSelect.Value, 0)                            AS OperCount
                                      , COALESCE (tmpProdOptItems.EKPrice, lpSelect.EKPrice, 0) AS OperPrice
                                        --
                                      , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                        --
                                      , lpSelect.ObjectId_parent
                                        -- факт Goods либо ПУСТО
                                      , CASE WHEN tmpProdColorItems.ProdColorPatternId > 0 THEN tmpProdColorItems.GoodsId ELSE lpSelect.ObjectId END AS ObjectId
                                        -- Boat Structure
                                      , lpSelect.ProdColorPatternId
                                        -- Категория Опций
                                      , tmpProdColorItems.MaterialOptionsId
                                        -- только если по факту это опция
                                      , COALESCE (tmpProdOptItems.ProdOptionsId, 0) AS ProdOptionsId

                                        -- Цвет - только Примечание (когда нет GoodsId)
                                      , tmpProdColorItems.ProdColorName

                                 FROM tmpReceiptProdModelChild_all AS lpSelect
                                      LEFT JOIN tmpProdColorItems ON tmpProdColorItems.ProductId          = lpSelect.ProductId
                                                                 AND tmpProdColorItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                      LEFT JOIN tmpProdOptItems ON tmpProdOptItems.ProductId          = lpSelect.ProductId
                                                               AND tmpProdOptItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                                               AND tmpProdOptItems.ProdColorPatternId > 0
                                                               -- ?надо ли это условие?
                                                               AND COALESCE (tmpProdOptItems.MaterialOptionsId, 0) = COALESCE (tmpProdColorItems.MaterialOptionsId, 0)
                                 WHERE -- !!!если учитываем в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                                       lpSelect.isBasicConf = TRUE
                                   OR -- или заполнена ЭТА структура
                                       tmpProdColorItems.ProdColorPatternId > 0

                                UNION ALL
                                 -- 2. Опции
                                 SELECT lpSelect.ProductId              AS ProductId
                                      , lpSelect.ModelId                AS ModelId
                                      , FALSE                           AS isBasis

                                      , 0                               AS OperCount_parent
                                      , lpSelect.Amount                 AS OperCount
                                      , lpSelect.EKPrice                AS OperPrice

                                        --
                                      , 0 AS ReceiptProdModelId
                                      , 0 AS ReceiptProdModelChildId
                                        --
                                      , 0 AS ObjectId_parent
                                        -- Goods
                                      , lpSelect.GoodsId AS ObjectId
                                        --
                                      , lpSelect.ProdColorPatternId
                                        -- Категория Опций
                                      , lpSelect.MaterialOptionsId
                                        --
                                      , lpSelect.ProdOptionsId

                                      , '' AS ProdColorName

                                 FROM tmpProdOptItems AS lpSelect
                                 -- БЕЗ этой Структуры
                                 WHERE COALESCE (lpSelect.ProdColorPatternId, 0) = 0
                                )
         -- Результат
         INSERT INTO _tmpItem_all (ObjectId_parent_find, ObjectId_parent, ObjectId, ObjectDescId, ProdOptionsId, ColorPatternId, ProdColorPatternId, MaterialOptionsId, ProdColorName, OperCount_parent, OperCount, OperPrice)
            SELECT 0 AS ObjectId_parent_find
                 , tmpRes.ObjectId_parent
                 , tmpRes.ObjectId
                 , COALESCE (Object_Object.DescId, 0) AS ObjectDescId
                   --
                 , tmpRes.ProdOptionsId
                   -- Шаблон Boat Structure
                 , ObjectLink_ColorPattern.ChildObjectId AS ColorPatternId
                   -- Boat Structure
                 , tmpRes.ProdColorPatternId
                   -- Категория Опций
                 , tmpRes.MaterialOptionsId
                   -- Цвет - только Примечание (когда нет GoodsId)
                 , tmpRes.ProdColorName
                   --
                 , tmpRes.OperCount_parent
                 , tmpRes.OperCount
                 , tmpRes.OperPrice
            FROM tmpRes
                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpRes.ObjectId
                 -- Шаблон Boat Structure
                 LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                      ON ObjectLink_ColorPattern.ObjectId = tmpRes.ProdColorPatternId
                                     AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
            ;

         -- Результат - элементы документа - получили Key_Id
         UPDATE _tmpItem_all SET Key_Id      = tmp.Key_Id
                               , Key_Id_text = tmp.Key_Id_text
         FROM (SELECT _tmpItem.ColorPatternId
                    , _tmpItem.ObjectId_parent
                    , STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0 THEN _tmpItem.MaterialOptionsId :: TVarChar || '-' ELSE '' END
                               || CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId :: TVarChar ELSE UPPER (_tmpItem.ProdColorName) END, ';') AS Key_Id
                    , STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0 THEN lfGet_Object_ValueData_sh (_tmpItem.MaterialOptionsId) || '-' ELSE '' END
                               || CASE WHEN _tmpItem.ObjectId > 0 THEN lfGet_Object_ValueData_sh (_tmpItem.ObjectId) ELSE UPPER (_tmpItem.ProdColorName) END, ';') AS Key_Id_text
               FROM -- сначала отсортировать
                    (SELECT * FROM _tmpItem_all AS _tmpItem ORDER BY _tmpItem.ColorPatternId, _tmpItem.ObjectId_parent
                                                                   , COALESCE (_tmpItem.ObjectId, -1) DESC
                                                                   , COALESCE (_tmpItem.MaterialOptionsId, 0)
                                                                   , _tmpItem.ProdColorName
                    ) AS _tmpItem
               GROUP BY _tmpItem.ColorPatternId
                      , _tmpItem.ObjectId_parent
              ) AS tmp
         WHERE _tmpItem_all.ColorPatternId  = tmp.ColorPatternId
           AND _tmpItem_all.ObjectId_parent = tmp.ObjectId_parent
        ;

         -- Находим ObjectId_parent для Boat Structure
         UPDATE _tmpItem_all SET ObjectId_parent_find = _tmpItem_find.ObjectId_parent_find
         FROM (WITH -- существующий список
                    tmpList_from AS (SELECT DISTINCT
                                            _tmpItem.ColorPatternId
                                          , _tmpItem.ObjectId_parent
                                          , _tmpItem.Key_Id
                                     FROM _tmpItem_all AS _tmpItem
                                     WHERE _tmpItem.ColorPatternId > 0
                                    )
                      -- в этом списке будем искать
                    , tmpList_to AS (SELECT DISTINCT
                                            _tmpReceiptItems_Key.ColorPatternId
                                          , _tmpReceiptItems_Key.ObjectId_parent
                                          , _tmpReceiptItems_Key.Key_Id
                                     FROM _tmpReceiptItems_Key
                                    )
               -- Результат
               SELECT tmpList_from.ColorPatternId
                    , tmpList_from.ObjectId_parent
                      -- здесь нашли узел с такой структурой
                    , COALESCE (tmpList_to.ObjectId_parent, 0) AS ObjectId_parent_find
               FROM tmpList_from
                    LEFT JOIN tmpList_to ON tmpList_to.ColorPatternId = tmpList_from.ColorPatternId
                                        AND tmpList_to.Key_Id         = tmpList_from.Key_Id
              ) AS _tmpItem_find
         WHERE _tmpItem_all.ProdColorPatternId > 0
           AND _tmpItem_all.ColorPatternId     = _tmpItem_find.ColorPatternId
           AND _tmpItem_all.ObjectId_parent    = _tmpItem_find.ObjectId_parent
        ;


        -- !!!Временно - заменим остальным ObjectId_parent, если не Boat Structure - хотя надо будет все составляющие перезалить!!!
        UPDATE _tmpItem_all SET ObjectId_parent_find = tmp.ObjectId_parent_find
        FROM (SELECT DISTINCT _tmpItem.ObjectId_parent, _tmpItem.ObjectId_parent_find FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find > 0) AS tmp
        WHERE _tmpItem_all.ObjectId_parent_find = 0
          AND _tmpItem_all.ObjectId_parent      = tmp.ObjectId_parent
         ;


        -- Проверка
        IF EXISTS (SELECT 1
                   FROM _tmpItem_all AS _tmpItem
                       JOIN _tmpItem_all AS _tmpItem_find
                                         ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                         AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                   WHERE _tmpItem.ObjectId_parent > 0
                  )
        --AND 1=0
        THEN
            RAISE EXCEPTION 'Ошибка-1.Не у всех элементов одинаковый ObjectId_parent_find.<%> <%> <%> <%>'
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent)
                              FROM _tmpItem_all AS _tmpItem
                                  JOIN _tmpItem_all AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent_find)
                              FROM _tmpItem_all AS _tmpItem
                                  JOIN _tmpItem_all AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent_find)
                              FROM _tmpItem_all AS _tmpItem
                                  JOIN _tmpItem_all AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find DESC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT COUNT (*)
                              FROM _tmpItem_all AS _tmpItem
                              WHERE _tmpItem.ObjectId_parent IN (SELECT _tmpItem.ObjectId_parent
                                                                 FROM _tmpItem_all AS _tmpItem
                                                                     JOIN _tmpItem_all AS _tmpItem_find
                                                                                       ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                                                       AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                                                                 WHERE _tmpItem.ObjectId_parent > 0
                                                                 ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                                                                 LIMIT 1)
                             )
                            ;
        END IF;


/*
        RAISE EXCEPTION 'Ошибка.<%>  <%>'
        , (select count(*) from _tmpReceiptItems_Key where _tmpReceiptItems_Key.Key_Id = '251200-22573;Schwarz;Taupe')
        , (select count(*) from _tmpItem_all         where _tmpItem_all.Key_Id         = '251200-22573;Schwarz;Taupe')
         ;
*/


        -- Пробуем создать
        INSERT INTO _tmpReceiptItems_new (ReceiptGoodsChildId, ReceiptGoodsId
                                        , ObjectId_parent_old, ObjectId_parent, ObjectId, ProdColorPatternId
                                        , MaterialOptionsId, ColorPatternId
                                        , ProdColorName
                                        , Key_Id, Key_Id_text
                                         )
           SELECT 0 AS ReceiptGoodsChildId
                , 0 AS ReceiptGoodsId
                  -- Предыдущий узел
                , _tmpItem_all.ObjectId_parent AS ObjectId_parent_old
                  -- Создадим узел
                , 0 AS ObjectId_parent
                  -- Комплектующие, из которых делается узел
                , _tmpItem_all.ObjectId

                  -- Комплектующие - из Boat Structure
                  --, _tmpItem_all.ObjectId_pcp

                  -- Boat Structure - не меняется
                , _tmpItem_all.ProdColorPatternId
                  -- Категория Опций - из которых делается узел
                , _tmpItem_all.MaterialOptionsId
                  --  Шаблон Boat Structure
                , _tmpItem_all.ColorPatternId
                  -- Цвет из которых делается узел - только Примечание (когда нет GoodsId)
                , _tmpItem_all.ProdColorName

                  -- Цвет - из Boat Structure
                  -- , _tmpItem_all.ProdColorName_pcp

                  --
                , _tmpItem_all.Key_Id, _tmpItem_all.Key_Id_text

           FROM _tmpItem_all
           WHERE _tmpItem_all.ObjectId_parent = 0
          ;

        -- Создаем новый Узел
        UPDATE _tmpReceiptItems_new SET ObjectId_parent = tmpGoods.GoodsId
        FROM (WITH tmpColor AS (SELECT _tmpReceiptItems_new.ObjectId_parent_old AS GoodsId_parent_old
                                     , _tmpReceiptItems_new.ObjectId            AS GoodsId
                                     , _tmpReceiptItems_new.ProdColorPatternId  AS ProdColorPatternId
                                     , _tmpReceiptItems_new.ProdColorName       AS ProdColorName
                                     , Object_ProdColor_goods.Id                AS ProdColorId_goods
                                     , Object_ProdColor_goods.ValueData         AS ProdColorName_goods
                                       -- № п/п
                                     , ROW_NUMBER() OVER (PARTITION BY _tmpReceiptItems_new.ObjectId_parent_old ORDER BY Object_ProdColorPattern.ObjectCode ASC) AS Ord

                                FROM _tmpReceiptItems_new
                                     -- Boat Structure
                                     LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = _tmpReceiptItems_new.ProdColorPatternId
                                     --
                                     LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                          ON ObjectLink_Goods_ProdColor.ObjectId = _tmpReceiptItems_new.ObjectId
                                                         AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                     LEFT JOIN Object AS Object_ProdColor_goods ON Object_ProdColor_goods.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                               )
                 , tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent_old AS GoodsId_parent_old, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT tmpGoods.GoodsId_parent_old
                   , gpInsertUpdate_Object_Goods (ioId                     := 0
                                                , inCode                   := (SELECT MIN (Object.ObjectCode) - 1 FROM Object WHERE Object.DescId = zc_Object_Goods())
                                                                              -- <(-3835)AGL-280-*ICE WHITE - *NEPTUNE GREY(Hypalon)>.
                                                , inName                   := 'AGL-' || Object_Model.ValueData
                                                                           ||   '-*' || tmpColor_1.ProdColorName_goods
                                                                           || ' - *' || tmpColor_2.ProdColorName_goods
                                                                                     || CASE WHEN tmpColor_3.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp THEN ' '  || tmpColor_3.ProdColorName ELSE '' END
                                                , inArticle                := 'AGL-' || Object_Model.ValueData
                                                                           ||   '-*' || tmpColor_1.ProdColorName_goods
                                                                           || ' - *' || tmpColor_2.ProdColorName_goods
                                                                                     || CASE WHEN tmpColor_3.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp THEN ' '  || tmpColor_3.ProdColorName ELSE '' END
                                                , inArticleVergl           := ''
                                                , inEAN                    := ''
                                                , inASIN                   := ''
                                                , inMatchCode              := ''
                                                , inFeeNumber              := ObjectString_FeeNumber.ValueData
                                                , inComment                := ObjectString_Comment.ValueData
                                                , inIsArc                  := FALSE
                                                , inFeet                   := ObjectFloat_Feet.ValueData
                                                , inMetres                 := ObjectFloat_Metres.ValueData
                                                , inAmountMin              := ObjectFloat_Min.ValueData
                                                , inAmountRefer            := ObjectFloat_Refer.ValueData
                                                , inEKPrice                := ObjectFloat_EKPrice.ValueData
                                                , inEmpfPrice              := ObjectFloat_EmpfPrice.ValueData
                                                , inGoodsGroupId           := ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                , inMeasureId              := ObjectLink_Goods_Measure.ChildObjectId
                                                , inGoodsTagId             := ObjectLink_Goods_GoodsTag.ChildObjectId
                                                , inGoodsTypeId            := ObjectLink_Goods_GoodsType.ChildObjectId
                                                , inGoodsSizeId            := ObjectLink_Goods_GoodsSize.ChildObjectId
                                                , inProdColorId            := tmpColor_1.ProdColorId_goods
                                                , inPartnerId              := ObjectLink_Goods_Partner.ChildObjectId
                                                , inUnitId                 := ObjectLink_Goods_Unit.ChildObjectId
                                                , inDiscountPartnerId      := ObjectLink_Goods_DiscountPartner.ChildObjectId
                                                , inTaxKindId              := ObjectLink_Goods_TaxKind.ChildObjectId
                                                , inEngineId               := NULL
                                                , inSession                := inUserId :: TVarChar
                                                 ) AS GoodsId
              FROM tmpGoods
                   LEFT JOIN tmpColor AS tmpColor_1 ON tmpColor_1.GoodsId_parent_old = tmpGoods.GoodsId_parent_old
                                                   AND tmpColor_1.Ord                = 1
                   LEFT JOIN tmpColor AS tmpColor_2 ON tmpColor_2.GoodsId_parent_old = tmpGoods.GoodsId_parent_old
                                                   AND tmpColor_2.Ord                = 2
                   LEFT JOIN tmpColor AS tmpColor_3 ON tmpColor_3.GoodsId_parent_old = tmpGoods.GoodsId_parent_old
                                                   AND tmpColor_3.Ord                = 3

                   LEFT JOIN _tmpReceiptItems_Key ON _tmpReceiptItems_Key.ObjectId_parent    = tmpGoods.GoodsId_parent_old
                                                 AND _tmpReceiptItems_Key.ProdColorPatternId = tmpColor_3.ProdColorPatternId

                   LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                        ON ObjectLink_ColorPattern_Model.ObjectId = tmpGoods.ColorPatternId
                                       AND ObjectLink_ColorPattern_Model.DescId   = zc_ObjectLink_ColorPattern_Model()
                   LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_ColorPattern_Model.ChildObjectId

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ColorPattern_Model.ChildObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                        ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                        ON ObjectLink_Goods_GoodsType.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                        ON ObjectLink_Goods_GoodsSize.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()

                   LEFT JOIN ObjectString AS ObjectString_Comment
                                          ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                         AND ObjectString_Comment.DescId   = zc_ObjectString_Goods_Comment()
                   LEFT JOIN ObjectString AS ObjectString_FeeNumber
                                          ON ObjectString_FeeNumber.ObjectId = Object_Goods.Id
                                         AND ObjectString_FeeNumber.DescId   = zc_ObjectString_Goods_FeeNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                        ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                        ON ObjectLink_Goods_Unit.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Unit.DescId = zc_ObjectLink_Goods_Unit()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_DiscountPartner
                                        ON ObjectLink_Goods_DiscountPartner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_DiscountPartner.DescId = zc_ObjectLink_Goods_DiscountPartner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                        ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                         ON ObjectFloat_Min.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Min.DescId   = zc_ObjectFloat_Goods_Min()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Refer
                                         ON ObjectFloat_Refer.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Refer.DescId   = zc_ObjectFloat_Goods_Refer()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                         ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                         ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Feet
                                         ON ObjectFloat_Feet.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Feet.DescId   = zc_ObjectFloat_Goods_Feet()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Metres
                                         ON ObjectFloat_Metres.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Metres.DescId   = zc_ObjectFloat_Goods_Metres()

              WHERE ObjectString_Comment.ValueData ILIKE 'Hypalon'

             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent_old = tmpGoods.GoodsId_parent_old
       ;

        -- Создаем новый ReceiptGoods
        UPDATE _tmpReceiptItems_new SET ReceiptGoodsId = tmpGoods.ReceiptGoodsId
        FROM (WITH tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent AS GoodsId_parent, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT tmpGoods.GoodsId_parent
                   , gpInsertUpdate_Object_ReceiptGoods (ioId               := 0
                                                       , inCode             := 0
                                                       , inName             := ''
                                                       , inColorPatternId   := tmpGoods.ColorPatternId
                                                       , inGoodsId          := tmpGoods.GoodsId_parent
                                                       , inisMain           := TRUE
                                                       , inUserCode         := (ABS (Object_Goods.ObjectCode) :: Integer) :: TVarChar
                                                       , inComment          := ''
                                                       , inSession          := inUserId :: TVarChar
                                                        ) AS ReceiptGoodsId
              FROM tmpGoods
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId_parent
             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent = tmpGoods.GoodsId_parent
       ;
                 
        -- Создаем новый ReceiptGoodsChild
        UPDATE _tmpReceiptItems_new SET ReceiptGoodsChildId = tmpGoods.ReceiptGoodsChildId
        FROM (WITH tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent AS GoodsId_parent, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT tmpGoods.GoodsId_parent
                   , gpInsertUpdate_Object_ReceiptGoodsChild (ioId                  := 0
                                                            , inComment             := CASE WHEN COALESCE (_tmpReceiptItems_new.ObjectId, 0) = 0
                                                                                            THEN CASE WHEN 
                                                                                                 END
                                                                                       END
                                                            , inReceiptGoodsId      := _tmpReceiptItems_new.ReceiptGoodsId
                                                            , inObjectId            := _tmpReceiptItems_new.ObjectId
                                                            , inProdColorPatternId  := _tmpReceiptItems_new.ProdColorPatternId
                                                            , inMaterialOptionsId   := _tmpReceiptItems_new.MaterialOptionsId
                                                            , ioValue               := 1
                                                            , ioValue_service       := 0
                                                            , inIsEnabled           := TRUE
                                                            , inSession             := inUserId :: TVarChar
                                                             ) AS ReceiptGoodsChildId
              FROM _tmpReceiptItems_new
                   LEFT JOIN _tmpReceiptItems_Key ON _tmpReceiptItems_Key.ObjectId_parent    = _tmpReceiptItems_new.ObjectId_parent_old
                                                 AND _tmpReceiptItems_Key.ProdColorPatternId = _tmpReceiptItems_new.ProdColorPatternId
             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent = tmpGoods.GoodsId_parent
       ;

        -- Проверка
        IF EXISTS (SELECT 1 FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0)
        --AND 1=0
        THEN
            RAISE EXCEPTION 'Ошибка.Не найден аналог для%<%>.%Для такой структуры: <%>%Всего не найдено <%> шт.'
                                        , CHR (13)
                                        , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent) || COALESCE ('(' || OS.ValueData || ')', '')
                                           FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0
                                                ) AS _tmpItem
                                                LEFT JOIN ObjectString AS OS ON OS.ObjectId = _tmpItem.ObjectId_parent AND OS.DescId = zc_ObjectString_Goods_Comment()
                                           LIMIT 1)
                                        , CHR (13)
                                        , (SELECT lfGet_Object_ValueData (_tmpItem.ColorPatternId)
                                                || ' : '
                                                || CHR (13)
                                                || CHR (13)
                                                || _tmpItem.Key_Id
                                                || CHR (13)
                                                || CHR (13)
                                                || STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0
                                                                    THEN lfGet_Object_ValueData_sh (_tmpItem.MaterialOptionsId) || ' - '
                                                                    ELSE ''
                                                               END
                                                            || CASE WHEN _tmpItem.ObjectId > 0
                                                                    THEN COALESCE (Object_ProdColor.ValueData, lfGet_Object_ValueData_sh (_tmpItem.ObjectId))
                                                                    ELSE _tmpItem.ProdColorName
                                                               END, CHR (13)
                                                              ) AS Key_Id

                                           FROM -- сначала отсортировать
                                                (SELECT * FROM _tmpItem_all AS _tmpItem
                                                 WHERE _tmpItem.ObjectId_parent = (SELECT MAX (_tmpItem.ObjectId_parent) FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0)
                                                   AND _tmpItem.ProdColorPatternId > 0
                                                 ORDER BY _tmpItem.ColorPatternId
                                                        , COALESCE (_tmpItem.ObjectId, -1) DESC, _tmpItem.ProdColorName
                                                ) AS _tmpItem
                                                LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                                     ON ObjectLink_Goods_ProdColor.ObjectId = _tmpItem.ObjectId
                                                                    AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                                LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                                           GROUP BY _tmpItem.ColorPatternId
                                                  , _tmpItem.Key_Id
                                          )
                                        , CHR (13)
                                        , (SELECT COUNT(*) FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0) AS _tmpItem);
        END IF;


        -- сначала все удалили
        PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
        ;

        -- 1. формируем первый раз - НЕТ ParentId -  Количество шаблон сборки
        PERFORM lpInsertUpdate_MI_OrderClient_Child (ioId                  := 0
                                                   , inParentId            := NULL
                                                   , inMovementId          := inMovementId
                                                   , inPartionId           := NULL
                                                   , inObjectId            := CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId ELSE _tmpItem.ProdColorPatternId END
                                                   , inGoodsId             := _tmpItem.ObjectId_parent
                                                   , inGoodsId_Basis       := _tmpItem.ObjectId_Basis
                                                   , inAmountBasis         := _tmpItem.OperCount
                                                   , inAmount              := CASE WHEN _tmpItem.ObjectDescId = zc_Object_ReceiptService() THEN _tmpItem.OperCount ELSE 0 END
                                                   , inAmountPartner       := 0 -- !!!временно!!!
                                                                              -- CASE WHEN _tmpItem.ObjectId_parent > 0 THEN 0 ELSE _tmpItem.OperCount END
                                                   , inOperPrice           := _tmpItem.OperPrice
                                                   , inCountForPrice       := 1
                                                   , inUnitId              := NULL
                                                   , inPartnerId           := OL_Goods_Partner.ChildObjectId
                                                   , inColorPatternId      := _tmpItem.ColorPatternId
                                                   , inProdColorPatternId  := _tmpItem.ProdColorPatternId
                                                   , inProdOptionsId       := _tmpItem.ProdOptionsId
                                                   , inUserId              := inUserId
                                                    )
        FROM (-- Собрали Узлы
              SELECT 0 AS ObjectId_parent
                   , CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find ELSE _tmpItem.ObjectId_parent END AS ObjectId
                     -- если была замена, какой узел был в ReceiptProdModel
                   , CASE WHEN _tmpItem.ObjectId_parent_find <> _tmpItem.ObjectId_parent THEN _tmpItem.ObjectId_parent ELSE 0 END AS ObjectId_Basis
                   , _tmpItem.OperCount_parent AS OperCount
                   , SUM (_tmpItem.OperCount * _tmpItem.OperPrice) / CASE WHEN _tmpItem.OperCount_parent > 0 THEN _tmpItem.OperCount_parent ELSE 1 END AS OperPrice
                   , 0 AS ColorPatternId
                   , 0 AS ProdColorPatternId
                   , CASE WHEN _tmpItem.ProdColorPatternId > 0 THEN 0 ELSE _tmpItem.ProdOptionsId END AS ProdOptionsId
                   , 0 AS ObjectDescId
              FROM _tmpItem_all AS _tmpItem
                   -- цена для Узел
                 --LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                 --                      ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                 --                     AND ObjectFloat_EKPrice.ObjectId = CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find
                 --                                                             ELSE _tmpItem.ObjectId_parent
                 --                                                        END
              WHERE _tmpItem.ObjectId_parent <> 0
              GROUP BY CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find ELSE _tmpItem.ObjectId_parent END
                     , CASE WHEN _tmpItem.ObjectId_parent_find <> _tmpItem.ObjectId_parent THEN _tmpItem.ObjectId_parent ELSE 0 END
                     , _tmpItem.OperCount_parent
                     , CASE WHEN _tmpItem.ProdColorPatternId > 0 THEN 0 ELSE _tmpItem.ProdOptionsId END
             UNION
              -- Все Составляющие
              SELECT DISTINCT
                     CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find ELSE _tmpItem.ObjectId_parent END AS ObjectId_parent
                     --
                   , _tmpItem.ObjectId
                     -- если была замена, какой узел был в ReceiptProdModel
                   , CASE WHEN _tmpItem.ObjectId_parent_find <> _tmpItem.ObjectId_parent THEN _tmpItem.ObjectId_parent ELSE 0 END AS ObjectId_Basis
                     --
                   , _tmpItem.OperCount
                   , _tmpItem.OperPrice
                   , _tmpItem.ColorPatternId
                   , _tmpItem.ProdColorPatternId
                   , _tmpItem.ProdOptionsId
                   , _tmpItem.ObjectDescId
              FROM _tmpItem_all AS _tmpItem
             ) AS _tmpItem
             LEFT JOIN ObjectLink AS OL_Goods_Partner
                                  ON OL_Goods_Partner.ObjectId = _tmpItem.ObjectId
                                 AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()
            ;



        -- !!!2.элементы документа, по партиям!!!
        WITH -- только ObjectId
             tmpItem AS   (SELECT MovementItem.Id                        AS MovementItemId
                                , MILinkObject_Partner.ObjectId          AS PartnerId

                                , MovementItem.ObjectId                  AS ObjectId
                                , MILinkObject_ProdColorPattern.ObjectId AS ProdColorPatternId

                                , MIFloat_AmountBasis.ValueData          AS AmountBasis
                                , MIFloat_OperPrice.ValueData            AS OperPrice

                                , COALESCE (Object_Object.DescId, 0)     AS ObjectDescId

                           FROM MovementItem
                                LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                 ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                 ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                                 ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountBasis
                                                            ON MIFloat_AmountBasis.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountBasis.DescId         = zc_MIFloat_AmountBasis()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = FALSE
                             -- !!! без этой структуры !!!
                             AND COALESCE (MILinkObject_Goods.ObjectId, 0) = 0
                          )
                -- существующие резервы - в заказах Клиентов
              , tmpOrderClient AS (SELECT MovementItem.PartionId     AS PartionId
                                        , MILinkObject_Unit.ObjectId AS UnitId
                                        , SUM (MovementItem.Amount)  AS Amount
                                   FROM Movement
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Child()
                                                               AND MovementItem.isErased   = FALSE
                                                               -- ограничили товарами
                                                               AND MovementItem.ObjectId IN (SELECT DISTINCT tmpItem.ObjectId FROM tmpItem)
                                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                        AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                   WHERE Movement.DescId   = zc_Movement_OrderClient()
                                     -- !!!проведенные!!!
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   GROUP BY MovementItem.PartionId
                                          , MILinkObject_Unit.ObjectId
                                  )
                -- перемещения под резерв - факт что пришло
              , tmpSend AS (SELECT MovementItem.PartionId     AS PartionId
                                 , MLO_To.ObjectId            AS UnitId
                                 , SUM (MovementItem.Amount)  AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                                        -- ограничили товарами
                                                        AND MovementItem.ObjectId IN (SELECT DISTINCT tmpItem.ObjectId FROM tmpItem)
                                 -- zc_MI_Master не удален
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                                 LEFT JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = MovementItem.MovementId
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                            WHERE Movement.DescId   = zc_Movement_Send()
                              -- !!!проведенные!!!
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              -- !!!test!!!
                              -- AND 1=0
                            GROUP BY MovementItem.PartionId
                                   , MLO_To.ObjectId
                           )
            -- из остатка отняли резервы
          , tmpContainer_all AS (SELECT Container.Id
                                      , Container.PartionId
                                      , Container.ObjectId
                                      , Container.WhereObjectId
                                      , Container.Amount - COALESCE (tmpOrderClient.Amount, 0) - COALESCE (tmpSend.Amount, 0) AS Amount
                                 FROM Container
                                      -- резервы - в заказах Клиентов
                                      LEFT JOIN tmpOrderClient ON tmpOrderClient.PartionId = Container.PartionId
                                                              AND tmpOrderClient.UnitId    = Container.WhereObjectId
                                      -- перемещения под резерв - Приход
                                      LEFT JOIN tmpSend ON tmpSend.PartionId = Container.PartionId
                                                       AND tmpSend.UnitId    = Container.WhereObjectId
                                 WHERE Container.DescId = zc_Container_Count()
                                   AND Container.Amount - COALESCE (tmpOrderClient.Amount, 0) - COALESCE (tmpSend.Amount, 0) > 0
                                   -- ограничили товарами
                                   AND Container.ObjectId IN (SELECT tmpItem.ObjectId FROM tmpItem)
                                   -- !!! временно для отладки
                                   AND NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())

                                )
                -- накопительный список - разбивка по партиям
              , tmpContainer AS (SELECT Container.Id             AS ContainerId
                                      , Container.PartionId      AS PartionId
                                      , Container.ObjectId       AS ObjectId
                                      , Container.WhereObjectId  AS WhereObjectId
                                      , Container.Amount         AS ContainerAmount
                                      , tmpItem.AmountBasis      AS OperCount
                                        -- накопительное кол-во
                                      , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId
                                                                     ORDER BY -- Сначала резерв
                                                                              CASE WHEN Container.WhereObjectId = vbUnitId_To THEN 0 ELSE 1 END
                                                                            , Object_PartionGoods.OperDate ASC
                                                                            , Container.Id ASC
                                                                    ) AS ContainerAmountSUM
                                 FROM tmpContainer_all AS Container
                                      LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                      LEFT JOIN tmpItem ON tmpItem.ObjectId = Container.ObjectId
                                )
                -- разбили по партиям
              , tmpRes_partion AS
                       (SELECT DD.ContainerId
                             , DD.PartionId
                             , DD.ObjectId
                             , CASE WHEN DD.OperCount - DD.ContainerAmountSUM > 0
                                         THEN DD.ContainerAmount
                                    ELSE DD.OperCount - DD.ContainerAmountSUM + DD.ContainerAmount
                               END AS OperCount
                        FROM (SELECT * FROM tmpContainer) AS DD
                        WHERE DD.OperCount - (DD.ContainerAmountSUM - DD.ContainerAmount) > 0
                       )
         -- Результат
         INSERT INTO _tmpItem (MovementItemId, ContainerId_Goods, ObjectId, PartionId, ProdColorPatternId, OperCount, OperCountPartner, OperPricePartner, ObjectDescId)
            -- 0.1. Остатки
            SELECT tmpItem.MovementItemId
                   -- нашли!!
                 , tmpRes_partion.ContainerId
                   --
                 , tmpItem.ObjectId
                   -- нашли!!
                 , tmpRes_partion.PartionId
                   --
                 , tmpItem.ProdColorPatternId
                   -- нашли!!
                 , COALESCE (tmpRes_partion.OperCount, 0) AS OperCount
                   --
                 , 0 AS OperCountPartner

                   -- нашли, хотя для остатка - информативно
                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0) AS OperPricePartner

                 , tmpItem.ObjectDescId

            FROM tmpItem
                 INNER JOIN tmpRes_partion ON tmpRes_partion.ObjectId = tmpItem.ObjectId
                 -- цена
                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                       ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                      AND ObjectFloat_EKPrice.ObjectId = tmpItem.ObjectId

           UNION ALL
            -- 0.2. Заказ
            SELECT tmpItem.MovementItemId
                   --
                 , 0 AS ContainerId_Goods
                   --
                 , tmpItem.ObjectId
                   --
                 , 0 AS PartionId
                   --
                 , tmpItem.ProdColorPatternId
                   --
                 , 0 AS OperCount

                 , -- для заказа оставили сколько не хватает
                   tmpItem.AmountBasis - COALESCE (tmpRes_partion_total.OperCount, 0) AS OperCountPartner

                   -- нашли
                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0) AS OperPricePartner

                 , tmpItem.ObjectDescId

            FROM tmpItem
                 -- цена
                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                       ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                      AND ObjectFloat_EKPrice.ObjectId = tmpItem.ObjectId

                 -- итого по партиям, а сколько не хватает - заказ у поставщика
                 LEFT JOIN (SELECT tmpRes_partion.ObjectId, SUM (tmpRes_partion.OperCount) AS OperCount FROM tmpRes_partion GROUP BY tmpRes_partion.ObjectId
                           ) AS tmpRes_partion_total ON tmpRes_partion_total.ObjectId = tmpItem.ObjectId
            -- если нужен заказ
            WHERE tmpItem.AmountBasis - COALESCE (tmpRes_partion_total.OperCount, 0) > 0
            ;


         -- Заказ Поставщику
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPricePartner(), _tmpItem.MovementItemId, _tmpItem.OperPricePartner)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(),    _tmpItem.MovementItemId, _tmpItem.OperCountPartner)
         FROM _tmpItem
         WHERE _tmpItem.ContainerId_Goods = 0
           AND _tmpItem.ObjectDescId      <> zc_Object_ReceiptService()
        ;


         -- формируем второй раз - есть ParentId - здесть только резерв с PartionId
         PERFORM lpInsertUpdate_MI_OrderClient_Child (ioId                  := 0
                                                    , inParentId            := _tmpItem.MovementItemId
                                                    , inMovementId          := inMovementId
                                                    , inPartionId           := _tmpItem.PartionId
                                                    , inObjectId            := _tmpItem.ObjectId
                                                    , inGoodsId             := NULL
                                                    , inGoodsId_Basis       := NULL
                                                    , inAmountBasis         := 0
                                                    , inAmount              := _tmpItem.OperCount
                                                    , inAmountPartner       := 0
                                                    , inOperPrice           := _tmpItem.OperPricePartner -- информативно
                                                    , inCountForPrice       := 1
                                                    , inUnitId              := CLO_Unit.ObjectId
                                                    , inPartnerId           := COALESCE ((SELECT Object_PartionGoods.FromId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = _tmpItem.PartionId ), 0)
                                                    , inColorPatternId      := NULL
                                                    , inProdColorPatternId  := NULL
                                                    , inProdOptionsId       := NULL
                                                    , inUserId              := inUserId
                                                     )
         FROM _tmpItem
              LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItem.ContainerId_Goods AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
         WHERE _tmpItem.ContainerId_Goods > 0;



         -- !!! временно для отладки
         IF NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())
         THEN
             -- находим партию с Engine Nr
             SELECT MIN (_tmpItem.PartionId), MAX (_tmpItem.PartionId)
                    INTO vbPartionId_1, vbPartionId_2
             FROM _tmpItem
                  INNER JOIN ObjectLink AS ObjectLink_Goods_Engine
                                        ON ObjectLink_Goods_Engine.ObjectId = _tmpItem.ObjectId
                                       AND ObjectLink_Goods_Engine.DescId   = zc_ObjectLink_Goods_Engine()
                                       -- !!! установлено это св-во
                                       AND ObjectLink_Goods_Engine.ChildObjectId > 0
                  INNER JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = _tmpItem.PartionId
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                               AND MIString_PartNumber.ValueData      <> ''
                                              ;

             -- Проверка
             IF COALESCE (vbPartionId_1, 0) <> COALESCE (vbPartionId_2, 0)
             THEN
                 RAISE EXCEPTION 'Ошибка.Найдено больше одного Engine Nr. <%> + <%>.'
                               , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                               , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_2 AND MIS.DescId = zc_MIString_PartNumber())
                             ;
             END IF;
             -- Проверка
             IF COALESCE (vbPartionId_1, 0) = 0
                AND NOT EXISTS (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
             THEN
                 RAISE EXCEPTION 'Ошибка.Не найдена партия с Engine Nr';
             END IF;
             -- Проверка
             IF COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
                        , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber()))
                <> (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                AND vbPartionId_1 > 0
                AND 1=0
             THEN
                 RAISE EXCEPTION 'Ошибка.У Лодки уже установлен Engine Nr = <%>. Нельзя установить новый Engine Nr = <%>'
                               , (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
                               , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                                ;
             END IF;


             -- сохранили у Лодки партию с Engine Nr
             IF COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> ''), '')
                <> (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                AND vbPartionId_1 > 0
             THEN
                 -- сохранили
                 PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), vbProductId, (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber()));

                 -- сохранили протокол
                 PERFORM lpInsert_ObjectProtocol (vbProductId, inUserId);
             END IF;

         END IF;

     END IF; -- !!!Только если нужен пересчет!!!

/*
    -- Результат
    RETURN QUERY
       SELECT 0 :: Integer AS MovementItemId
            , _tmpItem.ContainerId_Goods
            , _tmpItem.ObjectId_parent
            , _tmpItem.ObjectId_parent_find
            , _tmpItem.ObjectId
            , 0 :: Integer AS PartionId
            , _tmpItem.ProdOptionsId
            , _tmpItem.ColorPatternId
            , _tmpItem.ProdColorPatternId
            , _tmpItem.ProdColorName
            , _tmpItem.OperCount
            , _tmpItem.OperCount
            , _tmpItem.OperPrice
        FROM _tmpItem_all AS _tmpItem
       ;*/

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_OrderClient()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_OrderClient(inMovementId := 647 , inStatusCode := 2 , inIsChild_Recalc := 'True' ,  inSession := '5');
