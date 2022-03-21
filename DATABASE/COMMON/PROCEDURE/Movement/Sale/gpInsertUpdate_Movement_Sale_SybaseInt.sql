-- Function: gpInsertUpdate_Movement_Sale_SybaseInt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale_SybaseInt (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale_SybaseInt(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberOrder      TVarChar  , -- ����� ������ �����������
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
    IN inRouteId             Integer   , -- �������
    IN inRouteSortingId      Integer   , -- ���������� ���������
 INOUT ioPriceListId         Integer   , -- ����� ����
   OUT outPriceListName      TVarChar  , -- ����� ����
    IN inIsOnlyUpdateInt     Boolean   , -- !!!!!!
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;

   DECLARE vbContractId_pav Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());


     -- ��� ���������� �������� ������� �� ��
     IF EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inToId AND DescId = zc_ObjectLink_Partner_Unit() AND ChildObjectId > 0)
        AND inFromId = 148955 -- ����� ���������
     THEN
         IF NOT EXISTS (SELECT ContractId FROM Object_Contract_View WHERE ContractId = inContractId AND InfoMoneyId = zc_Enum_InfoMoney_30101()) -- ������� ���������
         THEN
              vbContractId_pav:= (SELECT View_Contract_f.ContractId
                                  FROM Object_Contract_View AS View_Contract
                                       INNER JOIN Object_Contract_View AS View_Contract_f
                                                                       ON View_Contract_f.JuridicalId = View_Contract.JuridicalId
                                                                      AND View_Contract_f.InfoMoneyId = zc_Enum_InfoMoney_30101()
                                                                      AND View_Contract_f.isErased = FALSE  -- ������� ���������
                                                                      AND View_Contract_f.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                  WHERE View_Contract.ContractId = inContractId);
              -- 
              IF vbContractId_pav <> 0
              THEN
                  inContractId:= vbContractId_pav;
              END IF;
         END IF;
     END IF;


     -- ��� �������� ��� ���������������
     IF ioId <> 0 AND inPaidKindId = zc_Enum_PaidKind_FirstForm()
                  AND (EXISTS (SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked() AND ValueData = TRUE)
                    OR EXISTS (SELECT MovementLinkMovement.MovementId
                               FROM MovementLinkMovement
                                    INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    INNER JOIN MovementBoolean AS MovementBoolean_Medoc
                                                               ON MovementBoolean_Medoc.MovementId = MovementLinkMovement.MovementChildId
                                                              AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()
                                                              AND MovementBoolean_Medoc.ValueData = TRUE
                               WHERE MovementLinkMovement.MovementId = ioId
                                 AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                    OR EXISTS (SELECT MovementLinkMovement.MovementId
                               FROM MovementLinkMovement
                                    INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    INNER JOIN MovementBoolean AS MovementBoolean_Electron
                                                               ON MovementBoolean_Electron.MovementId = MovementLinkMovement.MovementChildId
                                                              AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
                                                              AND MovementBoolean_Electron.ValueData = TRUE
                               WHERE MovementLinkMovement.MovementId = ioId
                                 AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                      )
     THEN
          -- ��������� <��������>
          SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
                 INTO ioId, ioPriceListId, outPriceListName
          FROM gpInsertUpdate_Movement_Sale (ioId               := ioId
                                           , inInvNumber        := inInvNumber
                                           , inInvNumberPartner := (SELECT ValueData FROM MovementString WHERE MovementId = ioId AND DescId = zc_MovementString_InvNumberPartner())
                                           , inInvNumberOrder   := inInvNumberOrder
                                           , inOperDate         := inOperDate
                                           , inOperDatePartner  := (SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner()) -- inOperDatePartner
                                           , inChecked          := (SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked())
                                           -- , inPriceWithVAT     := inPriceWithVAT
                                           -- , inVATPercent       := inVATPercent
                                           , inChangePercent    := (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_ChangePercent())
                                           , inFromId           := inFromId
                                           , inToId             := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_To())
                                           , inPaidKindId       := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_PaidKind())
                                           , inContractId       := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Contract())
                                           , inRouteSortingId   := inRouteSortingId
                                           , inCurrencyDocumentId  := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyDocument())
                                           , inCurrencyPartnerId   := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyPartner())
                                           , inDocumentTaxKindId_inf:= (SELECT MovementLinkObject.ObjectId
                                                                        FROM MovementLinkMovement
                                                                             JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                             JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementLinkMovement.MovementChildId
                                                                                                    AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                        WHERE MovementLinkMovement.MovementId = ioId
                                                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                                           , inMovementId_Order := (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_Order())
                                           , inMovementId_ReturnIn := (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_ReturnIn())
                                           , ioPriceListId      := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_PriceList())
                                           , ioCurrencyPartnerValue := (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_CurrencyPartnerValue())
                                           , ioParPartnerValue      := (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_ParPartnerValue())
                                           , inSession          := inSession
                                            ) AS tmp;

     ELSE
     IF inIsOnlyUpdateInt = TRUE AND ioId <> 0
     THEN
          -- ��������� <��������>
          SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
                 INTO ioId, ioPriceListId, outPriceListName
          FROM gpInsertUpdate_Movement_Sale (ioId               := ioId
                                           , inInvNumber        := inInvNumber
                                           , inInvNumberPartner := (SELECT ValueData FROM MovementString WHERE MovementId = ioId AND DescId = zc_MovementString_InvNumberPartner())
                                           , inInvNumberOrder   := inInvNumberOrder
                                           , inOperDate         := inOperDate
                                           , inOperDatePartner  := (SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner()) -- inOperDatePartner
                                           , inChecked          := (SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked())
                                           -- , inPriceWithVAT     := inPriceWithVAT
                                           -- , inVATPercent       := inVATPercent
                                           , inChangePercent    := inChangePercent
                                           , inFromId           := inFromId
                                           , inToId             := inToId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractId       := inContractId
                                           , inRouteSortingId   := inRouteSortingId
                                           , inCurrencyDocumentId  := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyDocument())
                                           , inCurrencyPartnerId   := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyPartner())
                                           , inDocumentTaxKindId_inf:= (SELECT MovementLinkObject.ObjectId
                                                                        FROM MovementLinkMovement
                                                                             JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                             JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementLinkMovement.MovementChildId
                                                                                                    AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                        WHERE MovementLinkMovement.MovementId = ioId
                                                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                                           , inMovementId_Order := (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_Order())
                                           , inMovementId_ReturnIn := (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_ReturnIn())
                                           , ioPriceListId      := ioPriceListId
                                           , ioCurrencyPartnerValue := (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_CurrencyPartnerValue())
                                           , ioParPartnerValue      := (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_ParPartnerValue())
                                           , inSession          := inSession
                                            ) AS tmp;
     ELSE
          -- ��������� <��������>
          SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
                 INTO ioId, ioPriceListId, outPriceListName
          FROM gpInsertUpdate_Movement_Sale (ioId               := ioId
                                           , inInvNumber        := inInvNumber
                                           , inInvNumberPartner := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = ioId AND DescId = zc_MovementString_InvNumberPartner()), inInvNumberPartner)
                                           , inInvNumberOrder   := inInvNumberOrder
                                           , inOperDate         := inOperDate
                                           , inOperDatePartner  := CASE WHEN ioId <> 0 THEN (SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner()) ELSE inOperDatePartner END
                                           , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked()), inChecked)
                                           -- , inPriceWithVAT     := inPriceWithVAT
                                           -- , inVATPercent       := inVATPercent
                                           , inChangePercent    := inChangePercent
                                           , inFromId           := inFromId
                                           , inToId             := inToId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractId       := inContractId
                                           , inRouteSortingId   := inRouteSortingId
                                           , inCurrencyDocumentId  := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyDocument())
                                           , inCurrencyPartnerId   := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyPartner())
                                           , inDocumentTaxKindId_inf:= (SELECT MovementLinkObject.ObjectId
                                                                        FROM MovementLinkMovement
                                                                             JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                             JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementLinkMovement.MovementChildId
                                                                                                    AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                        WHERE MovementLinkMovement.MovementId = ioId
                                                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                                           , inMovementId_Order := (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_Order())
                                           , inMovementId_ReturnIn := (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_ReturnIn())
                                           , ioPriceListId      := ioPriceListId
                                           , ioCurrencyPartnerValue := (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_CurrencyPartnerValue())
                                           , ioParPartnerValue      := (SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_ParPartnerValue())
                                           , inSession          := inSession
                                            ) AS tmp;

     END IF;
     END IF;

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

     -- ��������� ����� �
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);

     -- �������� ������
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = ioId AND AccessKeyId IS NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.03.22         *
 21.08.14                                        * add inRouteId
 22.05.14                                        * restore find inOperDatePartner
 23.04.14                                        * add COALESCE ...
 05.04.14                                        *
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Sale_SybaseInt (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
