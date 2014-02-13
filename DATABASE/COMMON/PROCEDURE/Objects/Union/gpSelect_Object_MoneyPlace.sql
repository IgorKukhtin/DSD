-- Function: gpSelect_Object_MoneyPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , ContractId Integer, ContractNumber TVarChar, ContractStateKindCode Integer, StartDate TDateTime)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId := inSession;

     RETURN QUERY
       WITH tmpUserTransport AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Transport())
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode     
          , Object_Cash.Valuedata AS Name
          , ObjectDesc.ItemName
          , Object_Cash.isErased
          , 0::Integer AS InfoMoneyId
          , 0::Integer AS InfoMoneyCode
          , ''::TVarChar AS InfoMoneyGroupName
          , ''::TVarChar AS InfoMoneyDestinationName
          , ''::TVarChar AS InfoMoneyName
          , 0::Integer AS ContractId
          , ''::TVarChar AS ContractNumber
          , 0::Integer AS ContractStateKindCode
          , NULL::TDateTime
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
     WHERE Object_Cash.DescId = zc_Object_Cash()
    UNION ALL
     SELECT Object_BankAccount_View.Id
          , Object_BankAccount_View.Code     
          , Object_BankAccount_View.Name AS Name
          , ObjectDesc.ItemName
          , Object_BankAccount_View.isErased
          , 0::Integer AS InfoMoneyId
          , 0::Integer AS InfoMoneyCode
          , ''::TVarChar AS InfoMoneyGroupName
          , ''::TVarChar AS InfoMoneyDestinationName
          , ''::TVarChar AS InfoMoneyName
       --   , Object_BankAccount_View.BankName
          , 0::Integer
       --   , Object_BankAccount_View.CurrencyName
          , ''::TVarChar
          , 0::Integer AS ContractStateKindCode
          , NULL::TDateTime
     FROM Object_BankAccount_View, ObjectDesc 
     WHERE ObjectDesc.Id = zc_Object_BankAccount()
    UNION ALL
     SELECT Object_Member.Id       
          , Object_Member.ObjectCode     
          , Object_Member.ValueData
          , ObjectDesc.ItemName
          , Object_Member.isErased
          , 0::Integer AS InfoMoneyId
          , 0::Integer AS InfoMoneyCode
          , ''::TVarChar AS InfoMoneyGroupName
          , ''::TVarChar AS InfoMoneyDestinationName
          , ''::TVarChar AS InfoMoneyName
          , 0::Integer
          , ''::TVarChar
          , 0::Integer AS ContractStateKindCode
          , NULL::TDateTime
     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
    WHERE Object_Member.DescId = zc_Object_Member()
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
          , View_Contract.ContractId 
          , View_Contract.InvNumber
          , View_Contract.ContractStateKindCode
          , View_Contract.StartDate
     FROM Object AS Object_Juridical
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = Object_Juridical.Id 
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       -- AND COALESCE (View_Contract.PaidKindId, zc_Enum_PaidKind_SecondForm()) = zc_Enum_PaidKind_SecondForm();
       AND (View_Contract.PaidKindId = zc_Enum_PaidKind_SecondForm() OR vbUserId NOT IN (SELECT UserId FROM tmpUserTransport));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MoneyPlace (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.02.14                                        * add ContractStateKindCode and InfoMoney...
 22.01.14                                        * add tmpUserTransport
 15.01.14                         * add BankAccount
 05.01.14                                        * add zc_Enum_PaidKind_SecondForm
 05.01.14                                        * View_Contract.InfoMoneyId
 18.12.13                         *
 20.11.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MoneyPlace (inSession:= '2')
