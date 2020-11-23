-- Function: gpGet_Object_ContractConditionPartner (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContractConditionPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractConditionPartner(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractConditionId Integer, ContractConditionName TVarChar
             , PartnerId Integer, PartnerName TVarChar
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

       FROM Object AS Object_ContractConditionPartner
       
            LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                 ON ObjectLink_ContractConditionPartner_ContractCondition.ObjectId = Object_ContractConditionPartner.Id
                                AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
            LEFT JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                 ON ObjectLink_ContractConditionPartner_Partner.ObjectId = Object_ContractConditionPartner.Id
                                AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractConditionPartner_Partner.ChildObjectId
                                           
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
