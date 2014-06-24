-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_Goods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSId Integer, NDSName TVarChar
               ) AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object_Goods.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           
           , CAST (0 as Integer)    AS GoodsGroupId
           , CAST ('' as TVarChar)  AS GoodsGroupName  
           , CAST (0 as Integer)    AS MeasureId
           , CAST ('' as TVarChar)  AS MeasureName
           , CAST (0 as Integer)    AS NDSId
           , CAST ('' as TVarChar)  AS NDSName
          
       FROM Object AS Object_Goods
       WHERE Object_Goods.DescId = zc_Object_Goods();
   ELSE
     RETURN QUERY 
     SELECT Object_Goods.Id             AS Id 
          , Object_Goods.ObjectCode     AS Code
          , Object_Goods.ValueData      AS Name
          , Object_Goods.isErased       AS isErased
          
          , Object_GoodsGroup.Id        AS GoodsGroupId
          , Object_GoodsGroup.ValueData AS GoodsGroupName
   
          , Object_Measure.Id           AS MeasureId
          , Object_Measure.ValueData    AS MeasureName
   
          , Object_NDS.Id               AS NDSId
          , Object_NDS.ValueData        AS NDSName
          
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
    WHERE Object_Goods.Id = inId;
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Goods(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.14         *
 20.06.13                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods('2')