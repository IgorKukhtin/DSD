-- Function: gpSelect_Object_GoodsGroupProperty()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroupProperty(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroupProperty(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ParentId Integer, ParentName TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroupProperty()());

   RETURN QUERY 
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name  
        , Object_Parent.Id        ::Integer  AS ParentId
        , Object_Parent.ValueData ::TVarChar AS ParentName
        , Object.isErased   AS isErased
   FROM Object
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                             ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object.Id
                            AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId
   WHERE Object.DescId = zc_Object_GoodsGroupProperty();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.23         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroupProperty('2')