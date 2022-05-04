-- Function: lpInsertUpdate_Movement_ReturnIn_scale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn_scale (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnIn_scale(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inParentId            Integer   , -- 
    IN inOperDate            TDateTime , -- ����(�����)
    IN inOperDatePartner     TDateTime , -- ���� ��������� � ����������
    IN inChecked             Boolean   , -- ��������
    IN inIsPartner           Boolean   , -- ��������� - ��� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inisList              Boolean   , -- ������ ��� ������
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- �������
    IN inSubjectDocId        Integer   , -- ��������� ��� �����������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
    IN inCurrencyValue       TFloat    , -- ���� ������
    IN inParValue            TFloat     , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerValue TFloat     , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue      TFloat     , -- ������� ��� ������� ����� ��������
    In inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- ��������� <��������>
     ioId:= (SELECT tmp.ioId
             FROM lpInsertUpdate_Movement_ReturnIn (ioId                  := ioId
                                                  , inInvNumber           := inInvNumber
                                                  , inInvNumberPartner    := inInvNumberPartner
                                                  , inInvNumberMark       := inInvNumberMark
                                                  , inParentId            := inParentId
                                                  , inOperDate            := inOperDate
                                                  , inOperDatePartner     := inOperDatePartner
                                                  , inChecked             := inChecked
                                                  , inIsPartner           := inIsPartner
                                                  , inPriceWithVAT        := inPriceWithVAT
                                                  , inisList              := inisList
                                                  , inVATPercent          := inVATPercent
                                                  , inChangePercent       := inChangePercent
                                                  , inFromId              := inFromId
                                                  , inToId                := inToId
                                                  , inPaidKindId          := inPaidKindId
                                                  , inContractId          := inContractId
                                                  , inCurrencyDocumentId  := inCurrencyDocumentId
                                                  , inCurrencyPartnerId   := inCurrencyPartnerId
                                                  , inCurrencyValue       := inCurrencyValue
                                                  , inParValue            := inCurrencyValue
                                                  , inCurrencyPartnerValue:= inCurrencyPartnerValue
                                                  , inParPartnerValue     := inParPartnerValue
                                                  , inMovementId_OrderReturnTare:= NULL
                                                  , inComment             := inComment
                                                  , inUserId              := inUserId
                                                   ) AS tmp
            );
    
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.22                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_ReturnIn_scale (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
