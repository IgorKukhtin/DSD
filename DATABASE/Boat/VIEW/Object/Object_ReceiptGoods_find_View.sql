-- View: Object_ReceiptGoods_find_View

-- DROP VIEW IF EXISTS Object_ReceiptGoods_find_View;

CREATE OR REPLACE VIEW Object_ReceiptGoods_find_View AS
 WITH tmpReceiptGoods_all AS (-- Сборка Модели
                              SELECT ObjectLink_ReceiptProdModelChild_Object.ChildObjectId AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , 0 AS GoodsId_child
                                     -- не опция
                                   , FALSE AS isProdOptions
                                     -- где собирается Лодка
                                   , COALESCE (ObjectLink_Unit.ChildObjectId, 0) AS UnitId
                                     -- где собирается узел ПФ
                                   , 0 AS UnitId_child
                                     --
                                   , Object_ReceiptProdModel.Id        AS ReceiptId
                                   , Object_ReceiptProdModel.ValueData AS ReceiptName

                                   , 0 AS ProdColorPatternId

                              FROM Object AS Object_ReceiptProdModel
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptProdModel
                                                         ON ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ChildObjectId = Object_ReceiptProdModel.Id
                                                        AND ObjectLink_ReceiptProdModelChild_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                   INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ObjectId
                                                                                    AND Object_ReceiptProdModelChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                         ON ObjectLink_ReceiptProdModelChild_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                        AND ObjectLink_ReceiptProdModelChild_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                                        -- вот Комплектующие
                                                        AND ObjectLink_ReceiptProdModelChild_Object.ChildObjectId > 0

                                   -- где собирается Лодка
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                        ON ObjectLink_Unit.ObjectId = Object_ReceiptProdModel.Id
                                                       AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptProdModel_Unit()

                              WHERE Object_ReceiptProdModel.DescId   = zc_Object_ReceiptProdModel()
                                AND Object_ReceiptProdModel.isErased = FALSE

                             UNION ALL
                              -- Сборка узлов
                              SELECT -- из чего собирается
                                     COALESCE (ObjectLink_ReceiptGoodsChild_Object.ChildObjectId, 0)     AS GoodsId_from
                                     -- какой узел собирается
                                   , ObjectLink_ReceiptGoods_Object.ChildObjectId                        AS GoodsId_to
                                     -- какой узел ПФ собирается
                                   , COALESCE (ObjectLink_ReceiptGoodsChild_GoodsChild.ChildObjectId, 0) AS GoodsId_child
                                     -- не опция
                                   , FALSE AS isProdOptions

                                     -- где собирается узел
                                   , COALESCE (ObjectLink_Unit.ChildObjectId, 0)      AS UnitId
                                     -- где собирается узел ПФ
                                   , COALESCE (ObjectLink_UnitChild.ChildObjectId, 0) AS UnitId_child

                                   , Object_ReceiptGoods.Id        AS ReceiptId
                                   , Object_ReceiptGoods.ValueData AS ReceiptName

                                     -- Boat Structure
                                   , COALESCE (ObjectLink_ReceiptGoodsChild_ProdColorPattern.ChildObjectId, 0) AS ProdColorPatternId

                              FROM Object AS Object_ReceiptGoods
                                   -- какой узел собирается
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                         ON ObjectLink_ReceiptGoods_Object.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()

                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                         ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                   INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                AND Object_ReceiptGoodsChild.isErased = FALSE
                                   -- вот Комплектующие
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                                        ON ObjectLink_ReceiptGoodsChild_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()

                                   -- Boat Structure
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ProdColorPattern
                                                        ON ObjectLink_ReceiptGoodsChild_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

                                   -- какой узел ПФ собирается
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_GoodsChild
                                                        ON ObjectLink_ReceiptGoodsChild_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

                                   -- где собирается узел
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                        ON ObjectLink_Unit.ObjectId = Object_ReceiptGoods.Id
                                                       AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptGoods_Unit()
                                   -- где собирается узел ПФ
                                   LEFT JOIN ObjectLink AS ObjectLink_UnitChild
                                                        ON ObjectLink_UnitChild.ObjectId = Object_ReceiptGoods.Id
                                                       AND ObjectLink_UnitChild.DescId   = zc_ObjectLink_ReceiptGoods_UnitChild()

                              WHERE Object_ReceiptGoods.DescId   = zc_Object_ReceiptGoods()
                                AND Object_ReceiptGoods.isErased = FALSE
                                -- есть Комплектующие или Boat Structure
                                AND (ObjectLink_ReceiptGoodsChild_Object.ChildObjectId > 0 OR ObjectLink_ReceiptGoodsChild_ProdColorPattern.ChildObjectId > 0)

                             UNION ALL
                              -- Опции
                              SELECT
                                     0 AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , ObjectLink_ProdOptions_Goods.ChildObjectId AS GoodsId_child
                                     -- опция
                                   , TRUE AS isProdOptions
                                     -- где собирается ...
                                     --, 0 AS UnitId
                                   , MAX (Object_ProdOptions.Id) AS UnitId
                                     -- где собирается узел ПФ
                                   , 0 AS UnitId_child

                                   , 0  AS ReceiptId
                                   , '' AS ReceiptName
                                   , 0  AS ProdColorPatternId

                              FROM Object AS Object_ProdOptions
                                   INNER JOIN ObjectLink AS ObjectLink_ProdOptions_Goods
                                                         ON ObjectLink_ProdOptions_Goods.ObjectId = Object_ProdOptions.Id
                                                        AND ObjectLink_ProdOptions_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()
                                                        -- вот Комплектующие
                                                        AND ObjectLink_ProdOptions_Goods.ChildObjectId > 0

                                   -- Boat Structure
                                   LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_ProdColorPattern
                                                        ON ObjectLink_ProdOptions_ProdColorPattern.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_ProdOptions_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()


                              WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                                AND Object_ProdOptions.isErased = FALSE
                                -- Не Boat Structure
                                AND ObjectLink_ProdOptions_ProdColorPattern.ChildObjectId IS NULL
                              GROUP BY ObjectLink_ProdOptions_Goods.ChildObjectId
                             )
           -- найдем где Детали/узлы участвуют в сборке Узла/Лодки - без ПФ
         , tmpReceiptGoods_unit AS (--
                                    SELECT tmp_all.GoodsId
                                         , MAX (tmp_all.UnitId) AS UnitId
                                         , STRING_AGG (DISTINCT Object_Unit.ValueData, '; ') AS UnitName
                                    FROM (SELECT DISTINCT
                                                 -- из чего собирается
                                                 tmpReceiptGoods_all.GoodsId_from AS GoodsId
                                                 -- где собирается
                                               , tmpReceiptGoods_all.UnitId
                                          FROM tmpReceiptGoods_all
                                          -- !!! без ПФ !!!
                                          WHERE tmpReceiptGoods_all.GoodsId_child = 0
                                            -- убрали опции
                                            AND tmpReceiptGoods_all.GoodsId_from NOT IN (SELECT tmpReceiptGoods_all.GoodsId_child FROM tmpReceiptGoods_all)

                                         -- плюс Узлы-ПФ - где собираются Узлы
                                         UNION
                                          SELECT DISTINCT
                                                 -- ПФ
                                                 tmpReceiptGoods_all.GoodsId_child AS GoodsId
                                                 -- где собирается
                                               , tmpReceiptGoods_all.UnitId
                                          FROM tmpReceiptGoods_all
                                          -- !!! ПФ !!!
                                          WHERE tmpReceiptGoods_all.GoodsId_child > 0

                                         -- плюс Узлы (которых нет в ReceiptProdModel) - на Участок сборки Основной - здесь собирается Лодка
                                         UNION
                                          SELECT DISTINCT
                                                 -- узел
                                                 tmpReceiptGoods_all.GoodsId_to AS GoodsId
                                                 -- где из узла собирается Лодка
                                               , 33347 AS UnitId
                                          FROM tmpReceiptGoods_all
                                          WHERE tmpReceiptGoods_all.GoodsId_to > 0
                                            -- убрали опции
                                            AND tmpReceiptGoods_all.GoodsId_to NOT IN (SELECT tmpReceiptGoods_all.GoodsId_child FROM tmpReceiptGoods_all)


                                         -- плюс Опции - на Участок сборки Основной - здесь собирается Лодка
                                         UNION
                                          SELECT DISTINCT
                                                 -- опция
                                                 tmpReceiptGoods_all.GoodsId_child AS GoodsId
                                                 -- где из узла собирается Лодка
                                                 --, 33347 AS UnitId -- Участок сборки Основной
                                               , tmpReceiptGoods_all.UnitId
                                          FROM tmpReceiptGoods_all
                                          -- !!! опция !!!
                                          WHERE tmpReceiptGoods_all.isProdOptions = TRUE

                                         ) AS tmp_all
                                         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp_all.UnitId
                                    GROUP BY tmp_all.GoodsId
                                    )
           -- найдем где Детали участвуют в сборке Узла-ПФ
         , tmpReceiptGoods_unit_child AS (--
                                          SELECT tmp_all.GoodsId
                                               , MAX (tmp_all.UnitId_child) AS UnitId
                                               , STRING_AGG (DISTINCT Object_Unit.ValueData, '; ') AS UnitName
                                          FROM (SELECT DISTINCT
                                                       -- из чего собирается
                                                       tmpReceiptGoods_all.GoodsId_from AS GoodsId
                                                       -- где собирается
                                                     , tmpReceiptGoods_all.UnitId_child
                                                FROM tmpReceiptGoods_all
                                                -- !!! ПФ !!!
                                                WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                               ) AS tmp_all
                                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp_all.UnitId_child
                                          GROUP BY tmp_all.GoodsId
                                         )
           -- найдем где собираются ВСЕ Узлы
         , tmpReceiptGoods_unit_parent AS (--
                                          SELECT tmp_all.GoodsId
                                               , MAX (tmp_all.UnitId) AS UnitId
                                               , STRING_AGG (DISTINCT Object_Unit.ValueData, '; ') AS UnitName
                                          FROM (SELECT DISTINCT
                                                       -- какой узел собирается
                                                       tmpReceiptGoods_all.GoodsId_to AS GoodsId
                                                       -- где собирается
                                                     , tmpReceiptGoods_all.UnitId
                                                FROM tmpReceiptGoods_all
                                                -- !!! не опция !!!
                                                --WHERE tmpReceiptGoods_all.isProdOptions = FALSE

                                               UNION
                                                SELECT DISTINCT
                                                       -- какой узел собирается
                                                       tmpReceiptGoods_all.GoodsId_child AS GoodsId
                                                       -- где собирается
                                                     , tmpReceiptGoods_all.UnitId_child AS UnitId
                                                FROM tmpReceiptGoods_all
                                                -- !!! ПФ !!!
                                                WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                               ) AS tmp_all
                                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp_all.UnitId
                                          GROUP BY tmp_all.GoodsId
                                         )

           -- найдем в каком ОДНОМ/ВСЕХ Узлах/Моделях лодки Детали/узлы участвуют в сборке, т.е. что собирается
         , tmpGoods_receipt AS (SELECT tmp.GoodsId_from AS GoodsId
                                     , tmp.GoodsId_receipt
                                     , Object_Goods.ValueData AS GoodsName_receipt
                                     , tmp.Name_all
                                FROM (SELECT tmpReceipt.GoodsId_from
                                           , MAX (tmpReceipt.GoodsId_to) AS GoodsId_receipt
                                           , STRING_AGG (DISTINCT Object_Goods.ValueData, ';') as Name_all
                                      FROM (-- сборка узлов
                                            SELECT tmpReceiptGoods_all.GoodsId_from  AS GoodsId_from
                                                 , tmpReceiptGoods_all.GoodsId_to    AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                            WHERE tmpReceiptGoods_all.GoodsId_to > 0
                                              -- !!!без ПФ!!!
                                              AND tmpReceiptGoods_all.GoodsId_child = 0
                                              --AND tmpReceiptGoods_all.ReceiptName ILIKE '%280%'

                                           -- сборка узлов - ПФ
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_from   AS GoodsId_from
                                                 , tmpReceiptGoods_all.GoodsId_child  AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                            WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                              --AND tmpReceiptGoods_all.ReceiptName ILIKE '%280%'

                                           -- сборка узлов - ПФ
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_child  AS GoodsId_from
                                                 , tmpReceiptGoods_all.GoodsId_to     AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                            WHERE tmpReceiptGoods_all.GoodsId_child > 0

                                           -- сборка моделей
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_from                AS GoodsId_from
                                                   -- какая модель собирается
                                                 , ObjectLink_ReceiptProdModel_Model.ChildObjectId AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                                                      ON ObjectLink_ReceiptProdModel_Model.ObjectId = tmpReceiptGoods_all.ReceiptId
                                                                     AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()
                                            WHERE tmpReceiptGoods_all.GoodsId_to = 0
                                              -- НЕ опция
                                              AND tmpReceiptGoods_all.isProdOptions = FALSE

                                           -- сборка Boat Structure
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_to              AS GoodsId_from
                                                   -- какая модель собирается
                                                 , ObjectLink_ColorPattern_Model.ChildObjectId AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                                 LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                                                                      ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = tmpReceiptGoods_all.ProdColorPatternId
                                                                     AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                                 LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                                                      ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                                                                     AND ObjectLink_ColorPattern_Model.DescId   = zc_ObjectLink_ColorPattern_Model()

                                            WHERE tmpReceiptGoods_all.ProdColorPatternId > 0
                                              -- !!!убрать, т.к. не все узлы в моделях сборки Лодки
                                              -- AND tmpReceiptGoods_all.GoodsId_from = 0

                                           ) AS tmpReceipt
                                           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReceipt.GoodsId_to
                                      GROUP BY tmpReceipt.GoodsId_from
                                      ) AS tmp
                                     INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId_receipt
                               )
     -- это узел (да/нет)
   , tmpReceiptGoods_find AS (-- какой узел собирается
                               SELECT DISTINCT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                               FROM tmpReceiptGoods_all

                              UNION
                               -- какой узел ПФ собирается
                               SELECT DISTINCT tmpReceiptGoods_all.GoodsId_child AS GoodsId
                               FROM tmpReceiptGoods_all
                               WHERE tmpReceiptGoods_all.isProdOptions = FALSE
                              )
          -- сборка (да/нет) - все из чего собирается + узлы
        , tmpReceiptGoods AS (-- все из чего собирается
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_from AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_from > 0
                             UNION
                              -- плюс узел ПФ
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_child AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                -- НЕ Опция
                                AND tmpReceiptGoods_all.isProdOptions = FALSE
                             UNION
                              -- плюс узел
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_to > 0
                             )
          , tmpListGoods AS (SELECT tmpReceiptGoods_all.GoodsId_from AS GoodsId
                             FROM tmpReceiptGoods_all
                            UNION
                             SELECT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                             FROM tmpReceiptGoods_all
                            UNION
                             SELECT tmpReceiptGoods_all.GoodsId_child AS GoodsId
                             FROM tmpReceiptGoods_all
                            )
       -- Результат
       SELECT
              tmpListGoods.GoodsId
              -- это узел (да/нет)
            , CASE WHEN tmpReceiptGoods_find.GoodsId > 0  THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods_group
              -- все из чего собирается + узлы
            , CASE WHEN tmpReceiptGoods.GoodsId > 0       THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
              -- Опция (да/нет) - Участвует в опциях
            , COALESCE (tmpReceiptGoods_all.isProdOptions, FALSE)                  :: Boolean AS isProdOptions

              -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
            , tmpGoods_receipt.GoodsId            :: Integer  AS GoodsId_receipt
              -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
            , tmpGoods_receipt.GoodsName_receipt  :: TVarChar AS GoodsName_receipt
              -- в каких ВСЕХ Узлах/Моделях лодки Детали/узлы участвуют в сборке, т.е. что собирается
            , tmpGoods_receipt.Name_all           :: TVarChar AS GoodsName_receipt_all

              -- На каком участке происходит расход Узла/Детали на сборку
            , tmpReceiptGoods_unit.UnitId         ::Integer  AS UnitId_receipt
            , tmpReceiptGoods_unit.UnitName       ::TVarChar AS UnitName_receipt
              -- На каком участке происходит расход Детали на сборку ПФ
            , tmpReceiptGoods_unit_child.UnitId   ::Integer  AS UnitId_child_receipt
            , tmpReceiptGoods_unit_child.UnitName ::TVarChar AS UnitName_child_receipt
              -- На каком участке происходит сборка Узла
            , tmpReceiptGoods_unit_parent.UnitId  ::Integer  AS UnitId_parent_receipt
            , tmpReceiptGoods_unit_parent.UnitName::TVarChar AS UnitName_parent_receipt

       FROM tmpListGoods
            -- это Опция (да/нет)
            LEFT JOIN tmpReceiptGoods_all ON tmpReceiptGoods_all.GoodsId_child = tmpListGoods.GoodsId
                                         AND tmpReceiptGoods_all.isProdOptions = TRUE
            -- это узел (да/нет)
            LEFT JOIN tmpReceiptGoods_find ON tmpReceiptGoods_find.GoodsId = tmpListGoods.GoodsId
            -- если Товар участвует в сборке
            LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpListGoods.GoodsId

            -- на сборку чего идет деталь
            LEFT JOIN tmpGoods_receipt ON tmpGoods_receipt.GoodsId = tmpListGoods.GoodsId

            -- где Детали/узлы участвуют в сборке Узла/Лодки
            LEFT JOIN tmpReceiptGoods_unit       ON tmpReceiptGoods_unit.GoodsId       = tmpListGoods.GoodsId
            LEFT JOIN tmpReceiptGoods_unit_child ON tmpReceiptGoods_unit_child.GoodsId = tmpListGoods.GoodsId
            -- найдем где собираются Узлы
            LEFT JOIN tmpReceiptGoods_unit_parent ON tmpReceiptGoods_unit_parent.GoodsId = tmpListGoods.GoodsId
           ;


ALTER TABLE Object_ReceiptGoods_find_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.23                                        *
*/

-- тест
-- SELECT * FROM Object_ReceiptGoods_find_View
