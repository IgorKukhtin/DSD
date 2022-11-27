-- Function: lpComplete_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderClient(
    IN inMovementId        Integer  , -- ключ Документа
    IN inIsChild_Recalc    Boolean  , -- Пересчет Комплектующих
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbProductId          Integer;
  DECLARE vbReceiptProdModelId Integer;
  DECLARE vbModelId            Integer;
  DECLARE vbIsBasicConf        Boolean;

  DECLARE vbClientId_From  Integer;
  DECLARE vbUnitId_To      Integer;

  DECLARE vbPartionId_1    Integer;
  DECLARE vbPartionId_2    Integer;
BEGIN
     -- нашли Лодку
     vbProductId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product());

     -- Параметры из Лодки - Шаблон её сборки
     SELECT COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId
            -- если "правильно" выбран ReceiptProdModel, т.е. модели совпадают
          , CASE WHEN ObjectLink_Product_Model.ChildObjectId = ObjectLink_ReceiptProdModel_Model.ChildObjectId THEN ObjectLink_Product_Model.ChildObjectId ELSE 0 END AS ModelId
            -- !!!учитываем ли в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
          , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) AS isBasicConf
            --
            INTO vbReceiptProdModelId, vbModelId, vbIsBasicConf
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
       AND ObjectLink_Product_Model.DescId   = zc_ObjectLink_Product_Model();
     

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

     -- Проверка - Boat Structure
     IF EXISTS (SELECT ObjectLink_ProdColorPattern.ChildObjectId
                FROM Object AS Object_ProdColorItems
                     -- Лодка
                     INNER JOIN ObjectLink AS ObjectLink_Product
                                           ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                          AND ObjectLink_Product.ChildObjectId = vbProductId
                     -- Заказ Клиента
                     INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                            ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                           AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                           AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId
                     -- Элемент
                     INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                          AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                  AND Object_ProdColorItems.isErased = FALSE
                  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                GROUP BY ObjectLink_ProdColorPattern.ChildObjectId
                HAVING COUNT(*) > 1
               )
     THEN
         RAISE EXCEPTION 'Проверка-1.Элемент Boat Structure = <%> не может дублироваться.'
             , (SELECT lfGet_Object_ValueData_pcp (ObjectLink_ProdColorPattern.ChildObjectId)
                FROM Object AS Object_ProdColorItems
                     -- Лодка
                     INNER JOIN ObjectLink AS ObjectLink_Product
                                           ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                          AND ObjectLink_Product.ChildObjectId = vbProductId
                     -- Заказ Клиента
                     INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                            ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                           AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                           AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId
                     -- Элемент
                     INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                          AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                  AND Object_ProdColorItems.isErased = FALSE
                  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                GROUP BY ObjectLink_ProdColorPattern.ChildObjectId
                HAVING COUNT(*) > 1
               )
               ;
               
     END IF;

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


     -- RAISE EXCEPTION 'Ошибка. <%>.', inIsChild_Recalc;

     -- !!!Только если нужен пересчет!!!
     -- !!!еще добавить если в заказе только запчасти!!!
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product() AND MLO.ObjectId > 0)
        AND (inIsChild_Recalc = TRUE
          OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
            )
     THEN
         -- таблица - элементы документа, Шаблон сборка Лодки
         CREATE TEMP TABLE _tmpItem_Child (MovementItemId Integer
                                         , ObjectId_parent_find Integer, ObjectId_parent Integer, ObjectDescId Integer
                                         , ProdOptionsId Integer
                                           --
                                         , OperCount TFloat
                                         , OperPrice TFloat
                                           --
                                         , Key_Id Text, Key_Id_text Text
                                          ) ON COMMIT DROP;
        -- таблица - элементы документа, сборка узлов
        CREATE TEMP TABLE _tmpItem_Detail (MovementItemId Integer
                                         , ObjectId_parent Integer, ObjectId Integer, ObjectDescId Integer
                                         , ProdOptionsId Integer
                                         , ColorPatternId Integer
                                          -- Boat Structure
                                         , ProdColorPatternId Integer
                                           -- Категория Опций
                                         , MaterialOptionsId Integer
                                           --
                                         , ReceiptLevelId Integer
                                           --
                                         , GoodsId_child Integer
                                           -- Цвет - только Примечание
                                         , ProdColorName TVarChar
                                           --
                                         , OperCount TFloat
                                         , OperPrice TFloat
                                          ) ON COMMIT DROP;

         -- таблица - элементы документа, по партиям
         CREATE TEMP TABLE _tmpItem_Reserv (MovementItemId Integer
                                          , ContainerId_Goods Integer
                                          , ObjectId Integer, PartionId Integer
                                          , OperCount TFloat
                                          , OperCountPartner TFloat
                                          , OperPricePartner TFloat
                                          , ObjectDescId Integer
                                           ) ON COMMIT DROP;


         -- все Элементы сборки Модели - здесь вся база
         CREATE TEMP TABLE _tmpReceiptProdModel ON COMMIT DROP AS
            SELECT lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                   -- !!!замена - НЕ оставляем только для Сборки
                 , lpSelect.ObjectId_parent
                   -- либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure /либо ПУСТО
                 , lpSelect.ObjectId
                   -- 
                 , lpSelect.ReceiptLevelId
                   -- 
                 , lpSelect.GoodsId_child
                   -- значение - Узел
                 , lpSelect.Value_parent
                   -- значение - Элемент
                 , lpSelect.Value
                   -- цена вх. без НДС - Узел
                 , lpSelect.EKPrice_parent
                   -- цена вх. без НДС - Элемент
                 , lpSelect.EKPrice
                   -- Boat Structure
                 , lpSelect.ProdColorPatternId

            FROM lpSelect_Object_ReceiptProdModelChild_detail (inIsGroup:=FALSE, inUserId:= inUserId) AS lpSelect
            WHERE lpSelect.ReceiptProdModelId = vbReceiptProdModelId
           ;


         -- таблица - в этом списке ReceiptGoods будем искать
         CREATE TEMP TABLE _tmpReceiptItems_Key ON COMMIT DROP AS
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
                                           -- ReceiptLevel
                                         , ObjectLink_ReceiptLevel.ChildObjectId           AS ReceiptLevelId
                                           -- GoodsChild
                                         , ObjectLink_GoodsChild.ChildObjectId             AS GoodsId_child
                                           -- цвет
                                         , CASE WHEN ObjectLink_Object.ChildObjectId > 0
                                                     THEN ''
                                                WHEN Object_ReceiptGoodsChild.ValueData <> ''
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
                                         INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
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
                                         -- ReceiptLevel
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                              ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                                         -- GoodsChild
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                              ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
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

                                    WHERE Object_ReceiptGoodsChild.DescId   = zc_Object_ReceiptGoodsChild()
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
                                   FROM (SELECT *
                                         FROM tmpReceiptItems
                                         ORDER BY tmpReceiptItems.ColorPatternId, tmpReceiptItems.ObjectId_parent
                                                , COALESCE (tmpReceiptItems.ObjectId, -1) DESC
                                                , COALESCE (tmpReceiptItems.MaterialOptionsId, 0)
                                                , tmpReceiptItems.ProdColorName
                                        ) AS tmpReceiptItems
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
                , tmpReceiptItems.ReceiptLevelId
                , tmpReceiptItems.GoodsId_child
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


--    RAISE EXCEPTION 'Ошибка. %   %', (select max (LENGTH (Key_Id)) from _tmpReceiptItems_Key)
  --  , (select max (LENGTH (Key_Id_text)) from _tmpReceiptItems_Key)
    --;

         -- существующие элементы ProdOptItems - у Лодки
         CREATE TEMP TABLE _tmpProdOptItems ON COMMIT DROP AS
            SELECT lpSelect.ProdOptionsId
                   -- Boat Structure - если есть
                 , lpSelect.ProdColorPatternId
                   -- Категория Опций
                 , lpSelect.MaterialOptionsId
                   --
                 , lpSelect.GoodsId
                   --
               --, lpSelect.ReceiptLevelId
                   --
               --, lpSelect.GoodsId_child
                   -- Кол-во опций
                 , lpSelect.Amount
                   -- Кол-во для сборки узла
                 , lpSelect.AmountBasis
                   -- Цена вх. для GoodsId
                 , lpSelect.EKPrice

            FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= 0
                                             , inIsShowAll:= FALSE
                                             , inIsErased := FALSE
                                             , inIsSale   := TRUE
                                             , inSession  := inUserId :: TVarChar
                                              ) AS lpSelect
            WHERE lpSelect.MovementId_OrderClient = inMovementId
              AND lpSelect.ProductId              = vbProductId
           ;

         -- существующие элементы ProdColorItems - у Лодки (здесь Boat Structure)
         CREATE TEMP TABLE _tmpProdColorItems ON COMMIT DROP AS
           SELECT -- Факт товар для Сборки
                  ObjectLink_Goods.ChildObjectId            AS GoodsId
                   -- Boat Structure
                , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
                   -- Категория Опций
                , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
                  -- Цвет - только Примечание (когда нет GoodsId)
                , CASE WHEN ObjectLink_Goods.ChildObjectId > 0
                            THEN ''
                       WHEN TRIM (ObjectString_Comment.ValueData) <> ''
                            THEN TRIM (ObjectString_Comment.ValueData)
                       ELSE -- нет, т.к. в ReceiptGoodsChild могли изменить, а если там пусто только тогда понадобится Boat Structure
                            ''
                            -- TRIM (COALESCE (ObjectString_ProdColorPattern_Comment.ValueData, ''))
                  END AS ProdColorName

           FROM Object AS Object_ProdColorItems
                -- Лодка
                INNER JOIN ObjectLink AS ObjectLink_Product
                                      ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                     AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                     AND ObjectLink_Product.ChildObjectId = vbProductId
                -- Заказ Клиента
                INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                       ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                      AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
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
           WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
             AND Object_ProdColorItems.isErased = FALSE
          ;


         -- Проверка
         IF EXISTS (SELECT _tmpProdColorItems.ProdColorPatternId FROM _tmpProdColorItems GROUP BY _tmpProdColorItems.ProdColorPatternId HAVING COUNT(*) > 1)
         THEN
             RAISE EXCEPTION 'Ошибка.Элемент Boat Structure = <%> не может дублироваться.'
                   , (SELECT lfGet_Object_ValueData_pcp (_tmpProdColorItems.ProdColorPatternId) FROM _tmpProdColorItems GROUP BY _tmpProdColorItems.ProdColorPatternId HAVING COUNT(*) > 1 LIMIT 1);
         END IF;



         -- 1. Результат - элементы документа zc_MI_Child - Шаблон сборки Лодки
         WITH tmpRes AS (-- 1. Базовая - ВСЕ Комплектующие у Лодки - !!!без деталей для сборки узлов!!! - поэтому DISTINCT
                         SELECT DISTINCT
                                -- потом создадим
                                0                                   AS MovementItemId
                                -- Товар c нужной Boat Structure, потом найдем/создадим
                              , CASE WHEN lpSelect.ObjectId_parent = lpSelect.ObjectId THEN lpSelect.ObjectId_parent ELSE 0 END AS ObjectId_parent_find
                                -- Узел/Товар из шаблона
                              , lpSelect.ObjectId_parent            AS ObjectId_parent
                              
                            --, CASE WHEN lpSelect.ObjectId_parent = lpSelect.ObjectId THEN lpSelect.GoodsId_child ELSE 0 END AS GoodsId_child_find
                            --, lpSelect.GoodsId_child
                              
                                -- здесь нет опции
                              , 0                                   AS ProdOptionsId
                              , COALESCE (lpSelect.Value_parent, 0) AS OperCount
                                -- для сборки узла - потом пересчитаем
                              , CASE WHEN lpSelect.ObjectId_parent = lpSelect.ObjectId THEN COALESCE (lpSelect.EKPrice_parent, 0) ELSE 0 END AS OperPrice
                                --

                         FROM _tmpReceiptProdModel AS lpSelect
                         WHERE -- !!!если учитываем в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                               vbIsBasicConf = TRUE
                           OR -- или заполнена ЭТА структура
                               lpSelect.ObjectId_parent IN (SELECT _tmpReceiptProdModel.ObjectId_parent
                                                            FROM _tmpReceiptProdModel
                                                                 JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpReceiptProdModel.ProdColorPatternId)

                        UNION ALL
                         -- 2. Опции
                         SELECT -- потом создадим
                                0                AS MovementItemId
                                -- тот же самый
                              , lpSelect.GoodsId AS ObjectId_parent
                                -- Goods
                              , lpSelect.GoodsId AS ObjectId

                            --, 0 AS GoodsId_child_find
                            --, 0 AS GoodsId_child

                                -- Опция
                              , lpSelect.ProdOptionsId
                                --
                              , lpSelect.Amount  AS OperCount
                              , lpSelect.EKPrice AS OperPrice

                         FROM _tmpProdOptItems AS lpSelect
                         -- БЕЗ этой Структуры
                         WHERE COALESCE (lpSelect.ProdColorPatternId, 0) = 0
                           -- !!!временно, пока не проставили Товар
                           AND lpSelect.GoodsId > 0
                        )
         -- Результат - Шаблон сборка Лодки
         INSERT INTO _tmpItem_Child (MovementItemId, ObjectId_parent_find, ObjectId_parent, ObjectDescId, ProdOptionsId, OperCount, OperPrice)
            SELECT 0 AS MovementItemId
                 , tmpRes.ObjectId_parent_find
                 , tmpRes.ObjectId_parent
                 , COALESCE (Object_Object.DescId, 0) AS ObjectDescId
               --, tmpRes.GoodsId_child_find
               --, tmpRes.GoodsId_child
                   --
                 , tmpRes.ProdOptionsId
                   --
                 , tmpRes.OperCount
                 , tmpRes.OperPrice
            FROM tmpRes
                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpRes.ObjectId_parent
            ;



         -- 2. Результат - элементы документа zc_MI_Detail - сборка узлов
         WITH 
              tmpRes AS (-- 1. Базовая - сборка
                         SELECT 
                                -- Узел из шаблона
                                lpSelect.ObjectId_parent
                                -- Goods - факт для Boat Structure, либо из шаблона (потом заменить, т.к. меняется шаблон), либо ПУСТО
                              , CASE WHEN _tmpProdColorItems.ProdColorPatternId > 0 THEN _tmpProdColorItems.GoodsId ELSE lpSelect.ObjectId END AS ObjectId
                         
                                -- только если по факту это опция
                              , COALESCE (_tmpProdOptItems.ProdOptionsId, 0) AS ProdOptionsId

                                -- Boat Structure
                              , lpSelect.ProdColorPatternId
                                -- Категория Опций
                              , _tmpProdColorItems.MaterialOptionsId
                                --
                              , lpSelect.ReceiptLevelId
                                --
                              , lpSelect.GoodsId_child
                                -- Цвет - только Примечание (когда нет GoodsId)
                              , _tmpProdColorItems.ProdColorName

                                -- значение - Элемент сборки
                              , COALESCE (lpSelect.Value, 0)                            AS OperCount
                                -- цена вх. без НДС - Элемент сборки
                              , COALESCE (_tmpProdOptItems.EKPrice, lpSelect.EKPrice, 0) AS OperPrice

                         FROM _tmpReceiptProdModel AS lpSelect
                              LEFT JOIN _tmpProdColorItems  ON _tmpProdColorItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                              LEFT JOIN _tmpProdOptItems ON _tmpProdOptItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                                        AND _tmpProdOptItems.ProdColorPatternId > 0
                                                       -- ?надо ли это условие?
                                                       -- AND COALESCE (_tmpProdOptItems.MaterialOptionsId, 0) = COALESCE (tmpProdColorItems.MaterialOptionsId, 0)

                         WHERE -- !!!если учитываем в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                              (vbIsBasicConf = TRUE
                           OR -- или заполнена ЭТА структура
                               lpSelect.ObjectId_parent IN (SELECT _tmpReceiptProdModel.ObjectId_parent FROM _tmpReceiptProdModel JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpReceiptProdModel.ProdColorPatternId)
                              )
                          AND (-- Только если сборка
                               lpSelect.ObjectId_parent <> lpSelect.ObjectId
                               -- или эта структура
                            OR lpSelect.ProdColorPatternId > 0 
                              )
                        )
         -- Результат - элементы документа, сборка узлов
         INSERT INTO _tmpItem_Detail (ObjectId_parent, ObjectId, ObjectDescId, ProdOptionsId, ColorPatternId, ProdColorPatternId, MaterialOptionsId, ReceiptLevelId, GoodsId_child
                                    , ProdColorName, OperCount, OperPrice)

            SELECT tmpRes.ObjectId_parent
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
                   --
                 , tmpRes.ReceiptLevelId
                 , tmpRes.GoodsId_child
                   -- Цвет - только Примечание (когда нет GoodsId)
                 , tmpRes.ProdColorName
                   --
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
         UPDATE _tmpItem_Child SET Key_Id      = tmp.Key_Id
                                 , Key_Id_text = tmp.Key_Id_text
         FROM (SELECT _tmpItem.ColorPatternId
                    , _tmpItem.ObjectId_parent
                    , STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0 THEN _tmpItem.MaterialOptionsId :: TVarChar || '-' ELSE '' END
                               || CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId :: TVarChar ELSE UPPER (_tmpItem.ProdColorName) END, ';') AS Key_Id
                    , STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0 THEN lfGet_Object_ValueData_sh (_tmpItem.MaterialOptionsId) || '-' ELSE '' END
                               || CASE WHEN _tmpItem.ObjectId > 0 THEN lfGet_Object_ValueData_sh (_tmpItem.ObjectId) ELSE UPPER (_tmpItem.ProdColorName) END, ';') AS Key_Id_text
               FROM -- сначала отсортировать
                    (SELECT * FROM _tmpItem_Detail AS _tmpItem ORDER BY _tmpItem.ColorPatternId, _tmpItem.ObjectId_parent
                                                                      , COALESCE (_tmpItem.ObjectId, -1) DESC
                                                                      , COALESCE (_tmpItem.MaterialOptionsId, 0)
                                                                      , _tmpItem.ProdColorName
                    ) AS _tmpItem
               GROUP BY _tmpItem.ColorPatternId
                      , _tmpItem.ObjectId_parent
              ) AS tmp
         WHERE _tmpItem_Child.ObjectId_parent = tmp.ObjectId_parent
        ;

         -- Находим ObjectId_parent для Boat Structure
         UPDATE _tmpItem_Child SET ObjectId_parent_find = _tmpItem_find.ObjectId_parent_find
                               --, GoodsId_child_find   = _tmpItem_find.GoodsId_child_find
         FROM (WITH -- существующий список
                    tmpList_from AS (SELECT DISTINCT
                                            _tmpItem.ColorPatternId
                                          , _tmpItem.ObjectId_parent
                                        --, _tmpItem.GoodsId_child
                                          , _tmpItem_Child.Key_Id
                                     FROM _tmpItem_Detail AS _tmpItem
                                          JOIN _tmpItem_Child ON _tmpItem_Child.ObjectId_parent = _tmpItem.ObjectId_parent
                                     WHERE _tmpItem.ColorPatternId > 0
                                    )
                      -- в этом списке будем искать
                    , tmpList_to AS (SELECT DISTINCT
                                            _tmpReceiptItems_Key.ColorPatternId
                                          , _tmpReceiptItems_Key.ObjectId_parent
                                        --, _tmpReceiptItems_Key.GoodsId_child
                                          , _tmpReceiptItems_Key.Key_Id
                                     FROM _tmpReceiptItems_Key
                                    )
               -- Результат
               SELECT tmpList_from.ObjectId_parent
                      -- здесь нашли узел с такой структурой
                    , COALESCE (tmpList_to.ObjectId_parent, 0) AS ObjectId_parent_find
                  --, COALESCE (tmpList_to.GoodsId_child, 0)   AS GoodsId_child_find
               FROM tmpList_from
                    LEFT JOIN tmpList_to ON tmpList_to.ColorPatternId = tmpList_from.ColorPatternId
                                        AND tmpList_to.Key_Id         = tmpList_from.Key_Id
              ) AS _tmpItem_find
         WHERE _tmpItem_Child.ObjectId_parent = _tmpItem_find.ObjectId_parent
        ;


        -- Проверка
        IF EXISTS (SELECT 1
                   FROM _tmpItem_Child AS _tmpItem
                       JOIN _tmpItem_Child AS _tmpItem_find
                                         ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                         AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                   WHERE _tmpItem.ObjectId_parent > 0
                  )
        --AND 1=0
        THEN
            RAISE EXCEPTION 'Ошибка-1.Не у всех элементов одинаковый ObjectId_parent_find.<%> <%> <%> <%>'
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent)
                              FROM _tmpItem_Child AS _tmpItem
                                  JOIN _tmpItem_Child AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent_find)
                              FROM _tmpItem_Child AS _tmpItem
                                  JOIN _tmpItem_Child AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent_find)
                              FROM _tmpItem_Child AS _tmpItem
                                  JOIN _tmpItem_Child AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find DESC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT COUNT (*)
                              FROM _tmpItem_Child AS _tmpItem
                              WHERE _tmpItem.ObjectId_parent IN (SELECT _tmpItem.ObjectId_parent
                                                                 FROM _tmpItem_Child AS _tmpItem
                                                                     JOIN _tmpItem_Child AS _tmpItem_find
                                                                                       ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                                                       AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                                                                 WHERE _tmpItem.ObjectId_parent > 0
                                                                 ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                                                                 LIMIT 1)
                             )
                            ;
        END IF;



--        RAISE EXCEPTION 'Ошибка.<%>  <%>'
--        , (select count(*) from _tmpReceiptItems_Key where _tmpReceiptItems_Key.Key_Id ILIKE '%ral%')
--        , (select count(*) from _tmpItem_Child         where _tmpItem_Child.Key_Id     ILIKE '%ral%')
--         ;


         -- таблица - список созданных узлов + его Комплектующие
         CREATE TEMP TABLE _tmpReceiptItems_new (ReceiptGoodsChildId Integer, ReceiptGoodsId Integer
                                               , ObjectId_parent_old Integer, ObjectId_parent Integer, ObjectId Integer, ProdColorPatternId Integer
                                               , MaterialOptionsId Integer, ColorPatternId Integer, ReceiptLevelId Integer, GoodsId_child Integer, GoodsId_child_old Integer
                                               , ProdColorName TVarChar
                                               , OperCount TFloat
                                               , Key_Id TVarChar, Key_Id_text TVarChar
                                                ) ON COMMIT DROP;
        -- Пробуем создать
        INSERT INTO _tmpReceiptItems_new (ReceiptGoodsChildId, ReceiptGoodsId
                                        , ObjectId_parent_old, ObjectId_parent, ObjectId, ProdColorPatternId
                                        , MaterialOptionsId, ColorPatternId, ReceiptLevelId, GoodsId_child, GoodsId_child_old
                                        , ProdColorName
                                        , OperCount
                                        , Key_Id, Key_Id_text
                                         )
           SELECT 0 AS ReceiptGoodsChildId
                , 0 AS ReceiptGoodsId
                  -- Предыдущий узел
                , _tmpItem_Child.ObjectId_parent AS ObjectId_parent_old
                  -- Создадим узел
                , 0 AS ObjectId_parent
                  -- Комплектующие, из которых делается узел
                , _tmpItem_Detail.ObjectId

                  -- Комплектующие - из Boat Structure
                  --, _tmpItem_Detail.ObjectId_pcp

                  -- Boat Structure - не меняется
                , _tmpItem_Detail.ProdColorPatternId
                  -- Категория Опций - из которых делается узел
                , _tmpItem_Detail.MaterialOptionsId
                  --  Шаблон Boat Structure
                , _tmpItem_Detail.ColorPatternId
                  --
                , _tmpItem_Detail.ReceiptLevelId
                  --
                , 0 AS GoodsId_child
                , _tmpItem_Detail.GoodsId_child AS GoodsId_child_old
                  -- Цвет из которых делается узел - только Примечание (когда нет GoodsId)
                , _tmpItem_Detail.ProdColorName

                  -- OperCount
                , _tmpItem_Detail.OperCount

                  -- Цвет - из Boat Structure
                  -- , _tmpItem_Detail.ProdColorName_pcp

                  --
                , _tmpItem_Child.Key_Id, _tmpItem_Child.Key_Id_text

           FROM _tmpItem_Child
                JOIN _tmpItem_Detail ON _tmpItem_Detail.ObjectId_parent = _tmpItem_Child.ObjectId_parent
           WHERE _tmpItem_Child.ObjectId_parent_find = 0
             AND _tmpItem_Detail.ProdColorPatternId  > 0
          ;


/*        RAISE EXCEPTION 'Ошибка.<%>  <%> <%>'
        , (select count(*) from _tmpReceiptItems_new where COALESCE (_tmpReceiptItems_new.GoodsId_child_old, 0) = 0 and Key_Id_text ilike '%9005%')
        , (select count(*) from _tmpReceiptItems_new where COALESCE (_tmpReceiptItems_new.GoodsId_child_old, 0) > 0 and Key_Id_text ilike '%9005%')
        , (select count(*) from _tmpReceiptItems_new )
         ;*/



        -- Создаем новый Узел - master
        UPDATE _tmpReceiptItems_new SET ObjectId_parent = tmpGoods.GoodsId
        FROM (WITH tmpColor AS (SELECT _tmpReceiptItems_new.ObjectId_parent_old AS GoodsId_parent_old
                                     , _tmpReceiptItems_new.ObjectId            AS GoodsId
                                     , _tmpReceiptItems_new.ProdColorPatternId  AS ProdColorPatternId
                                     , _tmpReceiptItems_new.ProdColorName       AS ProdColorName
                                     , Object_ProdColor_goods.Id                AS ProdColorId_goods
                                     , Object_ProdColor_goods.ValueData         AS ProdColorName_goods
                                     , OS_Article.ValueData                     AS Article_goods
                                     , Object_MaterialOptions.ValueData         AS MaterialOptionsName
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
                                     --
                                     LEFT JOIN ObjectString AS OS_Article ON OS_Article.ObjectId = _tmpReceiptItems_new.ObjectId
                                                                         AND OS_Article.DescId   = zc_ObjectString_Article()
                                     --
                                     LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = _tmpReceiptItems_new.MaterialOptionsId

                               )
                 , tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent_old AS GoodsId_parent_old, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT tmpGoods.GoodsId_parent_old
                   , gpInsertUpdate_Object_Goods (ioId                     := 0
                                                , inCode                   := -1 -- (SELECT MIN (Object.ObjectCode) - 1 FROM Object WHERE Object.DescId = zc_Object_Goods())
                                                                              -- <(-3835)AGL-280-*ICE WHITE - *NEPTUNE GREY(Hypalon)>.
                                                , inName                   := CASE WHEN ObjectString_Comment.ValueData ILIKE 'Hypalon'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                     ||   '-*' || tmpColor_1.ProdColorName_goods
                                                                                     || ' - *' || tmpColor_2.ProdColorName_goods
                                                                                             --|| CASE WHEN tmpColor_3.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp THEN ' *'  || tmpColor_3.ProdColorName ELSE '' END
                                                                                               || CASE WHEN tmpColor_3.GoodsId <> _tmpReceiptItems_Key.ObjectId_pcp THEN ' *'  || tmpColor_3.ProdColorName_goods ELSE '' END

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Teak'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || LEFT (tmpColor_1.MaterialOptionsName, 2)
                                                                                        || '-' || tmpColor_1.ProdColorName

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'HULL/DECK'
                                                                                   THEN 
                                                                                        'Корпус '
                                                                                      ||'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.ProdColorName_goods
                                                                                               || CASE WHEN tmpColor_2.ProdColorName_goods <> tmpColor_1.ProdColorName_goods
                                                                                                       THEN '-'  || tmpColor_2.ProdColorName_goods
                                                                                                       ELSE ''
                                                                                                  END

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'DECK'
                                                                                   THEN
                                                                                        'Сиденье водителя '
                                                                                      ||'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.ProdColorName_goods

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'STEERING CONSOLE'
                                                                                   THEN
                                                                                        'Капот '
                                                                                      ||'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.ProdColorName_goods

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Kreslo'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.Article_goods
                                                                                      ||   '-' || LOWER (LEFT (tmpColor_2.ProdColorName, 3))
                                                                                      ||   '-' || LOWER (LEFT (tmpColor_3.ProdColorName, 3))

                                                                              END


                                                , inArticle                := CASE WHEN ObjectString_Comment.ValueData ILIKE 'Hypalon'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                     ||   '-*' || tmpColor_1.ProdColorName_goods
                                                                                     || ' - *' || tmpColor_2.ProdColorName_goods
                                                                                             --|| CASE WHEN tmpColor_3.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp THEN ' *'  || LEFT (tmpColor_3.ProdColorName, 1) ELSE '' END
                                                                                               || CASE WHEN tmpColor_3.GoodsId <> _tmpReceiptItems_Key.ObjectId_pcp THEN ' *'  || LEFT (tmpColor_3.ProdColorName_goods, 1) ELSE '' END

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Teak'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || LEFT (tmpColor_1.MaterialOptionsName, 2)
                                                                                        || '-' || LEFT (tmpColor_1.ProdColorName, 1)

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'HULL/DECK'
                                                                                     OR ObjectString_Comment.ValueData ILIKE 'DECK'
                                                                                     OR ObjectString_Comment.ValueData ILIKE 'STEERING CONSOLE'
                                                                                   THEN
                                                                                        lfGet_Object_Goods_Article_value ('AGL-' || Object_Model.ValueData)

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Kreslo'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.Article_goods
                                                                                      ||   '-' || LOWER (LEFT (tmpColor_2.ProdColorName, 1))
                                                                                      ||    '' || LOWER (LEFT (tmpColor_3.ProdColorName, 1))
                                                                              END
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

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId_parent_old

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

              -- создаем только такие Узлы
              WHERE ObjectString_Comment.ValueData ILIKE 'Hypalon'
                 OR ObjectString_Comment.ValueData ILIKE 'Teak'
                 OR ObjectString_Comment.ValueData ILIKE 'HULL/DECK'
                 OR ObjectString_Comment.ValueData ILIKE 'DECK'
                 OR ObjectString_Comment.ValueData ILIKE 'STEERING CONSOLE'
                 OR ObjectString_Comment.ValueData ILIKE 'Kreslo'

             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent_old = tmpGoods.GoodsId_parent_old
       ;




        -- Создаем новый Узел - child
        UPDATE _tmpReceiptItems_new SET GoodsId_child = tmpGoods.GoodsId_child
        FROM (SELECT tmpGoods_1.GoodsId
                   , tmpGoods_1.GoodsId_child_old
                   , gpInsertUpdate_Object_Goods (ioId                     := 0
                                                , inCode                   := -1
                                                , inName                   := 'ПФ ' || Object_Goods_new.ValueData
                                                , inArticle                := ObjectString_Article_new.ValueData || '-пф'
                                              --, inArticle                := tmpGoods_1.GoodsId :: TVarChar
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
                                                , inProdColorId            := ObjectLink_Goods_ProdColor_new.ChildObjectId
                                                , inPartnerId              := ObjectLink_Goods_Partner.ChildObjectId
                                                , inUnitId                 := ObjectLink_Goods_Unit.ChildObjectId
                                                , inDiscountPartnerId      := ObjectLink_Goods_DiscountPartner.ChildObjectId
                                                , inTaxKindId              := ObjectLink_Goods_TaxKind.ChildObjectId
                                                , inEngineId               := NULL
                                                , inSession                := inUserId :: TVarChar
                                                 ) AS GoodsId_child
              FROM (SELECT DISTINCT
                           _tmpReceiptItems_new.ObjectId_parent    AS GoodsId
                         , _tmpReceiptItems_new.GoodsId_child_old  AS GoodsId_child_old
                    FROM _tmpReceiptItems_new
                    WHERE _tmpReceiptItems_new.GoodsId_child_old > 0
                   ) AS tmpGoods_1
                   LEFT JOIN Object AS Object_Goods_new ON Object_Goods_new.Id = tmpGoods_1.GoodsId
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor_new
                                        ON ObjectLink_Goods_ProdColor_new.ObjectId = tmpGoods_1.GoodsId
                                       AND ObjectLink_Goods_ProdColor_new.DescId = zc_ObjectLink_Goods_ProdColor()
                   LEFT JOIN ObjectString AS ObjectString_Article_new
                                          ON ObjectString_Article_new.ObjectId = tmpGoods_1.GoodsId
                                         AND ObjectString_Article_new.DescId   =  zc_ObjectString_Article()

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods_1.GoodsId_child_old

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
             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent   = tmpGoods.GoodsId
          AND _tmpReceiptItems_new.GoodsId_child_old = tmpGoods.GoodsId_child_old
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
              -- если создавали Узел
              WHERE tmpGoods.GoodsId_parent > 0
             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent = tmpGoods.GoodsId_parent
       ;

        -- Создаем новый ReceiptGoodsChild
        UPDATE _tmpReceiptItems_new SET ReceiptGoodsChildId = tmpGoods.ReceiptGoodsChildId
        FROM (WITH tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent AS GoodsId_parent, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT _tmpReceiptItems_new.ObjectId_parent
                   , _tmpReceiptItems_new.ObjectId
                   , _tmpReceiptItems_new.ProdColorPatternId
                   , (SELECT gpInsertUpdate.ioId
                      FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                  := 0
                                                                  , inComment             := CASE WHEN COALESCE (_tmpReceiptItems_new.ObjectId, 0) = 0
                                                                                                  THEN CASE WHEN _tmpReceiptItems_new.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp
                                                                                                       -- если не такой как в Boat Structure
                                                                                                       THEN _tmpReceiptItems_new.ProdColorName
                                                                                                       ELSE ''
                                                                                                       END
                                                                                                   ELSE ''
                                                                                             END
                                                                  , inReceiptGoodsId      := _tmpReceiptItems_new.ReceiptGoodsId
                                                                  , inObjectId            := _tmpReceiptItems_new.ObjectId
                                                                  , inProdColorPatternId  := _tmpReceiptItems_new.ProdColorPatternId
                                                                  , inMaterialOptionsId   := _tmpReceiptItems_new.MaterialOptionsId
                                                                  , inReceiptLevelId_top  := NULL
                                                                  , inReceiptLevelId      := _tmpReceiptItems_new.ReceiptLevelId
                                                                  , inGoodsChildId        := _tmpReceiptItems_new.GoodsId_child
                                                                  , ioValue               := _tmpReceiptItems_new.OperCount
                                                                  , ioValue_service       := 0
                                                                  , inIsEnabled           := TRUE
                                                                  , inSession             := inUserId :: TVarChar
                                                                   ) AS gpInsertUpdate
                     ) AS ReceiptGoodsChildId
              FROM _tmpReceiptItems_new
                   LEFT JOIN _tmpReceiptItems_Key ON _tmpReceiptItems_Key.ObjectId_parent    = _tmpReceiptItems_new.ObjectId_parent_old
                                                 AND _tmpReceiptItems_Key.ProdColorPatternId = _tmpReceiptItems_new.ProdColorPatternId
              -- если создавали Узел
              WHERE _tmpReceiptItems_new.ObjectId_parent > 0


            UNION ALL
             -- все остальное для сборки Узла
             SELECT  0 AS ObjectId_parent
                   , _tmpReceiptProdModel.ObjectId       AS ObjectId
                   , 0 AS ProdColorPatternId
                   , (SELECT gpInsertUpdate.ioId
                      FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                  := 0
                                                                  , inComment             := ''
                                                                  , inReceiptGoodsId      := _tmpReceiptItems_new.ReceiptGoodsId
                                                                  , inObjectId            := _tmpReceiptProdModel.ObjectId
                                                                  , inProdColorPatternId  := 0
                                                                  , inMaterialOptionsId   := NULL
                                                                  , inReceiptLevelId_top  := NULL
                                                                  , inReceiptLevelId      := _tmpReceiptProdModel.ReceiptLevelId
                                                                  , inGoodsChildId        := _tmpReceiptItems_new.GoodsId_child
                                                                  , ioValue               := _tmpReceiptProdModel.Value
                                                                  , ioValue_service       := 0
                                                                  , inIsEnabled           := TRUE
                                                                  , inSession             := inUserId :: TVarChar
                                                                   ) AS gpInsertUpdate
                     ) AS ReceiptGoodsChildId
             FROM _tmpReceiptProdModel
                  INNER JOIN Object AS Object_Object
                                    ON Object_Object.Id     = _tmpReceiptProdModel.ObjectId
                                   AND Object_Object.DescId = zc_Object_Goods()
                  INNER JOIN (-- новые элементы ReceiptGoodsId + есть GoodsId_child
                              SELECT DISTINCT
                                     _tmpReceiptItems_new.ReceiptGoodsId
                                   , _tmpReceiptItems_new.ObjectId_parent_old
                                   , _tmpReceiptItems_new.GoodsId_child, _tmpReceiptItems_new.GoodsId_child_old
                              FROM _tmpReceiptItems_new
                              -- есть GoodsId_child
                              WHERE _tmpReceiptItems_new.GoodsId_child_old > 0

                             UNION
                              -- новые элементы ReceiptGoodsId + БЕЗ GoodsId_child
                              SELECT DISTINCT
                                     _tmpReceiptItems_new.ReceiptGoodsId
                                   , _tmpReceiptItems_new.ObjectId_parent_old
                                     -- будет пустой
                                   , 0 AS GoodsId_child
                                     -- подставляем пустой
                                   , 0 AS GoodsId_child_old
                              FROM _tmpReceiptItems_new

                             ) AS _tmpReceiptItems_new
                               ON _tmpReceiptItems_new.ObjectId_parent_old = _tmpReceiptProdModel.ObjectId_parent
                              AND _tmpReceiptItems_new.GoodsId_child_old   = COALESCE (_tmpReceiptProdModel.GoodsId_child, 0)
                                   
             WHERE COALESCE (_tmpReceiptProdModel.ProdColorPatternId, 0) = 0
              -- только когда сборка Узла
              AND _tmpReceiptProdModel.ObjectId_parent > 0
             
             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent    = tmpGoods.ObjectId_parent
          AND _tmpReceiptItems_new.ObjectId           = tmpGoods.ObjectId
          AND _tmpReceiptItems_new.ProdColorPatternId = tmpGoods.ProdColorPatternId
       ;

       -- Перенесли новый Узел
        UPDATE _tmpItem_Child SET ObjectId_parent_find = _tmpReceiptItems_new.ObjectId_parent
        FROM (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent_old, _tmpReceiptItems_new.ObjectId_parent FROM _tmpReceiptItems_new
             ) AS _tmpReceiptItems_new
        WHERE _tmpItem_Child.ObjectId_parent    = _tmpReceiptItems_new.ObjectId_parent_old
        --AND _tmpItem_Child.ObjectId           = _tmpReceiptItems_new.ObjectId
        --AND _tmpItem_Child.ProdColorPatternId = _tmpReceiptItems_new.ProdColorPatternId
         ;

--        RAISE EXCEPTION 'Ошибка.<%> <%>', (select distinct lfGet_Object_ValueData (_tmpReceiptItems_new.ObjectId_parent_old) from _tmpReceiptItems_new)
  --      , (select distinct lfGet_Object_ValueData (_tmpReceiptItems_new.ObjectId_parent) from _tmpReceiptItems_new)
    --    ;


        -- Проверка
        IF EXISTS (SELECT 1 FROM _tmpItem_Child AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 /*AND _tmpItem.ProdColorPatternId > 0*/)
        --AND 1=0
        THEN
            RAISE EXCEPTION 'Ошибка.Не найден аналог для%<%>.%Для такой структуры: <%>%Всего не найдено <%> шт.'
                                        , CHR (13)
                                        , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent) || COALESCE ('(' || OS.ValueData || ')', '') || COALESCE ('(' || _tmpItem.ObjectId_parent :: TVarChar || ')', '')
                                           FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem_Child AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0
                                                ) AS _tmpItem
                                                LEFT JOIN ObjectString AS OS ON OS.ObjectId = _tmpItem.ObjectId_parent AND OS.DescId = zc_ObjectString_Goods_Comment()
                                           LIMIT 1)
                                        , CHR (13)
                                        , (SELECT lfGet_Object_ValueData (_tmpItem.ColorPatternId)
                                                || ' : '
                                                || CHR (13)
                                                || CHR (13)
                                                || _tmpItem_Child.Key_Id
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
                                                (SELECT * FROM _tmpItem_Detail AS _tmpItem
                                                 WHERE _tmpItem.ObjectId_parent = (SELECT MAX (_tmpItem.ObjectId_parent) FROM _tmpItem_Child AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0)
                                                   AND _tmpItem.ColorPatternId > 0
                                                 ORDER BY _tmpItem.ColorPatternId
                                                        , COALESCE (_tmpItem.ObjectId, -1) DESC
                                                        , _tmpItem.ProdColorName
                                                ) AS _tmpItem
                                                LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                                     ON ObjectLink_Goods_ProdColor.ObjectId = _tmpItem.ObjectId
                                                                    AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                                LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                                                LEFT JOIN _tmpItem_Child ON _tmpItem_Child.ObjectId_parent = _tmpItem.ObjectId_parent

                                           GROUP BY _tmpItem.ColorPatternId
                                                  , _tmpItem_Child.Key_Id
                                          )
                                        , CHR (13)
                                        , (SELECT COUNT(*) FROM _tmpItem_Child WHERE _tmpItem_Child.ObjectId_parent_find = 0);
        END IF;


        -- сначала все удалили
        PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail(), zc_MI_Reserv())
          AND MovementItem.isErased   = FALSE
        ;

        -- 1. формируем первый раз - Количество шаблон сборки
        UPDATE _tmpItem_Child
               SET MovementItemId = lpInsertUpdate_MI_OrderClient_Child (ioId                  := 0
                                                                       , inMovementId          := inMovementId
                                                                       , inObjectId            := _tmpItem.ObjectId_parent_find
                                                                       , inGoodsId_Basis       := _tmpItem.ObjectId_Basis
                                                                       , inAmount              := _tmpItem.OperCount
                                                                       , inAmountPartner       := 0 -- !!!временно!!!
                                                                                                  -- CASE WHEN _tmpItem.ObjectId_parent > 0 THEN 0 ELSE _tmpItem.OperCount END
                                                                       , inOperPrice           := _tmpItem.OperPrice
                                                                       , inCountForPrice       := 1
                                                                       , inPartnerId           := _tmpItem.PartnerId
                                                                       , inProdOptionsId       := _tmpItem.ProdOptionsId
                                                                       , inUserId              := inUserId
                                                                        )
        FROM (-- Собрали Узлы
              SELECT _tmpItem.ObjectId_parent_find
                     -- если была замена, какой узел был в ReceiptProdModel
                   , CASE WHEN _tmpItem.ObjectId_parent_find <> _tmpItem.ObjectId_parent THEN _tmpItem.ObjectId_parent ELSE 0 END AS ObjectId_Basis
                   , _tmpItem.OperCount
                   , CASE WHEN tmpItem_Detail.OperSumm > 0 THEN tmpItem_Detail.OperSumm / CASE WHEN _tmpItem.OperCount > 0 THEN _tmpItem.OperCount ELSE 1 END ELSE _tmpItem.OperPrice END AS OperPrice
                   , _tmpItem.ProdOptionsId
                   , OL_Goods_Partner.ChildObjectId AS PartnerId
              FROM _tmpItem_Child AS _tmpItem
                   -- Собрали Узлы
                   LEFT JOIN (SELECT _tmpItem_Detail.ObjectId_parent
                                   , SUM (COALESCE (_tmpItem_Detail.OperCount * _tmpItem_Detail.OperPrice)) AS OperSumm
                              FROM _tmpItem_Detail
                              GROUP BY _tmpItem_Detail.ObjectId_parent
                             ) AS tmpItem_Detail ON tmpItem_Detail.ObjectId_parent = _tmpItem.ObjectId_parent
                   LEFT JOIN ObjectLink AS OL_Goods_Partner
                                        ON OL_Goods_Partner.ObjectId = _tmpItem.ObjectId_parent
                                       AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()
             ) AS _tmpItem
        WHERE _tmpItem_Child.ObjectId_parent_find = _tmpItem.ObjectId_parent_find
       ;

        -- 2. формируем второй раз - Количество для сборки Узла
        UPDATE _tmpItem_Detail
               SET MovementItemId = lpInsertUpdate_MI_OrderClient_Detail (ioId                  := 0
                                                                        , inMovementId          := inMovementId
                                                                        , inObjectId            := CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId ELSE _tmpItem.ProdColorPatternId END
                                                                        , inGoodsId             := _tmpItem.ObjectId_parent_find
                                                                        , inAmount              := _tmpItem.OperCount
                                                                        , inAmountPartner       := 0 -- !!!временно!!!
                                                                                                   -- CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN 0 ELSE _tmpItem.OperCount END
                                                                        , inOperPrice           := _tmpItem.OperPrice
                                                                        , inCountForPrice       := 1
                                                                        , inPartnerId           := _tmpItem.PartnerId
                                                                        , inProdOptionsId       := _tmpItem.ProdOptionsId
                                                                        , inColorPatternId      := _tmpItem.ColorPatternId
                                                                        , inProdColorPatternId  := _tmpItem.ProdColorPatternId
                                                                        , inUserId              := inUserId
                                                                         )
        FROM (-- Собрали Узлы
              SELECT _tmpItem_Child.ObjectId_parent_find
                   , _tmpItem_Child.MovementItemId
                   , _tmpItem.ObjectId_parent
                   , _tmpItem.ObjectId
                   , _tmpItem.OperCount AS OperCount
                   , _tmpItem.OperPrice
                   , _tmpItem.ColorPatternId
                   , _tmpItem.ProdColorPatternId
                   , _tmpItem.ProdOptionsId
                   , OL_Goods_Partner.ChildObjectId AS PartnerId
              FROM _tmpItem_Detail AS _tmpItem
                   -- Узел
                   LEFT JOIN _tmpItem_Child ON _tmpItem_Child.ObjectId_parent = _tmpItem.ObjectId_parent
                   --
                   LEFT JOIN ObjectLink AS OL_Goods_Partner
                                        ON OL_Goods_Partner.ObjectId = _tmpItem.ObjectId
                                       AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()
             ) AS _tmpItem
        WHERE _tmpItem_Detail.ObjectId_parent      = _tmpItem.ObjectId_parent
          AND (_tmpItem_Detail.ObjectId            = _tmpItem.ObjectId
           AND _tmpItem_Detail.ProdColorPatternId = _tmpItem.ProdColorPatternId
          --OR (_tmpItem_Detail.ProdColorPatternId = _tmpItem.ProdColorPatternId
          --AND _tmpItem_Detail.ColorPatternId     = _tmpItem.ColorPatternId)
              )
       ;

        -- !!!3.элементы документа, по партиям!!!
        WITH -- только ObjectId
             tmpItem AS   (SELECT MovementItem.Id                        AS MovementItemId
                                , MILinkObject_Partner.ObjectId          AS PartnerId
                                , MovementItem.ObjectId                  AS ObjectId
                                , MovementItem.Amount                    AS Amount
                                , MIFloat_OperPrice.ValueData            AS OperPrice
                                , COALESCE (Object_Object.DescId, 0)     AS ObjectDescId

                           FROM MovementItem
                                LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                 ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = FALSE
                             -- !!!без услуг!!!
                             AND Object_Object.DescId    <> zc_Object_ReceiptService()
                          )
                -- существующие резервы - в заказах Клиентов
              , tmpOrderClient AS (SELECT MovementItem.PartionId     AS PartionId
                                        , MILinkObject_Unit.ObjectId AS UnitId
                                        , SUM (MovementItem.Amount)  AS Amount
                                   FROM Movement
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Reserv()
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
                                        -- !!!надо будет считать разницу - резерв и то что пришло
                                      , Container.Amount - COALESCE (tmpOrderClient.Amount, 0) + COALESCE (tmpSend.Amount, 0) AS Amount
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
                                      , tmpItem.Amount           AS OperCount
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
         INSERT INTO _tmpItem_Reserv (MovementItemId, ContainerId_Goods, ObjectId, PartionId, OperCount, OperCountPartner, OperPricePartner, ObjectDescId)
            -- 0.1. Остатки
            SELECT tmpItem.MovementItemId
                   -- нашли!!
                 , tmpRes_partion.ContainerId
                   --
                 , tmpItem.ObjectId
                   -- нашли!!
                 , tmpRes_partion.PartionId
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
                 , 0 AS OperCount

                 , -- для заказа оставили сколько не хватает
                   tmpItem.Amount - COALESCE (tmpRes_partion_total.OperCount, 0) AS OperCountPartner

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
            WHERE tmpItem.Amount - COALESCE (tmpRes_partion_total.OperCount, 0) > 0
            ;


         -- Заказ Поставщику
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPricePartner(), _tmpItem_Reserv.MovementItemId, _tmpItem_Reserv.OperPricePartner)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(),    _tmpItem_Reserv.MovementItemId, _tmpItem_Reserv.OperCountPartner)
         FROM _tmpItem_Reserv
         WHERE _tmpItem_Reserv.ContainerId_Goods = 0
           AND _tmpItem_Reserv.OperCountPartner  > 0
        ;


         -- 3. формируем третий раз - резерв по партиям
         PERFORM lpInsertUpdate_MI_OrderClient_Reserv (ioId                  := 0
                                                     , inParentId            := _tmpItem_Reserv.MovementItemId
                                                     , inMovementId          := inMovementId
                                                     , inPartionId           := _tmpItem_Reserv.PartionId
                                                     , inObjectId            := _tmpItem_Reserv.ObjectId
                                                     , inAmount              := _tmpItem_Reserv.OperCount
                                                     , inOperPrice           := _tmpItem_Reserv.OperPricePartner -- информативно
                                                     , inCountForPrice       := 1
                                                     , inUnitId              := CLO_Unit.ObjectId
                                                     , inUserId              := inUserId
                                                      )
         FROM _tmpItem_Reserv
              LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItem_Reserv.ContainerId_Goods AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
         WHERE _tmpItem_Reserv.ContainerId_Goods > 0;



         -- !!! временно для отладки
         IF NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())
         THEN
             -- находим партию с Engine Nr
             SELECT MIN (_tmpItem_Reserv.PartionId), MAX (_tmpItem_Reserv.PartionId)
                    INTO vbPartionId_1, vbPartionId_2
             FROM _tmpItem_Reserv
                  INNER JOIN ObjectLink AS ObjectLink_Goods_Engine
                                        ON ObjectLink_Goods_Engine.ObjectId = _tmpItem_Reserv.ObjectId
                                       AND ObjectLink_Goods_Engine.DescId   = zc_ObjectLink_Goods_Engine()
                                       -- !!! установлено это св-во
                                       AND ObjectLink_Goods_Engine.ChildObjectId > 0
                  INNER JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = _tmpItem_Reserv.PartionId
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


    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_OrderClient()
                               , inUserId     := inUserId
                                );

    -- RAISE EXCEPTION 'Ошибка. ok '; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_OrderClient(inMovementId := 667 , inStatusCode := 2 , inIsChild_Recalc := 'True' ,  inSession := '5');
