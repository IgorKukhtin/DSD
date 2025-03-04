-- Function: lpInsertUpdate_Movement_Sale()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �����������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inInvNumberPartner      TVarChar   , -- ����� ��������� � �����������
    IN inInvNumberOrder        TVarChar   , -- ����� ������ �����������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inOperDatePartner       TDateTime  , -- ���� ��������� � �����������
    IN inChecked               Boolean    , -- ��������
   OUT outPriceWithVAT         Boolean    , -- ���� � ��� (��/���)
   OUT outVATPercent           TFloat     , -- % ���
 INOUT ioChangePercent         TFloat     , -- (-)% ������ (+)% �������
    IN inFromId                Integer    , -- �� ���� (� ���������)
    IN inToId                  Integer    , -- ���� (� ���������)
    IN inPaidKindId            Integer    , -- ���� ���� ������
    IN inContractId            Integer    , -- ��������
    IN inRouteSortingId        Integer    , -- ���������� ���������
    IN inCurrencyDocumentId    Integer    , -- ������ (���������)
    IN inCurrencyPartnerId     Integer    , -- ������ (�����������)
    IN inMovementId_Order      Integer    , -- ���� ���������
    IN inMovementId_ReturnIn   Integer    , -- ���� ��������� �������
 INOUT ioPriceListId           Integer    , -- ����� ����
   OUT outPriceListName        TVarChar   , -- ����� ����
   OUT outCurrencyValue        TFloat     , -- ���� ������
   OUT outParValue             TFloat     , -- ������� ��� �������� � ������ �������
 INOUT ioCurrencyPartnerValue  TFloat     , -- ���� ��� ������� ����� ��������
 INOUT ioParPartnerValue       TFloat     , -- ������� ��� ������� ����� ��������
    IN inUserId                Integer      -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert    Boolean;
   DECLARE vbBranchId    Integer;
   DECLARE vbIsContract_NotVAT Boolean;
   DECLARE vbCurrencyUser      Boolean;
BEGIN

     -- ��������/������ ������ - �������
     IF COALESCE (inCurrencyDocumentId, 0) IN (0, zc_Enum_Currency_Basis())
        AND zc_Enum_Currency_Basis() <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_Currency())
     THEN
         inCurrencyPartnerId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_Currency());
     END IF;
     -- ��������/������ ������ - �����
     IF COALESCE (inCurrencyDocumentId, 0) IN (0, zc_Enum_Currency_Basis())
        AND zc_Enum_Currency_Basis() <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioPriceListId AND OL.DescId = zc_ObjectLink_PriceList_Currency())
     THEN
         inCurrencyDocumentId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioPriceListId AND OL.DescId = zc_ObjectLink_PriceList_Currency());
     END IF;

     -- ������, �.�. ������ �������
     ioChangePercent:= COALESCE ((SELECT Object_PercentView.ChangePercent FROM Object_ContractCondition_PercentView AS Object_PercentView WHERE Object_PercentView.ContractId = inContractId AND inOperDatePartner BETWEEN Object_PercentView.StartDate AND Object_PercentView.EndDate), 0);

     -- �����
     vbIsContract_NotVAT:= COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = inContractId AND OB.DescId = zc_ObjectBoolean_Contract_NotVAT()), FALSE);

     -- ����� ������
     vbBranchId:= (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);

     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) 
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;
     -- ��������
     IF (COALESCE (ioId, 0) = 0 AND COALESCE (inOperDatePartner, zc_DateStart()) < (inOperDate - INTERVAL '1 DAY'))
        OR inOperDatePartner IS NULL
     THEN
         RAISE EXCEPTION '������.������� �������� ���� � ���������� <%>.', inOperDatePartner;
     END IF;
     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <�������>.';
     END IF;
     -- ��������
     IF inCurrencyDocumentId <> zc_Enum_Currency_Basis() AND inCurrencyDocumentId <> inCurrencyPartnerId
        AND 1=0
     THEN
         RAISE EXCEPTION '������.�������� �������� <������ (����)> ��� <������ (����������)>';
     END IF;

     -- ��������
     IF vbBranchId > 0 AND inFromId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inFromId AND OL.DescId = zc_ObjectLink_Unit_Branch() AND OL.ChildObjectId = vbBranchId)
         AND inUserId <> 409393 -- ����� �.�.
     THEN
         RAISE EXCEPTION '������.��� ���� ������� ������������� <%>.%����� ������� %>'
                 , lfGet_Object_ValueData_sh (inFromId)
                 , CHR (13)
                 , (SELECT STRING_AGG (tmp.Value, ' ��� ') FROM (SELECT '<' || lfGet_Object_ValueData_sh (OL.ObjectId) || '>' AS Value FROM ObjectLink AS OL WHERE OL.ChildObjectId = vbBranchId AND OL.DescId = zc_ObjectLink_Unit_Branch() ORDER BY OL.ObjectId) AS tmp)
                 ;
     END IF;


     -- !!!������ ���������!!!
     IF COALESCE (inCurrencyDocumentId, 0) = 0 THEN inCurrencyDocumentId:= zc_Enum_Currency_Basis(); END IF;
     -- !!!������ ���������!!!
     IF COALESCE (inCurrencyPartnerId, 0) = 0 THEN inCurrencyPartnerId:= zc_Enum_Currency_Basis(); END IF;
     -- !!!������ ���������!!!
     IF inCurrencyDocumentId = inCurrencyPartnerId
     THEN ioCurrencyPartnerValue := 0;
          ioParPartnerValue:= 0;
     END IF;

     --������ ���� �����
     vbCurrencyUser := COALESCE( (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = ioId AND MB.DescId = zc_MovementBoolean_CurrencyUser()), FALSE);


     -- �����-����
     IF ((COALESCE (ioPriceListId, 0) = 0 -- OR COALESCE (ioId, 0) = 0
          OR 1=1 -- !!!������ ������!!!
         )
       --AND inUserId <> zfCalc_UserMain()
       --AND inUserId <> 9464 -- ����� �.�.
       --AND inUserId <> zfCalc_UserAdmin() :: Integer
        )
        OR COALESCE (ioPriceListId, 0) = 0
     THEN
         -- !!!������!!!
         SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, CASE WHEN vbIsContract_NotVAT = TRUE THEN 0 ELSE tmp.VATPercent END
                INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                   , inPartnerId      := inToId
                                                   , inMovementDescId := zc_Movement_Sale()
                                                   , inOperDate_order := CASE WHEN inMovementId_Order <> 0 THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Order) ELSE NULL END 
                                                   , inOperDatePartner:= inOperDatePartner -- CASE WHEN inMovementId_Order <> 0 THEN NULL ELSE inOperDate END
                                                   , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                                   , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                                   , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId_Order AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                    ) AS tmp;
         -- !!!������!!!
         -- !!!������!!! ��� ��������� ������ �� �����-����� !!!�� ���� inOperDatePartner!!!
         -- SELECT PriceListId, PriceListName, PriceWithVAT, VATPercent
         --        INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         -- FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inToId, inOperDate:= inOperDatePartner);
--IF inUserId = 5
--THEN
--    RAISE EXCEPTION '������.<%>', lfGet_Object_ValueData_sh(ioPriceListId);
--END IF;

     ELSE
         SELECT Object_PriceList.ValueData                             AS PriceListName
              , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
              , CASE WHEN vbIsContract_NotVAT = TRUE THEN 0 ELSE ObjectFloat_VATPercent.ValueData END AS VATPercent
                INTO outPriceListName, outPriceWithVAT, outVATPercent
         FROM Object AS Object_PriceList
              LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                      ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                     AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
              LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                    ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                   AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
         WHERE Object_PriceList.Id = ioPriceListId;
     END IF;


     -- ���������� ���� ������� !!!�� ��� ������������� - ��������!!!
     vbAccessKeyId:= zfGet_AccessKey_onUnit (inFromId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner(), inUserId);

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Sale(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Movement.Id = ioId AND Movement.AccessKeyId <> vbAccessKeyId;


     -- ��������� �������� <���� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);


     -- ��������� �������� <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, outPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, outVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, ioChangePercent);

     IF COALESCE (vbCurrencyUser, FALSE) = FALSE
     THEN
         -- ������� ����� ��� �������
         IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
         THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
              FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyDocumentId, inPaidKindId:= inPaidKindId);
         ELSE IF inCurrencyPartnerId <> zc_Enum_Currency_Basis()
              THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
                   FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyPartnerId, inPaidKindId:= inPaidKindId);
              ELSE outCurrencyValue:= 0;
                   outParValue:=0;
              END IF;
         END IF;
     ELSE
         --���������� ����������� ��������
         outCurrencyValue     := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_CurrencyValue()), 1);
         outParValue          := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_ParValue()), 1);
         inCurrencyDocumentId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument()), zc_Enum_Currency_Basis());
         inCurrencyPartnerId  := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner()), zc_Enum_Currency_Basis());             
     END IF;

     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- ��������� �������� <������� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, outParValue);

     -- ������� ����� ��� �������� �� ���. ���. � ������ �����������
     /*IF inCurrencyDocumentId <> inCurrencyPartnerId
     THEN SELECT Amount, ParValue INTO ioCurrencyPartnerValue, ioParPartnerValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= inCurrencyDocumentId, inCurrencyToId:= inCurrencyPartnerId, inPaidKindId:= inPaidKindId);
     END IF;
     */
     -- ��������� �������� <���� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, ioCurrencyPartnerValue);
     -- ��������� �������� <������� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, ioParPartnerValue);


     -- ��������� �������� <����� ������ �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <���������� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);
     -- ��������� ����� � <������ (�����������) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);

     -- ��������� ����� � <����� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, ioPriceListId);

     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inMovementId_Order);
     -- ��������� ����� � ���������� <�������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ReturnIn(), ioId, inMovementId_ReturnIn);
     
     -- !!!�����������!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id
                                             , CASE WHEN MIFloat_PromoMovement.ValueData > 0
                                                         THEN CASE WHEN zc_Enum_ConditionPromo_ContractChangePercentOff() = (SELECT MI_Child.ObjectId FROM MovementItem AS MI_Child WHERE MI_Child.MovementId = MIFloat_PromoMovement.ValueData AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() AND MI_Child.isErased = FALSE LIMIT 1)
                                                                        THEN 0  -- ��� ����� % ������ �� ��������
                                                                   ELSE ioChangePercent
                                                              END
                                                    ELSE ioChangePercent
                                               END)
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                      ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                     AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
     WHERE MovementItem.MovementId = ioId
       AND MovementItem.DescId = zc_MI_Master();

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 29.06.16         * 
 22.10.14                                        * add inMovementId_Order
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId
 16.04.14                                        * add lpInsert_MovementProtocol
 07.04.14                                        * add ��������
 10.02.14                                        * � lp-������ ���� ���
 04.02.14                         * 
*/
/*
-- 1.
update Movement set StatusId = zc_Enum_Status_Erased() where DescId = zc_Movement_Sale() and StatusId <> zc_Enum_Status_Erased();
-- 2.
update dba.Bill set Id_Postgres = null where BillKind = zc_bkSaleToClient() and Id_Postgres is not null;
update dba.fBill set Id_Postgres = null where BillKind = zc_bkSaleToClient() and Id_Postgres is not null;
update dba.fBillItems set Id_Postgres = null where BillKind = zc_bkSaleToClient() and Id_Postgres is not null;
update dba.BillItems join dba.Bill on Bill.Id = BillItems.BillId and isnull(Bill.Id_Postgres,0)=0 set BillItems.Id_Postgres = null where BillItems.Id_Postgres is not null;
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Sale (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, ioChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
