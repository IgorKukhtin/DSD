--
DROP FUNCTION IF EXISTS gpGet_Object_ReceiptService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptService(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Article TVarChar
             , Comment TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptService());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer     AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptService())   AS Code
           , '' :: TVarChar    AS Name
           , '' :: TVarChar    AS Article
           , '' :: TVarChar    AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_ReceiptService.Id         AS Id
           , Object_ReceiptService.ObjectCode AS Code
           , Object_ReceiptService.ValueData  AS Name
           , ObjectString_Article.ValueData   AS Article
           , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment
       FROM Object AS Object_ReceiptService
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptService_Comment()
           LEFT JOIN ObjectString AS ObjectString_Article
                                  ON ObjectString_Article.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()
       WHERE Object_ReceiptService.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
11.12.20          *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptService(0, '2')
