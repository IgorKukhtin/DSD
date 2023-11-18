-- Function: gpUpdate_MI_ProductionUnion_Child_byOrder()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_Child_byOrder (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_Child_byOrder(
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer   , -- ����� �������
    IN inObjectId               Integer   , -- �������������
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


     -- ������ ��������� ����������� zc_MI_Child  
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                := 0
                                                    , inParentId          := inParentId
                                                    , inMovementId        := inMovementId
                                                    , inObjectId          := tmpMI.GoodsId
                                                    , inReceiptLevelId    := tmpMI.ReceiptLevelId
                                                    , inColorPatternId    := tmpMI.ColorPatternId
                                                    , inProdColorPatternId:= tmpMI.ProdColorPatternId
                                                    , inProdOptionsId     := tmpMI.ProdOptionsId
                                                    , inAmount            := tmpMI.Amount     ::TFloat
                                                    , inForCount          := tmpMI.ForCount   ::TFloat
                                                    , inUserId            := vbUserId
                                                     )
     FROM (
           WITH
           -- �������� �� ������ �� ������
           tmpOrderInternal AS (SELECT MovementItem.MovementId AS MovementId_OrderInternal
                                FROM MovementItemFloat AS MIFloat_MovementId 
                                     INNER JOIN MovementItem ON MovementItem.Id = MIFloat_MovementId.MovementItemId
                                     INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                        AND Movement.DescId = zc_Movement_OrderInternal()
                                WHERE MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                 AND MIFloat_MovementId.ValueData = inMovementId_OrderClient
                                 AND MovementItem.ObjectId = inObjectId
                                )

         , tmpMI AS (SELECT MovementItem.*
                     FROM tmpOrderInternal
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpOrderInternal.MovementId_OrderInternal
                                                AND MovementItem.DescId = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE

                         INNER JOIN MovementItem AS MI_Master ON MI_Master.Id = MovementItem.ParentId
                                                AND MI_Master.DescId = zc_MI_Master()
                                                AND MI_Master.ObjectId = inObjectId
                                                AND MI_Master.isErased   = FALSE
                         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                     AND MIFloat_MovementId.ValueData      = inMovementId_OrderClient
                     )
         SELECT MovementItem.ObjectId          AS GoodsId
              , MILO_ReceiptLevel.ObjectId     AS ReceiptLevelId
              , MILO_ColorPattern.ObjectId     AS ColorPatternId
              , MILO_ProdColorPattern.ObjectId AS ProdColorPatternId
              , MILO_ProdOptions.ObjectId      AS ProdOptionsId
              , MIFloat_ForCount.ValueData     AS ForCount
              , MovementItem.Amount            AS Amount
         FROM tmpMI AS MovementItem
           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                            ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                           AND MILO_ReceiptLevel.DescId          = zc_MILinkObject_ReceiptLevel()
           LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                            ON MILO_ColorPattern.MovementItemId = MovementItem.Id
                                           AND MILO_ColorPattern.DescId = zc_MILinkObject_ColorPattern()
           LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                            ON MILO_ProdColorPattern.MovementItemId = MovementItem.Id
                                           AND MILO_ProdColorPattern.DescId = zc_MILinkObject_ProdColorPattern()
           LEFT JOIN MovementItemLinkObject AS MILO_ProdOptions
                                            ON MILO_ProdOptions.MovementItemId = MovementItem.Id
                                           AND MILO_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
           LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                       ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                      AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
        ) AS tmpMI;
        
 
         
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