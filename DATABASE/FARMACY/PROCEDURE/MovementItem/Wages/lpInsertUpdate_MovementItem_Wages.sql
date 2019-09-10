-- Function: lpInsertUpdate_MovementItem_Wages()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Wages (Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Wages (Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Wages(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserWagesId         Integer   , -- ���������
    IN inUserId              Integer   , -- ������������
    IN inUnitId              Integer     -- �������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserWagesId, inMovementId, 0, NULL);

    -- ��������� �������� <�������������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);    

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.19                                                        *
*/