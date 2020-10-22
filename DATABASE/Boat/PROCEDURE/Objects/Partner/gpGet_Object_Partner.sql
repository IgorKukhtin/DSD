-- Торговая марка

DROP FUNCTION IF EXISTS gpGet_Object_Partner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
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
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_Partner())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Partner.Id                 AS Id
           , Object_Partner.ObjectCode         AS Code
           , Object_Partner.ValueData          AS Name
           , ObjectString_Comment.ValueData  AS Comment
       FROM Object AS Object_Partner
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Partner.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Partner_Comment() 
       WHERE Object_Partner.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Partner (1 ::integer,'2'::TVarChar)
