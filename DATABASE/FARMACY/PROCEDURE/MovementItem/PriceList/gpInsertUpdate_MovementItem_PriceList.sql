-- Function: gpInsertUpdate_MovementItem_PriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, Integer, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PriceList(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsMainId         Integer   , -- ������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����
    IN inPartionGoodsDate    TDateTime , -- ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;

     -- 
     PERFORM lpInsertUpdate_MovementItem_PriceList (ioId, inMovementId, inGoodsMainId, inGoodsId
                                                  , inAmount
                                                  , COALESCE ((SELECT MIFloat.ValueData FROM MovementItemFloat AS MIFloat WHERE MIFloat.MovementItemId =  ioId AND MIFloat.DescId = zc_MIFloat_Price()), 0)
                                                  , inPartionGoodsDate, NULL, vbUserId
                                                   );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.09.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PriceList (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
