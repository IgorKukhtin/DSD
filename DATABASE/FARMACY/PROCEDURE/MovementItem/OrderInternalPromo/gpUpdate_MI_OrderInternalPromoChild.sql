-- Function: gpUpdate_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromoChild(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����������, ����������.
    IN inAmountManual        TFloat    , -- ����������, ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
  
    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, inAmount, inParentId);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, inAmountManual);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.19         *
 17.04.19         *
*/