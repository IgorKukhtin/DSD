-- Function: gpInsertUpdate_MovementItem_OrderGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderGoods(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId                Integer   , -- ������
    --IN inGoodsKindId            Integer   , -- ���� �������
    IN inAmount                 TFloat    , -- ���������� ��
    IN inAmountSecond           TFloat    , -- ���������� ��
    IN inPrice                  TFloat    , --
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbWeight TFloat;
   DECLARE vbMeasureId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderGoods());
 
 
     -- �������� ��� ������� �� ��� ��
     IF COALESCE (inAmount, 0) <> 0 AND COALESCE (inAmountSecond, 0) <> 0
     THEN
     	 RAISE EXCEPTION '������.������������� ���� ���������� � ���� �� ��������.';
     END IF;
     
     vbWeight := (SELECT ObjectFloat_Weight.ValueData
                  FROM ObjectFloat AS ObjectFloat_Weight
                  WHERE ObjectFloat_Weight.ObjectId = inGoodsId
                    AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                  );
     vbMeasureId :=COALESCE ((SELECT ObjectLink_Goods_Measure.ChildObjectId
                              FROM ObjectLink AS ObjectLink_Goods_Measure
                              WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                             ),0) ;

/*
     --�������� �� ��� ��
     IF COALESCE (inAmount, 0) = 0 AND vbMeasureId <> zc_Measure_Sh() 
     THEN
         -- �������� ��� �� ������
         inAmount := (inAmountSecond * COALESCE (vbWeight,1));
         inAmountSecond := 0;
     END IF;

     IF COALESCE (inAmountSecond, 0) = 0 AND vbMeasureId = zc_Measure_Sh() 
     THEN
         -- �������� �� �� ����
         inAmountSecond := ( CASE WHEN vbWeight <> 0 THEN inAmount /vbWeight ELSE 0 END);
         inAmount := 0;
     END IF;
     */
     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_OrderGoods (ioId           := ioId
                                                     , inMovementId   := inMovementId
                                                     , inGoodsId      := inGoodsId
                                                     , inAmount       := inAmount
                                                     , inAmountSecond := inAmountSecond
                                                     , inPrice        := inPrice
                                                     , inComment      := inComment
                                                     , inUserId       := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.21         *
*/

-- ����
--