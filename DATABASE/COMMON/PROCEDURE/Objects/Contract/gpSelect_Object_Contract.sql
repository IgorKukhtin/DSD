-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_Contract (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar, InvNumberArchive TVarChar
             , Comment TVarChar, BankAccount TVarChar
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
                         
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , AreaId Integer, AreaName TVarChar
             , ContractArticleId Integer, ContractArticleName TVarChar
             , ContractStateKindCode Integer
             , OKPO TVarChar
             , BankId Integer, BankName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , Default Boolean
             , isErased Boolean 
              )
AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());

   RETURN QUERY 
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       
       , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive
       , ObjectString_Comment.ValueData            AS Comment 
       , ObjectString_BankAccount.ValueData        AS BankAccount
      
       , ObjectDate_Signing.ValueData AS SigningDate
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       
       , Object_ContractKind.Id        AS ContractKindId 
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName

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

       , Object_Area.Id                     AS AreaId
       , Object_Area.ValueData              AS AreaName

       , Object_ContractArticle.Id          AS ContractArticleId
       , Object_ContractArticle.ValueData   AS ContractArticleName

       , Object_ContractStateKind.ObjectCode AS ContractStateKindCode

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_Bank.Id          AS BankId
       , Object_Bank.ValueData   AS BankName

       , Object_Insert.ValueData   AS InsertName
       , Object_Update.ValueData   AS UpdateName
       , ObjectDate_Protocol_Insert.ValueData AS InsertDate
       , ObjectDate_Protocol_Update.ValueData AS UpdateDate
       
       , ObjectBoolean_Default.ValueData AS Default
       
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

        LEFT JOIN ObjectString AS ObjectString_BankAccount
                               ON ObjectString_BankAccount.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_BankAccount.DescId = zc_objectString_Contract_BankAccount()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
        
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
        LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId
        
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
   ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Contract (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.03.14         * add zc_ObjectBoolean_Contract_Default
 25.02.14                                        * add zc_ObjectDate_Protocol_... and zc_ObjectLink_Protocol_...
 21.02.14         * add Bank, BankAccount
 09.01.14         * add PaidKindId
 06.01.14                                        * add OKPO
 14.11.13         * add from redmaine               
 20.10.13                                        * add Object_Contract_View
 20.10.13                                        * add from redmine
 22.07.13         * add  SigningDate, StartDate, EndDate               
 11.06.13         *
 12.04.13                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Contract (inSession := zfCalc_UserAdmin())
