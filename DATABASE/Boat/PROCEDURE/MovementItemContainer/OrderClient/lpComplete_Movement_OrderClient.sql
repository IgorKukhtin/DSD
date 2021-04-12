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
             , OperPrice              TFloat
              )
AS
$BODY$
BEGIN

     -- ������� - �������� ���������, �� ����� ����������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer
                               , ObjectId_parent_find Integer, ObjectId_parent Integer, ObjectId Integer, PartionId Integer
                               , ProdOptionsId Integer
                               , ColorPatternId Integer
                               , ProdColorPatternId  Integer
                               , ProdColorName TVarChar
                               , OperCount TFloat
                               , OperPrice TFloat
                                ) ON COMMIT DROP;

     -- �������� ���������
     WITH -- ����� + ������ � ������
          tmpProduct AS (SELECT MovementLinkObject_Product.ObjectId                    AS ProductId
                              , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId
                              , CASE WHEN ObjectLink_Product_Model.ChildObjectId = ObjectLink_ReceiptProdModel_Model.ChildObjectId THEN ObjectLink_Product_Model.ChildObjectId ELSE 0 END AS ModelId
                                -- !!!��������� �� � ��������� ��� ������� ������������!!
                              , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) AS isBasicConf
                         FROM MovementLinkObject AS MovementLinkObject_Product
                              -- ������
                              LEFT JOIN ObjectLink AS ObjectLink_Product_Model
                                                   ON ObjectLink_Product_Model.ObjectId = MovementLinkObject_Product.ObjectId
                                                  AND ObjectLink_Product_Model.DescId   = zc_ObjectLink_Product_Model()
                              -- ������ ������ ������
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                   ON ObjectLink_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                                                  AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
                              -- ��� ��� ������, ��� ��������
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                                   ON ObjectLink_ReceiptProdModel_Model.ObjectId = ObjectLink_ReceiptProdModel.ChildObjectId
                                                  AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                                      ON ObjectBoolean_BasicConf.ObjectId = MovementLinkObject_Product.ObjectId
                                                     AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()

                         WHERE MovementLinkObject_Product.MovementId = inMovementId
                           AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()
                        )
          -- ��� �������� ������ ������ - ����� ��� ����
        , tmpReceiptProdModelChild_all AS (SELECT tmpProduct.ProductId   AS ProductId
                                                , tmpProduct.ModelId     AS ModelId
                                                , tmpProduct.isBasicConf AS isBasicConf
                                                  --
                                                , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                                  --
                                                , lpSelect.ObjectId_parent
                                                  -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                                , lpSelect.ObjectId
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
                                  , COALESCE (lpSelect.Value, 0)    AS OperCount
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
     INSERT INTO _tmpItem (MovementItemId, ContainerId_Goods, ObjectId_parent_find, ObjectId_parent, ObjectId, PartionId, ProdOptionsId, ColorPatternId, ProdColorPatternId, ProdColorName, OperCount, OperPrice)
        SELECT 0 AS MovementItemId
             , 0 AS ContainerId_Goods
             , 0 AS ObjectId_parent_find
             , tmpRes.ObjectId_parent
             , tmpRes.ObjectId
             , 0 AS PartionId
             , tmpRes.ProdOptionsId
             , ObjectLink_ColorPattern.ChildObjectId AS ColorPatternId
             , tmpRes.ProdColorPatternId
             , tmpRes.ProdColorName
             , tmpRes.OperCount
             , tmpRes.OperPrice
        FROM tmpRes
             -- ������ Boat Structure
             LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = tmpRes.ProdColorPatternId
                                 AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
        ;


     -- ������� ObjectId_parent ��� Boat Structure
     UPDATE _tmpItem SET ObjectId_parent_find = _tmpItem_find.ObjectId_parent_find
     FROM (WITH -- ������������ �������� Boat Structure
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
                                      (SELECT * FROM _tmpItem ORDER BY _tmpItem.ColorPatternId, _tmpItem.ObjectId_parent
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
     WHERE _tmpItem.ProdColorPatternId > 0
       AND _tmpItem.ColorPatternId     = _tmpItem_find.ColorPatternId
       AND _tmpItem.ObjectId_parent    = _tmpItem_find.ObjectId_parent
    ;
    

    -- !!!�������� - ������� ��������� ObjectId_parent, ���� �� Boat Structure - ���� ���� ����� ��� ������������ ����������!!!
    UPDATE _tmpItem SET ObjectId_parent_find = tmp.ObjectId_parent_find
    FROM (SELECT DISTINCT _tmpItem.ObjectId_parent, _tmpItem.ObjectId_parent_find FROM _tmpItem) AS tmp
    WHERE _tmpItem.ObjectId_parent_find = 0
      AND _tmpItem.ObjectId_parent      = tmp.ObjectId_parent
     ;


    -- ��������
    IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0)
    THEN
        RAISE EXCEPTION '������.�� ������ ������ ��� <%>. ��� ����� ���������: <%> ����� �� ������� <%> ��.'
                                    , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent) FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0) AS _tmpItem LIMIT 1)
                                    , (SELECT lfGet_Object_ValueData (_tmpItem.ColorPatternId)
                                            || ' : ' || STRING_AGG (CASE WHEN _tmpItem.ObjectId > 0 THEN COALESCE (Object_ProdColor.ValueData, lfGet_Object_ValueData_sh (_tmpItem.ObjectId)) ELSE _tmpItem.ProdColorName END, ';') AS Key_Id
                                       FROM -- ������� �������������
                                            (SELECT * FROM _tmpItem
                                             WHERE _tmpItem.ObjectId_parent = (SELECT MIN (_tmpItem.ObjectId_parent) FROM _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0)
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
                                    , (SELECT COUNT(*)                                          FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 AND _tmpItem.ProdColorPatternId > 0) AS _tmpItem);
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
                                               , inObjectId            := _tmpItem.ObjectId
                                               , inGoodsId             := CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN _tmpItem.ObjectId_parent_find WHEN _tmpItem.ObjectId <> _tmpItem.ObjectId_parent THEN _tmpItem.ObjectId_parent ELSE 0 END
                                               , inAmount              := 0
                                               , inAmountPartner       := _tmpItem.OperCount
                                               , inOperPrice           := _tmpItem.OperPrice
                                               , inCountForPrice       := 1
                                               , inUnitId              := NULL
                                               , inPartnerId           := (SELECT Object_PartionGoods.FromId FROM Object_PartionGoods WHERE Object_PartionGoods.ObjectId = _tmpItem.ObjectId ORDER BY Object_PartionGoods.OperDate DESC, Object_PartionGoods.MovementItemId DESC LIMIT 1)
                                               , inColorPatternId      := _tmpItem.ColorPatternId
                                               , inProdColorPatternId  := _tmpItem.ProdColorPatternId
                                               , inProdOptionsId       := _tmpItem.ProdOptionsId
                                               , inUserId              := inUserId
                                                )
    FROM _tmpItem
    WHERE _tmpItem.ObjectId > 0;


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
