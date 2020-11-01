-- Function: gpInsertUpdate_MI_ProductionPeresort()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inGoodsId                Integer   , -- �����
    IN inAmountOut              TFloat    , -- ���������� ������
  
    IN inPartionGoods           TVarChar  , -- ������ ������
    IN inPartionGoodsDate       TDateTime , -- ������ ������
    IN inComment                TVarChar  , -- ����������	                   
    IN inGoodsKindId            Integer   , -- ���� ������� 
    IN inGoodsKindId_Complete   Integer   , -- ���� �������
 INOUT ioGoodsChildId           Integer   , -- ������
    IN inPartionGoodsChild      TVarChar  , -- ������ ������  
    IN inPartionGoodsDateChild  TDateTime , -- ������ ������    
    IN inGoodsKindChildId       Integer   , -- ���� �������
    IN inGoodsKindId_Complete_child  Integer   , -- ���� �������
   OUT outGoodsChilCode         Integer   , --
   OUT outGoodsChildName        TVarChar  , --
   OUT outAmountIn              TFloat    , -- ���������� ������  - ������ ����� : outAmountIn= inAmountOut * ���  ��� inAmountOut / ��� ���  inAmountOut
                                                                 -- �.�. � ����������� �� ��.���. ��� ������ ������ � ������ �����  ��� ����������
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS Record AS
$BODY$
   DECLARE vbUserId          Integer;

   DECLARE vbMeasureId       Integer;
   DECLARE vbMeasureId_child Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   

   -- ������ ��������
   IF COALESCE (ioGoodsChildId, 0) = 0 
   THEN
       ioGoodsChildId:= inGoodsId;
   END IF;
   
  
   -- �����
   vbMeasureId:= (SELECT ObjectLink_Goods_Measure.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Goods_Measure
                  WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure());
   -- �����
   vbMeasureId_child:= (SELECT ObjectLink_Goods_Measure.ChildObjectId
                        FROM ObjectLink AS ObjectLink_Goods_Measure
                        WHERE ObjectLink_Goods_Measure.ObjectId = ioGoodsChildId
                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure());

   -- ��������� Kg -> Sh
   IF vbMeasureId = zc_Measure_Sh() AND vbMeasureId_child = zc_Measure_Kg()
   THEN
       -- ������
       outAmountIn:= (SELECT inAmountOut / ObjectFloat_Weight.ValueData 
                      FROM ObjectFloat AS ObjectFloat_Weight
                      WHERE ObjectFloat_Weight.ObjectId = inGoodsId
                        AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        AND ObjectFloat_Weight.ValueData <> 0
                     ) ;
   ELSE
   -- ��������� Sh -> Kg
   IF vbMeasureId = zc_Measure_Kg() AND vbMeasureId_child = zc_Measure_Sh()
   THEN
       -- ������
       outAmountIn:= (SELECT inAmountOut * ObjectFloat_Weight.ValueData
                      FROM ObjectFloat AS ObjectFloat_Weight
                      WHERE ObjectFloat_Weight.ObjectId = ioGoodsChildId
                        AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        AND ObjectFloat_Weight.ValueData <> 0
                     ) ;
   ELSE
       -- ������ �� ������
       outAmountIn:= inAmountOut;
   END IF;
   END IF;

   -- ��������
   IF COALESCE (outAmountIn, 0) = 0 AND inAmountOut <> 0
   THEN
       RAISE EXCEPTION '������.� ������ �� ����������� �������� <���>.';
   END IF;

   -- ���������
   ioId:= lpInsertUpdate_MI_ProductionPeresort (ioId                     := ioId
                                              , inMovementId             := inMovementId
                                              , inGoodsId                := inGoodsId
                                              , inGoodsId_child          := ioGoodsChildId
                                              , inGoodsKindId            := inGoodsKindId
                                              , inGoodsKindId_child      := inGoodsKindChildId
                                              , inAmount                 := outAmountIn
                                              , inAmount_child           := inAmountOut
                                              , inPartionGoods           := inPartionGoods
                                              , inPartionGoods_child     := inPartionGoodsChild
                                              , inPartionGoodsDate       := inPartionGoodsDate
                                              , inPartionGoodsDate_child := inPartionGoodsDateChild
                                              , inUserId                 := vbUserId
                                               );

   --
   outGoodsChildName:= (SELECT ValueData FROM Object WHERE Id = ioGoodsChildId);
   outGoodsChilCode:= (SELECT ObjectCode FROM Object WHERE Id = ioGoodsChildId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.07.15                                        * all
 29.06.15         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
-- SELECT * from gpInsertUpdate_MI_ProductionPeresort(ioId := 0 , inMovementId := 597577 , inGoodsId := 2589 , inAmount := 5 , inPartionGoods := '' , inComment := '' , inGoodsKindId := 8330 , inGoodsChildId := 0 , inPartionGoodsChild := '' , inGoodsKindChildId := 0 ,  inSession := '5');
