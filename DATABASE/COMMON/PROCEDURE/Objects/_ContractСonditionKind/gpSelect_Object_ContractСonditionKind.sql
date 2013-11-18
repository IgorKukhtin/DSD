-- Function: gpSelect_Object_ContractConditionKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractConditionKind());

   RETURN QUERY 
   SELECT
        Object_ContractConditionKind.Id           AS Id 
      , Object_ContractConditionKind.ObjectCode   AS Code
      , Object_ContractConditionKind.ValueData    AS NAME
      
      , Object_ContractConditionKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ContractConditionKind
                              
   WHERE Object_ContractConditionKind.DescId = zc_Object_ContractConditionKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractConditionKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractConditionKind('2')
