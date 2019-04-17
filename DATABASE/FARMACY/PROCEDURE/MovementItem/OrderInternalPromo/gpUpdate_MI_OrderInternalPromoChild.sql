-- Function: gpUpdate_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromoChild(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ���������� �� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
  
    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, inAmount, inParentId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.04.19         *
*/