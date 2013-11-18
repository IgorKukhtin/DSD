-- Function: gpSelect_Object_ContractCondition(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractCondition(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractCondition(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Value TFloat
             , ContractId Integer, ContractName TVarChar                
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar                
             , isErased boolean
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractCondition());

   RETURN QUERY 
     SELECT 
           Object_ContractCondition.Id        AS Id
           
         , ObjectFloat_Value.ValueData     AS Value  
                                                        
         , Object_Contract.Id          AS ContractId
         , Object_Contract.ValueData   AS ContractName

         , Object_ContractConditionKind.Id          AS ContractConditionKindId
         , Object_ContractConditionKind.ValueData   AS ContractConditionKindName

         , Object_ContractCondition.isErased AS isErased
         
     FROM OBJECT AS Object_ContractCondition
     
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                               ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                               ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
          LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
           
          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
          
     WHERE Object_ContractCondition.DescId = zc_Object_ContractCondition();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractCondition (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractCondition ('2')