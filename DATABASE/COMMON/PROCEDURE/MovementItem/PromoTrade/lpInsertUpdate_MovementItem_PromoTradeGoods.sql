-- Function: lpInsertUpdate_MovementItem_PromoTradeGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoTradeGoods(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- 
    IN inSumm                  TFloat    , --
    IN inPartnerCount          TFloat    , -- ���� �� �����
    IN inGoodsKindId           Integer   , --�� ������� <��� ������>
    IN inTradeMarkId           Integer   ,  --�������� ����� 
    IN inGoodsGroupPropertyId  Integer,
    IN inGoodsGroupDirectionId Integer,
    IN inComment               TVarChar  , --�����������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
 
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL, inUserId);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartnerCount(), ioId, inPartnerCount);
    
    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
  
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TradeMark(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inTradeMarkId ELSE NULL END ::Integer);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupProperty(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupPropertyId ELSE NULL END ::Integer);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupDirection(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupDirectionId ELSE NULL END ::Integer);
    
    -- ��������� <�����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

    -- ��������� ��������
    IF inUserId > 0 THEN 
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    ELSE
      PERFORM lpInsert_MovementItemProtocol (ioId, zc_Enum_Process_Auto_ReComplete(), vbIsInsert);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.09.24         *
 */