-- Function: lpInsertUpdate_Movement_Loss()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Loss(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inArticleLossId       Integer   , -- ������ ��������
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
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Loss());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Loss(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <������ ��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ArticleLoss(), ioId, inArticleLossId);

     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSummLoss (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.  ������ �.�.
 24.07.19                                                                                     *
 20.07.15                                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Loss (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticleLossId:= 1, inSession:= '3')
