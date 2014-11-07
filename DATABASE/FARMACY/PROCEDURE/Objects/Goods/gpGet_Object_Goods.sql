-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_Goods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               isErased boolean
               ) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
       vbUserId := lpGetUserBySession (inSession);

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
  
   IF COALESCE (inId, 0) = 0
   THEN
       vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object_Goods.GoodsCodeInt), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
              
           , CAST (0 as Integer)    AS GoodsGroupId
           , CAST ('' as TVarChar)  AS GoodsGroupName  
           , CAST (0 as Integer)    AS MeasureId
           , CAST ('' as TVarChar)  AS MeasureName
           , CAST (0 as Integer)    AS NDSKindId
           , CAST ('' as TVarChar)  AS NDSKindName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object_Goods_View AS Object_Goods
       WHERE Object_Goods.ObjectId = vbObjectId;
   ELSE
     RETURN QUERY 
     SELECT Object_Goods.Id             AS Id 
          , Object_Goods.ObjectCode     AS Code
          , Object_Goods.ValueData      AS Name
          
          , COALESCE(Object_GoodsGroup.Id, 0)        AS GoodsGroupId
          , Object_GoodsGroup.ValueData AS GoodsGroupName
   
          , Object_Measure.Id           AS MeasureId
          , Object_Measure.ValueData    AS MeasureName
   
          , Object_NDSKind.Id               AS NDSKindId
          , Object_NDSKind.ValueData        AS NDSKindName

          , Object_Goods.isErased       AS isErased
          
     FROM Object AS Object_Goods
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
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
 30.10.14                        *
 24.06.14         *
 20.06.13                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods('2')