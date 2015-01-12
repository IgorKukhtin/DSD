-- Function: gpGet_Object_ContractTagGroup()

DROP FUNCTION IF EXISTS gpGet_Object_ContractTagGroup(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractTagGroup(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractTagGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractTagGroup()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractTagGroup.Id         AS Id
           , Object_ContractTagGroup.ObjectCode AS Code
           , Object_ContractTagGroup.ValueData  AS NAME
          
           , Object_ContractTagGroup.isErased   AS isErased
           
       FROM Object AS Object_ContractTagGroup
       WHERE Object_ContractTagGroup.Id = inId;

   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ContractTagGroup (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.15         * 

*/

-- тест
-- SELECT * FROM gpGet_Object_ContractTagGroup (0, '2')