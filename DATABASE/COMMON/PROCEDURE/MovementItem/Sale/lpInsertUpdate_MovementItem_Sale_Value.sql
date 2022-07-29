-- Function: lpInsertUpdate_MovementItem_Sale_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale_Value(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountChangePercent TFloat    , -- ���������� c ������ % ������
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inPrice               TFloat    , -- ����
    IN ioCountForPrice       TFloat    , -- ���� �� ����������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inBoxCount            TFloat    , -- ���������� ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inBoxId               Integer   , -- �����
--    IN inCountPack           TFloat    , -- ���������� �������� (������)
--    IN inWeightTotal         TFloat    , -- ��� 1 ��. ��������� + ��������
--    IN inWeightPack          TFloat    , -- ��� �������� ��� 1-�� ��. ���������
    IN inIsBarCode           Boolean   , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCountPack TFloat;
   DECLARE vbWeightTotal TFloat;
   DECLARE vbWeightPack TFloat;
   DECLARE vbPartionGoodsDate TDateTime;
BEGIN

     -- !!!������ - ��� ��������!!!
     IF inIsBarCode = TRUE
     THEN
         -- �������� �������� ��� ��������
         SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
                INTO vbWeightPack, vbWeightTotal
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
         vbCountPack:= CASE WHEN vbWeightTotal <> 0
                                 THEN CAST (inAmount / vbWeightTotal AS NUMERIC (16, 4))
                            ELSE 0
                       END;
     END IF;
     
     vbPartionGoodsDate:= zfConvert_StringToDate (inPartionGoods);

     -- ���������
     SELECT tmp.ioId INTO ioId
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountPartner      := inAmountPartner
                                          , inAmountChangePercent:= inAmountChangePercent
                                          , inChangePercentAmount:= inChangePercentAmount
                                          , ioPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice 
                                          , inCount              := inCount
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := CASE WHEN vbPartionGoodsDate > zc_DateStart() THEN '' ELSE inPartionGoods END
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          , inCountPack          := COALESCE (vbCountPack, 0)
                                          , inWeightTotal        := COALESCE (vbWeightTotal,0)
                                          , inWeightPack         := COALESCE (vbWeightPack,0)
                                          , inIsBarCode          := inIsBarCode

                                          , inUserId             := inUserId
                                           ) AS tmp;


     -- �������� �������� <������ ������-����>
     IF vbPartionGoodsDate > zc_DateStart()
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, vbPartionGoodsDate);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.11.15                                        *
 04.02.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Sale_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
