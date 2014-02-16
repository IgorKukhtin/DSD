-- Function: gpSelect_Object_GoodsProperty()

--DROP FUNCTION gpSelect_Object_GoodsProperty();

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsProperty(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   --PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsProperty());

   RETURN QUERY 
   SELECT 
         Object.Id         AS Id 
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_GoodsProperty();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_GoodsProperty(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.13          *
 00.06.13
 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsProperty('2')