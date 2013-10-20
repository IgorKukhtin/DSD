-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_Contract (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
             , ChangePercent TFloat, ChangePrice TFloat
             , Comment TVarChar
             , ContractKindName TVarChar, JuridicalCode Integer, JuridicalName TVarChar, PaidKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , isErased Boolean 
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Contract());

   RETURN QUERY 
   SELECT
         Object_Contract.Id               AS Id
       , Object_Contract.ValueData        AS InvNumber
       
       , ObjectDate_Signing.ValueData AS SigningDate
       , ObjectDate_Start.ValueData   AS StartDate
       , ObjectDate_End.ValueData     AS EndDate
       
       , ObjectFloat_ChangePercent.ValueData  AS ChangePercent
       , ObjectFloat_ChangePrice.ValueData    AS ChangePrice

       , ObjectString_Comment.ValueData   AS Comment

       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_PaidKind.ValueData     AS PaidKindName

       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_Contract.isErased         AS isErased
       
   FROM Object AS Object_Contract
        LEFT JOIN ObjectDate AS ObjectDate_Signing
                             ON ObjectDate_Signing.ObjectId = Object_Contract.Id
                            AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
        LEFT JOIN ObjectDate AS ObjectDate_Start
                             ON ObjectDate_Start.ObjectId = Object_Contract.Id
                            AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
        LEFT JOIN ObjectDate AS ObjectDate_End
                             ON ObjectDate_End.ObjectId = Object_Contract.Id
                            AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()                               
        LEFT JOIN ObjectFloat AS ObjectFloat_ChangePercent
                              ON ObjectFloat_ChangePercent.ObjectId = Object_Contract.Id
                             AND ObjectFloat_ChangePercent.DescId = zc_ObjectFloat_Contract_ChangePercent()  
        LEFT JOIN ObjectFloat AS ObjectFloat_ChangePrice
                              ON ObjectFloat_ChangePrice.ObjectId = Object_Contract.Id
                              AND ObjectFloat_ChangePrice.DescId = zc_ObjectFloat_Contract_ChangePrice()  
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract.Id
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract.Id 
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                             ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id 
                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                             ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id 
                            AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                             ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id 
                            AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

   WHERE Object_Contract.DescId = zc_Object_Contract();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Contract (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.13                                        * add from redmine
 22.07.13         * add  SigningDate, StartDate, EndDate               
 11.06.13         *
 12.04.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Contract (inSession := zfCalc_UserAdmin())
