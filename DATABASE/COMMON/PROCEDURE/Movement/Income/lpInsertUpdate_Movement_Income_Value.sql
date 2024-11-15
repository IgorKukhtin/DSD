-- Function: lpInsertUpdate_Movement_Income_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income_Value (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income_Value(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������

    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������

    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inPersonalPackerId    Integer   , -- ��������� (������������)
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
    IN inCurrencyValue       TFloat    , -- ���� ������
    IN inComment             TVarChar  , --
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ��������� <��������>
     ioId:= (SELECT tmp.ioId
             FROM lpInsertUpdate_Movement_Income (ioId                := ioId
                                                , inInvNumber         := inInvNumber
                                                , inOperDate          := inOperDate
                                                , inOperDatePartner   := inOperDatePartner
                                                , inInvNumberPartner  := inInvNumberPartner
                                                , ioPriceWithVAT      := inPriceWithVAT
                                                , ioVATPercent        := inVATPercent
                                                , inChangePercent     := inChangePercent
                                                , inFromId            := inFromId
                                                , inToId              := inToId
                                                , inPaidKindId        := inPaidKindId
                                                , inContractId        := inContractId
                                                , inPersonalPackerId  := inPersonalPackerId
                                                , ioPriceListId       := Null  ::Integer
                                                , inCurrencyDocumentId:= inCurrencyDocumentId
                                                , inCurrencyPartnerId := inCurrencyPartnerId
                                                , ioCurrencyValue     := inCurrencyValue
                                                , ioParValue          := NULL  :: TFloat
                                                , inUserId            := inUserId
                                                 ) AS tmp);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.03.21         *
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Income_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
