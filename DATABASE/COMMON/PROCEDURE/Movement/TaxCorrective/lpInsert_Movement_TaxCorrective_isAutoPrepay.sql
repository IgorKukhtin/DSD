-- Function: lpInsert_Movement_TaxCorrective_isAutoPrepay()

DROP FUNCTION IF EXISTS lpInsert_Movement_TaxCorrective_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_TaxCorrective_isAutoPrepay(
    IN inId                  Integer   , -- ���� ������� <�������� TaxCorrective>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ���������� ���������
    IN inInvNumberBranch     TVarChar  , -- ����� �������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inisAuto              Boolean   , -- �������������
    IN inChecked             Boolean   , -- ��������
    IN inDocument            Boolean   , -- ���� �� ����������� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inAmount              TFloat    , -- ����� ����������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartnerId           Integer   , -- ����������
    IN inContractId          Integer   , -- ��������
    IN inDocumentTaxKindId   Integer   , -- ��� ������������ ��������� TaxCorrective
    IN inUserId              Integer     -- ������������
)


RETURNS VOID AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBranchId Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;
     -- ��������
     IF COALESCE (inContractId, 0) = 0 -- AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ���������� �������.';
     END IF;


     -- ���������� ���� �������
     IF COALESCE (inId, 0) = 0
     THEN vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());
     ELSE vbAccessKeyId:= (SELECT Movement.AccessKeyId FROM Movement WHERE Movement.Id = inId);
     END IF;

     -- ������������ ������
     vbBranchId:= CASE WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentBread()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDnepr())
                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDnepr())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentKiev()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKiev())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentOdessa()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportOdessa())
                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentZaporozhye()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportZaporozhye())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentKrRog()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKrRog())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentNikolaev()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportNikolaev())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentKharkov()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKharkov())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentCherkassi()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportCherkassi())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentLviv()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportLviv())
                  END;
     -- ��������
     IF COALESCE (vbBranchId, 0) = 0
     THEN
         RAISE EXCEPTION '������.���������� ���������� <������>.';
     END IF;

     -- ������������  ����� �������
     IF inOperDate < '01.01.2016'
     THEN
         inInvNumberBranch:= (SELECT ObjectString.ValueData FROM ObjectString WHERE ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = vbBranchId);
     ELSE
         inInvNumberBranch:='';
     END IF;

     -- ���� ����, ������� <����� ���������>
     IF COALESCE (inInvNumber, '') = ''
     THEN
         inInvNumber:= NEXTVAL ('movement_taxcorrective_seq') ::TVarChar;
     END IF;
     -- ���� ����, ������� <����� ���������� ���������>
     IF COALESCE (inInvNumberPartner, '') = ''
     THEN
         inInvNumberPartner:= lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective(), inOperDate, inInvNumberBranch) ::TVarChar;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- ��������� <��������>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_TaxCorrective(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <����� ���������� ���������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), inId, inInvNumberPartner);
     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), inId, inInvNumberBranch);

     -- ��������� �������� <�������������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inisAuto);

     -- ��������� �������� <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inId, inChecked);

     -- ��������� �������� <���� �� ����������� ��������>
     IF vbIsInsert THEN PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), inId, FALSE); END IF; -- inDocument

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inId, inPriceWithVAT);

     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), inId, inPartnerId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inId, inContractId);
     -- ��������� ����� � <��� ������������ ���������� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), inId, inDocumentTaxKindId);

     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inId, vbBranchId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (inId, inUserId, vbIsInsert);
     END IF;


    --������ ��������� 
    PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                     , inMovementId         := inId
                                                     , inGoodsId            := inDocumentTaxKindId
                                                     , inAmount             := inAmount
                                                     , inPrice              := 1
                                                     , inPriceTax_calc      := 0
                                                     , ioCountForPrice      := 1
                                                     , inGoodsKindId        := NULL
                                                     , inUserId             := inUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.21         *
*/

-- ����
--