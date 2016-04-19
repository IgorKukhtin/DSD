-- Function: gpSelect_Object_Juridical_Container (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_Container (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_Container(
    IN inJuridicalId    Integer,       --
    IN inAccountId      Integer,       --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , BranchCode Integer, BranchName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar 
             , PaidKindId Integer, PaidKindName TVarChar
             , PartionMovementId Integer, PartionOperDate, PartionInvNumber
             , Amount TFloat

             , isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);

   -- Результат
   RETURN QUERY 
   WITH 
    tmpContainer AS (select Container.Id                 AS ContainerId
                          , Container.ObjectId
                          , Container.Amount
                          , CLO_Juridical.ObjectId       AS JuridicalId
                          , CLO_InfoMoney.ObjectId       AS InfoMoneyId
                          , CLO_PaidKind.ObjectId        AS PaidKindId
                          , CLO_Contract.ObjectId        AS ContractId
                          , CLO_Branch.ObjectId          AS BranchId
                          , CLO_PartionMovement.ObjectId AS PartionMovementId
                     FROM Container
                       INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                      ON CLO_Juridical.ContainerId = Container.Id
                                                     AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                     AND (CLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                       LEFT JOIN ContainerLinkObject AS CLO_InfoMoney 
                                                     ON CLO_InfoMoney.ContainerId = Container.Id 
                                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                       
                       LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                     ON CLO_Branch.ContainerId = Container.Id
                                                    AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                       LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                     ON CLO_PaidKind.ContainerId = Container.Id
                                                    AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                       LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                     ON CLO_Contract.ContainerId = Container.Id
                                                    AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       LEFT JOIN ContainerLinkObject AS CLO_PartionMovement
                                                     ON CLO_PartionMovement.ContainerId = Container.Id
                                                    AND CLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                     WHERE Container.DescId = zc_Container_Summ()
                       AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)


       -- Результат
       SELECT Object_Juridical.Id         AS JuridicalId
            , Object_Juridical.ObjectCode AS JuridicalCode
            , Object_Juridical.ValueData  AS JuridicalName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all
            , Object_Branch.ObjectCode         AS BranchCode
            , Object_Branch.ValueData          AS BranchName
            , View_Contract.ContractId
            , View_Contract.ContractCode
            , View_Contract.InvNumber          AS ContractNumber
            , Object_PaidKind.Id               AS PaidKindId
            , Object_PaidKind.ValueData        AS PaidKindName

            , Movement.Id         AS PartionMovementId
            , Movement.OperDate   AS PartionOperDate
            , Movement.InvNumber  AS PartionInvNumber

            , tmpContainer.Amount ::TFloat AS Amount
       FROM tmpContainer
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpContainer.JuridicalId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpContainer.BranchId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpContainer.InfoMoneyId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpContainer.PaidKindId
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = tmpContainer.ContractId
            LEFT JOIN Movement ON Movement.Id = tmpContainer.PartionMovementId
            
;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical_Container (0, FALSE, zfCalc_UserAdmin())
