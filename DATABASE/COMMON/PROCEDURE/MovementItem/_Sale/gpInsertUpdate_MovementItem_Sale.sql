-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpinsertupdate_movementitem_sale(integer, integer, integer, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tvarchar, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpinsertupdate_movementitem_sale(integer, integer, integer, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tvarchar, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountChangePercent TFloat    , -- ���������� c ������ % ������
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     -- �������� - �����������/��������� �������� �� ����� ����������������
     IF NOT EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND StatusId = zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION '�������� �� ����� ���������������� �.�. �� <%>.', lfGet_Object_ValueData ((SELECT StatusId FROM Movement WHERE Id = inMovementId));
     END IF;
     -- �������� - ��������� ������� ��������� �� ����� ����������������
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE Id = ioId AND isErased = TRUE)
     THEN
         RAISE EXCEPTION '������� �� ����� ���������������� �.�. �� <������>.';
     END IF;

     -- ��������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     ioId := lpInsertUpdate_MovementItem_Sale(ioId, inMovementId, inGoodsId, inAmount, inAmountPartner, inAmountChangePercent, 
                   inChangePercentAmount, inPrice, inCountForPrice, inHeadCount, inPartionGoods, inGoodsKindId, inAssetId, vbUserId);              
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * inPrice AS NUMERIC (16, 2))
                      END;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.02.14                        * add lpInsertUpdate_MovementItem_Sale
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 02.09.13                                        * add zc_MIFloat_ChangePercentAmount
 13.08.13                                        * add RAISE EXCEPTION
 09.07.13                                        * add IF inGoodsId <> 0
 18.07.13         * add inAssetId
 13.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
