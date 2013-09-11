-- Function: gpSelect_Object_TradeMark (TVarChar)

-- DROP FUNCTION gpSelect_Object_TradeMark (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TradeMark(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_TradeMark());

   RETURN QUERY 
   SELECT
         Object.Id         AS Id 
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_TradeMark();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_TradeMark (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.09.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_TradeMark('2')
