-- Function: gpSelect_Object_GoodsBrand()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsBrand (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsBrand(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsBrand());

   RETURN QUERY 
   SELECT Object_GoodsBrand.Id         AS Id 
        , Object_GoodsBrand.ObjectCode AS Code
        , Object_GoodsBrand.ValueData  AS Name
        , Object_GoodsBrand.isErased   AS isErased
   FROM Object AS Object_GoodsBrand
   WHERE Object_GoodsBrand.DescId = zc_Object_GoodsBrand();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsBrand('2')