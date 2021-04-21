-- 
DROP FUNCTION IF EXISTS gpGet_Object_DocTag (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DocTag(
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
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DocTag());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_DocTag())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_DocTag.Id               AS Id
           , Object_DocTag.ObjectCode       AS Code
           , Object_DocTag.ValueData        AS Name
           , ObjectString_Comment.ValueData AS Comment
       FROM Object AS Object_DocTag
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_DocTag.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_DocTag_Comment() 
       WHERE Object_DocTag.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.04.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_DocTag (1 ::integer,'2'::TVarChar)
