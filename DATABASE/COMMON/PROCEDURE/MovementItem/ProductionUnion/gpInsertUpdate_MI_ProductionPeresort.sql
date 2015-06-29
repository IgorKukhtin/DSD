-- Function: gpInsertUpdate_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TVarChar, Integer, Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inGoodsId                Integer   , -- �����
    IN inAmountOut              TFloat    , -- ���������� ������
   OUT outAmountIn              TFloat    , -- ���������� ������  - ������ ����� : outAmountIn= inAmountOut * ���  ��� inAmountOut / ��� ���  inAmountOut
                                                                 -- �.�. � ����������� �� ��.���. ��� ������ ������ � ������ �����  ��� ����������
    IN inPartionGoods           TVarChar  , -- ������ ������
    IN inPartionGoodsDate       TDateTime , -- ������ ������
    IN inComment                TVarChar  , -- ����������	                   
    IN inGoodsKindId            Integer   , -- ���� ������� 
 INOUT ioGoodsChildId           Integer   , -- ������
    IN inPartionGoodsChild      TVarChar  , -- ������ ������  
    IN inPartionGoodsDateChild  TDateTime , -- ������ ������    
    IN inGoodsKindChildId       Integer   , -- ���� �������
   OUT outGoodsChilCode         Integer   , --
   OUT outGoodsChildName        TVarChar  , --
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS Record AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbChildId Integer;
   DECLARE vbMeasureId  Integer;
   DECLARE vbMeasureChildId Integer;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   
   -- ������ ��������
   IF COALESCE (ioGoodsChildId, 0) = 0 
   THEN
       ioGoodsChildId:= inGoodsId;
   END IF;
   --
   outGoodsChildName:= (SELECT ValueData FROM Object WHERE Id = ioGoodsChildId);
   outGoodsChilCode:= (SELECT ObjectCode FROM Object WHERE Id = ioGoodsChildId);
   
  
   vbMeasureId:=(Select  ObjectLink_Goods_Measure.ChildObjectId AS Measure1
                 FROM Object 
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                 WHERE Id = inGoodsId );
   vbMeasureChildId:=(Select ObjectLink_Goods_Measure.ChildObjectId 
                      FROM Object 
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                      WHERE Id = ioGoodsChildId );

   outAmountIn:= CAST( (Select Case when vbMeasureId = vbMeasureChildId then inAmountOut 
                              When (vbMeasureId = zc_Measure_Sh() and vbMeasureChildId = zc_Measure_kg()) then inAmountOut / ObjectFloat_Weight.ValueData 
                              When (vbMeasureId = zc_Measure_kg() and vbMeasureChildId = zc_Measure_Sh()) then inAmountOut * ObjectFloat_Weight.ValueData
                              else inAmountOut end
                  From ObjectFloat AS ObjectFloat_Weight
                  WHERE ObjectFloat_Weight.ObjectId = ioGoodsChildId -- Object.Id
                    AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                 ) AS TFloat) ;
               
   
   IF COALESCE (ioId,0) <> 0
   THEN
      vbChildId := (SELECT Id FROM MovementItem WHERE MovementId = inMovementId 
                                                  AND ParentId   = ioId
                                                  AND DescId     = zc_MI_Child());
   END IF;

   -- ��������� <Master>
   ioId:= lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmountOut
                                                  , inCount            := 0
                                                  , inPartionGoodsDate := inPartionGoodsDate
                                                  , inPartionGoods     := inPartionGoods
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inUserId           := vbUserId
                                                   );


   -- ��������� �������� <������ ������> ��� �������
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

   -- ��������� <Child>
   vbChildId := lpInsertUpdate_MI_ProductionUnion_Child (ioId               := vbChildId
                                                       , inMovementId       := inMovementId
                                                       , inGoodsId          := ioGoodsChildId
                                                       , inAmount           := inAmountOut
                                                       , inParentId         := ioId
                                                       , inPartionGoodsDate := inPartionGoodsDateChild
                                                       , inPartionGoods     := inPartionGoodsChild
                                                       , inGoodsKindId      := inGoodsKindChildId
                                                       , inUserId           := vbUserId
                                                        );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.03.15                                        * all
 26.12.14                                        *
 11.12.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
-- select * from gpInsertUpdate_MI_ProductionPeresort(ioId := 0 , inMovementId := 597577 , inGoodsId := 2589 , inAmount := 5 , inPartionGoods := '' , inComment := '' , inGoodsKindId := 8330 , inGoodsChildId := 0 , inPartionGoodsChild := '' , inGoodsKindChildId := 0 ,  inSession := '5');
