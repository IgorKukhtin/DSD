-- Function: lpUpdate_Object_Receipt_Total()

DROP FUNCTION IF EXISTS lpUpdate_Object_Receipt_Total (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Receipt_Total(
    IN inReceiptId                  Integer   , -- ключ объекта
    IN inUserId                     Integer   
)
RETURNS VOID
AS
$BODY$
BEGIN
   -- сохранили свойство <Вес упаковки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TotalWeightMain(), inReceiptId, tmp.TotalWeightMain)
         , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TotalWeight(), inReceiptId, tmp.TotalWeight)
   FROM Object AS Object_Receipt
        LEFT JOIN (SELECT ObjectLink_ReceiptChild_Receipt.ChildObjectId AS ReceiptId
                        , SUM (CASE WHEN ObjectBoolean_WeightMain.ValueData = TRUE THEN COALESCE (ObjectFloat_Value.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS TotalWeightMain
                        , SUM (CASE WHEN Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10202() -- Основное сырье + Прочее сырье + Оболочка
                                     AND Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10203() -- Основное сырье + Прочее сырье + Упаковка
                                     AND Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10204() -- Основное сырье + Прочее сырье + Прочее сырье
                                     -- AND COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE) = FALSE
                                         THEN COALESCE (ObjectFloat_Value.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS TotalWeight
                   FROM ObjectLink AS ObjectLink_ReceiptChild_Receipt
                        INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                AND Object_ReceiptChild.isErased = FALSE
                        LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                              ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()

                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                             ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                            AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                             ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                            ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                           AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id 
                                               AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                               AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()

                   WHERE ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                     AND ObjectLink_ReceiptChild_Receipt.ChildObjectId = inReceiptId
                   GROUP BY ObjectLink_ReceiptChild_Receipt.ChildObjectId
                  ) AS tmp ON tmp.ReceiptId = inReceiptId
    WHERE Object_Receipt.Id = inReceiptId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_Object_Receipt_Total (Integer, Integer) OWNER TO postgres;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.02.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Receipt_Total ()
