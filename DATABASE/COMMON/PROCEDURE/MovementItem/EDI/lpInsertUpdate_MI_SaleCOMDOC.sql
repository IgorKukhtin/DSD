-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SaleCOMDOC(Integer, Integer, Integer, TFloat, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SaleCOMDOC(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , 
    IN inGoodsKindId         Integer   , -- �����
    IN inAmountPartner       TFloat    , -- ����������
    IN inPricePartner        TFloat      -- ����
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbMovementItemId Integer;
BEGIN

     vbMovementItemId := COALESCE((SELECT Id  
       FROM MovementItem 
       JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  AND MILinkObject_GoodsKind.ObjectId = inGoodsKindId
  LEFT JOIN MovementItemFloat AS MIFloat_Price
                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.ObjectId = inGoodsId
        AND MovementItem.DescId = zc_MI_Master() 
        AND ((MIFloat_Price.ValueData = inPricePartner) OR (COALESCE(inPricePartner,0) = 0))
         ), 0);

     IF COALESCE(vbMovementItemId, 0) = 0 THEN 
        -- ��������� <������� ���������>
        vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
        -- ��������� ����� � <���� �������>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbMovementItemId, inGoodsKindId);
     END IF;
     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), vbMovementItemId, inAmountPartner);
     IF COALESCE(inPricePartner, 0) <> 0 THEN
        -- ��������� �������� <����>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPricePartner);
     END IF; 
     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.14                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
