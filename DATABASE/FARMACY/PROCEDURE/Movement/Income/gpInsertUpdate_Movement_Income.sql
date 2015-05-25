-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inNDSKindId           Integer   , -- ���� ���
    IN inContractId          Integer   , -- �������
    IN inPaymentDate         TDateTime , -- ���� �������
    IN inInvNumberBranch     TVarChar  , -- ����� ���������
    IN inOperDateBranch      TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE(Id Integer, InvNumberBranch TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
   DECLARE vbDeferment Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
     vbUserId := inSession;
     -- �������� ������ �������. ���� �� ���������� �� ��������, �� ����� ����� ���� �������

     SELECT ContractId INTO vbOldContractId FROM Movement_Income_View WHERE Movement_Income_View.Id = ioId;

     IF COALESCE(vbOldContractId, 0) <> inContractId THEN 
        SELECT Deferment INTO vbDeferment 
          FROM Object_Contract_View WHERE Object_Contract_View.Id = inContractId;
        inPaymentDate := inOperDate + vbDeferment * interval '1 day';  
     END IF;

     ioId := lpInsertUpdate_Movement_Income(ioId, inInvNumber, inOperDate, inPriceWithVAT
                                          , inFromId, inToId, inNDSKindId, inContractId, inPaymentDate, vbUserId);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), inId, inInvNumberBranch);

     -- 
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inId, inOperDateBranch);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.05.15                         *
 24.12.14                         *
 02.12.14                                                        *
 10.07.14                                                        *


*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
