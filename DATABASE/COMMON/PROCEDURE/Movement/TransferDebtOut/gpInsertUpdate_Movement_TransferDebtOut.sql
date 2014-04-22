-- Function: gpInsertUpdate_Movement_TransferDebtOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransferDebtOut(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inFromId              Integer   , -- ����������� ���� (�� ����)
    IN inToId                Integer   , -- ����������� ���� (����)
    IN inContractFromId      Integer   , -- ������� (�� ����)
    IN inContractToId        Integer   , -- ������� (����)
    IN inPaidKindFromId      Integer   , -- ���� ���� ������ (�� ����)
    IN inPaidKindToId        Integer   , -- ���� ���� ������ (����)
    IN inMasterId            Integer   , -- ��������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut());

     -- ��������
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION '������. �������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractFromId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������. �� ���������� ������� (�� ����).';
     END IF;
     IF COALESCE (inContractToId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������. �� ���������� ������� (����).';
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransferDebtOut(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <������� (�� ����)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), ioId, inContractFromId);
     -- ��������� ����� � <������� (����)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractTotId);
     
     -- ��������� ����� � <���� ���� ������ (�� ����)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), ioId, inPaidKindFromId);
     -- ��������� ����� � <���� ���� ������ (����)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindTotId);
     
     -- ��������� ����� � <��������� ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), ioId, inMasterId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

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
 22.04.14  		  *
 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TransferDebtOut (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTransferDebtOutKind:= 0, inSession:= '2')
