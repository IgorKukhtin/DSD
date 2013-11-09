-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , TradeMarkName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyId Integer
             , BusinessName TVarChar
             , FuelName TVarChar
             , Weight TFloat, isPartionCount Boolean, isPartionSumm Boolean, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId := inSession;

     RETURN QUERY 
       WITH tmpUserTransport AS (SELECT UserId FROM UserRole_View WHERE RoleId = zc_Enum_Role_Transport())
       SELECT Object_Goods.Id             AS Id
            , Object_Goods.ObjectCode     AS Code
            , Object_Goods.ValueData      AS Name

            , Object_GoodsGroup.Id         AS GoodsGroupId
            , Object_GoodsGroup.ValueData  AS GoodsGroupName 

            , Object_Measure.ValueData     AS MeasureName

            , Object_TradeMark.ValueData  AS TradeMarkName

            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyGroupName
            , Object_InfoMoney_View.InfoMoneyDestinationName
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyId

            , Object_Business.ValueData  AS BusinessName

            , Object_Fuel.ValueData    AS FuelName

            , ObjectFloat_Weight.ValueData AS Weight
            , ObjectBoolean_PartionCount.ValueData AS isPartionCount
            , ObjectBoolean_PartionSumm.ValueData  AS isPartionSumm 
            , Object_Goods.isErased       AS isErased

       FROM (SELECT Object_Goods.*
             FROM ObjectLink AS ObjectLink_Goods_Fuel
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Fuel.ObjectId
                  LEFT JOIN ObjectLink AS ObjectLink_TicketFuel_Goods
                                       ON ObjectLink_TicketFuel_Goods.ChildObjectId = Object_Goods.Id
                                      AND ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
             WHERE ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
               AND ObjectLink_Goods_Fuel.ChildObjectId > 0
               AND ObjectLink_TicketFuel_Goods.ChildObjectId IS NULL
               AND vbUserId IN (SELECT UserId FROM tmpUserTransport)
            UNION ALL
             SELECT Object_Goods.* FROM Object AS Object_Goods WHERE Object_Goods.DescId = zc_Object_Goods() AND vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
            ) AS Object_Goods
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                  AND Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
                 
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                                               AND Object_Measure.DescId = zc_Object_Measure()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                                                 AND Object_TradeMark.DescId = zc_Object_TradeMark()

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
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
      
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                    ON ObjectLink_Goods_Business.ObjectId = Object_Goods.Id 
                   AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
             LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId    
                                                AND Object_Business.DescId = zc_Object_Business()

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
 09.11.13                                        * add tmpUserTransport
 29.10.13                                        * add Object_InfoMoney_View
 02.10.13                                        * add GoodsGroupId
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 12.07.13                                        * add zc_ObjectBoolean_Goods_Partion...
 04.07.13          * + TradeMark             
 21.06.13          *              
 11.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Goods (inSession := '9818')
