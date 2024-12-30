-- Function: lpInsertUpdate_MI_PromoGoods_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PromoGoods_Detail (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PromoGoods_Detail (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PromoGoods_Detail(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inParentId              Integer   , --
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- 
    IN inAmountIn              TFloat    , -- 
    IN inAmountReal            TFloat    , -- ����� ������ � ����������� ������, ��
    IN inAmountRetIn           TFloat    , --
    IN inOperDate              TDateTime  , --�����
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inGoodsId, inMovementId, inAmount, inParentId);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountIn(), ioId, inAmountIn);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(), ioId, inAmountReal);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRetIn(), ioId, inAmountRetIn);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

 
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.12.24         *
 */