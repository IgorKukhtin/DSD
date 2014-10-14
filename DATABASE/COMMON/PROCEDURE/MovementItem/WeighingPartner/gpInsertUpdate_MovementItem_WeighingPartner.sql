-- Function: gpInsertUpdate_MovementItem_WeighingPartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat,TFloat,TFloat,TFloat,TFloat, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingPartner(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inRealWeight          TFloat    , -- �������� ��� (��� ����� % ������ ��� ���-��)
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inCountTare           TFloat    , -- ���������� ����
    IN inWeightTare          TFloat    , -- ��� ����
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inBoxCount            TFloat    , -- ���������� ����(�����)
    IN inBoxNumber           TFloat    , -- ����� �����
    IN inLevelNumber         TFloat    , -- ����� ���� 
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inPartionGoodsDate    TDateTime , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inPriceListId         Integer   , -- �����
    IN inBoxId               Integer   , -- ����(�����)
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());

     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemIDate (zc_MIFIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- ��������� �������� <�������� ��� (��� ����� % ������ ��� ���-��)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- ��������� �������� <% ������ ��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- ��������� �������� <���������� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare(), ioId, inCountTare);
     -- ��������� �������� <��� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- ��������� �������� <���������� ������� ��� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- ��������� �������� <���������� ����(�����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);
     -- ��������� �������� <����� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxNumber(), ioId, inBoxNumber);
     -- ��������� �������� <����� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LevelNumber(), ioId, inLevelNumber);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PriceList(), ioId, inPriceListId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);
    
     -- ������� ������ <����� ������ � ���� �������>
     PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, vbUserId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.10.14                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
