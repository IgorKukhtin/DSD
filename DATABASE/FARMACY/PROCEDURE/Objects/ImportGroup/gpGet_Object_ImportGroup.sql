-- Function: gpGet_Object_ImportGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ImportGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportGroup(
    IN inId          Integer,       -- Группа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar)
AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST ('' as TVarChar)  AS Name
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ImportGroup.Id         AS Id
           , Object_ImportGroup.ValueData  AS Name
       FROM Object AS Object_ImportGroup
       WHERE Object_ImportGroup.Id = inId;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_ImportGroup('2')