-- Function: lpComplete_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderClient(
    IN inMovementId        Integer  , -- ���� ���������
    IN inIsChild_Recalc    Boolean  , -- �������� �������������
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
  DECLARE vbProductId      Integer;
  DECLARE vbPartionId_1    Integer;
  DECLARE vbPartionId_2    Integer;
  DECLARE vbClientId_From  Integer;
  DECLARE vbUnitId_To      Integer;
BEGIN

     -- ����� �����
     vbProductId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product());

     -- ��������� �� ���������
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

     -- �������� - Kunden
     IF COALESCE (vbClientId_From, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <Kunden>.';
     END IF;
     -- �������� - �������������
     IF COALESCE (vbUnitId_To, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������������� (����)>.';
     END IF;
     -- �������� - ������������� - ������������
     IF vbUnitId_To <> zc_Unit_Production() AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product() AND MLO.ObjectId > 0)
     THEN
         RAISE EXCEPTION '������.��� <������������� (����)> ���������� ���������� �������� = <%>.', lfGet_Object_ValueData_sh (zc_Unit_Production());
     END IF;


     -- !!!������ ���� ����� ��������!!!
     -- !!!��� �������� ���� � ������ ������ ��������!!!
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product() AND MLO.ObjectId > 0)
        AND (inIsChild_Recalc = TRUE
          OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
            )
     THEN
         -- ������� - �������� ���������, �� ����� ����������
         CREATE TEMP TABLE _tmpItem_all (ObjectId_parent_find Integer, ObjectId_parent Integer, ObjectId Integer, ObjectDescId Integer
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
                                   , ObjectId Integer, PartionId Integer
                                   , ProdColorPatternId  Integer
                                   , OperCount TFloat
                                   , OperCountPartner TFloat
                                   , OperPricePartner TFloat
                                   , ObjectDescId Integer
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

                                FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= 0
                                                                 , inIsShowAll:= FALSE
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
                                      , COALESCE (tmpProdOptItems.ProdOptionsId, 0) AS ProdOptionsId

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
         INSERT INTO _tmpItem_all (ObjectId_parent_find, ObjectId_parent, ObjectId, ObjectDescId, ProdOptionsId, ColorPatternId, ProdColorPatternId, ProdColorName, OperCount_parent, OperCount, OperPrice)
            SELECT 0 AS ObjectId_parent_find
                 , tmpRes.ObjectId_parent
                 , tmpRes.ObjectId
                 , COALESCE (Object_Object.DescId, 0) AS ObjectDescId
                   --
                 , tmpRes.ProdOptionsId
                 , ObjectLink_ColorPattern.ChildObjectId AS ColorPatternId
                 , tmpRes.ProdColorPatternId
                 , tmpRes.ProdColorName
                 , tmpRes.OperCount_parent
                 , tmpRes.OperCount
                 , tmpRes.OperPrice
            FROM tmpRes
                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpRes.ObjectId
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


        -- ������� ��� �������
        PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
        ;

        -- 1. ��������� ������ ��� - ��� ParentId -  ���������� ������ ������
        PERFORM lpInsertUpdate_MI_OrderClient_Child (ioId                  := 0
                                                   , inParentId            := NULL
                                                   , inMovementId          := inMovementId
                                                   , inPartionId           := NULL
                                                   , inObjectId            := CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId ELSE _tmpItem.ProdColorPatternId END
                                                   , inGoodsId             := _tmpItem.ObjectId_parent
                                                   , inAmountBasis         := _tmpItem.OperCount
                                                   , inAmount              := CASE WHEN _tmpItem.ObjectDescId = zc_Object_ReceiptService() THEN _tmpItem.OperCount ELSE 0 END
                                                   , inAmountPartner       := 0 -- !!!��������!!!
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
        FROM (-- ������� ����
              SELECT 0 AS ObjectId_parent
                   , CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find ELSE _tmpItem.ObjectId_parent END AS ObjectId
                   , _tmpItem.OperCount_parent AS OperCount
                   , SUM (_tmpItem.OperCount * _tmpItem.OperPrice) / CASE WHEN _tmpItem.OperCount_parent > 0 THEN _tmpItem.OperCount_parent ELSE 1 END AS OperPrice
                   , 0 AS ColorPatternId
                   , 0 AS ProdColorPatternId
                   , CASE WHEN _tmpItem.ProdColorPatternId > 0 THEN 0 ELSE _tmpItem.ProdOptionsId END AS ProdOptionsId
                   , 0 AS ObjectDescId
              FROM _tmpItem_all AS _tmpItem
                   -- ���� ��� ����
                 --LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                 --                      ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                 --                     AND ObjectFloat_EKPrice.ObjectId = CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find
                 --                                                             ELSE _tmpItem.ObjectId_parent
                 --                                                        END
              WHERE _tmpItem.ObjectId_parent <> 0
              GROUP BY CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find ELSE _tmpItem.ObjectId_parent END
                     , _tmpItem.OperCount_parent
                     , CASE WHEN _tmpItem.ProdColorPatternId > 0 THEN 0 ELSE _tmpItem.ProdOptionsId END
             UNION
              -- ��� ������������
              SELECT DISTINCT
                     CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find ELSE _tmpItem.ObjectId_parent END AS ObjectId_parent
                   , _tmpItem.ObjectId
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



        -- !!!2.�������� ���������, �� �������!!!
        WITH -- ������ ObjectId
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
                             -- !!! ��� ���� ��������� !!!
                             AND COALESCE (MILinkObject_Goods.ObjectId, 0) = 0
                          )
                -- ������������ ������� - � ������� ��������
              , tmpOrderClient AS (SELECT MovementItem.PartionId     AS PartionId
                                        , MILinkObject_Unit.ObjectId AS UnitId
                                        , SUM (MovementItem.Amount)  AS Amount
                                   FROM Movement
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Child()
                                                               AND MovementItem.isErased   = FALSE
                                                               -- ���������� ��������
                                                               AND MovementItem.ObjectId IN (SELECT DISTINCT tmpItem.ObjectId FROM tmpItem)
                                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                        AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                   WHERE Movement.DescId   = zc_Movement_OrderClient()
                                     -- !!!�����������!!!
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   GROUP BY MovementItem.PartionId
                                          , MILinkObject_Unit.ObjectId
                                  )
                -- ����������� ��� ������ - ���� ��� ������
              , tmpSend AS (SELECT MovementItem.PartionId     AS PartionId
                                 , MLO_To.ObjectId            AS UnitId
                                 , SUM (MovementItem.Amount)  AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                                        -- ���������� ��������
                                                        AND MovementItem.ObjectId IN (SELECT DISTINCT tmpItem.ObjectId FROM tmpItem)
                                 -- zc_MI_Master �� ������
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                                 LEFT JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = MovementItem.MovementId
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                            WHERE Movement.DescId   = zc_Movement_Send()
                              -- !!!�����������!!!
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              -- !!!test!!!
                              AND 1=0
                            GROUP BY MovementItem.PartionId
                                   , MLO_To.ObjectId
                           )
            -- �� ������� ������ �������
          , tmpContainer_all AS (SELECT Container.Id
                                      , Container.PartionId
                                      , Container.ObjectId
                                      , Container.WhereObjectId
                                      , Container.Amount - COALESCE (tmpOrderClient.Amount, 0) - COALESCE (tmpSend.Amount, 0) AS Amount
                                 FROM Container
                                      -- ������� - � ������� ��������
                                      LEFT JOIN tmpOrderClient ON tmpOrderClient.PartionId = Container.PartionId
                                                              AND tmpOrderClient.UnitId    = Container.WhereObjectId
                                      -- ����������� ��� ������ - ������
                                      LEFT JOIN tmpSend ON tmpSend.PartionId = Container.PartionId
                                                       AND tmpSend.UnitId    = Container.WhereObjectId
                                 WHERE Container.DescId = zc_Container_Count()
                                   AND Container.Amount - COALESCE (tmpOrderClient.Amount, 0) - COALESCE (tmpSend.Amount, 0) > 0
                                   -- ���������� ��������
                                   AND Container.ObjectId IN (SELECT tmpItem.ObjectId FROM tmpItem)
                                   -- !!! �������� ��� �������
                                   AND NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())

                                )
                -- ������������� ������ - �������� �� �������
              , tmpContainer AS (SELECT Container.Id             AS ContainerId
                                      , Container.PartionId      AS PartionId
                                      , Container.ObjectId       AS ObjectId
                                      , Container.WhereObjectId  AS WhereObjectId
                                      , Container.Amount         AS ContainerAmount
                                      , tmpItem.AmountBasis      AS OperCount
                                        -- ������������� ���-��
                                      , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId
                                                                     ORDER BY -- ������� ������
                                                                              CASE WHEN Container.WhereObjectId = vbUnitId_To THEN 0 ELSE 1 END
                                                                            , Object_PartionGoods.OperDate ASC
                                                                            , Container.Id ASC
                                                                    ) AS ContainerAmountSUM
                                 FROM tmpContainer_all AS Container
                                      LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                      LEFT JOIN tmpItem ON tmpItem.ObjectId = Container.ObjectId
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
         INSERT INTO _tmpItem (MovementItemId, ContainerId_Goods, ObjectId, PartionId, ProdColorPatternId, OperCount, OperCountPartner, OperPricePartner, ObjectDescId)
            -- 0.1. �������
            SELECT tmpItem.MovementItemId
                   -- �����!!
                 , tmpRes_partion.ContainerId
                   --
                 , tmpItem.ObjectId
                   -- �����!!
                 , tmpRes_partion.PartionId
                   --
                 , tmpItem.ProdColorPatternId
                   -- �����!!
                 , COALESCE (tmpRes_partion.OperCount, 0) AS OperCount
                   --
                 , 0 AS OperCountPartner

                   -- �����, ���� ��� ������� - ������������
                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0) AS OperPricePartner

                 , tmpItem.ObjectDescId

            FROM tmpItem
                 INNER JOIN tmpRes_partion ON tmpRes_partion.ObjectId = tmpItem.ObjectId
                 -- ����
                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                       ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                      AND ObjectFloat_EKPrice.ObjectId = tmpItem.ObjectId

           UNION ALL
            -- 0.2. �����
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

                 , -- ��� ������ �������� ������� �� �������
                   tmpItem.AmountBasis - COALESCE (tmpRes_partion_total.OperCount, 0) AS OperCountPartner

                   -- �����
                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0) AS OperPricePartner

                 , tmpItem.ObjectDescId

            FROM tmpItem
                 -- ����
                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                       ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                      AND ObjectFloat_EKPrice.ObjectId = tmpItem.ObjectId

                 -- ����� �� �������, � ������� �� ������� - ����� � ����������
                 LEFT JOIN (SELECT tmpRes_partion.ObjectId, SUM (tmpRes_partion.OperCount) AS OperCount FROM tmpRes_partion GROUP BY tmpRes_partion.ObjectId
                           ) AS tmpRes_partion_total ON tmpRes_partion_total.ObjectId = tmpItem.ObjectId
            -- ���� ����� �����
            WHERE tmpItem.AmountBasis - COALESCE (tmpRes_partion_total.OperCount, 0) > 0
            ;


         -- ����� ����������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPricePartner(), _tmpItem.MovementItemId, _tmpItem.OperPricePartner)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(),    _tmpItem.MovementItemId, _tmpItem.OperCountPartner)
         FROM _tmpItem
         WHERE _tmpItem.ContainerId_Goods = 0
           AND _tmpItem.ObjectDescId      <> zc_Object_ReceiptService()
        ;


         -- ��������� ������ ��� - ���� ParentId - ������ ������ ������ � PartionId
         PERFORM lpInsertUpdate_MI_OrderClient_Child (ioId                  := 0
                                                    , inParentId            := _tmpItem.MovementItemId
                                                    , inMovementId          := inMovementId
                                                    , inPartionId           := _tmpItem.PartionId
                                                    , inObjectId            := _tmpItem.ObjectId
                                                    , inGoodsId             := NULL
                                                    , inAmountBasis         := 0
                                                    , inAmount              := _tmpItem.OperCount
                                                    , inAmountPartner       := 0
                                                    , inOperPrice           := _tmpItem.OperPricePartner -- ������������
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
                AND 1=0
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

     END IF; -- !!!������ ���� ����� ��������!!!

/*
    -- ���������
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
