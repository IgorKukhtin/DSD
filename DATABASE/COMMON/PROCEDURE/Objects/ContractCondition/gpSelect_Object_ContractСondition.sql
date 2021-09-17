-- Function: gpSelect_Object_ContractCondition(TVarChar)

-- DROP FUNCTION IF EXISTS gpSelect_Object_ContractCondition(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractCondition (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractCondition(
    IN inIsErased    Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Value TFloat, PercentRetBonus TFloat
             , ContractId Integer, ContractName TVarChar                
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar    
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractSendId Integer, ContractSendName TVarChar
             
             , ContractStateKindCode_Send Integer
             , ContractTagName_Send TVarChar             
             , InfoMoneyCode_Send Integer, InfoMoneyName_Send TVarChar
             , JuridicalCode_Send Integer, JuridicalName_Send TVarChar
             , StartDate TDateTime, EndDate TDateTime
 
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased boolean
             ) AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractCondition());

   RETURN QUERY 
     SELECT 
           Object_ContractCondition.Id          AS Id
         , ObjectFloat_Value.ValueData          AS Value  
         , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0) :: TFloat AS PercentRetBonus

         , Object_Contract.Id                   AS ContractId
         , Object_Contract.ValueData            AS ContractName

         , Object_ContractConditionKind.Id          AS ContractConditionKindId
         , Object_ContractConditionKind.ValueData   AS ContractConditionKindName

         , Object_BonusKind.Id                  AS BonusKindId
         , Object_BonusKind.ValueData           AS BonusKindName

         , Object_InfoMoney.Id                  AS InfoMoneyId
         , Object_InfoMoney.ValueData           AS InfoMoneyName
         
         , Object_PaidKind.Id                   AS PaidKindId
         , Object_PaidKind.ValueData            AS PaidKindName
        
         , Object_ContractSend.Id               AS ContractSendId
         , Object_ContractSend.ValueData        AS ContractSendName

         , Object_ContractSendStateKind.ObjectCode  AS ContractStateKindCode_Send
         , Object_ContractSendTag.ValueData         AS ContractTagName_Send
         , Object_InfoMoneySend.ObjectCode      AS InfoMoneyCode_Send
         , Object_InfoMoneySend.ValueData       AS InfoMoneyName_Send 
    
         , Object_JuridicalSend.ObjectCode      AS JuridicalCode_Send
         , Object_JuridicalSend.ValueData       AS JuridicalName_Send
         
         , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
         , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate

         , Object_ContractCondition.ValueData   AS Comment
         
         , Object_Insert.ValueData              AS InsertName
         , Object_Update.ValueData              AS UpdateName
         , ObjectDate_Protocol_Insert.ValueData AS InsertDate
         , ObjectDate_Protocol_Update.ValueData AS UpdateDate

         , Object_ContractCondition.isErased    AS isErased
         
     FROM Object AS Object_ContractCondition
     
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                               ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                               ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
          LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
  
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                               ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
          LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                               ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_InfoMoney.DescId = zc_ObjectLink_ContractCondition_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ContractCondition_InfoMoney.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                               ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition.Id
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

          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                               ON ObjectLink_ContractCondition_PaidKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ContractCondition_PaidKind.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()

          LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus 
                                ON ObjectFloat_PercentRetBonus.ObjectId = Object_ContractCondition.Id 
                               AND ObjectFloat_PercentRetBonus.DescId = zc_ObjectFloat_ContractCondition_PercentRetBonus()

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = Object_ContractCondition.Id
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_ContractCondition.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   

          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                               ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()

     WHERE Object_ContractCondition.DescId = zc_Object_ContractCondition()
       AND (Object_ContractCondition.isErased = FALSE OR inIsErased = TRUE)
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.05.20         *
 24.03.20         *
 16.04.14                                        * add isErased = FALSE
 14.03.14         * add InfoMoney
 25.02.14                                        * add zc_ObjectDate_Protocol_... and zc_ObjectLink_Protocol_...
 19.02.14         * add BonusKind             
 16.11.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractCondition ('2', FALSE)
