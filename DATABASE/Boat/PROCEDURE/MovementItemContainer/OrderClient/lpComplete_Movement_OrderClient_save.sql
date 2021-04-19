DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderClient(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
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
  DECLARE vbProductId   Integer;
  DECLARE vbPartionId_1 Integer;
  DECLARE vbPartionId_2 Integer;
BEGIN

     -- ����� �����
     vbProductId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product());

     -- ������� - �������� ���������, �� ����� ����������
     CREATE TEMP TABLE _tmpItem_all (ObjectId_parent_find Integer, ObjectId_parent Integer, ObjectId Integer
                                   , ProdOptionsId Integer
                                   , ColorPatternId Integer
                                   , ProdColorPatternId  Integer
                                   , ProdColorName TVarChar
                                   , OperCount_parent TFloat, OperCount TFloat
                                   , OperPrice TFloat
                                    ) ON COMMIT DROP;
     -- ������� - �������� ���������, �� �������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer
                               , ObjectId_parent_find Integer, ObjectId_parent Integer, ObjectId Integer, PartionId Integer
                               , ProdOptionsId Integer
                               , ColorPatternId Integer
                               , ProdColorPatternId  Integer
                               , ProdColorName TVarChar
                               , OperCount TFloat
                               , OperCountPartner TFloat
                               , OperPrice TFloat
                                ) ON COMMIT DROP;

     -- �������� ���������
     WITH -- ����� + ������ � ������
          tmpProduct AS (SELECT vbProductId                                            AS ProductId
                              , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId
                              , CASE WHEN ObjectLink_Product_Model.ChildObjectId = ObjectLink_ReceiptProdModel_Model.ChildObjectId THEN ObjectLink_Product_Model.ChildObjectId ELSE 0 END AS ModelId
                                -- !!!��������� �� � ��������� ��� ������� ������������!!
                              , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) AS isBasicConf
                         FROM -- ������
                              ObjectLink AS ObjectLink_Product_Model
                              -- ������ ������ ������
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                   ON ObjectLink_ReceiptProdModel.ObjectId = vbProductId
                                                  AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
                              -- ��� ��� ������, ��� ��������
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                                   ON ObjectLink_ReceiptProdModel_Model.ObjectId = ObjectLink_ReceiptProdModel.ChildObjectId
                                                  AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                                      ON ObjectBoolean_BasicConf.ObjectId = vbProductId
                                                     AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()

                         WHERE ObjectLink_Product_Model.ObjectId = vbProductId
                           AND ObjectLink_Product_Model.DescId   = zc_ObjectLink_Product_Model()
                        )
          -- ��� �������� ������ ������ - ����� ��� ����
        , tmpReceiptProdModelChild_all AS (SELECT tmpProduct.ProductId   AS ProductId
                                                , tmpProduct.ModelId     AS ModelId
                                                , tmpProduct.isBasicConf AS isBasicConf
                                                  --
                                                , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                                  -- !!!������ - ��������� ������ ��� ������
                                                , CASE WHEN lpSelect.ObjectId_parent <> COALESCE (lpSelect.ObjectId, 0) THEN lpSelect.ObjectId_parent ELSE 0 END AS ObjectId_parent
                                                  -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                                , lpSelect.ObjectId
                                                  -- ��������
                                                , lpSelect.Value_parent
                                                  -- �������� - �������
                                                , lpSelect.Value
                                                  -- ���� ��. ��� ��� - �������
                                                , lpSelect.EKPrice
                                                  --
                                                , lpSelect.ProdColorPatternId
                                                , lpSelect.ProdOptionsId

                                           FROM lpSelect_Object_ReceiptProdModelChild_detail (inUserId) AS lpSelect
                                                JOIN tmpProduct ON tmpProduct.ReceiptProdModelId = lpSelect.ReceiptProdModelId
                                          )
        -- ������������ �������� ProdOptItems - � �����
      , tmpProdOptItems AS (SELECT lpSelect.ProductId
                                 , tmpProduct.ModelId
                                 , lpSelect.ProdOptionsId
                                 , lpSelect.ProdColorPatternId
                                 , lpSelect.GoodsId
                                   --
                                 , lpSelect.AmountBasis
                                 , lpSelect.Amount
                                 , lpSelect.EKPrice

                            FROM gpSelect_Object_ProdOptItems (inIsShowAll:= FALSE
                                                             , inIsErased := FALSE
                                                             , inIsSale   := TRUE
                                                             , inSession  := inUserId :: TVarChar
                                                              ) AS lpSelect
                                 JOIN tmpProduct ON tmpProduct.ProductId = lpSelect.ProductId
                            WHERE lpSelect.MovementId_OrderClient = inMovementId
                           )

     -- ������������ �������� ProdColorItems - � ����� (����� Boat Structure)
   , tmpProdColorItems AS (SELECT ObjectLink_Product.ChildObjectId          AS ProductId
                                , ObjectLink_Goods.ChildObjectId            AS GoodsId
                                , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
                                  -- ����� ���� (����� ��� GoodsId)
                                , CASE WHEN TRIM (ObjectString_Comment.ValueData) <> '' THEN TRIM (ObjectString_Comment.ValueData) ELSE TRIM (COALESCE (ObjectString_ProdColorPattern_Comment.ValueData, '')) END AS ProdColorName

                           FROM Object AS Object_ProdColorItems
                                -- �����
                                INNER JOIN ObjectLink AS ObjectLink_Product
                                                      ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                     AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
                                -- ����� �������
                                INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                       ON ObjectFloat_MovementId_OrderClient.ObjectId = Object_ProdColorItems.Id
                                                      AND ObjectFloat_MovementId_OrderClient.DescId   = zc_ObjectFloat_ProdColorItems_OrderClient()
                                                      AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId

                                -- ����� ����, ���� ���� ��������� ��� ����� (����� ��� GoodsId)
                                LEFT JOIN ObjectString AS ObjectString_Comment
                                                       ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                                      AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorItems_Comment()

                                -- ���� ������ �� ������ �����, �� ��� ��� � ReceiptGoodsChild
                                LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                                    AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
                                -- �������
                                LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                     ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                                    AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                -- ����� ���� �� Boat Structure (����� ��� GoodsId)
                                LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                                       ON ObjectString_ProdColorPattern_Comment.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                      AND ObjectString_ProdColorPattern_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()

                           WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                             AND Object_ProdColorItems.isErased = FALSE
                          )
                  -- ������������� - � �����
                , tmpRes AS (-- 1. ������� - ���
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
                                    -- ���� Goods ���� �����
                                  , CASE WHEN tmpProdColorItems.ProdColorPatternId > 0 THEN tmpProdColorItems.GoodsId ELSE lpSelect.ObjectId END AS ObjectId
                                    --
                                  , lpSelect.ProdColorPatternId
                                    -- ������ ���� �� ����� ��� �����
                                  , tmpProdOptItems.ProdOptionsId

                                  , tmpProdColorItems.ProdColorName

                             FROM tmpReceiptProdModelChild_all AS lpSelect
                                  LEFT JOIN tmpProdColorItems ON tmpProdColorItems.ProductId          = lpSelect.ProductId
                                                             AND tmpProdColorItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                  LEFT JOIN tmpProdOptItems ON tmpProdOptItems.ProductId          = lpSelect.ProductId
                                                           AND tmpProdOptItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                                           AND tmpProdOptItems.ProdColorPatternId > 0
                             WHERE -- !!!���� ��������� � ��������� ��� ������� ������������!!
                                   lpSelect.isBasicConf = TRUE
                               OR -- ��� ��������� ��� ���������
                                   tmpProdColorItems.ProdColorPatternId > 0

                            UNION ALL
                             -- 2. �����
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
                                    --
                                  , lpSelect.ProdOptionsId

                                  , '' AS ProdColorName

                             FROM tmpProdOptItems AS lpSelect
                             -- ��� ���� ���������
                             WHERE COALESCE (lpSelect.ProdColorPatternId, 0) = 0
                            )
     -- ���������
     INSERT INTO _tmpItem_all (ObjectId_parent_find, ObjectId_parent, ObjectId, ProdOptionsId, ColorPatternId, ProdColorPatternId, ProdColorName, OperCount_parent, OperCount, OperPrice)
        SELECT 0 AS ObjectId_parent_find
             , tmpRes.ObjectId_parent
             , tmpRes.ObjectId
               --
             , tmpRes.ProdOptionsId
             , ObjectLink_ColorPattern.ChildObjectId AS ColorPatternId
             , tmpRes.ProdColorPatternId
             , tmpRes.ProdColorName
             , tmpRes.OperCount_parent
             , tmpRes.OperCount
             , tmpRes.OperPrice
        FROM tmpRes
             -- ������ Boat Structure
             LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = tmpRes.ProdColorPatternId
                                 AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
        ;


     -- ������� ObjectId_parent ��� Boat Structure
     UPDATE _tmpItem_all SET ObjectId_parent_find = _tmpItem_find.ObjectId_parent_find
     FROM (WITH -- ������ ������ ���� - �������� Boat Structure
                tmpReceiptItems AS (SELECT Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                                         , ObjectLink_ReceiptGoods.ChildObjectId           AS ReceiptGoodsId
                                           -- ����
                                         , ObjectLink_Goods.ChildObjectId                  AS ObjectId_parent
                                           -- ���� ������ �� ������ �����, �� ��� ��� � Boat Structure
                                         , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                           -- ������� Boat Structure
                                         , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
                                           -- ������ Boat Structure
                                         , ObjectLink_ColorPattern.ChildObjectId           AS ColorPatternId
                                           -- ����
                                         , COALESCE (ObjectString_Comment.ValueData, '')   AS ProdColorName

                                    FROM Object AS Object_ReceiptGoodsChild
                                         INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                               ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                              AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                                              -- !!!���� ��� Boat Structure
                                                              AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                                         -- ������ ������ ����
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                              ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                         -- ����
                                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                              ON ObjectLink_Goods.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                             AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                                         -- ������������
                                         LEFT JOIN ObjectLink AS ObjectLink_Object
                                                              ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                         -- ����
                                         LEFT JOIN ObjectString AS ObjectString_Comment
                                                                ON ObjectString_Comment.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                               AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()
                                         -- ������ Boat Structure
                                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                              ON ObjectLink_ColorPattern.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                             AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()

                                    WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                      AND Object_ReceiptGoodsChild.isErased = FALSE
                                    ORDER BY ObjectLink_ColorPattern.ChildObjectId, ObjectLink_Goods.ChildObjectId
                                           , COALESCE (ObjectLink_Object.ChildObjectId, -1) DESC, COALESCE (ObjectString_Comment.ValueData, '')
                                   )
                -- ������������ ������
              , tmpList_from AS (SELECT _tmpItem.ColorPatternId
                                      , _tmpItem.ObjectId_parent
                                      , STRING_AGG (CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId :: TVarChar ELSE _tmpItem.ProdColorName END, ';') AS Key_Id
                                 FROM -- ������� �������������
                                      (SELECT * FROM _tmpItem_all AS _tmpItem ORDER BY _tmpItem.ColorPatternId, _tmpItem.ObjectId_parent
                                                                                     , COALESCE (_tmpItem.ObjectId, -1) DESC, _tmpItem.ProdColorName
                                      ) AS _tmpItem
                                 GROUP BY _tmpItem.ColorPatternId
                                        , _tmpItem.ObjectId_parent
                                )
                  -- � ���� ������ ����� ������
                , tmpList_to AS (SELECT tmpReceiptItems.ColorPatternId
                                      , tmpReceiptItems.ObjectId_parent
                                      , STRING_AGG (CASE WHEN tmpReceiptItems.ObjectId > 0 THEN tmpReceiptItems.ObjectId :: TVarChar ELSE tmpReceiptItems.ProdColorName END, ';') AS Key_Id
                                 FROM tmpReceiptItems
                                 GROUP BY tmpReceiptItems.ColorPatternId
                                        , tmpReceiptItems.ObjectId_parent
                                )
           -- ���������
           SELECT tmpList_from.ColorPatternId
                , tmpList_from.ObjectId_parent
                  -- ����� ����� ���� � ����� ����������
                , COALESCE (tmpList_to.ObjectId_parent, 0) AS ObjectId_parent_find
           FROM tmpList_from
                LEFT JOIN tmpList_to ON tmpList_to.ColorPatternId = tmpList_from.ColorPatternId
                                    AND tmpList_to.Key_Id         = tmpList_from.Key_Id
          ) AS _tmpItem_find
     WHERE _tmpItem_all.ProdColorPatternId > 0
       AND _tmpItem_all.ColorPatternId     = _tmpItem_find.ColorPatternId
       AND _tmpItem_all.ObjectId_parent    = _tmpItem_find.ObjectId_parent
    ;


    -- !!!�������� - ������� ��������� ObjectId_parent, ���� �� Boat Structure - ���� ���� ����� ��� ������������ ����������!!!
    UPDATE _tmpItem_all SET ObjectId_parent_find = tmp.ObjectId_parent_find
    FROM (SELECT DISTINCT _tmpItem.ObjectId_parent, _tmpItem.ObjectId_parent_find FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find > 0) AS tmp
    WHERE _tmpItem_all.ObjectId_parent_find = 0
      AND _tmpItem_all.ObjectId_parent      = tmp.ObjectId_parent
     ;


    -- ��������
    IF EXISTS (SELECT 1
               FROM _tmpItem_all AS _tmpItem
                   JOIN _tmpItem_all AS _tmpItem_find
                                     ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                     AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
               WHERE _tmpItem.ObjectId_parent > 0
              )
    --AND 1=0
    THEN
        RAISE EXCEPTION '������-1.�� � ���� ��������� ���������� ObjectId_parent_find.<%> <%> <%> <%>'
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
    -- ��������
    IF EXISTS (SELECT 1 FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0)
    --AND 1=0
    THEN
        RAISE EXCEPTION '������.�� ������ ������ ��� <%>. ��� ����� ���������: <%> ����� �� ������� <%> ��.'
                                    , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent) FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0) AS _tmpItem LIMIT 1)
                                    , (SELECT lfGet_Object_ValueData (_tmpItem.ColorPatternId)
                                            || ' : ' || STRING_AGG (CASE WHEN _tmpItem.ObjectId > 0 THEN COALESCE (Object_ProdColor.ValueData, lfGet_Object_ValueData_sh (_tmpItem.ObjectId)) ELSE _tmpItem.ProdColorName END, ';') AS Key_Id
                                       FROM -- ������� �������������
                                            (SELECT * FROM _tmpItem_all AS _tmpItem
                                             WHERE _tmpItem.ObjectId_parent = (SELECT MIN (_tmpItem.ObjectId_parent) FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0)
                                               AND _tmpItem.ProdColorPatternId > 0
                                             ORDER BY _tmpItem.ColorPatternId
                                                    , COALESCE (_tmpItem.ObjectId, -1) DESC, _tmpItem.ProdColorName
                                            ) AS _tmpItem
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                                 ON ObjectLink_Goods_ProdColor.ObjectId = _tmpItem.ObjectId
                                                                AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                                       GROUP BY _tmpItem.ColorPatternId
                                      )
                                    , (SELECT COUNT(*) FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem_all AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0) AS _tmpItem);
    END IF;


    -- !!!�������� ���������, �� �������!!!
    WITH -- ���������� �� ����� - ���� ����
         tmpRes_group AS   (SELECT CASE WHEN tmpRes.ObjectId_parent_find > 0 THEN tmpRes.ObjectId_parent_find  WHEN tmpRes.ObjectId_parent > 0 THEN tmpRes.ObjectId_parent  ELSE tmpRes.ObjectId  END AS ObjectId
                                 , CASE WHEN tmpRes.ObjectId_parent_find > 0 THEN tmpRes.OperCount_parent      WHEN tmpRes.ObjectId_parent > 0 THEN tmpRes.ObjectId_parent  ELSE tmpRes.OperCount END AS OperCount
                             FROM _tmpItem_all AS tmpRes
                                  -- ����� ������ - ��������� ����� ��������
                                  LEFT JOIN Object ON Object.Id = tmpRes.ObjectId

                             WHERE COALESCE (tmpRes.ObjectId_parent, 0) = 0
                               OR (tmpRes.ObjectId_parent > 0 AND Object.DescId = zc_Object_ReceiptService())
                            )
            -- ������������ �������
          , tmpOrderClient AS (SELECT MovementItem.PartionId
                                    , SUM (MovementItem.Amount) AS Amount
                               FROM Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Child()
                                                           AND MovementItem.isErased   = FALSE
                               WHERE Movement.DescId   = zc_Movement_OrderClient()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                               GROUP BY MovementItem.PartionId
                              )
        -- �� ������� ������ �������
      , tmpContainer_all AS (SELECT Container.Id        AS Id
                                  , Container.PartionId AS PartionId
                                  , Container.ObjectId  AS ObjectId
                                  , Container.Amount - COALESCE (tmpOrderClient.Amount, 0) AS Amount
                             FROM Container
                                  LEFT JOIN tmpOrderClient ON tmpOrderClient.PartionId = Container.PartionId
                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.Amount - COALESCE (tmpOrderClient.Amount, 0) > 0
                               -- ���������� ��������
                               AND Container.ObjectId IN (SELECT tmpRes_group.ObjectId FROM tmpRes_group)
                               -- !!! �������� ��� �������
                               AND NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())

                            )
            -- ������������� ������ - �������� �� �������
          , tmpContainer AS (SELECT Container.Id           AS ContainerId
                                  , Container.PartionId    AS PartionId
                                  , Container.ObjectId     AS ObjectId
                                  , Container.Amount       AS ContainerAmount
                                  , tmpRes_group.OperCount AS OperCount
                                  , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId
                                                                 ORDER BY Object_PartionGoods.OperDate ASC, Container.Id ASC
                                                                ) AS ContainerAmountSUM
                             FROM tmpContainer_all AS Container
                                  LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                  LEFT JOIN tmpRes_group ON tmpRes_group.ObjectId = Container.ObjectId
                            )
            -- ������� �� �������
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
     -- ���������
     INSERT INTO _tmpItem (ContainerId_Goods, ObjectId_parent_find, ObjectId_parent, ObjectId, PartionId, ProdOptionsId, ColorPatternId, ProdColorPatternId, ProdColorName, OperCount, OperCountPartner, OperPrice)
        SELECT tmpRes_partion.ContainerId
             , tmpRes.ObjectId_parent_find
             , tmpRes.ObjectId_parent
               -- ��������!!
             , COALESCE (tmpRes_partion.ObjectId, tmpRes.ObjectId) AS ObjectId
               -- �����!!
             , tmpRes_partion.PartionId
               --
             , tmpRes.ProdOptionsId
             , tmpRes.ColorPatternId
             , tmpRes.ProdColorPatternId
             , tmpRes.ProdColorName
               -- �����!!
             , COALESCE (tmpRes_partion.OperCount, 0) AS OperCount
               -- 
             , CASE WHEN tmpRes.ObjectId_parent > 0 AND tmpRes_partion.OperCount > 0
                         -- ���� ����� ���� + ����� �������, ����� ����� ����������
                         THEN 0
                    ELSE -- ��� ������ �������� ������� �� �������
                         tmpRes.OperCount - COALESCE (tmpRes_partion_total.OperCount, 0)
               END AS OperCountPartner
                    
               -- ����� ��� ����
             , COALESCE (ObjectFloat_EKPrice.ValueData, tmpRes.OperPrice) AS OperPrice

        FROM _tmpItem_all AS tmpRes
             LEFT JOIN tmpRes_partion ON tmpRes_partion.ObjectId = CASE WHEN tmpRes.ObjectId_parent_find > 0 THEN tmpRes.ObjectId_parent_find
                                                                        WHEN tmpRes.ObjectId_parent      > 0 THEN tmpRes.ObjectId_parent
                                                                        ELSE tmpRes.ObjectId
                                                                   END
             -- ���� ��� ������, ���� ����� ������� ����
             LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                   ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                  AND ObjectFloat_EKPrice.ObjectId = CASE WHEN tmpRes.ObjectId_parent_find > 0 THEN tmpRes.ObjectId_parent_find
                                                                          WHEN tmpRes.ObjectId_parent      > 0 THEN tmpRes.ObjectId_parent
                                                                          ELSE tmpRes.ObjectId
                                                                     END
                                  -- !!!���� ����� �������!!!
                                  AND tmpRes_partion.OperCount     > 0

             -- ���� � �������� ���� ������� ����, ��������� ����� ��������
             LEFT JOIN tmpRes_partion AS tmpRes_partion_find ON tmpRes_partion_find.ObjectId = CASE WHEN tmpRes.ObjectId_parent_find > 0 THEN tmpRes.ObjectId_parent_find
                                                                                                    WHEN tmpRes.ObjectId_parent      > 0 THEN tmpRes.ObjectId_parent
                                                                                               END

             -- ����� �� �������, � ������� �� ������� - ����� � ����������
             LEFT JOIN (SELECT tmpRes_partion.ObjectId, SUM (tmpRes_partion.OperCount) AS OperCount FROM tmpRes_partion GROUP BY tmpRes_partion.ObjectId
                       ) AS tmpRes_partion_total ON tmpRes_partion_total.ObjectId = tmpRes.ObjectId
                                                -- ��� ����� �� ����
                                                AND tmpRes.ObjectId_parent        = 0

             -- ����� ������ - ��������� ����� ��������
             LEFT JOIN Object ON Object.Id = tmpRes.ObjectId

        WHERE tmpRes_partion_find.ObjectId IS NULL
           OR Object.DescId = zc_Object_ReceiptService()
        ;


    -- ��������
    IF EXISTS (SELECT 1
               FROM _tmpItem
                   JOIN _tmpItem AS _tmpItem_find
                                 ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                 AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
               WHERE _tmpItem.ObjectId_parent > 0
              )
    --AND 1=0
    THEN
        RAISE EXCEPTION '������-2.�� � ���� ��������� ���������� ObjectId_parent.';
    END IF;


    -- ������� ��� �������
    PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Child()
      AND MovementItem.isErased   = FALSE
    ;

    -- ��������� ������
    PERFORM lpInsertUpdate_MI_OrderClient_Child (ioId                  := 0
                                               , inMovementId          := inMovementId
                                               , inPartionId           := _tmpItem.PartionId
                                               , inObjectId            := _tmpItem.ObjectId
                                               , inGoodsId             := CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find WHEN _tmpItem.ObjectId <> _tmpItem.ObjectId_parent THEN _tmpItem.ObjectId_parent ELSE 0 END
                                               , inAmount              := _tmpItem.OperCount
                                               , inAmountPartner       := _tmpItem.OperCountPartner
                                               , inOperPrice           := _tmpItem.OperPrice
                                               , inCountForPrice       := 1
                                               , inUnitId              := CLO_Unit.ObjectId
                                               , inPartnerId           := COALESCE ((SELECT Object_PartionGoods.FromId FROM Object_PartionGoods WHERE Object_PartionGoods.ObjectId = _tmpItem.ObjectId ORDER BY Object_PartionGoods.OperDate DESC, Object_PartionGoods.MovementItemId DESC LIMIT 1)
                                                                                  , (SELECT OL_Goods_Partner.ChildObjectId FROM ObjectLink AS OL_Goods_Partner WHERE OL_Goods_Partner.ObjectId = _tmpItem.ObjectId AND OL_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner())
                                                                                   )
/*            LEFT JOIN ObjectLink AS OL_Goods_Partner_goods
                                 ON OL_Goods_Partner_goods.ObjectId =  Object_Goods.Id
                                AND OL_Goods_Partner_goods.DescId   = zc_ObjectLink_Goods_Partner()
            LEFT JOIN Object AS Object_Partner_goods ON Object_Partner_goods.Id     = OL_Goods_Partner_goods.ChildObjectId*/
                                               , inColorPatternId      := _tmpItem.ColorPatternId
                                               , inProdColorPatternId  := _tmpItem.ProdColorPatternId
                                               , inProdOptionsId       := _tmpItem.ProdOptionsId
                                               , inUserId              := inUserId
                                                )
    FROM _tmpItem
         LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItem.ContainerId_Goods AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
    WHERE _tmpItem.ObjectId > 0;



    -- !!! �������� ��� �������
    IF NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())
    THEN
        -- ������� ������ � Engine Nr
        SELECT MIN (_tmpItem.PartionId), MAX (_tmpItem.PartionId)
               INTO vbPartionId_1, vbPartionId_2
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_Goods_Engine
                                   ON ObjectLink_Goods_Engine.ObjectId = _tmpItem.ObjectId
                                  AND ObjectLink_Goods_Engine.DescId   = zc_ObjectLink_Goods_Engine()
                                  -- !!! ����������� ��� ��-��
                                  AND ObjectLink_Goods_Engine.ChildObjectId > 0
             INNER JOIN MovementItemString AS MIString_PartNumber
                                           ON MIString_PartNumber.MovementItemId = _tmpItem.PartionId
                                          AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                          AND MIString_PartNumber.ValueData      <> ''
                                         ;

        -- ��������
        IF COALESCE (vbPartionId_1, 0) <> COALESCE (vbPartionId_2, 0)
        THEN
            RAISE EXCEPTION '������.������� ������ ������ Engine Nr. <%> + <%>.'
                          , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                          , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_2 AND MIS.DescId = zc_MIString_PartNumber())
                        ;
        END IF;
        -- ��������
        IF COALESCE (vbPartionId_1, 0) = 0
           AND NOT EXISTS (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
        THEN
            RAISE EXCEPTION '������.�� ������� ������ � Engine Nr';
        END IF;
        -- ��������
        IF COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
                   , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber()))
           <> (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
           AND vbPartionId_1 > 0
        THEN
            RAISE EXCEPTION '������.� ����� ��� ���������� Engine Nr = <%>. ������ ���������� ����� Engine Nr = <%>'
                          , (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
                          , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                           ;
        END IF;


        -- ��������� � ����� ������ � Engine Nr
        IF COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> ''), '')
           <> (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
           AND vbPartionId_1 > 0
        THEN
            -- ���������
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), vbProductId, (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber()));

            -- ��������� ��������
            PERFORM lpInsert_ObjectProtocol (vbProductId, inUserId);
        END IF;

    END IF;


    -- ���������
    RETURN QUERY
       SELECT _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , _tmpItem.ObjectId_parent
            , _tmpItem.ObjectId_parent_find
            , _tmpItem.ObjectId
            , _tmpItem.PartionId
            , _tmpItem.ProdOptionsId
            , _tmpItem.ColorPatternId
            , _tmpItem.ProdColorPatternId
            , _tmpItem.ProdColorName
            , _tmpItem.OperCount
            , _tmpItem.OperCount
            , _tmpItem.OperPrice
        FROM _tmpItem
       ;

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_OrderClient()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_OrderClient (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
