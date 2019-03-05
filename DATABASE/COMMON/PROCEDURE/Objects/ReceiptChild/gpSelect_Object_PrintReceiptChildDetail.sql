-- Function: gpSelect_Object_PrintReceiptChildDetail()

DROP FUNCTION IF EXISTS gpSelect_Object_PrintReceiptChildDetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PrintReceiptChildDetail(IN ReceiptId integer, IN inSession TVarChar)

RETURNS TABLE (MainReceiptId Integer, GoodsCode Integer, GoodsName TVarChar, Value TFloat, ValueWeight TFloat,
               isWeightMain Boolean, isTaxExit Boolean, isWeightTotal Boolean,
               MeasureName TVarChar, MeasureName_calc TVarChar, InfoMoneyName TVarChar,
               GroupNumber Integer
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());
     CREATE TEMP TABLE tmpReceiptTable(id Integer) ON COMMIT DROP;
     INSERT INTO tmpReceiptTable (Id) VALUES(ReceiptId);

     RETURN QUERY 
      SELECT DD.MainReceiptId
           , DD.GoodsCode
           , DD.GoodsName
           , SUM (DD.Value) :: TFloat AS Value
           , SUM (DD.ValueWeight) :: TFloat AS ValueWeight
           , DD.isWeightMain
           , DD.isTaxExit
           , CASE WHEN DD.InfoMoneyId <> zc_Enum_InfoMoney_10202() -- Основное сырье + Прочее сырье + Оболочка
                   AND DD.InfoMoneyId <> zc_Enum_InfoMoney_10203() -- Основное сырье + Прочее сырье + Упаковка
                   AND DD.InfoMoneyId <> zc_Enum_InfoMoney_10204() -- Основное сырье + Прочее сырье + Прочее сырье
                   AND (DD.isTaxExit = FALSE
                     OR DD.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                     OR DD.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Продукция + Мясное сырье
                       )
                       THEN TRUE
                   ELSE FALSE
             END :: Boolean AS isWeightTotal
           , DD.MeasureName
           , DD.MeasureName_calc
           , DD.InfoMoneyName
           , DD.GroupNumber 
      FROM       
      (SELECT           D.MainReceiptId
                      , Object_Goods.GoodsCode
                      , Object_Goods.GoodsName
                      , D.Value
                      , (D.Value * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS ValueWeight
                      , COALESCE (ObjectBoolean_WeightMain.ValueData, FALSE) AS isWeightMain
                      , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)    AS isTaxExit                      
                      , Object_Measure.ValueData     AS MeasureName
                      , COALESCE (Object_Measure_calc.ValueData, Object_Measure.ValueData) AS MeasureName_calc
                      , Object_InfoMoney_View.InfoMoneyId
                      , CASE WHEN Object_Goods.GoodsId = zc_Goods_WorkIce() THEN '' ELSE Object_InfoMoney_View.InfoMoneyName END :: TVarChar AS InfoMoneyName
                      , zfCalc_ReceiptChild_GroupNumber (inGoodsId   := D.GoodsId
                                          , inGoodsKindId            := D.GoodsKindId
                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                          , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                          , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                           ) AS GroupNumber
       FROM lpSelect_Object_ReceiptChildDetail(0) AS D 
          LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.GoodsId = D.GoodsId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
          LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                  ON ObjectBoolean_WeightMain.ObjectId = D.ReceiptChildId 
                                 AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                  ON ObjectBoolean_TaxExit.ObjectId = D.ReceiptChildId 
                                 AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.GoodsId 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          LEFT JOIN Object AS Object_Measure_calc ON Object_Measure_calc.Id = zc_Measure_Kg() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                               ON ObjectFloat_Weight.ObjectId = Object_Goods.GoodsId
                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
         ) AS DD

      GROUP BY DD.MainReceiptId
             , DD.GoodsCode
             , DD.GoodsName
             , DD.isWeightMain
             , DD.isTaxExit
             , DD.MeasureName
             , DD.MeasureName_calc
             , DD.InfoMoneyId
             , DD.InfoMoneyName
             , DD.GroupNumber;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PrintReceiptChildDetail (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.15                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PrintReceiptChildDetail (354493, '2')
