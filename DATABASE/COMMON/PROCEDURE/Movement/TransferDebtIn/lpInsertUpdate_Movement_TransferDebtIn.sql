-- Function: lpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TransferDebtIn(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����� (������)>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindFromId      Integer   , -- ���� ���� ������
    IN inPaidKindToId        Integer   , -- ���� ���� ������
    IN inContractFromId      Integer   , -- ��������
    IN inContractToId        Integer   , -- ��������
    IN inPartnerId           Integer   , -- ���������� ����
    IN inPartnerFromId       Integer   , -- ���������� �� ����
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_TaxCorrective Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractFromId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <������� (�� ����)>.';
     END IF;

     -- ��������
     IF COALESCE (inContractToId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <������� (����)>.';
     END IF;

     -- �������� ���� � ���� �������������
     IF ioId <> 0 AND NOT EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND OperDate = inOperDate)
     THEN
         -- ����� ����� ����������� �������������
         vbMovementId_TaxCorrective:= (SELECT MAX (MovementLinkMovement.MovementId) FROM MovementLinkMovement INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId AND Movement.StatusId = zc_Enum_Status_Complete() WHERE MovementLinkMovement.MovementChildId = ioId AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master());
         -- �������� - ��� ������������� ������ ���� ���� �� ������������
         IF vbMovementId_TaxCorrective <> 0
         THEN
             RAISE EXCEPTION '������.��������� ���� ����������, �������� <������������� � ���������> � <%> �� <%> � ������� <%>.', (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective), lfGet_Object_ValueData (zc_Enum_Status_Complete());
         END IF;
         -- �������� ����
         UPDATE Movement SET OperDate = inOperDate
         FROM MovementLinkMovement
         WHERE Movement.Id = MovementLinkMovement.MovementId
           AND MovementLinkMovement.MovementChildId = ioId
           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (MovementLinkMovement.MovementId, inUserId, FALSE)
         FROM MovementLinkMovement
         WHERE MovementLinkMovement.MovementChildId = ioId
           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
     END IF;


     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransferDebtIn(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� �������� <����� "������������ ������ ����� �i ������">
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);

     -- ��������� �������� <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), ioId, inPaidKindFromId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), ioId, inContractFromId);
     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindToId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractToId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerFrom(), ioId, inPartnerFromId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.02.16         * add inPartnerFromId
 01.12.14         * add InvNumberMark
 03.09.14         * add inChecked
 20.06.14                                                       * add InvNumberPartner
 07.05.14                                        * add vbAccessKeyId
 04.05.14                                        * del ioPriceListId, outPriceListName
 25.04.14         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_TransferDebtIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
