-- Function: lpInsertUpdate_Movement_ReturnIn()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnIn(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inParentId            Integer   , -- 
    IN inOperDate            TDateTime , -- ����(�����)
    IN inOperDatePartner     TDateTime , -- ���� ��������� � ����������
    IN inChecked             Boolean   , -- ��������
    IN inIsPartner           Boolean   , -- ��������� - ��� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inisList              Boolean   , -- ������ ��� ������
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������

    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
    IN inCurrencyValue       TFloat    , -- ���� ������ 

    IN inParValue             TFloat    , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerValue TFloat     , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue      TFloat     , -- ������� ��� ������� ����� ��������
    IN inMovementId_OrderReturnTare Integer , --
    In inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_TaxCorrective Integer;
   DECLARE vbBranchId Integer;
BEGIN
     -- ����� ������
     vbBranchId:= (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);

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

     -- ��������
     IF vbBranchId > 0 AND inToId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inToId AND OL.DescId = zc_ObjectLink_Unit_Branch() AND OL.ChildObjectId = vbBranchId)
     AND vbBranchId <> 8377   -- ������ ��.���
     AND vbBranchId <> 301310 -- ������ ���������
     THEN
         RAISE EXCEPTION '������.��� <%> ��� ���� ������� ������������� <%>.%����� ������� %>'
                 , lfGet_Object_ValueData_sh (inUserId)
                 , lfGet_Object_ValueData_sh (inToId)
                 , CHR (13)
                 , (SELECT STRING_AGG (tmp.Value, ' ��� ') FROM (SELECT '<' || lfGet_Object_ValueData_sh (OL.ObjectId) || '>' AS Value FROM ObjectLink AS OL WHERE OL.ChildObjectId = vbBranchId AND OL.DescId = zc_ObjectLink_Unit_Branch() ORDER BY OL.ObjectId) AS tmp)
                  ;
     END IF;


     -- �������� ���� � ���� �������������
     IF ioId <> 0 AND NOT EXISTS (SELECT MovementId FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner() AND ValueData = inOperDatePartner)
     THEN
         -- ����� ����� ����������� �������������
         vbMovementId_TaxCorrective:= (SELECT MAX (MovementLinkMovement.MovementId) FROM MovementLinkMovement INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId AND Movement.StatusId = zc_Enum_Status_Complete() WHERE MovementLinkMovement.MovementChildId = ioId AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master());
         -- �������� - ��� ������������� ������ ���� ���� �� ������������
         IF vbMovementId_TaxCorrective <> 0
         THEN
             RAISE EXCEPTION '������.��������� ���� ����������, �������� <������������� � ���������> � <%> �� <%> � ������� <%>.', (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective), lfGet_Object_ValueData (zc_Enum_Status_Complete());
         END IF;
         -- �������� ����
         UPDATE Movement SET OperDate = inOperDatePartner
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


     -- ���������� ���� ������� !!!�� ��� ������������� - ��������!!!
     vbAccessKeyId:= zfGet_AccessKey_onUnit (inToId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn(), inUserId);

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReturnIn(), inInvNumber, inOperDate, inParentId, vbAccessKeyId);
     -- �������� ������
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = ioId AND AccessKeyId IS NULL;

     -- ��������� �������� <���� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� �������� <����� "������������ ������ ����� �i ������">
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� �������� <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isPartner(), ioId, inIsPartner);
     -- ��������� �������� <������ ��� ������ (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), ioId, inisList);

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
     -- ��������� �������� <������� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- ��������� �������� <���� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- ��������� �������� <������� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);

     -- ��������� ����� � <������ �� ������� ����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_OrderReturnTare(), ioId, inMovementId_OrderReturnTare);

     IF inOperDatePartner < '01.08.2016' OR inPaidKindId = zc_Enum_PaidKind_SecondForm()
        OR NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = ioId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE)
     THEN
         -- !!!�����������!!!
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id
                                                 , CASE WHEN inOperDatePartner < '01.08.2016'
                                                             THEN inChangePercent
                                                        WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() AND inOperDate < zc_isReturnInNAL_bySale()
                                                             THEN inChangePercent
                                                        WHEN 1=1 AND MIFloat_PromoMovement.ValueData > 0
                                                             THEN COALESCE (MIFloat_ChangePercent.ValueData, 0)
                                                        ELSE inChangePercent
                                                   END
                                                  )
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
         WHERE MovementItem.MovementId = ioId
           AND MovementItem.DescId = zc_MI_Master();
     END IF;


     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (ioId);


     -- IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     -- THEN
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     -- END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.04.22         *
 14.05.16         *
 21.08.15         * ADD inIsPartner
 26.06.15         * add Comment, ParentId
 24.12.14				         * add �������� ���� � ���� �������������
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
