-- Function: gpInsert_Scale_MI()
/*
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);
*/
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_MI(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inGoodsKindId           Integer   , -- ���� �������
    IN inRealWeight            TFloat    , -- �������� ��� (��� �����: ����� ���� � % ������ ��� ���-��)
    IN inChangePercentAmount   TFloat    , -- % ������ ��� ���-��
    IN inCountTare             TFloat    , -- ���������� ����
    IN inWeightTare            TFloat    , -- ��� 1-�� ����
    IN inPrice                 TFloat    , -- ����
    IN inPrice_Return          TFloat    , -- ����
    IN inCountForPrice         TFloat    , -- ���� �� ����������
    IN inCountForPrice_Return  TFloat    , -- ���� �� ����������
    IN inDayPrior_PriceReturn  Integer,
    IN inCount                 TFloat    , -- ���������� ������� ��� ���������� �������
    IN inHeadCount             TFloat    , -- 
    IN inBoxCount              TFloat    , -- 
    IN inBoxCode               Integer   , -- 
    IN inPartionGoods          TVarChar  , -- ������
    IN inPriceListId           Integer   , --
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id        Integer
             , TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMovementDescId Integer;
   DECLARE vbMovementId_order Integer;
   DECLARE vbBoxId Integer;
   DECLARE vbTotalSumm TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Scale_MI());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����������
     SELECT Movement.OperDate, MovementFloat.ValueData :: Integer, COALESCE (MLM_Order.MovementChildId, 0)
            INTO vbOperDate, vbMovementDescId, vbMovementId_order
     FROM Movement
          LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDesc()
          LEFT JOIN MovementLinkMovement AS MLM_Order
                                         ON MLM_Order.MovementId = Movement.Id
                                        AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
     WHERE Movement.Id = inMovementId;

     -- ����������
     vbBoxId:= CASE WHEN inBoxCode > 0 THEN (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBoxCode AND Object.DescId = zc_Object_Box()) ELSE 0 END;


     -- ���������
     vbId:= gpInsertUpdate_MovementItem_WeighingPartner (ioId                  := 0
                                                       , inMovementId          := inMovementId
                                                       , inGoodsId             := inGoodsId
                                                       , inAmount              := inRealWeight - inCountTare * inWeightTare
                                                       , inAmountPartner       := CAST ((inRealWeight - inCountTare * inWeightTare) * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))
                                                       , inRealWeight          := inRealWeight
                                                       , inChangePercentAmount := inChangePercentAmount
                                                       , inCountTare           := inCountTare
                                                       , inWeightTare          := inWeightTare
                                                       , inCountPack           := inCount
                                                       , inHeadCount           := inHeadCount
                                                       , inBoxCount            := inBoxCount
                                                       , inBoxNumber           := CASE WHEN vbMovementDescId <> zc_Movement_Sale() THEN 0 ELSE  1 + COALESCE ((SELECT MAX (MovementItemFloat.ValueData) FROM MovementItem INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id AND MovementItemFloat.DescId = zc_MIFloat_BoxNumber() WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE), 0) END
                                                       , inLevelNumber         := 0
                                                       , inPrice               := CASE WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                                                                            THEN inPrice_Return
                                                                                       WHEN vbMovementDescId = zc_Movement_Sale()
                                                                                            AND vbMovementId_order = 0 -- !!!���� �� �� ������!!!
                                                                                            THEN COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate
                                                                                                                                                                        , inPriceListId:= inPriceListId
                                                                                                                                                                        , inGoodsId    := inGoodsId
                                                                                                                                                                        , inSession    := inSession
                                                                                                                                                                         ) AS tmp), 0)
                                                                                       ELSE inPrice
                                                                                  END
                                                                                   /*CASE WHEN vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_SendOnPrice())
                                                                                            THEN 
                                                                                       ELSE 0
                                                                                  END*/
                                                       , inCountForPrice       := CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN inCountForPrice_Return ELSE inCountForPrice END
                                                       , inPartionGoods        := inPartionGoods
                                                       , inPartionGoodsDate    := NULL
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
                                                       , inPriceListId         := inPriceListId
                                                       , inBoxId               := vbBoxId
                                                       , inSession             := inSession
                                                        );

     -- 
     vbTotalSumm:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_TotalSumm());

     -- ���������
     RETURN QUERY
       SELECT vbId, vbTotalSumm;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.15                                        * all
 13.10.14                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsert_Scale_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
