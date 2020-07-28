-- Function: gpInsertUpdate_Movement_ProfitIncomeService_ByReport 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitIncomeService_ByReport (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitIncomeService_ByReport (
    IN inStartDate                TDateTime ,  
    IN inEndDate                  TDateTime ,
    IN inPaidKindId               Integer   ,
    IN inJuridicalId              Integer   ,
    IN inBranchId                 Integer   ,
    IN inSession                  TVarChar        -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitIncomeService());
       
       
     /*   -- ������� ��� ��������� �������������� �������������
       PERFORM lpSetErased_Movement (inMovementId:= Movement.Id
                                   , inUserId    := vbUserId)
       FROM Movement
            INNER JOIN MovementBoolean AS MovementBoolean_isLoad
                                       ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                      AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                      AND MovementBoolean_isLoad.ValueData = TRUE
       WHERE Movement.DescId = zc_Movement_ProfitIncomeService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
       ;
      */
      
     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 
     PERFORM lpInsertUpdate_Movement_ProfitIncomeService (ioId                := 0
                                                        , inInvNumber         := CAST (NEXTVAL ('movement_ProfitIncomeService_seq') AS TVarChar) 
                                                        , inOperDate          := inEndDate
                                                        , inAmountIn          := 0  :: tfloat
                                                        , inAmountOut         := Sum_Bonus
                                                        , inBonusValue        := CAST (Value AS NUMERIC (16, 2))
                                                        , inComment           := Comment
                                                        , inContractId        := ContractId_find
                                                        , inContractMasterId  := ContractId_master
                                                        , inContractChildId   := ContractId_Child
                                                        , inInfoMoneyId       := InfoMoneyId_find
                                                        , inJuridicalId       := COALESCE (PartnerId, JuridicalId)  -- ���� ������ ���������� - ���������� ��� � �� ���� ��� ������� ��� ��.���� JuridicalId
                                                        , inPaidKindId        := PaidKindId
                                                        , inContractConditionKindId := ConditionKindId
                                                        , inBonusKindId       := BonusKindId
                                                        , inBranchId          := BranchId
                                                        , inIsLoad            := TRUE
                                                        , inUserId            := vbUserId
                                                         )
     FROM gpReport_CheckBonus (inStartDate:= inStartDate, inEndDate:= inEndDate, inPaidKindID:= inPaidKindID, inJuridicalId:= inJuridicalId, inBranchId:= inBranchId, inSession:= inSession) AS tmp
     WHERE tmp.Sum_Bonus <> 0
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.07.20         *
*/

-- ����
--