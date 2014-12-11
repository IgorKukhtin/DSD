-- Function: gpSelect_Object_MoneyPlaceCash()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlaceCash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlaceCash(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractId Integer, ContractNumber TVarChar, ContractStateKindCode Integer, StartDate TDateTime, EndDate TDateTime
             , ContractTagName TVarChar, ContractKindName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbIsConstraint Boolean;
  DECLARE vbObjectId_Constraint Integer;

   DECLARE vbIsConstraint_Branch Boolean;
   DECLARE vbObjectId_Constraint_Branch Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется уровень доступа (группа юр.лиц)
     vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0);
     vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;

     -- определяется уровень доступа (филиал)
     vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);
     vbIsConstraint_Branch:= COALESCE (vbObjectId_Constraint_Branch, 0) > 0;


     -- Результат
     RETURN QUERY
     WITH View_InfoMoney_40801 AS (SELECT * FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyCode = 40801)
        , tmpPersonal_Branch AS (SELECT View_Personal.MemberId
                                 FROM ObjectLink AS ObjectLink_Unit_Branch
                                      INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = ObjectLink_Unit_Branch.ObjectId
                                 WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch
                                   AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                 GROUP BY View_Personal.MemberId
                                UNION ALL
                                 SELECT View_Personal.MemberId
                                 FROM Object_Personal_View AS View_Personal
                                 WHERE View_Personal.PositionId = 81178 -- экспедитор
                                    OR View_Personal.UnitId = 8409 -- Отдел экспедиторов
                                 GROUP BY View_Personal.MemberId
                                )
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode
          , Object_Cash.Valuedata AS Name
          , ObjectDesc.ItemName
          , Object_Cash.isErased
          , View_InfoMoney.InfoMoneyId
          , View_InfoMoney.InfoMoneyCode
          , View_InfoMoney.InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all
          , NULL::Integer AS ContractId
          , ''::TVarChar AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
          LEFT JOIN View_InfoMoney_40801 AS View_InfoMoney ON 1 = 1
     WHERE Object_Cash.DescId = zc_Object_Cash()
    UNION ALL
     SELECT Object_BankAccount_View.Id
          , Object_BankAccount_View.Code     
          , (Object_BankAccount_View.Name || ' * '|| Object_BankAccount_View.BankName) ::TVarChar AS Name
          , ObjectDesc.ItemName
          , Object_BankAccount_View.isErased
          , View_InfoMoney.InfoMoneyId
          , View_InfoMoney.InfoMoneyCode
          , View_InfoMoney.InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all
          , NULL::Integer
          , ''::TVarChar
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
     FROM Object_BankAccount_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_BankAccount()
          LEFT JOIN View_InfoMoney_40801 AS View_InfoMoney ON 1 = 1
     WHERE Object_BankAccount_View.JuridicalId = zc_Juridical_Basis()
       AND vbIsConstraint = FALSE
    UNION ALL
     SELECT Object_Member.Id
          , Object_Member.ObjectCode     
          , Object_Member.ValueData
          , ObjectDesc.ItemName
          , Object_Member.isErased
          , NULL::Integer AS InfoMoneyId
          , NULL::Integer AS InfoMoneyCode
          , ''::TVarChar AS InfoMoneyGroupName
          , ''::TVarChar AS InfoMoneyDestinationName
          , ''::TVarChar AS InfoMoneyName
          , ''::TVarChar AS InfoMoneyName_all
          , NULL::Integer
          , ''::TVarChar
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
     FROM Object AS Object_Member
          LEFT JOIN tmpPersonal_Branch ON tmpPersonal_Branch.MemberId = Object_Member.Id
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
    WHERE Object_Member.DescId = zc_Object_Member()
      AND Object_Member.isErased = FALSE
      AND (tmpPersonal_Branch.MemberId > 0
           OR vbIsConstraint_Branch = FALSE
          )
    UNION ALL
     SELECT Object_Partner.Id
          , Object_Partner.ObjectCode     
          , Object_Partner.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Partner.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , View_Contract.ContractId 
          , View_Contract.InvNumber
          , View_Contract.ContractStateKindCode
          , View_Contract.StartDate
          , View_Contract.EndDate
          , View_Contract.ContractTagName
          , View_Contract.ContractKindName
     FROM Object AS Object_Partner
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = Object_Juridical.Id
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                               ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
     WHERE Object_Partner.DescId = zc_Object_Partner()
       AND Object_Partner.isErased = FALSE
       AND View_Contract.isErased = FALSE
       AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
            OR vbIsConstraint = FALSE)
    UNION ALL
     SELECT Object_Juridical.Id
          , Object_Juridical.ObjectCode     
          , Object_Juridical.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Juridical.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , View_Contract.ContractId 
          , View_Contract.InvNumber
          , View_Contract.ContractStateKindCode
          , View_Contract.StartDate
          , View_Contract.EndDate
          , View_Contract.ContractTagName
          , View_Contract.ContractKindName
     FROM Object AS Object_Juridical
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = Object_Juridical.Id 
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40900()
       AND View_Contract.isErased = FALSE
       AND Object_Juridical.isErased = FALSE
       AND vbIsConstraint = FALSE
    UNION ALL
     SELECT Object_Founder.Id
          , Object_Founder.ObjectCode     
          , Object_Founder.ValueData
          , ObjectDesc.ItemName
          , Object_Founder.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , NULL::Integer
          , ''::TVarChar
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
     FROM Object AS Object_Founder
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Founder.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Founder_InfoMoney
                               ON ObjectLink_Founder_InfoMoney.ObjectId = Object_Founder.Id
                              AND ObjectLink_Founder_InfoMoney.DescId = zc_ObjectLink_Founder_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Founder_InfoMoney.ChildObjectId
    WHERE Object_Founder.DescId = zc_Object_Founder()
      AND Object_Founder.isErased = FALSE
      AND vbIsConstraint = FALSE
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MoneyPlaceCash (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.09.14                                        * add zc_Object_Founder
 28.08.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MoneyPlaceCash (inSession:= '2')
