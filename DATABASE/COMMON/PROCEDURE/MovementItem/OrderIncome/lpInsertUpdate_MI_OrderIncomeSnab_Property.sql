-- Function: lpInsertUpdate_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderIncomeSnab_Property (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderIncomeSnab_Property (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderIncomeSnab_Property (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderIncomeSnab_Property(
    IN inId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   , -- 
    IN inGoodsId              Integer   , -- ������
    IN inMeasureId            Integer   , -- 
    IN inRemainsStart         TFloat    , -- 
    --IN inRemainsEnd           TFloat    , -- 
    IN inBalanceStart         TFloat    , -- 
    IN inBalanceEnd           TFloat    , -- 
    IN inIncome               TFloat    , -- 
    IN inAmountForecast       TFloat    , -- 
    IN inAmountIn             TFloat    , -- 
    IN inAmountOut            TFloat    , -- 
    IN inAmountOrder          TFloat    , -- 
    IN inUserId               Integer     -- ������������
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     IF COALESCE (inId, 0) = 0
     THEN
         -- ������
         IF COALESCE (inMeasureId, 0) = 0
         THEN
             inMeasureId:= zc_Measure_Sht();
         END IF;
           
         -- ��������� <������� ���������>
         inId := lpInsertUpdate_MovementItem (COALESCE (inId, 0), zc_MI_Master(), inMeasureId, inMovementId, 0, NULL);

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), inId, inGoodsId);
     END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), inId, inRemainsStart);
   -- ��������� �������� <>
   --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsEnd(), inId, inRemainsEnd);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BalanceStart(), inId, inBalanceStart);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BalanceEnd(), inId, inBalanceEnd);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Income(), inId, inIncome);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecast(), inId, inAmountForecast);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountIn(), inId, inAmountIn);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut(), inId, inAmountOut);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), inId, inAmountOrder);
   
  
   -- ��������� ��������
   -- PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.04.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_OrderIncomeSnab_Property (inId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
