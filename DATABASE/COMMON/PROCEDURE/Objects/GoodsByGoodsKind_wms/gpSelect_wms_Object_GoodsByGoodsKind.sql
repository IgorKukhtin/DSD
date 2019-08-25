 -- Function: gpSelect_wms_Object_GoodsByGoodsKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_wms_Object_GoodsByGoodsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_wms_Object_GoodsByGoodsKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             
             , WeightMin   TFloat
             , WeightMax   TFloat
             , WeightAvg   TFloat
             , NormInDays  TFloat
             , Height      TFloat
             , Length      TFloat
             , Width       TFloat
             , BoxWeight   TFloat      
             , WeightOnBox TFloat
             , CountOnBox  TFloat
             , WmsCode     Integer
             , WmsCellNum  Integer
             , isGoodsTypeKind_Sh Boolean, isGoodsTypeKind_Nom Boolean, isGoodsTypeKind_Ves Boolean
             , IsErased Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());

     RETURN QUERY
       --
       SELECT
             Object_GoodsByGoodsKind.ObjectId   AS Id
           , Object_GoodsByGoodsKind.GoodsId    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , Object_GoodsGroup.ValueData        AS GoodsGroupName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
           , Object_TradeMark.ValueData         AS TradeMarkName
           , Object_GoodsTag.ValueData          AS GoodsTagName
           , Object_GoodsPlatform.ValueData     AS GoodsPlatformName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_GoodsByGoodsKind.WeightMin   ::TFloat
           , Object_GoodsByGoodsKind.WeightMax   ::TFloat
           , ((COALESCE (Object_GoodsByGoodsKind.WeightMin,0) + COALESCE (Object_GoodsByGoodsKind.WeightMax,0)) / 2) :: TFloat AS WeightAvg
           , Object_GoodsByGoodsKind.NormInDays  ::TFloat
           , Object_GoodsByGoodsKind.Height      ::TFloat
           , Object_GoodsByGoodsKind.Length      ::TFloat
           , Object_GoodsByGoodsKind.Width       ::TFloat
           , Object_GoodsByGoodsKind.BoxWeight   ::TFloat      
           , Object_GoodsByGoodsKind.WeightOnBox ::TFloat
           , Object_GoodsByGoodsKind.CountOnBox  ::TFloat
           , Object_GoodsByGoodsKind.WmsCode
           , Object_GoodsByGoodsKind.WmsCellNum  ::Integer

           , CASE WHEN COALESCE (Object_GoodsByGoodsKind.GoodsTypeKindId_Sh, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Sh
           , CASE WHEN COALESCE (Object_GoodsByGoodsKind.GoodsTypeKindId_Nom, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Nom
           , CASE WHEN COALESCE (Object_GoodsByGoodsKind.GoodsTypeKindId_Ves, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Ves
           
           , Object_GoodsByGoodsKind.IsErased

       FROM wms_Object_GoodsByGoodsKind AS Object_GoodsByGoodsKind
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = Object_GoodsByGoodsKind.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_GoodsByGoodsKind.GoodsKindId
            LEFT JOIN Object AS Object_Measure   ON Object_Measure.Id   = Object_GoodsByGoodsKind.MeasureId
            LEFT JOIN Object AS Object_Box       ON Object_Box.Id       = Object_GoodsByGoodsKind.BoxId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                 ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
            LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                 ON ObjectLink_Goods_GoodsTag.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                 ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
            LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.08.19        *
 23.05.19        *
*/
-- тест
-- SELECT * FROM gpSelect_wms_Object_GoodsByGoodsKind('3')
