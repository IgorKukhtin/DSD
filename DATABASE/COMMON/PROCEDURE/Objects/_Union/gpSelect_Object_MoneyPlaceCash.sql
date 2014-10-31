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
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется уровень доступа
     vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0);
     vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;


     -- Результат
     RETURN QUERY
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode
          , Object_Cash.Valuedata AS Name
          , ObjectDesc.ItemName
          , Object_Cash.isErased
          , NULL::Integer AS InfoMoneyId
          , NULL::Integer AS InfoMoneyCode
          , ''::TVarChar AS InfoMoneyGroupName
          , ''::TVarChar AS InfoMoneyDestinationName
          , ''::TVarChar AS InfoMoneyName
          , ''::TVarChar AS InfoMoneyName_all
          , NULL::Integer AS ContractId
          , ''::TVarChar AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
     WHERE Object_Cash.DescId = zc_Object_Cash()
    UNION ALL
     SELECT Object_BankAccount_View.Id
          , Object_BankAccount_View.Code     
          , (Object_BankAccount_View.Name || ' * '|| Object_BankAccount_View.BankName) ::TVarChar AS Name
          , ObjectDesc.ItemName
          , Object_BankAccount_View.isErased
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
     FROM Object_BankAccount_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_BankAccount()
     WHERE Object_BankAccount_View.JuridicalId = zc_Juridical_Basis()
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
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
    WHERE Object_Member.DescId = zc_Object_Member()
      AND Object_Member.isErased = FALSE
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
