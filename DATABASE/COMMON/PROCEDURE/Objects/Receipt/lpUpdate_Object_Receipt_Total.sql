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
   -- сохранили свойство <Итого вес основного сырья (100 кг.)> + <Итого вес закладки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TotalWeightMain(), inReceiptId, tmp.TotalWeightMain)
         , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TotalWeight(), inReceiptId, tmp.TotalWeight)
   FROM Object AS Object_Receipt
        LEFT JOIN (SELECT ObjectLink_ReceiptChild_Receipt.ChildObjectId AS ReceiptId
                        , SUM (CASE WHEN ObjectBoolean_WeightMain.ValueData = TRUE THEN COALESCE (ObjectFloat_Value.ValueData, 0) ELSE 0 END
                             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                              ) AS TotalWeightMain
                        , SUM (CASE WHEN TRUE
                                       = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                                          , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                                          , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                                          , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                                           )
                                         THEN COALESCE (ObjectFloat_Value.ValueData, 0) ELSE 0
                               END
                             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                              ) AS TotalWeight
                   FROM ObjectLink AS ObjectLink_ReceiptChild_Receipt
                        INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                AND Object_ReceiptChild.isErased = FALSE
                        LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                              ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()

                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                             ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                            AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                            ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                           AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()

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

   -- сохранили свойство <% выхода (проверка ГП)>
   IF EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.ObjectId = inReceiptId AND ObjectLink.DescId = zc_ObjectLink_Receipt_GoodsKind() AND ObjectLink.ChildObjectId = zc_GoodsKind_WorkProgress())
   THEN
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxExitCheck(), inReceiptId, COALESCE (tmp.TaxExit, ObjectFloat_TaxExit.ValueData))
       FROM Object AS Object_Receipt
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                  ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id
                                 AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
            LEFT JOIN (SELECT COALESCE (ObjectFloat_TaxExit_find.ValueData, 0)
                            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                              AS TaxExit
                       FROM ObjectLink AS ObjectLink_Receipt_Parent
                            LEFT JOIN Object AS Object_Receipt_find ON Object_Receipt_find.Id = ObjectLink_Receipt_Parent.ObjectId
                            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit_parent
                                                  ON ObjectFloat_TaxExit_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                                 AND ObjectFloat_TaxExit_parent.DescId = zc_ObjectFloat_Receipt_TaxExit()
                            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit_find
                                                  ON ObjectFloat_TaxExit_find.ObjectId = Object_Receipt_find.Id
                                                 AND ObjectFloat_TaxExit_find.DescId = zc_ObjectFloat_Receipt_Value()
                            LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                 ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt_find.Id
                                                AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       WHERE ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                         AND ObjectLink_Receipt_Parent.ChildObjectId = inReceiptId
                         AND COALESCE (ObjectFloat_TaxExit_parent.ValueData, 0)
                          <> (COALESCE (ObjectFloat_TaxExit_find.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                         AND COALESCE (Object_Receipt_find.isErased, FALSE) = FALSE
                       LIMIT 1
                      ) AS tmp ON tmp.TaxExit <> COALESCE (ObjectFloat_TaxExit.ValueData, 0)
       WHERE Object_Receipt.Id = inReceiptId;
   END IF;

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
-- SELECT lpUpdate_Object_Receipt_Total (Object.Id, zfCalc_UserAdmin() :: Integer) FROM Object WHERE DescId = zc_Object_Receipt()
