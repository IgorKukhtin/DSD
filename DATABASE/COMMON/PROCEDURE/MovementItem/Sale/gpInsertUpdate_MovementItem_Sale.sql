-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inGoodsId                 Integer   , -- ������
    IN inAmount                  TFloat    , -- ����������
 INOUT ioAmountPartner           TFloat    , -- ���������� � �����������
   OUT outAmountChangePercent    TFloat    , -- ���������� c ������ % ������ (!!!������!!!)
    IN inChangePercentAmount     TFloat    , -- % ������ ��� ���-�� (!!!�� ��������!!!)
 INOUT ioChangePercentAmount     TFloat    , -- % ������ ��� ���-�� (!!!�� �����!!!)
    IN inIsChangePercentAmount   Boolean   , -- ������� - ����� �� �������������� �� �������� <% ������ ��� ���-��>
    IN inIsCalcAmountPartner     Boolean   , -- ������� - ����� �� ��������� <���������� � �����������>
    IN inPrice                   TFloat    , -- ����
 INOUT ioCountForPrice           TFloat    , -- ���� �� ����������
   OUT outAmountSumm             TFloat    , -- ����� ���������
    IN inHeadCount               TFloat    , -- ���������� �����
    IN inBoxCount                TFloat    , -- ���������� ������
    IN inPartionGoods            TVarChar  , -- ������ ������
    IN inGoodsKindId             Integer   , -- ���� �������
    IN inAssetId                 Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inBoxId                   Integer   , -- �����
   OUT outWeightPack             TFloat    ,
   OUT outWeightTotal            TFloat    , 
   OUT outCountPack              TFloat    , 
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());


     -- !!!�� ��������!!! - % ������ ��� ���-��
     IF inIsChangePercentAmount = TRUE
     THEN
         IF EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND ChildObjectId = zc_Measure_Kg())
         THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!�� ��������!!!
         ELSE ioChangePercentAmount:= 0;
         END IF;
     END IF;

     -- !!!������!!! - ���������� c ������ % ������
     outAmountChangePercent:= CAST (inAmount * (1 - COALESCE (ioChangePercentAmount, 0) / 100) AS NUMERIC (16, 3));

     IF inIsCalcAmountPartner = TRUE
     THEN
         ioAmountPartner:= outAmountChangePercent;
     END IF;

     -- ������ ��������
     SELECT COALESCE (ObjectFloat_WeightPackage.ValueData,0)::TFloat  AS WeightPack
          , COALESCE (ObjectFloat_WeightTotal.ValueData,0)  ::TFloat  AS WeightTotal
         into outWeightPack, outWeightTotal
     FROM Object_GoodsByGoodsKind_View
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                 ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()

           LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                 ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
      WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId 
        AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;

      IF COALESCE (outWeightPack,0) <> 0 AND 
         COALESCE (outWeightTotal,0) <> 0 AND 
         COALESCE ((1-outWeightPack/outWeightTotal), 0) <> 0
      THEN 
          outCountPack:= CAST (((ioAmountPartner/(1-outWeightPack/outWeightTotal))/ outWeightTotal) AS NUMERIC (16, 4));
      ELSE
          outCountPack:= 0;
      END IF;
      

     -- ���������
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountPartner      := ioAmountPartner
                                          , inAmountChangePercent:= outAmountChangePercent
                                          , inChangePercentAmount:= ioChangePercentAmount
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          
                                          , inCountPack          := COALESCE (outCountPack, 0) ::TFloat
                                          , inWeightTotal        := COALESCE (outWeightTotal,0) ::TFloat
                                          , inWeightPack         := COALESCE (outWeightPack,0) ::TFloat
                                          , inIsBarCode          := COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE MovementItemId = ioId AND DescId = zc_MIBoolean_BarCode()), FALSE) 
                                                                                                                              
                                          , inUserId             := vbUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.10.14                                                       * add box
 08.02.14                                        * ���� ������ � lpInsertUpdate_MovementItem_Sale
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
