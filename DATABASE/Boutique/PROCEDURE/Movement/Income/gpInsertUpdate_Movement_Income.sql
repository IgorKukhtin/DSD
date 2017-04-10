-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inCurrencyDocumentId   Integer   , -- ������ (���������)
    IN inCurrencyPartnerId    Integer   , -- ������ (�����������)
    IN inCurrencyValue        TFloat    , -- ���� ������
    IN inParValue             TFloat    , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerValue TFloat    , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue      TFloat    , -- ������� ��� ������� ����� ��������
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());

     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Income (ioId                := ioId
                                           , inInvNumber         := inInvNumber
                                           , inOperDate          := inOperDate
                                           , inFromId            := inFromId
                                           , inToId              := inToId
                                           , inCurrencyDocumentId:= inCurrencyDocumentId
                                           , inCurrencyPartnerId := inCurrencyPartnerId
                                           , inCurrencyValue     := inCurrencyValue
                                           , inParValue          := inParValue
                                           , inCurrencyPartnerValue := inCurrencyPartnerValue
                                           , inParPartnerValue   := inParPartnerValue
                                           , inComment           := inComment
                                           , inUserId            := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.04.17         *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
