-- 
DROP FUNCTION IF EXISTS gpGet_Object_MessagePersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MessagePersonalService(
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
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MessagePersonalService());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_MessagePersonalService())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_MessagePersonalService.Id                 AS Id
           , Object_MessagePersonalService.ObjectCode         AS Code
           , Object_MessagePersonalService.ValueData          AS Name
           , ObjectString_Comment.ValueData  AS Comment
       FROM Object AS Object_MessagePersonalService
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_MessagePersonalService.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_MessagePersonalService_Comment() 
       WHERE Object_MessagePersonalService.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.25         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MessagePersonalService (1 ::integer,'2'::TVarChar)
