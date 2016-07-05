-- Function: gpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inDocumentKindId      Integer   , -- ��� ��������� (� ���������)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Send (ioId               := ioId
                                         , inInvNumber        := inInvNumber
                                         , inOperDate         := inOperDate
                                         , inFromId           := inFromId
                                         , inToId             := inToId
                                         , inDocumentKindId   := inDocumentKindId
                                         , inUserId           := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.06.16         *
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
