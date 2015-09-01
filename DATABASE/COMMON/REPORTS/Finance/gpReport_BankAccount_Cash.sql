-- Function: gpReport_BankAccount_Cash


DROP FUNCTION IF EXISTS gpReport_BankAccount_Cash (TDateTime, TDateTime, Integer, Integer, Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_BankAccount_Cash(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- ����
    IN inBankAccountId    Integer,    -- ���� ����
    IN inCurrencyId       Integer   , -- ������
    IN inCashId           Integer,    -- �����
    IN inIsDetail         Boolean   , -- 
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (ContainerId Integer, BankName TVarChar, BankAccountName TVarChar
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

             , GroupId Integer, GroupName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());

     -- ���������
  RETURN QUERY
     WITH tmpReport_BankAccount AS (SELECT * FROM gpReport_BankAccount (inStartDate       := inStartDate
                                                                       , inEndDate        := inEndDate
                                                                       , inAccountId      := inAccountId
                                                                       , inBankAccountId  := inBankAccountId
                                                                       , inCurrencyId     := inCurrencyId
                                                                       , inIsDetail       := inIsDetail
                                                                       , inSession        := ''
                                                                                          ) AS gpReport)
        , tmpReport_Cash AS (SELECT * FROM gpReport_Cash (inStartDate    := inStartDate
                                                        , inEndDate      := inEndDate
                                                        , inAccountId    := inAccountId
                                                        , inCashId       := inCashId
                                                        , inSession      := ''
                                                                         ) AS gpReport)
        , tmpResult AS (SELECT tmpReport_BankAccount.ContainerId 
                             , tmpReport_BankAccount.BankName , tmpReport_BankAccount.BankAccountName
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
                             , tmpReport_BankAccount.Comment 
                        FROM tmpReport_BankAccount 
                       UNION ALL
                        SELECT tmpReport_Cash.ContainerId 
                             , '' AS BankName, tmpReport_Cash.CashName AS BankAccountName
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
                            , tmpReport_Cash.Comment 
                        FROM tmpReport_Cash
         )
                        SELECT tmpResult.ContainerId 
                             , tmpResult.BankName :: TVarChar
                             , tmpResult.BankAccountName :: TVarChar
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
                             , tmpResult.GroupId
                             , tmpResult.GroupName 
                             , tmpResult.Comment 
                        FROM tmpResult


;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_BankAccount_Cash (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.08.15         * 
*/

-- ����
-- SELECT * FROM gpReport_BankAccount_Cash (inStartDate:= '01.01.2015', inEndDate:= '31.01.2015', inAccountId:= 0, inBankAccountId:=0, inCurrencyId:= 0, inIsDetail:= TRUE, inSession:= zfCalc_UserAdmin());
--select * from gpReport_BankAccount_Cash(inStartDate := ('21.05.2015')::TDateTime , inEndDate := ('21.05.2015')::TDateTime , inAccountId := 0 , inBankAccountId := 0 , inCurrencyId := 0 , inCashId := 0 , inIsDetail := 'True' ,  inSession := '5');