-- Function: lpInsertUpdate_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SheetWorkTimeClose(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ������ �������
    IN inOperDateEnd         TDateTime , -- ���� ��������� �������
    IN inTimeClose           TDateTime , -- ����� ���� �������� 
    IN inUnitId              Integer   , -- �������������(����������)
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SheetWorkTimeClose(), inInvNumber, inOperDate, NULL, NULL);

     -- <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
     -- <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_TimeClose(), ioId, inTimeClose);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     IF vbIsInsert = TRUE
     THEN
         -- <>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ClosedAuto(), ioId, TRUE);

         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);

     ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.21         *
*/

-- ����
-- 