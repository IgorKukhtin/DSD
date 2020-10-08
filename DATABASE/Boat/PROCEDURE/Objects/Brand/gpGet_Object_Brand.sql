-- Торговая марка

DROP FUNCTION IF EXISTS gpGet_Object_Brand (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Brand(
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
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Brand());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_Brand())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Brand.Id                 AS Id
           , Object_Brand.ObjectCode         AS Code
           , Object_Brand.ValueData          AS Name
           , ObjectString_Comment.ValueData  AS Comment
       FROM Object AS Object_Brand
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Brand.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Brand_Comment() 
       WHERE Object_Brand.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Brand (1,'2')
