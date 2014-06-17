-- Function: lpInsertUpdate_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, integer, integer, integer, integer, integer, integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PriceCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartnerId           Integer   , -- ����������
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) 
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <�������>.';
     END IF;

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_PriceCorrective());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PriceCorrective(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);
     
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     
     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

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
 17.06.14         * add inInvNumberPartner 
                      , inInvNumberMark                
 29.05.14         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PriceCorrective (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inPartnerId:= 1, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
