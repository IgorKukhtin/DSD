-- Function: gpGet_Object_ContractCondition()

DROP FUNCTION IF EXISTS gpGet_Object_ContractCondition(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractCondition(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ContractId Integer, ContractName TVarChar,
               ContractConditionKindId Integer, ContractConditionKindName TVarChar,
               Value TFloat,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ContractCondition());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractCondition()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS ContractId
           , CAST ('' as TVarChar) AS ContractName 

           , CAST (0 as Integer)   AS ContractConditionKindId
           , CAST ('' as TVarChar) AS ContractConditionKindName 
           
           , CAST (NULL AS TFloat) AS Value     
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractCondition.Id           AS Id
           , Object_ContractCondition.ObjectCode   AS Code
           , Object_ContractCondition.ValueData    AS Name
         
           , Object_Contract.Id         AS ContractId
           , Object_Contract.ValueData  AS ContractName 
           
           , Object_ContractConditionKind.Id         AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData  AS ContractConditionKindName 

           , ObjectFloat_Value.ValueData AS Value
           
           , Object_ContractCondition.isErased       AS isErased
           
       FROM Object AS Object_ContractCondition
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
                                  
      WHERE Object_ContractCondition.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ContractCondition (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ContractCondition(0,'2')