-- Function: gpSelect_Object_ContractPartnerChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartnerChoice (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartnerChoice(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractStateKindCode Integer
             , InfoMoneyId Integer
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , OKPO TVarChar
             , ChangePercent TFloat
             , isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());

   RETURN QUERY
   SELECT
         Object_Contract_View.ContractId   AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Partner.Id             AS PartnerId
       , Object_Partner.ObjectCode     AS PartnerCode
       , Object_Partner.ValueData      AS PartnerName
       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName
       , Object_Contract_View.ContractStateKindCode

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , ObjectHistory_JuridicalDetails_View.OKPO
       , COALESCE (tmpChangePercent.changepercent,0)::TFloat  AS ChangePercent
       , Object_Contract_View.isErased

   FROM Object_Contract_View
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId

        JOIN ObjectLink AS ObjectLink_Partner_Juridical
                        ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId
                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

        LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.objectid

 		LEFT JOIN (
         SELECT
                ObjectFloat_Value.ValueData AS ChangePercent
              , Object_Contract.Id          AS ContractId

         FROM OBJECT AS Object_ContractCondition

         LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                              ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()

         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                              ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                             AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()

          JOIN Object AS Object_ContractConditionKind
                      ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                      AND Object_ContractConditionKind.Id = zc_Enum_ContractConditionKind_ChangePercent()

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()

     WHERE Object_ContractCondition.DescId = zc_Object_ContractCondition()
       AND Object_ContractCondition.isErased = FALSE

     ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId


        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

   WHERE COALESCE (Object_Contract_View.ContractStateKindId, 0) <> zc_Enum_ContractStateKind_Close()
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractPartnerChoice (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.02.14                                         * add zc_Enum_ContractStateKind_Close
 24.01.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractPartnerChoice (inSession := zfCalc_UserAdmin())
