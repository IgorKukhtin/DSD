-- Function: gpInsertUpdate_MovementItem_Sale_SybaseFl()

-- DROP FUNCTION gpInsertUpdate_MovementItem_Sale_SybaseFl();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale_SybaseFl(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Sale());
     vbUserId := inSession;

     -- �������� - �����������/��������� �������� �� ����� ����������������
     IF NOT EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND StatusId = zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION '�������� �� ����� ���������������� �.�. �� <%>.', (SELECT Object_Status.ValueData FROM Movement JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId WHERE Movement.Id = inMovementId );
     END IF;
     -- �������� - ��������� ������� ��������� �� ����� ����������������
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE Id = ioId AND isErased = TRUE)
     THEN
         RAISE EXCEPTION '������� �� ����� ���������������� �.�. �� <������>.';
     END IF;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <���������� c ������ % ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountChangePercent(), ioId, inAmountChangePercent);
     -- ��������� �������� <% ������ ��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <���� �� ����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, vbUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 02.09.13                                        * add zc_MIFloat_ChangePercentAmount
 13.08.13                                        * add RAISE EXCEPTION
 09.07.13                                        * add IF inGoodsId <> 0
 18.07.13         * add inAssetId               
 13.07.13         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale_SybaseFl (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
