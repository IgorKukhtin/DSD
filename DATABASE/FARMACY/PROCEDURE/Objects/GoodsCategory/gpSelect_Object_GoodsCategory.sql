-- Function: gpSelect_Object_GoodsCategory()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsCategory(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsCategory(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitCategoryId Integer, UnitCategoryName TVarChar
             , Value TFloat
             , isErased boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsCategory());

   RETURN QUERY 
       SELECT 
             Object_GoodsCategory.Id        AS Id

           , ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
           , Object_GoodsGroup.ValueData               AS GoodsGroupName

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName 
                     
           , Object_UnitCategory.Id         AS UnitCategoryId
           , Object_UnitCategory.ValueData  AS UnitCategoryName 

           , ObjectFloat_Value.ValueData    AS Value
           
           , Object_GoodsCategory.isErased  AS isErased
           
       FROM Object AS Object_GoodsCategory
           LEFT JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                               AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsCategory_Goods.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsCategory_UnitCategory
                                ON ObjectLink_GoodsCategory_UnitCategory.ObjectId = Object_GoodsCategory.Id
                               AND ObjectLink_GoodsCategory_UnitCategory.DescId = zc_ObjectLink_GoodsCategory_Category()
           LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_GoodsCategory_UnitCategory.ChildObjectId           

           LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                 ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

       WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsCategory ('2')