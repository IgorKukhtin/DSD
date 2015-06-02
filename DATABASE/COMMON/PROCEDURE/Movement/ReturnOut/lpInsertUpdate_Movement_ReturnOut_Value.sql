-- Function: lpInsertUpdate_Movement_ReturnOut_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut_Value (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer,Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnOut_Value(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���������>
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
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ��������� <��������>
     ioId:= 
    (SELECT tmp.ioId
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
                                           , inUserId             := inUserId
                                            ) AS tmp);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 29.05.15                                        *
*/

-- ����
--SELECT * FROM lpInsertUpdate_Movement_ReturnOut_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inUserId:= 2)
