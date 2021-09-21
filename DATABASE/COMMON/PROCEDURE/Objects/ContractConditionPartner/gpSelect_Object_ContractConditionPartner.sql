-- Function: gpSelect_Object_ContractConditionPartner (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionPartner (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionPartner(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractConditionId Integer, ContractConditionCode Integer, ContractConditionName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , Address TVarChar
             , isConnected Boolean
             , isErased Boolean
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
           , NOT Object_ContractConditionPartner.isErased AS isConnected
           , Object_ContractConditionPartner.isErased    AS isErased
           
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

     WHERE Object_ContractConditionPartner.DescId = zc_Object_ContractConditionPartner()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractConditionPartner (zfCalc_UserAdmin())
