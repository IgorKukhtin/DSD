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
RETURNS TABLE( MovementId Integer, InvNumber TVarChar, OperDate TDateTime, ServiceDate TDateTime, StatusCode Integer
             , isSend Boolean
             , ContractStateKindId_Child Integer, ContractStateKindName_Child TVarChar
             , ContractTagName_child TVarChar
             , ContractId_Master Integer, ContractId_Child Integer, ContractId_find Integer
             , InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , BranchId Integer, BranchName TVarChar, BranchName_inf TVarChar
             --
             , JuridicalId Integer, JuridicalName TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , Value TFloat, PercentRetBonus TFloat, PercentRetBonus_fact_weight TFloat
             , Sum_Sale_weight TFloat, Sum_ReturnIn_weight TFloat
             , PercentRetBonus_diff_weight TFloat
             , BonusKindId Integer, BonusKindName TVarChar
             , InfoMoneyId_master Integer, InfoMoneyId_child Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PaidKindId_Child Integer, PaidKindName_Child TVarChar
             , RetailName TVarChar
             , PersonalId Integer
             , PersonalCode Integer
             , PersonalName TVarChar --супервайзер
             , PersonalTradeId Integer
             , PersonalTradeCode Integer
             , PersonalTradeName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , AreaId Integer, AreaName TVarChar
             
             , Sum_CheckBonus TFloat
             , Sum_SaleReturnIn TFloat
             , Sum_Account TFloat
             , Sum_AccountSendDebt TFloat
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
             , AmountKg TFloat
             , AmountSh TFloat
             , PartKg   TFloat

             , Comment TVarChar
             , isSalePart Boolean 
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
         , tmpObject_Contract_View AS (SELECT Object_Contract_View.*
                                       FROM Object_Contract_View
                                       WHERE Object_Contract_View.ContractId IN (SELECT DISTINCT tmpMovement.ContractChildId  AS Id FROM tmpMovement)
                                       )

         , tmpObject_Personal_View AS (SELECT Object_Personal_View.*
                                       FROM Object_Personal_View
                                       WHERE Object_Personal_View.PersonalId IN (SELECT DISTINCT tmpMovement.PersonalId      AS Id FROM tmpMovement
                                                                           UNION SELECT DISTINCT tmpMovement.PersonalId_main AS Id FROM tmpMovement)
                                       )
         , tmpReport AS (SELECT *
                         FROM gpReport_CheckBonus (inStartDate    := inStartDate                                --gpReport_CheckBonusTest2_old
                                                 , inEndDate      := inEndDate
                                                 , inPaidKindId   := inPaidKindId
                                                 , inJuridicalId  := inJuridicalId
                                                 , inBranchId     := inBranchId
                                                 , inMemberId     := inMemberId
                                                 , inIsMovement   := FALSE
                                                 , inisDetail     := FALSE
                                                 , inisGoods      := FALSE
                                                 , inSession      := inSession
                                                  ) AS tmp
                         WHERE inisReport = TRUE
                         )

         , tmpMovementAll AS (SELECT tmpMovement.Id AS MovementId
                                   , tmpMovement.InvNumber
                                   , tmpMovement.OperDate
                                   , tmpMovement.ServiceDate
                                   , tmpMovement.StatusCode
                                   , FALSE ::Boolean AS isSend 
                                   , Object_Contract_Child.ContractStateKindId   AS ContractStateKindId_Child
                                   , Object_Contract_Child.ContractStateKindName AS ContractStateKindName_Child
                                   , tmpMovement.ContractTagName_child
                                   , tmpMovement.ContractMasterId                AS ContractId_Master
                                   , tmpMovement.ContractChildId                 AS ContractId_Child
                                   , 0 ::Integer                                 AS ContractId_find
                                   , tmpMovement.ContractMasterInvNumber         AS InvNumber_master
                                   , tmpMovement.ContractChildInvNumber          AS InvNumber_child
                                   , '' ::TVarChar                               AS InvNumber_find
                                   , tmpMovement.BranchId
                                   , tmpMovement.BranchName
                                   , Object_Personal_trade.BranchName AS BranchName_inf -- Филиал из подразделения  отв.сотр.
                                   , tmpMovement.JuridicalId
                                   , tmpMovement.JuridicalName 
                                   , tmpMovement.ContractConditionKindId    AS ConditionKindId
                                   , tmpMovement.ContractConditionKindName  AS ConditionKindName
                                   , tmpMovement.BonusValue AS Value
                                   , tmpMovement.PercentRet AS PercentRetBonus
                                   , 0 ::TFloat AS PercentRetBonus_fact_weight
                                   , 0 ::TFloat AS Sum_Sale_weight
                                   , 0 ::TFloat AS Sum_ReturnIn_weight
                                   , 0 ::TFloat AS PercentRetBonus_diff_weight
                                   , tmpMovement.BonusKindId
                                   , tmpMovement.BonusKindName
                                   , tmpMovement.InfoMoneyid        AS InfoMoneyId_master --Object_InfoMoney_master.ValueData      
                                   , Object_InfoMoney_child.Id      AS InfoMoneyId_child
                                   , 0 ::Integer                    AS InfoMoneyId_find
                                   , tmpMovement.InfoMoneyName        AS InfoMoneyName_master --Object_InfoMoney_master.ValueData      
                                   , Object_InfoMoney_child.ValueData AS InfoMoneyName_child
                                   , '' ::TVarChar                    AS InfoMoneyName_find
                                   , tmpMovement.PaidKindId
                                   , tmpMovement.PaidKindName
                                   , tmpMovement.PaidKindId_Child
                                   , tmpMovement.PaidKindName_Child
                                   , tmpMovement.RetailName
                                   , tmpMovement.PersonalId_main    AS PersonalId
                                   , Object_Personal.PersonalCode   AS PersonalCode
                                   , tmpMovement.PersonalName_main  AS PersonalName  --супервайзер
                                   , tmpMovement.PersonalId AS PersonalTradeId
                                   , Object_Personal_trade.PersonalCode   AS PersonalTradeCode
                                   , Object_Personal_trade.PersonalName   AS PersonalTradeName
                                   , tmpMovement.PartnerId
                                   , tmpMovement.PartnerName
                                   , Object_Area.Id                  AS AreaId
                                   , Object_Area.ValueData           AS AreaName
                                   , tmpMovement.TotalSumm ::TFloat AS Sum_CheckBonus --сумма база
                                   , 0 ::TFloat  AS Sum_SaleReturnIn
                                   , 0 ::TFloat  AS Sum_Account
                                   , 0 ::TFloat  AS Sum_AccountSendDebt
                                   , 0 ::TFloat  AS Sum_Bonus
                                   , (COALESCE (tmpMovement.AmountIn,0) + COALESCE (tmpMovement.AmountOut,0)) ::TFloat AS Sum_BonusFact
                                   , 0 ::TFloat AmountKg
                                   , 0 ::TFloat AmountSh
                                   , 0 ::TFloat PartKg  
                                   , tmpMovement.Comment
                                   , FALSE ::Boolean AS isSalePart --Долевая продажа
                              FROM tmpMovement
                                   --LEFT JOIN tmpObject_Contract_View AS Object_Contract_Master ON Object_Contract_Master.ContractId = tmpMovement.ContractMasterId
                                   LEFT JOIN tmpObject_Contract_View AS Object_Contract_Child ON Object_Contract_Child.ContractId = tmpMovement.ContractChildId
                       
                                   LEFT JOIN Object AS Object_InfoMoney_master ON Object_InfoMoney_master.Id = tmpMovement.ContractMasterId
                                   LEFT JOIN Object AS Object_InfoMoney_child ON Object_InfoMoney_child.Id = Object_Contract_Child.ContractId
                       
                                   LEFT JOIN tmpObject_Personal_View AS Object_Personal_trade ON Object_Personal_trade.PersonalId = tmpMovement.PersonalId
                                   LEFT JOIN tmpObject_Personal_View AS Object_Personal ON Object_Personal.PersonalId = tmpMovement.PersonalId_main
                       
                                   LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                                                        ON ObjectLink_Partner_Area.ObjectId = tmpMovement.PartnerId
                                                       AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
                                   LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
                             )

         , tmpReportAll AS (SELECT 0                AS MovementId
                                 , ''   ::TVarChar  AS InvNumber
                                 , NULL ::TDateTime AS OperDate
                                 , NULL ::Integer   AS StatusCode
                                 , FALSE ::Boolean AS isSend
                                 , Object_Contract_Child.ContractStateKindId   AS ContractStateKindId_Child
                                 , Object_Contract_Child.ContractStateKindName AS ContractStateKindName_Child
                                 , tmp.ContractTagName_child
                                 , tmp.ContractId_master, tmp.ContractId_child, tmp.ContractId_find
                                 , tmp.InvNumber_master, tmp.InvNumber_child, tmp.InvNumber_find
                                 , tmp.BranchId, tmp.BranchName
                                 , tmp.BranchName_inf
                                 , tmp.JuridicalId, tmp.JuridicalName
                                 , tmp.ConditionKindId, tmp.ConditionKindName
                                 , tmp.Value
                                 , tmp.PercentRetBonus
                                 , tmp.PercentRetBonus_fact_weight
                                 , tmp.Sum_Sale_weight
                                 , tmp.Sum_ReturnIn_weight
                                 , tmp.PercentRetBonus_diff_weight
                                 , tmp.BonusKindId, tmp.BonusKindName
                                 , tmp.InfoMoneyId_master, tmp.InfoMoneyId_child, tmp.InfoMoneyId_find
                                 , tmp.InfoMoneyName_master, tmp.InfoMoneyName_child, tmp.InfoMoneyName_find
                                 , tmp.PaidKindId, tmp.PaidKindName
                                 , tmp.PaidKindId_Child, tmp.PaidKindName_Child
                                 , tmp.RetailName
                                 , tmp.PersonalId
                                 , tmp.PersonalCode
                                 , tmp.PersonalName
                                 , tmp.PersonalTradeId
                                 , tmp.PersonalTradeCode
                                 , tmp.PersonalTradeName           
                                 , tmp.PartnerId
                                 , tmp.PartnerName
                                 , tmp.AreaId
                                 , tmp.AreaName
                                 , tmp.Sum_CheckBonus
                                 , tmp.Sum_SaleReturnIn
                                 , tmp.Sum_Account
                                 , tmp.Sum_AccountSendDebt           
                                 , tmp.Sum_Bonus
                                 , tmp.Sum_BonusFact
                                 , tmp.AmountKg  ::TFloat
                                 , tmp.AmountSh  ::TFloat
                                 , tmp.PartKg    ::TFloat
                                 , tmp.Comment
                                 , tmp.isSalePart
                           FROM tmpReport AS tmp
                                 LEFT JOIN tmpObject_Contract_View AS Object_Contract_Child  ON Object_Contract_Child.ContractId = tmp.ContractId_child
                            )


       SELECT COALESCE (tmp.MovementId ,tmpR.MovementId) AS MovementId
            , COALESCE (tmp.InvNumber,tmpR.InvNumber)    AS InvNumber
            , COALESCE (tmp.OperDate,tmpR.OperDate)      AS OperDate
            , COALESCE (tmp.ServiceDate,Null) ::TDateTime AS ServiceDate
            , COALESCE (tmp.StatusCode,tmpR.StatusCode)  AS StatusCode
            
            , COALESCE (tmp.isSend ,tmpR.isSend) AS isSend
            , COALESCE (tmp.ContractStateKindId_Child,tmpR.ContractStateKindId_Child)     AS ContractStateKindId_Child
            , COALESCE (tmp.ContractStateKindName_Child,tmpR.ContractStateKindName_Child) AS ContractStateKindName_Child
            , COALESCE (tmp.ContractTagName_child,tmpR.ContractTagName_child)             AS ContractTagName_child
            , COALESCE (tmp.ContractId_Master,tmpR.ContractId_Master) AS ContractId_Master
            , COALESCE (tmp.ContractId_Child,tmpR.ContractId_Child)   AS ContractId_Child
            , COALESCE (tmp.ContractId_find,tmpR.ContractId_find)     AS ContractId_find
            , COALESCE (tmp.InvNumber_master,tmpR.InvNumber_master) AS InvNumber_master
            , COALESCE (tmp.InvNumber_child,tmpR.InvNumber_child)   AS InvNumber_child
            , COALESCE (tmp.InvNumber_find,tmpR.InvNumber_find)     AS InvNumber_find
            , COALESCE (tmp.BranchId,tmpR.BranchId) AS BranchId
            , COALESCE (tmp.BranchName,tmpR.BranchName) AS BranchName
            , COALESCE (tmp.BranchName_inf,tmpR.BranchName_inf) AS BranchName_inf

            , COALESCE (tmp.JuridicalId,tmpR.JuridicalId) AS JuridicalId
            , COALESCE (tmp.JuridicalName,tmpR.JuridicalName)  AS JuridicalName

            , COALESCE (tmp.ConditionKindId,tmpR.ConditionKindId)    AS ConditionKindId
            , COALESCE (tmp.ConditionKindName,tmpR.ConditionKindName)  AS ConditionKindName
            
            , COALESCE (tmp.Value,tmpR.Value)                                             ::TFloat AS Value
            , COALESCE (tmp.PercentRetBonus,tmpR.PercentRetBonus)                         ::TFloat AS PercentRetBonus
            , COALESCE (tmp.PercentRetBonus_fact_weight,tmpR.PercentRetBonus_fact_weight) ::TFloat AS PercentRetBonus_fact_weight
            , COALESCE (tmp.Sum_Sale_weight ,tmpR.Sum_Sale_weight)                        ::TFloat AS Sum_Sale_weight
            , COALESCE (tmp.Sum_ReturnIn_weight ,tmpR.Sum_ReturnIn_weight)                ::TFloat AS Sum_ReturnIn_weight
            , COALESCE (tmp.PercentRetBonus_diff_weight,tmpR.PercentRetBonus_diff_weight) ::TFloat AS PercentRetBonus_diff_weight
            
            , COALESCE (tmp.BonusKindId,tmpR.BonusKindId)     AS BonusKindId
            , COALESCE (tmp.BonusKindName,tmpR.BonusKindName) AS BonusKindName

            , COALESCE (tmp.InfoMoneyId_master,tmpR.InfoMoneyId_master)        AS InfoMoneyId_master
            , COALESCE (tmp.InfoMoneyId_child,tmpR.InfoMoneyId_child)          AS InfoMoneyId_child
            , COALESCE (tmp.InfoMoneyId_find,tmpR.InfoMoneyId_find)            AS InfoMoneyId_find
            
            , COALESCE (tmp.InfoMoneyName_master,tmpR.InfoMoneyName_master)        AS InfoMoneyName_master
            , COALESCE (tmp.InfoMoneyName_child,tmpR.InfoMoneyName_child)          AS InfoMoneyName_child
            , COALESCE (tmp.InfoMoneyName_find,tmpR.InfoMoneyName_find) ::TVarChar AS InfoMoneyName_find
            
            , COALESCE (tmp.PaidKindId,tmpR.PaidKindId)             AS PaidKindId
            , COALESCE (tmp.PaidKindName,tmpR.PaidKindName)         AS PaidKindName
            , COALESCE (tmp.PaidKindId_Child,tmpR.PaidKindId_Child)     AS PaidKindId_Child
            , COALESCE (tmp.PaidKindName_Child,tmpR.PaidKindName_Child) AS PaidKindName_Child
            
            , COALESCE (tmp.RetailName,tmpR.RetailName)       As RetailName
            , COALESCE (tmp.PersonalId,tmpR.PersonalId)       AS PersonalId
            , COALESCE (tmp.PersonalCode,tmpR.PersonalCode)   AS PersonalCode
            , COALESCE (tmp.PersonalName,tmpR.PersonalName)   AS PersonalName  --супервайзер
            
            , COALESCE (tmp.PersonalTradeId,tmpR.PersonalTradeId)       AS PersonalTradeId
            , COALESCE (tmp.PersonalTradeCode,tmpR.PersonalTradeCode)   AS PersonalTradeCode
            , COALESCE (tmp.PersonalTradeName,tmpR.PersonalTradeName)   AS PersonalTradeName
            
            , COALESCE (tmp.PartnerId,tmpR.PartnerId)     AS PartnerId
            , COALESCE (tmp.PartnerName,tmpR.PartnerName) AS PartnerName

            , COALESCE (tmp.AreaId,tmpR.AreaId)           AS AreaId
            , COALESCE (tmp.AreaName,tmpR.AreaName)       AS AreaName
            
            , COALESCE (tmp.Sum_CheckBonus, tmpR.Sum_CheckBonus)           ::TFloat AS Sum_CheckBonus
            , COALESCE (tmp.Sum_SaleReturnIn, tmpR.Sum_SaleReturnIn)       ::TFloat AS Sum_SaleReturnIn
            , COALESCE (tmp.Sum_Account, tmpR.Sum_Account)                 ::TFloat AS Sum_Account
            , COALESCE (tmp.Sum_AccountSendDebt, tmpR.Sum_AccountSendDebt) ::TFloat AS Sum_AccountSendDebt
            , COALESCE (tmp.Sum_Bonus, tmpR.Sum_Bonus)                     ::TFloat AS Sum_Bonus
            , COALESCE (tmp.Sum_BonusFact, tmpR.Sum_BonusFact)             ::TFloat AS Sum_BonusFact

            , COALESCE (tmp.AmountKg, tmpR.AmountKg)                       ::TFloat AS AmountKg
            , COALESCE (tmp.AmountSh, tmpR.AmountSh)                       ::TFloat AS AmountSh
            , COALESCE (tmp.PartKg, tmpR.PartKg)                           ::TFloat AS PartKg
            
            , COALESCE (tmp.Comment,tmpR.Comment)                        ::TVarChar AS Comment
            , COALESCE (tmp.isSalePart, tmpR.isSalePart)                 ::Boolean  AS isSalePart --Долевая продажа
            
       FROM tmpMovementAll AS tmp
          FULL JOIN tmpReportAll AS tmpR ON tmpR.ContractStateKindId_Child = tmp.ContractStateKindId_Child
                                        AND tmpR.ContractId_Master = tmp.ContractId_Master
                                        AND tmpR.JuridicalId = tmp.JuridicalId
                                        AND tmpR.Value = tmp.Value
                                        AND COALESCE (tmpR.PersonalTradeId,0) = COALESCE (tmp.PersonalTradeId,0)
                                        AND COALESCE (tmpR.PersonalId,0) = COALESCE (tmp.PersonalId,0)
                                        AND COALESCE (tmpR.PaidKindId_Child,0) = COALESCE (tmp.PaidKindId_Child,0)
                                        AND COALESCE (tmpR.Sum_CheckBonus,0) = COALESCE (tmp.Sum_CheckBonus,0)
                                        AND COALESCE (tmpR.PercentRetBonus,0) = COALESCE (tmp.PercentRetBonus,0)
                                        AND COALESCE (tmpR.PartKg,0) = COALESCE (tmp.PartKg,0)

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
--
--select * from gpSelect_Movement_ProfitLossService_ByReport(inStartDate := ('01.04.2021')::TDateTime , inEndDate := ('03.04.2021')::TDateTime , inOperDate := ('01.01.2021')::TDateTime , inBonusKindId := 0 , inPaidKindId := 0 , inJuridicalId := 0 , inBranchId := 0 , inMemberId := 0 , inisReport := 'false' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');