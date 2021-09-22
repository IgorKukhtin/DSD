-- Function: gpGet_Object_ContractConditionPartner (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContractConditionPartner (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_ContractConditionPartner (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractConditionPartner(
    IN inId                     Integer,       -- ключ объекта <>
    IN inJuridicalId            Integer,
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractConditionId Integer, ContractConditionName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ContractConditionPartner());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractConditionPartner()) AS Code
          
           , CAST (0 as Integer)    AS ContractConditionId
           , CAST ('' as TVarChar)  AS ContractConditionName  

           , CAST (0 as Integer)    AS PartnerId
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (0 as Integer)    AS ContractId
           , CAST (0 as Integer)    AS ContractCode
           , CAST ('' as TVarChar)  AS ContractName
    
           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (0 as Integer)    AS ContractConditionKindId
           , CAST ('' as TVarChar)  AS ContractConditionKindName
       FROM Object AS Object_Juridical
       WHERE Object_Juridical.Id = inJuridicalId
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractConditionPartner.Id          AS Id
           , Object_ContractConditionPartner.ObjectCode  AS Code

           , Object_ContractCondition.Id         AS ContractConditionId
           , Object_ContractCondition.ValueData  AS ContractConditionName

           , Object_Partner.Id          AS PartnerId
           , Object_Partner.ValueData   AS PartnerName

           , Object_Contract.Id         AS ContractId
           , Object_Contract.ObjectCode AS ContractCode
           , Object_Contract.ValueData  AS ContractName

           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

       FROM Object AS Object_ContractConditionPartner
       
            LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                 ON ObjectLink_ContractConditionPartner_ContractCondition.ObjectId = Object_ContractConditionPartner.Id
                                AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
            LEFT JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                 ON ObjectLink_ContractConditionPartner_Partner.ObjectId = Object_ContractConditionPartner.Id
                                AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractConditionPartner_Partner.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                 ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                 ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                                AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

       WHERE Object_ContractConditionPartner.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.20         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_ContractConditionPartner (0, inSession := '5')
-- select * from gpGet_Object_ContractConditionPartner(inId := 6140513 ,  inJuridicalId:= 0, inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');