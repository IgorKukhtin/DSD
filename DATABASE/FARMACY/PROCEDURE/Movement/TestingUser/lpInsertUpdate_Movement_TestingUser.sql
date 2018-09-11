-- Function: lpInsertUpdate_Movement_TestingUser()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TestingUser (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TestingUser(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PriceList());
     vbUserId := inSession;

     -- �������� ���� � ������� ����� ������
     inOperDate := date_trunc('month', inOperDate);

     -- ���� ����� ��� ������ Movement
     IF (COALESCE (ioId, 0) = 0) AND EXISTS(SELECT Id FROM Movement WHERE DescId = zc_Movement_TestingUser() AND OperDate = inOperDate)
     THEN
       SELECT Id
       INTO ioId
       FROM Movement
       WHERE DescId = zc_Movement_TestingUser()
         AND OperDate = inOperDate;
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TestingUser(), NULL, inOperDate, NULL);

     -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = TRUE
     THEN
       -- ��������� �������� <���� ��������>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (��������)>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     END IF;

     -- ��������� ��������
     --PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 11.09.18         *                                               *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_TestingUser (ioId:= 0, inOperDate:= '01.09.2018', inSession:= '3')