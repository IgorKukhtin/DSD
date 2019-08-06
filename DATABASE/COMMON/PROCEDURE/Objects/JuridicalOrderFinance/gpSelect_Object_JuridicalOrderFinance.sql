-- Function: gpSelect_Object_JuridicalOrderFinance()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalOrderFinance(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalOrderFinance(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , BankAccountId Integer, BankAccountCode Integer, BankAccountName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , InfoMoneyName_all TVarChar
             , SummOrderFinance TFloat
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalOrderFinance());

   RETURN QUERY 

       SELECT Object_JuridicalOrderFinance.Id   AS Id

            , Object_Juridical.Id              AS JuridicalId
            , Object_Juridical.ObjectCode      AS JuridicalCode
            , Object_Juridical.ValueData       AS JuridicalName

            , Object_BankAccount.Id            AS BankAccountId
            , Object_BankAccount.ObjectCode    AS BankAccountCode
            , Object_BankAccount.ValueData     AS BankAccountName
            
            , Object_InfoMoney_View.InfoMoneyGroupName
            , Object_InfoMoney_View.InfoMoneyDestinationName
            , Object_InfoMoney_View.InfoMoneyId
            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyName_all
            
            , ObjectFloat_SummOrderFinance.ValueData :: TFloat AS SummOrderFinance
           
            , Object_JuridicalOrderFinance.isErased  AS isErased

       FROM Object AS Object_JuridicalOrderFinance
           LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                               AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = OL_JuridicalOrderFinance_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                               AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = OL_JuridicalOrderFinance_BankAccount.ChildObjectId
          
           LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                               AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = OL_JuridicalOrderFinance_InfoMoney.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderFinance
                                 ON ObjectFloat_SummOrderFinance.ObjectId = Object_JuridicalOrderFinance.Id
                                AND ObjectFloat_SummOrderFinance.DescId = zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance()

       WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalOrderFinance ('2')