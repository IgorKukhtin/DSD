-- Function: gpInsertUpdate_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tdatetime, tdatetime, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tdatetime, tdatetime, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnIn(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberMark       TVarChar  , -- ����� "������������ ������ ����� �i ������"
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inChecked             Boolean   , -- ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_ReturnIn
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inInvNumberPartner := inInvNumberPartner
                                      , inInvNumberMark    := inInvNumberMark
                                      , inOperDate         := inOperDate
                                      , inOperDatePartner  := inOperDatePartner
                                      , inChecked          := inChecked
                                      , inPriceWithVAT     := inPriceWithVAT
                                      , inVATPercent       := inVATPercent
                                      , inChangePercent    := inChangePercent
                                      , inFromId           := inFromId
                                      , inToId             := inToId
                                      , inPaidKindId       := inPaidKindId
                                      , inContractId       := inContractId
                                      , inCurrencyDocumentId := inCurrencyDocumentId
                                      , inCurrencyPartnerId  := inCurrencyPartnerId
                                      , inUserId           := vbUserId
                                       );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
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
