-- Function: lpInsertUpdate_Movement_ReportUnLiquid()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReportUnLiquid (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReportUnLiquid(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inStartSale           TDateTime , -- ���� ������ ������
    IN inEndSale             TDateTime , -- ���� ��������� ������
    IN inUnitId              Integer   , -- ����������� ����
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReportUnLiquid(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- ����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ���� ������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
     -- ���� ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);

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
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.18         *
*/

-- ����
--