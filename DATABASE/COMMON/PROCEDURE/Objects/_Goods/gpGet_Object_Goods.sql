-- Function: gpGet_Object_Goods()

--DROP FUNCTION gpGet_Object_Goods();

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               GoodsGroupId Integer, GoodsGroupCode Integer, GoodsGroupName TVarChar, 
               MeasureId Integer,  MeasureCode Integer, MeasureName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               Weight TFloat, isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Goods());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)   AS GoodsGroupId
           , CAST (0 as Integer)   AS GoodsGroupCode
           , CAST ('' as TVarChar) AS GoodsGroupName 
           , CAST (0 as Integer)   AS MeasureId
           , CAST (0 as Integer)   AS MeasureCode
           , CAST ('' as TVarChar) AS MeasureName
           , CAST (0 as Integer)   AS InfoMoneyId
           , CAST (0 as Integer)   AS InfoMoneyCode
           , CAST ('' as TVarChar) AS InfoMoneyName
           , CAST (0 as Integer)   AS InfoMoneyGroupId
           , CAST (0 as Integer)   AS InfoMoneyGroupCode
           , CAST ('' as TVarChar) AS InfoMoneyGroupName
           , CAST (0 as Integer)   AS InfoMoneyDestinationId
           , CAST (0 as Integer)   AS InfoMoneyDestinationCode
           , CAST ('' as TVarChar) AS InfoMoneyDestinationName
           , CAST ('' as TVarChar) AS Weight
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_Goods();
   ELSE
     RETURN QUERY 
     SELECT 
           Object_Goods.Id             AS Id
         , Object_Goods.ObjectCode     AS Code
         , Object_Goods.ValueData      AS Name
         
         , Object_GoodsGroup.Id         AS GoodsGroupId
         , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
         , Object_GoodsGroup.ValueData  AS GoodsGroupName 
          
         , Object_Measure.Id            AS MeasureId
         , Object_Measure.ObjectCode    AS MeasureCode
         , Object_Measure.ValueData     AS MeasureName
         
         , Object_InfoMoney.Id         AS InfoMoneyId
         , Object_InfoMoney.ObjectCode AS InfoMoneyCode
         , Object_InfoMoney.ValueData  AS InfoMoneyName
         
         , Object_InfoMoneyGroup.Id         AS InfoMoneyGroupId
         , Object_InfoMoneyGroup.ObjectCode AS InfoMoneyGroupCode
         , Object_InfoMoneyGroup.ValueData  AS InfoMoneyGroupName
         
         , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId
         , Object_InfoMoneyDestination.ObjectCode AS InfoMoneyDestinationCode
         , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
         
         , ObjectFloat_Weight.ValueData AS Weight
         , Object_Goods.isErased       AS isErased
     FROM OBJECT AS Object_Goods
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                 
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                 
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                
          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                 ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id 
                AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
          LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId    
          
          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                 ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id 
                AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
          LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId              
          
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
 21.06.13          *              
 11.06.13          *
 11.05.13                                        

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods (100, '2')