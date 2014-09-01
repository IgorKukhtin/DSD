-- Function: gpSelect_Object_Founder()

DROP FUNCTION IF EXISTS gpSelect_Object_Founder(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Founder(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Founder()());

   RETURN QUERY
   SELECT
          Object_Founder.Id         AS Id
        , Object_Founder.ObjectCode AS Code
        , Object_Founder.ValueData  AS Name

        , Object_Founder.isErased    AS isErased
   FROM Object AS Object_Founder
   WHERE Object_Founder.DescId = zc_Object_Founder();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Founder(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 01.09.14         * 

*/

-- тест
-- SELECT * FROM gpSelect_Object_Founder('2')