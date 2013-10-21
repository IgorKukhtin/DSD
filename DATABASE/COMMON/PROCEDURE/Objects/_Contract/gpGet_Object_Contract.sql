-- Function: gpGet_Object_Contract()

DROP FUNCTION IF EXISTS gpGet_Object_Contract (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract(
    IN inId             Integer,       -- ключ объекта <Договор>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
             , ChangePercent TFloat, ChangePrice TFloat
             , Comment TVarChar
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Contract());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             0 :: Integer    AS Id
           , '' :: TVarChar  AS InvNumber
           , CURRENT_DATE :: TDateTime AS SigningDate
           , CURRENT_DATE :: TDateTime AS StartDate
           , CURRENT_DATE :: TDateTime AS EndDate

           , 0 :: TFloat AS ChangePercent
           , 0 :: TFloat AS ChangePrice
           
           , '' :: TVarChar   AS Comment

           , 0 :: Integer   AS ContractKindId
           , '' :: TVarChar AS ContractKindName
           , 0 :: Integer   AS JuridicalId
           , '' :: TVarChar AS JuridicalName
           , 0 :: Integer   AS PaidKindId
           , '' :: TVarChar AS PaidKindName
           , 0 :: Integer   AS InfoMoneyId
           , '' :: TVarChar AS InfoMoneyName

           , NULL :: Boolean  AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_Contract_View.ContractId AS Id
           , Object_Contract_View.InvNumber

           , ObjectDate_Signing.ValueData AS SigningDate
           , Object_Contract_View.StartDate
           , Object_Contract_View.EndDate

           , Object_Contract_View.ChangePercent
           , Object_Contract_View.ChangePrice
           
           , ObjectString_Comment.ValueData   AS Comment

           , Object_ContractKind.Id        AS ContractKindId
           , Object_ContractKind.ValueData AS ContractKindName
           , Object_Juridical.Id           AS JuridicalId
           , Object_Juridical.ValueData    AS JuridicalName
           , Object_PaidKind.Id            AS PaidKindId
           , Object_PaidKind.ValueData     AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyId
           , (   '(' || Object_InfoMoney_View.InfoMoneyCode :: TVarChar
              || ') '|| Object_InfoMoney_View.InfoMoneyGroupName
              || ' ' || Object_InfoMoney_View.InfoMoneyDestinationName
              || ' ' || Object_InfoMoney_View.InfoMoneyName
             ) :: TVarChar AS InfoMoneyName

           , Object_Contract_View.isErased

       FROM Object_Contract_View
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

       WHERE Object_Contract_View.ContractId = inId;

   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.13                                        * add from redmaine
 22.07.13         * add  SigningDate, StartDate, EndDate 
 11.06.13         *
 12.04.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Contract (inId := 2, inSession := zfCalc_UserAdmin())
