-- FunctiON: gpReport_CheckBonusDetail ()

DROP FUNCTION IF EXISTS gpReport_CheckBonusDetail (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonusDetail (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inPaidKindID          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   , 
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_Movement TDateTime, OperDatePartner TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
             , ContractId_master Integer, ContractId_child Integer, ContractId_find Integer, InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PaidKindName_Child TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , RetailName TVarChar, PersonalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Value TFloat
             , Sum_CheckBonus TFloat
             , Sum_CheckBonusFact TFloat 
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
             , Sum_SaleFact TFloat
             , Sum_SaleReturnIn  TFloat
             , Sum_Account  TFloat
             , PercentRetBonus  TFloat
             , PercentRetBonus_fact  TFloat
             , PercentRetBonus_diff  TFloat
             , Comment TVarChar
             , FromName_Movement          TVarChar
             , ToName_Movement            TVarChar
             , PaidKindName_Movement      TVarChar
             , ContractCode_Movement      TVarChar
             , ContractName_Movement      TVarChar
             , ContractTagName_Movement   TVarChar
             , TotalCount_Movement        TFloat
             , TotalCountPartner_Movement TFloat
             , TotalSumm_Movement         TFloat
              )  
AS
$BODY$
    DECLARE inisMovement Boolean ; -- по документам
    DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- по документам
    inisMovement := TRUE;
    
    RETURN QUERY
      
      SELECT tmp.OperDate_Movement, tmp.OperDatePartner, tmp.InvNumber_Movement, tmp.DescName_Movement
           , tmp.ContractId_master, tmp.ContractId_child, tmp.ContractId_find, tmp.InvNumber_master, tmp.InvNumber_child, tmp.InvNumber_find
           , tmp.ContractTagName_child, tmp.ContractStateKindCode_child
           , tmp.InfoMoneyId_master, tmp.InfoMoneyId_find
           , tmp.InfoMoneyName_master, tmp.InfoMoneyName_child, tmp.InfoMoneyName_find
           , tmp.JuridicalId, tmp.JuridicalName
           , tmp.PaidKindId, tmp.PaidKindName
           , tmp.PaidKindName_Child
           , tmp.ConditionKindId, tmp.ConditionKindName
           , tmp.BonusKindId, tmp.BonusKindName
           , tmp.BranchId, tmp.BranchName
           , tmp.RetailName
           , tmp.PersonalName
           , tmp.PartnerId
           , tmp.PartnerName
           , tmp.Value
           , tmp.Sum_CheckBonus
           , tmp.Sum_CheckBonusFact
           , tmp.Sum_Bonus
           , tmp.Sum_BonusFact
           , tmp.Sum_SaleFact
           , tmp.Sum_SaleReturnIn
           , tmp.Sum_Account
           , tmp.PercentRetBonus
           , tmp.PercentRetBonus_fact
           , tmp.PercentRetBonus_diff
           , tmp.Comment
           , tmp.FromName_Movement
           , tmp.ToName_Movement
           , tmp.PaidKindName_Movement
           , tmp.ContractCode_Movement
           , tmp.ContractName_Movement
           , tmp.ContractTagName_Movement
           , tmp.TotalCount_Movement
           , tmp.TotalCountPartner_Movement
           , tmp.TotalSumm_Movement
      FROM gpReport_CheckBonusTest3 (inStartDate           := inStartDate
                                   , inEndDate             := inEndDate
                                   , inPaidKindID          := zc_Enum_PaidKind_FirstForm()
                                   , inJuridicalId         := inJuridicalId
                                   , inBranchId            := inBranchId
                                   , inIsMovement          := inIsMovement
                                   , inSession             := inSession
                                    ) AS tmp
      WHERE inPaidKindId = zc_Enum_PaidKind_FirstForm() OR COALESCE (inPaidKindId,0) = 0
  UNION ALL
      SELECT tmp.OperDate_Movement, tmp.OperDatePartner, tmp.InvNumber_Movement, tmp.DescName_Movement
           , tmp.ContractId_master, tmp.ContractId_child, tmp.ContractId_find, tmp.InvNumber_master, tmp.InvNumber_child, tmp.InvNumber_find
           , tmp.ContractTagName_child, tmp.ContractStateKindCode_child
           , tmp.InfoMoneyId_master, tmp.InfoMoneyId_find
           , tmp.InfoMoneyName_master, tmp.InfoMoneyName_child, tmp.InfoMoneyName_find
           , tmp.JuridicalId, tmp.JuridicalName
           , tmp.PaidKindId, tmp.PaidKindName
           , tmp.PaidKindName_Child
           , tmp.ConditionKindId, tmp.ConditionKindName
           , tmp.BonusKindId, tmp.BonusKindName
           , tmp.BranchId, tmp.BranchName
           , tmp.RetailName
           , tmp.PersonalName
           , tmp.PartnerId
           , tmp.PartnerName
           , tmp.Value
           , tmp.Sum_CheckBonus
           , tmp.Sum_CheckBonusFact
           , tmp.Sum_Bonus
           , tmp.Sum_BonusFact
           , tmp.Sum_SaleFact
           , tmp.Sum_SaleReturnIn
           , tmp.Sum_Account
           , tmp.PercentRetBonus
           , tmp.PercentRetBonus_fact
           , tmp.PercentRetBonus_diff
           , tmp.Comment
           , tmp.FromName_Movement
           , tmp.ToName_Movement
           , tmp.PaidKindName_Movement
           , tmp.ContractCode_Movement
           , tmp.ContractName_Movement
           , tmp.ContractTagName_Movement
           , tmp.TotalCount_Movement
           , tmp.TotalCountPartner_Movement
           , tmp.TotalSumm_Movement
      FROM gpReport_CheckBonusTest3 (inStartDate           := inStartDate
                                   , inEndDate             := inEndDate
                                   , inPaidKindID          := zc_Enum_PaidKind_SecondForm()
                                   , inJuridicalId         := inJuridicalId
                                   , inBranchId            := inBranchId
                                   , inIsMovement          := inIsMovement
                                   , inSession             := inSession
                                    ) AS tmp
      WHERE inPaidKindId = zc_Enum_PaidKind_SecondForm() OR COALESCE (inPaidKindId,0) = 0
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.10.20         *
*/
