-- Function: gpInsertUpdate_MovementItem_OrderClient()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderClient(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderClient(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderClient(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
 INOUT ioOperPrice           TFloat    , -- ���� �� �������
    IN inOperPriceList       TFloat    , -- ���� ��� ������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inComment             TVarChar  , 
    IN inUserId              Integer     -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbIsInsert Boolean;
    DECLARE vbDiscountTax TFloat;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- % ������ ��� ������� ���� �� ������� ���� ������� �� ����� �� �����
     IF (SELECT Object.DescId FROM Object WHERE Object.Id = inGoodsId) <> zc_Object_Product()
     THEN
      --RAISE EXCEPTION ('111');
          
          vbDiscountTax := (SELECT (COALESCE (MovementFloat_DiscountTax.ValueData,0)
                                  + COALESCE (MovementFloat_DiscountNextTax.ValueData,0) ) ::TFloat AS DiscountTax
                            FROM Movement
                                LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                                        ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                                       AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
                                LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                                        ON MovementFloat_DiscountNextTax.MovementId = Movement.Id
                                                       AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()
                            WHERE Movement.Id = inMovementId
                            );
          -- ������������ ���� �� �������
          ioOperPrice := (CASE WHEN COALESCE (vbDiscountTax,0) > 0 THEN zfCalc_SummDiscountTax (inOperPriceList, vbDiscountTax)  ELSE inOperPriceList END );
     END IF;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- ��������� �������� <���� �� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, ioOperPrice);
     -- ��������� �������� <���� ��� ������> 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);
     -- ��������� �������� <���� �� ���.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.04.21         * inOperPriceList
 15.02.21         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderClient (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inGoodsName = '', inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
