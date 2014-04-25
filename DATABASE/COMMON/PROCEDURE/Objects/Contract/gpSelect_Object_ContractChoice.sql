-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractChoice (Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractChoice(
    IN inPaidKindId     Integer,       -- Форма оплаты
    IN inShowAll        Boolean,       --
    IN inJuridicalId    Integer,       -- Юр лицо
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagName TVarChar, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractStateKindCode Integer
             , OKPO TVarChar
             , isErased Boolean 
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());

   --
   CREATE TEMP TABLE _tmpPaidKind (PaidKindId Integer, PaidKindName TVarChar) ON COMMIT DROP;
   IF COALESCE (inPaidKindId,0) <> 0 
   THEN 
       INSERT INTO _tmpPaidKind (PaidKindId, PaidKindName)
          SELECT Object.Id, Object.ValueData FROM Object WHERE Id = inPaidKindId;
   ELSE 
       INSERT INTO _tmpPaidKind (PaidKindId, PaidKindName)
          SELECT Object.Id, Object.ValueData FROM Object WHERE DescId = zc_Object_PaidKind();
   END IF;


   IF inShowAll= TRUE THEN
   
   RETURN QUERY 
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_Contract_View.ContractStateKindCode

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_Contract_View.isErased
       
   FROM _tmpPaidKind
        INNER JOIN Object_Contract_View ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
                                       AND Object_Contract_View.isErased = FALSE
                                       AND (Object_Contract_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
   ;

   ELSE
   
   RETURN QUERY 
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_Contract_View.ContractStateKindCode

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_Contract_View.isErased
       
   FROM _tmpPaidKind
        INNER JOIN Object_Contract_View ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
                                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                       AND Object_Contract_View.isErased = FALSE
                                       AND (Object_Contract_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
   ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractChoice (Integer, Boolean, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.04.14                                        * add ContractTagName
 27.03.14                         * add inJuridicalId
 27.02.14         * add inPaidKindId,inShowAll
 13.02.14                                         * add zc_Enum_ContractStateKind_Close
 13.02.14                                         * change Object_Contract_View.ContractStateKindCode
 06.01.14                                         * add OKPO
 18.11.13                         *                
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractChoice (inPaidKindId:=NULL, inShowAll:= true, inSession := zfCalc_UserAdmin())
