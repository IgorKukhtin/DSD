

-- FunctiON: gpReport_CheckBonus_Income ()

DROP FUNCTION IF EXISTS gpReport_CheckBonus_Income (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonus_Income (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inPaidKindID          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   ,
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_Movement TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
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
             , RetailName TVarChar
             , PersonalCode Integer, PersonalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Value TFloat
             , PercentRetBonus TFloat
             , PercentRetBonus_fact TFloat
             , Sum_CheckBonus TFloat
             , Sum_CheckBonusFact TFloat
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
             , Sum_IncomeFact TFloat
             , Sum_Account TFloat
             , Sum_IncomeReturnOut TFloat
             , Amount_in TFloat
             , Amount_out TFloat
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE inIsMovement  Boolean ; -- по документам
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!Только просмотр Аудитор!!!
   PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


   inisMovement:= FALSE;

    RETURN QUERY
      SELECT  tmp.OperDate_Movement
            , tmp.InvNumber_Movement
            , tmp.DescName_Movement
            , tmp.ContractId_master
            , tmp.ContractId_child
            , tmp.ContractId_find
            , tmp.InvNumber_master       ::TVarChar
            , tmp.InvNumber_child        ::TVarChar
            , tmp.InvNumber_find         ::TVarChar
            , tmp.ContractTagName_child  ::TVarChar
            , tmp.ContractStateKindCode_child
            , tmp.InfoMoneyId_master
            , tmp.InfoMoneyId_find
            , tmp.InfoMoneyName_master
            , tmp.InfoMoneyName_child
            , tmp.InfoMoneyName_find
            , tmp.JuridicalId
            , tmp.JuridicalName
            , tmp.PaidKindId
            , tmp.PaidKindName
            , tmp.PaidKindName_Child
            , tmp.ConditionKindId
            , tmp.ConditionKindName
            , tmp.BonusKindId
            , tmp.BonusKindName
            , tmp.BranchId
            , tmp.BranchName
            , tmp.RetailName
            , tmp.PersonalCode
            , tmp.PersonalName
            , tmp.PartnerId
            , tmp.PartnerName
            , tmp.Value
            , tmp.PercentRetBonus
            , tmp.PercentRetBonus_fact
            , tmp.Sum_CheckBonus
            , tmp.Sum_CheckBonusFact
            , tmp.Sum_Bonus
            , tmp.Sum_BonusFact
            , tmp.Sum_IncomeFact
            , tmp.Sum_Account
            , tmp.Sum_IncomeReturnOut
            , tmp.Amount_in
            , tmp.Amount_out
            , tmp.Comment
      FROM lpReport_CheckBonus_Income (inStartDate           := inStartDate
                                     , inEndDate             := inEndDate
                                     , inPaidKindID          := zc_Enum_PaidKind_FirstForm()
                                     , inJuridicalId         := inJuridicalId
                                     , inBranchId            := inBranchId
                                     , inSession             := inSession
                                      ) AS tmp
      WHERE (inPaidKindId = zc_Enum_PaidKind_FirstForm() OR COALESCE (inPaidKindId, 0) = 0)
  UNION ALL
      SELECT  tmp.OperDate_Movement
            , tmp.InvNumber_Movement
            , tmp.DescName_Movement
            , tmp.ContractId_master
            , tmp.ContractId_child
            , tmp.ContractId_find
            , tmp.InvNumber_master       ::TVarChar
            , tmp.InvNumber_child        ::TVarChar
            , tmp.InvNumber_find         ::TVarChar
            , tmp.ContractTagName_child  ::TVarChar
            , tmp.ContractStateKindCode_child
            , tmp.InfoMoneyId_master
            , tmp.InfoMoneyId_find
            , tmp.InfoMoneyName_master
            , tmp.InfoMoneyName_child
            , tmp.InfoMoneyName_find
            , tmp.JuridicalId
            , tmp.JuridicalName
            , tmp.PaidKindId
            , tmp.PaidKindName
            , tmp.PaidKindName_Child
            , tmp.ConditionKindId
            , tmp.ConditionKindName
            , tmp.BonusKindId
            , tmp.BonusKindName
            , tmp.BranchId
            , tmp.BranchName
            , tmp.RetailName
            , tmp.PersonalCode
            , tmp.PersonalName
            , tmp.PartnerId
            , tmp.PartnerName
            , tmp.Value
            , tmp.PercentRetBonus
            , tmp.PercentRetBonus_fact
            , tmp.Sum_CheckBonus
            , tmp.Sum_CheckBonusFact
            , tmp.Sum_Bonus
            , tmp.Sum_BonusFact
            , tmp.Sum_IncomeFact
            , tmp.Sum_Account
            , tmp.Sum_IncomeReturnOut
            , tmp.Amount_in
            , tmp.Amount_out
            , tmp.Comment
      FROM lpReport_CheckBonus_Income (inStartDate           := inStartDate
                                     , inEndDate             := inEndDate
                                     , inPaidKindID          := zc_Enum_PaidKind_SecondForm()
                                     , inJuridicalId         := inJuridicalId
                                     , inBranchId            := inBranchId
                                     , inSession             := inSession
                                      ) AS tmp
      WHERE (inPaidKindId = zc_Enum_PaidKind_SecondForm() OR COALESCE (inPaidKindId, 0) = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.20         * gpReport_CheckBonus_Income
*/

-- тест
-- select * from gpReport_CheckBonus_Income (inStartDate:= '15.03.2016', inEndDate:= '15.03.2016', inPaidKindID:= zc_Enum_PaidKind_FirstForm(), inJuridicalId:= 0, inBranchId:= 0, inSession:= zfCalc_UserAdmin());
-- select * from gpReport_CheckBonus_Income(inStartDate := ('28.05.2020')::TDateTime , inEndDate := ('28.05.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 344240 , inBranchId := 0 ,  inSession := '5');--
-- select * from gpReport_CheckBonus_Income(inStartDate := ('01.05.2020')::TDateTime , inEndDate := ('30.06.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 3834632 , inBranchId := 0 ,  inSession := '5');

--select * from gpReport_CheckBonus_Income(inStartDate := ('01.12.2020')::TDateTime , inEndDate := ('31.12.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 473873 , inBranchId := 0 ,  inSession := '5');