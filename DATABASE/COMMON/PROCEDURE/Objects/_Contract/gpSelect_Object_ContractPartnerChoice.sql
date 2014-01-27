-- Function: gpSelect_Object_ContractPartnerChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartnerChoice (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartnerChoice(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , OKPO TVarChar
             , Address TVarChar
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
         Object_Contract_View.ContractId AS ContractId
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Partner.Id             AS PartnerId
       , Object_Partner.ObjectCode     AS PartnerCode
       , Object_Partner.ValueData      AS PartnerName
       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName
       , Object_PriceList.Id           AS PriceListId
       , Object_PriceList.ValueData    AS PriceListName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , ObjectHistory_JuridicalDetails_View.OKPO
       , ObjectString_Address.ValueData  AS Address
       , COALESCE (tmpChangePercent.changepercent,0)::TFloat  AS ChangePercent
       , Object_Contract_View.isErased

   FROM Object_Contract_View
        LEFT JOIN ObjectDate AS ObjectDate_Signing
                             ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

        LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                               ON ObjectString_InvNumberArchive.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

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
       AND Object_ContractCondition.isErased = False

     ) AS tmpChangePercent ON tmpChangePercent.contractid = Object_Contract_View.ContractId


        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                            ON ObjectLink_Contract_Personal.ObjectId = Object_Contract_View.ContractId
                           AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
        LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                             ON ObjectLink_Contract_Area.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                             ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
        LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                             ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind()
        LEFT JOIN Object AS Object_ContractStateKind ON Object_ContractStateKind.Id = ObjectLink_Contract_ContractStateKind.ChildObjectId

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id


        LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                             ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id
                            AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
        LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Partner_PriceList.ChildObjectId


        LEFT JOIN ObjectString AS ObjectString_Address
                               ON ObjectString_Address.ObjectId = Object_Partner.Id
                              AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()


   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractPartnerChoice (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.01.14                                                        *
*/

-- тест
 SELECT * FROM gpSelect_Object_ContractPartnerChoice (inSession := zfCalc_UserAdmin())