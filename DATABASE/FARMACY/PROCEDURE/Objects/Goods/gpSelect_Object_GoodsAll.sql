-- Function: gpSelect_Object_GoodsAll()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsAll (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsAll (
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               isErased boolean
              ) AS
$BODY$
BEGIN 

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
       SELECT 
             ObjectBoolean_Goods_isMain.ObjectId              AS Id
           , Object_Goods.ObjectCode                          AS Code
           , Object_Goods.ValueData                           AS Name
          
           , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                      AS GoodsGroupName
           , ObjectLink_Goods_Measure.ChildObjectId           AS MeasureId
           , Object_Measure.ValueData                         AS MeasureName
           , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
           , Object_NDSKind.ValueData                         AS NDSKindName

           , Object_Goods.isErased                            AS isErased
           
       FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId

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

            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()  

      WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.16         *
*/

-- тест
 --SELECT * FROM gpSelect_Object_GoodsAll('2')