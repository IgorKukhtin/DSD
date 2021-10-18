-- Function: gpSelect_Object_OrderType()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderType (Integer, Boolean,TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_OrderType(
    IN inUnitId     Integer  , 
    IN inShowAll     Boolean  , 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               TermProduction TFloat, NormInDays TFloat, StartProductionInDays TFloat,
               Koeff1 TFloat, Koeff2 TFloat, 
               Koeff3 TFloat, Koeff4 TFloat,
               Koeff5 TFloat, Koeff6 TFloat, 
               Koeff7 TFloat, Koeff8 TFloat,
               Koeff9 TFloat, Koeff10 TFloat,
               Koeff11 TFloat, Koeff12 TFloat,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar,
               UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , MeasureName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , isOrderPr1 Boolean, isOrderPr2 Boolean, isOrderPr3 Boolean, isOrderPr4 Boolean, isOrderPr5 Boolean, isOrderPr6 Boolean, isOrderPr7 Boolean
             , isInPr1 Boolean, isInPr2 Boolean, isInPr3 Boolean, isInPr4 Boolean, isInPr5 Boolean, isInPr6 Boolean, isInPr7 Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_OrderType());
   vbUserId:= lpGetUserBySession (inSession);


 IF inShowAll = FALSE
 THEN
   
    RETURN QUERY 
       SELECT 
             Object_OrderType.Id          AS Id
           , Object_OrderType.ObjectCode  AS Code
           , Object_OrderType.ValueData   AS Name
           , Object_OrderType.isErased    AS isErased

           , ObjectFloat_TermProduction.ValueData        AS TermProduction
           , ObjectFloat_NormInDays.ValueData            AS NormInDays 
           , ObjectFloat_StartProductionInDays.ValueData AS StartProductionInDays 
           
           , ObjectFloat_Koeff1.ValueData AS Koeff1
           , ObjectFloat_Koeff2.ValueData AS Koeff2 
           , ObjectFloat_Koeff3.ValueData AS Koeff3
           , ObjectFloat_Koeff4.ValueData AS Koeff4
           , ObjectFloat_Koeff5.ValueData AS Koeff5
           , ObjectFloat_Koeff6.ValueData AS Koeff6
           , ObjectFloat_Koeff7.ValueData AS Koeff7
           , ObjectFloat_Koeff8.ValueData AS Koeff8
           , ObjectFloat_Koeff9.ValueData AS Koeff9           
           , ObjectFloat_Koeff10.ValueData AS Koeff10
           , ObjectFloat_Koeff11.ValueData AS Koeff11
           , ObjectFloat_Koeff12.ValueData AS Koeff12     
                                                      
           , Object_Goods.Id              AS GoodsId
           , Object_Goods.ObjectCode      AS GoodsCode
           , Object_Goods.ValueData       AS GoodsName 
           , Object_GoodsGroup.ValueData  AS GoodsGroupName 
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_Unit.Id           AS UnitId
           , Object_Unit.ObjectCode   AS UnitCode
           , Object_Unit.ValueData    AS UnitName 

           , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName             
           , Object_TradeMark.ValueData  AS TradeMarkName
           , Object_GoodsTag.ValueData   AS GoodsTagName
           , Object_Measure.ValueData    AS MeasureName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , COALESCE (ObjectBoolean_OrderPr1.ValueData, FALSE) ::Boolean AS isOrderPr1
           , COALESCE (ObjectBoolean_OrderPr2.ValueData, FALSE) ::Boolean AS isOrderPr2 
           , COALESCE (ObjectBoolean_OrderPr3.ValueData, FALSE) ::Boolean AS isOrderPr3
           , COALESCE (ObjectBoolean_OrderPr4.ValueData, FALSE) ::Boolean AS isOrderPr4
           , COALESCE (ObjectBoolean_OrderPr5.ValueData, FALSE) ::Boolean AS isOrderPr5
           , COALESCE (ObjectBoolean_OrderPr6.ValueData, FALSE) ::Boolean AS isOrderPr6
           , COALESCE (ObjectBoolean_OrderPr7.ValueData, FALSE) ::Boolean AS isOrderPr7

           , COALESCE (ObjectBoolean_InPr1.ValueData, FALSE) ::Boolean AS isInPr1
           , COALESCE (ObjectBoolean_InPr2.ValueData, FALSE) ::Boolean AS isInPr2 
           , COALESCE (ObjectBoolean_InPr3.ValueData, FALSE) ::Boolean AS isInPr3
           , COALESCE (ObjectBoolean_InPr4.ValueData, FALSE) ::Boolean AS isInPr4
           , COALESCE (ObjectBoolean_InPr5.ValueData, FALSE) ::Boolean AS isInPr5
           , COALESCE (ObjectBoolean_InPr6.ValueData, FALSE) ::Boolean AS isInPr6
           , COALESCE (ObjectBoolean_InPr7.ValueData, FALSE) ::Boolean AS isInPr7
       FROM Object AS Object_OrderType
           LEFT JOIN ObjectLink AS OrderType_Unit
                                ON OrderType_Unit.ObjectId = Object_OrderType.Id
                               AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = OrderType_Unit.ChildObjectId      

           LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                 ON ObjectFloat_TermProduction.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
           LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                 ON ObjectFloat_NormInDays.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays() 
           LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                                 ON ObjectFloat_StartProductionInDays.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays() 
                                                                                                 
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff1
                                 ON ObjectFloat_Koeff1.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff1.DescId = zc_ObjectFloat_OrderType_Koeff1()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff2
                                 ON ObjectFloat_Koeff2.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff2.DescId = zc_ObjectFloat_OrderType_Koeff2()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff3
                                 ON ObjectFloat_Koeff3.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff3.DescId = zc_ObjectFloat_OrderType_Koeff3()                             
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff4
                                 ON ObjectFloat_Koeff4.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff4.DescId = zc_ObjectFloat_OrderType_Koeff4()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff5
                                 ON ObjectFloat_Koeff5.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff5.DescId = zc_ObjectFloat_OrderType_Koeff5()                             
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff6
                                 ON ObjectFloat_Koeff6.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff6.DescId = zc_ObjectFloat_OrderType_Koeff6()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff7
                                 ON ObjectFloat_Koeff7.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff7.DescId = zc_ObjectFloat_OrderType_Koeff7()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff8
                                 ON ObjectFloat_Koeff8.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff8.DescId = zc_ObjectFloat_OrderType_Koeff8()                             
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff9
                                 ON ObjectFloat_Koeff9.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff9.DescId = zc_ObjectFloat_OrderType_Koeff9()  
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff10
                                 ON ObjectFloat_Koeff10.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff10.DescId = zc_ObjectFloat_OrderType_Koeff10()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff11
                                 ON ObjectFloat_Koeff11.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff11.DescId = zc_ObjectFloat_OrderType_Koeff11()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff12
                                 ON ObjectFloat_Koeff12.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff12.DescId = zc_ObjectFloat_OrderType_Koeff12()    
                                                                                                     
           LEFT JOIN ObjectLink AS OrderType_Goods
                                ON OrderType_Goods.ObjectId = Object_OrderType.Id
                               AND OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = OrderType_Goods.ChildObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId    

           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                  ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
             LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr1
                                     ON ObjectBoolean_OrderPr1.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr1.DescId = zc_ObjectBoolean_OrderType_OrderPr1()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr2
                                     ON ObjectBoolean_OrderPr2.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr2.DescId = zc_ObjectBoolean_OrderType_OrderPr2()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr3
                                     ON ObjectBoolean_OrderPr3.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr3.DescId = zc_ObjectBoolean_OrderType_OrderPr3()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr4
                                     ON ObjectBoolean_OrderPr4.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr4.DescId = zc_ObjectBoolean_OrderType_OrderPr4()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr5
                                     ON ObjectBoolean_OrderPr5.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr5.DescId = zc_ObjectBoolean_OrderType_OrderPr5()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr6
                                     ON ObjectBoolean_OrderPr6.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr6.DescId = zc_ObjectBoolean_OrderType_OrderPr6()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr7
                                     ON ObjectBoolean_OrderPr7.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr7.DescId = zc_ObjectBoolean_OrderType_OrderPr7()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr1
                                     ON ObjectBoolean_InPr1.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr1.DescId = zc_ObjectBoolean_OrderType_InPr1()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr2
                                     ON ObjectBoolean_InPr2.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr2.DescId = zc_ObjectBoolean_OrderType_InPr2()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr3
                                     ON ObjectBoolean_InPr3.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr3.DescId = zc_ObjectBoolean_OrderType_InPr3()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr4
                                     ON ObjectBoolean_InPr4.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr4.DescId = zc_ObjectBoolean_OrderType_InPr4()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr5
                                     ON ObjectBoolean_InPr5.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr5.DescId = zc_ObjectBoolean_OrderType_InPr5()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr6
                                     ON ObjectBoolean_InPr6.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr6.DescId = zc_ObjectBoolean_OrderType_InPr6()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr7
                                     ON ObjectBoolean_InPr7.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr7.DescId = zc_ObjectBoolean_OrderType_InPr7()
       WHERE Object_OrderType.DescId = zc_Object_OrderType()
         AND (OrderType_Unit.ChildObjectId = inUnitId OR inUnitId = 0);

   ELSE 

    RETURN QUERY
    WITH tmpGoods AS(SELECT Object_Goods.Id            AS GoodsId
                          , Object_Goods.ObjectCode    AS GoodsCode 
                          , Object_Goods.ValueData     AS GoodsName

                          , Object_InfoMoney_View.InfoMoneyCode
                          , Object_InfoMoney_View.InfoMoneyGroupName
                          , Object_InfoMoney_View.InfoMoneyDestinationName
                          , Object_InfoMoney_View.InfoMoneyName

                     FROM Object_InfoMoney_View
                          INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                          INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                           AND Object_Goods.isErased = FALSE
                     WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
                    )
         SELECT 
             COALESCE (Object_OrderType.Id, 0)::Integer           AS Id
           , COALESCE (Object_OrderType.ObjectCode, 0)::Integer   AS Code
           , COALESCE (Object_OrderType.ValueData, '')::TVarChar  AS Name
           , COALESCE (Object_OrderType.isErased, false)::Boolean AS isErased

           , COALESCE (ObjectFloat_TermProduction.ValueData, 0)::TFloat        AS TermProduction
           , COALESCE (ObjectFloat_NormInDays.ValueData, 0)::TFloat            AS NormInDays 
           , COALESCE (ObjectFloat_StartProductionInDays.ValueData, 0)::TFloat AS StartProductionInDays 
           
           , COALESCE (ObjectFloat_Koeff1.ValueData, 0)::TFloat  AS Koeff1
           , COALESCE (ObjectFloat_Koeff2.ValueData, 0)::TFloat  AS Koeff2 
           , COALESCE (ObjectFloat_Koeff3.ValueData, 0)::TFloat  AS Koeff3
           , COALESCE (ObjectFloat_Koeff4.ValueData, 0)::TFloat  AS Koeff4
           , COALESCE (ObjectFloat_Koeff5.ValueData, 0)::TFloat  AS Koeff5
           , COALESCE (ObjectFloat_Koeff6.ValueData, 0)::TFloat  AS Koeff6
           , COALESCE (ObjectFloat_Koeff7.ValueData, 0)::TFloat  AS Koeff7
           , COALESCE (ObjectFloat_Koeff8.ValueData, 0)::TFloat  AS Koeff8
           , COALESCE (ObjectFloat_Koeff9.ValueData, 0)::TFloat  AS Koeff9           
           , COALESCE (ObjectFloat_Koeff10.ValueData, 0)::TFloat  AS Koeff10
           , COALESCE (ObjectFloat_Koeff11.ValueData, 0)::TFloat  AS Koeff11
           , COALESCE (ObjectFloat_Koeff12.ValueData, 0)::TFloat  AS Koeff12                                                      
           
           , Object_Goods.GoodsId        AS GoodsId
           , Object_Goods.GoodsCode      AS GoodsCode
           , Object_Goods.GoodsName      AS GoodsName 
           , Object_GoodsGroup.ValueData AS GoodsGroupName 
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_Unit.Id           AS UnitId
           , Object_Unit.ObjectCode   AS UnitCode
           , Object_Unit.ValueData    AS UnitName 

           , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName             
           , Object_TradeMark.ValueData  AS TradeMarkName
           , Object_GoodsTag.ValueData   AS GoodsTagName
           , Object_Measure.ValueData    AS MeasureName

           , Object_Goods.InfoMoneyCode
           , Object_Goods.InfoMoneyGroupName
           , Object_Goods.InfoMoneyDestinationName
           , Object_Goods.InfoMoneyName

           , COALESCE (ObjectBoolean_OrderPr1.ValueData, FALSE) ::Boolean AS isOrderPr1
           , COALESCE (ObjectBoolean_OrderPr2.ValueData, FALSE) ::Boolean AS isOrderPr2 
           , COALESCE (ObjectBoolean_OrderPr3.ValueData, FALSE) ::Boolean AS isOrderPr3
           , COALESCE (ObjectBoolean_OrderPr4.ValueData, FALSE) ::Boolean AS isOrderPr4
           , COALESCE (ObjectBoolean_OrderPr5.ValueData, FALSE) ::Boolean AS isOrderPr5
           , COALESCE (ObjectBoolean_OrderPr6.ValueData, FALSE) ::Boolean AS isOrderPr6
           , COALESCE (ObjectBoolean_OrderPr7.ValueData, FALSE) ::Boolean AS isOrderPr7

           , COALESCE (ObjectBoolean_InPr1.ValueData, FALSE) ::Boolean AS isInPr1
           , COALESCE (ObjectBoolean_InPr2.ValueData, FALSE) ::Boolean AS isInPr2 
           , COALESCE (ObjectBoolean_InPr3.ValueData, FALSE) ::Boolean AS isInPr3
           , COALESCE (ObjectBoolean_InPr4.ValueData, FALSE) ::Boolean AS isInPr4
           , COALESCE (ObjectBoolean_InPr5.ValueData, FALSE) ::Boolean AS isInPr5
           , COALESCE (ObjectBoolean_InPr6.ValueData, FALSE) ::Boolean AS isInPr6
           , COALESCE (ObjectBoolean_InPr7.ValueData, FALSE) ::Boolean AS isInPr7
         FROM tmpGoods AS Object_Goods

           LEFT JOIN ObjectLink AS OrderType_Goods
                                ON OrderType_Goods.ChildObjectId = Object_Goods.GoodsId
                               AND OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
           LEFT JOIN Object AS Object_OrderType ON Object_OrderType.Id = OrderType_Goods.ObjectId 
                                                  AND Object_OrderType.DescId = zc_Object_OrderType()

           LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                               ON ObjectFloat_TermProduction.ObjectId = Object_OrderType.Id 
                              AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
           LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                               ON ObjectFloat_NormInDays.ObjectId = Object_OrderType.Id 
                              AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays() 
           LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                               ON ObjectFloat_StartProductionInDays.ObjectId = Object_OrderType.Id 
                              AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays() 

           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff1
                                 ON ObjectFloat_Koeff1.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff1.DescId = zc_ObjectFloat_OrderType_Koeff1()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff2
                                 ON ObjectFloat_Koeff2.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff2.DescId = zc_ObjectFloat_OrderType_Koeff2()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff3
                                 ON ObjectFloat_Koeff3.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff3.DescId = zc_ObjectFloat_OrderType_Koeff3()                             
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff4
                                 ON ObjectFloat_Koeff4.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff4.DescId = zc_ObjectFloat_OrderType_Koeff4()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff5
                                 ON ObjectFloat_Koeff5.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff5.DescId = zc_ObjectFloat_OrderType_Koeff5()                             
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff6
                                 ON ObjectFloat_Koeff6.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff6.DescId = zc_ObjectFloat_OrderType_Koeff6()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff7
                                 ON ObjectFloat_Koeff7.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff7.DescId = zc_ObjectFloat_OrderType_Koeff7()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff8
                                 ON ObjectFloat_Koeff8.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff8.DescId = zc_ObjectFloat_OrderType_Koeff8()                             
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff9
                                 ON ObjectFloat_Koeff9.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff9.DescId = zc_ObjectFloat_OrderType_Koeff9()  
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff10
                                 ON ObjectFloat_Koeff10.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff10.DescId = zc_ObjectFloat_OrderType_Koeff10()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff11
                                 ON ObjectFloat_Koeff11.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff11.DescId = zc_ObjectFloat_OrderType_Koeff11()
           LEFT JOIN ObjectFloat AS ObjectFloat_Koeff12
                                 ON ObjectFloat_Koeff12.ObjectId = Object_OrderType.Id 
                                AND ObjectFloat_Koeff12.DescId = zc_ObjectFloat_OrderType_Koeff12()                              

           LEFT  JOIN ObjectLink AS OrderType_Unit
                                ON OrderType_Unit.ObjectId = Object_OrderType.Id
                               AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (OrderType_Unit.ChildObjectId, inUnitId)
                       
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.GoodsId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId    
           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.GoodsId
                                 AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.GoodsId
                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.GoodsId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                  ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.GoodsId
                                 AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
             LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr1
                                     ON ObjectBoolean_OrderPr1.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr1.DescId = zc_ObjectBoolean_OrderType_OrderPr1()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr2
                                     ON ObjectBoolean_OrderPr2.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr2.DescId = zc_ObjectBoolean_OrderType_OrderPr2()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr3
                                     ON ObjectBoolean_OrderPr3.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr3.DescId = zc_ObjectBoolean_OrderType_OrderPr3()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr4
                                     ON ObjectBoolean_OrderPr4.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr4.DescId = zc_ObjectBoolean_OrderType_OrderPr4()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr5
                                     ON ObjectBoolean_OrderPr5.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr5.DescId = zc_ObjectBoolean_OrderType_OrderPr5()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr6
                                     ON ObjectBoolean_OrderPr6.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr6.DescId = zc_ObjectBoolean_OrderType_OrderPr6()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr7
                                     ON ObjectBoolean_OrderPr7.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr7.DescId = zc_ObjectBoolean_OrderType_OrderPr7()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr1
                                     ON ObjectBoolean_InPr1.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr1.DescId = zc_ObjectBoolean_OrderType_InPr1()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr2
                                     ON ObjectBoolean_InPr2.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr2.DescId = zc_ObjectBoolean_OrderType_InPr2()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr3
                                     ON ObjectBoolean_InPr3.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr3.DescId = zc_ObjectBoolean_OrderType_InPr3()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr4
                                     ON ObjectBoolean_InPr4.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr4.DescId = zc_ObjectBoolean_OrderType_InPr4()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr5
                                     ON ObjectBoolean_InPr5.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr5.DescId = zc_ObjectBoolean_OrderType_InPr5()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr6
                                     ON ObjectBoolean_InPr6.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr6.DescId = zc_ObjectBoolean_OrderType_InPr6()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr7
                                     ON ObjectBoolean_InPr7.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr7.DescId = zc_ObjectBoolean_OrderType_InPr7()

      WHERE (OrderType_Unit.ChildObjectId = inUnitId OR inUnitId = 0 OR OrderType_Goods.ObjectId IS NULL)
     ;
     END IF;
  
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_OrderType (Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.10.21         *
 11.03.15         *


*/

-- тест
--SELECT * FROM gpSelect_Object_OrderType (0,True,zfCalc_UserAdmin())
--  SELECT * FROM gpSelect_Object_OrderType (0,False,zfCalc_UserAdmin())
