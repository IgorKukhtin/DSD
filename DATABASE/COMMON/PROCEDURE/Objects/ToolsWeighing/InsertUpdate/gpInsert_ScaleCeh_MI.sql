-- Function: gpInsert_ScaleCeh_MI()

DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleCeh_MI(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inIsStartWeighing     Boolean   , -- ����� ������ �����������
    IN inIsPartionGoodsDate  Boolean   , -- 
    IN inOperCount           TFloat    , -- ����������
    IN inRealWeight          TFloat    , -- �������� ��� (��� ����� % ������ ��� ���-��)
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
    IN inSession             TVarChar    -- ������ ������������
)                              

RETURNS TABLE (Id        Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     vbId:= gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                          , inMovementId          := inMovementId
                                                          , inGoodsId             := inGoodsId
                                                          , inAmount              := inOperCount
                                                          , inIsStartWeighing     := inIsStartWeighing
                                                          , inRealWeight          := inRealWeight
                                                          , inWeightTare          := inWeightTare
                                                          , inLiveWeight          := inLiveWeight
                                                          , inHeadCount           := inHeadCount
                                                          , inCount               := inCount
                                                          , inCountPack           := inCountPack
                                                          , inCountSkewer1        := inCountSkewer1
                                                          , inWeightSkewer1       := inWeightSkewer1
                                                          , inCountSkewer2        := inCountSkewer2
                                                          , inWeightSkewer2       := inWeightSkewer2
                                                          , inWeightOther         := inWeightOther
                                                          , inPartionGoodsDate    := CASE WHEN inIsPartionGoodsDate = TRUE THEN inPartionGoodsDate ELSE NULL END :: TDateTime
                                                          , inPartionGoods        := inPartionGoods
                                                          , inGoodsKindId         := CASE WHEN (SELECT View_InfoMoney.InfoMoneyDestinationId
                                                                                                FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                                                     LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                                WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                                                               ) IN (zc_Enum_InfoMoneyDestination_20500() -- ������������� + ��������� ����
                                                                                                   , zc_Enum_InfoMoneyDestination_20600() -- ������������� + ������ ���������
                                                                                                    )
                                                                                               THEN 0
                                                                                          ELSE inGoodsKindId
                                                                                     END
                                                          , inSession             := inSession
                                                           );

     -- ���������
     RETURN QUERY
       SELECT vbId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsert_ScaleCeh_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
