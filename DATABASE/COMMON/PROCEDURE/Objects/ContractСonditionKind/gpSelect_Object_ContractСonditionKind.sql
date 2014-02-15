-- Function: gpSelect_Object_ContractConditionKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionKind (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionKind(
    IN inContractId     INTEGER DEFAULT 0,       --
    IN inSession        TVarChar DEFAULT ''      -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractConditionKind());
--   raise exception '%', inContractId;

   RETURN QUERY 
   SELECT
        Object_ContractConditionKind.Id           AS Id 
      , Object_ContractConditionKind.ObjectCode   AS Code
      , Object_ContractConditionKind.ValueData    AS NAME
      
      , Object_ContractConditionKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ContractConditionKind
                              
   WHERE Object_ContractConditionKind.DescId = zc_Object_ContractConditionKind()
       AND (Object_ContractConditionKind.Id in (SELECT ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                                from ObjectLink AS ObjectLink_ContractCondition_Contract
                                                  LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                                       ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                                      AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract() AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId)
         or inContractId = 0);
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractConditionKind (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.14         * add inContractId
 16.11.13         *

*/

-- тест
 --SELECT * FROM gpSelect_Object_ContractConditionKind( inSession    := '2')
