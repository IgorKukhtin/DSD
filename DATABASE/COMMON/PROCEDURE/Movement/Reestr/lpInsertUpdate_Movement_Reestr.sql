-- Function: lpInsertUpdate_Movement_Reestr()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Reestr (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Reestr(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCarId                Integer   , -- ����������
    IN inPersonalDriverId     Integer   , -- ��������� (��������)
    IN inMemberId             Integer   , -- ���������� ����(����������)
    IN inMovementId_Transport Integer   , -- ������� ����/���������� ������� ���������
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inMovementId_Transport, 0) = 0 AND COALESCE (inCarId, 0) = 0 AND inUserId > 0
     THEN 
         RAISE EXCEPTION '������. ���������� ���������� �������� <������� ����> ��� ������� �� ����������� <����������>.';
     END IF;


     -- ���������� ���� ������� !!!�� ��� ������������� - ��������!!!
     vbAccessKeyId:= CASE WHEN 1 = 1
                               THEN lpGetAccessKey (ABS (inUserId), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Reestr(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ������� ��� �� �� "��������"
     IF inUserId > 0
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), ioId, inMemberId);

         -- ��������� ����� � ���������� <������� ����> ��� <���������� ������� ���������>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), ioId, inMovementId_Transport);

         -- ��������� �������� <����� ������������ ���� "�������� �� ������" (�.�. �������� ��������� �������� � ������)>
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
 20.10.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Reestr (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inMemberId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
