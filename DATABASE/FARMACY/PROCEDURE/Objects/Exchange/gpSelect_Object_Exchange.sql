-- Function: gpSelect_Object_Exchange()

DROP FUNCTION IF EXISTS gpSelect_Object_Exchange (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Exchange(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Exchange());

   RETURN QUERY
   SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased

   FROM Object
   WHERE Object.DescId = zc_Object_Exchange();

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Exchange(TVarChar)
  OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.09.18        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Exchange('2')
