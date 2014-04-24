-- Function: lpInsertUpdate_Movement_Tax()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Tax(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���������>
    IN inInvNumber           TVarChar  , -- ����� ���������
 INOUT ioInvNumberPartner    TVarChar  , -- ����� ���������� ���������
    IN inInvNumberBranch     TVarChar  , -- ����� �������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
    IN inDocument            Boolean   , -- ���� �� ����������� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartnerId           Integer   , -- ����������
    IN inContractId          Integer   , -- ��������
    IN inDocumentTaxKindId   Integer   , -- ��� ������������ ���������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ���� �������
     -- vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax());

     -- ��������
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ���������� �������.';
     END IF;

     IF COALESCE (ioInvNumberPartner, '') = ''
     THEN
        SELECT CAST (NEXTVAL ('movement_tax_seq') AS TVarChar)
        INTO ioInvNumberPartner;

     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Tax(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <����� ���������� ���������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, ioInvNumberPartner);

     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), ioId, inInvNumberBranch);

     -- ��������� �������� <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
     -- ��������� �������� <���� �� ����������� ��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), ioId, inDocument);
     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);

     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <��� ������������ ���������� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), ioId, inDocumentTaxKindId);

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
 24.04.14                                                       * add inInvNumberBranch
 16.04.14                                        * add lpInsert_MovementProtocol
 29.03.14         * add  INOUT ioInvNumberPartner
 16.03.14                                        * add inPartnerId
 12.02.14                                                       * change to inDocumentTaxKindId
 11.02.14                                                       *  - registred
 09.02.14                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Tax (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)



