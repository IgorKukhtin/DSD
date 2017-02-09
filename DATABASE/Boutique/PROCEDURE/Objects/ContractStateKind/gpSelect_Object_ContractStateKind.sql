-- Function: gpSelect_Object_ContractStateKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractStateKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractStateKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractStateKind());

   RETURN QUERY 
   SELECT
        Object_ContractStateKind.Id           AS Id 
      , Object_ContractStateKind.ObjectCode   AS Code
      , Object_ContractStateKind.ValueData    AS NAME
      
      , Object_ContractStateKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ContractStateKind
                              
   WHERE Object_ContractStateKind.DescId = zc_Object_ContractStateKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractStateKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractStateKind('2')
