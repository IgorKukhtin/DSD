-- Function: lpInsertUpdate_Movement_ReestrIncome()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReestrIncome (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReestrIncome (Integer, TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReestrIncome(
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
     vbAccessKeyId:= zc_Enum_Process_AccessKey_DocumentDnepr();

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReestrIncome(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

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
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.10.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_ReestrIncome (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inMemberId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
