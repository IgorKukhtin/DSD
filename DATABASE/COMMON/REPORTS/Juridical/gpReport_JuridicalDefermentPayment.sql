 -- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPayment(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountId Integer, AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, RetailName TVarChar, RetailName_main TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , SectionId Integer, SectionName TVarChar
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
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
             , BranchName_personal       TVarChar
             , BranchName_personal_trade TVarChar
             , PaymentDate TDateTime, PaymentAmount TFloat
             , PaymentDate_jur TDateTime, PaymentAmount_jur TFloat
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


     if vbUserId <> 5 AND 1=0
     then
         RAISE EXCEPTION 'Ошибка.Отчет веремнно отключен. Повторите действие через 30 мин.';
     end if;

/*IF inPaidKindId = 0 and vbUserId <> 5
THEN
    RAISE EXCEPTION 'Ошибка.Необходимо выбрать <Форма оплаты>.';
END IF;*/



     -- Результат
     RETURN QUERY
     WITH
     tmpReport AS (SELECT tmpReport.AccountId, tmpReport.AccountName
                        , tmpReport.JuridicalId, tmpReport.JuridicalName, tmpReport.RetailName, tmpReport.RetailName_main, tmpReport.OKPO, tmpReport.JuridicalGroupName
                        , tmpReport.SectionId, tmpReport.SectionName
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
    -- выбираем последнии оплаты
   , tmpLastPayment_all AS (SELECT tt.JuridicalId
                                 , tt.ContractId
                                 , tt.PaidKindId
                                 , COALESCE (tt.PartnerId, 0) AS PartnerId
                                 , tt.OperDate
                                 , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                 , tt.Amount
                            FROM gpSelect_Object_JuridicalDefermentPayment(inSession) AS tt
                                 JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                 ON ObjectLink_Contract_InfoMoney.ObjectId = tt.ContractId
                                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                           )
     -- находим последнии оплаты
   , tmpLastPayment AS (SELECT tt.JuridicalId
                             , tt.PaidKindId
                             , tt.InfoMoneyId
                             , tt.OperDate
                             , SUM (tt.Amount) AS Amount
                        FROM tmpLastPayment_all AS tt
                        GROUP BY tt.JuridicalId
                               , tt.PaidKindId
                               , tt.InfoMoneyId
                               , tt.OperDate
                       )

   ---
   SELECT tmpReport.*
        , tmpLastPayment.OperDate :: TDateTime AS PaymentDate
        , tmpLastPayment.Amount   :: TFloat    AS PaymentAmount
        
        , tmpLastPaymentJuridical.OperDate :: TDateTime AS PaymentDate_jur
        , tmpLastPaymentJuridical.Amount   :: TFloat    AS PaymentAmount_jur
        
   FROM tmpReport
        LEFT JOIN tmpLastPayment_all AS tmpLastPayment
                                     ON tmpLastPayment.JuridicalId = tmpReport.JuridicalId
                                    AND tmpLastPayment.ContractId  = tmpReport.ContractId
                                    AND tmpLastPayment.PaidKindId  = tmpReport.PaidKindId
                                    AND tmpLastPayment.PartnerId   = COALESCE (tmpReport.PartnerId,0)

        LEFT JOIN (SELECT tmpLastPayment.JuridicalId
                        , tmpLastPayment.InfoMoneyId
                        , tmpLastPayment.PaidKindId
                        , tmpLastPayment.OperDate
                        , tmpLastPayment.Amount
                        , ROW_NUMBER() OVER(PARTITION BY tmpLastPayment.JuridicalId, tmpLastPayment.PaidKindId, tmpLastPayment.InfoMoneyId ORDER BY tmpLastPayment.OperDate DESC) AS Ord
                   FROM tmpLastPayment
                  ) AS tmpLastPaymentJuridical
                    ON tmpLastPaymentJuridical.JuridicalId = tmpReport.JuridicalId
                   AND tmpLastPaymentJuridical.PaidKindId  = tmpReport.PaidKindId
                   AND tmpLastPaymentJuridical.InfoMoneyId = tmpReport.InfoMoneyId
                   AND tmpLastPaymentJuridical.Ord = 1
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.22         * add Section
 12.11.21         *
 05.07.21         * add lp + inStartDate_sale, inEndDate_sale
 13.09.14                                        * add inJuridicalGroupId
 07.09.14                                        * add Branch...
 24.08.14                                        * add Partner...
 11.07.14                                        * add RetailName
 05.07.14                                        * add zc_Movement_TransferDebtOut
 02.06.14                                        * change DefermentPaymentRemains
 20.05.14                                        * add Object_Contract_View
 12.05.14                                        * add RESULT.DelayCreditLimit
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 15.04.14                                        * add StartDate and EndDate
 10.04.14                                        * add AreaName
 09.04.14                                        * add !!!
 31.03.14                                        * add Object_Contract_View and Object_InfoMoney_View and ObjectHistory_JuridicalDetails_View and Object_PaidKind
 30.03.14                          * 
 06.02.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPayment (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(),  inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_JuridicalDefermentPayment (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());

--select * from gpReport_JuridicalDefermentPayment(inOperDate := ('19.12.2023')::TDateTime , inEmptyParam := ('01.05.2033')::TDateTime , inAccountId := 9128 , inPaidKindId := 3 , inBranchId := 0 , inJuridicalGroupId := 0 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e')
--where JuridicalId = 14866