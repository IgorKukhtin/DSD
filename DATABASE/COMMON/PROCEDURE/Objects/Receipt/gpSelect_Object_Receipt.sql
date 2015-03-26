-- Function: gpSelect_Object_Receipt()

DROP FUNCTION IF EXISTS gpSelect_Object_Receipt (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Receipt(
    IN inReceiptId    Integer,
    IN inGoodsId      Integer,
    IN inGoodsKindId  Integer,
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ReceiptCode TVarChar, Comment TVarChar,
               Value TFloat, ValueCost TFloat, TaxExit TFloat, PartionValue TFloat, PartionCount TFloat, WeightPackage TFloat,
               TotalWeightMain TFloat, TotalWeight TFloat,
               StartDate TDateTime, EndDate TDateTime,
               isMain Boolean,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               GoodsKindCompleteId Integer, GoodsKindCompleteCode Integer, GoodsKindCompleteName TVarChar, GoodsKindCompleteId_calc Integer, GoodsKindCompleteName_calc TVarChar,
               ReceiptCostId Integer, ReceiptCostCode Integer, ReceiptCostName TVarChar,
               ReceiptKindId Integer, ReceiptKindCode Integer, ReceiptKindName TVarChar,
               MeasureName TVarChar
             , Code_Parent Integer, Name_Parent TVarChar, ReceiptCode_Parent TVarChar, isMain_Parent Boolean
             , GoodsCode_Parent Integer, GoodsName_Parent TVarChar, MeasureName_Parent TVarChar
             , GoodsKindName_Parent TVarChar, GoodsKindCompleteName_Parent TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, TradeMarkName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , isCheck_Parent Boolean
             , isErased Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Receipt());

   RETURN QUERY
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     SELECT
           Object_Receipt.Id         AS Id
         , Object_Receipt.ObjectCode AS Code
         , Object_Receipt.ValueData  AS Name

         , ObjectString_Code.ValueData    AS ReceiptCode
         , ObjectString_Comment.ValueData AS Comment

         , ObjectFloat_Value.ValueData         AS Value
         , ObjectFloat_ValueCost.ValueData     AS ValueCost
         , ObjectFloat_TaxExit.ValueData       AS TaxExit
         , ObjectFloat_PartionValue.ValueData  AS PartionValue
         , ObjectFloat_PartionCount.ValueData  AS PartionCount
         , ObjectFloat_WeightPackage.ValueData AS WeightPackage
         , ObjectFloat_TotalWeightMain.ValueData AS TotalWeightMain
         , ObjectFloat_TotalWeight.ValueData     AS TotalWeight

         , ObjectDate_StartDate.ValueData AS StartDate
         , ObjectDate_EndDate.ValueData   AS EndDate

         , ObjectBoolean_Main.ValueData AS isMain

         , Object_Goods.Id          AS GoodsId
         , Object_Goods.ObjectCode  AS GoodsCode
         , Object_Goods.ValueData   AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_GoodsKindComplete.Id          AS GoodsKindCompleteId
         , Object_GoodsKindComplete.ObjectCode  AS GoodsKindCompleteCode
         , Object_GoodsKindComplete.ValueData   AS GoodsKindCompleteName
         , COALESCE (Object_GoodsKindComplete.Id, Object_GoodsKindComplete_basis.Id) :: Integer                AS GoodsKindCompleteId_calc
         , COALESCE (Object_GoodsKindComplete.ValueData, Object_GoodsKindComplete_basis.ValueData) :: TVarChar AS GoodsKindCompleteName_calc


         , Object_ReceiptCost.Id          AS ReceiptCostId
         , Object_ReceiptCost.ObjectCode  AS ReceiptCostCode
         , Object_ReceiptCost.ValueData   AS ReceiptCostName

         , Object_ReceiptKind.Id          AS ReceiptKindId
         , Object_ReceiptKind.ObjectCode  AS ReceiptKindCode
         , Object_ReceiptKind.ValueData   AS ReceiptKindName

         , Object_Measure.ValueData     AS MeasureName

         , Object_Receipt_Parent.ObjectCode      AS Code_Parent
         , Object_Receipt_Parent.ValueData       AS Name_Parent
         , ObjectString_Code_Parent.ValueData    AS ReceiptCode_Parent
         , ObjectBoolean_Main_Parent.ValueData   AS isMain_Parent
         , Object_Goods_Parent.ObjectCode              AS GoodsCode_Parent
         , Object_Goods_Parent.ValueData               AS GoodsName_Parent
         , Object_Measure_Parent.ValueData             AS MeasureName_Parent
         , Object_GoodsKind_Parent.ValueData           AS GoodsKindName_Parent
         , Object_GoodsKindComplete_Parent.ValueData   AS GoodsKindCompleteName_Parent

         , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
         , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
         , Object_GoodsTag.ValueData                   AS GoodsTagName
         , Object_TradeMark.ValueData                  AS TradeMarkName

         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyGroupName
         , Object_InfoMoney_View.InfoMoneyDestinationName
         , Object_InfoMoney_View.InfoMoneyName

         , CASE WHEN Object_Goods.Id <> Object_Goods_Parent.Id THEN TRUE ELSE FALSE END AS isCheck_Parent
         , Object_Receipt.isErased AS isErased

     FROM Object AS Object_Receipt
          INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Receipt.isErased

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                               ON ObjectLink_Receipt_Parent.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
          LEFT JOIN Object AS Object_Receipt_Parent ON Object_Receipt_Parent.Id = ObjectLink_Receipt_Parent.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Code_Parent
                                 ON ObjectString_Code_Parent.ObjectId = Object_Receipt_Parent.Id
                                AND ObjectString_Code_Parent.DescId = zc_ObjectString_Receipt_Code()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent
                               ON ObjectLink_Receipt_Goods_Parent.ObjectId = Object_Receipt_Parent.Id
                              AND ObjectLink_Receipt_Goods_Parent.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = ObjectLink_Receipt_Goods_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_Parent
                               ON ObjectLink_Goods_Measure_Parent.ObjectId = Object_Goods_Parent.Id 
                              AND ObjectLink_Goods_Measure_Parent.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure_Parent ON Object_Measure_Parent.Id = ObjectLink_Goods_Measure_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent
                              ON ObjectLink_Receipt_GoodsKind_Parent.ObjectId = Object_Receipt_Parent.Id
                             AND ObjectLink_Receipt_GoodsKind_Parent.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = ObjectLink_Receipt_GoodsKind_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete_Parent
                               ON ObjectLink_Receipt_GoodsKindComplete_Parent.ObjectId = Object_Receipt_Parent.Id
                              AND ObjectLink_Receipt_GoodsKindComplete_Parent.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
          LEFT JOIN Object AS Object_GoodsKindComplete_Parent ON Object_GoodsKindComplete_Parent.Id = ObjectLink_Receipt_GoodsKindComplete_Parent.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_Parent
                                  ON ObjectBoolean_Main_Parent.ObjectId = Object_Receipt_Parent.Id
                                 AND ObjectBoolean_Main_Parent.DescId = zc_ObjectBoolean_Receipt_Main()


          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                               ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Receipt_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                               ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Receipt_GoodsKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                               ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = ObjectLink_Receipt_GoodsKindComplete.ChildObjectId
          LEFT JOIN Object AS Object_GoodsKindComplete_basis ON Object_GoodsKindComplete_basis.Id = zc_GoodsKind_Basis()
                                                            AND Object_InfoMoney_View.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_10000() -- Основное сырье

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_ReceiptCost
                               ON ObjectLink_Receipt_ReceiptCost.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_ReceiptCost.DescId = zc_ObjectLink_Receipt_ReceiptCost()
          LEFT JOIN Object AS Object_ReceiptCost ON Object_ReceiptCost.Id = ObjectLink_Receipt_ReceiptCost.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_ReceiptKind
                               ON ObjectLink_Receipt_ReceiptKind.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_ReceiptKind.DescId = zc_ObjectLink_Receipt_ReceiptKind()
          LEFT JOIN Object AS Object_ReceiptKind ON Object_ReceiptKind.Id = ObjectLink_Receipt_ReceiptKind.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                               ON ObjectDate_StartDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_Receipt_Start()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_Receipt_End()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()

          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Receipt.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Receipt_Comment()

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()

          LEFT JOIN ObjectFloat AS ObjectFloat_ValueCost
                                ON ObjectFloat_ValueCost.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_ValueCost.DescId = zc_ObjectFloat_Receipt_ValueCost()

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionValue
                                ON ObjectFloat_PartionValue.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_PartionValue.DescId = zc_ObjectFloat_Receipt_PartionValue()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionCount
                                ON ObjectFloat_PartionCount.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_PartionCount.DescId = zc_ObjectFloat_Receipt_PartionCount()

          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_Receipt_WeightPackage()

          LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeightMain
                                ON ObjectFloat_TotalWeightMain.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TotalWeightMain.DescId = zc_ObjectFloat_Receipt_TotalWeightMain()
          LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeight
                                ON ObjectFloat_TotalWeight.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TotalWeight.DescId = zc_ObjectFloat_Receipt_TotalWeight()

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                               ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                               ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

     WHERE Object_Receipt.DescId = zc_Object_Receipt()
       AND (Object_Receipt.Id = inReceiptId OR inReceiptId = 0)
       AND (ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
       AND (ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId OR inGoodsKindId = 0);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Receipt (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.03.15                                       * add inReceiptId
 23.02.15        * add 
 14.02.15                                      *all
 19.07.13        * reName zc_ObjectDate_
 10.07.13        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Receipt (0, 0, 0, FALSE, zfCalc_UserAdmin())
