-- Function: lpInsertUpdate_Movement_TestingTuning()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TestingTuning (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TestingTuning(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inTimeTest            Integer   , -- ����� �� ���� (���)
    IN inTimeTestStorekeeper Integer   , -- ����� �� ���� ��������� (���) 
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TestingTuning());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TestingTuning(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� <����������� ����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Time(), ioId, inTimeTest);
     -- ��������� <����������� ����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TimeStorekeeper(), ioId, inTimeTestStorekeeper);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.07.21                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_TestingTuning (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticleTestingTuningId:= 1, inSession:= '3')