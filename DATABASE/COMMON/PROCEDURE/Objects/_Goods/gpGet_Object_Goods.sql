-- Function: gpGet_Object_Goods()

--DROP FUNCTION gpGet_Object_Goods();

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GoodsGroupId Integer, GoodsGroupName TVarChar, 
               MeasureId Integer, MeasureName TVarChar, Weight TFloat, InfoMoneyId Integer, InfoMoneyName TVarChar) AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)   AS GoodsGroupId
           , CAST ('' as TVarChar) AS GoodsGroupName  
           , CAST (0 as Integer)   AS MeasureId
           , CAST ('' as TVarChar) AS MeasureName
           , CAST ('' as TVarChar) AS Weight
           , CAST (0 as Integer)   AS InfoMoneyId
           , CAST ('' as TVarChar) AS InfoMoneyName
       FROM Object 
       WHERE Object.DescId = zc_Object_Goods();
   ELSE
     RETURN QUERY 
     SELECT 
          Object.Id            AS Id
        , Object.ObjectCode    AS Code
        , Object.ValueData     AS Name
        , Object.isErased      AS isErased
        , GoodsGroup.Id        AS GoodsGroupId
        , GoodsGroup.ValueData AS GoodsGroupName  
        , Measure.Id           AS MeasureId
        , Measure.ValueData    AS MeasureName
        , Weight.ValueData     AS Weight
        , Object_InfoMoney.Id  AS InfoMoneyId
        , Object_InfoMoney.ValueData AS InfoMoneyName
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
LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
       ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id 
      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
LEFT JOIN Object AS Object_InfoMoney
       ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId
     WHERE Object.Id = inId;
  END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Goods(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 11.05.13                                        

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods('2')