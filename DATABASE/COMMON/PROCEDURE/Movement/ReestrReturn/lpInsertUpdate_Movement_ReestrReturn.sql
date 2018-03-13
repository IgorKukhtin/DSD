-- Function: lpInsertUpdate_Movement_ReestrReturn()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReestrReturn (Integer, TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReestrReturn(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ���� ������� !!!�� ��� ������������� - ��������!!!
     vbAccessKeyId:= CASE WHEN 1 = 1
                               THEN lpGetAccessKey (ABS (inUserId), zc_Enum_Process_InsertUpdate_Movement_ReturnIn())
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReestrReturn(), inInvNumber, inOperDate, NULL, vbAccessKeyId);


     IF inUserId > 0 AND vbIsInsert = True
     THEN
         -- ��������� �������� <����� ������������ ���� "" (�.�. �������� ����� �������� � ������)>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <��� ����������� ���� "" (�.�. �������� ����� �������� � ������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     IF inUserId > 0 AND vbIsInsert = False
     THEN
         -- ��������� �������� <����� ������������ ���� "�������� �� �������" (�.�. �������� ��������� �������� � ������)>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <��� ����������� ���� "�������� �� ������" (�.�. �������� ��������� �������� � ������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, ABS (inUserId), vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.03.17         *
*/

-- ����
-- 