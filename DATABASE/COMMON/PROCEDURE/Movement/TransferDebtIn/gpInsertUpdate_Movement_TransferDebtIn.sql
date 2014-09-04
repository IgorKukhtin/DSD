-- Function: gpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransferDebtIn(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����� (������)>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inContractFromId      Integer   , -- ������� (�� ����)
    IN inContractToId        Integer   , -- ������� (����)
    IN inPaidKindFromId      Integer   , -- ���� ���� ������ (�� ����)
    IN inPaidKindToId        Integer   , -- ���� ���� ������ (����)
    IN inPartnerId           Integer   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn());

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_TransferDebtIn (ioId    := ioId
                                                  , inInvNumber        := inInvNumber
                                                  , inInvNumberPartner := inInvNumberPartner
                                                  , inOperDate         := inOperDate
                                                  , inChecked          := inChecked
                                                  , inPriceWithVAT     := inPriceWithVAT
                                                  , inVATPercent       := inVATPercent
                                                  , inChangePercent    := inChangePercent
                                                  , inFromId           := inFromId
                                                  , inToId             := inToId
                                                  , inPaidKindFromId   := inPaidKindFromId
                                                  , inPaidKindToId     := inPaidKindToId
                                                  , inContractFromId   := inContractFromId
                                                  , inContractToId     := inContractToId
                                                  , inPartnerId        := inPartnerId
                                                  , inUserId           := vbUserId
                                                   ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.09.14         * add inChecked
 20.06.14                                                       * add InvNumberPartner
 07.05.14                                        * add inPartnerId
 04.05.14                                        * del ioPriceListId, outPriceListName
 25.04.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TransferDebtIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
