-- 

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptServiceMaterial (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptServiceMaterial(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Comment TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptServiceMaterial());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer     AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptServiceMaterial())   AS Code
           , '' :: TVarChar    AS Name
           , '' :: TVarChar    AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_ReceiptServiceMaterial.Id         AS Id
           , Object_ReceiptServiceMaterial.ObjectCode AS Code
           , Object_ReceiptServiceMaterial.ValueData  AS Name
           , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment
       FROM Object AS Object_ReceiptServiceMaterial
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptServiceMaterial.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptServiceMaterial_Comment()
       WHERE Object_ReceiptServiceMaterial.Id = inId;
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
-- SELECT * FROM gpGet_Object_ReceiptServiceMaterial(0, '2')
