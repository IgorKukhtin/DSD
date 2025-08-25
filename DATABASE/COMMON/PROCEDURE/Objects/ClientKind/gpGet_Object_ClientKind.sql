-- Function: gpGet_Object_ClientKind()

DROP FUNCTION IF EXISTS gpGet_Object_ClientKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ClientKind(
    IN inId          Integer,       -- ключ объекта <Виды бонусов>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ClientKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ClientKind()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ClientKind.Id         AS Id
           , Object_ClientKind.ObjectCode AS Code
           , Object_ClientKind.ValueData  AS NAME
           , Object_ClientKind.isErased   AS isErased
           
       FROM Object AS Object_ClientKind
       WHERE Object_ClientKind.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.08.25         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_ClientKind (0, '2')