-- Function: gpInsertUpdate_Movement_ReturnOut_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut_Partner (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut_Partner(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
   OUT outCurrencyValue      TFloat    , -- ���� ������

    IN inContractFromId      Integer   , -- ��������  
    IN inPaidKindFromId      Integer   , -- ���� ���� ������ 
    IN inChangePercentFrom   TFloat    , -- (-)% ������ (+)% ������� 
    IN inisIncome            Boolean   , -- False ������� ������ �� ����������

    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

     -- ��������� <��������>
     SELECT tmp.ioId, tmp.outCurrencyValue
            INTO ioId, outCurrencyValue
     FROM lpInsertUpdate_Movement_ReturnOut (ioId                 := ioId
                                           , inInvNumber          := inInvNumber
                                           , inOperDate           := inOperDate
                                           , inOperDatePartner    := inOperDatePartner
                                           , inPriceWithVAT       := inPriceWithVAT
                                           , inVATPercent         := inVATPercent
                                           , inChangePercent      := inChangePercent
                                           , inFromId             := inFromId
                                           , inToId               := inToId
                                           , inPaidKindId         := inPaidKindId
                                           , inContractId         := inContractId
                                           , inCurrencyDocumentId := inCurrencyDocumentId
                                           , inCurrencyPartnerId  := inCurrencyPartnerId
                                           , inUserId             := vbUserId
                                            ) AS tmp;

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), ioId, inPaidKindFromId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), ioId, inContractFromId);
     -- ��������� �������� <(-)% ������ (+)% ������� ����������> 
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentPartner(), ioId, inChangePercentFrom);
     -- ��������� �������� <������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isIncome(), ioId, inisIncome);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.07.15         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut_Partner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inSession:= '2');
