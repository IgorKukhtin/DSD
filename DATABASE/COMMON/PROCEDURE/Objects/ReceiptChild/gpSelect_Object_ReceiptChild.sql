-- Function: gpSelect_Object_ReceiptChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptChild(
    IN inReceiptId    Integer,
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Value TFloat, ValueWeight TFloat, ValueWeight_calc TFloat, isWeightMain Boolean, isTaxExit Boolean, isWeightTotal Boolean,
               StartDate TDateTime, EndDate TDateTime, Comment TVarChar,
               ReceiptId Integer, ReceiptName TVarChar, 
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               MeasureName TVarChar, MeasureName_calc TVarChar,
               GroupNumber Integer,
               InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar,
               Color_calc Integer,
               isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());

   RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     SELECT 
           tmpReceiptChild.Id
         , tmpReceiptChild.Value
         , tmpReceiptChild.ValueWeight
         , CASE WHEN tmpReceiptChild.isWeightTotal = TRUE THEN tmpReceiptChild.ValueWeight ELSE 0 END :: TFloat AS ValueWeight_calc

         , tmpReceiptChild.isWeightMain
         , tmpReceiptChild.isTaxExit
         , tmpReceiptChild.isWeightTotal

         , ObjectDate_StartDate.ValueData     AS StartDate
         , ObjectDate_EndDate.ValueData       AS EndDate
         , ObjectString_Comment.ValueData     AS Comment
 
         , tmpReceiptChild.ReceiptId
         , tmpReceiptChild.ReceiptName

         , Object_Goods.Id               AS GoodsId
         , Object_Goods.ObjectCode       AS GoodsCode
         , Object_Goods.ValueData        AS GoodsName

         , Object_GoodsKind.Id           AS GoodsKindId
         , Object_GoodsKind.ObjectCode   AS GoodsKindCode
         , Object_GoodsKind.ValueData    AS GoodsKindName

         , Object_Measure.ValueData      AS MeasureName
         , COALESCE (Object_Measure_calc.ValueData, Object_Measure.ValueData) :: TVarChar AS MeasureName_calc

         , tmpReceiptChild.GroupNumber

         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyCode            END :: Integer  AS InfoMoneyCode
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyGroupName       END :: TVarChar AS InfoMoneyGroupName
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyDestinationName END :: TVarChar AS InfoMoneyDestinationName
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyName            END :: TVarChar AS InfoMoneyName

         , CASE tmpReceiptChild.GroupNumber
                   WHEN 6 THEN 15993821 -- _colorRecord_GoodsPropertyId_Ice           - inGoodsId = zc_Goods_WorkIce()
                   WHEN 1 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                   WHEN 2 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyId = zc_Enum_InfoMoney_10105() -- Основное сырье + Мясное сырье + Прочее мясное сырье
                   WHEN 3 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                   WHEN 4 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                   WHEN 5 THEN 32896    -- _colorRecord_KindPackage_Composition_K_MB  -  zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   WHEN 7 THEN 35980    -- _colorRecord_KindPackage_Composition_K     - zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   WHEN 8 THEN 10965163 -- _colorRecord_KindPackage_Composition_Y     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье (осталось Оболочка + Упаковка + Прочее сырье)
                   ELSE 0 -- clBlack
             END :: Integer AS Color_calc

         , tmpReceiptChild.isErased
         
     FROM (SELECT Object_ReceiptChild.Id                          AS Id
                , Object_Receipt.Id                               AS ReceiptId
                , Object_Receipt.ValueData                        AS ReceiptName
                , ObjectLink_ReceiptChild_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_ReceiptChild_GoodsKind.ChildObjectId AS GoodsKindId
                , ObjectLink_Goods_Measure.ChildObjectId          AS MeasureId
                , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                 , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                 , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                 , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                 , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                 , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                  ) AS GroupNumber
                , zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                   , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                   , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                   , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                   , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                   , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                    ) AS isWeightTotal
                , ObjectFloat_Value.ValueData :: TFloat AS Value
                , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS ValueWeight

                , ObjectBoolean_WeightMain.ValueData AS isWeightMain
                , ObjectBoolean_TaxExit.ValueData    AS isTaxExit

                , Object_InfoMoney_View.InfoMoneyCode
                , Object_InfoMoney_View.InfoMoneyGroupName
                , Object_InfoMoney_View.InfoMoneyDestinationName
                , Object_InfoMoney_View.InfoMoneyName

                , Object_ReceiptChild.isErased AS isErased

           FROM Object AS Object_ReceiptChild
                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                     ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Receipt.isErased

                LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                        ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id
                                       AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                        ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id
                                       AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                      ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()

                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                     ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                     ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                     ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                    AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           WHERE Object_ReceiptChild.DescId = zc_Object_ReceiptChild()
             AND (ObjectLink_ReceiptChild_Receipt.ChildObjectId = inReceiptId OR inReceiptId = 0)
          ) AS tmpReceiptChild

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReceiptChild.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpReceiptChild.GoodsKindId
 
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpReceiptChild.MeasureId
          LEFT JOIN Object AS Object_Measure_calc ON Object_Measure_calc.Id = zc_Measure_Kg() AND Object_Measure.Id = zc_Measure_Sh()

          LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                               ON ObjectDate_StartDate.ObjectId = tmpReceiptChild.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ReceiptChild_Start()
          LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                               ON ObjectDate_EndDate.ObjectId = tmpReceiptChild.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ReceiptChild_End()
            
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = tmpReceiptChild.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptChild_Comment()
    ;
  
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
