-- Function: lpInsertUpdate_MovementItem_Wages_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Wages_Child (Integer, Integer, Integer, Boolean, Integer, TFloat, TDateTime, TFloat, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Wages_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inAuto                Boolean   , -- ���� ������
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����� ���������
    IN inDateCalculation     TDateTime , -- ���� �������
    IN inSummaBase           TFloat    , -- ����� ����
    IN inPayrollTypeID       Integer   , -- ��� ����������
    IN inComment             TVarChar  , -- ��������
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

    -- ��������� �������� <���� ������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, inAuto);
    
    -- ��������� �������� <��� ����������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PayrollType(), ioId, inPayrollTypeID);    

     -- ��������� �������� <���� �������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Calculation(), ioId, inDateCalculation);

     -- ��������� �������� <����� ����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaBase(), ioId, inSummaBase);

    -- ��������� �������� <��������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

    -- ��������� ��������
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.08.19                                                        *
*/

-- ����
-- 