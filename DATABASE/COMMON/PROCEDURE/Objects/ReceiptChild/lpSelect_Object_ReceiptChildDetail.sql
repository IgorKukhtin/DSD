-- Function: lpSelect_Object_ReceiptChildDetail()

DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptChildDetail (Integer);
DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptChildDetail ();
DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptChildDetail (Boolean);

CREATE OR REPLACE FUNCTION lpSelect_Object_ReceiptChildDetail (
    IN inIsParent Boolean DEFAULT FALSE
)
RETURNS TABLE (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
             , ReceiptChildId Integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, isStart Boolean, isCost Boolean
              )
AS
$BODY$
BEGIN
     -- только главные рецепты c пустым GoodsKindId - ЭМУЛЬСИИ...
     CREATE TEMP TABLE tmpReceipt_basis (ReceiptId Integer, GoodsId Integer) ON COMMIT DROP;
     INSERT INTO tmpReceipt_basis (ReceiptId, GoodsId)
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

     -- только "альтернативные" рецепты
     CREATE TEMP TABLE tmpReceipt_parent (ReceiptId Integer, ReceiptId_parent Integer, GoodsId_parent Integer, GoodsKindId_parent Integer) ON COMMIT DROP;
     IF inIsParent = TRUE
     THEN
         -- для ПФ-ГП
         INSERT INTO tmpReceipt_parent (ReceiptId, ReceiptId_parent, GoodsId_parent, GoodsKindId_parent)
            SELECT Object_Receipt.Id                               AS ReceiptId          -- это Рецепт который делается из ПФ-ГП
                 , ObjectLink_Receipt_Goods_find.ObjectId          AS ReceiptId_parent   -- это ПФ-ГП
                 , ObjectLink_Receipt_Goods_find.ChildObjectId     AS GoodsId_parent     -- это ПФ-ГП
                 , ObjectLink_Receipt_GoodsKind_find.ChildObjectId AS GoodsKindId_parent -- это ПФ-ГП
            FROM ObjectLink AS ObjectLink_Receipt_Goods_find
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_find
                                       ON ObjectLink_Receipt_GoodsKind_find.ObjectId = ObjectLink_Receipt_Goods_find.ObjectId
                                      AND ObjectLink_Receipt_GoodsKind_find.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                      AND ObjectLink_Receipt_GoodsKind_find.ChildObjectId = zc_GoodsKind_WorkProgress() -- !!!ограниечение!!!
                 INNER JOIN Object AS Object_Receipt_find ON Object_Receipt_find.Id = ObjectLink_Receipt_Goods_find.ObjectId
                                                         AND Object_Receipt_find.isErased = FALSE
                 INNER JOIN ObjectFloat AS ObjectFloat_Value_find
                                        ON ObjectFloat_Value_find.ObjectId = Object_Receipt_find.Id
                                       AND ObjectFloat_Value_find.DescId = zc_ObjectFloat_Receipt_Value()
                                       AND ObjectFloat_Value_find.ValueData > 0
                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_find
                                          ON ObjectBoolean_Main_find.ObjectId = Object_Receipt_find.Id
                                         AND ObjectBoolean_Main_find.DescId = zc_ObjectBoolean_Receipt_Main()
                                         AND ObjectBoolean_Main_find.ValueData = TRUE
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete_find
                                      ON ObjectLink_Receipt_GoodsKindComplete_find.ObjectId = Object_Receipt_find.Id
                                     AND ObjectLink_Receipt_GoodsKindComplete_find.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                       ON ObjectLink_Receipt_Goods_parent.ChildObjectId = ObjectLink_Receipt_Goods_find.ChildObjectId
                                      AND ObjectLink_Receipt_Goods_parent.DescId = zc_ObjectLink_Receipt_Goods()
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_parent
                                       ON ObjectLink_Receipt_GoodsKind_parent.ObjectId = ObjectLink_Receipt_Goods_parent.ObjectId
                                      AND ObjectLink_Receipt_GoodsKind_parent.ChildObjectId = ObjectLink_Receipt_GoodsKind_find.ChildObjectId
                                      AND ObjectLink_Receipt_GoodsKind_parent.DescId = zc_ObjectLink_Receipt_GoodsKind()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete_parent
                                      ON ObjectLink_Receipt_GoodsKindComplete_parent.ObjectId = ObjectLink_Receipt_Goods_parent.ObjectId
                                     AND ObjectLink_Receipt_GoodsKindComplete_parent.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                       ON ObjectLink_Receipt_Parent.ChildObjectId = ObjectLink_Receipt_Goods_parent.ObjectId
                                      AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                                      AND ObjectLink_Receipt_Parent.ObjectId <> ObjectLink_Receipt_Goods_find.ObjectId

                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Parent.ObjectId
                                                    AND Object_Receipt.isErased = FALSE

            WHERE ObjectLink_Receipt_Goods_find.DescId = zc_ObjectLink_Receipt_Goods()
              AND ObjectBoolean_Main_find.ObjectId IS NULL
              AND COALESCE (ObjectLink_Receipt_GoodsKindComplete_find.ChildObjectId, zc_GoodsKind_Basis()) = COALESCE (ObjectLink_Receipt_GoodsKindComplete_parent.ChildObjectId, zc_GoodsKind_Basis())
           ;
     END IF; -- if inIsParent = TRUE


     -- только рецепты - ParentMulti
     CREATE TEMP TABLE tmpReceipt_multi (ReceiptId_parent Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, ReceiptChildId Integer, Koeff TFloat) ON COMMIT DROP;
     -- сформировали
     INSERT INTO tmpReceipt_multi (ReceiptId_parent, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in, GoodsId_out, GoodsKindId_out, Amount_out, ReceiptChildId, Koeff)
                   WITH tmp AS (
                         SELECT Object_Receipt_find.Id                          AS ReceiptId_parent
                              , Object_Receipt.Id                               AS ReceiptId
                              , ObjectLink_Receipt_Goods.ChildObjectId          AS GoodsId_in
                              , ObjectLink_Receipt_GoodsKind.ChildObjectId      AS GoodsKindId_in
                              , ObjectFloat_Value_master.ValueData              AS Amount_in
                              , ObjectLink_ReceiptChild_Goods.ChildObjectId     AS GoodsId_out
                              , ObjectLink_ReceiptChild_GoodsKind.ChildObjectId AS GoodsKindId_out
                              , ObjectFloat_Value.ValueData                     AS Amount_out
                              , ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS AmountWeight_out
                              , Object_ReceiptChild.Id                          AS ReceiptChildId
                              , CASE WHEN (ObjectFloat_Value_master.ValueData * CASE WHEN ObjectLink_Measure_master.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight_master.ValueData ELSE 1 END) <> 0
                                          THEN (ObjectFloat_Value.ValueData        * CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                             / (ObjectFloat_Value_master.ValueData * CASE WHEN ObjectLink_Measure_master.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight_master.ValueData ELSE 1 END)
                                     ELSE 0
                                END AS Koeff
                         FROM ObjectBoolean AS ObjectBoolean_ParentMulti
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectBoolean_ParentMulti.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              -- параметры "главного" рецепта
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                                                   AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                   ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = Object_Receipt.Id
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              -- параметры "составляющих" рецепта
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                    ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = Object_Receipt.Id
                                                   AND ObjectLink_ReceiptChild_Receipt.DescId        = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId   = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId   = zc_ObjectLink_ReceiptChild_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              -- т.е. только ГП
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- Доходы
                                                                OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                  )

                              -- нашли "главный" рецепт
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods_find
                                                    ON ObjectLink_Receipt_Goods_find.ChildObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                   AND ObjectLink_Receipt_Goods_find.DescId        = zc_ObjectLink_Receipt_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_find
                                                    ON ObjectLink_Receipt_GoodsKind_find.ChildObjectId = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                   AND ObjectLink_Receipt_GoodsKind_find.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                                   AND ObjectLink_Receipt_GoodsKind_find.ObjectId      = ObjectLink_Receipt_Goods_find.ObjectId
                              INNER JOIN Object AS Object_Receipt_find ON Object_Receipt_find.Id       = ObjectLink_Receipt_Goods_find.ObjectId
                                                                      AND Object_Receipt_find.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main_find
                                                       ON ObjectBoolean_Main_find.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main_find.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main_find.ValueData = TRUE

                              -- инфа для расчета коэффициента
                              LEFT JOIN ObjectLink AS ObjectLink_Measure_master
                                                   ON ObjectLink_Measure_master.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                                  AND ObjectLink_Measure_master.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight_master
                                                    ON ObjectFloat_Weight_master.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                                   AND ObjectFloat_Weight_master.DescId = zc_ObjectFloat_Goods_Weight()

                              LEFT JOIN ObjectLink AS ObjectLink_Measure
                                                   ON ObjectLink_Measure.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                         WHERE ObjectBoolean_ParentMulti.DescId = zc_ObjectBoolean_Receipt_ParentMulti()
                           AND ObjectBoolean_ParentMulti.ValueData = TRUE
                        )
         , tmp_koeff AS (SELECT tmp.ReceiptId
                              , tmp.GoodsId_in
                              , SUM (tmp.AmountWeight_out) AS AmountWeight_out
                         FROM tmp
                         GROUP BY tmp.ReceiptId
                                , tmp.GoodsId_in
                        )
                   -- Результат
                   SELECT tmp.ReceiptId_parent
                        , tmp.ReceiptId
                        , tmp.GoodsId_in
                        , tmp.GoodsKindId_in
                          -- обязательно учли Koeff
                        , tmp.Amount_in * COALESCE (tmp.Amount_out / tmp_koeff.AmountWeight_out, tmp.Koeff) AS Amount_in
                        , tmp.GoodsId_out
                        , tmp.GoodsKindId_out
                          -- НЕ надо учитывать Koeff
                        , tmp.Amount_out AS Amount_out
                        , tmp.ReceiptChildId
                          -- сохранили Koeff, вдруг понадобится
                        , COALESCE (tmp.Amount_out / tmp_koeff.AmountWeight_out, tmp.Koeff) AS Koeff
                   FROM tmp
                        LEFT JOIN tmp_koeff ON tmp_koeff.ReceiptId        = tmp.ReceiptId
                                           AND tmp_koeff.GoodsId_in       = tmp.GoodsId_in
                                           AND tmp_koeff.AmountWeight_out <> 0
                                           AND 1 = 0 -- !!!Временно отключил!!!
                   ;
          


      RETURN QUERY
      WITH RECURSIVE temp1 (ReceiptId_parent, ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in, ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, isStart, isCost)
        AS (-- первый уровень - НЕТ ParentMulti
            SELECT COALESCE (tmpReceipt_multi_group.ReceiptId, COALESCE (ObjectLink_Receipt_Parent.ChildObjectId, 0)) AS ReceiptId_parent
                 , CASE WHEN ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId
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
                 -- рецепты - ParentMulti
                 LEFT JOIN tmpReceipt_multi ON tmpReceipt_multi.GoodsId_out     = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                           AND tmpReceipt_multi.GoodsKindId_out = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                           AND tmpReceipt_multi.ReceiptId       = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                 LEFT JOIN (SELECT DISTINCT tmpReceipt_multi.ReceiptId FROM tmpReceipt_multi) AS tmpReceipt_multi_group ON tmpReceipt_multi_group.ReceiptId = ObjectLink_ReceiptChild_Receipt.ChildObjectId

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
                 -- ЭМУЛЬСИИ
                 LEFT JOIN tmpReceipt_basis ON tmpReceipt_basis.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId

            WHERE Object_ReceiptChild.isErased = FALSE
              AND ObjectFloat_Value.ValueData <> 0
              AND ObjectFloatReceipt_Value.ValueData <> 0
              AND tmpReceipt_multi.GoodsId_out IS NULL

           UNION
            -- первый уровень - ЕСТЬ ParentMulti
            SELECT tmpReceipt_multi.ReceiptId        AS ReceiptId_parent
                 , tmpReceipt_multi.ReceiptId_parent AS ReceiptId_from

                 , tmpReceipt_multi.ReceiptId
                 , 0 AS GoodsId_in
                 , 0 AS GoodsKindId_in
                 , tmpReceipt_multi.Amount_in

                 , tmpReceipt_multi.ReceiptChildId
                 , tmpReceipt_multi.GoodsId_out
                 , tmpReceipt_multi.GoodsKindId_out
                 , tmpReceipt_multi.Amount_out
                 , TRUE AS isStart
                 , FALSE AS isCost
            FROM tmpReceipt_multi

           UNION
            -- первый уровень - "альтернативные"
            SELECT tmpReceipt_parent.ReceiptId_parent
                 , CASE WHEN ObjectLink_ReceiptChild_Goods.ChildObjectId = tmpReceipt_parent.GoodsId_parent
                             THEN tmpReceipt_parent.ReceiptId_parent
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
            FROM tmpReceipt_parent
                 INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                       ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = tmpReceipt_parent.ReceiptId
                                      AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()

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

                 LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                       ON ObjectFloatReceipt_Value.ObjectId = tmpReceipt_parent.ReceiptId
                                      AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

                 LEFT JOIN tmpReceipt_basis ON tmpReceipt_basis.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId

            WHERE ObjectFloat_Value.ValueData <> 0
              AND ObjectFloatReceipt_Value.ValueData <> 0

           UNION
            -- затраты
            SELECT COALESCE (tmpReceipt_multi_group.ReceiptId, COALESCE (ObjectLink_Receipt_Parent.ChildObjectId, 0)) AS ReceiptId_parent
                 , 0                                                                     AS ReceiptId_from
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
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                      ON ObjectLink_Receipt_Parent.ObjectId = Object_Receipt.Id
                                     AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                 LEFT JOIN (SELECT DISTINCT tmpReceipt_multi.ReceiptId FROM tmpReceipt_multi) AS tmpReceipt_multi_group ON tmpReceipt_multi_group.ReceiptId = Object_Receipt.Id
            WHERE Object_Receipt.isErased = FALSE
              AND ObjectFloatReceipt_Value.ValueData <> 0
              AND ObjectFloat_ValueCost.ValueData <> 0

           UNION
            -- затраты - "альтернативные"
            SELECT tmpReceipt_parent.ReceiptId_parent                                    AS ReceiptId_parent
                 , 0                                                                     AS ReceiptId_from
                 , tmpReceipt_parent.ReceiptId                                           AS ReceiptId
                 , 0                                                                     AS GoodsId_in
                 , 0                                                                     AS GoodsKindId_in
                 , ObjectFloatReceipt_Value.ValueData                                    AS Amount_in
                 , tmpReceipt_parent.ReceiptId                                           AS ReceiptChildId
                 , ObjectLink_Receipt_ReceiptCost.ChildObjectId                          AS GoodsId_out
                 , 0                                                                     AS GoodsKindId_out
                 , ObjectFloat_ValueCost.ValueData                                       AS Amount_out
                 , TRUE                                                                  AS isStart
                 , TRUE                                                                  AS isCost
            FROM tmpReceipt_parent
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_ReceiptCost
                                      ON ObjectLink_Receipt_ReceiptCost.ObjectId = tmpReceipt_parent.ReceiptId
                                     AND ObjectLink_Receipt_ReceiptCost.DescId = zc_ObjectLink_Receipt_ReceiptCost()
                 LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                       ON ObjectFloatReceipt_Value.ObjectId = tmpReceipt_parent.ReceiptId
                                      AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()
                 LEFT JOIN ObjectFloat AS ObjectFloat_ValueCost
                                       ON ObjectFloat_ValueCost.ObjectId = tmpReceipt_parent.ReceiptId
                                      AND ObjectFloat_ValueCost.DescId = zc_ObjectFloat_Receipt_ValueCost()
            WHERE ObjectFloatReceipt_Value.ValueData <> 0
              AND ObjectFloat_ValueCost.ValueData <> 0

           UNION 
            -- рекурсия - нашли и разложили по составляющим
            SELECT DD.ReceiptId_parent
                 , CASE WHEN ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId
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
     SELECT ReceiptDetail.ReceiptId_parent
          , 0 AS ReceiptId_from
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
     SELECT ReceiptDetail.ReceiptId_parent
          , ReceiptDetail.ReceiptId_from
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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.11.15                                        * add ReceiptId_parent
 16.03.15                        *
*/

-- тест
--  SELECT * FROM lpSelect_Object_ReceiptChildDetail (TRUE)
