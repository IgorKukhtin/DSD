-- 
DROP FUNCTION IF EXISTS gpGet_Object_FineSubject (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_FineSubject(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_FineSubject());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_FineSubject())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_FineSubject.Id                 AS Id
           , Object_FineSubject.ObjectCode         AS Code
           , Object_FineSubject.ValueData          AS Name
           , ObjectString_Comment.ValueData  AS Comment
       FROM Object AS Object_FineSubject
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_FineSubject.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_FineSubject_Comment() 
       WHERE Object_FineSubject.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_FineSubject (1 ::integer,'2'::TVarChar)
