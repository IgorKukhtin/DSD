-- Function: gpSelect_Object_ContractConditionKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionKind (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionKind(
   -- IN inContractId     INTEGER DEFAULT 0,       --
    IN inSession        TVarChar DEFAULT ''      -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

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
  UNION ALL
   SELECT
        0 AS Id 
      , 0 AS Code
      , 'УДАЛИТЬ' :: TVarChar AS NAME
      , FALSE AS isErased
      
      
      
;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractConditionKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.14                                        * add 'УДАЛИТЬ'
 20.02.14         * del inContractId
 04.01.14         * add inContractId
 16.11.13         *
*/

-- тест
 --SELECT * FROM gpSelect_Object_ContractConditionKind( inSession    := '2')
