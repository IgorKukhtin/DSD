-- Function: gpInsertUpdate_MovementItem_Sale()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inGoodsId                 Integer   , -- ������
 INOUT ioAmount                  TFloat    , -- ����������
 INOUT ioAmountPartner           TFloat    , -- ���������� � �����������
   OUT outAmountChangePercent    TFloat    , -- ���������� c ������ % ������ (!!!������!!!)
    IN inChangePercentAmount     TFloat    , -- % ������ ��� ���-�� (!!!�� ��������!!!)
 INOUT ioChangePercentAmount     TFloat    , -- % ������ ��� ���-�� (!!!�� �����!!!)
    IN inIsChangePercentAmount   Boolean   , -- ������� - ����� �� �������������� �� �������� <% ������ ��� ���-��>
    IN inIsCalcAmountPartner     Boolean   , -- ������� - ����� �� ��������� <���������� � �����������>
 INOUT ioPrice                   TFloat    , -- ����
 INOUT ioCountForPrice           TFloat    , -- ���� �� ����������
   OUT outAmountSumm             TFloat    , -- ����� ��������� 
    IN inCount                   TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount               TFloat    , -- ���������� �����
    IN inBoxCount                TFloat    , -- ���������� ������
    IN inPartionGoods            TVarChar  , -- ������ ������
    IN inGoodsKindId             Integer   , -- ���� �������
    IN inAssetId                 Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inBoxId                   Integer   , -- �����
   OUT outWeightPack             TFloat    ,
   OUT outWeightTotal            TFloat    , 
   OUT outCountPack              TFloat    , 
   OUT outMovementPromo          TVarChar  , -- 
   OUT outPricePromo             Numeric (16,8), --
   OUT outGoodsRealCode         Integer  , -- ����� (���� ��������)
   OUT outGoodsRealName         TVarChar  , -- ����� (���� ��������)
   OUT outGoodsKindRealName     TVarChar  , -- ��� ������ (���� ��������) 
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMeasureId Integer;
   DECLARE vbIsBarCode Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     -- �������� ��������
     vbMeasureId:= (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = inGoodsId AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure());
     -- �������� ��������
     vbIsBarCode:= COALESCE ((SELECT MIBoolean.ValueData FROM MovementItemBoolean AS MIBoolean WHERE MIBoolean.MovementItemId = ioId AND MIBoolean.DescId = zc_MIBoolean_BarCode()), FALSE);

     -- !!!������ - ��� ��������!!!
     IF vbIsBarCode = TRUE
     THEN
         -- !!!�� ��������!!! - % ������ ��� ���-��
         IF inIsChangePercentAmount = TRUE
         THEN
             IF vbMeasureId = zc_Measure_Kg()
             THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!�� ��������!!!
             ELSE ioChangePercentAmount:= 0;
             END IF;
         END IF;

         -- ��������: ���� �������� ��� ����� ���� �������� ��� ��� ���������, ������� ������
         IF ioId <> 0 AND EXISTS (SELECT 1 FROM MovementItemFloat AS MIFloat WHERE MIFloat.MovementItemId = ioId AND MIFloat.DescId = zc_MIFloat_AmountPartner() AND MIFloat.ValueData = ioAmountPartner)
                      AND NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Master() AND MI.Amount = ioAmount)
                      AND vbMeasureId = zc_Measure_Kg()
         THEN
             RAISE EXCEPTION '������.���� ��������, �.�. <���-�� �����> �������� ��������� ���� ���������� ������� <������ ����. ����.>.';
         END IF;

         -- �������� �������� ��� ��������
         SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
                INTO outWeightPack, outWeightTotal
         FROM Object_GoodsByGoodsKind_View
              -- ��� 1-��� ������ - ��� ������ ��� ��������
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                    ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                   AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
              --  ��� � �������� - "������" ��� + ��� 1-��� ������
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                    ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                   AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
         WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId 
           AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;
         -- ������ ���-�� ��. �������� (���� ���������� �� 4-� ������)
         outCountPack:= CASE WHEN outWeightTotal <> 0 AND outWeightPack <> 0 AND outWeightTotal > outWeightPack
                                  THEN CAST (CAST (ioAmountPartner / (1 - outWeightPack / outWeightTotal) AS NUMERIC (16, 4)) / outWeightTotal AS NUMERIC (16, 4))
                             ELSE 0
                        END;

         IF vbMeasureId = zc_Measure_Kg()
         THEN
             -- !!!������ � ���� ������ ������ "���-�� �����"!!!
             ioAmount:= (ioAmountPartner + CAST (outCountPack * COALESCE (outWeightPack, 0) / (1 - CASE WHEN ioChangePercentAmount < 100 THEN ioChangePercentAmount/100 ELSE 0 END) AS NUMERIC (16, 4)));
             -- !!!��������� "������" ������!!!
             --ioChangePercentAmount:= 0;
             --inIsChangePercentAmount:= FALSE;
             -- !!!������!!! - ���������� c ������ % ������
             outAmountChangePercent:= ioAmountPartner;
         ELSE
             -- !!!��������� "������" ������!!!
             ioChangePercentAmount:= 0;
             inIsChangePercentAmount:= FALSE;
             -- !!!������!!! - ���������� c ������ % ������
             outAmountChangePercent:= ioAmount;
         END IF;

     ELSE
         -- !!!�� ��������!!! - % ������ ��� ���-��
         IF inIsChangePercentAmount = TRUE
         THEN
             IF vbMeasureId = zc_Measure_Kg()
             THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!�� ��������!!!
             ELSE ioChangePercentAmount:= 0;
             END IF;
         END IF;
         -- !!!������!!! - ���������� c ������ % ������
         outAmountChangePercent:= CAST (ioAmount * (1 - COALESCE (ioChangePercentAmount, 0) / 100) AS NUMERIC (16, 3));

     END IF;


     IF inIsCalcAmountPartner = TRUE
     THEN
         -- !!!������!!! - ���������� c � ����������
         ioAmountPartner:= outAmountChangePercent;
     END IF;


     -- ���������
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice, tmp.outAmountSumm
          , zfCalc_PromoMovementName (tmp.outMovementId_Promo, NULL, NULL, NULL, NULL)
          , tmp.outPricePromo
          , tmp.outGoodsRealCode, tmp.outGoodsRealName
          , tmp.outGoodsKindRealName
            INTO ioId, ioPrice, ioCountForPrice, outAmountSumm, outMovementPromo, outPricePromo
               , outGoodsRealCode, outGoodsRealName, outGoodsKindRealName
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := ioAmount
                                          , inAmountPartner      := ioAmountPartner
                                          , inAmountChangePercent:= outAmountChangePercent
                                          , inChangePercentAmount:= ioChangePercentAmount
                                          , ioPrice              := ioPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inCount              := inCount 
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          
                                          , inCountPack          := COALESCE (outCountPack, 0)
                                          , inWeightTotal        := COALESCE (outWeightTotal, 0)
                                          , inWeightPack         := COALESCE (outWeightPack, 0)
                                          , inIsBarCode          := vbIsBarCode
                                                                                                                              
                                          , inUserId             := vbUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.07.22         * inCount
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
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, ioAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, ioPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
