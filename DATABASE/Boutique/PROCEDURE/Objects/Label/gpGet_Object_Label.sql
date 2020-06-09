-- Название для ценника

DROP FUNCTION IF EXISTS gpGet_Object_Label (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Label(
    IN inId          Integer,       -- <Название для ценника>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
              , Name_RUS TVarChar
 ) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             0 :: Integer                              AS Id
           , lfGet_ObjectCode(0, zc_Object_Label())    AS Code
           , '' :: TVarChar                            AS Name
           , '' :: TVarChar                            AS Name_RUS
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , COALESCE (ObjectString_RUS.ValueData, NULL) :: TVarChar AS Name_RUS
       FROM Object
           LEFT JOIN ObjectString AS ObjectString_RUS
                                  ON ObjectString_RUS.ObjectId = Object.Id
                                 AND ObjectString_RUS.DescId = zc_ObjectString_Label_RUS()
       WHERE Object.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.06.20          *
08.05.17                                                          *
03.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpGet_Object_Label (0,'2'::TVarChar)