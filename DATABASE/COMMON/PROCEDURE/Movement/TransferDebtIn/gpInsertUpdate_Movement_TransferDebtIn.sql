-- Function: gpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtIn (integer, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransferDebtIn(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����� (������)>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inContractFromId      Integer   , -- ������� (�� ����)
    IN inContractToId        Integer   , -- ������� (����)
    IN inPaidKindFromId      Integer   , -- ���� ���� ������ (�� ����)
    IN inPaidKindToId        Integer   , -- ���� ���� ������ (����)
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
                                                  , inOperDate         := inOperDate
                                                  , inPriceWithVAT     := inPriceWithVAT
                                                  , inVATPercent       := inVATPercent
                                                  , inChangePercent    := inChangePercent
                                                  , inFromId           := inFromId
                                                  , inToId             := inToId
                                                  , inPaidKindFromId   := inPaidKindFromId
                                                  , inPaidKindToId     := inPaidKindToId
                                                  , inContractFromId   := inContractFromId
                                                  , inContractToId     := inContractToId
                                                  , inUserId           := vbUserId
                                                   ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.05.14                                        * del ioPriceListId, outPriceListName
 25.04.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TransferDebtIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
