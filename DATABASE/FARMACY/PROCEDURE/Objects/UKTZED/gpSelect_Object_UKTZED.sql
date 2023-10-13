-- Function: gpSelect_Object_UKTZED()

DROP FUNCTION IF EXISTS gpSelect_Object_UKTZED(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UKTZED(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UKTZED()());

   RETURN QUERY 
   SELECT Object_UKTZED.Id                     AS Id 
        , Object_UKTZED.ObjectCode             AS Code
        , Object_UKTZED.ValueData              AS Name
        , Object_UKTZED.isErased               AS isErased
   FROM Object AS Object_UKTZED
   WHERE Object_UKTZED.DescId = zc_Object_UKTZED();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.10.23                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_Object_UKTZED('2')