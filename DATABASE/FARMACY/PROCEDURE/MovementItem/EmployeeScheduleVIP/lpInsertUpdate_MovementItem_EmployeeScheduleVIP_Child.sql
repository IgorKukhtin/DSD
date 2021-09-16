-- Function: lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inAmount              TFloat    , -- ����
    IN inPayrollTypeVIPID    Integer   , -- ��� ����������
    IN inDateStart           TDateTime , -- ���� ����� ������ �����
    IN inDateEnd             TDateTime , -- ���� ����� ����� �����
    IN inUserId              Integer   -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inPayrollTypeVIPID, inMovementId, inAmount, inParentId);

     -- ��������� �������� <���� ����� ������ �����>
    IF inDateStart IS NOT NULL
    THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Start(), ioId, inDateStart);
    END IF;

     -- ��������� �������� <���� ����� ����� �����>
    IF inDateEnd IS NOT NULL
    THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_End(), ioId, inDateEnd);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
16.09.21                                                        *
*/

-- 