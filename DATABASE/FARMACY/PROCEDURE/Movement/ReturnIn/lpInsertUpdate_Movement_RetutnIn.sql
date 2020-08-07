-- Function: lpInsertUpdate_Movement_RetutnIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_RetutnIn (Integer, Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_RetutnIn(
 INOUT ioId                    Integer    , -- ���� ������� <��������>
    IN inParentId              Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUnitId                Integer    , -- �� ���� (�������������)
    IN inCashRegisterId        Integer    , -- 
    IN inFiscalCheckNumber     TVarChar   , -- 
    IN inUserId                Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId Integer;
BEGIN
    -- ��������
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
    END IF;
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReturnIn(), inInvNumber, inOperDate, Null, 0);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), ioId, COALESCE(inParentId, 0));

    -- ��������� ����� � <�� ���� (�������������)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), ioId, inCashRegisterId);
 
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_FiscalCheckNumber(), ioId, inFiscalCheckNumber);

    -- !!!�������� ����� �������� ����������� �������!!!
    IF vbIsInsert = TRUE
       THEN
           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
           -- ��������� �������� <������������ (��������)>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
    END IF;
     
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.01.19         *
*/
--