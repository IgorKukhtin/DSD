 -- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPayment(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inSession          TVarChar    -- ������ ������������
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
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
     WITH
     tmpReport AS (SELECT tmpReport.*
                   FROM lpReport_JuridicalDefermentPayment (inOperDate         := inOperDate
                                                          , inEmptyParam       := inEmptyParam
                                                          , inStartDate_sale   := CASE WHEN DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 DAY') <> DATE_TRUNC ('MONTH', inOperDate) 
                                                                                                 -- ����� ����� ��������� ���� ���, ����� ���. �����
                                                                                                 THEN DATE_TRUNC ('MONTH', inOperDate)
                                                                                                 -- ����� ������� �����
                                                                                                 ELSE DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 MONTH'
                                                                                            END
                                                          , inEndDate_sale     := CASE WHEN DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 DAY') <> DATE_TRUNC ('MONTH', inOperDate) 
                                                                                                 -- ����� ����� ��������� ���� ���, ����� ���. �����
                                                                                                 THEN inOperDate
                                                                                                 -- ����� ������� �����
                                                                                                 ELSE DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY'
                                                                                            END
                                                          , inAccountId        := inAccountId
                                                          , inPaidKindId       := inPaidKindId
                                                          , inBranchId         := inBranchId
                                                          , inJuridicalGroupId := inJuridicalGroupId
                                                          , inUserId           := vbUserId
                                                           ) AS tmpReport
                   )
   --������� ��������� ������
   , tmpLastPayment AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , Container.ObjectId     AS AccountId
                                   , (-1 * MIContainer.Amount) AS Amount
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount < 0
                       
                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpReport.JuridicalId, tmpReport.ContractId, tmpReport.AccountId
                                               FROM tmpReport) AS tmpReport 
                                                               ON tmpReport.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpReport.ContractId = CLO_Contract.ObjectId 
                       
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.AccountId
                        )
   ---
   SELECT tmpReport.*
        , tmpLastPayment.OperDate :: TDateTime AS PaymentDate
        , tmpLastPayment.Amount   :: TFloat    AS PaymentAmount
   FROM tmpReport
        LEFT JOIN tmpLastPayment ON tmpLastPayment.JuridicalId = tmpReport.JuridicalId
                                AND tmpLastPayment.ContractId = tmpReport.ContractId
                                AND tmpLastPayment.AccountId = tmpReport.AccountId
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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

-- ����
-- SELECT * FROM gpReport_JuridicalDefermentPayment (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(),  inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_JuridicalDefermentPayment (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
