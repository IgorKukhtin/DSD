-- Function: gpGet_Object_GoodsCategory()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsCategory(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsCategory(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer  
             , GoodsId Integer, GoodsName TVarChar
             , UnitCategoryId Integer, UnitCategoryName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Value TFloat
             , isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsCategory());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           
           , CAST (0 as Integer)   AS GoodsId
           , CAST ('' as TVarChar) AS GoodsName 

           , CAST (0 as Integer)   AS UnitCategoryId
           , CAST ('' as TVarChar) AS UnitCategoryName 

           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName 

           , CAST (NULL AS TFloat) AS Value     
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsCategory.Id        AS Id
         
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ValueData         AS GoodsName 
           
           , Object_UnitCategory.Id         AS UnitCategoryId
           , Object_UnitCategory.ValueData  AS UnitCategoryName 

           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName 

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

           LEFT JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                               AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_GoodsCategory_Unit.ChildObjectId    

           LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                 ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                  
      WHERE Object_GoodsCategory.Id = inId;
   END IF;
  
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
-- SELECT * FROM gpGet_Object_GoodsCategory(0,'2')