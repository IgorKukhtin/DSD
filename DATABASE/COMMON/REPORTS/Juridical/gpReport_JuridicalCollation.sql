-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inJuridicalId      Integer,    -- ����������� ����  
    IN inPartnerId        Integer,    -- 
    IN inContractId       Integer,    -- �������
    IN inAccountId        Integer,    -- ���� 
    IN inPaidKindId       Integer   , --
    IN inInfoMoneyId      Integer,    -- �������������� ������ 
    IN inCurrencyId       Integer   , -- ������ 
    IN inMovementId_Sale  Integer   , -- ���� ��������� �������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementSumm TFloat, 
               StartRemains TFloat, 
               EndRemains TFloat, 
               Debet TFloat, 
               Kredit TFloat, 
               MovementSumm_Currency TFloat, 
               StartRemains_Currency TFloat, 
               EndRemains_Currency TFloat, 
               Debet_Currency TFloat, 
               Kredit_Currency TFloat, 
               OperDate TDateTime, 
               InvNumber TVarChar, InvNumberPartner TVarChar,
               AccountCode Integer,
               AccountName TVarChar,
               ContractCode Integer, 
               ContractName TVarChar,
               ContractTagName TVarChar,
               ContractStateKindCode Integer, ContractComment TVarChar,
               PaidKindId Integer, PaidKindName TVarChar,
               InfoMoneyGroupCode Integer,
               InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationCode Integer,
               InfoMoneyDestinationName TVarChar,
               InfoMoneyCode Integer,
               InfoMoneyName TVarChar,
               MovementId Integer, 
               ItemName TVarChar,
               OperationSort Integer,
               FromName TVarChar,
               ToName TVarChar)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  -- ���� ������, ������� ������� ������� � ��������. 
  RETURN QUERY  
     WITH Object_Account_View AS (SELECT Object_Account_View.AccountCode, Object_Account_View.AccountName_all, Object_Account_View.AccountId FROM Object_Account_View)
        , tmpContract AS (SELECT COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                               , View_Contract_ContractKey.ContractId_Key
                          FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                          WHERE View_Contract_ContractKey.ContractId = inContractId
                         )
        , tmpContainer AS (SELECT CLO_Juridical.ContainerId               AS ContainerId
                                , Container_Currency.Id                   AS ContainerId_Currency
                                , Container.ObjectId                      AS AccountId
                                , CLO_InfoMoney.ObjectId                  AS InfoMoneyId
                                , CLO_Contract.ObjectId                   AS ContractId
                                , tmpContract.ContractId_Key              AS ContractId_Key
                                , CLO_PaidKind.ObjectId                   AS PaidKindId
                                , COALESCE (CLO_Currency.ObjectId, 0)     AS CurrencyId
                                , Container.Amount                        AS Amount
                                , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
                           FROM ContainerLinkObject AS CLO_Juridical
                                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                                                    AND Container.DescId = zc_Container_Summ()
                                LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                              ON CLO_Partner.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                              ON CLO_InfoMoney.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                              ON CLO_Contract.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                              ON CLO_PaidKind.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId

                                LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = CLO_Juridical.ContainerId AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                                LEFT JOIN Container AS Container_Currency ON Container_Currency.ParentId = CLO_Juridical.ContainerId AND Container_Currency.DescId = zc_Container_SummCurrency()

                           WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
                             AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                             AND (CLO_Partner.ObjectId = inPartnerId OR COALESCE (inPartnerId, 0) = 0)
                             AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
                             AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                             AND (tmpContract.ContractId > 0 OR COALESCE (inContractId, 0) = 0)
                             AND (CLO_Currency.ObjectId = inCurrencyId OR COALESCE (inCurrencyId, 0) = 0 OR COALESCE (inCurrencyId, 0) = zc_Enum_Currency_Basis())
                          )
   SELECT 
          CASE WHEN Operation.OperationSort = 0
                     THEN Operation.MovementSumm
               ELSE 0
          END :: TFloat AS MovementSumm,

          Operation.StartSumm :: TFloat AS StartRemains,
          Operation.EndSumm :: TFloat AS EndRemains,     

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm > 0
                    THEN Operation.MovementSumm
               ELSE 0
          END :: TFloat AS Debet,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm < 0
                    THEN -1 * Operation.MovementSumm
               ELSE 0
          END :: TFloat AS Kredit,

          CASE WHEN Operation.OperationSort = 0
                     THEN Operation.MovementSumm_Currency
               ELSE 0
          END :: TFloat AS MovementSumm_Currency,

          Operation.StartSumm_Currency :: TFloat AS StartRemains_Currency,
          Operation.EndSumm_Currency :: TFloat AS EndRemains_Currency,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm_Currency > 0
                    THEN Operation.MovementSumm_Currency
               ELSE 0
          END :: TFloat AS Debet_Currency,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm_Currency < 0
                    THEN -1 * Operation.MovementSumm_Currency
               ELSE 0
          END :: TFloat AS Kredit_Currency,

          Operation.OperDate,
          Movement.InvNumber,
          MovementString_InvNumberPartner.ValueData AS InvNumberPartner,
          Object_Account_View.AccountCode,
          Object_Account_View.AccountName_all AS AccountName,

          View_Contract_InvNumber.ContractCode,
          View_Contract_InvNumber.InvNumber AS ContractName,
          View_Contract_InvNumber.ContractTagName,
          View_Contract_InvNumber.ContractStateKindCode,
          ObjectString_Comment.ValueData AS ContractComment,

          Object_PaidKind.Id AS PaidKindId,
          Object_PaidKind.ValueData AS PaidKindName,
          Object_InfoMoney_View.InfoMoneyGroupCode,
          Object_InfoMoney_View.InfoMoneyGroupName,
          Object_InfoMoney_View.InfoMoneyDestinationCode,
          Object_InfoMoney_View.InfoMoneyDestinationName,
          Object_InfoMoney_View.InfoMoneyCode,
          Object_InfoMoney_View.InfoMoneyName,
          Movement.Id               AS MovementId, 
          CASE WHEN Operation.OperationSort = -1
                    THEN ' ����:'
               ELSE MovementDesc.ItemName
          END::TVarChar  AS ItemName,     
          Operation.OperationSort, 
          (Object_From.ValueData || CASE WHEN Object_From.DescId = zc_Object_BankAccount() THEN ' * ' || Object_Bank.ValueData ELSE '' END) :: TVarChar AS FromName, 
          (Object_To.ValueData || CASE WHEN Object_To.DescId = zc_Object_BankAccount() THEN ' * ' || Object_Bank.ValueData ELSE '' END) :: TVarChar AS ToName
          --, Operation.MovementItemId :: Integer AS MovementItemId
          
    FROM  (SELECT tmpContainer.AccountId,
                  tmpContainer.InfoMoneyId,
                  tmpContainer.ContractId,
                  tmpContainer.PaidKindId,
                  tmpContainer.CurrencyId,
                  tmpContainer.MovementId,
                  tmpContainer.OperDate,
                  tmpContainer.MovementItemId,

                  SUM (tmpContainer.MovementSumm) AS MovementSumm,
                  SUM (tmpContainer.MovementSumm_Currency) AS MovementSumm_Currency,
                  0 AS StartSumm,
                  0 AS EndSumm,
                  0 AS StartSumm_Currency,
                  0 AS EndSumm_Currency,
                  0 AS OperationSort
           FROM -- 1.1. �������� � ������ �������
               (SELECT tmpContainer.AccountId,
                       tmpContainer.InfoMoneyId,
                       tmpContainer.ContractId,
                       tmpContainer.PaidKindId,
                       tmpContainer.CurrencyId,
                       MIContainer.MovementId,
                       MIContainer.OperDate,
                       MAX (MIContainer.MovementItemId) AS MovementItemId,

                       SUM (MIContainer.Amount) AS MovementSumm,
                       0                        AS MovementSumm_Currency
                FROM tmpContainer
                     INNER JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                     AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.ContractId, tmpContainer.PaidKindId, tmpContainer.CurrencyId
                       , MIContainer.MovementId, MIContainer.OperDate
                HAVING SUM (MIContainer.Amount) <> 0
               UNION ALL
                -- 1.2. �������� � ������ ��������
                SELECT tmpContainer.AccountId,
                       tmpContainer.InfoMoneyId,
                       tmpContainer.ContractId,
                       tmpContainer.PaidKindId,
                       tmpContainer.CurrencyId,
                       MIContainer.MovementId,
                       MIContainer.OperDate,
                       MAX (MIContainer.MovementItemId) AS MovementItemId,

                       0                        AS MovementSumm,
                       SUM (MIContainer.Amount) AS MovementSumm_Currency
                FROM tmpContainer
                     INNER JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                     AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                WHERE tmpContainer.ContainerId_Currency > 0
                GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.ContractId, tmpContainer.PaidKindId, tmpContainer.CurrencyId
                       , MIContainer.MovementId, MIContainer.OperDate
                HAVING SUM (MIContainer.Amount) <> 0
               ) AS tmpContainer
           GROUP BY tmpContainer.AccountId,
                    tmpContainer.InfoMoneyId,
                    tmpContainer.ContractId,
                    tmpContainer.PaidKindId,
                    tmpContainer.CurrencyId,
                    tmpContainer.MovementId,
                    tmpContainer.OperDate,
                    tmpContainer.MovementItemId

          UNION ALL
           SELECT tmpRemains.AccountId, 
                  tmpRemains.InfoMoneyId, 
                  tmpRemains.ContractId, 
                  tmpRemains.PaidKindId, 
                  tmpRemains.CurrencyId,
                  0 AS MovementId,
                  NULL :: TDateTime AS OperDate,
                  0 AS MovementItemId,
                  0 AS MovementSumm,
                  0 MovementSumm_Currency,
                  SUM (tmpRemains.StartSumm) AS StartSumm,
                  SUM (tmpRemains.EndSumm) AS EndSumm,
                  SUM (tmpRemains.StartSumm_Currency) AS StartSumm_Currency,
                  SUM (tmpRemains.EndSumm_Currency) AS EndSumm_Currency,
                  -1 AS OperationSort
           FROM  -- 2.1. ������� � ������ �������
                (SELECT tmpContainer.ContainerId, 
                        tmpContainer.AccountId,
                        tmpContainer.InfoMoneyId,
                        tmpContainer.ContractId_Key AS ContractId,
                        tmpContainer.PaidKindId,
                        tmpContainer.CurrencyId,
                        tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartSumm,
                        tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndSumm,
                        0 AS StartSumm_Currency,
                        0 AS EndSumm_Currency
                 FROM tmpContainer
                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                      ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                     AND MIContainer.OperDate >= inStartDate
                 GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.ContractId_Key, tmpContainer.PaidKindId, tmpContainer.CurrencyId
                        , tmpContainer.ContainerId, tmpContainer.Amount
                UNION ALL
                 -- 2.2. ������� � ������ ��������
                 SELECT tmpContainer.ContainerId, 
                        tmpContainer.AccountId,
                        tmpContainer.InfoMoneyId,
                        tmpContainer.ContractId_Key AS ContractId,
                        tmpContainer.PaidKindId,
                        tmpContainer.CurrencyId,
                        0 AS StartSumm,
                        0 AS EndSumm,
                        tmpContainer.Amount_Currency - COALESCE (SUM (MIContainer.Amount), 0)                                                            AS StartSumm_Currency,
                        tmpContainer.Amount_Currency - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndSumm_Currency
                 FROM tmpContainer
                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                      ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                     AND MIContainer.OperDate >= inStartDate
                 WHERE tmpContainer.ContainerId_Currency > 0
                 GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.ContractId_Key, tmpContainer.PaidKindId, tmpContainer.CurrencyId
                        , tmpContainer.ContainerId, tmpContainer.ContainerId_Currency, tmpContainer.Amount_Currency
                ) AS tmpRemains
           GROUP BY tmpRemains.AccountId, tmpRemains.InfoMoneyId, tmpRemains.ContractId, tmpRemains.PaidKindId, tmpRemains.CurrencyId -- tmpRemains.ContainerId, 
           HAVING SUM (tmpRemains.StartSumm) <> 0 OR SUM (tmpRemains.EndSumm) <> 0
          ) AS Operation

      LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = Operation.ContractId
      LEFT JOIN ObjectString AS ObjectString_Comment
                             ON ObjectString_Comment.ObjectId = Operation.ContractId
                            AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

      LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
      LEFT JOIN Movement ON Movement.Id = Operation.MovementId
      LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
      LEFT JOIN MovementString AS MovementString_InvNumberPartner
                               ON MovementString_InvNumberPartner.MovementId =  Operation.MovementId
                              AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

      LEFT JOIN MovementItem AS MovementItem_by ON MovementItem_by.Id = Operation.MovementItemId
                                               AND MovementItem_by.DescId IN (zc_MI_Master())
                                               AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
      LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                       ON MILinkObject_Unit.MovementItemId = Operation.MovementItemId
                                      AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
      LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                       ON MILinkObject_MoneyPlace.MovementItemId = Operation.MovementItemId
                                      AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id 
                                  AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId IN (zc_Movement_TransportService())
                                                                               THEN zc_MovementLinkObject_UnitForwarding()
                                                                            WHEN Movement.DescId IN (zc_Movement_PersonalAccount())
                                                                                 THEN zc_MovementLinkObject_Personal()
                                                                            WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_TransferDebtOut())
                                                                                 THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                                                                                 THEN zc_MovementLinkObject_From()
                                                                       END
      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id 
                                  AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_TransferDebtOut())
                                                                               THEN zc_MovementLinkObject_To()
                                                                          WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                                                                               THEN zc_MovementLinkObject_To()
                                                                     END
      LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                   ON MovementLinkObject_Partner.MovementId = Movement.Id 
                                  AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()

      LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                           ON ObjectLink_BankAccount_Bank.ObjectId = MovementItem_by.ObjectId
                          AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
      LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

      LEFT JOIN Object AS Object_From ON Object_From.Id = CASE WHEN Movement.DescId IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective()) AND MovementLinkObject_Partner.ObjectId IS NOT NULL
                                                                    THEN MovementLinkObject_Partner.ObjectId
                                                               ELSE COALESCE (MovementLinkObject_From.ObjectId, COALESCE (CASE WHEN Operation.MovementSumm < 0 THEN MILinkObject_MoneyPlace.ObjectId ELSE MovementItem_by.ObjectId END, MILinkObject_Unit.ObjectId))
                                                          END
      LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN Movement.DescId IN (zc_Movement_TransferDebtOut()) AND MovementLinkObject_Partner.ObjectId IS NOT NULL
                                                                THEN MovementLinkObject_Partner.ObjectId
                                                           ELSE COALESCE (MovementLinkObject_To.ObjectId, COALESCE (CASE WHEN Operation.MovementSumm > 0 THEN MILinkObject_MoneyPlace.ObjectId ELSE MovementItem_by.ObjectId END, MILinkObject_Unit.ObjectId))
                                                      END
      LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Operation.PaidKindId
      
  ORDER BY Operation.OperationSort;
                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.11.14         * add inCurrencyId
 21.08.14                                        * add ContractComment
 03.07.14                                        * add InvNumberPartner
 16.05.14                                        * add Operation.OperDate
 10.05.14                                        * add inInfoMoneyId
 05.05.14                                        * add inPaidKindId
 04.05.14                                        * add PaidKindName
 26.04.14                                        * add Object_Contract_ContractKey_View
 17.04.14                        * 
 26.03.14                        * 
 18.02.14                        * add WITH ��� ��������� �������. 
 25.01.14                        * 
 15.01.14                        * 
*/

-- ����
-- SELECT * FROM gpReport_JuridicalCollation (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inJuridicalId:= 0, inPartnerId:=0, inContractId:= 0, inAccountId:= 0, inPaidKindId:= 0, inInfoMoneyId:= 0, inCurrencyId:= 0, inSession:= zfCalc_UserAdmin());
