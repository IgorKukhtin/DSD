-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut(
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
    IN inComment             TVarChar  , -- ����������
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
     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId 
 10.02.14                                        * � lp-������ ���� ���
 10.02.14                                                        *
 14.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inSession:= '2');
