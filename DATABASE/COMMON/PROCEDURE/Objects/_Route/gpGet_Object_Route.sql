-- Function: gpGet_Object_Route()

-- DROP FUNCTION gpGet_Object_Route (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Route(
    IN inId             Integer,       -- ключ объекта <Маршрут>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Route());

   RETURN QUERY
   SELECT
      Object.Id
    , Object.ObjectCode
    , Object.ValueData AS Name
    , Object.isErased
   FROM Object 
   WHERE Object.Id = inId;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Route (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.13          *

*/

-- тест
-- SELECT * FROM gpGet_Object_Route (2, '')
