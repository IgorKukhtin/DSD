-- Function: lpInsertUpdate_Movement_Tax()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Tax(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
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
   DECLARE vbBranchId Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
        AND inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Prepay()
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <�������>.';
     END IF;

     -- ���������� ���� �������
     IF COALESCE (ioId, 0) = 0
        OR (inContractId > 0
        AND (inContractId <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_Contract()), 0)
          OR EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND COALESCE (Movement.AccessKeyId, 0) = 0)
            )
        AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
           )
     THEN IF inContractId > 0  AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
          THEN -- ��� ����������
               vbAccessKeyId:= zfGet_AccessKey_onBranch (COALESCE ((SELECT ObjectLink_Unit_Branch.ChildObjectId
                                                                    FROM ObjectLink AS OL
                                                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                                               ON ObjectLink_Personal_Unit.ObjectId = OL.ChildObjectId
                                                                                              AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                                                                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                                                              ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                                                                             AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()

                                                                    WHERE OL.ObjectId = inContractId
                                                                      AND OL.DescId   = zc_ObjectLink_Contract_PersonalCollation()
                                                                   ), 0)
                                                       , zc_Enum_Process_InsertUpdate_Movement_Tax(), inUserId
                                                        );
               -- ��������
               IF COALESCE (vbAccessKeyId, 0) = 0
               THEN
                   RAISE EXCEPTION '������.������ ��� ������� = <%> (%).', lfGet_Object_ValueData (inContractId), inContractId;
               END IF;

          ELSEIF COALESCE (inContractId, 0) = 0 AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
          THEN
              -- ����� ????????
              vbAccessKeyId:= 0;
              --
              -- vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax());

          ELSE vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax());
          END IF;

     ELSE vbAccessKeyId:= (SELECT Movement.AccessKeyId FROM Movement WHERE Movement.Id = ioId);
     END IF;

     -- ������������ ������
     vbBranchId:= CASE WHEN vbAccessKeyId > 0 THEN zfGet_Branch_AccessKey (vbAccessKeyId) ELSE 0 END;

     -- ��������
   /*IF COALESCE (vbBranchId, 0) = 0 AND (inContractId > 0 OR inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Prepay())
     THEN
         RAISE EXCEPTION '������.���������� ���������� <������>.';
     END IF;*/

     -- ������������  ����� �������
     IF inOperDate < '01.01.2016'
     THEN
         inInvNumberBranch:= (SELECT ObjectString.ValueData FROM ObjectString WHERE ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = vbBranchId);
     ELSE
         inInvNumberBranch:='';
     END IF;

     -- ���� ����, ������� <����� ���������>
     IF COALESCE (ioInvNumber, '') = ''
     THEN
         ioInvNumber:= NEXTVAL ('movement_tax_seq') ::TVarChar;
     END IF;
     -- ���� ����, ������� <����� ���������� ���������>
     IF COALESCE (ioInvNumberPartner, '') = ''
     THEN
         ioInvNumberPartner:= lpInsertFind_Object_InvNumberTax (zc_Movement_Tax(), inOperDate, inInvNumberBranch) ::TVarChar;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Tax(), ioInvNumber, inOperDate, NULL, vbAccessKeyId);

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

     -- ��������� ����� � <������>
     IF vbIsInsert = TRUE THEN PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), ioId, vbBranchId); END IF;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);
     
     -- ��������� "������� ����", ������ "�����������" - ���� ��� ��� ������ ����������� (�.�. ����������� �����)
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), tmp.MovementId, CURRENT_DATE)
     FROM (SELECT ioId AS MovementId /*WHERE vbIsInsert = TRUE AND CURRENT_DATE >= '01.04.2016'*/) AS tmp
          LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = tmp.MovementId
                                   AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
     WHERE COALESCE (MovementBoolean.ValueData, FALSE) = FALSE
       AND vbIsInsert = TRUE
    ;

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
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
 13.11.14                                        * add vbBranchId
 13.11.14                                        * add vbAccessKeyId
 02.05.14                                        * add ���� ����, ������� <����� ���������>
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 24.04.14                                                       * add inInvNumberBranch
 16.04.14                                        * add lpInsert_MovementProtocol
 29.03.14         * add  INOUT ioInvNumberPartner
 16.03.14                                        * add inPartnerId
 12.02.14                                                       * change to inDocumentTaxKindId
 11.02.14                                                       *  - registred
 09.02.14                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Tax (ioId:= 0, ioInvNumber:= '-1',ioInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)
