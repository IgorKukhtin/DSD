-- Function: gpInsertUpdate_Movement_BankAccount()


DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inAmountIn            TFloat    , -- ����� �������
    IN inAmountOut           TFloat    , -- ����� �������

    IN inBankAccountId       Integer   , -- ��������� ���� 	
    IN inComment             TVarChar  , -- ����������� 
    IN inMoneyPlaceId        Integer   , -- �� ����, ����, �����  	
    IN inContractId          Integer   , -- ��������
    IN inInfoMoneyId         Integer   , -- ������ ���������� 
    IN inUnitId              Integer   , -- �������������
    IN inCurrencyId          Integer   , -- ������ 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- ��������
     IF (COALESCE(inAmountIn, 0) = 0) AND (COALESCE(inAmountOut, 0) = 0) THEN
        RAISE EXCEPTION '������� ����� ������� ��� �������';
     END IF;

     -- ��������
     IF (COALESCE(inAmountIn, 0) <> 0) AND (COALESCE(inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION '������ ���� ������� ������ ���� ����� - ��� ������� ��� �������.';
     END IF;

     -- ������
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId, inInvNumber, inOperDate, vbAmount
                                               , inBankAccountId, inComment, inMoneyPlaceId, inContractId, inInfoMoneyId, inUnitId, inCurrencyId
                                               , (SELECT ParentId FROM Movement WHERE Id = ioId), null
                                               , vbUserId
                                                );

     -- 5.1. ������� - ��������
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;

     -- 5.2. ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, JuridicalId_Basis Integer
                               , UnitId Integer, BranchId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount())
     THEN
          PERFORM lpComplete_Movement_BankAccount (inMovementId := ioId
                                                 , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 17.08.14                                        * add MovementDescId
 11.05.14                                        * add ioId:= 
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 04.04.14                                        * add lpComplete_Movement_BankAccount
 13.03.14                                        * add vbUserId
 13.03.14                                        * err inParentId NOT NULL
 06.12.13                          *
 09.08.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
