-- Function: gpSelect_Object_ReceiptChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptChild (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptChild(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Value   TFloat, isWeightMain Boolean, isTaxExit Boolean,
               StartDate TDateTime, EndDate TDateTime, Comment TVarChar,
               ReceiptId Integer, ReceiptName TVarChar, 
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               MeasureName TVarChar,
               GroupNumber Integer,
               isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());

   RETURN QUERY 
     SELECT 
           Object_ReceiptChild.Id      AS Id
         , ObjectFloat_Value.ValueData AS Value  
         
         , ObjectBoolean_WeightMain.ValueData AS isWeightMain
         , ObjectBoolean_TaxExit.ValueData    AS isTaxExit
         , ObjectDate_StartDate.ValueData     AS StartDate
         , ObjectDate_EndDate.ValueData       AS EndDate
         , ObjectString_Comment.ValueData     AS Comment
 
         , Object_Receipt.Id         AS ReceiptId
         , Object_Receipt.ValueData  AS ReceiptName

         , Object_Goods.Id          AS GoodsId
         , Object_Goods.ObjectCode  AS GoodsCode
         , Object_Goods.ValueData   AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_Measure.ValueData     AS MeasureName
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce()
                     THEN 6

                WHEN Object_GoodsKind.Id = zc_GoodsKind_WorkProgress()
                  OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                     THEN 3

                WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_10105() -- Основное сырье + Мясное сырье + Прочее мясное сырье
                     THEN 2

                WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                 AND ObjectBoolean_WeightMain.ValueData = TRUE
                     THEN 5

                WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                     THEN 7

                WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                     THEN 1

                WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье (осталось Оболочка + Упаковка + Прочее сырье)
                     THEN 8

                WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                     THEN 4

                ELSE 10
           END :: Integer AS GroupNumber

         , Object_ReceiptChild.isErased AS isErased
         
     FROM Object AS Object_ReceiptChild
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                               ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
          LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_ReceiptChild_Receipt.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                               ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ReceiptChild_Goods.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

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
     
     WHERE Object_ReceiptChild.DescId = zc_Object_ReceiptChild();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReceiptChild (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.02.15                                        *all
 19.07.13         * rename zc_ObjectDate_
 09.07.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptChild ('2')
