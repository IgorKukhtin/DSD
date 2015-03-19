-- Function: gpSelect_Object_ReceiptChild()

DROP FUNCTION IF EXISTS gpSelect_Object_PrintReceiptChildDetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PrintReceiptChildDetail(IN ReceiptId integer, IN inSession TVarChar)

RETURNS TABLE (MainReceiptId Integer, GoodsCode Integer, GoodsName TVarChar, Value TFloat, 
               isWeightMain Boolean, isTaxExit Boolean,
               MeasureName TVarChar, InfoMoneyName TVarChar,
               GroupNumber Integer) AS

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
           , SUM(DD.Value)::TFloat AS Value
           , DD.isWeightMain
           , DD.isTaxExit                      
           , DD.MeasureName
           , DD.InfoMoneyName
           , DD.GroupNumber 
      FROM       
      (SELECT           D.MainReceiptId
                      , Object_Goods.GoodsCode
                      , Object_Goods.GoodsName
                      , D.Value
                      , ObjectBoolean_WeightMain.ValueData AS isWeightMain
                      , ObjectBoolean_TaxExit.ValueData    AS isTaxExit                      
                      , Object_Measure.ValueData     AS MeasureName
                      , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName
                      , zfCalc_ReceiptChild_GroupNumber (inGoodsId   := D.GoodsId
                                          , inGoodsKindId            := D.GoodsKindId
                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                          , inWeightMain             := ObjectBoolean_WeightMain.ValueData
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
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId) AS DD
          
      GROUP BY DD.MainReceiptId
           , DD.GoodsCode
           , DD.GoodsName
           , DD.isWeightMain
           , DD.isTaxExit                      
           , DD.MeasureName
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

