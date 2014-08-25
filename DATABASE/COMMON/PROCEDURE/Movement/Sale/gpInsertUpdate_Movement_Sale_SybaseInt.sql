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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());


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
                                           , inPriceWithVAT     := inPriceWithVAT
                                           , inVATPercent       := inVATPercent
                                           , inChangePercent    := inChangePercent
                                           , inFromId           := inFromId
                                           , inToId             := inToId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractId       := inContractId
                                           , inRouteSortingId   := inRouteSortingId
                                           , inCurrencyDocumentId  := 14461
                                           , inCurrencyPartnerId   := NULL
                                           , inDocumentTaxKindId_inf:= (SELECT MovementLinkObject.ObjectId
                                                                        FROM MovementLinkMovement
                                                                             JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                             JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementLinkMovement.MovementChildId
                                                                                                    AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                        WHERE MovementLinkMovement.MovementId = ioId
                                                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                                           , ioPriceListId      := ioPriceListId
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
                                           , inOperDatePartner  := inOperDatePartner
                                           , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked()), inChecked)
                                           , inPriceWithVAT     := inPriceWithVAT
                                           , inVATPercent       := inVATPercent
                                           , inChangePercent    := inChangePercent
                                           , inFromId           := inFromId
                                           , inToId             := inToId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractId       := inContractId
                                           , inRouteSortingId   := inRouteSortingId
                                           , inCurrencyDocumentId  := 14461
                                           , inCurrencyPartnerId   := NULL
                                           , inDocumentTaxKindId_inf:= (SELECT MovementLinkObject.ObjectId
                                                                        FROM MovementLinkMovement
                                                                             JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                             JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementLinkMovement.MovementChildId
                                                                                                    AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                                        WHERE MovementLinkMovement.MovementId = ioId
                                                                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                                           , ioPriceListId      := ioPriceListId
                                           , inSession          := inSession
                                            ) AS tmp;

     END IF;

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
 21.08.14                                        * add inRouteId
 22.05.14                                        * restore find inOperDatePartner
 23.04.14                                        * add COALESCE ...
 05.04.14                                        *
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Sale_SybaseInt (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
