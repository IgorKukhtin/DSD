-- Function: gpInsertUpdate_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, tdatetime, tdatetime, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, integer, tdatetime, tdatetime, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, TVarChar, tvarchar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, integer, tdatetime, tdatetime, boolean, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, integer, tdatetime, tdatetime, boolean, boolean, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, TVarChar, tvarchar);

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
    In inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());


     -- ���������� � �������� <���� ��� �������� � ������ �������>
     outCurrencyValue := 1.00;
     IF inCurrencyDocumentId <> inCurrencyPartnerId -- AND inCurrencyDocumentId > 0 AND inCurrencyPartnerId > 0
     THEN
        outCurrencyValue := (SELECT MovementItem.Amount
                             FROM (SELECT MAX (Movement.OperDate) AS maxOperDate
                                   FROM Movement 
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId = zc_MI_Master()
                                                              AND MovementItem.ObjectId = inCurrencyDocumentId
                                                              AND MovementItem.isErased = FALSE
                                       INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                         ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                                        AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                                                                        AND MILinkObject_CurrencyTo.ObjectId = inCurrencyPartnerId
                                   WHERE Movement.DescId = zc_Movement_Currency()
                                     AND Movement.OperDate <= inOperDate
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   ) AS tmpCurrency
                                   INNER JOIN Movement ON Movement.OperDate = tmpCurrency.maxOperDate
                                                      AND Movement.DescId = zc_Movement_Currency()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                            );
     END IF;


     -- ��������� <��������>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_Movement_ReturnIn
                                       (ioId               := ioId
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
                                      , inComment          := inComment
                                      , inUserId           := vbUserId
                                       )AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
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
