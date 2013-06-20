-- Function: gpGet_Object_AccountGroup (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_AccountGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_AccountGroup(
    IN inId             Integer,       -- ключ объекта <Группы управленческих счетов>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_AccountGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_AccountGroup.ObjectCode), 0) + 1  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_AccountGroup
       WHERE Object_AccountGroup.DescId = zc_Object_AccountGroup();
   ELSE
       RETURN QUERY 
       SELECT
             Object_AccountGroup.Id         AS Id
           , Object_AccountGroup.ObjectCode AS Code
           , Object_AccountGroup.ValueData  AS Name
           , Object_AccountGroup.isErased   AS isErased
       FROM Object AS Object_AccountGroup
       WHERE Object_AccountGroup.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_AccountGroup (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *  zc_Enum_Process_Get_Object_AccountGroup()              
 17.06.13          *

*/

-- тест
-- SELECT * FROM gpGet_Object_AccountGroup (2, '')
