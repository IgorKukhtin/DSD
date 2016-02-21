-- Function: lpInsertUpdate_MI_SheetWorkTime_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SheetWorkTime_Child (Integer, Integer, Integer, TDateTime);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SheetWorkTime_Child (Integer, Integer, Integer, TDateTime, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SheetWorkTime_Child (Integer, Integer, Integer, Time, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SheetWorkTime_Child(
 INOUT inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- �������
    IN inValue               TDateTime ,  -- ���������� ����� ����
    IN inUserId              Integer   -- ���������� ����� ����
 )                              
RETURNS Integer AS
$BODY$
 DECLARE vbIsInsert Boolean;
BEGIN
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;
     
     -- ��������� <������� ���������>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Child(), Null, inMovementId, 0, inParentId);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), inId, inValue);


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.02.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_SheetWorkTime_Child (InMovementItemId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:= 0, inSession:= '2')
