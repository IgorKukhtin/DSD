-- Function: gpSelect_Movement_ProfitLossService_ByReport()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitLossService_ByReport(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inOperDate           TDateTime , -- Дата начисления
    IN inBonusKindId        Integer   , -- вид бонуса
    IN inPaidKindId         Integer   , -- ФО
    IN inJuridicalId        Integer   , --
    IN inBranchId           Integer  ,
    IN inMemberId           Integer  ,
    IN inisReport           Boolean ,   -- Данные из отчета (да/нет)
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE(Id Integer, InvNumber TVarChar, InvNumber_full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate  TDateTime
             , TotalSumm  TFloat
             , PercentRet TFloat
             , PartKg     TFloat
             , AmountIn TFloat, AmountOut TFloat
             , BonusValue TFloat, AmountPartner TFloat, Summ TFloat
             , Summ_51201 TFloat
             , Comment TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar, OKPO TVarChar
             , JuridicalCode_Child Integer, JuridicalName_Child TVarChar, OKPO_Child TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerCode Integer, PartnerName TVarChar, ItemName_Partner TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , ContractMasterId Integer, ContractMasterInvNumber TVarChar, ContractTagName_master TVarChar
             , ContractChildId Integer, ContractChildInvNumber TVarChar, ContractTagName_child TVarChar
             , UnitName TVarChar
             , PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , PersonalId_main Integer, PersonalName_main TVarChar
             , PaidKindId_Child Integer, PaidKindName_Child TVarChar
             , isLoad Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProfitLossService());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH 
           tmpMovement AS (SELECT tmp.*
                           FROM  gpSelect_Movement_ProfitLossService (inStartDate       := inStartDate
                                                                    , inEndDate         := inEndDate
                                                                    , inJuridicalBasisId:= 0
                                                                    , inBranchId        := inBranchId
                                                                    , inPaidKindId      := inPaidKindId
                                                                    , inIsErased        := false::Boolean
                                                                    , inSession         := inSession) AS tmp
                           WHERE (tmp.JuridicalId = inJuridicalId OR inJuridicalId = 0) 
                           )

  
       SELECT *
       FROM tmpMovement
            
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.21         *
*/

-- тест
--