-- Function: gpSelect_Movement_Send()

DROP FUNCTION IF EXISTS gpSelect_Movement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inAccountId   Integer   , 
    IN inJuridicalId Integer   , 
    IN inPartnerId   Integer   , 
    IN inBranchId    Integer   , 
    IN inInfoMoneyId Integer   ,
    IN inContractId  Integer   , 
    IN inPaidKindId  Integer   , 
    IN inDescSet     TVarChar  ,  
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, DescId Integer, DescName TVarChar
             , DebetSumm TFloat, KreditSumm TFloat
             , Comment TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , ContractCode Integer, ContractNumber TVarChar
             , ContractTagName TVarChar, ContractStateKindCode Integer
             , PaidKindName TVarChar, AccountName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDescId Integer; 
   DECLARE vbIndex  Integer;
   DECLARE vbIsSaleRealDesc    Boolean;
   DECLARE vbIsServiceRealDesc Boolean;

   DECLARE vbObjectId_Constraint Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется уровень доступа
     vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
     -- !!!меняется параметр!!!
     IF vbObjectId_Constraint > 0 AND inPaidKindId <> zc_Enum_PaidKind_FirstForm() THEN inBranchId:= vbObjectId_Constraint; END IF;


     --
     vbIsSaleRealDesc:= FALSE;
     vbIsServiceRealDesc:= FALSE;

     -- таблица - MovementDesc - типы документов
     CREATE TEMP TABLE _tmpMovementDesc (DescId Integer) ON COMMIT DROP;
     -- парсим типы документов
     vbIndex := 1;
     WHILE split_part (inDescSet, ';', vbIndex) <> '' LOOP
         IF split_part (inDescSet, ';', vbIndex) = 'SaleRealDesc'
         THEN vbIsSaleRealDesc = TRUE;
         ELSE
             IF split_part (inDescSet, ';', vbIndex) = 'ServiceRealDesc'
             THEN vbIsServiceRealDesc = TRUE;
             ELSE
                 -- парсим
                 EXECUTE 'SELECT ' || split_part (inDescSet, ';', vbIndex) INTO vbDescId;
                 -- добавляем то что нашли
                 INSERT INTO _tmpMovementDesc SELECT vbDescId;
             END IF;
         END IF;
         -- теперь следуюющий
         vbIndex := vbIndex + 1;
     END LOOP;


     -- Результат
     RETURN QUERY 
       SELECT
             tmpMIContainer.MovementId AS Id
           , tmpMIContainer.InvNumber
           , tmpMIContainer.OperDate
           , tmpMIContainer.MovementDescId AS DescId
           , MovementDesc.ItemName
           , CASE WHEN tmpMIContainer.AmountSumm >= 0 THEN      tmpMIContainer.AmountSumm ELSE 0 END :: TFloat AS DebetSumm
           , CASE WHEN tmpMIContainer.AmountSumm < 0  THEN -1 * tmpMIContainer.AmountSumm ELSE 0 END :: TFloat AS KreditSumm

           , MIString_Comment.ValueData AS Comment

           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData AS JuridicalName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , Object_Partner.ObjectCode AS PartnerCode
           , Object_Partner.ValueData AS PartnerName
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData AS BranchName
           , View_Contract.ContractCode
           , View_Contract.InvNumber AS ContractNumber
           , View_Contract.ContractTagName
           , View_Contract.ContractStateKindCode
           , Object_PaidKind.ValueData AS PaidKindName
           , Object_Account_View.AccountName_all AS AccountName
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
             
       FROM (SELECT Movement.Id AS MovementId
                  , Movement.InvNumber
                  , Movement.OperDate
                  , Movement.DescId AS MovementDescId
                  , tmpContainer.ContainerId
                  , tmpContainer.AccountId
                  , tmpContainer.JuridicalId
                  , tmpContainer.PartnerId
                  , tmpContainer.BranchId
                  , tmpContainer.ContractId
                  , tmpContainer.InfoMoneyId
                  , tmpContainer.PaidKindId
                  , MAX (MIContainer.MovementItemId) AS MovementItemId
                  , SUM (MIContainer.Amount) AS AmountSumm
                  , CASE WHEN Movement.DescId = zc_Movement_Service() AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10300() THEN TRUE ELSE FALSE END AS isSaleRealDesc
                  , CASE WHEN Movement.DescId = zc_Movement_Service() AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_ProfitLossDirection_10300() THEN TRUE ELSE FALSE END AS isServiceRealDesc
             FROM
            (SELECT Container.Id                              AS ContainerId
                  , Container.ObjectId                        AS AccountId
                  , CLO_Juridical.ObjectId                    AS JuridicalId
                  , CLO_Partner.ObjectId                      AS PartnerId
                  , CLO_Branch.ObjectId                       AS BranchId
                  , CLO_Contract.ObjectId                     AS ContractId
                  , CLO_InfoMoney.ObjectId                    AS InfoMoneyId
                  , CLO_PaidKind.ObjectId                     AS PaidKindId
             FROM Container
                  LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                                ON CLO_Juridical.ContainerId = Container.Id
                                               AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                  LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                ON CLO_Partner.ContainerId = Container.Id
                                               AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = Container.Id
                                               AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                  LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                ON CLO_Contract.ContainerId = Container.Id
                                               AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                  LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId
                  LEFT JOIN ContainerLinkObject AS CLO_InfoMoney 
                                                ON CLO_InfoMoney.ContainerId = Container.Id
                                               AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                  LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                ON CLO_PaidKind.ContainerId = Container.Id
                                               AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
             WHERE Container.DescId IN (zc_Container_Summ(), zc_Container_SummAsset())
               AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
               AND (CLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
               AND (CLO_Partner.ObjectId = inPartnerId OR COALESCE (inPartnerId, 0) = 0)
               AND (CLO_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0)
               AND (View_Contract_ContractKey.ContractId_Key = inContractId OR COALESCE (inContractId, 0) = 0)
               AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
               AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
            ) AS tmpContainer

             INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
             INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
             INNER JOIN _tmpMovementDesc ON _tmpMovementDesc.DescId = Movement.DescId

             GROUP BY Movement.Id
                    , Movement.InvNumber
                    , Movement.OperDate
                    , Movement.DescId
                    , tmpContainer.ContainerId
                    , tmpContainer.AccountId
                    , tmpContainer.JuridicalId
                    , tmpContainer.PartnerId
                    , tmpContainer.BranchId
                    , tmpContainer.ContractId
                    , tmpContainer.InfoMoneyId
                    , tmpContainer.PaidKindId
                    , CASE WHEN Movement.DescId = zc_Movement_Service() AND MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10300() THEN TRUE ELSE FALSE END
                    , CASE WHEN Movement.DescId = zc_Movement_Service() AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_ProfitLossDirection_10300() THEN TRUE ELSE FALSE END
            ) AS tmpMIContainer

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = tmpMIContainer.MovementId
                                        AND MovementLinkObject_Partner.DescId = CASE WHEN tmpMIContainer.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() WHEN tmpMIContainer.MovementDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_Partner() END
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMIContainer.MovementDescId
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMIContainer.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpMIContainer.AccountId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMIContainer.JuridicalId   
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = CASE WHEN tmpMIContainer.PartnerId <> 0 THEN tmpMIContainer.PartnerId ELSE MovementLinkObject_Partner.ObjectId END
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpMIContainer.BranchId
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = tmpMIContainer.ContractId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpMIContainer.InfoMoneyId         
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMIContainer.PaidKindId

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
       WHERE (isSaleRealDesc = TRUE OR vbIsSaleRealDesc = FALSE OR tmpMIContainer.MovementDescId <> zc_Movement_Service())
         AND (isServiceRealDesc = TRUE OR vbIsServiceRealDesc = FALSE OR tmpMIContainer.MovementDescId <> zc_Movement_Service())
      ;
  
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.14                                        * add vbIsSaleRealDesc and vbIsServiceRealDesc
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 07.09.14                                        * add Branch...
 31.08.14                                        * ALL
 22.04.14                         *
 11.03.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', 0, 0, 0, 0, 0, 0, 0, '', inSession:= zfCalc_UserAdmin())
