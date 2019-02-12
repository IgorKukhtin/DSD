-- Function: gpSelect_Object_GoodsCategory()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsCategory(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsCategory(Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsCategory(
    IN inUnitCategoryId  Integer ,
    IN inShowAll         Boolean ,
    IN inisErased        Boolean ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitCategoryId Integer, UnitCategoryName TVarChar
             , Value TFloat
             , isErased boolean
) AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsCategory());
    vbUserId:= lpGetUserBySession (inSession);
     
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


   IF inShowAll THEN
   RETURN QUERY
        WITH 
        tmpGoods AS (SELECT ObjectBoolean_Goods_isMain.ObjectId              AS GoodsId
                          , Object_Goods.ObjectCode                          AS GoodsCode
                          , Object_Goods.ValueData                           AS GoodsName
                          , Object_Goods.isErased                            AS isErased
                     FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                           LEFT JOIN Object AS Object_Goods 
                                            ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                           AND (Object_Goods.isErased = inisErased OR inisErased = TRUE)
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object 
                                                ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                     WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                       AND inUnitCategoryId <> 0
                     )

      , tmpGoodsCategory AS (SELECT Object_GoodsCategory.Id        AS Id
                                  , ObjectLink_Goods_GoodsGroup.ChildObjectId    AS GoodsGroupId
                                  , Object_GoodsGroup.ValueData                  AS GoodsGroupName
                                  , ObjectLink_GoodsCategory_Goods.ChildObjectId AS GoodsId
                                  , ObjectLink_GoodsCategory_UnitCategory.ChildObjectId AS UnitCategoryId
                                  , ObjectFloat_Value.ValueData    AS Value
                                  , Object_GoodsCategory.isErased  AS isErased
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_UnitCategory
                                                       ON ObjectLink_GoodsCategory_UnitCategory.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_UnitCategory.DescId = zc_ObjectLink_GoodsCategory_Category()
                                                      AND (ObjectLink_GoodsCategory_UnitCategory.ChildObjectId = inUnitCategoryId /*OR inUnitCategoryId = 0*/)

                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                      ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                     AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                 --LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsCategory_Goods.ChildObjectId
  
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                       ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND (Object_GoodsCategory.isErased = inisErased OR inisErased = TRUE)
                             )

       SELECT
             COALESCE (tmpGoodsCategory.Id, 0)        AS Id
           , ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
           , Object_GoodsGroup.ValueData               AS GoodsGroupName
           , tmpGoods.GoodsId               AS GoodsId
           , tmpGoods.GoodsCode             AS GoodsCode
           , tmpGoods.GoodsName             AS GoodsName 
           , Object_UnitCategory.Id         AS UnitCategoryId
           , Object_UnitCategory.ValueData  AS UnitCategoryName 
           , COALESCE (tmpGoodsCategory.Value, 0)  ::TFloat       AS Value
           , CASE WHEN tmpGoodsCategory.isErased = TRUE OR tmpGoods.isErased = TRUE THEN TRUE ELSE FALSE END AS isErased
       FROM tmpGoods
           FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpGoods.GoodsId

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
           
           LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = COALESCE (tmpGoodsCategory.UnitCategoryId, inUnitCategoryId)
           
       ;
   ELSE
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
           INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_UnitCategory
                                 ON ObjectLink_GoodsCategory_UnitCategory.ObjectId = Object_GoodsCategory.Id
                                AND ObjectLink_GoodsCategory_UnitCategory.DescId = zc_ObjectLink_GoodsCategory_Category()
                                AND (ObjectLink_GoodsCategory_UnitCategory.ChildObjectId = inUnitCategoryId /*OR inUnitCategoryId = 0*/)
           LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_GoodsCategory_UnitCategory.ChildObjectId 

           LEFT JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                               AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsCategory_Goods.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                 ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

       WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
         AND (Object_GoodsCategory.isErased = inisErased OR inisErased = TRUE);
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
-- SELECT * FROM gpSelect_Object_GoodsCategory (0, TRUE, TRUE, '2')