-- Function: gpInsert_MI_ReturnIn_byOrderReturnTare()

DROP FUNCTION IF EXISTS gpInsert_MI_ReturnIn_byOrderReturnTare (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_ReturnIn_byOrderReturnTare(
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inMovementId_Order       Integer   , -- OrderReturnTare
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartnerId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     --�������� ���. ������ OrderReturnTare
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_Order AND Movement.DescId = zc_Movement_OrderReturnTare())
     THEN
         RETURN;
     END IF;

     IF COALESCE (inMovementId,0) = 0 
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.'; 
     END IF;
     
     --
     vbPartnerId := (SELECT MovementLinkObject_From.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_From
                     WHERE MovementLinkObject_From.MovementId = inMovementId
                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     );

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := 0
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmp.GoodsId
                                                 , inAmount             := tmp.Amount
                                                 , inAmountPartner      := tmp.Amount
                                                 , ioPrice              := NULL
                                                 , ioCountForPrice      := 1
                                                 , inCount              := NULL
                                                 , inHeadCount          := NULL
                                                 , inMovementId_Partion := NULL
                                                 , inPartionGoods       := NULL
                                                 , inGoodsKindId        := NULL
                                                 , inAssetId            := NULL
                                                 , ioMovementId_Promo   := NULL
                                                 , ioChangePercent      := NULL
                                                 , inIsCheckPrice       := TRUE
                                                 , inUserId             := vbUserId
                                                  )
     FROM (SELECT MovementItem.ObjectId AS GoodsId
                , MovementItem.Amount
           FROM MovementItem
               INNER JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                 ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                                                AND MILinkObject_Partner.ObjectId = vbPartnerId
           WHERE MovementItem.MovementId = inMovementId_Order
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.01.22         *
*/

-- ����
--