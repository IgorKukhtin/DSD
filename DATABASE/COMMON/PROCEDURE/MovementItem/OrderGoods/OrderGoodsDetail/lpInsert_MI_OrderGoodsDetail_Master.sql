-- Function: lpInsert_MI_OrderGoodsDetail_Master()

DROP FUNCTION IF EXISTS lpInsert_MI_OrderGoodsDetail_Master (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsert_MI_OrderGoodsDetail_Master (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsert_MI_OrderGoodsDetail_Master(
    IN inId                        Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                Integer   , -- ���� �������
    IN inGoodsId                   Integer   , -- ������
    IN inGoodsKindId               Integer   , -- 
    IN inAmount                    TFloat    , -- ���������� ����
    IN inAmountForecast            TFloat    , -- ����������(�������) - ��� �����
    IN inAmountForecastOrder       TFloat    , -- ����������(������)  - ��� �����
    IN inAmountForecastPromo       TFloat    , -- ����������(�������) - ������ �����
    IN inAmountForecastOrderPromo  TFloat    , -- ����������(������)  - ������ �����
    IN inUserId                    Integer     -- ������ ������������                                                
)
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbId_child Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- ��������� <������� ���������>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecast(), inId, inAmountForecast);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecastOrder(), inId, inAmountForecastOrder);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecastPromo(), inId, inAmountForecastPromo);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecastOrderPromo(), inId, inAmountForecastOrderPromo);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.21         *
*/

-- ����
--