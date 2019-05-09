-- Function: lpInsertUpdate_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternalPromoChild(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ���������� �� �������
    IN inAmountManual        TFloat    , -- ����������, ������ ����
    IN inAmountOut           TFloat    , -- ���� ������ �� ������� �� ������ � StartSale �� Movement.OperDate
    IN inRemains             TFloat    , -- �������
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, inAmount, inParentId);
    
    -- ��������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut(), ioId, inAmountOut);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), ioId, inRemains);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, inAmountManual);
    
    -- ��������� ��������
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.04.19         *
 */