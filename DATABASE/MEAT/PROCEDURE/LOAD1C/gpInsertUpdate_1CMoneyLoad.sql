-- Function: gpInsertUpdate_1CMoneyLoad()

DROP FUNCTION IF EXISTS gpInsertUpdate_1CMoneyLoad(Integer, TVarChar, TDateTime, 
    Integer, TVarChar, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_1CMoneyLoad(
    IN inUnitId Integer, 
    IN inInvNumber TVarChar,
    IN inOperDate TDateTime, 
    IN inClientCode Integer, 
    IN inClientName TVarChar, 
    IN inSummaIn TFloat, 
    IN inSummaOut TFloat,
    IN inBranchId Integer,
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
--     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());
    
     IF inBranchId <> zfGetBranchFromUnitId(inUnitId) THEN
        RAISE EXCEPTION '������ � ����� �� ������������ ���������� �������';
     END IF;
    
        INSERT INTO Money1C (UnitId, InvNumber, OperDate, ClientCode, ClientName, SummaIn, SummaOut)
             VALUES(inUnitId, inInvNumber, inOperDate, inClientCode, inClientName, inSummaIn, inSummaOut);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 01.09.14                        * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_1CMoneyLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
