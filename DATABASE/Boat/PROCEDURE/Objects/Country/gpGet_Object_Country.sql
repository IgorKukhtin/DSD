-- Страна производитель

DROP FUNCTION IF EXISTS gpGet_Object_Country (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Country(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Country());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer     AS Id
           , lfGet_ObjectCode(0, zc_Object_Country())   AS Code
           , '' :: TVarChar    AS Name
           , '' :: TVarChar    AS ShortName
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Country.Id         AS Id
           , Object_Country.ObjectCode AS Code
           , Object_Country.ValueData  AS Name
           , COALESCE (ObjectString_ShortName.ValueData, NULL) :: TVarChar AS ShortName
       FROM Object AS Object_Country
           LEFT JOIN ObjectString AS ObjectString_ShortName
                                  ON ObjectString_ShortName.ObjectId = Object_Country.Id
                                 AND ObjectString_ShortName.DescId = zc_ObjectString_Country_ShortName()
       WHERE Object_Country.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Country(0, '2')
