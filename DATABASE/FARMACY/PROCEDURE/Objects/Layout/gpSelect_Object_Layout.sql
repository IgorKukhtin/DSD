-- Function: gpSelect_Object_Layout()

DROP FUNCTION IF EXISTS gpSelect_Object_Layout(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Layout(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Layout()());

   RETURN QUERY 
   SELECT Object_Layout.Id                     AS Id 
        , Object_Layout.ObjectCode             AS Code
        , Object_Layout.ValueData              AS Name
        , Object_Layout.isErased               AS isErased
   FROM Object AS Object_Layout
   WHERE Object_Layout.DescId = zc_Object_Layout();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.08.20         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Layout('2')