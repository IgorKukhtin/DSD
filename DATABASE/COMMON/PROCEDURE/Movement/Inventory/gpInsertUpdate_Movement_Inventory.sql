-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inSession             TVarChar    -- ������ ������������
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Inventory (ioId               := ioId
                                              , inInvNumber        := inInvNumber
                                              , inOperDate         := inOperDate
                                              , inFromId           := inFromId
                                              , inToId             := inToId
                                              , inUserId           := vbUserId
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Inventory (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inSession:= '2')
