-- Function: gpSelect_Object_GoodsListSale_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsListSale_all (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsListSale_all(
    IN inRetailId      Integer , -- торговая сеть
    IN inContractId    Integer , -- договор
    IN inJuridicalId   Integer , -- юр. лицо
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsName TVarChar
             , ContractId Integer, ContractCode Integer, InvNumber TVarChar
             , isErased boolean

             , InvNumberArchive TVarChar

             , ContractKeyId Integer, ContractId_Key Integer, Code_Key Integer
             , InvNumber_Key TVarChar, ContractStateKindCode_Key Integer

             , Comment TVarChar, BankAccountExternal TVarChar, GLNCode TVarChar
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
                         
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , JuridicalDocumentId Integer, JuridicalDocumentCode Integer, JuridicalDocumentName TVarChar
             , RetailId Integer, RetailName TVarChar
             
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             
             , PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar
             , PersonalCollationId Integer, PersonalCollationCode Integer, PersonalCollationName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , ContractTagId Integer, ContractTagName TVarChar, ContractTagGroupName TVarChar
                          
             , AreaContractId Integer, AreaContractName TVarChar
             , ContractArticleId Integer, ContractArticleName TVarChar
             , ContractStateKindId Integer, ContractStateKindCode Integer
             , OKPO TVarChar
             , BankId Integer, BankName TVarChar
             
             , UpdateDate TDateTime
             , isDefault Boolean
             , isStandart Boolean
             , isPersonal Boolean
             , isUnique Boolean

             , DocumentCount TFloat, DateDocument TDateTime
         
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsListSale());
     vbUserId:= lpGetUserBySession (inSession);
  
     -- Результат
     RETURN QUERY 
       SELECT 
             Object_GoodsListSale.Id          AS Id

           , Object_Goods.Id         AS GoodsId
           , Object_Goods.ValueData  AS GoodsName

           , Object_Contract_View.ContractId    AS ContractId
           , Object_Contract_View.ContractCode  AS ContractCode
           , Object_Contract_View.InvNumber     AS InvNumber
      
           , Object_GoodsListSale.isErased      AS isErased


           , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive
  
           , View_Contract_InvNumber_Key.ContractKeyId
           , View_Contract_InvNumber_Key.ContractId_Key        AS ContractId_Key
           , View_Contract_InvNumber_Key.ContractCode          AS Code_Key
           , View_Contract_InvNumber_Key.InvNumber             AS InvNumber_Key
           , View_Contract_InvNumber_Key.ContractStateKindCode AS ContractStateKindCode_Key

           , ObjectString_Comment.ValueData            AS Comment 
           , ObjectString_BankAccount.ValueData        AS BankAccountExternal
           , ObjectString_GLNCode.ValueData            AS GLNCode 

           , ObjectDate_Signing.ValueData AS SigningDate
           , Object_Contract_View.StartDate
           , Object_Contract_View.EndDate
       
           , Object_ContractKind.Id          AS ContractKindId
           , Object_ContractKind.ValueData   AS ContractKindName
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ObjectCode     AS JuridicalCode
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_JuridicalGroup.ValueData AS JuridicalGroupName

           , Object_JuridicalBasis.Id           AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

           , Object_JuridicalDocument.Id             AS JuridicalDocumentId
           , Object_JuridicalDocument.ObjectCode     AS JuridicalDocumentCode
           , Object_JuridicalDocument.ValueData      AS JuridicalDocumentName

           , Object_Retail.Id                AS RetailId
           , Object_Retail.ValueData         AS RetailName

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

           , Object_BankAccount.Id              AS BankAccountId
           , Object_BankAccount.ValueData       AS BankAccountName

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

           , Object_Bank.Id          AS BankId
           , Object_Bank.ValueData   AS BankName

           , ObjectDate_Protocol_Update.ValueData AS UpdateDate
       
           , COALESCE (ObjectBoolean_Default.ValueData, False)  AS isDefault
           , COALESCE (ObjectBoolean_Standart.ValueData, False) AS isStandart

           , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
           , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique
       
           , ObjectFloat_DocumentCount.ValueData AS DocumentCount
           , ObjectDate_Document.ValueData AS DateDocument

    FROM Object AS Object_GoodsListSale
        INNER JOIN ObjectLink AS GoodsListSale_Contract
                              ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                             AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
                             AND (GoodsListSale_Contract.ChildObjectId = inContractId OR inContractId = 0)
        LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = GoodsListSale_Contract.ChildObjectId
 
        INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                              ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                             AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
                             AND (ObjectLink_GoodsListSale_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_GoodsListSale_Juridical.ChildObjectId
            
--
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                        --     AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
--
        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsListSale.Id
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
                                                                              
        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                             ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsListSale_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                             ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
        LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_GoodsListSale_Partner.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Signing
                             ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                            AND Object_Contract_View.InvNumber <> '-'
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_DocumentCount
                              ON ObjectFloat_DocumentCount.ObjectId = Object_Contract_View.ContractId
                             AND ObjectFloat_DocumentCount.DescId = zc_ObjectFloat_Contract_DocumentCount()
        LEFT JOIN ObjectDate AS ObjectDate_Document
                             ON ObjectDate_Document.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Document.DescId = zc_ObjectDate_Contract_Document()

        LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                               ON ObjectString_InvNumberArchive.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN ObjectString AS ObjectString_BankAccount
                               ON ObjectString_BankAccount.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_BankAccount.DescId = zc_objectString_Contract_BankAccount()
                              
        LEFT JOIN ObjectString AS ObjectString_GLNCode
                               ON ObjectString_GLNCode.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_GLNCode.DescId = zc_objectString_Contract_GLNCode()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                                ON ObjectBoolean_Standart.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                                ON ObjectBoolean_Personal.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                                ON ObjectBoolean_Unique.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()
        
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
        LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
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
        
        LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                             ON ObjectLink_Contract_BankAccount.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
        LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId
                
        LEFT JOIN ObjectLink AS ObjectLink_Contract_AreaContract
                             ON ObjectLink_Contract_AreaContract.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_AreaContract.DescId = zc_ObjectLink_Contract_AreaContract()
        LEFT JOIN Object AS Object_AreaContract ON Object_AreaContract.Id = ObjectLink_Contract_AreaContract.ChildObjectId                     
            
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                             ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
        LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
      
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Bank
                             ON ObjectLink_Contract_Bank.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_Bank.DescId = zc_ObjectLink_Contract_Bank()
        LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Contract_Bank.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                             ON ObjectLink_Contract_JuridicalDocument.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
        LEFT JOIN Object AS Object_JuridicalDocument ON Object_JuridicalDocument.Id = ObjectLink_Contract_JuridicalDocument.ChildObjectId

       LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
        LEFT JOIN Object_Contract_InvNumber_Key_View AS View_Contract_InvNumber_Key ON View_Contract_InvNumber_Key.ContractId = Object_Contract_View.ContractId
           
     WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
       AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.16         * 
        
*/

-- тест
--SELECT * FROM gpSelect_Object_GoodsListSale_all (0,0,0,zfCalc_UserAdmin())