-- Function: gpUpdate_MI_ProductionUnion_Child_byReceipt()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_Child_byReceipt (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_Child_byReceipt(
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer   , -- ����� �������
    IN inObjectId               Integer   , -- �������������
    IN inReceiptProdModelId     Integer   , --    
    IN inAmount                 TFloat    , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);

     -- ������� - ���
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.ParentId   = inParentId
       AND MovementItem.isErased   = FALSE;


        -- ���������� �� �������
        PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                := 0
                                                       , inParentId          := inParentId
                                                       , inMovementId        := inMovementId
                                                       , inObjectId          := tmpReceiptGoodsChild.GoodsId
                                                       , inReceiptLevelId    := tmpReceiptGoodsChild.ReceiptLevelId
                                                       , inColorPatternId    := tmpReceiptGoodsChild.ColorPatternId
                                                       , inProdColorPatternId:= tmpReceiptGoodsChild.ProdColorPatternId
                                                       , inProdOptionsId     := tmpReceiptGoodsChild.ProdOptionsId
                                                       , inAmount            := tmpReceiptGoodsChild.Value * inAmount
                                                       , inForCount          := 1
                                                       , inUserId            := vbUserId
                                                        )
        FROM (WITH
                tmpReceiptGoodsChild AS (SELECT ObjectLink_Goods_master.ChildObjectId      AS GoodsId_master
                                              , ObjectLink_Object.ChildObjectId            AS GoodsId
                                              , ObjectLink_GoodsChild.ChildObjectId        AS GoodsId_child
                                              , ObjectLink_ReceiptLevel.ChildObjectId      AS ReceiptLevelId
                                              , ObjectLink_ColorPattern.ChildObjectId      AS ColorPatternId
                                              , ObjectLink_ProdColorPattern.ChildObjectId  AS ProdColorPatternId
                                              , ObjectFloat_Value.ValueData                AS Value
                                         FROM ObjectLink AS ObjectLink_ReceiptGoods
                                              -- ����� ���� ����������
                                              LEFT JOIN ObjectLink AS ObjectLink_Goods_master
                                                                   ON ObjectLink_Goods_master.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                                  AND ObjectLink_Goods_master.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                              -- ������
                                              LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                                   ON ObjectLink_ColorPattern.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                                  AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ReceiptGoods_ColorPattern()

                                              INNER JOIN Object AS Object_ReceiptGoodsChild
                                                                ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoods.ObjectId
                                                               -- �� ������
                                                               AND Object_ReceiptGoodsChild.isErased = FALSE

                                              LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                   ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                              INNER JOIN Object AS Object_Object
                                                                ON Object_Object.Id     = ObjectLink_Object.ChildObjectId
                                                               -- ��� �� ������ � �� ������ Boat Structure
                                                               AND Object_Object.DescId = zc_Object_Goods()

                                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                                   ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()

                                              -- �������� � ������
                                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                     ON ObjectFloat_Value.ObjectId  = Object_ReceiptGoodsChild.Id
                                                                    AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                                                    AND ObjectFloat_Value.ValueData > 0
                                              -- "�����������" ���� ������
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                                   ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                              -- Boat Structure
                                              LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                                   ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

                                         WHERE ObjectLink_ReceiptGoods.ChildObjectId = inReceiptProdModelId
                                           AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                        )
               , tmpReceiptProdModel AS (SELECT 0                           AS GoodsId_master
                                              , MovementItem.ObjectId       AS GoodsId
                                              , 0                           AS GoodsId_child
                                              , MILO_ReceiptLevel.ObjectId  AS ReceiptLevelId
                                              , MovementItem.Amount         AS Amount
                                         FROM MovementItem
                                              LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                                                               ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                                                              AND MILO_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()

                                              LEFT JOIN MovementItemLinkObject AS MILO_ProdOptions
                                                                               ON MILO_ProdOptions.MovementItemId = MovementItem.Id
                                                                              AND MILO_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()

                                         WHERE MovementItem.MovementId = inMovementId_OrderClient
                                           AND MovementItem.isErased   = FALSE
                                           AND MovementItem.DescId     = zc_MI_Child()
                                           -- !!!�� �����!!!
                                           AND MILO_ProdOptions.ObjectId IS NULL
                                           -- !!!
                                           AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId = zc_Object_Product())
                                        )
                 -- �����
               , tmpProdOptItems AS (SELECT lpSelect.GoodsId
                                          , lpSelect.ProdOptionsId
                                            -- ���-�� �����
                                          , lpSelect.Amount
                                     FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient
                                                                      , inIsShowAll:= FALSE
                                                                      , inIsErased := FALSE
                                                                      , inIsSale   := TRUE
                                                                      , inSession  := vbUserId :: TVarChar
                                                                       ) AS lpSelect
                                     WHERE lpSelect.MovementId_OrderClient = inMovementId_OrderClient
                                       AND lpSelect.ProductId              = inObjectId
                                       AND lpSelect.GoodsId                > 0
                                       -- ��� ���� ���������
                                       AND COALESCE (lpSelect.ProdColorPatternId, 0) = 0
                                    )

           -- 1. ���� ��� "�����������" ���� ������
           SELECT tmpReceiptGoodsChild.GoodsId
                , tmpReceiptGoodsChild.ReceiptLevelId
                , tmpReceiptGoodsChild.ColorPatternId
                , tmpReceiptGoodsChild.ProdColorPatternId
                , 0 AS ProdOptionsId
                , tmpReceiptGoodsChild.Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_child = inObjectId

         UNION ALL
           -- 2.1. ���� ��� ������ ����
           SELECT tmpReceiptGoodsChild.GoodsId
                , tmpReceiptGoodsChild.ReceiptLevelId
                , tmpReceiptGoodsChild.ColorPatternId
                , tmpReceiptGoodsChild.ProdColorPatternId
                , 0 AS ProdOptionsId
                , tmpReceiptGoodsChild.Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_master = inObjectId
              -- ��������� �������������� ���� ������
             AND tmpReceiptGoodsChild.GoodsId_child IS NULL
             -- ���� ���
             AND tmpReceiptGoodsChild.GoodsId NOT IN (SELECT DISTINCT tmpCheck.GoodsId_child FROM tmpReceiptGoodsChild AS tmpCheck WHERE tmpCheck.GoodsId_child > 0)

         UNION ALL
           -- 2.2. ���� ��� "�����������" � ������ ����
           SELECT DISTINCT
                  tmpReceiptGoodsChild.GoodsId_child AS GoodsId
                , 0                                  AS ReceiptLevelId
                , 0                                  AS ColorPatternId
                , 0                                  AS ProdColorPatternId
                , 0                                  AS ProdOptionsId
                  -- ������
                , 1 AS Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_master = inObjectId
              -- ��������� �������������� ���� ������
             AND tmpReceiptGoodsChild.GoodsId_child > 0

         UNION ALL
           -- 3.1. ���� ��� ������ �����
           SELECT tmpReceiptProdModel.GoodsId
                , tmpReceiptProdModel.ReceiptLevelId
                , 0 AS ColorPatternId
                , 0 AS ProdColorPatternId
                , 0 AS ProdOptionsId
                  --
                , tmpReceiptProdModel.Amount

           FROM tmpReceiptProdModel

         UNION ALL
           -- 3.2. �������� �����, ���� ��� ������ �����
           SELECT tmpProdOptItems.GoodsId
                , 0 AS ReceiptLevelId
                , 0 AS ColorPatternId
                , 0 AS ProdColorPatternId
                , tmpProdOptItems.ProdOptionsId
                  -- ���-�� �����
                , tmpProdOptItems.Amount

           FROM tmpProdOptItems

          ) AS tmpReceiptGoodsChild
         ;
 
         
     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE
     ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.11.23         *
*/

-- ����
-- SELECT * FROM