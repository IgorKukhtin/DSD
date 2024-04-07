-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalSold(
    IN inStartDate                TDateTime , -- 
    IN inEndDate                  TDateTime , --
    IN inAccountId                Integer,    -- Счет  
    IN inInfoMoneyId              Integer,    -- Управленческая статья  
    IN inInfoMoneyGroupId         Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inPaidKindId               Integer   , --
    IN inBranchId                 Integer   , --
    IN inJuridicalGroupId         Integer   , --
    IN inCurrencyId               Integer   , -- Валюта
    IN inIsPartionMovement        Boolean   ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar, INN TVarChar, JuridicalGroupName TVarChar
             , RetailName TVarChar, RetailReportName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , JuridicalPartnerlName TVarChar
             , BranchCode Integer, BranchName TVarChar, BranchName_personal TVarChar, BranchName_personal_trade TVarChar
             , ContractCode Integer, ContractNumber TVarChar
             , ContractTagGroupName TVarChar, ContractTagName TVarChar, ContractStateKindCode Integer
             , ContractJuridicalDocId Integer, ContractJuridicalDocCode Integer, ContractJuridicalDocName TVarChar
             , PersonalName TVarChar, PersonalTradeName TVarChar, PersonalCollationName TVarChar, PersonalTradeName_Partner TVarChar, PersonalSigningName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , PaidKindName TVarChar, AccountName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
             , CurrencyName TVarChar
             , ContractConditionKindName TVarChar, ContractConditionValue TFloat
             , PartionMovementName TVarChar
             , PaymentDate TDateTime
             , AccountId Integer, JuridicalId Integer, PartnerId Integer, InfoMoneyId Integer, ContractId Integer, PaidKindId Integer, BranchId Integer
             , StartAmount_A TFloat, StartAmount_P TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , IncomeSumm TFloat, ReturnOutSumm TFloat, SaleSumm TFloat, SaleRealSumm TFloat, SaleSumm_10300 TFloat, SaleRealSumm_total TFloat, ReturnInSumm TFloat, ReturnInRealSumm TFloat, ReturnInSumm_10300 TFloat, ReturnInRealSumm_total TFloat
             , PriceCorrectiveSumm TFloat, ChangePercentSumm TFloat
             , MoneySumm TFloat, ServiceSumm TFloat, ServiceRealSumm TFloat, TransferDebtSumm TFloat, SendDebtSumm TFloat, ChangeCurrencySumm TFloat, OtherSumm TFloat
             , EndAmount_A TFloat, EndAmount_P TFloat, EndAmount_D TFloat, EndAmount_K TFloat

             , StartAmount_Currency_A TFloat, StartAmount_Currency_P TFloat, StartAmount_Currency_D TFloat, StartAmount_Currency_K TFloat
             , DebetSumm_Currency TFloat, KreditSumm_Currency TFloat
             , IncomeSumm_Currency TFloat, ReturnOutSumm_Currency TFloat
             , SaleSumm_Currency TFloat, SaleRealSumm_Currency TFloat, SaleSumm_10300_Currency TFloat, SaleRealSumm_Currency_total TFloat
             , ReturnInSumm_Currency TFloat, ReturnInRealSumm_Currency TFloat, ReturnInSumm_10300_Currency TFloat, ReturnInRealSumm_Currency_total TFloat
             , PriceCorrectiveSumm_Currency TFloat, ChangePercentSumm_Currency TFloat
             , MoneySumm_Currency TFloat, ServiceSumm_Currency TFloat, ServiceRealSumm_Currency TFloat
             , TransferDebtSumm_Currency TFloat, SendDebtSumm_Currency TFloat, ChangeCurrencySumm_Currency TFloat, OtherSumm_Currency TFloat
             , EndAmount_Currency_A TFloat, EndAmount_Currency_P TFloat, EndAmount_Currency_D TFloat, EndAmount_Currency_K TFloat
             , PartnerTagName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     RETURN QUERY
     SELECT tmpReport.*
     FROM lpReport_JuridicalSold (inStartDate              := inStartDate
                                , inEndDate                := inEndDate
                                , inStartDate_sale         := CASE WHEN inStartDate = inEndDate OR EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM inEndDate) THEN DATE_TRUNC ('MONTH', inStartDate) - INTERVAL '1 MONTH' ELSE inStartDate END
                                , inEndDate_sale           := CASE WHEN inStartDate = inEndDate OR EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM inEndDate) THEN DATE_TRUNC ('MONTH', inStartDate) - INTERVAL '1 DAY'   ELSE inEndDate   END
                                , inAccountId              := inAccountId
                                , inInfoMoneyId            := inInfoMoneyId
                                , inInfoMoneyGroupId       := inInfoMoneyGroupId
                                , inInfoMoneyDestinationId := inInfoMoneyDestinationId
                                , inPaidKindId             := inPaidKindId
                                , inBranchId               := inBranchId
                                , inJuridicalGroupId       := inJuridicalGroupId
                                , inCurrencyId             := inCurrencyId
                                , inIsPartionMovement      := inIsPartionMovement
                                , inUserId                 := vbUserId
                                 ) AS tmpReport
                              ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.20         * add Currency
 29.08.15         * add inIsPartionMovement
 14.11.14         * add inCurrencyId
 10.10.14                                        * add tmpContractCondition
 13.09.14                                        * add inJuridicalGroupId
 13.09.14                                        * add PersonalTradeName
 07.09.14                                        * add Branch...
 07.09.14                                        * ??? как без GROUP BY Container.Amount ???
 24.08.14                                        * add Partner...
 20.05.14                                        * add Object_Contract_View
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 15.04.14                                        * add StartDate and EndDate
 10.04.14                                        * add AreaName
 10.03.14                                        * add zc_Movement_ProfitLossService
 13.02.14                                        * add OKPO and ContractCode
 30.01.14                                        * 
 15.01.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalSold (inStartDate:= '01.01.2016', inEndDate:= '01.01.2016', inAccountId:= null, inInfoMoneyId:= null, inInfoMoneyGroupId:= null, inInfoMoneyDestinationId:= null, inPaidKindId:= null, inBranchId:= null, inJuridicalGroupId:= null, inCurrencyId:= null, inIsPartionMovement:= FALSE, inSession:= zfCalc_UserAdmin()); 
--select * from gpReport_JuridicalSold(inStartDate := ('13.01.2022')::TDateTime , inEndDate := ('13.01.2022')::TDateTime , inAccountId := 0 , inInfoMoneyId := 0 , inInfoMoneyGroupId := 0 , inInfoMoneyDestinationId := 0 , inPaidKindId := 0 , inBranchId := 0 , inJuridicalGroupId := 257169 , inCurrencyId := 76965 , inIsPartionMovement := 'False' ,  inSession := '5');
