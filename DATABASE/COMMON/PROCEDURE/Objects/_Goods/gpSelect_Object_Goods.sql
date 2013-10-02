-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , TradeMarkName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , BusinessName TVarChar
             , FuelName TVarChar
             , Weight TFloat, isPartionCount Boolean, isPartionSumm Boolean, isErased Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Goods());

   RETURN QUERY 
     SELECT 
           Object_Goods.Id             AS Id
         , Object_Goods.ObjectCode     AS Code
         , Object_Goods.ValueData      AS Name

         , Object_GoodsGroup.Id         AS GoodsGroupId
         , Object_GoodsGroup.ValueData  AS GoodsGroupName 

         , Object_Measure.ValueData     AS MeasureName

         , Object_TradeMark.ValueData  AS TradeMarkName

         , Object_InfoMoney.ObjectCode AS InfoMoneyCode
         , Object_InfoMoney.ValueData  AS InfoMoneyName

         , Object_InfoMoneyGroup.ValueData  AS InfoMoneyGroupName

         , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName

         , Object_Business.ValueData  AS BusinessName

         , Object_Fuel.ValueData    AS FuelName

         , ObjectFloat_Weight.ValueData AS Weight
         , ObjectBoolean_PartionCount.ValueData AS isPartionCount
         , ObjectBoolean_PartionSumm.ValueData  AS isPartionSumm
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

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
          
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                  ON ObjectBoolean_PartionCount.ObjectId = Object_Goods.Id 
                                 AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                  ON ObjectBoolean_PartionSumm.ObjectId = Object_Goods.Id 
                                 AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

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
      
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                 ON ObjectLink_Goods_Business.ObjectId = Object_Goods.Id 
                AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId              

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
          LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId    

  WHERE Object_Goods.DescId = zc_Object_Goods()
  ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.10.13                                        * add GoodsGroupId
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 12.07.13                                        * add zc_ObjectBoolean_Goods_Partion...
 04.07.13          * + TradeMark             
 21.06.13          *              
 11.06.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods('2')