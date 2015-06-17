-- Function: gpSelect_Object_Account(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , MeasureName TVarChar
             , Weight TFloat
             , WeightPackage TFloat, WeightTotal TFloat
             , isOrder Boolean)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT
             Object_GoodsByGoodsKind_View.Id 
           , Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
           , Object_GoodsByGoodsKind_View.GoodsKindName
           
           , Object_GoodsGroup.ValueData AS GoodsGroupName 
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
           , Object_TradeMark.ValueData      AS TradeMarkName
           , Object_GoodsTag.ValueData       AS GoodsTagName
           , Object_GoodsPlatform.ValueData  AS GoodsPlatformName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Measure.ValueData        AS MeasureName

           , ObjectFloat_Weight.ValueData AS Weight

           , COALESCE (ObjectFloat_WeightPackage.ValueData,0)::TFloat  AS WeightPackage
           , COALESCE (ObjectFloat_WeightTotal.ValueData,0)  ::TFloat  AS WeightTotal
           , COALESCE (ObjectBoolean_Order.ValueData, False)           AS isOrder
           
       FROM Object_GoodsByGoodsKind_View
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                 ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()

           LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                 ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                   ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                  AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId             

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                  ON ObjectLink_Goods_GoodsTag.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
             LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                  ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
             LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.15                                       * all
 18.03.15        * add redmine 17.03.2015
 29.01.14                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind (zfCalc_UserAdmin())
