-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_Goods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Weight TFloat
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer,  MeasureName TVarChar
             , TradeMarkId Integer,  TradeMarkName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , FuelId Integer, FuelName TVarChar
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Goods());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Goods()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as TFloat)     AS Weight

           , CAST (0 as Integer)   AS GoodsGroupId
           , CAST ('' as TVarChar) AS GoodsGroupName 
           
           , CAST (0 as Integer)   AS MeasureId
           , CAST ('' as TVarChar) AS MeasureName
           
           , CAST (0 as Integer)   AS TradeMarkId
           , CAST ('' as TVarChar) AS TradeMarkName
           
           , CAST (0 as Integer)   AS InfoMoneyId
           , CAST ('' as TVarChar) AS InfoMoneyName
           
           , CAST (0 as Integer)   AS BusinessId
           , CAST ('' as TVarChar) AS BusinessName

           , CAST (0 as Integer)   AS FuelId
           , CAST ('' as TVarChar) AS FuelName
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Goods.Id              AS Id
           , Object_Goods.ObjectCode      AS Code
           , Object_Goods.ValueData       AS Name
           , ObjectFloat_Weight.ValueData AS Weight
         
           , Object_GoodsGroup.Id         AS GoodsGroupId
           , Object_GoodsGroup.ValueData  AS GoodsGroupName 
          
           , Object_Measure.Id            AS MeasureId
           , Object_Measure.ValueData     AS MeasureName

           , Object_TradeMark.Id          AS TradeMarkId
           , Object_TradeMark.ValueData   AS TradeMarkName
         
           , Object_InfoMoney.Id          AS InfoMoneyId
           , Object_InfoMoney.ValueData   AS InfoMoneyName
         
           , Object_Business.Id           AS BusinessId
           , Object_Business.ValueData    AS BusinessName

           , Object_Fuel.Id           AS FuelId
           , Object_Fuel.ValueData    AS FuelName

       FROM Object AS Object_Goods
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                 
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight 
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                
          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                               ON ObjectLink_Goods_Business.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId    
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
          LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId    

       WHERE Object_Goods.Id = inId;

   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Goods (Integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 06.09.13                          *              
 02.07.13          * + TradeMark             
 02.07.13                                        * 1251Cyr
 21.06.13          *              
 11.06.13          *
 11.05.13                                        

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods (100, '2')