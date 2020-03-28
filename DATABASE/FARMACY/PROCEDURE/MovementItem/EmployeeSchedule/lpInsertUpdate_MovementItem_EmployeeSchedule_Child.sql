-- Function: lpInsertUpdate_MovementItem_EmployeeSchedule_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_EmployeeSchedule_Child (Integer, Integer, Integer, Integer, TFloat, Integer, TDateTime, TDateTime, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_EmployeeSchedule_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����
    IN inPayrollTypeID       Integer   , -- ��� ����������
    IN inDateStart           TDateTime , -- ���� ����� ������ �����
    IN inDateEnd             TDateTime , -- ���� ����� ����� �����
    IN inServiceExit         Boolean   , -- ��������� �����
    IN inUserId              Integer   -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, inAmount, inParentId);

    -- ��������� �������� <��� ����������>
    IF inPayrollTypeID >= 0
    THEN
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PayrollType(), ioId, inPayrollTypeID);    
    END IF;

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

     -- ��������� �������� <��������� �����>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ServiceExit(), ioId, inServiceExit);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.09.19                                                        *
 03.09.19                                                        *
 31.08.19                                                        *
*/

-- 