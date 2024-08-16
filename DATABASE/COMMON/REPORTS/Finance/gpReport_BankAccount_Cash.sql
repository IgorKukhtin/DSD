-- Function: gpReport_BankAccount_Cash

DROP FUNCTION IF EXISTS gpReport_BankAccount_Cash (TDateTime, TDateTime, Integer, Integer, Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_BankAccount_Cash(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inBankAccountId    Integer,    -- Счет банк
    IN inCurrencyId       Integer   , -- Валюта
    IN inCashId           Integer,    -- касса
    IN inIsDetail         Boolean   , -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, BankName TVarChar, BankAccountName TVarChar, JuridicalName TVarChar
             , CurrencyName_BankAccount TVarChar, CurrencyName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , MoneyPlaceName TVarChar, ItemName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar
             , ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat

             , StartAmount_Currency TFloat, StartAmountD_Currency TFloat, StartAmountK_Currency TFloat
             , DebetSumm_Currency TFloat, KreditSumm_Currency TFloat
             , EndAmount_Currency TFloat, EndAmountD_Currency TFloat, EndAmountK_Currency TFloat
             , Summ_Currency TFloat, Summ_Currency_pl TFloat
             
             , GroupId Integer, GroupName TVarChar
             , CashName TVarChar
             , Comment TVarChar
             , OperDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
  RETURN QUERY
     WITH tmpReport_BankAccount AS (SELECT * FROM gpReport_BankAccount (inStartDate       := inStartDate
                                                                       , inEndDate        := inEndDate
                                                                       , inAccountId      := inAccountId
                                                                       , inJuridicalBasisId := 0
                                                                       , inBankAccountId  := inBankAccountId
                                                                       , inCurrencyId     := inCurrencyId
                                                                       , inIsDetail       := inIsDetail
                                                                       , inSession        := inSession
                                                                                          ) AS gpReport)
        , tmpReport_Cash AS (SELECT * FROM gpReport_Cash (inStartDate    := inStartDate
                                                        , inEndDate      := inEndDate
                                                        , inAccountId    := inAccountId
                                                        , inCashId       := inCashId
                                                        , inCurrencyId   := 0
                                                        , inisDate       := CASE WHEN vbUserId IN (5, 6604558) THEN TRUE ELSE FALSE END
                                                        , inSession      := inSession
                                                                         ) AS gpReport)
        , tmpResult AS (SELECT tmpReport_BankAccount.ContainerId 
                             , tmpReport_BankAccount.BankName , tmpReport_BankAccount.BankAccountName, tmpReport_BankAccount.JuridicalName 
                             , tmpReport_BankAccount.CurrencyName_BankAccount, tmpReport_BankAccount.CurrencyName

                             , tmpReport_BankAccount.InfoMoneyGroupName , tmpReport_BankAccount.InfoMoneyDestinationName , tmpReport_BankAccount.InfoMoneyCode 
                             , tmpReport_BankAccount.InfoMoneyName , tmpReport_BankAccount.InfoMoneyName_all 
                             , tmpReport_BankAccount.AccountName 
                             , tmpReport_BankAccount.MoneyPlaceName , tmpReport_BankAccount.ItemName 
                             , tmpReport_BankAccount.ContractCode , tmpReport_BankAccount.ContractInvNumber , tmpReport_BankAccount.ContractTagName 
                             , tmpReport_BankAccount.UnitCode , tmpReport_BankAccount.UnitName 
                             , tmpReport_BankAccount.ProfitLossGroupCode , tmpReport_BankAccount.ProfitLossGroupName 
                             , tmpReport_BankAccount.ProfitLossDirectionCode , tmpReport_BankAccount.ProfitLossDirectionName 
                             , tmpReport_BankAccount.StartAmount , tmpReport_BankAccount.StartAmountD , tmpReport_BankAccount.StartAmountK 
                             , tmpReport_BankAccount.DebetSumm , tmpReport_BankAccount.KreditSumm 
                             , tmpReport_BankAccount.EndAmount , tmpReport_BankAccount.EndAmountD , tmpReport_BankAccount.EndAmountK 
                             , tmpReport_BankAccount.GroupId , tmpReport_BankAccount.GroupName 
                             , tmpReport_BankAccount.CashName
                             , tmpReport_BankAccount.Comment 

             , tmpReport_BankAccount.StartAmount_Currency, tmpReport_BankAccount.StartAmountD_Currency, tmpReport_BankAccount.StartAmountK_Currency
             , tmpReport_BankAccount.DebetSumm_Currency, tmpReport_BankAccount.KreditSumm_Currency
             , tmpReport_BankAccount.EndAmount_Currency, tmpReport_BankAccount.EndAmountD_Currency, tmpReport_BankAccount.EndAmountK_Currency
             , tmpReport_BankAccount.Summ_Currency, tmpReport_BankAccount.Summ_pl AS Summ_Currency_pl
             , tmpReport_BankAccount.OperDate
             
                        FROM tmpReport_BankAccount 
                       UNION ALL
                        SELECT tmpReport_Cash.ContainerId 
                             , '' AS BankName, tmpReport_Cash.CashName AS BankAccountName
                             , '' AS JuridicalName
                             , '' AS CurrencyName_BankAccount, '' AS CurrencyName
                             , tmpReport_Cash.InfoMoneyGroupName , tmpReport_Cash.InfoMoneyDestinationName , tmpReport_Cash.InfoMoneyCode 
                             , tmpReport_Cash.InfoMoneyName , tmpReport_Cash.InfoMoneyName_all 
                             , tmpReport_Cash.AccountName 
                             , tmpReport_Cash.MoneyPlaceName , tmpReport_Cash.ItemName 
                             , tmpReport_Cash.ContractCode , tmpReport_Cash.ContractInvNumber , tmpReport_Cash.ContractTagName 
                             , tmpReport_Cash.UnitCode , tmpReport_Cash.UnitName 
                             , tmpReport_Cash.ProfitLossGroupCode , tmpReport_Cash.ProfitLossGroupName 
                             , tmpReport_Cash.ProfitLossDirectionCode , tmpReport_Cash.ProfitLossDirectionName 
                             , tmpReport_Cash.StartAmount , tmpReport_Cash.StartAmountD , tmpReport_Cash.StartAmountK 
                             , tmpReport_Cash.DebetSumm , tmpReport_Cash.KreditSumm 
                             , tmpReport_Cash.EndAmount , tmpReport_Cash.EndAmountD , tmpReport_Cash.EndAmountK 
                            , tmpReport_Cash.GroupId , tmpReport_Cash.GroupName 
                             , tmpReport_Cash.CashName
                            , tmpReport_Cash.Comment 
             , tmpReport_Cash.StartAmount_Currency, tmpReport_Cash.StartAmountD_Currency, tmpReport_Cash.StartAmountK_Currency
             , tmpReport_Cash.DebetSumm_Currency, tmpReport_Cash.KreditSumm_Currency
             , tmpReport_Cash.EndAmount_Currency, tmpReport_Cash.EndAmountD_Currency, tmpReport_Cash.EndAmountK_Currency
             , tmpReport_Cash.Summ_Currency, tmpReport_Cash.Summ_Currency_pl

             , tmpReport_Cash.OperDate

                        FROM tmpReport_Cash
         )

        ----
        SELECT tmpResult.ContainerId 
             , tmpResult.BankName                 :: TVarChar
             , tmpResult.BankAccountName          :: TVarChar 
             , tmpResult.JuridicalName            :: TVarChar
             , tmpResult.CurrencyName_BankAccount :: TVarChar 
             , tmpResult.CurrencyName :: TVarChar
             , tmpResult.InfoMoneyGroupName 
             , tmpResult.InfoMoneyDestinationName 
             , tmpResult.InfoMoneyCode
             , tmpResult.InfoMoneyName 
             , tmpResult.InfoMoneyName_all 
             , tmpResult.AccountName 
             , tmpResult.MoneyPlaceName 
             , tmpResult.ItemName 
             , tmpResult.ContractCode  
             , tmpResult.ContractInvNumber
             , tmpResult.ContractTagName 
             , tmpResult.UnitCode 
             , tmpResult.UnitName 
             , tmpResult.ProfitLossGroupCode 
             , tmpResult.ProfitLossGroupName 
             , tmpResult.ProfitLossDirectionCode 
             , tmpResult.ProfitLossDirectionName 
             , tmpResult.StartAmount 
             , tmpResult.StartAmountD 
             , tmpResult.StartAmountK 
             , tmpResult.DebetSumm 
             , tmpResult.KreditSumm 
             , tmpResult.EndAmount
             , tmpResult.EndAmountD 
             , tmpResult.EndAmountK 

             , tmpResult.StartAmount_Currency, tmpResult.StartAmountD_Currency, tmpResult.StartAmountK_Currency
             , tmpResult.DebetSumm_Currency, tmpResult.KreditSumm_Currency
             , tmpResult.EndAmount_Currency, tmpResult.EndAmountD_Currency, tmpResult.EndAmountK_Currency
             , tmpResult.Summ_Currency, tmpResult.Summ_Currency_pl
             
             , tmpResult.GroupId
             , tmpResult.GroupName 
             , tmpResult.CashName
             , tmpResult.Comment 
             , CASE WHEN tmpResult.OperDate = zc_DateStart() THEN NULL ELSE tmpResult.OperDate END :: TDateTime AS OperDate
        FROM tmpResult
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.07.24         *
 30.08.15         * 
*/

-- тест
-- SELECT * FROM gpReport_BankAccount_Cash (inStartDate:= '01.09.2024', inEndDate:= '01.09.2024', inAccountId:= 0, inBankAccountId:=0, inCurrencyId:= 0, inCashId:= 0, inIsDetail:= TRUE, inSession:= zfCalc_UserAdmin());
