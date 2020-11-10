-- Function: gpSelect_Object_ContractTradeMark_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractTradeMark (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractTradeMark (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractTradeMark(
    IN inisErased    Boolean ,      --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , isErased boolean
             , SigningDate TDateTime, StartDate_contract TDateTime, EndDate_contract TDateTime
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar
             , PersonalCollationId Integer, PersonalCollationCode Integer, PersonalCollationName TVarChar
             , ContractTagId Integer, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , AreaContractId Integer, AreaContractName TVarChar
             , ContractArticleId Integer, ContractArticleName TVarChar
             , ContractStateKindId Integer, ContractStateKindCode Integer
             , OKPO TVarChar
             , isDefault Boolean, isDefaultOut Boolean
             , isStandart Boolean
             , isPersonal Boolean
             , isUnique Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractTradeMark());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_ContractTradeMark.Id          AS Id
           , Object_ContractTradeMark.ObjectCode  AS Code
         
           , Object_Contract_View.ContractId      AS ContractId
           , Object_Contract_View.ContractCode    AS ContractCode
           , Object_Contract_View.InvNumber       AS ContractName

           , Object_TradeMark.Id                  AS TradeMarkId
           , Object_TradeMark.ValueData           AS TradeMarkName
       
           , Object_ContractTradeMark.isErased    AS isErased
           
           , ObjectDate_Signing.ValueData     AS SigningDate
           , Object_Contract_View.StartDate   AS StartDate_contract
           , Object_Contract_View.EndDate     AS EndDate_contract
       
           , Object_ContractKind.Id          AS ContractKindId
           , Object_ContractKind.ValueData   AS ContractKindName
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ObjectCode     AS JuridicalCode
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_JuridicalGroup.ValueData AS JuridicalGroupName

           , Object_JuridicalBasis.Id           AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

           , Object_PaidKind.Id            AS PaidKindId
           , Object_PaidKind.ValueData     AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyGroupCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationCode
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Personal_View.PersonalId    AS PersonalId
           , Object_Personal_View.PersonalCode  AS PersonalCode
           , Object_Personal_View.PersonalName  AS PersonalName
           
           , Object_PersonalTrade.PersonalId    AS PersonalTradeId
           , Object_PersonalTrade.PersonalCode  AS PersonalTradeCode
           , Object_PersonalTrade.PersonalName  AS PersonalTradeName
    
           , Object_PersonalCollation.PersonalId    AS PersonalCollationId
           , Object_PersonalCollation.PersonalCode  AS PersonalCollationCode
           , Object_PersonalCollation.PersonalName  AS PersonalCollationName
    
           , Object_Contract_View.ContractTagId
           , Object_Contract_View.ContractTagName
           , Object_Contract_View.ContractTagGroupName
    
           , Object_AreaContract.Id             AS AreaContractId
           , Object_AreaContract.ValueData      AS AreaContractName
    
           , Object_ContractArticle.Id          AS ContractArticleId
           , Object_ContractArticle.ValueData   AS ContractArticleName
    
           , Object_Contract_View.ContractStateKindId
           , Object_Contract_View.ContractStateKindCode
    
           , ObjectHistory_JuridicalDetails_View.OKPO
    
           , COALESCE (ObjectBoolean_Default.ValueData, False)      AS isDefault
           , COALESCE (ObjectBoolean_DefaultOut.ValueData, False)   AS isDefaultOut
           , COALESCE (ObjectBoolean_Standart.ValueData, False)     AS isStandart
    
           , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
           , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique
           
    FROM Object AS Object_ContractTradeMark
            LEFT JOIN ObjectLink AS ContractTradeMark_Contract
                                 ON ContractTradeMark_Contract.ObjectId = Object_ContractTradeMark.Id
                                AND ContractTradeMark_Contract.DescId = zc_ObjectLink_ContractTradeMark_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ContractTradeMark_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractTradeMark_TradeMark
                                 ON ObjectLink_ContractTradeMark_TradeMark.ObjectId = Object_ContractTradeMark.Id
                                AND ObjectLink_ContractTradeMark_TradeMark.DescId = zc_ObjectLink_ContractTradeMark_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_ContractTradeMark_TradeMark.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND Object_Contract_View.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
    
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                    ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DefaultOut
                                    ON ObjectBoolean_DefaultOut.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_DefaultOut.DescId = zc_ObjectBoolean_Contract_DefaultOut()
    
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                                    ON ObjectBoolean_Standart.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                                    ON ObjectBoolean_Personal.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                                    ON ObjectBoolean_Unique.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()
            
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId
            
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Contract_View.JuridicalId
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId
    
            LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                 ON ObjectLink_Contract_Personal.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               
    
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
            LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Contract_PersonalTrade.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId        
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_AreaContract
                                 ON ObjectLink_Contract_AreaContract.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_AreaContract.DescId = zc_ObjectLink_Contract_AreaContract()
            LEFT JOIN Object AS Object_AreaContract ON Object_AreaContract.Id = ObjectLink_Contract_AreaContract.ChildObjectId                     
                
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                                 ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
            LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
          
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

     WHERE Object_ContractTradeMark.DescId = zc_Object_ContractTradeMark()
      AND (Object_ContractTradeMark.isErased = FALSE OR inisErased = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.20         *
*/

-- тест
--SELECT * FROM gpSelect_Object_ContractTradeMark (false, zfCalc_UserAdmin())