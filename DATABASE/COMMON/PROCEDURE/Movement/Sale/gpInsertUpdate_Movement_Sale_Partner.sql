-- Function: gpInsertUpdate_Movement_Sale_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale_Partner (integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale_Partner(
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
    IN inRouteSortingId      Integer   , -- ���������� ���������
 INOUT ioPriceListId         Integer   , -- ����� ����
   OUT outPriceListName      TVarChar  , -- ����� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());

     -- ��������, �.�. ��� ��������� ������ ������
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE MovementId = ioId AND Amount <> 0 AND isErased = FALSE)
                  AND EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_From() AND ObjectId = 8459) -- ����� ����������
     THEN
         IF NOT EXISTS (SELECT Movement.Id
                        FROM Movement
                             JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                  ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                                 AND MovementBoolean_PriceWithVAT.ValueData = inPriceWithVAT
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
                          AND COALESCE (MovementFloat_VATPercent.ValueData, 0) = COALESCE (inVATPercent, 0)
                          AND COALESCE (MovementFloat_ChangePercent.ValueData, 0) = COALESCE (inChangePercent, 0)
                          AND COALESCE (MovementString_InvNumberOrder.ValueData, '') = COALESCE (inInvNumberOrder, '')
                          AND COALESCE (MovementLinkObject_RouteSorting.ObjectId, 0) = COALESCE (inRouteSortingId, 0)
                       )
         THEN
             RAISE EXCEPTION '������.��������������� <��������> ����� ������ � ��������� ������.';
         END IF;
     END IF;

     -- ��������� <��������>
     SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
            INTO ioId, ioPriceListId, outPriceListName
     FROM lpInsertUpdate_Movement_Sale (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inInvNumberPartner := inInvNumberPartner
                                      , inInvNumberOrder   := inInvNumberOrder
                                      , inOperDate         := inOperDate
                                      , inOperDatePartner  := inOperDatePartner
                                      , inChecked          := inChecked
                                      , inPriceWithVAT     := inPriceWithVAT
                                      , inVATPercent       := inVATPercent
                                      , inChangePercent    := inChangePercent
                                      , inFromId           := inFromId
                                      , inToId             := inToId
                                      , inPaidKindId       := inPaidKindId
                                      , inContractId       := inContractId
                                      , inRouteSortingId   := inRouteSortingId
                                      , ioPriceListId      := ioPriceListId
                                      , inUserId           := vbUserId
                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 07.04.14                                        *
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Sale_Partner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
