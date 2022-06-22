-- 
DROP FUNCTION IF EXISTS gpGet_Object_MaterialOptions (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MaterialOptions(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MaterialOptions());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_MaterialOptions())   AS Code
           , '' :: TVarChar           AS Name
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_MaterialOptions.Id                 AS Id
           , Object_MaterialOptions.ObjectCode         AS Code
           , Object_MaterialOptions.ValueData          AS Name
       FROM Object AS Object_MaterialOptions
       WHERE Object_MaterialOptions.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.26.22          *
*/

-- тест
-- SELECT * FROM gpGet_Object_MaterialOptions (1 ::integer,'2'::TVarChar)
