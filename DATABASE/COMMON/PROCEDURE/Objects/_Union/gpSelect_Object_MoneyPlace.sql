-- Function: gpSelect_Object_MoneyPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar, ContractStateKindCode Integer, StartDate TDateTime, EndDate TDateTime
             , ContractTagName TVarChar, ContractKindName TVarChar
             , OKPO TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     WITH tmpUserTransport AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Transport())
        , View_InfoMoney_40801 AS (SELECT * FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyCode = 40801) -- Внутренний оборот
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
          , NULL::Integer AS PaidKindId
          , ''::TVarChar  AS PaidKindName
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , ''::TVarChar AS OKPO
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
          LEFT JOIN View_InfoMoney_40801 AS View_InfoMoney ON 1 = 1
     WHERE Object_Cash.DescId = zc_Object_Cash()
       AND Object_Cash.isErased = FALSE
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
          , NULL::Integer AS PaidKindId
          , ''::TVarChar  AS PaidKindName
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , ''::TVarChar    AS OKPO
     FROM Object_BankAccount_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_BankAccount()
          LEFT JOIN View_InfoMoney_40801 AS View_InfoMoney ON 1 = 1
     WHERE (Object_BankAccount_View.JuridicalId IN (zc_Juridical_Basis()
                                                  , 15505 -- ДУКО ТОВ 
                                                  , 15512 -- Ірна-1 Фірма ТОВ
                                                   )
         OR Object_BankAccount_View.isCorporate = TRUE
           )
       AND Object_BankAccount_View.isErased = FALSE
    /*UNION ALL
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
          , NULL::Integer AS PaidKindId
          , ''::TVarChar  AS PaidKindName
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , ''::TVarChar AS OKPO
     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
    WHERE Object_Member.DescId = zc_Object_Member()
      AND Object_Member.isErased = FALSE*/
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
          , Object_PaidKind.Id            AS PaidKindId
          , Object_PaidKind.ValueData     AS PaidKindName
          , View_Contract.ContractId 
          , View_Contract.ContractCode
          , View_Contract.InvNumber
          , View_Contract.ContractStateKindCode
          , View_Contract.StartDate
          , View_Contract.EndDate
          , View_Contract.ContractTagName
          , View_Contract.ContractKindName
          , ObjectHistory_JuridicalDetails_View.OKPO
     FROM Object AS Object_Juridical
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = Object_Juridical.Id 
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       -- AND COALESCE (View_Contract.PaidKindId, zc_Enum_PaidKind_SecondForm()) = zc_Enum_PaidKind_SecondForm();
       AND ((View_Contract.PaidKindId = zc_Enum_PaidKind_SecondForm() AND vbUserId IN (SELECT UserId FROM tmpUserTransport))
          OR View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
           )
       -- AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
       AND View_Contract.isErased = FALSE
       AND Object_Juridical.isErased = FALSE
    UNION ALL
     SELECT Object_PersonalServiceList.Id       
          , Object_PersonalServiceList.ObjectCode     
          , Object_PersonalServiceList.ValueData
          , ObjectDesc.ItemName
          , Object_PersonalServiceList.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , NULL::Integer AS PaidKindId
          , ''::TVarChar  AS PaidKindName
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , ''::TVarChar AS OKPO
     FROM Object AS Object_PersonalServiceList
          INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
                               AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PersonalServiceList.DescId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_60101() -- Заработная плата
    WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
      AND Object_PersonalServiceList.isErased = FALSE
    -- Физ Лица
    UNION ALL
     SELECT Object_Member.Id       
          , Object_Member.ObjectCode     
          , Object_Member.ValueData
          , ObjectDesc.ItemName
          , Object_Member.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , NULL::Integer AS PaidKindId
          , ''::TVarChar  AS PaidKindName
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , ObjectString_INN.ValueData ::TVarChar AS OKPO   --INN 
     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_60104() -- Удержания сторон. юр.л.

          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Member.Id
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
    WHERE Object_Member.DescId = zc_Object_Member()
      AND Object_Member.isErased = FALSE
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MoneyPlace (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.09.19         * add INN для Member
 29.08.14                                        * add InfoMoneyName_all
 20.05.14                                        * change ContractKindName
 25.04.14                                        * add ContractTagName
 18.04.14                                        * rem View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
 18.03.14                                        * add all
 13.02.14                                        * add ObjectHistory_JuridicalDetails_View and ContractStateKindCode and InfoMoney...
 22.01.14                                        * add tmpUserTransport
 15.01.14                         * add BankAccount
 05.01.14                                        * add zc_Enum_PaidKind_SecondForm
 05.01.14                                        * View_Contract.InfoMoneyId
 18.12.13                         *
 20.11.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MoneyPlace (inSession:= '2')
