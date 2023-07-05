 -- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentMovement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPaymentMovement(
    IN inOperDate         TDateTime , --
    IN inEmptyParam       TDateTime , --
    IN inAccountId        Integer   , --                           
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inSession          TVarChar    -- ������ ������������
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
             , MovementId      Integer
             , OperDate        TDateTime
             , MovementDescName TVarChar
             , InvNumber       TVarChar
             , Summa_doc       TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpReport')
     THEN
         DELETE FROM tmpReport;
     ELSE
         -- ������� - �������� ������ ��� ������������� ������ �� ���������
         CREATE TEMP TABLE _tmpReport ON COMMIT DROP AS
                      (SELECT tmpReport.*
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
                                                              , inUserId           := -1 * vbUserId
                                                               ) AS tmpReport
                      )

     ;

     END IF;

     -- ���������
     RETURN QUERY
     WITH
     tmpReport AS (SELECT a.AccountId, a.AccountName
                        , a.JuridicalId, a.JuridicalName, a.RetailName, a.RetailName_main, a.OKPO, a.JuridicalGroupName
                        , a.SectionId, a.SectionName
                        , a.PartnerId, a.PartnerCode, a.PartnerName
                        , a.BranchId, a.BranchCode, a.BranchName
                        , a.PaidKindId, a.PaidKindName
                        , a.ContractId, a.ContractCode, a.ContractNumber
                        , a.ContractTagGroupName, a.ContractTagName, a.ContractStateKindCode
                        , a.ContractJuridicalDocId, a.ContractJuridicalDocCode, a.ContractJuridicalDocName
                        , a.PersonalName
                        , a.PersonalTradeName
                        , a.PersonalCollationName
                        , a.PersonalTradeName_Partner
                        , a.StartDate, a.EndDate
                        , SUM (a.DebetRemains) :: TFloat AS DebetRemains, SUM (a.KreditRemains) :: TFloat AS KreditRemains
                        , SUM (a.SaleSumm) :: TFloat AS SaleSumm, SUM (a.DefermentPaymentRemains) :: TFloat AS DefermentPaymentRemains
                        , SUM (a.SaleSumm1) :: TFloat AS SaleSumm1, SUM (a.SaleSumm2) :: TFloat AS SaleSumm2, SUM (a.SaleSumm3) :: TFloat AS SaleSumm3
                        , SUM (a.SaleSumm4) :: TFloat AS SaleSumm4, SUM (a.SaleSumm5) :: TFloat AS SaleSumm5
                        , a.Condition, a.StartContractDate, SUM (a.Remains) :: TFloat AS Remains
                        , a.InfoMoneyGroupName, a.InfoMoneyDestinationName, a.InfoMoneyId, a.InfoMoneyCode, a.InfoMoneyName
                        , a.AreaName, a.AreaName_Partner

                        , a.BranchName_personal
                        , a.BranchName_personal_trade 
                        
                   FROM _tmpReport AS a
                   GROUP BY a.AccountId, a.AccountName
                          , a.JuridicalId, a.JuridicalName, a.RetailName, a.RetailName_main, a.OKPO, a.JuridicalGroupName
                          , a.SectionId, a.SectionName
                          , a.PartnerId, a.PartnerCode, a.PartnerName
                          , a.BranchId, a.BranchCode, a.BranchName
                          , a.PaidKindId, a.PaidKindName
                          , a.ContractId, a.ContractCode, a.ContractNumber
                          , a.ContractTagGroupName, a.ContractTagName, a.ContractStateKindCode
                          , a.ContractJuridicalDocId, a.ContractJuridicalDocCode, a.ContractJuridicalDocName
                          , a.PersonalName
                          , a.PersonalTradeName
                          , a.PersonalCollationName
                          , a.PersonalTradeName_Partner
                          , a.StartDate, a.EndDate
                          , a.Condition, a.StartContractDate
                          , a.InfoMoneyGroupName, a.InfoMoneyDestinationName, a.InfoMoneyId, a.InfoMoneyCode, a.InfoMoneyName
                          , a.AreaName, a.AreaName_Partner

                          , a.BranchName_personal
                          , a.BranchName_personal_trade
                  )
    -- �������� ��������� ������
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
     -- ������� ��������� ������
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
   -- DISTINCT ContainerId + StartContractDate
   , tmpContainer AS (
                      SELECT DISTINCT a.ContainerId
                           , a.StartContractDate
                           , a.JuridicalId
                           , a.PartnerId
                           , a.ContractId
                           , a.PaidKindId 
                      FROM _tmpReport AS a
                      WHERE COALESCE (a.SaleSumm,0) <> 0
                      )
   , tmpContainerData AS (SELECT tmpContainer.JuridicalId
                               , tmpContainer.PartnerId
                               , tmpContainer.ContractId
                               , tmpContainer.PaidKindId
                               , MIContainer.MovementId
                               , MIContainer.MovementDescId
                               , MovementDesc.ItemName AS MovementDescName
                               , Movement.OperDate
                               , Movement.InvNumber
                               , SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                          FROM tmpContainer
                               INNER JOIN MovementItemcontainer AS MIContainer
                                                                ON MIContainer.Id = tmpContainer.ContainerId
                                                               AND MIContainer.DescId = zc_MIContainer_Summ()  
                                                               AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) 
                                                               --AND MIContainer.OperDate BETWEEN tmpContainer.StartContractDate AND inOperDate
                               LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                               LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                          GROUP BY tmpContainer.JuridicalId
                                 , tmpContainer.PartnerId
                                 , tmpContainer.ContractId
                                 , tmpContainer.PaidKindId
                                 , MIContainer.MovementId
                                 , MIContainer.MovementDescId
                                 , Movement.OperDate
                                 , Movement.InvNumber
                                 , MovementDesc.ItemName
                          )
   --
   , tmpData AS (SELECT tmpReport.AccountId, tmpReport.AccountName, tmpReport.JuridicalId, tmpReport.JuridicalName, tmpReport.RetailName, tmpReport.RetailName_main, tmpReport.OKPO, tmpReport.JuridicalGroupName
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
                       , tmpReport.DebetRemains, tmpReport.KreditRemains
                       , tmpReport.SaleSumm, tmpReport.DefermentPaymentRemains
                       , tmpReport.SaleSumm1, tmpReport.SaleSumm2, tmpReport.SaleSumm3, tmpReport.SaleSumm4, tmpReport.SaleSumm5
                       , tmpReport.Condition, tmpReport.StartContractDate, tmpReport.Remains
                       , tmpReport.InfoMoneyGroupName, tmpReport.InfoMoneyDestinationName
                       , tmpReport.InfoMoneyId, tmpReport.InfoMoneyCode, tmpReport.InfoMoneyName
                       , tmpReport.AreaName, tmpReport.AreaName_Partner
                       , tmpReport.BranchName_personal
                       , tmpReport.BranchName_personal_trade

                       , tmpLastPayment.OperDate :: TDateTime AS PaymentDate
                       , tmpLastPayment.Amount   :: TFloat    AS PaymentAmount

                       , tmpLastPaymentJuridical.OperDate :: TDateTime AS PaymentDate_jur
                       , tmpLastPaymentJuridical.Amount   :: TFloat    AS PaymentAmount_jur  
                       
                       , ROW_NUMBER() OVER(PARTITION BY tmpReport.JuridicalId, tmpReport.PaidKindId, tmpReport.ContractId, tmpReport.PartnerId ORDER BY tmpLastPayment.OperDate DESC) AS Ord 
                       , tmpContainerData.MovementId
                       , tmpContainerData.OperDate 
                       , tmpContainerData.MovementDescName
                       , tmpContainerData.InvNumber
                       , tmpContainerData.Amount AS Summa_doc
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

                  LEFT JOIN tmpContainerData ON tmpContainerData.JuridicalId = tmpReport.JuridicalId
                                            AND tmpContainerData.ContractId  = tmpReport.ContractId
                                            AND tmpContainerData.PaidKindId  = tmpReport.PaidKindId
                                            AND COALESCE (tmpContainerData.PartnerId,0) = COALESCE (tmpReport.PartnerId,0)
                 )
   
   ---
   SELECT tmpReport.AccountId, tmpReport.AccountName, tmpReport.JuridicalId, tmpReport.JuridicalName, tmpReport.RetailName, tmpReport.RetailName_main, tmpReport.OKPO, tmpReport.JuridicalGroupName
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
        
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.DebetRemains  ELSE 0 END ::TFloat AS DebetRemains
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.KreditRemains ELSE 0 END ::TFloat AS KreditRemains            
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm      ELSE 0 END ::TFloat AS SaleSumm
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.DefermentPaymentRemains ELSE 0 END ::TFloat AS DefermentPaymentRemains
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm1     ELSE 0 END ::TFloat AS SaleSumm1
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm2     ELSE 0 END ::TFloat AS SaleSumm2
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm3     ELSE 0 END ::TFloat AS SaleSumm3
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm4     ELSE 0 END ::TFloat AS SaleSumm4
        , CASE WHEN tmpReport.Ord = 1 THEN tmpReport.SaleSumm5     ELSE 0 END ::TFloat AS SaleSumm5
        
        , tmpReport.Condition, tmpReport.StartContractDate, tmpReport.Remains
        , tmpReport.InfoMoneyGroupName, tmpReport.InfoMoneyDestinationName
        , tmpReport.InfoMoneyId, tmpReport.InfoMoneyCode, tmpReport.InfoMoneyName
        , tmpReport.AreaName, tmpReport.AreaName_Partner
        , tmpReport.BranchName_personal
        , tmpReport.BranchName_personal_trade

        , tmpReport.PaymentDate        :: TDateTime 
        , tmpReport.PaymentAmount      :: TFloat 
        , tmpReport.PaymentDate_jur    :: TDateTime
        , tmpReport.PaymentAmount_jur  :: TFloat

        , tmpReport.MovementId      ::Integer
        , tmpReport.OperDate        ::TDateTime
        , tmpReport.MovementDescName ::TVarChar
        , tmpReport.InvNumber       ::TVarChar
        , tmpReport.Summa_doc   ::TFloat    ::TFloat
   FROM tmpData AS tmpReport
       
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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

-- ����
--
 --select * from gpReport_JuridicalDefermentPaymentMovement(inOperDate := ('05.07.2023')::TDateTime , inEmptyParam := ('01.05.2013')::TDateTime , inAccountId := 9128 , inPaidKindId := 3 , inBranchId := 0 , inJuridicalGroupId := 0 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');

