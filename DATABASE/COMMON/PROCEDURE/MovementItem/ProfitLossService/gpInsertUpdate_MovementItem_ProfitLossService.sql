-- Function: gpInsertUpdate_MovementItem_ProfitLossService()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProfitLossService(integer, integer, integer, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProfitLossService(integer, integer, integer, tfloat, tvarchar, integer, integer, integer, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProfitLossService(
 INOUT ioId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <�������� ���������� �� ������������ ���� (������� ������� ��������)>
    IN inObjectId                Integer   , -- ����������� ����, ���������� ����
    IN inAmount                  TFloat    , -- �����
    IN inComment                 TVarChar  , -- �����������
    IN inContractId              Integer   , -- �������
    IN inContractConditionKindId Integer   , -- ���� ������� ���������
    IN inInfoMoneyId             Integer   , -- ������ ����������
    IN inUnitId                  Integer   , -- �������������
    IN inPaidKindId              Integer   , -- ���� ���� ������
   OUT outBranchName             TVarChar  , -- ������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBranchId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProfitLossService());

     -- �������� - ��������� ������� ��������� �� ����� ����������������
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE Id = ioId AND isErased = TRUE)
     THEN
         RAISE EXCEPTION '������� �� ����� ���������������� �.�. �� <������>.';
     END IF;
--   ���������� ������ �� �������������
     SELECT Object_Branch.ValueData, Object_Branch.Id
     INTO outBranchName, vbBranchId
     FROM Object AS Object_Branch
     LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                          ON ObjectLink_Unit_Branch.ObjectId = inUnitId
                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

     WHERE Object_Branch.Id =  ObjectLink_Unit_Branch.ChildObjectId
     ;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inObjectId, inMovementId, inAmount, NULL);

     -- ��������� �������� <�����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- ��������� ����� � <���� ������� ���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), ioId, inContractConditionKindId);

     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- ��������� ����� � <���� ���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);



     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, vbBranchId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.14                                                       *
*/


-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_ProfitLossService (ioId:= 0, inMovementId:= 10, inObjectId:= 1, inAmount:= 0, inComment:= 'test', inContractId:= 1, inContractConditionKindId:= 1, inInfoMoneyId:= 0, inUnitId:= 0, inPaidKindId:= 0, outBranchName:= '', inSession:= '2')