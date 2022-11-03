-- Function: gpSelect_Object_Section()

DROP FUNCTION IF EXISTS gpSelect_Object_Section (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Section(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Section());

   RETURN QUERY 
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name
        , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_Section();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Section('2')