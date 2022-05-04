-- Function: gpInsertUpdate_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnIn(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inParentId            Integer   , --
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inChecked             Boolean   , -- ��������
    IN inIsPartner           Boolean   , -- ��������� - ��� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inisList              Boolean   , -- ������ ��� ������
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
   OUT outCurrencyValue      TFloat    , -- ���� ������
   OUT outParValue           TFloat    , -- ������� ��� �������� � ������ �������
 INOUT ioCurrencyPartnerValue TFloat   , -- ���� ��� ������� ����� ��������
 INOUT ioParPartnerValue      TFloat   , -- ������� ��� ������� ����� ��������
    IN inMovementId_OrderReturnTare    Integer   , --
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());


     -- ������� ����� ��� �������
     IF inCurrencyPartnerId <> zc_Enum_Currency_Basis() AND COALESCE (ioCurrencyPartnerValue, 0) = 0
     THEN SELECT Amount, ParValue INTO ioCurrencyPartnerValue, ioParPartnerValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyPartnerId, inPaidKindId:= inPaidKindId);

     ELSEIF inCurrencyPartnerId IN (0, zc_Enum_Currency_Basis())
     THEN outCurrencyValue:= 0;
          outParValue:=0;
     END IF;

     -- ������� ����� ��� �������
     outCurrencyValue:= ioCurrencyPartnerValue;
     outParValue     := ioParPartnerValue;


     -- ��������� <��������>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_Movement_ReturnIn (ioId               := ioId
                                          , inInvNumber        := inInvNumber
                                          , inInvNumberPartner := inInvNumberPartner
                                          , inInvNumberMark    := inInvNumberMark
                                          , inParentId         := inParentId
                                          , inOperDate         := inOperDate
                                          , inOperDatePartner  := CASE WHEN vbUserId = 5 AND ioId > 0 AND 1 = 0 THEN COALESCE ((SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner()), inOperDatePartner) ELSE inOperDatePartner END
                                          , inChecked          := CASE WHEN vbUserId = 5 AND ioId > 0 AND 1 = 0 THEN COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked()), inChecked) ELSE inChecked END
                                          , inIsPartner        := inIsPartner
                                          , inPriceWithVAT     := inPriceWithVAT
                                          , inisList           := inisList
                                          , inVATPercent       := inVATPercent
                                          , inChangePercent    := inChangePercent
                                          , inFromId           := inFromId
                                          , inToId             := inToId
                                          , inPaidKindId       := inPaidKindId
                                          , inContractId       := inContractId
                                          , inCurrencyDocumentId := inCurrencyDocumentId
                                          , inCurrencyPartnerId  := inCurrencyPartnerId
                                          , inCurrencyValue    := outCurrencyValue
                                          , inParValue         := outParValue
                                          , inCurrencyPartnerValue := ioCurrencyPartnerValue
                                          , inParPartnerValue      := ioParPartnerValue
                                          , inMovementId_OrderReturnTare:= inMovementId_OrderReturnTare
                                          , inComment          := inComment
                                          , inUserId           := vbUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.04.22         * inMovementId_OrderReturnTare
 14.05.16         *
 21.08.15         * ADD inIsPartner
 26.06.15         * add
 26.08.14                                        * add ������ � GP - ���������� �������� <���� ��� �������� � ������ �������>
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId
 23.04.14                                        * add inInvNumberMark
 26.03.14                                        * add inInvNumberPartner
 14.02.14                                                         * del DocumentTaxKind
 14.02.14                        * move to lp
 13.01.14                                        * add/del property from redmain
 17.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReturnIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
