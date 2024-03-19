-- 

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptServiceGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptServiceGroup(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Comment TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptServiceGroup());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer     AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptServiceGroup())   AS Code
           , '' :: TVarChar    AS Name
           , '' :: TVarChar    AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_ReceiptServiceGroup.Id         AS Id
           , Object_ReceiptServiceGroup.ObjectCode AS Code
           , Object_ReceiptServiceGroup.ValueData  AS Name
           , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment
       FROM Object AS Object_ReceiptServiceGroup
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptServiceGroup.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptServiceGroup_Comment()
       WHERE Object_ReceiptServiceGroup.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptServiceGroup(0, '2')
