-- Function: gpGet_Object_BodyType()

DROP FUNCTION IF EXISTS gpGet_Object_BodyType (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BodyType(
    IN inId          Integer,       -- ключ объекта <Страны>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_BodyType());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_BodyType()) AS Code 
           , CAST ('' as TVarChar)  AS Name
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
       FROM Object
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.07.23         *
*/

-- тест
-- SELECT * FROM gpGet_Object_BodyType (0, '2')