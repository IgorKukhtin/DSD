-- Function: gpInsertUpdate_Movement_ProfitLossService_ByReportGrid 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReportGrid (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_ByReportGrid (
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
                                                      , inAmountIn          := 0                               :: TFloat
                                                      , inAmountOut         := Sum_Bonus                       :: TFloat
                                                      , inBonusValue        := CAST (Value AS NUMERIC (16, 2)) :: TFloat
                                                      , inComment           := Comment                         :: TVarChar
                                                      , inContractId        := ContractId_find
                                                      , inContractMasterId  := ContractId_master
                                                      , inContractChildId   := ContractId_Child
                                                      , inInfoMoneyId       := InfoMoneyId_find
                                                      , inJuridicalId       := CASE WHEN PartnerId > 0 THEN PartnerId ELSE JuridicalId END  -- ���� ������ ���������� - ���������� ��� � �� ���� ��� ������� ��� ��.���� JuridicalId
                                                      , inPaidKindId        := PaidKindId
                                                      , inUnitId            := 0                               :: Integer
                                                      , inContractConditionKindId   := ConditionKindId
                                                      , inBonusKindId       := BonusKindId
                                                      , inBranchId          := BranchId
                                                      , inIsLoad            := TRUE                            :: Boolean
                                                      , inUserId            := vbUserId
                                                       )
     FROM gpReport_CheckBonus (inStartDate:= inStartDate, inEndDate:= inEndDate, inPaidKindID:= inPaidKindID, inJuridicalId:= inJuridicalId, inBranchId:= inBranchId, inisMovement:= FALSE, inSession:= inSession) AS tmp
     WHERE tmp.Sum_Bonus <> 0 
       AND tmp.isSend = TRUE
     ;

-- if inSession = '5' 
-- then
--     RAISE EXCEPTION '������. test end';
-- end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.09.20         *
*/

-- ����