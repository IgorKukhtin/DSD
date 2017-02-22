-- Function: gpSelect_Object_Account(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , MeasureName TVarChar
             , Weight TFloat
             , WeightPackage TFloat, WeightTotal TFloat, ChangePercentAmount TFloat
             , isOrder Boolean, isScaleCeh Boolean
             , GoodsSubId Integer, GoodsSubCode Integer, GoodsSubName TVarChar, MeasureSubName TVarChar
             , GoodsKindSubId Integer, GoodsKindSubName TVarChar
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT
             Object_GoodsByGoodsKind_View.Id 
           , Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
           , Object_GoodsByGoodsKind_View.GoodsKindId
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
           , COALESCE (ObjectFloat_ChangePercentAmount.ValueData,0)  ::TFloat  AS ChangePercentAmount
           , COALESCE (ObjectBoolean_Order.ValueData, False)           AS isOrder
           , COALESCE (ObjectBoolean_ScaleCeh.ValueData, False)        AS isScaleCeh

           , Object_GoodsSub.Id               AS GoodsSubId
           , Object_GoodsSub.ObjectCode       AS GoodsSubCode
           , Object_GoodsSub.ValueData        AS GoodsSubName
           , Object_MeasureSub.ValueData      AS MeasureSubName

           , Object_GoodsKindSub.Id           AS GoodsKindSubId
           , Object_GoodsKindSub.ValueData    AS GoodsKindSubName

           , Object_Receipt.Id                AS ReceiptId
           , ObjectString_Code.ValueData      AS ReceiptCode
           , Object_Receipt.ValueData         AS ReceiptName
         
       FROM Object_GoodsByGoodsKind_View
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                 ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()

           LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                 ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
                                                         
           LEFT JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                 ON ObjectFloat_ChangePercentAmount.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_ChangePercentAmount.DescId = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
                                                                
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                   ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                  AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_ScaleCeh
                                   ON ObjectBoolean_ScaleCeh.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                  AND ObjectBoolean_ScaleCeh.DescId = zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh()

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

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
           LEFT JOIN Object AS Object_GoodsSub ON Object_GoodsSub.Id = ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_GoodsSub_Measure
                                ON ObjectLink_GoodsSub_Measure.ObjectId = Object_GoodsSub.Id
                               AND ObjectLink_GoodsSub_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_MeasureSub ON Object_MeasureSub.Id = ObjectLink_GoodsSub_Measure.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
           LEFT JOIN Object AS Object_GoodsKindSub ON Object_GoodsKindSub.Id = ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Receipt
                                ON ObjectLink_GoodsByGoodsKind_Receipt.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectLink_GoodsByGoodsKind_Receipt.DescId = zc_ObjectLink_GoodsByGoodsKind_Receipt()
           LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_GoodsByGoodsKind_Receipt.ChildObjectId
           LEFT JOIN ObjectString AS ObjectString_Code
                                  ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                 AND ObjectString_Code.DescId   = zc_ObjectString_Receipt_Code()

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�. 
 22.02.17        * add ChangePercentAmount
 08.12.16        * add isScaleCeh
 27.10.16        * add zc_ObjectLink_GoodsByGoodsKind_Receipt
 26.07.16        *
 17.06.15                                       * all
 18.03.15        * add redmine 17.03.2015
 29.01.14                        * 
*/
/*
select BarCodeShort from (
select GoodsName, BarCodeShort from gpSelect_Object_GoodsPropertyValue(inGoodsPropertyId := 0 , inShowAll := 'False' ,  inSession := '5') as a
where BarCodeShort <> ''
group by GoodsName, BarCodeShort
) aS A
group by BarCodeShort
having count (*) > 1
*/
-- ����
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind (zfCalc_UserAdmin())
