-- Function: gpGet_Object_ProdOptPattern()

DROP FUNCTION IF EXISTS gpGet_Object_ProdOptPattern (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdOptPattern(
    IN inId          Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptPattern());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
         SELECT
                0 :: Integer            AS Id
             , lfGet_ObjectCode(0, zc_Object_ProdOptPattern())   AS Code
             , '' :: TVarChar           AS Name
             , '' :: TVarChar           AS Comment
        ;

   ELSE
       RETURN QUERY
         SELECT
               Object_ProdOptPattern.Id         AS Id
             , Object_ProdOptPattern.ObjectCode AS Code
             , Object_ProdOptPattern.ValueData  AS Name

             , ObjectString_Comment.ValueData     ::TVarChar AS Comment

         FROM Object AS Object_ProdOptPattern
              LEFT JOIN ObjectString AS ObjectString_Comment
                                     ON ObjectString_Comment.ObjectId = Object_ProdOptPattern.Id
                                    AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptPattern_Comment()

         WHERE Object_ProdOptPattern.DescId = zc_Object_ProdOptPattern()
          AND Object_ProdOptPattern.Id = inId
        ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ProdOptPattern (inId:= 2469, inSession:= zfCalc_UserAdmin())
