-- 

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptServiceModel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptServiceModel(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Comment TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptServiceModel());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer     AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptServiceModel())   AS Code
           , '' :: TVarChar    AS Name
           , '' :: TVarChar    AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_ReceiptServiceModel.Id         AS Id
           , Object_ReceiptServiceModel.ObjectCode AS Code
           , Object_ReceiptServiceModel.ValueData  AS Name
           , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment
       FROM Object AS Object_ReceiptServiceModel
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptServiceModel.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptServiceModel_Comment()
       WHERE Object_ReceiptServiceModel.Id = inId;
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
-- SELECT * FROM gpGet_Object_ReceiptServiceModel(0, '2')
