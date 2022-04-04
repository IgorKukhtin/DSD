-- Function: gpInsertUpdate_Movement_Sale_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale_Partner (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale_Partner (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale_Partner (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale_Partner(
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
    IN inDocumentTaxKindId_inf Integer    , -- ��� ������������ ���������� ���������
    IN inMovementId_Order      Integer    , -- ���� ���������
    IN inMovementId_ReturnIn   Integer    , -- �������
 INOUT ioPriceListId           Integer    , -- ����� ����
   OUT outPriceListName        TVarChar   , -- ����� ����
   OUT outCurrencyValue        TFloat     , -- ���� ��� �������� � ������ �������
   OUT outParValue             TFloat     , -- ������� ��� �������� � ������ �������
 INOUT ioCurrencyPartnerValue  TFloat     , -- ���� ��� ������� ����� ��������
 INOUT ioParPartnerValue       TFloat     , -- ������� ��� ������� ����� ��������
    IN inComment               TVarChar   , -- ����������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Tax Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());


     -- !!!��������
     SELECT Object_PriceList.ValueData                             AS PriceListName
          , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
          , ObjectFloat_VATPercent.ValueData                       AS VATPercent
            INTO outPriceListName, outPriceWithVAT, outVATPercent
     FROM Object AS Object_PriceList
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                  ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                 AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
          LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                               AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
     WHERE Object_PriceList.Id = ioPriceListId;

     -- ��������, �.�. ��� ��������� ������ ������
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE MovementId = ioId AND Amount <> 0 AND isErased = FALSE)
                  AND EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_From() AND ObjectId = 8459) -- ����� ����������
                  AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyDocument() AND ObjectId <> zc_Enum_Currency_Basis())
                  AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_CurrencyPartner() AND ObjectId <> zc_Enum_Currency_Basis())
     THEN
         IF NOT EXISTS (SELECT Movement.Id
                        FROM Movement
                             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                       ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                      ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                             JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                    AND MovementLinkObject_From.ObjectId = inFromId
                             JOIN MovementLinkObject AS MovementLinkObject_To
                                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                    AND MovementLinkObject_To.ObjectId = inToId

                             JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                     ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                    AND MovementLinkObject_PaidKind.ObjectId = inPaidKindId
                             JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                    AND MovementLinkObject_Contract.ObjectId = inContractId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                                          ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                                         AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
                        WHERE Movement.Id = ioId
                          AND Movement.OperDate = inOperDate
                          AND Movement.InvNumber = inInvNumber
                          -- AND COALESCE (MovementFloat_VATPercent.ValueData, 0) = COALESCE (outVATPercent, 0)
                          -- AND COALESCE (MovementFloat_ChangePercent.ValueData, 0) = COALESCE (ioChangePercent, 0)
                          AND MovementBoolean_PriceWithVAT.ValueData = outPriceWithVAT
                          AND COALESCE (MovementString_InvNumberOrder.ValueData, '') = COALESCE (inInvNumberOrder, '')
                          -- AND COALESCE (MovementLinkObject_RouteSorting.ObjectId, 0) = COALESCE (inRouteSortingId, 0)
                       )
         THEN
             RAISE EXCEPTION '������.��������������� <��������> ����� ������ � ��������� ������.';
         END IF;
     END IF;

     -- ������������ ��������� ��� ���������
     IF ioId <> 0
     THEN
         vbMovementId_Tax:= (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_Master());
     END IF;

     -- ��������� <��������>
     SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName, tmp.outPriceWithVAT, tmp.outVATPercent
          , tmp.outCurrencyValue, tmp.outParValue, tmp.ioCurrencyPartnerValue, tmp.ioParPartnerValue
            INTO ioId, ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
               , outCurrencyValue, outParValue, ioCurrencyPartnerValue, ioParPartnerValue
     FROM lpInsertUpdate_Movement_Sale (ioId                   := ioId
                                      , inInvNumber            := inInvNumber
                                      , inInvNumberPartner     := inInvNumberPartner
                                      , inInvNumberOrder       := inInvNumberOrder
                                      , inOperDate             := inOperDate
                                      , inOperDatePartner      := inOperDatePartner
                                      , inChecked              := inChecked
                                      -- , inPriceWithVAT       := inPriceWithVAT
                                      -- , inVATPercent         := inVATPercent
                                      , ioChangePercent        := ioChangePercent
                                      , inFromId               := inFromId
                                      , inToId                 := inToId
                                      , inPaidKindId           := inPaidKindId
                                      , inContractId           := inContractId
                                      , inRouteSortingId       := inRouteSortingId
                                      , inCurrencyDocumentId   := inCurrencyDocumentId
                                      , inCurrencyPartnerId    := inCurrencyPartnerId
                                      , inMovementId_Order     := inMovementId_Order
                                      , inMovementId_ReturnIn  := inMovementId_ReturnIn
                                      , ioPriceListId          := ioPriceListId
                                      , ioCurrencyPartnerValue := ioCurrencyPartnerValue
                                      , ioParPartnerValue      := ioParPartnerValue
                                      , inUserId               := vbUserId
                                       ) AS tmp;

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- � ���� ������ ���� ������������/������� ���������
    IF vbMovementId_Tax <> 0
    THEN
        IF inDocumentTaxKindId_inf <> 0
        THEN
             -- �������� <��� �����. ���.> �� ������ ����������
             IF NOT EXISTS (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementLinkObject_DocumentTaxKind() AND ObjectId = inDocumentTaxKindId_inf)
             THEN
                 RAISE EXCEPTION '������.������ �������� <��� ���������� ���������>.';
             END IF;

             -- �������������� ���������
             IF EXISTS (SELECT Id FROM Movement WHERE Id = vbMovementId_Tax AND StatusId = zc_Enum_Status_Erased())
             THEN
                 PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Tax
                                              , inUserId     := vbUserId);
             END IF;
        ELSE
             -- �������� ���������
             PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Tax
                                         , inUserId     := vbUserId);
        END IF;

    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.07.16         *
 18.07.14                                        * add inCurrencyDocumentId and inCurrencyPartnerId
 17.04.14                                        * add ������������/������� ��������� 
 07.04.14                                        *
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Sale_Partner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, ioChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
