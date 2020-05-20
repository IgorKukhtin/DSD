-- Function: gpInsertUpdate_Movement_ProfitLossService_ByReport 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_ByReport (
    IN inStartDate                TDateTime ,  
    IN inEndDate                  TDateTime ,
    IN inPaidKindID               Integer   ,
    IN inJuridicalId              Integer   ,
    IN inSession                  TVarChar        -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());
       
       
     /*   -- ������� ��� ��������� �������������� �������������
       PERFORM lpSetErased_Movement (inMovementId:= Movement.Id
                                   , inUserId    := vbUserId)
       FROM Movement
            INNER JOIN MovementBoolean AS MovementBoolean_isLoad
                                       ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                      AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                      AND MovementBoolean_isLoad.ValueData = TRUE
       WHERE Movement.DescId = zc_Movement_ProfitLossService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
       ;
      */
      
     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 
     PERFORM lpInsertUpdate_Movement_ProfitLossService (ioId                := 0
                                                      , inInvNumber         := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                      , inOperDate          := inEndDate
                                                      , inAmountIn          := 0  :: tfloat
                                                      , inAmountOut         := Sum_Bonus
                                                      , inBonusValue        := CAST (Value AS NUMERIC (16, 2))
                                                      , inComment           := Comment
                                                      , inContractId        := ContractId_find
                                                      , inContractMasterId  := ContractId_master
                                                      , inContractChildId   := ContractId_Child
                                                      , inInfoMoneyId       := InfoMoneyId_find
                                                      , inJuridicalId       := JuridicalId
                                                      , inPaidKindId        := PaidKindID
                                                      , inUnitId            := 0 :: Integer
                                                      , inContractConditionKindId   := ConditionKindId
                                                      , inBonusKindId       := BonusKindId
                                                      , inIsLoad            := TRUE
                                                      , inUserId            := vbUserId
                                                       )
     FROM gpReport_CheckBonus (inStartDate:= inStartDate, inEndDate:= inEndDate, inPaidKindID:= inPaidKindID, inJuridicalId:= inJuridicalId, inBranchId:=0, inSession:= inSession) AS tmp
     WHERE Sum_Bonus <> 0
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.05.20         * add inBranchId
 09.12.15         * 
 03.12.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_ByReport (inStartDate := '01.01.2013', inEndDate := '01.01.2013' , inSession:= zfCalc_UserAdmin())
