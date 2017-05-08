-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_Object_City (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_City(
    IN inId          Integer,       -- Населенный пункт
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_City());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             0 :: Integer                           AS Id
           , lfGet_ObjectCode(0, zc_Object_City())  AS Code
           , '' :: TVarChar                         AS Name
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
       FROM Object
      
       WHERE Object.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.2017                                                           *
28.02.2017                                                           *

*/

-- тест
-- SELECT * FROM gpSelect_City('2')
