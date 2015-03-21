-- Function: gpSelect_Object_ReceiptChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptChild(
    IN inReceiptId    Integer,
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Value TFloat, ValueWeight TFloat, isWeightMain Boolean, isTaxExit Boolean, isWeightTotal Boolean,
               StartDate TDateTime, EndDate TDateTime, Comment TVarChar,
               ReceiptId Integer, ReceiptName TVarChar, 
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               MeasureName TVarChar, MeasureName_calc TVarChar,
               GroupNumber Integer,
               InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar,
               isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());

   RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     SELECT 
           Object_ReceiptChild.Id      AS Id
         , ObjectFloat_Value.ValueData AS Value
         , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS ValueWeight
         
         , ObjectBoolean_WeightMain.ValueData AS isWeightMain
         , ObjectBoolean_TaxExit.ValueData    AS isTaxExit
         , CASE WHEN Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10202() -- Основное сырье + Прочее сырье + Оболочка
                 AND Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10203() -- Основное сырье + Прочее сырье + Упаковка
                 AND Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10204() -- Основное сырье + Прочее сырье + Прочее сырье
                 -- AND COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE) = FALSE
                     THEN TRUE
                 ELSE FALSE
           END :: Boolean AS isWeightTotal
         , ObjectDate_StartDate.ValueData     AS StartDate
         , ObjectDate_EndDate.ValueData       AS EndDate
         , ObjectString_Comment.ValueData     AS Comment
 
         , Object_Receipt.Id             AS ReceiptId
         , Object_Receipt.ValueData      AS ReceiptName

         , Object_Goods.Id               AS GoodsId
         , Object_Goods.ObjectCode       AS GoodsCode
         , Object_Goods.ValueData        AS GoodsName

         , Object_GoodsKind.Id           AS GoodsKindId
         , Object_GoodsKind.ObjectCode   AS GoodsKindCode
         , Object_GoodsKind.ValueData    AS GoodsKindName

         , Object_Measure.ValueData      AS MeasureName
         , COALESCE (Object_Measure_calc.ValueData, Object_Measure.ValueData) AS MeasureName_calc

         , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := Object_Goods.Id
                                          , inGoodsKindId            := Object_GoodsKind.Id
                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                          , inWeightMain             := ObjectBoolean_WeightMain.ValueData
                                           ) AS GroupNumber

         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN 0 ELSE Object_InfoMoney_View.InfoMoneyCode END :: Integer AS InfoMoneyCode
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN '' ELSE Object_InfoMoney_View.InfoMoneyGroupName END :: TVarChar AS InfoMoneyGroupName
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN '' ELSE Object_InfoMoney_View.InfoMoneyDestinationName END :: TVarChar AS InfoMoneyDestinationName
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN '' ELSE Object_InfoMoney_View.InfoMoneyName END :: TVarChar AS InfoMoneyName

         , Object_ReceiptChild.isErased AS isErased
         
     FROM Object AS Object_ReceiptChild
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                               ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
          LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_ReceiptChild_Receipt.ChildObjectId
          INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Receipt.isErased

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                               ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ReceiptChild_Goods.ChildObjectId
 
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                               ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          LEFT JOIN Object AS Object_Measure_calc ON Object_Measure_calc.Id = zc_Measure_Kg() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()


          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                               ON ObjectDate_StartDate.ObjectId = Object_ReceiptChild.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ReceiptChild_Start()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                               ON ObjectDate_EndDate.ObjectId = Object_ReceiptChild.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ReceiptChild_End()
            
          LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                  ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id
                                 AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                  ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id
                                 AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptChild.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptChild_Comment()
          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()

     WHERE Object_ReceiptChild.DescId = zc_Object_ReceiptChild()
       AND (ObjectLink_ReceiptChild_Receipt.ChildObjectId = inReceiptId OR inReceiptId = 0);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReceiptChild (Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.03.15                                       * add inReceiptId
 18.03.15                        * InfoMoneyName
 14.02.15                                        *all
 19.07.13         * rename zc_ObjectDate_
 09.07.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptChild (352371, FALSE, '2') ORDER BY GroupNumber
