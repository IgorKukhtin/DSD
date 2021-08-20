-- Function: gpSelect_Object_TopicsTestingTuning()

DROP FUNCTION IF EXISTS gpSelect_Object_TopicsTestingTuning(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TopicsTestingTuning(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TopicsTestingTuning()());

   RETURN QUERY
   SELECT
          Object_TopicsTestingTuning.Id         AS Id
        , Object_TopicsTestingTuning.ObjectCode AS Code
        , Object_TopicsTestingTuning.ValueData  AS Name

        , Object_TopicsTestingTuning.isErased   AS isErased
   FROM Object AS Object_TopicsTestingTuning
   WHERE Object_TopicsTestingTuning.DescId = zc_Object_TopicsTestingTuning();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.07.21                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TopicsTestingTuning('3')