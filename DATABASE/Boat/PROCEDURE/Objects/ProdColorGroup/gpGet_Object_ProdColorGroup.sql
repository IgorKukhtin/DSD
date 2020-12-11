-- Торговая марка

DROP FUNCTION IF EXISTS gpGet_Object_ProdColorGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdColorGroup(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ProdColorKindId Integer, ProdColorKindName TVarChar
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProdColorGroup());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdColorGroup())   AS Code
           , '' :: TVarChar           AS Name
           ,  0 :: Integer            AS ProdColorKindId
           , '' :: TVarChar           AS ProdColorKindName
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_ProdColorGroup.Id         AS Id
           , Object_ProdColorGroup.ObjectCode AS Code
           , Object_ProdColorGroup.ValueData  AS Name
           , Object_ProdColorKind.Id          AS ProdColorKindId
           , Object_ProdColorKind.ValueData   AS ProdColorKindName
           , ObjectString_Comment.ValueData   AS Comment
       FROM Object AS Object_ProdColorGroup
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorGroup.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorGroup_Comment()
          LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                               ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                              AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
          LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
       WHERE Object_ProdColorGroup.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ProdColorGroup (1 ::integer,'2'::TVarChar)
