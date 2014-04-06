-- Function: gpInsertUpdate_Movement_SendDebt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendDebt(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

 INOUT ioMasterId            Integer   , -- ���� ������� <������� ���������>
 INOUT ioChildId             Integer   , -- ���� ������� <������� ���������>

    IN inAmount              TFloat    , -- �����  
    
    IN inJuridicalFromId     Integer   , -- ��.����
    IN inContractFromId      Integer   , -- �������
    IN inPaidKindFromId      Integer   , -- ��� ���� ������
    IN inInfoMoneyFromId     Integer   , -- ������ ����������

    IN inJuridicalToId       Integer   , -- ��.����
    IN inContractToId        Integer   , -- �������
    IN inPaidKindToId        Integer   , -- ��� ���� ������
    IN inInfoMoneyToId       Integer   , -- ������ ����������

    IN inComment             TVarChar  , -- ����������
    
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebt());

     -- ��������
     IF (COALESCE (inJuridicalFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <����������� ���� (�����)>.';
     END IF;
     IF (COALESCE (inInfoMoneyFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <�� ������ ���������� (�����)>.';
     END IF;
     IF (COALESCE (inContractFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <������� (�����)>.';
     END IF;

     -- ��������
     IF (COALESCE (inJuridicalToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <����������� ���� (������)>.';
     END IF;
     IF (COALESCE (inInfoMoneyToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <�� ������ ���������� (������)>.';
     END IF;
     IF (COALESCE (inContractToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <������� (������)>.';
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_SendDebt())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SendDebt(), inInvNumber, inOperDate, NULL);

   
     -- ��������� <������� ������� ���������>
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), inJuridicalFromId, ioId, inAmount, NULL);

     -- ��������� ����� � <������� �� >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMasterId, inContractFromId);

     -- ��������� ����� � <��� ���� ������ ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMasterId, inPaidKindFromId);

     -- ��������� ����� � <������ ���������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);

     -- ��������� �������� <�����������>
     PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMasterId, inComment);


     -- ��������� <������ ������� ���������>
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), inJuridicalToId, ioId, inAmount, NULL);

     -- ��������� ����� � <������� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioChildId, inContractToId);

     -- ��������� ����� � <��� ���� ������ ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioChildId, inPaidKindToId);

     -- ��������� ����� � <������ ���������� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, inInfoMoneyToId);

     -- ������� - !!!��� �����������!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
     -- 5.1. ������� - ��������
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- 5.2. ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, JuridicalId_Basis Integer
                               , UnitId Integer, BranchId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebt())
     THEN
          PERFORM lpComplete_Movement_SendDebt (inMovementId := ioId
                                              , inUserId     := vbUserId);
     END IF;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 28.01.14                                        * add lpComplete_Movement_SendDebt
 24.01.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_SendDebt (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
