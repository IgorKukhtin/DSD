-- FunctiON: gpReport_CheckBonus ()

DROP FUNCTION IF EXISTS gpReport_ContractEndDate (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ContractEndDate (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inFlag                Boolean   ,
    IN inSessiON             TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar, InvNumberArchive TVarChar

             , InvNumber_Key TVarChar, ContractStateKindCode_Key Integer

             , Comment TVarChar, BankAccountExternal TVarChar
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
                         
             , ContractKindName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , JuridicalBasisName TVarChar
             
             , PaidKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PersonalCode Integer, PersonalName TVarChar
             
             , PersonalTradeCode Integer, PersonalTradeName TVarChar
             , PersonalCollationCode Integer, PersonalCollationName TVarChar
             , BankAccountName TVarChar
             , ContractTagName TVarChar
                          
             , AreaName TVarChar
             , ContractArticleName TVarChar
             , ContractStateKindCode Integer
             , OKPO TVarChar
             , BankName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isDefault Boolean
             , isStandart Boolean
             , isPersonal Boolean
             , isUnique Boolean

             , DocumentCount TFloat, DateDocument TDateTime

             , isErased Boolean 
              )  
AS
$BODY$
BEGIN

    RETURN QUERY
   
   SELECT
         Object_Contract_View.ContractId   AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive

       , View_Contract_InvNumber_Key.InvNumber             AS InvNumber_Key
       , View_Contract_InvNumber_Key.ContractStateKindCode AS ContractStateKindCode_Key

       , ObjectString_Comment.ValueData            AS Comment 
       , ObjectString_BankAccount.ValueData        AS BankAccountExternal

       , ObjectDate_Signing.ValueData AS SigningDate
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName

       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

       , Object_PaidKind.ValueData     AS PaidKindName

       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_Personal_View.PersonalCode  AS PersonalCode
       , Object_Personal_View.PersonalName  AS PersonalName
       
       , Object_PersonalTrade.PersonalCode  AS PersonalTradeCode
       , Object_PersonalTrade.PersonalName  AS PersonalTradeName

       , Object_PersonalCollation.PersonalCode  AS PersonalCollationCode
       , Object_PersonalCollation.PersonalName  AS PersonalCollationName

       , Object_BankAccount.ValueData       AS BankAccountName

       , Object_Contract_View.ContractTagName

       , Object_Area.ValueData              AS AreaName

       , Object_ContractArticle.ValueData   AS ContractArticleName

       , Object_Contract_View.ContractStateKindCode

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_Bank.ValueData   AS BankName

       , Object_Insert.ValueData   AS InsertName
       , Object_Update.ValueData   AS UpdateName
       , ObjectDate_Protocol_Insert.ValueData AS InsertDate
       , ObjectDate_Protocol_Update.ValueData AS UpdateDate
       
       , COALESCE (ObjectBoolean_Default.ValueData, False)  AS isDefault
       , COALESCE (ObjectBoolean_Standart.ValueData, False) AS isStandart

       , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
       , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique
       
       , ObjectFloat_DocumentCount.ValueData AS DocumentCount
       , ObjectDate_Document.ValueData AS DateDocument

       , Object_Contract_View.isErased
       
   FROM Object_Contract_View
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
        
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
        LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId
        
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
                
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                             ON ObjectLink_Contract_Area.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId                     
            
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                             ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
        LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
      
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Bank
                             ON ObjectLink_Contract_Bank.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_Bank.DescId = zc_ObjectLink_Contract_Bank()
        LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Contract_Bank.ChildObjectId   

        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
        JOIN Object_Contract_InvNumber_Key_View AS View_Contract_InvNumber_Key 
                                                     ON View_Contract_InvNumber_Key.ContractId = Object_Contract_View.ContractId
                                                    AND View_Contract_InvNumber_Key.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
   WHERE Object_Contract_View.isErased = False
     AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
     AND ((Object_Contract_View.EndDate BETWEEN inStartDate AND inEndDate) OR (Object_Contract_View.EndDate<inStartDate and inFlag=True))

  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_ContractEndDate (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 31.08.14         *
*/

-- òåñò
-- select * from gpReport_ContractEndDate (inStartDate:= '03.09.2014', inEndDate:= '30.09.2014', inFlag:=False, inSession:= zfCalc_UserAdmin());
