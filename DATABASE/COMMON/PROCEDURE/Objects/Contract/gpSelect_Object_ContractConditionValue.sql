-- Function: gpSelect_Object_ContractConditionValue()

--DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionValue (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionValue (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionValue(
    IN inJuridicalId    Integer,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar, InvNumberArchive TVarChar
             , Comment TVarChar , BankAccountExternal TVarChar 
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
                         
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             
             , PaidKindId Integer, PaidKindName TVarChar, PaidKindName_Condition TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , AreaId Integer, AreaName TVarChar
             , ContractArticleId Integer, ContractArticleName TVarChar
             , ContractTagName TVarChar
             , ContractStateKindCode Integer 
             , OKPO TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar  
             , BonusKindId Integer, BonusKindName TVarChar
             , BankId Integer, BankName TVarChar
             , ContractConditionId Integer, ContractConditionComment TVarChar 
             , Value TFloat
             , StartDate_ch TDateTime, EndDate_ch TDateTime
             , InfoMoneyGroupCode_ch Integer, InfoMoneyGroupName_ch TVarChar
             , InfoMoneyDestinationCode_ch Integer, InfoMoneyDestinationName_ch TVarChar
             , InfoMoneyId_ch Integer, InfoMoneyCode_ch Integer, InfoMoneyName_ch TVarChar

             , ContractSendId Integer, ContractSendName TVarChar 
             , ContractStateKindCode_Send Integer
             , ContractTagName_Send TVarChar             
             , InfoMoneyCode_Send Integer, InfoMoneyName_Send TVarChar
             , JuridicalCode_Send Integer, JuridicalName_Send TVarChar

             , isDefault Boolean, isDefaultOut Boolean, isStandart Boolean
             , isPersonal Boolean, isUnique Boolean
             , isErased Boolean 
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractConditionValue());

   RETURN QUERY 
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       
       , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive
       , ObjectString_Comment.ValueData   AS Comment 
       , ObjectString_BankAccount.ValueData        AS BankAccountExternal

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

       , Object_PaidKind.Id                   AS PaidKindId
       , Object_PaidKind.ValueData            AS PaidKindName
       , Object_PaidKind_Condition.ValueData  AS PaidKindName_Condition

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName 

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

       , Object_Contract_View.ContractTagName
       , Object_Contract_View.ContractStateKindCode

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_ContractConditionKind.Id        AS ContractConditionKindId
       , Object_ContractConditionKind.ValueData AS ContractConditionKindName

       , Object_BonusKind.Id               AS BonusKindId
       , Object_BonusKind.ValueData        AS BonusKindName

       , Object_Bank.Id               AS BankId
       , Object_Bank.ValueData        AS BankName

       , tmpContractCondition.ContractConditionId
       , tmpContractCondition.Comment      AS ContractConditionComment
       , ObjectFloat_Value.ValueData       AS Value

       , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate_ch
       , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate_ch

       , View_InfoMoney_ContractCondition.InfoMoneyGroupCode AS InfoMoneyGroupCode_ch
       , View_InfoMoney_ContractCondition.InfoMoneyGroupName AS InfoMoneyGroupName_ch
       , View_InfoMoney_ContractCondition.InfoMoneyDestinationCode AS InfoMoneyDestinationCode_ch
       , View_InfoMoney_ContractCondition.InfoMoneyDestinationName AS InfoMoneyDestinationName_ch
       , View_InfoMoney_ContractCondition.InfoMoneyId   AS InfoMoneyId_ch
       , View_InfoMoney_ContractCondition.InfoMoneyCode AS InfoMoneyCode_ch
       , View_InfoMoney_ContractCondition.InfoMoneyName AS InfoMoneyName_ch

       , Object_ContractSend.Id               AS ContractSendId
       , Object_ContractSend.ValueData        AS ContractSendName
       , Object_ContractSendStateKind.ObjectCode  AS ContractStateKindCode_Send
     
       , Object_ContractSendTag.ValueData     AS ContractTagName_Send
       , Object_InfoMoneySend.ObjectCode      AS InfoMoneyCode_Send
       , Object_InfoMoneySend.ValueData       AS InfoMoneyName_Send 
       , Object_JuridicalSend.ObjectCode      AS JuridicalCode_Send
       , Object_JuridicalSend.ValueData       AS JuridicalName_Send 

       , COALESCE (ObjectBoolean_Default.ValueData, False)      AS isDefault
       , COALESCE (ObjectBoolean_DefaultOut.ValueData, False)   AS isDefaultOut
       , COALESCE (ObjectBoolean_Standart.ValueData, False)     AS isStandart

       , COALESCE (ObjectBoolean_Personal.ValueData, False)  AS isPersonal
       , COALESCE (ObjectBoolean_Unique.ValueData, False)    AS isUnique

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
        
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                            ON ObjectLink_Contract_Personal.ObjectId = Object_Contract_View.ContractId
                           AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
        LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                             ON ObjectLink_Contract_Area.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_AreaContract()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId                     
            
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                             ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
        LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
      
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Bank
                             ON ObjectLink_Contract_Bank.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_Bank.DescId = zc_ObjectLink_Contract_Bank()
        LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Contract_Bank.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

        LEFT JOIN (SELECT Object_ContractCondition.Id AS ContractConditionId
                        , Object_ContractCondition.ValueData AS Comment
                        , ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                   FROM Object AS Object_ContractCondition
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                             ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                            AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE Object_ContractCondition.DescId = zc_Object_ContractCondition()
                     AND Object_ContractCondition.isErased = FALSE
                  ) AS tmpContractCondition ON tmpContractCondition.ContractId = Object_Contract_View.ContractId
          
        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                             ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = tmpContractCondition.ContractConditionId
                            AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
        LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                             ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                            AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
        LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                             ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                            AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
        LEFT JOIN Object AS Object_ContractSend ON Object_ContractSend.Id = ObjectLink_ContractCondition_ContractSend.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ContractSend_Juridical
                             ON ObjectLink_ContractSend_Juridical.ObjectId = Object_ContractSend.Id 
                            AND ObjectLink_ContractSend_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
        LEFT JOIN Object AS Object_JuridicalSend ON Object_JuridicalSend.Id = ObjectLink_ContractSend_Juridical.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ContractSend_ContractTag
                             ON ObjectLink_ContractSend_ContractTag.ObjectId = Object_ContractSend.Id
                            AND ObjectLink_ContractSend_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
        LEFT JOIN Object AS Object_ContractSendTag ON Object_ContractSendTag.Id = ObjectLink_ContractSend_ContractTag.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ContractSend_ContractStateKind
                             ON ObjectLink_ContractSend_ContractStateKind.ObjectId = Object_ContractSend.Id
                            AND ObjectLink_ContractSend_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind() 
        LEFT JOIN Object AS Object_ContractSendStateKind ON Object_ContractSendStateKind.Id = ObjectLink_ContractSend_ContractStateKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ContractSend_InfoMoney
                             ON ObjectLink_ContractSend_InfoMoney.ObjectId = Object_ContractSend.Id
                            AND ObjectLink_ContractSend_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
        LEFT JOIN Object AS Object_InfoMoneySend ON Object_InfoMoneySend.Id = ObjectLink_ContractSend_InfoMoney.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                              ON ObjectFloat_Value.ObjectId = tmpContractCondition.ContractConditionId
                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()

        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                             ON ObjectLink_ContractCondition_InfoMoney.ObjectId = tmpContractCondition.ContractConditionId
                            AND ObjectLink_ContractCondition_InfoMoney.DescId = zc_ObjectLink_ContractCondition_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_ContractCondition ON View_InfoMoney_ContractCondition.InfoMoneyId = ObjectLink_ContractCondition_InfoMoney.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                             ON ObjectLink_ContractCondition_PaidKind.ObjectId = tmpContractCondition.ContractConditionId
                            AND ObjectLink_ContractCondition_PaidKind.DescId   = zc_ObjectLink_ContractCondition_PaidKind()
        LEFT JOIN Object AS Object_PaidKind_Condition ON Object_PaidKind_Condition.Id = ObjectLink_ContractCondition_PaidKind.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_StartDate
                             ON ObjectDate_StartDate.ObjectId = tmpContractCondition.ContractConditionId
                            AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
        LEFT JOIN ObjectDate AS ObjectDate_EndDate
                             ON ObjectDate_EndDate.ObjectId = tmpContractCondition.ContractConditionId
                            AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()
   WHERE Object_Contract_View.JuridicalId = inJuridicalId OR inJuridicalId = 0
   ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_ContractConditionValue (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.20         * add inJuridicalId
 18.01.19         * DefaultOut
 13.04.16         *
 02.03.16         *
 23.05.14         * add zc_ObjectBoolean_Contract_Personal
                        zc_ObjectBoolean_Contract_Unique
 20.05.14                                        * !!!ContractKindName - всегда!!!
 20.05.14                                        * add Object_Contract_View.InvNumber <> '-'
 25.04.14                                        * rename BankAccountExternal
 25.04.14                                        * add ContractTagName
 17.04.14                                        * add InfoMoney..._ch
 14.03.14         * add isStandart
 14.03.14         * add isDefault
 21.02.14         * add Bank, BankAccount
 14.02.14                                        * add Object_ContractCondition.isErased = FALSE
 11.02.14                         * add ContractStateKindColor
 05.02.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractConditionValue (inJuridicalId:= 1, inSession := zfCalc_UserAdmin())
