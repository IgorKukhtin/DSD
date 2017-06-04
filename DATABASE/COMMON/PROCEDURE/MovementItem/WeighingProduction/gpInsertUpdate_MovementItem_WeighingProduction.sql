-- Function: gpInsertUpdate_MovementItem_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingProduction(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inIsStartWeighing     Boolean   , -- ����� ������ �����������
    IN inRealWeight          TFloat    , -- �������� ��� (��� �����: ����� ���� � ������)
    IN inWeightTare          TFloat    , -- ��� ����
    IN inLiveWeight          TFloat    , -- ����� ���
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inCount               TFloat    , -- ���������� �������
    IN inCountPack           TFloat    , -- ���������� ��������
    IN inCountSkewer1        TFloat    , -- ���������� ������/������� ����1
    IN inWeightSkewer1       TFloat    , -- ��� ����� ������/������ ����1
    IN inCountSkewer2        TFloat    , -- ���������� ������ ����2
    IN inWeightSkewer2       TFloat    , -- ��� ����� ������ ����2
    IN inWeightOther         TFloat    , -- ���, ������
    IN inPartionGoodsDate    TDateTime , -- ������ ������ (����)
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inMovementItemId      Integer   , -- 
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inStorageLineId       Integer   , -- ����� ��-��
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <����� ������ �����������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_StartWeighing(), ioId, inIsStartWeighing);

     -- ��������� �������� <����/����� ��������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);

     -- ��������� �������� <�������� ��� (��� �����: ����� ���� � ������)
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- ��������� �������� <��� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- ��������� �������� <����� ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LiveWeight(), ioId, inLiveWeight);
     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- ��������� �������� <���������� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);


     -- ��������� �������� <���������� ������/������� ����1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer1(), ioId, inCountSkewer1);
     -- ��������� �������� <��� ����� ������/������ ����1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer1(), ioId, inWeightSkewer1);
     -- ��������� �������� <���������� ������ ����2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer2(), ioId, inCountSkewer2);
     -- ��������� �������� <��� ����� ������ ����2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer2(), ioId, inWeightSkewer2);
     -- ��������� �������� <���, ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightOther(), ioId, inWeightOther);

     -- ��������� �������� <MovementItemId - ������ ������������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMovementItemId);

     -- ��������� �������� <������ ������ (����)>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <����� ��-��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), ioId, inStorageLineId);
     
    
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.15                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingProduction (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
