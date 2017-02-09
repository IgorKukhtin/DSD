-- Function: gpGet_Object_Business(Integer,TVarChar)

--DROP FUNCTION gpGet_Object_Business(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Business(
    IN inId          Integer,       -- Ключ объекта <Бизнесы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_Business();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id
           , Object.ObjectCode
           , Object.ValueData
           , Object.isErased
       FROM Object
       WHERE Object.Id = inId;
   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Business(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.13          *
 05.06.13          

*/

-- тест
-- SELECT * FROM gpGet_Object_Business(1,'2')