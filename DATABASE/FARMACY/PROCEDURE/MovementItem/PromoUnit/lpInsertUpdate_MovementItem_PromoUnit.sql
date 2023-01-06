-- Function: lpInsertUpdate_MovementItem_PromoUnit()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoUnit (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoUnit(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPlanMax       TFloat    , -- ���������� ��� ������
    IN inPrice               TFloat    , -- ����
    IN inComment             TVarChar  , -- ����������
    IN inisFixedPercent      Boolean   , -- ������������� ������� ����������
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
    
    -- ��������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMax(), ioId, inAmountPlanMax);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_FixedPercent(), ioId, inisFixedPercent);

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�,
 04.02.17         *
 */