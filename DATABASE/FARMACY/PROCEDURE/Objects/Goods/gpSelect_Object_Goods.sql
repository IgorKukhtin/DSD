-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSId Integer, NDSName TVarChar
              ) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT Object_Goods.Id           AS Id 
        , Object_Goods.ObjectCode   AS Code
        , Object_Goods.ValueData    AS Name
        , Object_Goods.isErased     AS isErased
   
        , Object_GoodsGroup.Id        AS GoodsGroupId
        , Object_GoodsGroup.ValueData AS GoodsGroupName
   
        , Object_Measure.Id        AS MeasureId
        , Object_Measure.ValueData AS MeasureName
   
        , Object_NDS.Id        AS NDSId
        , Object_NDS.ValueData AS NDSName
   
    FROM Object AS Object_Goods
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDS
                             ON ObjectLink_Goods_NDS.ObjectId = Object.Id
                            AND ObjectLink_Goods_NDS.DescId = zc_ObjectLink_Goods_NDS()
        LEFT JOIN Object AS Object_NDS ON Object_NDS.Id = ObjectLink_Goods_NDS.ChildObjectId

    WHERE Object_Goods.DescId = zc_Object_Goods();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.14         *
 20.06.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroup('2')