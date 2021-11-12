-- Function: gpInsertUpdate_Movement_Income_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income_Partner(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������

 INOUT ioPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
 INOUT ioVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������

    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inPersonalPackerId    Integer   , -- ��������� (������������)
 INOUT ioPriceListId         Integer    , -- ����� ����
   OUT outPriceListName      TVarChar   , -- ����� ����
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
   OUT outCurrencyValue      TFloat    , -- ���� ������
    IN inContractToId        Integer   , -- ��������
    IN inPaidKindToId        Integer   , -- ���� ���� ������
 INOUT ioChangePercentTo     TFloat    , -- (-)% ������ (+)% �������
    IN inisIncome            Boolean   , -- False ������� ������ �� ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());


     -- �����/������
     ioChangePercentTo:= (SELECT MAX (Object_ContractCondition_ValueView.ChangePercentPartner)
                          FROM Object_ContractCondition_ValueView
                          WHERE Object_ContractCondition_ValueView.ContractId = inContractId
                            AND inOperDatePartner BETWEEN Object_ContractCondition_ValueView.StartDate AND Object_ContractCondition_ValueView.EndDate
                         );


     -- ��������� <��������>
     SELECT tmp.ioId, tmp.ioCurrencyValue, tmp.ioPriceListId, tmp.outPriceListName, tmp.ioPriceWithVAT, tmp.ioVATPercent
            INTO ioId, outCurrencyValue, ioPriceListId, outPriceListName, ioPriceWithVAT, ioVATPercent
     FROM lpInsertUpdate_Movement_Income (ioId                := ioId
                                        , inInvNumber         := inInvNumber
                                        , inOperDate          := inOperDate
                                        , inOperDatePartner   := inOperDatePartner
                                        , inInvNumberPartner  := inInvNumberPartner
                                        , ioPriceWithVAT      := ioPriceWithVAT
                                        , ioVATPercent        := ioVATPercent
                                        , inChangePercent     := inChangePercent
                                        , inFromId            := inFromId
                                        , inToId              := inToId
                                        , inPaidKindId        := inPaidKindId
                                        , inContractId        := inContractId
                                        , inPersonalPackerId  := inPersonalPackerId
                                        , ioPriceListId       := ioPriceListId
                                        , inCurrencyDocumentId:= inCurrencyDocumentId
                                        , inCurrencyPartnerId := inCurrencyPartnerId
                                        , ioCurrencyValue     := NULL :: TFloat
                                        , ioParValue          := NULL :: TFloat
                                        , inUserId            := vbUserId
                                         ) AS tmp;


     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindToId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractToId);
     -- ��������� �������� <(-)% ������ (+)% ������� ����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentPartner(), ioId, ioChangePercentTo);
     -- ��������� �������� <������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isIncome(), ioId, inisIncome);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.03.21         *
 29.06.15         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Income_Partner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
