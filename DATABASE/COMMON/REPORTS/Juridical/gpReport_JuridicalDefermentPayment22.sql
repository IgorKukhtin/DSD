-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPayment22 (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPayment22(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
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
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
             , BranchName_personal       TVarChar
             , BranchName_personal_trade TVarChar
             , PaymentDate TDateTime
             , PaymentAmount TFloat 
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpReport AS (SELECT tmpReport.*
                   FROM lpReport_JuridicalDefermentPayment (inOperDate         := inOperDate
                                                          , inEmptyParam       := inEmptyParam
                                                          , inStartDate_sale   := CASE WHEN DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 DAY') <> DATE_TRUNC ('MONTH', inOperDate) 
                                                                                                 -- тогда здесь последний день мес, берем тек. месяц
                                                                                                 THEN DATE_TRUNC ('MONTH', inOperDate)
                                                                                                 -- берем прошлый месяц
                                                                                                 ELSE DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 MONTH'
                                                                                            END
                                                          , inEndDate_sale     := CASE WHEN DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 DAY') <> DATE_TRUNC ('MONTH', inOperDate) 
                                                                                                 -- тогда здесь последний день мес, берем тек. месяц
                                                                                                 THEN inOperDate
                                                                                                 -- берем прошлый месяц
                                                                                                 ELSE DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY'
                                                                                            END
                                                          , inAccountId        := inAccountId
                                                          , inPaidKindId       := inPaidKindId
                                                          , inBranchId         := inBranchId
                                                          , inJuridicalGroupId := inJuridicalGroupId
                                                          , inUserId           := vbUserId
                                                           ) AS tmpReport
                   )
   --выбираем последнии оплаты
   , tmpLastPayment AS ( SELECT tt.* FROM gpSelect_Object_JuridicalDefermentPayment(inSession) AS tt)


   ---
   SELECT tmpReport.*
        , tmpLastPayment.OperDate     :: TDateTime AS PaymentDate
        , tmpLastPayment.Amount       :: TFloat    AS PaymentAmount
   FROM tmpReport
        LEFT JOIN tmpLastPayment ON tmpLastPayment.JuridicalId = tmpReport.JuridicalId
                                AND tmpLastPayment.ContractId = tmpReport.ContractId
                                --AND tmpLastPayment.AccountId = tmpReport.AccountId
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
02.12.21         *
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPayment (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(),  inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_JuridicalDefermentPayment22 (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
