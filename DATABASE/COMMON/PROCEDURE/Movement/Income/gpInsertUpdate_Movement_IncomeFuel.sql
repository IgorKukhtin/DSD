-- Function: gpInsertUpdate_Movement_IncomeFuel()

-- DROP FUNCTION gpInsertUpdate_Movement_IncomeFuel();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeFuel(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ����

    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePrice         TFloat    , -- ������ � ����
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������ 
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inPersonalDriverId    Integer   , -- ��������� (��������)
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());


     -- �������� - ��������� ��������� �������� ������
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= '���������');

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioId
                                               , inParentId         := NULL
                                               , inInvNumber        := inInvNumber
                                               , inOperDate         := inOperDate
                                               , inOperDatePartner  := inOperDatePartner
                                               , inInvNumberPartner := inInvNumberPartner
                                               , inPriceWithVAT     := inPriceWithVAT
                                               , inVATPercent       := inVATPercent
                                               , inChangePrice      := inChangePrice
                                               , inFromId           := inFromId
                                               , inToId             := inToId
                                               , inPaidKindId       := inPaidKindId
                                               , inContractId       := inContractId
                                               , inRouteId          := inRouteId
                                               , inPersonalDriverId := inPersonalDriverId
                                               , inAccessKeyId      := vbAccessKeyId 
                                               , inUserId           := vbUserId 
                                                );
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.13                                        * add lpGetAccess
 31.10.13                                        * add inOperDatePartner
 19.10.13                                        * add inChangePrice
 07.10.13                                        * add lpCheckRight
 06.10.13                                        * add lfCheck_Movement_Parent
 05.10.13                                        * add inInvNumberPartner
 04.10.13                                        * add lpInsertUpdate_Movement_IncomeFuel
 04.10.13                                        * add Route
 27.09.13                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_IncomeFuel (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePrice:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
