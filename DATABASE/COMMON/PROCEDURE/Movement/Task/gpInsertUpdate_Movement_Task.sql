-- Function: gpInsertUpdate_Movement_Task()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Task (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Task(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ����(�����)
    IN inPersonalTradeId     Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Task());

     --vbUserId:=:= (CASE WHEN vbUserId = 5 THEN 140094 ELSE vbUserId);

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_Task
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inPersonalTradeId  := inPersonalTradeId
                                      , inUserId           := vbUserId
                                       )AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.03.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Task (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPersonalTradeId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
