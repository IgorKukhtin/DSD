-- Function: gpGet_Object_ContractTagKind()

DROP FUNCTION IF EXISTS gpGet_Object_ContractTagKind(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractTagKind(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractTagKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractTagKind()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractTagKind.Id         AS Id
           , Object_ContractTagKind.ObjectCode AS Code
           , Object_ContractTagKind.ValueData  AS NAME
          
           , Object_ContractTagKind.isErased   AS isErased
           
       FROM Object AS Object_ContractTagKind
       WHERE Object_ContractTagKind.Id = inId;

   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.26         * 

*/

-- тест
-- SELECT * FROM gpGet_Object_ContractTagKind (0, '2')