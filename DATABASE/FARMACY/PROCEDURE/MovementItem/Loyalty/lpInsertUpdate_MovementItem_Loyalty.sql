-- Function: lpInsertUpdate_MovementItem_Loyalty()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loyalty (Integer, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Loyalty(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAmount              TFloat    , -- ����� ������
    IN inCount               Integer   , -- ��������
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), NULL, inMovementId, inAmount, NULL);
    
    -- ��������� �������� <��������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.11.19                                                       *
 */