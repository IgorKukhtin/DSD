-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer   , -- ����� �������
    IN inGoodsId                Integer   , -- �������������
    IN inAmount                 TFloat    , -- ����������
    IN inComment                TVarChar  ,
    IN inUserId                 Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
         --
         --
         PERFORM lpInsertUpdate_MI_OrderInternal_Child (ioId                     := 0
                                                      , inParentId               := ioId
                                                      , inMovementId             := inMovementId
                                                      , inObjectId               := tmpMI.ObjectId
                                                      , inReceiptLevelId         := tmpMI.ReceiptLevelId
                                                      , inColorPatternId         := tmpMI.ColorPatternId
                                                      , inProdColorPatternId     := tmpMI.ProdColorPatternId
                                                      , inUnitId                 := 0 -- !!!
                                                      , inAmount                 := tmpMI.Amount
                                                      , inAmountReserv           := 0
                                                      , inAmountSend             := tmpMI.Amount
                                                      , inForCount               := tmpMI.ForCount
                                                      , inUserId                 := inUserId
                                                       )
         FROM (SELECT DISTINCT
                      CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                            AND MILinkObject_Goods_basis.ObjectId > 0
                                -- �������� � ���� ������� "�����������" ����
                                THEN MILinkObject_Goods_basis.ObjectId
                            ELSE MovementItem.ObjectId
                      END AS ObjectId
                      --
                    , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                            AND MILinkObject_Goods_basis.ObjectId > 0
                                THEN 0
                            ELSE MILinkObject_ReceiptLevel.ObjectId
                      END AS ReceiptLevelId
                      --
                    , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                            AND MILinkObject_Goods_basis.ObjectId > 0
                                THEN 0
                            ELSE MILinkObject_ColorPattern.ObjectId
                      END AS ColorPatternId
                      --
                    , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                            AND MILinkObject_Goods_basis.ObjectId > 0
                                THEN 0
                            ELSE MILinkObject_ProdColorPattern.ObjectId
                      END AS ProdColorPatternId
                      --
                    , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                            AND MILinkObject_Goods_basis.ObjectId > 0
                                -- ���-�� ��� ����� ������� "�����������" ����
                                THEN 1
                            ELSE MovementItem.Amount
                      END AS Amount
                      --
                    , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                            AND MILinkObject_Goods_basis.ObjectId > 0
                                THEN 0
                            ELSE MIFloat_ForCount.ValueData
                      END AS ForCount
               FROM MovementItem
                    -- ����� ���� ����������
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                     ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                    -- ����� "�����������" ���� ����������
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                     ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                    --
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                     ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                     ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                    --
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                     ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                    LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                               AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()

               WHERE MovementItem.MovementId = inMovementId_OrderClient
                 AND MovementItem.DescId     = zc_MI_Detail()
                 AND MovementItem.isErased    = FALSE
                 AND (MILinkObject_Goods.ObjectId       = inGoodsId
                   OR MILinkObject_Goods_basis.ObjectId = inGoodsId
                     )
              ) AS tmpMI
        ;


     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.12.22         *
*/

-- ����
--