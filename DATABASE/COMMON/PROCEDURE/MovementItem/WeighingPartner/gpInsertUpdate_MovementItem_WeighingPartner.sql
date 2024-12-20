-- Function: gpInsertUpdate_MovementItem_WeighingPartner()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingPartner(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inRealWeight          TFloat    , -- �������� ��� (��� �����: ����� ���� � % ������ ��� ���-��)
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inCountTare           TFloat    , -- ���������� ����
    IN inWeightTare          TFloat    , -- ��� ����

    IN inCountTare1          TFloat    , -- ���������� ��. ����1
    IN inWeightTare1         TFloat    , -- ��� ��. ����1
    IN inCountTare2          TFloat    , -- ���������� ��. ����2
    IN inWeightTare2         TFloat    , -- ��� ��. ����2
    IN inCountTare3          TFloat    , -- ���������� ��. ����3
    IN inWeightTare3         TFloat    , -- ��� ��. ����3
    IN inCountTare4          TFloat    , -- ���������� ��. ����4
    IN inWeightTare4         TFloat    , -- ��� ��. ����4
    IN inCountTare5          TFloat    , -- ���������� ��. ����5
    IN inWeightTare5         TFloat    , -- ��� ��. ����5
    IN inCountTare6          TFloat    , -- ���������� ��. ����6
    IN inWeightTare6         TFloat    , -- ��� ��. ����6
        
    IN inCountPack           TFloat    , -- ���������� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inBoxCount            TFloat    , -- ���������� ����(�����)
    IN inBoxNumber           TFloat    , -- ����� �����
    IN inLevelNumber         TFloat    , -- ����� ���� 
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inPartionGoods        TVarChar  , -- ������
    IN inPartionGoodsDate    TDateTime , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inPriceListId         Integer   , -- �����
    IN inBoxId               Integer   , -- ����(�����)
    IN inMovementId_Promo    Integer   ,
    IN inIsBarCode           Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <MovementId-�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, inMovementId_Promo);

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� �������� <����/����� ��������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);

     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <�������� ��� (��� �����: ����� ���� � % ������ ��� ���-��)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- ��������� �������� <% ������ ��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- ��������� �������� <���������� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare(), ioId, inCountTare);
     -- ��������� �������� <��� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- ��������� �������� <���������� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- ��������� �������� <���������� ����(�����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);
     -- ��������� �������� <����� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxNumber(), ioId, inBoxNumber);
     -- ��������� �������� <����� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LevelNumber(), ioId, inLevelNumber);
     -- ��������� �������� <�� �������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);

     -- ��������� �������� <���������� ��. ����1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), ioId, inCountTare1);
     -- ��������� �������� <��� ��. ����1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare1(), ioId, inWeightTare1);
     -- ��������� �������� <���������� ��. ����2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), ioId, inCountTare2);
     -- ��������� �������� <��� ��. ����2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare2(), ioId, inWeightTare2);
     -- ��������� �������� <���������� ��. ����3>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(), ioId, inCountTare3);
     -- ��������� �������� <��� ��. ����3>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare3(), ioId, inWeightTare3);
     -- ��������� �������� <���������� ��. ����4>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(), ioId, inCountTare4);
     -- ��������� �������� <��� ��. ����4>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare4(), ioId, inWeightTare4);
     -- ��������� �������� <���������� ��. ����5>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(), ioId, inCountTare5);
     -- ��������� �������� <��� ��. ����5>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare5(), ioId, inWeightTare5);
     -- ��������� �������� <���������� ��. ����6>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare6(), ioId, inCountTare6);
     -- ��������� �������� <��� ��. ����6>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare6(), ioId, inWeightTare6);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     -- ��������� �������� <(-)% ������ (+)% �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PriceList(), ioId, inPriceListId);
     -- ��������� ����� � <��� �����. ��.>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.02.20         *
 13.11.15                                        *
 13.10.14                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
