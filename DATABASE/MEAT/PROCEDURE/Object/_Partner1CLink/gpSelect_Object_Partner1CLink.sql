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
       WITH tmpJuridical AS (SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                  , ObjectLink_Partner_Juridical.ObjectId       AS PartnerId
                             FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                                  INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                        ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId 
                                                       AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                             WHERE ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30101() -- "Готовая продукция"
                               AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
                                    , ObjectLink_Partner_Juridical.ObjectId
                            )
       /*WITH tmpJuridical AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                  , ObjectLink_Partner_Juridical.ObjectId       AS PartnerId
                             FROM Movement
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                               AND MovementLinkObject_From.ObjectId IN (8459)
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                             WHERE Movement.OperDate BETWEEN '01.11.2013' AND '01.11.2014'
                               AND Movement.DescId = zc_Movement_Sale()
                               AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                                   , ObjectLink_Partner_Juridical.ObjectId
                           UNION 
                             SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                  , ObjectLink_Partner_Juridical.ObjectId       AS PartnerId
                             FROM Movement
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                               AND MovementLinkObject_To.ObjectId IN (8459, 8461, 8462 )
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                             WHERE Movement.OperDate BETWEEN '01.11.2013' AND '01.11.2014'
                               AND Movement.DescId = zc_Movement_ReturnIn()
                               AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                                   , ObjectLink_Partner_Juridical.ObjectId
                           )*/
       SELECT Object_Partner.Id                     AS PartnerId
            , Object_Partner.ObjectCode             AS PartnerCode
            , Object_Partner.ValueData              AS PartnerName
            , Object_Partner1CLink.Id               AS Id
            , Object_Partner1CLink.ObjectCode       AS Code
            , Object_Partner1CLink.ValueData        AS Name
            , Object_Branch.Id                      AS BranchId
            , Object_Branch.BranchLinkName          AS BranchName
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
       FROM tmpJuridical
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpJuridical.JuridicalId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpJuridical.PartnerId

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ChildObjectId = Object_Partner.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
            LEFT JOIN Object AS Object_Partner1CLink ON Object_Partner1CLink.Id = ObjectLink_Partner1CLink_Partner.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
            LEFT JOIN Object_BranchLink_View AS Object_Branch ON Object_Branch.Id = ObjectLink_Partner1CLink_Branch.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                 ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId   
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
      UNION ALL
       SELECT Object_Partner.Id                     AS PartnerId
            , Object_Partner.ObjectCode             AS PartnerCode
            , Object_Partner.ValueData              AS PartnerName
            , Object_Partner1CLink.Id               AS Id
            , Object_Partner1CLink.ObjectCode       AS Code
            , Object_Partner1CLink.ValueData        AS Name
            , Object_Branch.Id                      AS BranchId
            , Object_Branch.BranchLinkName          AS BranchName
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
       FROM Object AS Object_Partner1CLink
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
            LEFT JOIN tmpJuridical ON tmpJuridical.PartnerId = ObjectLink_Partner1CLink_Partner.ChildObjectId

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
            LEFT JOIN Object_BranchLink_View AS Object_Branch ON Object_Branch.Id = ObjectLink_Partner1CLink_Branch.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                 ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId   
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
       WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink()
         AND tmpJuridical.PartnerId IS NULL
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner1CLink (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.05.14                                        * add tmpJuridical
 29.04.14                                        * add UNION ALL 
 24.04.14                                        * all
 07.04.14                        * 
 17.02.14                        * 
 28.01.14                        * 
*/
/*
delete from ObjectBoolean where ObjectId in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
delete from ObjectLink where ObjectId in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
delete from objectProtocol where ObjectId in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
delete from object where Id in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
*/
-- тест
-- SELECT * FROM gpSelect_Object_Partner1CLink (zfCalc_UserAdmin()) WHERE Code = 1
