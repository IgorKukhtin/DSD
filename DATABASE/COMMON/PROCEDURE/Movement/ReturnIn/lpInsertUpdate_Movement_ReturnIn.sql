-- Function: lpInsertUpdate_Movement_ReturnIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnIn(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inChecked             Boolean   , -- ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
    IN inCurrencyValue       TFloat    , -- ���� ������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
 AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) 
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <�������>.';
     END IF;

     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReturnIn(), inInvNumber, inOperDate, NULL, vbAccessKeyId);
     -- �������� ������
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = ioId AND AccessKeyId IS NULL;

     -- ��������� �������� <���� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� �������� <����� "������������ ������ ����� �i ������">
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);

     -- ��������� �������� <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_ChangePercent(), ioId, inChangePercent);


     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);
     -- ��������� ����� � <������ (�����������) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_CurrencyValue(), ioId, inCurrencyValue);   


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (ioId);


     IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.14                                        * add ������ � GP - ���������� �������� <���� ��� �������� � ������ �������>
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId
 23.04.14                                        * add inInvNumberMark
 16.04.14                                        * add lpInsert_MovementProtocol
 26.03.14                                        * add inInvNumberPartner
 14.02.14                                                         * del DocumentTaxKind
 11.02.14                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_ReturnIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
