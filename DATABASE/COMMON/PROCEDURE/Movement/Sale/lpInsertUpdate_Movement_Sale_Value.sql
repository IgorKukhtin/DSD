-- Function: lpInsertUpdate_Movement_Sale_Value()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale_Value (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale_Value (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale_Value(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �����������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inInvNumberPartner      TVarChar   , -- ����� ��������� � �����������
    IN inInvNumberOrder        TVarChar   , -- ����� ������ �����������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inOperDatePartner       TDateTime  , -- ���� ��������� � �����������
    IN inChecked               Boolean    , -- ��������
    IN inChangePercent         TFloat     , -- (-)% ������ (+)% �������
    IN inFromId                Integer    , -- �� ���� (� ���������)
    IN inToId                  Integer    , -- ���� (� ���������)
    IN inPaidKindId            Integer    , -- ���� ���� ������
    IN inContractId            Integer    , -- ��������
    IN inRouteSortingId        Integer    , -- ���������� ���������
    IN inCurrencyDocumentId    Integer    , -- ������ (���������)
    IN inCurrencyPartnerId     Integer    , -- ������ (�����������)
    IN inMovementId_Order      Integer    , -- ���� ���������
    IN inMovementId_ReturnIn   Integer    , -- ���� ��������� �������
    IN ioPriceListId           Integer    , -- ����� ����
    IN ioCurrencyPartnerValue  TFloat     , -- ���� ��� ������� ����� ��������
    IN ioParPartnerValue       TFloat     , -- ������� ��� ������� ����� ��������
    IN inUserId                Integer      -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- ��������� <��������>
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_Movement_Sale (ioId                   := ioId
                                      , inInvNumber            := inInvNumber
                                      , inInvNumberPartner     := inInvNumberPartner
                                      , inInvNumberOrder       := inInvNumberOrder
                                      , inOperDate             := inOperDate
                                      , inOperDatePartner      := inOperDatePartner
                                      , inChecked              := inChecked
                                      , ioChangePercent        := inChangePercent
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
                                      , inUserId               := inUserId
                                       ) AS tmp);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.02.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Sale_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
