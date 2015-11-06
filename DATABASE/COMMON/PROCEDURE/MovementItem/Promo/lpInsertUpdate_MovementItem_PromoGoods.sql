-- Function: lpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- % ������ �� �����
    IN inPrice               TFloat    , --���� � ������
    IN inPriceWithOutVAT     TFloat    , --���� �������� ��� ����� ���, � ������ ������, ���
    IN inPriceWithVAT        TFloat    , --���� �������� � ������ ���, � ������ ������, ���
    IN inAmountReal          TFloat    , --����� ������ � ����������� ������, ��
    IN inAmountPlanMin       TFloat    , --������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inAmountPlanMax       TFloat    , --�������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inGoodsKindId         Integer    , --�� ������� <��� ������>
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
    
    -- ��������� <���� � ������>
    IF inPrice is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    END IF;

    -- ��������� <���� �������� ��� ����� ���, � ������ ������, ���>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), ioId, inPriceWithOutVAT);
    END IF;

    -- ��������� <���� �������� � ������ ���, � ������ ������, ���>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);
    END IF;

    -- ��������� <����� ������ � ����������� ������, ��>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(), ioId, inAmountReal);
    END IF;

    -- ��������� <������� ������������ ������ ������ �� ��������� ������ (� ��)>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMin(), ioId, inAmountPlanMin);
    END IF;

    -- ��������� <�������� ������������ ������ ������ �� ��������� ������ (� ��)>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMax(), ioId, inAmountPlanMax);
    END IF;

    -- ��������� ����� � <��� ������>
    IF inPriceWithOutVAT is not null
    THEN
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�,
 13.10.15                                                                       *
 */