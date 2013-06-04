-- Function: gpGet_Object_RouteSorting (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_RouteSorting (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RouteSorting(
    IN inId             Integer,       -- ключ объекта <Сортировки Маршрутов>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_RouteSorting());

   RETURN QUERY
   SELECT
      Object.Id
    , Object.ObjectCode AS Code
    , Object.ValueData AS Name
    , Object.isErased
   FROM Object 
   WHERE Object.Id = inId;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_RouteSorting (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.13          *

*/

-- тест
-- SELECT * FROM gpGet_Object_RouteSorting (2, '')
