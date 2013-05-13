-- Function: gpGet_Object_Goods()

--DROP FUNCTION gpGet_Object_Goods();

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
IN inId          Integer,       /* Товар */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GoodsGroupId Integer, GoodsGroupName TVarChar, 
               MeasureId Integer, MeasureName TVarChar, Weight TFloat) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData
     , Object.isErased
     , GoodsGroup.Id AS GoodsGroupId
     , GoodsGroup.ValueData AS GoodsGroupName  
     , Measure.Id AS MeasureId
     , Measure.ValueData AS MeasureName
     , Weight.ValueData AS Weight
     FROM Object
LEFT JOIN ObjectLink AS Goods_GoodsGroup
       ON Goods_GoodsGroup.ObjectId = Object.Id
      AND Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
LEFT JOIN Object AS GoodsGroup
       ON GoodsGroup.Id = Goods_GoodsGroup.ChildObjectId
LEFT JOIN ObjectLink AS Goods_Measure
       ON Goods_Measure.ObjectId = Object.Id 
      AND Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
LEFT JOIN Object AS Measure
       ON Measure.Id = Goods_Measure.ChildObjectId
LEFT JOIN ObjectFloat AS Weight 
       ON Weight.ObjectId = Object.Id 
      AND Weight.DescId = zc_ObjectFloat_Goods_Weight()
     WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Goods(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')