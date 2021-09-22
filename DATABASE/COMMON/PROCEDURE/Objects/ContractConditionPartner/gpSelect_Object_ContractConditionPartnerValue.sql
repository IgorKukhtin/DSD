-- Function: gpSelect_Object_ContractConditionPartner (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionPartner_choice (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionPartnerValue (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionPartnerValue(
    IN inJuridicalId   Integer ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractConditionId Integer, ContractConditionCode Integer, ContractConditionName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , Address TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isConnected Boolean
             , isErased Boolean
             , ContractId Integer, ContractCode Integer, InvNumber TVarChar
             , ContractTagName TVarChar, ContractStateKindCode Integer
             , ContractKindId Integer, ContractKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar, PaidKindName_Condition TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , Value TFloat
             , StartDate_ch TDateTime, EndDate_ch TDateTime
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractConditionPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_ContractConditionPartner.Id          AS Id
           , Object_ContractConditionPartner.ObjectCode  AS Code

           , Object_ContractCondition.Id                 AS ContractConditionId
           , Object_ContractCondition.ObjectCode         AS ContractConditionCode
           , Object_ContractCondition.ValueData          AS ContractConditionName

           , Object_Partner.Id                           AS PartnerId
           , Object_Partner.ObjectCode                   AS PartnerCode
           , Object_Partner.ValueData                    AS PartnerName
           , ObjectString_Address.ValueData              AS Address

           , Object_Juridical.Id                         AS JuridicalId
           , Object_Juridical.ObjectCode                 AS JuridicalCode
           , Object_Juridical.ValueData                  AS JuridicalName

           , NOT Object_ContractConditionPartner.isErased AS isConnected
           , Object_ContractConditionPartner.isErased     AS isErased

           , Object_Contract_View.ContractId
           , Object_Contract_View.ContractCode
           , Object_Contract_View.InvNumber
           , Object_Contract_View.ContractTagName
           , Object_Contract_View.ContractStateKindCode

           , Object_ContractKind.Id                 AS ContractKindId
           , Object_ContractKind.ValueData          AS ContractKindName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

           , Object_PaidKind.Id                   AS PaidKindId
           , Object_PaidKind.ValueData            AS PaidKindName
           , Object_PaidKind_Condition.ValueData  AS PaidKindName_Condition

           , Object_BonusKind.Id               AS BonusKindId
           , Object_BonusKind.ValueData        AS BonusKindName
           
           , ObjectFloat_Value.ValueData       AS Value
           , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate_ch
           , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate_ch
       FROM Object AS Object_ContractConditionPartner
                                                            
            LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                 ON ObjectLink_ContractConditionPartner_ContractCondition.ObjectId = Object_ContractConditionPartner.Id
                                AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
            LEFT JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                 ON ObjectLink_ContractConditionPartner_Partner.ObjectId = Object_ContractConditionPartner.Id
                                AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractConditionPartner_Partner.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Address
                                   ON ObjectString_Address.ObjectId = Object_Partner.Id
                                  AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                 ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                 ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                                AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId

            --LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId

            LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                 ON ObjectLink_ContractCondition_PaidKind.ObjectId = Object_ContractCondition.Id
                                AND ObjectLink_ContractCondition_PaidKind.DescId   = zc_ObjectLink_ContractCondition_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_Condition ON Object_PaidKind_Condition.Id = ObjectLink_ContractCondition_PaidKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                 ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                                AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                  ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id
                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()

            LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                 ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
            LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                 ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()

     WHERE Object_ContractConditionPartner.DescId = zc_Object_ContractConditionPartner()
       AND (inJuridicalId = 0 OR inJuridicalId = ObjectLink_Partner_Juridical.ChildObjectId)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.09.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractConditionPartnerValue (0,zfCalc_UserAdmin())
