-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPayment(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inAccountId        Integer   , --
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, OKPO TVarChar, PaidKindName TVarChar
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
              )
AS
$BODY$
   DECLARE vbLenght Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- �������� ������� �� ���� �� ��. ����� � ������� ���������. 
     -- ��� �� �������� ������� � �������� �� ������ 
  vbLenght := 7;

  RETURN QUERY  

 select a.AccountName, a.JuridicalId, a.JuridicalName, a.OKPO, a.PaidKindName
             , SUM(a.DebetRemains)::TFloat , SUM(a.KreditRemains)::TFloat
             , SUM(a.SaleSumm)::TFloat, SUM(a.DefermentPaymentRemains)::TFloat
             , SUM(a.SaleSumm1)::TFloat, SUM(a.SaleSumm2)::TFloat, SUM(a.SaleSumm3)::TFloat, SUM(a.SaleSumm4)::TFloat, SUM(a.SaleSumm5)::TFloat
             , a.Condition, a.StartContractDate, SUM(a.Remains)::TFloat
             , a.InfoMoneyGroupName, a.InfoMoneyDestinationName, a.InfoMoneyCode, a.InfoMoneyName
from (
  SELECT 
     Object_Account_View.AccountName_all AS AccountName
   , Object_Juridical.Id        AS JuridicalId
   , Object_Juridical.Valuedata AS JuridicalName
   , ObjectHistory_JuridicalDetails_View.OKPO
   , Object_PaidKind.ValueData  AS PaidKindName
   , (CASE WHEN RESULT.Remains > 0 THEN RESULT.Remains ELSE 0 END)::TFloat AS DebetRemains
   , (CASE WHEN RESULT.Remains > 0 THEN 0 ELSE -1 * RESULT.Remains END)::TFloat AS KreditRemains
   , RESULT.SaleSumm::TFloat
   , (CASE WHEN (RESULT.Remains - RESULT.SaleSumm) > 0 THEN RESULT.Remains - RESULT.SaleSumm ELSE RESULT.Remains - RESULT.SaleSumm END)::TFloat AS DefermentPaymentRemains
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm) > 0 AND RESULT.SaleSumm1 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm) > RESULT.SaleSumm1 THEN RESULT.SaleSumm1 ELSE (RESULT.Remains - RESULT.SaleSumm) END
      ELSE 0 END)::TFloat AS SaleSumm1
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1) > 0 AND RESULT.SaleSumm2 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1) > RESULT.SaleSumm2 THEN RESULT.SaleSumm2 ELSE (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1) END
      ELSE 0 END)::TFloat AS SaleSumm2
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > 0 AND RESULT.SaleSumm3 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > RESULT.SaleSumm3 THEN RESULT.SaleSumm3 ELSE (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) END
      ELSE 0 END)::TFloat AS SaleSumm3
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > 0 AND RESULT.SaleSumm4 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > RESULT.SaleSumm4 THEN RESULT.SaleSumm4 ELSE (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) END
      ELSE 0 END)::TFloat AS SaleSumm4
   , (CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4) > 0 THEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4) ELSE 0 END )::TFloat AS SaleSumm5
   , (RESULT.DayCount||' '||Object_ContractConditionKind.ValueData)::TVarChar AS Condition
   , RESULT.ContractDate::TDateTime AS StartContractDate
   , (-RESULT.Remains)::TFloat AS Remains

      , Object_InfoMoney_View.InfoMoneyGroupName
      , Object_InfoMoney_View.InfoMoneyDestinationName
      , Object_InfoMoney_View.InfoMoneyCode
      , Object_InfoMoney_View.InfoMoneyName

  FROM (SELECT Container.Id
             , Container.ObjectId     AS AccountId
             , CLO_Contract.ObjectId  AS ContractId
             , CLO_Juridical.ObjectId AS JuridicalId 
             , Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate >= inOperDate THEN MIContainer.Amount ELSE 0 END), 0) AS Remains
             , SUM (CASE WHEN (MIContainer.OperDate < inOperDate) AND (MIContainer.OperDate >= ContractDate) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate AND MIContainer.OperDate >= ContractDate - vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm1
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - vbLenght AND MIContainer.OperDate >= ContractDate - 2 * vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm2
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 2 * vbLenght AND MIContainer.OperDate >= ContractDate - 3 * vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm3
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 3 * vbLenght AND MIContainer.OperDate >= ContractDate - 4 * vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm4
             , ContractKind.ContractConditionKindId
             , ContractKind.DayCount
             , ContractDate
         FROM ContainerLinkObject AS CLO_Juridical 
         JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
    LEFT JOIN ContainerLinkObject AS CLO_Contract
           ON CLO_Contract.ContainerId = Container.Id AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                
    LEFT JOIN (SELECT ContractId
                    , zfCalc_DetermentPaymentDate(COALESCE(ContractConditionKindId, 0), DayCount, inOperDate)::Date AS ContractDate
                    , ContractConditionKindId
                    , DayCount
                 FROM Object_Contract_DefermentPaymentView
                       ) AS ContractKind
            ON ContractKind.contractid = CLO_Contract.objectid
                              
     LEFT JOIN MovementItemContainer AS MIContainer 
            ON MIContainer.Containerid = Container.Id
           AND MIContainer.OperDate >= COALESCE(ContractKind.ContractDate::Date - 4 * vbLenght, inOperDate)
     LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
         WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
           AND (Container.ObjectId = inAccountId OR inAccountId = 0)
      GROUP BY Container.amount
             , CLO_Contract.ObjectId
             , CLO_Juridical.ObjectId  
             , Container.ObjectId
             , Container.Id
             , ContractConditionKindId
             , DayCount
             , ContractDate) AS RESULT
  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = RESULT.JuridicalId
  LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = RESULT.AccountId
  LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = RESULT.ContractId
  LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = RESULT.ContractConditionKindId

           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                  ON CLO_InfoMoney.ContainerId = RESULT.Id
                 AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId

           LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                  ON CLO_PaidKind.ContainerId = RESULT.Id
                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CLO_PaidKind.ObjectId
) as a
where a.DebetRemains <> 0 or a.KreditRemains <> 0
             or  a.SaleSumm <> 0 or a.DefermentPaymentRemains <> 0
             or  a.SaleSumm1 <> 0 or a.SaleSumm2 <> 0 or a.SaleSumm3 <> 0 or a.SaleSumm4 <> 0 or a.SaleSumm5 <> 0
             or  a.Remains <> 0 
 GROUP BY a.AccountName, a.JuridicalId, a.JuridicalName, a.OKPO, a.PaidKindName
             , a.Condition, a.StartContractDate
             , a.InfoMoneyGroupName, a.InfoMoneyDestinationName, a.InfoMoneyCode, a.InfoMoneyName
    ;
    -- �����. �������� ��������� ������. 
    -- ����� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.04.14                                        * add !!!
 31.03.14                                        * add Object_Contract_View and Object_InfoMoney_View and ObjectHistory_JuridicalDetails_View and Object_PaidKind
 30.03.14                          * 
 06.02.14                          * 
*/

-- ����
-- SELECT * FROM gpReport_JuridicalDefermentPayment ('01.01.2014'::TDateTime, '01.02.2013'::TDateTime, 0, inSession:= '2'::TVarChar); 
