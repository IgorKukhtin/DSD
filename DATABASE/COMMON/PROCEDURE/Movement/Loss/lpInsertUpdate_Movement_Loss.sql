-- Function: lpInsertUpdate_Movement_Loss()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Loss(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
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

     -- ���������� ���� ������� !!!�� ��� ������������� - ��������!!!
     vbAccessKeyId:= CASE WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 346093 -- ����� �� �.������
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8413 -- ����� �� �.������ ���
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8425 -- ����� �� �.�������
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          ELSE lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Loss())
                     END;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Loss(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <������ ��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ArticleLoss(), ioId, inArticleLossId);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.03.17         *
 06.09.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Loss (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
