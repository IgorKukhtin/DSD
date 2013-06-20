-- Function: gpGet_Object_Goods()

--DROP FUNCTION gpGet_Object_Goods();

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,
               GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupCode Integer, 
               MeasureId Integer, MeasureName TVarChar, MeasureCode Integer, Weight TFloat,
               InfoMoneyId Integer, InfoMoneyName TVarChar, InfoMoneyCode Integer,
               InfoMoneyGroupId Integer, InfoMoneyGroupName TVarChar, InfoMoneyGroupCode Integer, 
               InfoMoneyDestinationId Integer, InfoMoneyDestinationName TVarChar, InfoMoneyDestinationCode Integer) AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Goods());
  
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
           , CAST (0 as Integer)   AS GoodsGroupCode
           , CAST (0 as Integer)   AS MeasureId
           , CAST ('' as TVarChar) AS MeasureName
           , CAST (0 as Integer)   AS MeasureCode
           , CAST ('' as TVarChar) AS Weight
           , CAST (0 as Integer)   AS InfoMoneyId
           , CAST ('' as TVarChar) AS InfoMoneyName
           , CAST (0 as Integer)   AS InfoMoneyCode
          
           , CAST (0 as Integer)   AS InfoMoneyGroupId
           , CAST ('' as TVarChar) AS InfoMoneyGroupName
           , CAST (0 as Integer)   AS InfoMoneyGroupCode
           , CAST (0 as Integer)   AS InfoMoneyDestinationId
           , CAST ('' as TVarChar) AS InfoMoneyDestinationName
           , CAST (0 as Integer)   AS InfoMoneyDestinationCode

       FROM Object 
       WHERE Object.DescId = zc_Object_Goods();
   ELSE
     RETURN QUERY 
     SELECT 
           Object_Goods.Id             AS Id
         , Object_Goods.ObjectCode     AS Code
         , Object_Goods.ValueData      AS Name
         , Object_Goods.isErased       AS isErased
         , GoodsGroup.Id         AS GoodsGroupId
         , GoodsGroup.ValueData  AS GoodsGroupName  
         , GoodsGroup.ObjectCode AS GoodsGroupCode
          
         , Measure.Id            AS MeasureId
         , Measure.ValueData     AS MeasureName
         , Measure.ObjectCode    AS MeasureCode
         , Weight.ValueData      AS Weight
         
         , Object_InfoMoney.Id         AS InfoMoneyId
         , Object_InfoMoney.ValueData  AS InfoMoneyName
         , Object_InfoMoney.ObjectCode AS InfoMoneyCode
         
         , CAST (0 as Integer)   AS InfoMoneyGroupId
         , CAST ('' as TVarChar) AS InfoMoneyGroupName
         , CAST (0 as Integer)   AS InfoMoneyGroupCode
         , CAST (0 as Integer)   AS InfoMoneyDestinationId
         , CAST ('' as TVarChar) AS InfoMoneyDestinationName
         , CAST (0 as Integer)   AS InfoMoneyDestinationCode
        
        
        
     FROM OBJECT AS Object_Goods
LEFT JOIN ObjectLink AS Goods_GoodsGroup
       ON Goods_GoodsGroup.ObjectId = Object_Goods.Id
      AND Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
LEFT JOIN Object AS GoodsGroup
       ON GoodsGroup.Id = Goods_GoodsGroup.ChildObjectId
LEFT JOIN ObjectLink AS Goods_Measure
       ON Goods_Measure.ObjectId = Object_Goods.Id 
      AND Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
LEFT JOIN Object AS Measure
       ON Measure.Id = Goods_Measure.ChildObjectId
LEFT JOIN ObjectFloat AS Weight 
       ON Weight.ObjectId = Object_Goods.Id 
      AND Weight.DescId = zc_ObjectFloat_Goods_Weight()
LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
LEFT JOIN Object AS Object_InfoMoney
       ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId
     WHERE Object_Goods.Id = inId;
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