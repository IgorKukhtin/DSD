-- Function: gpSelect_Object_MoneyPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean, 
               InfoMoneyId Integer, InfoMoneyName TVarChar, 
               ContractId Integer, ContractNumber TVarChar, StartDate TDateTime, ContractKindName TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId := inSession;

     RETURN QUERY
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode     
          , Object_Cash.Valuedata AS Name
          , ObjectDesc.ItemName
          , Object_Cash.isErased
          , 0::Integer
          , ''::TVarChar
          , 0::Integer
          , ''::TVarChar
          , NULL::TDateTime
          , ''::TVarChar
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
     WHERE Object_Cash.DescId = zc_Object_Cash()
    UNION ALL
     SELECT Object_BankAccount_View.Id
          , Object_BankAccount_View.Code     
          , Object_BankAccount_View.Name AS Name
          , ObjectDesc.ItemName
          , Object_BankAccount_View.isErased
          , 0::Integer
          , ''::TVarChar
       --   , Object_BankAccount_View.BankName
          , 0::Integer
       --   , Object_BankAccount_View.CurrencyName
          , ''::TVarChar
          , NULL::TDateTime
          , ''::TVarChar
     FROM Object_BankAccount_View, ObjectDesc 
     WHERE ObjectDesc.Id = zc_Object_BankAccount()
    UNION ALL
     SELECT Object_Member.Id       
          , Object_Member.ObjectCode     
          , Object_Member.ValueData
          , ObjectDesc.ItemName
          , Object_Member.isErased
          , 0::Integer
          , ''::TVarChar
          , 0::Integer
          , ''::TVarChar
          , NULL::TDateTime
          , ''::TVarChar
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
          , Object_InfoMoney_View.InfoMoneyName
          , View_Contract.ContractId 
          , View_Contract.InvNumber
          , View_Contract.StartDate
          , Object_ContractKind.ValueData AS ContractKindName
     FROM Object AS Object_Juridical
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = Object_Juridical.Id 
          LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                               ON ObjectLink_Contract_ContractKind.ObjectId = View_Contract.ContractId
                              AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
          LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       -- AND COALESCE (View_Contract.PaidKindId, zc_Enum_PaidKind_SecondForm()) = zc_Enum_PaidKind_SecondForm();
       AND View_Contract.PaidKindId = zc_Enum_PaidKind_SecondForm();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MoneyPlace (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.14                         * add BankAccount
 05.01.14                                        * add zc_Enum_PaidKind_SecondForm
 05.01.14                                        * View_Contract.InfoMoneyId
 18.12.13                         *
 20.11.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MoneyPlace (inSession:= '2')
