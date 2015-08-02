-- Function: gpSelect_Object_ReceiptChild()

DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptChildDetail (Integer);
DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptChildDetail ();

CREATE OR REPLACE FUNCTION lpSelect_Object_ReceiptChildDetail()
RETURNS TABLE (ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
             , ReceiptChildId Integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, isStart Boolean, isCost Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());


     CREATE TEMP TABLE tmpReceipt_basis (ReceiptId Integer, GoodsId Integer) ON COMMIT DROP;
     INSERT INTO tmpReceipt_basis (GoodsId, ReceiptId)
        SELECT MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
             , ObjectLink_Receipt_Goods.ChildObjectId  AS GoodsId
        FROM ObjectLink AS ObjectLink_Receipt_Goods
             INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                AND Object_Receipt.isErased = FALSE
             INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                      ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                     AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                     AND ObjectBoolean_Main.ValueData = TRUE
             LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                  ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                 AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
        WHERE ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
           AND ObjectLink_Receipt_GoodsKind.ChildObjectId IS NULL
        GROUP BY ObjectLink_Receipt_Goods.ChildObjectId
       ;


      RETURN QUERY
      WITH RECURSIVE temp1 (ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in, ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, isStart, isCost)
        AS (SELECT CASE WHEN ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId
                             THEN ObjectLink_Receipt_Goods_parent.ObjectId
                        ELSE tmpReceipt_basis.ReceiptId
                   END AS ReceiptId_from

                 , ObjectLink_ReceiptChild_Receipt.ChildObjectId                         AS ReceiptId
                 , 0                                                                     AS GoodsId_in
                 , 0                                                                     AS GoodsKindId_in
                 , ObjectFloatReceipt_Value.ValueData                                    AS Amount_in

                 , Object_ReceiptChild.Id                                                AS ReceiptChildId
                 , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)             AS GoodsId_out
                 , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)         AS GoodsKindId_out
                 , ObjectFloat_Value.ValueData                                           AS Amount_out
                 , TRUE AS isStart
                 , FALSE AS isCost
            FROM Object AS Object_ReceiptChild
                 LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                       ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id 
                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                      ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                      ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()

                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                      ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                                                    AND Object_Receipt.isErased = FALSE
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                      ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                                     AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                 LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                       ON ObjectFloatReceipt_Value.ObjectId = Object_Receipt.Id
                                      AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                      ON ObjectLink_Receipt_Parent.ObjectId = Object_Receipt.Id
                                     AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                 LEFT JOIN Object AS Object_Receipt_Parent ON Object_Receipt_Parent.Id = ObjectLink_Receipt_Parent.ChildObjectId
                                                          AND Object_Receipt_Parent.isErased = FALSE
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                      ON ObjectLink_Receipt_Goods_parent.ObjectId = Object_Receipt_Parent.Id
                                     AND ObjectLink_Receipt_Goods_parent.DescId = zc_ObjectLink_Receipt_Goods()

                 LEFT JOIN tmpReceipt_basis ON tmpReceipt_basis.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId

            WHERE Object_ReceiptChild.isErased = FALSE
              AND ObjectFloat_Value.ValueData <> 0
              AND ObjectFloatReceipt_Value.ValueData <> 0

           UNION 
            SELECT 0                                                                     AS ReceiptId_from
                 , Object_Receipt.Id                                                     AS ReceiptId
                 , 0                                                                     AS GoodsId_in
                 , 0                                                                     AS GoodsKindId_in
                 , ObjectFloatReceipt_Value.ValueData                                    AS Amount_in
                 , Object_Receipt.Id                                                     AS ReceiptChildId
                 , ObjectLink_Receipt_ReceiptCost.ChildObjectId                          AS GoodsId_out
                 , 0                                                                     AS GoodsKindId_out
                 , ObjectFloat_ValueCost.ValueData                                       AS Amount_out
                 , TRUE                                                                  AS isStart
                 , TRUE                                                                  AS isCost
            FROM Object AS Object_Receipt 
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_ReceiptCost
                                      ON ObjectLink_Receipt_ReceiptCost.ObjectId = Object_Receipt.Id
                                     AND ObjectLink_Receipt_ReceiptCost.DescId = zc_ObjectLink_Receipt_ReceiptCost()
                 LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                       ON ObjectFloatReceipt_Value.ObjectId = Object_Receipt.Id
                                      AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()
                 LEFT JOIN ObjectFloat AS ObjectFloat_ValueCost
                                       ON ObjectFloat_ValueCost.ObjectId = Object_Receipt.Id
                                      AND ObjectFloat_ValueCost.DescId = zc_ObjectFloat_Receipt_ValueCost()
            WHERE Object_Receipt.isErased = FALSE
              AND ObjectFloatReceipt_Value.ValueData <> 0
              AND ObjectFloat_ValueCost.ValueData <> 0

           UNION 
            SELECT CASE WHEN ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId
                             THEN ObjectLink_Receipt_Goods_parent.ObjectId
                        ELSE tmpReceipt_basis.ReceiptId
                   END AS ReceiptId_from

                 , DD.ReceiptId
                 , DD.GoodsId_out        AS GoodsId_in
                 , DD.GoodsKindId_out    AS GoodsKindId_in
                 , DD.Amount_in

                 , Object_ReceiptChild.Id AS ReceiptChildId
                 , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)     AS GoodsId_out
                 , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_out
                 , (DD.Amount_out * ObjectFloat_Value.ValueData / ObjectFloatReceipt_Value.ValueData) :: TFloat AS Amount_out
                 , FALSE                AS isStart
                 , FALSE                AS isCost

            FROM temp1 AS DD
                 LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                       ON ObjectFloatReceipt_Value.ObjectId = DD.ReceiptId_from
                                      AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                      ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = DD.ReceiptId_from
                                     AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                 INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                         AND Object_ReceiptChild.isErased = FALSE
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                      ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                      ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                       ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()

                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                      ON ObjectLink_Receipt_Parent.ObjectId = DD.ReceiptId_from
                                     AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                 LEFT JOIN Object AS Object_Receipt_Parent ON Object_Receipt_Parent.Id = ObjectLink_Receipt_Parent.ChildObjectId
                                                          AND Object_Receipt_Parent.isErased = FALSE
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                      ON ObjectLink_Receipt_Goods_parent.ObjectId = Object_Receipt_Parent.Id
                                     AND ObjectLink_Receipt_Goods_parent.DescId = zc_ObjectLink_Receipt_Goods()
                 LEFT JOIN tmpReceipt_basis ON tmpReceipt_basis.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId

            WHERE DD.ReceiptId_from > 0
              AND ObjectFloat_Value.ValueData <> 0
              AND ObjectFloatReceipt_Value.ValueData <> 0
           )
      , ReceiptDetail AS (SELECT * FROM temp1)

     -- Результат
     SELECT 0 AS ReceiptId_from
          , ReceiptDetail.ReceiptId
          , ReceiptDetail.GoodsId_in, ReceiptDetail.GoodsKindId_in
          , ReceiptDetail.Amount_in

          , ReceiptDetail.ReceiptChildId
          , ReceiptDetail.GoodsId_out
          , ReceiptDetail.GoodsKindId_out
          , ReceiptDetail.Amount_out
          , ReceiptDetail.isStart
          , ReceiptDetail.isCost
     FROM ReceiptDetail
     WHERE (ReceiptDetail.goodsId_out, ReceiptDetail.goodsKindId_out, ReceiptDetail.ReceiptId) NOT IN (SELECT ReceiptDetail.GoodsId_in, ReceiptDetail.GoodsKindId_in, ReceiptDetail.ReceiptId FROM ReceiptDetail)
    UNION
     SELECT ReceiptDetail.ReceiptId_from
          , ReceiptDetail.ReceiptId
          , ReceiptDetail.GoodsId_in, ReceiptDetail.GoodsKindId_in
          , ReceiptDetail.Amount_in

          , ReceiptDetail.ReceiptChildId
          , ReceiptDetail.GoodsId_out
          , ReceiptDetail.GoodsKindId_out
          , ReceiptDetail.Amount_out
          , ReceiptDetail.isStart
          , ReceiptDetail.isCost
     FROM ReceiptDetail
     WHERE ReceiptDetail.ReceiptId_from > 0 AND ReceiptDetail.isStart = TRUE
    ;
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSelect_Object_ReceiptChildDetail () OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.15                        *
*/

-- тест
--  SELECT * FROM lpSelect_Object_ReceiptChildDetail ()
