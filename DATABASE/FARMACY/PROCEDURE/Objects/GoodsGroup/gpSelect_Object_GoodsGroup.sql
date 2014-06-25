-- Function: gpSelect_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroup();

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean
             , ParentId Integer, ParentName TVarChar
              ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
           Object_GoodsGroup.Id         AS Id 
         , Object_GoodsGroup.ObjectCode AS Code
         , Object_GoodsGroup.ValueData  AS Name
         , Object_GoodsGroup.isErased   AS isErased

         , Object_Parent.Id         AS ParentId
         , Object_Parent.ValueData  AS ParentName

     FROM Object AS Object_GoodsGroup
          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent 
                               ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                              AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Goods_Parent.ChildObjectId

     WHERE Object.DescId = zc_Object_GoodsGroup();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsGroup(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.14         *
         
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroup('2')