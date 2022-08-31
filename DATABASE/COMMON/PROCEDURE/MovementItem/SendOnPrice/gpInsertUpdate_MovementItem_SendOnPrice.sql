-- Function: gpInsertUpdate_MovementItem_SendOnPrice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean,Boolean, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean,Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendOnPrice(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����������

 INOUT ioAmountPartner           TFloat    , -- ���������� � �����������
   OUT outAmountChangePercent    TFloat    , -- ���������� c ������ % ������ (!!!������!!!)
    IN inChangePercentAmount     TFloat    , -- % ������ ��� ���-�� (!!!�� �����!!!)
 INOUT ioChangePercentAmount     TFloat    , -- % ������ ��� ���-�� (!!!�� �����!!!)
    IN inIsChangePercentAmount   Boolean   , -- ������� - ����� �� �������������� �� �������� <% ������ ��� ���-��>
    IN inIsCalcAmountPartner     Boolean   , -- ������� - ����� �� ��������� <���������� � �����������>

    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inCount               TFloat    , -- ���������� ������� (������)
    IN inCountPartner        TFloat    , -- ���������� �������(������)

    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inUnitId              Integer   , -- �������������

   OUT outWeightPack             TFloat    ,
   OUT outWeightTotal            TFloat    , 
   OUT outCountPack              TFloat    , 

    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsBarCode Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice());

     -- �������� ��������
     vbIsBarCode:= COALESCE ((SELECT MIBoolean.ValueData FROM MovementItemBoolean AS MIBoolean WHERE MIBoolean.MovementItemId = ioId AND MIBoolean.DescId = zc_MIBoolean_BarCode()), FALSE);

     -- !!!������ - ��� ��������!!!
     IF vbIsBarCode = TRUE
     THEN
         -- ��������: ���� �������� ��� ����� ���� �������� ��� ��� ���������, ������� ������
         IF ioId <> 0 AND EXISTS (SELECT 1 FROM MovementItemFloat AS MIFloat WHERE MIFloat.MovementItemId = ioId AND MIFloat.DescId = zc_MIFloat_AmountPartner() AND MIFloat.ValueData = ioAmountPartner)
                      AND NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Master() AND MI.Amount = ioAmount)
         THEN
             RAISE EXCEPTION '������.���� ��������, �.�. <���-�� �����> �������� ��������� ���� ���������� ������� <������ ����. ����.>.';
         END IF;

         -- �������� �������� ��� ��������
         SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
                INTO outWeightPack, outWeightTotal
         FROM Object_GoodsByGoodsKind_View
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                    ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                   AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
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

         -- !!!������ � ���� ������ ������ "���-�� �����"!!!
         ioAmount:= ioAmountPartner + CAST (outCountPack * COALESCE (outWeightPack, 0) AS NUMERIC (16, 4));
         -- !!!��������� "������" ������!!!
         ioChangePercentAmount:= 0;
         inIsChangePercentAmount:= FALSE;
         -- !!!������!!! - ���������� c ������ % ������
         outAmountChangePercent:= ioAmountPartner;

     ELSE
         -- !!!�� ��������!!! - % ������ ��� ���-��
         IF inIsChangePercentAmount = TRUE
         THEN
             IF EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND ChildObjectId = zc_Measure_Kg())
             THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!�� ��������!!!
             ELSE ioChangePercentAmount:= 0;
             END IF;
         END IF;

         -- !!!������!!! - ���������� c ������ % ������
         IF ioChangePercentAmount <> 0
         THEN outAmountChangePercent:= CAST (ioAmount * (1 - COALESCE (ioChangePercentAmount, 0) / 100) AS NUMERIC (16, 3));
         ELSE outAmountChangePercent:= ioAmount;
         END IF;
         
     END IF;

     IF inIsCalcAmountPartner = TRUE
     THEN
         ioAmountPartner:= outAmountChangePercent;
     END IF;


     -- ���������
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_SendOnPrice
                                            (ioId                := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := ioAmount
                                          , inAmountPartner      := ioAmountPartner
                                          , inAmountChangePercent:= outAmountChangePercent
                                          , inChangePercentAmount:= inChangePercentAmount
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inCount              := inCount
                                          , inCountPartner       := inCountPartner
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inUnitId             := inUnitId

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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.

 30.08.22         * add inCount, inCountPartner
 19.11.15         * 
 04.06.15         * add inUnitId
 05.05.14                                                        * ���� ������������ ����� ����� �������
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 05.09.13                                        * add zc_MIFloat_ChangePercentAmount
 12.07.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SendOnPrice (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
