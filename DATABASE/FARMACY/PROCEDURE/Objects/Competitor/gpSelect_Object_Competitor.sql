-- Function: gpSelect_Object_Competitor(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Competitor(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Competitor(
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Competitor());

   RETURN QUERY 
     SELECT Object_Competitor.Id                 AS Id
          , Object_Competitor.ObjectCode         AS Code
          , Object_Competitor.ValueData          AS Name
          , Object_Competitor.isErased           AS isErased
     FROM OBJECT AS Object_Competitor

     WHERE Object_Competitor.DescId = zc_Object_Competitor();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.05.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_Competitor('3')