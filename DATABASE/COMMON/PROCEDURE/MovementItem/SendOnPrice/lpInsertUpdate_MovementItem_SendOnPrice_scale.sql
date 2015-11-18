-- Function: gpInsertUpdate_MovementItem_SendOnPrice()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice_scale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice_scale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SendOnPrice_scale(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountChangePercent TFloat    , -- ���������� c ������ % ������
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inUnitId              Integer   , -- 
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

     -- ���������
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_MovementItem_SendOnPrice
                                           (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountPartner      := inAmountPartner
                                          , inAmountChangePercent:= inAmountChangePercent
                                          , inChangePercentAmount:= inChangePercentAmount
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := inCountForPrice
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inUnitId             := inUnitId

                                          , inCountPack          := COALESCE (vbCountPack, 0)
                                          , inWeightTotal        := COALESCE (vbWeightTotal,0)
                                          , inWeightPack         := COALESCE (vbWeightPack,0)
                                          , inIsBarCode          := inIsBarCode

                                          , inUserId             := inUserId
                                           ) AS tmp);

     -- ��������� ����� � <Unit>
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

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
-- SELECT * FROM gpInsertUpdate_MovementItem_SendOnPrice (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
