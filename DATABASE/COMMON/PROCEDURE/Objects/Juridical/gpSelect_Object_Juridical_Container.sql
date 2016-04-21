-- Function: gpSelect_Object_Juridical_Container (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_Container (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_Container (Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_Container(
    IN inJuridicalId    Integer,       --
    IN inAccountId      Integer,       --
    IN inShowAll        Boolean,       -- 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (containerid tfloat
             , juridicalid integer, juridicalcode integer, juridicalname tvarchar
             , okpo tvarchar
             , Accountid integer, Accountcode integer, Accountname tvarchar             
             , infomoneyid integer, infomoneycode integer, infomoneyname tvarchar, infomoneyname_all tvarchar
             , branchid integer, branchcode integer, branchname tvarchar
             , Businessid integer, Businessname tvarchar
             , juridicalBasisid integer, juridicalBasiscode integer, juridicalBasisname tvarchar
             , partnerid integer, partnercode integer, partnername tvarchar
             , contractid integer, contractcode integer, contractnumber tvarchar
             , paidkindid integer, paidkindname tvarchar
             , partionmovementid integer, partionoperdate tdatetime, partioninvnumber tvarchar
             , amountdebet tfloat, amountkredit tfloat) AS
--zc_ContainerLinkObject_Business - бизнес 2)zc_ContainerLinkObject_JuridicalBasis
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
                          , Container.ObjectId           AS AccountId
                          , CLO_Juridical.ObjectId       AS JuridicalId
                          , CLO_Partner.ObjectId         AS PartnerId
                          , CLO_InfoMoney.ObjectId       AS InfoMoneyId
                          , CLO_PaidKind.ObjectId        AS PaidKindId
                          , CLO_Contract.ObjectId        AS ContractId
                          , CLO_Branch.ObjectId          AS BranchId
                          , CLO_Business.ObjectId        AS BusinessId
                          , CLO_JuridicalBasis.ObjectId  AS JuridicalBasisId
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

                       LEFT JOIN ContainerLinkObject AS CLO_Business 
                                                     ON CLO_Business.ContainerId = Container.Id 
                                                    AND CLO_Business.DescId = zc_ContainerLinkObject_Business()

                       LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis 
                                                     ON CLO_JuridicalBasis.ContainerId = Container.Id 
                                                    AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()

                       LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                     ON CLO_Partner.ContainerId = Container.Id
                                                    AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()                                                    
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
                       AND ((Container.Amount <> 0 AND inShowAll = False) OR inShowAll = true)
                   )

       -- Результат
       SELECT tmpContainer.ContainerId ::TFloat
            , Object_Juridical.Id         AS JuridicalId
            , Object_Juridical.ObjectCode AS JuridicalCode
            , Object_Juridical.ValueData  AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO 

            , View_Account.AccountId    AS AccountId
            , View_Account.AccountCode  AS AccountCode
            , View_Account.AccountName  AS AccountName

            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all
            , Object_Branch.Id                 AS BranchId
            , Object_Branch.ObjectCode         AS BranchCode
            , Object_Branch.ValueData          AS BranchName

            , Object_Business.Id               AS BusinessId
            , Object_Business.ValueData        AS BusinessName

            , Object_JuridicalBasis.Id         AS JuridicalBasisId
            , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
            , Object_JuridicalBasis.ValueData  AS JuridicalBasisName

            , Object_Partner.Id                AS PartnerId
            , Object_Partner.ObjectCode        AS PartnerCode
            , Object_Partner.ValueData         AS PartnerName
            , View_Contract.ContractId
            , View_Contract.ContractCode
            , View_Contract.InvNumber          AS ContractNumber
            , Object_PaidKind.Id               AS PaidKindId
            , Object_PaidKind.ValueData        AS PaidKindName

            , Movement.Id         AS PartionMovementId
            , Movement.OperDate   AS PartionOperDate
            , Movement.InvNumber  AS PartionInvNumber

            , CASE WHEN tmpContainer.Amount > 0 THEN tmpContainer.Amount ELSE 0 END ::TFloat AS AmountDebet
            , CASE WHEN tmpContainer.Amount < 0 THEN -1 * tmpContainer.Amount ELSE 0 END ::TFloat AS AmountKredit

       FROM tmpContainer
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpContainer.JuridicalId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpContainer.JuridicalBasisId
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpContainer.BusinessId
            LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpContainer.AccountId 
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpContainer.PartnerId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpContainer.BranchId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpContainer.InfoMoneyId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpContainer.PaidKindId
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = tmpContainer.ContractId
            LEFT JOIN Movement ON Movement.Id = tmpContainer.PartionMovementId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
            
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
-- SELECT * FROM gpSelect_Object_Juridical_Container (0, 0, TRUE, zfCalc_UserAdmin())
--select * from gpSelect_Object_Juridical_Container(inJuridicalId := 345687 , inAccountId := 0 , inShowAll := 'False' ,  inSession := zfCalc_UserAdmin());
