-- Function: gpGet_Object_AccountDirection (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_AccountDirection (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_AccountDirection(
    IN inId             Integer,       -- ключ объекта <Аналитики управленческих счетов>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_AccountDirection());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_AccountDirection()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT
             Object_AccountDirection.Id         AS Id
           , Object_AccountDirection.ObjectCode AS Code
           , Object_AccountDirection.ValueData  AS Name
           , Object_AccountDirection.isErased   AS isErased
       FROM Object AS Object_AccountDirection
       WHERE Object_AccountDirection.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_AccountDirection (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          * zc_Enum_Process_Get_Object_AccountDirection()              
 17.06.13          *

*/

-- тест
-- SELECT * FROM gpGet_Object_AccountDirection (2, '')
