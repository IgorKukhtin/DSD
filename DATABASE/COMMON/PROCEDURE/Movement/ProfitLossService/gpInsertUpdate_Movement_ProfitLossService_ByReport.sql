-- Function: gpInsertUpdate_Movement_ProfitLossService_ByReport 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, tvarchar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_ByReport (
   --OUT ioId                       Integer   ,
    IN inStartDate                TDateTime ,  
    IN inEndDate                  TDateTime ,

    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;

BEGIN
  
       -- �������� ���� ������������ �� ����� ���������
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());  
  
       -- ������� ��� ��������� �������������� �������������
       -- 
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

       /*ioId :=  gpInsertUpdate_Movement_ProfitLossService (ioId              := 0             --COALESCE (vbId,0)
                                                         , inInvNumber       := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                         , inOperDate        := inEndDate
                                                         , inAmountIn        := 0
                                                         , inAmountOut       := inAmount
                                                         , inComment         := ''
                                                         , inContractId      := inContractId
                                                         , inInfoMoneyId     := inInfoMoneyId
                                                         , inJuridicalId     := inJuridicalId
                                                         , inPaidKindId      := inPaidKindId
                                                         , inUnitId          := 0
                                                         , inContractConditionKindId   := inContractConditionKindId
                                                         , inBonusKindId     := inBonusKindId
                                                         , inisLoad          := TRUE
                                                         , inSession         := inSession
                                                         );
*/


  -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
  --   PERFORM lpComplete_Movement_Finance_CreateTemp();

     select lpInsertUpdate_Movement_ProfitLossService (ioId              := 0
                                                     , inInvNumber       := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                     , inOperDate        :=inEndDate
                                                     , inAmountIn        := 0
                                                     , inAmountOut       := Sum_Bonus
                                                     , inComment         := ''
                                                     , inContractId      := ContractId_find
                                                     , inInfoMoneyId     := InfoMoneyId_find
                                                     , inJuridicalId     := JuridicalId
                                                     , inPaidKindId      := zc_Enum_PaidKind_FirstForm()
                                                     , inUnitId          := 0
                                                     , inContractConditionKindId   := ConditionKindId
                                                     , inBonusKindId     := BonusKindId
                                                     , inisLoad          := TRUE
                                                     , inUserId          := inSession     --zfCalc_UserAdmin() :: Integer
                                                      )
    from gpReport_CheckBonus (inStartDate:= inStartDate, inEndDate:= inEndDate, inSession:= inSession) as a
    where Sum_Bonus <> 0    -- and Sum_Bonus =30

    ; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.12.14         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_ByReport (inStartDate := '01.01.2013', inEndDate := '01.01.2013' , inSession:= '2')
