-- View: Object_ReceiptGoods_find_View

-- DROP VIEW IF EXISTS Object_ReceiptGoods_find_View;

CREATE OR REPLACE VIEW Object_ReceiptGoods_find_View AS
 WITH tmpReceiptGoods_all AS (-- ������ ������
                              SELECT ObjectLink_ReceiptProdModelChild_Object.ChildObjectId AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , 0 AS GoodsId_child
                                     -- �� �����
                                   , FALSE AS isProdOptions
                                     -- ��� ���������� �����
                                   , COALESCE (ObjectLink_Unit.ChildObjectId, 0) AS UnitId
                                     -- ��� ���������� ���� ��
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
                                                        -- ��� �������������
                                                        AND ObjectLink_ReceiptProdModelChild_Object.ChildObjectId > 0

                                   -- ��� ���������� �����
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                        ON ObjectLink_Unit.ObjectId = Object_ReceiptProdModel.Id
                                                       AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptProdModel_Unit()

                              WHERE Object_ReceiptProdModel.DescId   = zc_Object_ReceiptProdModel()
                                AND Object_ReceiptProdModel.isErased = FALSE

                             UNION ALL
                              -- ������ �����
                              SELECT -- �� ���� ����������
                                     COALESCE (ObjectLink_ReceiptGoodsChild_Object.ChildObjectId, 0)     AS GoodsId_from
                                     -- ����� ���� ����������
                                   , ObjectLink_ReceiptGoods_Object.ChildObjectId                        AS GoodsId_to
                                     -- ����� ���� �� ����������
                                   , COALESCE (ObjectLink_ReceiptGoodsChild_GoodsChild.ChildObjectId, 0) AS GoodsId_child
                                     -- �� �����
                                   , FALSE AS isProdOptions

                                     -- ��� ���������� ����
                                   , COALESCE (ObjectLink_Unit.ChildObjectId, 0)      AS UnitId
                                     -- ��� ���������� ���� ��
                                   , COALESCE (ObjectLink_UnitChild.ChildObjectId, 0) AS UnitId_child

                                   , Object_ReceiptGoods.Id        AS ReceiptId
                                   , Object_ReceiptGoods.ValueData AS ReceiptName

                                     -- Boat Structure
                                   , COALESCE (ObjectLink_ReceiptGoodsChild_ProdColorPattern.ChildObjectId, 0) AS ProdColorPatternId

                              FROM Object AS Object_ReceiptGoods
                                   -- ����� ���� ����������
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                         ON ObjectLink_ReceiptGoods_Object.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()

                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                         ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                   INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                AND Object_ReceiptGoodsChild.isErased = FALSE
                                   -- ��� �������������
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                                        ON ObjectLink_ReceiptGoodsChild_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()

                                   -- Boat Structure
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ProdColorPattern
                                                        ON ObjectLink_ReceiptGoodsChild_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

                                   -- ����� ���� �� ����������
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_GoodsChild
                                                        ON ObjectLink_ReceiptGoodsChild_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

                                   -- ��� ���������� ����
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                        ON ObjectLink_Unit.ObjectId = Object_ReceiptGoods.Id
                                                       AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptGoods_Unit()
                                   -- ��� ���������� ���� ��
                                   LEFT JOIN ObjectLink AS ObjectLink_UnitChild
                                                        ON ObjectLink_UnitChild.ObjectId = Object_ReceiptGoods.Id
                                                       AND ObjectLink_UnitChild.DescId   = zc_ObjectLink_ReceiptGoods_UnitChild()

                              WHERE Object_ReceiptGoods.DescId   = zc_Object_ReceiptGoods()
                                AND Object_ReceiptGoods.isErased = FALSE
                                -- ���� ������������� ��� Boat Structure
                                AND (ObjectLink_ReceiptGoodsChild_Object.ChildObjectId > 0 OR ObjectLink_ReceiptGoodsChild_ProdColorPattern.ChildObjectId > 0)

                             UNION ALL
                              -- �����
                              SELECT
                                     0 AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , ObjectLink_ProdOptions_Goods.ChildObjectId AS GoodsId_child
                                     -- �����
                                   , TRUE AS isProdOptions
                                     -- ��� ���������� ...
                                     --, 0 AS UnitId
                                   , MAX (Object_ProdOptions.Id) AS UnitId
                                     -- ��� ���������� ���� ��
                                   , 0 AS UnitId_child

                                   , 0  AS ReceiptId
                                   , '' AS ReceiptName
                                   , 0  AS ProdColorPatternId

                              FROM Object AS Object_ProdOptions
                                   INNER JOIN ObjectLink AS ObjectLink_ProdOptions_Goods
                                                         ON ObjectLink_ProdOptions_Goods.ObjectId = Object_ProdOptions.Id
                                                        AND ObjectLink_ProdOptions_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()
                                                        -- ��� �������������
                                                        AND ObjectLink_ProdOptions_Goods.ChildObjectId > 0

                                   -- Boat Structure
                                   LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_ProdColorPattern
                                                        ON ObjectLink_ProdOptions_ProdColorPattern.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_ProdOptions_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()


                              WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                                AND Object_ProdOptions.isErased = FALSE
                                -- �� Boat Structure
                                AND ObjectLink_ProdOptions_ProdColorPattern.ChildObjectId IS NULL
                              GROUP BY ObjectLink_ProdOptions_Goods.ChildObjectId
                             )
           -- ������ ��� ������/���� ��������� � ������ ����/����� - ��� ��
         , tmpReceiptGoods_unit AS (--
                                    SELECT tmp_all.GoodsId
                                         , MAX (tmp_all.UnitId) AS UnitId
                                         , STRING_AGG (DISTINCT Object_Unit.ValueData, '; ') AS UnitName
                                    FROM (SELECT DISTINCT
                                                 -- �� ���� ����������
                                                 tmpReceiptGoods_all.GoodsId_from AS GoodsId
                                                 -- ��� ����������
                                               , tmpReceiptGoods_all.UnitId
                                          FROM tmpReceiptGoods_all
                                          -- !!! ��� �� !!!
                                          WHERE tmpReceiptGoods_all.GoodsId_child = 0
                                            -- ������ �����
                                            AND tmpReceiptGoods_all.GoodsId_from NOT IN (SELECT tmpReceiptGoods_all.GoodsId_child FROM tmpReceiptGoods_all)

                                         -- ���� ����-�� - ��� ���������� ����
                                         UNION
                                          SELECT DISTINCT
                                                 -- ��
                                                 tmpReceiptGoods_all.GoodsId_child AS GoodsId
                                                 -- ��� ����������
                                               , tmpReceiptGoods_all.UnitId
                                          FROM tmpReceiptGoods_all
                                          -- !!! �� !!!
                                          WHERE tmpReceiptGoods_all.GoodsId_child > 0

                                         -- ���� ���� (������� ��� � ReceiptProdModel) - �� ������� ������ �������� - ����� ���������� �����
                                         UNION
                                          SELECT DISTINCT
                                                 -- ����
                                                 tmpReceiptGoods_all.GoodsId_to AS GoodsId
                                                 -- ��� �� ���� ���������� �����
                                               , 33347 AS UnitId
                                          FROM tmpReceiptGoods_all
                                          WHERE tmpReceiptGoods_all.GoodsId_to > 0
                                            -- ������ �����
                                            AND tmpReceiptGoods_all.GoodsId_to NOT IN (SELECT tmpReceiptGoods_all.GoodsId_child FROM tmpReceiptGoods_all)


                                         -- ���� ����� - �� ������� ������ �������� - ����� ���������� �����
                                         UNION
                                          SELECT DISTINCT
                                                 -- �����
                                                 tmpReceiptGoods_all.GoodsId_child AS GoodsId
                                                 -- ��� �� ���� ���������� �����
                                                 --, 33347 AS UnitId -- ������� ������ ��������
                                               , tmpReceiptGoods_all.UnitId
                                          FROM tmpReceiptGoods_all
                                          -- !!! ����� !!!
                                          WHERE tmpReceiptGoods_all.isProdOptions = TRUE

                                         ) AS tmp_all
                                         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp_all.UnitId
                                    GROUP BY tmp_all.GoodsId
                                    )
           -- ������ ��� ������ ��������� � ������ ����-��
         , tmpReceiptGoods_unit_child AS (--
                                          SELECT tmp_all.GoodsId
                                               , MAX (tmp_all.UnitId_child) AS UnitId
                                               , STRING_AGG (DISTINCT Object_Unit.ValueData, '; ') AS UnitName
                                          FROM (SELECT DISTINCT
                                                       -- �� ���� ����������
                                                       tmpReceiptGoods_all.GoodsId_from AS GoodsId
                                                       -- ��� ����������
                                                     , tmpReceiptGoods_all.UnitId_child
                                                FROM tmpReceiptGoods_all
                                                -- !!! �� !!!
                                                WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                               ) AS tmp_all
                                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp_all.UnitId_child
                                          GROUP BY tmp_all.GoodsId
                                         )
           -- ������ ��� ���������� ��� ����
         , tmpReceiptGoods_unit_parent AS (--
                                          SELECT tmp_all.GoodsId
                                               , MAX (tmp_all.UnitId) AS UnitId
                                               , STRING_AGG (DISTINCT Object_Unit.ValueData, '; ') AS UnitName
                                          FROM (SELECT DISTINCT
                                                       -- ����� ���� ����������
                                                       tmpReceiptGoods_all.GoodsId_to AS GoodsId
                                                       -- ��� ����������
                                                     , tmpReceiptGoods_all.UnitId
                                                FROM tmpReceiptGoods_all
                                                -- !!! �� ����� !!!
                                                --WHERE tmpReceiptGoods_all.isProdOptions = FALSE

                                               UNION
                                                SELECT DISTINCT
                                                       -- ����� ���� ����������
                                                       tmpReceiptGoods_all.GoodsId_child AS GoodsId
                                                       -- ��� ����������
                                                     , tmpReceiptGoods_all.UnitId_child AS UnitId
                                                FROM tmpReceiptGoods_all
                                                -- !!! �� !!!
                                                WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                               ) AS tmp_all
                                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp_all.UnitId
                                          GROUP BY tmp_all.GoodsId
                                         )

           -- ������ � ����� �����/���� �����/������� ����� ������/���� ��������� � ������, �.�. ��� ����������
         , tmpGoods_receipt AS (SELECT tmp.GoodsId_from AS GoodsId
                                     , tmp.GoodsId_receipt
                                     , Object_Goods.ValueData AS GoodsName_receipt
                                     , tmp.Name_all
                                FROM (SELECT tmpReceipt.GoodsId_from
                                           , MAX (tmpReceipt.GoodsId_to) AS GoodsId_receipt
                                           , STRING_AGG (DISTINCT Object_Goods.ValueData, ';') as Name_all
                                      FROM (-- ������ �����
                                            SELECT tmpReceiptGoods_all.GoodsId_from  AS GoodsId_from
                                                 , tmpReceiptGoods_all.GoodsId_to    AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                            WHERE tmpReceiptGoods_all.GoodsId_to > 0
                                              -- !!!��� ��!!!
                                              AND tmpReceiptGoods_all.GoodsId_child = 0
                                              --AND tmpReceiptGoods_all.ReceiptName ILIKE '%280%'

                                           -- ������ ����� - ��
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_from   AS GoodsId_from
                                                 , tmpReceiptGoods_all.GoodsId_child  AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                            WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                              --AND tmpReceiptGoods_all.ReceiptName ILIKE '%280%'

                                           -- ������ ����� - ��
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_child  AS GoodsId_from
                                                 , tmpReceiptGoods_all.GoodsId_to     AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                            WHERE tmpReceiptGoods_all.GoodsId_child > 0

                                           -- ������ �������
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_from                AS GoodsId_from
                                                   -- ����� ������ ����������
                                                 , ObjectLink_ReceiptProdModel_Model.ChildObjectId AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                                                      ON ObjectLink_ReceiptProdModel_Model.ObjectId = tmpReceiptGoods_all.ReceiptId
                                                                     AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()
                                            WHERE tmpReceiptGoods_all.GoodsId_to = 0
                                              -- �� �����
                                              AND tmpReceiptGoods_all.isProdOptions = FALSE

                                           -- ������ Boat Structure
                                           UNION
                                            SELECT tmpReceiptGoods_all.GoodsId_to              AS GoodsId_from
                                                   -- ����� ������ ����������
                                                 , ObjectLink_ColorPattern_Model.ChildObjectId AS GoodsId_to
                                            FROM tmpReceiptGoods_all
                                                 LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                                                                      ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = tmpReceiptGoods_all.ProdColorPatternId
                                                                     AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                                 LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                                                      ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                                                                     AND ObjectLink_ColorPattern_Model.DescId   = zc_ObjectLink_ColorPattern_Model()

                                            WHERE tmpReceiptGoods_all.ProdColorPatternId > 0
                                              -- !!!������, �.�. �� ��� ���� � ������� ������ �����
                                              -- AND tmpReceiptGoods_all.GoodsId_from = 0

                                           ) AS tmpReceipt
                                           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReceipt.GoodsId_to
                                      GROUP BY tmpReceipt.GoodsId_from
                                      ) AS tmp
                                     INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId_receipt
                               )
     -- ��� ���� (��/���)
   , tmpReceiptGoods_find AS (-- ����� ���� ����������
                               SELECT DISTINCT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                               FROM tmpReceiptGoods_all

                              UNION
                               -- ����� ���� �� ����������
                               SELECT DISTINCT tmpReceiptGoods_all.GoodsId_child AS GoodsId
                               FROM tmpReceiptGoods_all
                               WHERE tmpReceiptGoods_all.isProdOptions = FALSE
                              )
          -- ������ (��/���) - ��� �� ���� ���������� + ����
        , tmpReceiptGoods AS (-- ��� �� ���� ����������
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_from AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_from > 0
                             UNION
                              -- ���� ���� ��
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_child AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_child > 0
                                -- �� �����
                                AND tmpReceiptGoods_all.isProdOptions = FALSE
                             UNION
                              -- ���� ����
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
       -- ���������
       SELECT
              tmpListGoods.GoodsId
              -- ��� ���� (��/���)
            , CASE WHEN tmpReceiptGoods_find.GoodsId > 0  THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods_group
              -- ��� �� ���� ���������� + ����
            , CASE WHEN tmpReceiptGoods.GoodsId > 0       THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
              -- ����� (��/���) - ��������� � ������
            , COALESCE (tmpReceiptGoods_all.isProdOptions, FALSE)                  :: Boolean AS isProdOptions

              -- � ����� ����� ����/������ ����� ������/���� ��������� � ������, �.�. ��� ����������
            , tmpGoods_receipt.GoodsId            :: Integer  AS GoodsId_receipt
              -- � ����� ����� ����/������ ����� ������/���� ��������� � ������, �.�. ��� ����������
            , tmpGoods_receipt.GoodsName_receipt  :: TVarChar AS GoodsName_receipt
              -- � ����� ���� �����/������� ����� ������/���� ��������� � ������, �.�. ��� ����������
            , tmpGoods_receipt.Name_all           :: TVarChar AS GoodsName_receipt_all

              -- �� ����� ������� ���������� ������ ����/������ �� ������
            , tmpReceiptGoods_unit.UnitId         ::Integer  AS UnitId_receipt
            , tmpReceiptGoods_unit.UnitName       ::TVarChar AS UnitName_receipt
              -- �� ����� ������� ���������� ������ ������ �� ������ ��
            , tmpReceiptGoods_unit_child.UnitId   ::Integer  AS UnitId_child_receipt
            , tmpReceiptGoods_unit_child.UnitName ::TVarChar AS UnitName_child_receipt
              -- �� ����� ������� ���������� ������ ����
            , tmpReceiptGoods_unit_parent.UnitId  ::Integer  AS UnitId_parent_receipt
            , tmpReceiptGoods_unit_parent.UnitName::TVarChar AS UnitName_parent_receipt

       FROM tmpListGoods
            -- ��� ����� (��/���)
            LEFT JOIN tmpReceiptGoods_all ON tmpReceiptGoods_all.GoodsId_child = tmpListGoods.GoodsId
                                         AND tmpReceiptGoods_all.isProdOptions = TRUE
            -- ��� ���� (��/���)
            LEFT JOIN tmpReceiptGoods_find ON tmpReceiptGoods_find.GoodsId = tmpListGoods.GoodsId
            -- ���� ����� ��������� � ������
            LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpListGoods.GoodsId

            -- �� ������ ���� ���� ������
            LEFT JOIN tmpGoods_receipt ON tmpGoods_receipt.GoodsId = tmpListGoods.GoodsId

            -- ��� ������/���� ��������� � ������ ����/�����
            LEFT JOIN tmpReceiptGoods_unit       ON tmpReceiptGoods_unit.GoodsId       = tmpListGoods.GoodsId
            LEFT JOIN tmpReceiptGoods_unit_child ON tmpReceiptGoods_unit_child.GoodsId = tmpListGoods.GoodsId
            -- ������ ��� ���������� ����
            LEFT JOIN tmpReceiptGoods_unit_parent ON tmpReceiptGoods_unit_parent.GoodsId = tmpListGoods.GoodsId
           ;


ALTER TABLE Object_ReceiptGoods_find_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.12.23                                        *
*/

-- ����
-- SELECT * FROM Object_ReceiptGoods_find_View
