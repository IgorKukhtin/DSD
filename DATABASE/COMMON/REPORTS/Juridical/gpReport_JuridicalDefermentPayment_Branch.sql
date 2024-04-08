-- Function: gpReport_JuridicalDefermentPayment_Branch()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPayment_Branch (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPayment_Branch(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inStartDate_sale   TDateTime , -- 
    IN inEndDate_sale     TDateTime , --
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountId Integer, AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, RetailName TVarChar, RetailName_main TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar
             , ContractTagGroupName TVarChar, ContractTagName TVarChar, ContractStateKindCode Integer
             , ContractJuridicalDocId Integer, ContractJuridicalDocCode Integer, ContractJuridicalDocName TVarChar
             , PersonalName TVarChar
             , PersonalTradeName TVarChar
             , PersonalCollationName TVarChar
             , PersonalTradeName_Partner TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
             , BranchName_personal       TVarChar
             , BranchName_personal_trade TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inOperDate, inOperDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
     SELECT tmpReport.AccountId, tmpReport.AccountName
                        , tmpReport.JuridicalId, tmpReport.JuridicalName, tmpReport.RetailName, tmpReport.RetailName_main, tmpReport.OKPO, tmpReport.JuridicalGroupName
                        , tmpReport.PartnerId, tmpReport.PartnerCode, tmpReport.PartnerName
                        , tmpReport.BranchId, tmpReport.BranchCode, tmpReport.BranchName
                        , tmpReport.PaidKindId, tmpReport.PaidKindName
                        , tmpReport.ContractId, tmpReport.ContractCode, tmpReport.ContractNumber
                        , tmpReport.ContractTagGroupName, tmpReport.ContractTagName, tmpReport.ContractStateKindCode
                        , tmpReport.ContractJuridicalDocId, tmpReport.ContractJuridicalDocCode, tmpReport.ContractJuridicalDocName
                        , tmpReport.PersonalName
                        , tmpReport.PersonalTradeName
                        , tmpReport.PersonalCollationName
                        , tmpReport.PersonalTradeName_Partner
                        , tmpReport.StartDate, tmpReport.EndDate
                        , (tmpReport.DebetRemains) :: TFloat AS DebetRemains, (tmpReport.KreditRemains) :: TFloat AS KreditRemains
                        , (tmpReport.SaleSumm) :: TFloat AS SaleSumm, (tmpReport.DefermentPaymentRemains) :: TFloat AS DefermentPaymentRemains
                        , (tmpReport.SaleSumm1) :: TFloat AS SaleSumm1, (tmpReport.SaleSumm2) :: TFloat AS SaleSumm2, (tmpReport.SaleSumm3) :: TFloat AS SaleSumm3
                        , (tmpReport.SaleSumm4) :: TFloat AS SaleSumm4, (tmpReport.SaleSumm5) :: TFloat AS SaleSumm5
                        , tmpReport.Condition, tmpReport.StartContractDate, (tmpReport.Remains) :: TFloat AS Remains
                        , tmpReport.InfoMoneyGroupName, tmpReport.InfoMoneyDestinationName, tmpReport.InfoMoneyId, tmpReport.InfoMoneyCode, tmpReport.InfoMoneyName
                        , tmpReport.AreaName, tmpReport.AreaName_Partner

                        , tmpReport.BranchName_personal
                        , tmpReport.BranchName_personal_trade

     FROM lpReport_JuridicalDefermentPayment (inOperDate         := inOperDate
                                            , inEmptyParam       := inEmptyParam
                                            , inStartDate_sale   := inStartDate_sale
                                            , inEndDate_sale     := inEndDate_sale
                                            , inAccountId        := inAccountId
                                            , inPaidKindId       := inPaidKindId
                                            , inBranchId         := inBranchId
                                            , inJuridicalGroupId := inJuridicalGroupId
                                            , inUserId           := vbUserId
                                             ) AS tmpReport
                              ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.11.21         *
 05.07.21         *
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPayment_Branch (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inStartDate_sale:= CURRENT_DATE, inEndDate_sale:= CURRENT_DATE, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
