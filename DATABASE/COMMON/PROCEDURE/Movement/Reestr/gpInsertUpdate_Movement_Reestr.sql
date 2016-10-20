-- Function: gpInsertUpdate_Movement_Reestr()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Reestr (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Reestr(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCarId                Integer   , -- ����������
    IN inPersonalDriverId     Integer   , -- ��������� (��������)
    IN inMemberId             Integer   , -- ���������� ����(����������)
    IN inDocumentId_Transport Integer   , -- ������� ����/���������� ������� ���������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
                                              
     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_Reestr (ioId                  := ioId
                                             , inInvNumber        := inInvNumber
                                             , inOperDate         := inOperDate
                                             , inCarId            := inCarId
                                             , inPersonalDriverId := inPersonalDriverId
                                             , inMemberId         := inMemberId
                                             , inDocumentId_Transport := inDocumentId_Transport
                                             , inUserId           := vbUserId
                                              ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.10.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Reestr (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
