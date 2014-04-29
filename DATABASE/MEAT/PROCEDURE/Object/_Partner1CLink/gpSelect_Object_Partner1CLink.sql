-- Function: gpSelect_Object_Partner1CLink(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner1CLink (TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_Partner1CLink(
    IN inSession     TVarChar       -- сессия пользователя
)                                                                	
RETURNS TABLE (PartnerId integer, PartnerCode Integer, PartnerName TVarChar
             , Id Integer, Code Integer, Name TVarChar
             , BranchId Integer, BranchName TVarChar
             , ContractId Integer, ContractNumber TVarChar, EndDate TDateTime
             , ContractTagName TVarChar, ContractStateKindCode Integer
             , JuridicalId Integer, JuridicalName TVarChar, OKPO TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner1CLink());
   
     RETURN QUERY 
       SELECT Object_Partner.Id                     AS PartnerId
            , Object_Partner.ObjectCode             AS PartnerCode
            , Object_Partner.ValueData              AS PartnerName
            , Object_Partner1CLink.Id               AS Id
            , Object_Partner1CLink.ObjectCode       AS Code
            , Object_Partner1CLink.ValueData        AS Name
            , Object_Branch.Id                      AS BranchId
            , Object_Branch.ValueData               AS BranchName
            , View_Contract_InvNumber.ContractId 
            , View_Contract_InvNumber.InvNumber     AS ContractNumber
            , ObjectDate_End.ValueData              AS EndDate
            , View_Contract_InvNumber.ContractTagName
            , View_Contract_InvNumber.ContractStateKindCode
            , Object_Juridical.Id                   AS JuridicalId
            , Object_Juridical.ValueData            AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO
            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
       FROM (SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
             FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                  INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                        ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId 
                                       AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             WHERE ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30101() -- "Готовая продукция"
               AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
             GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
            ) AS tmpJuridical
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpJuridical.JuridicalId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ChildObjectId = Object_Juridical.Id 
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ChildObjectId = Object_Partner.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
            LEFT JOIN Object AS Object_Partner1CLink ON Object_Partner1CLink.Id = ObjectLink_Partner1CLink_Partner.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Partner1CLink_Branch.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                 ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId   
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
      UNION ALL
       SELECT 0               AS PartnerId
            , 0               AS PartnerCode
            , '' :: TVarChar  AS PartnerName
            , Object_Partner1CLink.Id               AS Id
            , Object_Partner1CLink.ObjectCode       AS Code
            , Object_Partner1CLink.ValueData        AS Name
            , Object_Branch.Id                      AS BranchId
            , Object_Branch.ValueData               AS BranchName
            , View_Contract_InvNumber.ContractId 
            , View_Contract_InvNumber.InvNumber     AS ContractNumber
            , ObjectDate_End.ValueData              AS EndDate
            , View_Contract_InvNumber.ContractTagName
            , View_Contract_InvNumber.ContractStateKindCode
            , 0               AS JuridicalId
            , '' :: TVarChar  AS JuridicalName
            , '' :: TVarChar  AS OKPO
            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
       FROM Object AS Object_Partner1CLink
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Partner1CLink_Branch.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                 ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId   
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
       WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink()
         AND ObjectLink_Partner1CLink_Partner.ChildObjectId IS NULL
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner1CLink (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.14                                        * add UNION ALL 
 24.04.14                                        * all
 07.04.14                        * 
 17.02.14                        * 
 28.01.14                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner1CLink (zfCalc_UserAdmin()) WHERE Code = 1