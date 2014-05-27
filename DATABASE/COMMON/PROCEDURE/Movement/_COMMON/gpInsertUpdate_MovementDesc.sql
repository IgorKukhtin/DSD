-- Function: gpInsertUpdate_MovementDesc()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementDesc (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementDesc(
    IN inId                  Integer   , -- ���� ������� 
    IN inFormId              Integer   , -- �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_DescId());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������
     IF inFormId = 0 THEN
        inFormId = NULL;
     END IF;

     -- ���������
     UPDATE MovementDesc SET FormId = inFormId WHERE Id = inId;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.05.14                                        * del lpInsert_MovementProtocol
 10.05.14                                        * add lpInsert_MovementProtocol
 24.01.14                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementDesc (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
