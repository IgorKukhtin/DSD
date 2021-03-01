-- Function: lpUpdate_Object_Receipt_Parent()

DROP FUNCTION IF EXISTS lpUpdate_Object_Receipt_Parent (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Receipt_Parent(
    IN inReceiptId                  Integer   , -- ключ объекта
    IN inGoodsId                    Integer   , -- ключ объекта
    IN inUserId                     Integer
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- Список
    CREATE TEMP TABLE _tmpListMaster (ReceiptId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindCompleteId Integer) ON COMMIT DROP;
    -- Список "Main"
    INSERT INTO _tmpListMaster (ReceiptId, GoodsId, GoodsKindId, GoodsKindCompleteId)
       SELECT ObjectLink_Receipt_Goods.ObjectId                                                   AS ReceiptId
            , COALESCE (ObjectLink_Receipt_Goods.ChildObjectId, 0)                                AS GoodsId
            , COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)                            AS GoodsKindId
            , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindCompleteId
       FROM ObjectLink AS ObjectLink_Receipt_Goods
            INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                     ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                    AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                    AND ObjectBoolean_Main.ValueData = TRUE
            INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                  ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                 AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                 AND ObjectLink_Receipt_GoodsKind.ChildObjectId > 0 -- zc_GoodsKind_Basis()
            LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                 ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
                                AND ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress() -- zc_GoodsKind_Basis()
       WHERE /*(ObjectLink_Receipt_Goods.ObjectId = inReceiptId
           OR ObjectLink_Receipt_Goods.ObjectId = inGoodsId
           OR COALESCE (inGoodsId, 0) = 0 OR COALESCE (inReceiptId, 0) = 0
             )
         AND*/ ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods();

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_Parent(), ObjectLink_Receipt_Goods.ObjectId, CASE WHEN tmp.isParentMulti = TRUE THEN NULL ELSE tmp.ReceiptId_parent END)
         , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Receipt_ParentMulti(), ObjectLink_Receipt_Goods.ObjectId, tmp.isParentMulti)
   FROM ObjectLink AS ObjectLink_Receipt_Goods
        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                             ON ObjectLink_Receipt_Parent.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                            AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_ParentMulti
                                ON ObjectBoolean_ParentMulti.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                               AND ObjectBoolean_ParentMulti.DescId = zc_ObjectBoolean_Receipt_ParentMulti()
        LEFT JOIN (-- Все у кого Child-GoodsKind = ПФ (ГП)
                   SELECT tmp.ReceiptId
                        , MAX (tmp.ReceiptId_parent) AS ReceiptId_parent
                        , CASE WHEN MAX (tmp.ReceiptId_parent) <> MIN (tmp.ReceiptId_parent) THEN TRUE ELSE FALSE END AS isParentMulti
                   FROM
                   -- Все у кого Child-GoodsKind = ПФ (ГП)
                  (SELECT ObjectLink_Receipt_Goods.ObjectId                                               AS ReceiptId
                        , COALESCE (_tmpListMaster.ReceiptId, COALESCE (_tmpListMaster_two.ReceiptId, 0)) AS ReceiptId_parent
                   FROM ObjectLink AS ObjectLink_Receipt_Goods
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                              ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_Goods.ObjectId
                                             AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()

                        INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                AND Object_ReceiptChild.isErased = FALSE
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                             ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                            AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                             AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress()

                        LEFT JOIN _tmpListMaster ON _tmpListMaster.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                AND _tmpListMaster.GoodsKindId = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                AND _tmpListMaster.GoodsKindCompleteId = ObjectLink_Receipt_GoodsKind.ChildObjectId

                        LEFT JOIN _tmpListMaster AS _tmpListMaster_two
                                                 ON _tmpListMaster_two.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                AND _tmpListMaster_two.GoodsKindId = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                AND _tmpListMaster_two.GoodsKindCompleteId = zc_GoodsKind_Basis()
                                                AND _tmpListMaster.GoodsId IS NULL

                   WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
                       OR ObjectLink_Receipt_Goods.ObjectId = inGoodsId
                       OR COALESCE (inGoodsId, 0) = 0 OR COALESCE (inReceiptId, 0) = 0
                         )
                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                  UNION
                   -- Все у кого Child-GoodsKind <> ПФ (ГП) AND Child-GoodsKind <> 0 AND в найденном рецепте GoodsKindCompleteId = zc_GoodsKind_Basis()
                   SELECT ObjectLink_Receipt_Goods.ObjectId      AS ReceiptId
                        , COALESCE (_tmpListMaster.ReceiptId, 0) AS ReceiptId_parent
                   FROM ObjectLink AS ObjectLink_Receipt_Goods
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                              ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_Goods.ObjectId
                                             AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()

                        INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                AND Object_ReceiptChild.isErased = FALSE
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                             ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                            AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                             AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId <> zc_GoodsKind_WorkProgress()
                                             AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId > 0

                        LEFT JOIN _tmpListMaster ON _tmpListMaster.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                AND _tmpListMaster.GoodsKindId = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                AND _tmpListMaster.GoodsKindCompleteId = zc_GoodsKind_Basis()

                   WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
                       OR ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                       OR (COALESCE (inGoodsId, 0) = 0 AND COALESCE (inReceiptId, 0) = 0)
                         )
                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                  ) AS tmp
                   GROUP BY tmp.ReceiptId
                  ) AS tmp ON tmp.ReceiptId = ObjectLink_Receipt_Goods.ObjectId
   WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
       OR ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
       OR (COALESCE (inGoodsId, 0) = 0 AND COALESCE (inReceiptId, 0) = 0)
         )
      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
      AND (COALESCE (ObjectLink_Receipt_Parent.ObjectId, 0) <> COALESCE (tmp.ReceiptId_parent, 0)
        OR COALESCE (ObjectBoolean_ParentMulti.ValueData, FALSE) <> COALESCE (tmp.isParentMulti, FALSE)
          );



   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxLoss(), tmp.ReceiptId
                                     , CASE WHEN tmp.GoodsKindId = zc_GoodsKind_WorkProgress()
                                                 THEN 0
                                            WHEN tmp.Amount_child = 0 AND tmp.Amount_master <> 0
                                                 THEN -100
                                            WHEN tmp.Amount_child = 0 AND tmp.Amount_master = 0
                                                 THEN 0
                                            ELSE 100 - 100 * tmp.Amount_master / tmp.Amount_child
                                       END
                                      )
   FROM
  (SELECT ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
        , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId
        , COALESCE (ObjectFloat_Value.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount_master
        , COALESCE (tmp.Amount_child, 0) AS Amount_child
   FROM ObjectLink AS ObjectLink_Receipt_Goods
        INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                              ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                             AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                             AND ObjectLink_Receipt_GoodsKind.ChildObjectId > 0
        LEFT JOIN ObjectFloat AS ObjectFloat_Value
                              ON ObjectFloat_Value.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

         LEFT JOIN (SELECT ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                          , SUM (COALESCE (ObjectFloat_Value.ValueData, 0)
                               * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                ) AS Amount_child
                    FROM ObjectLink AS ObjectLink_Receipt_Goods
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                              ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_Goods.ObjectId
                                             AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                        INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                AND Object_ReceiptChild.isErased = FALSE
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                             AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId > 0
                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                             ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                            AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
                        OR ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                        OR (COALESCE (inGoodsId, 0) = 0 AND COALESCE (inReceiptId, 0) = 0)
                          )
                       AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                    GROUP BY ObjectLink_Receipt_Goods.ObjectId
                  ) AS tmp ON tmp.ReceiptId = ObjectLink_Receipt_Goods.ObjectId
   WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
       OR ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
       OR (COALESCE (inGoodsId, 0) = 0 AND COALESCE (inReceiptId, 0) = 0)
         )
      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
   ) AS tmp
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                              ON ObjectFloat_TaxLoss.ObjectId = tmp.ReceiptId
                            AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
   WHERE  COALESCE (ObjectFloat_TaxLoss.ValueData, 0) <> CASE WHEN tmp.GoodsKindId = zc_GoodsKind_WorkProgress()
                                                                   THEN 0
                                                              WHEN tmp.Amount_child = 0 AND tmp.Amount_master <> 0
                                                                   THEN -100
                                                              WHEN tmp.Amount_child = 0 AND tmp.Amount_master = 0
                                                                   THEN 0
                                                              ELSE 100 - 100 * tmp.Amount_master / tmp.Amount_child
                                                         END
   ;



   -- 1. пересчитали свойство - !!! у товара !!!
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsBasis(), tmp.Id, tmp.GoodsId_Basis)
         , lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsMain(),  tmp.Id, tmp.GoodsId_Main)

   FROM (WITH tmpFind_all AS (SELECT COALESCE (ObjectLink_Receipt_Goods.ChildObjectId,     0) AS GoodsId
                                   , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                     END AS ReceiptId_Basis
                                   , CASE -- !!!сразу - Парент!!!
                                          WHEN 1=1
                                               THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                          -- следующий за WorkProgress
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_0.ObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_1.ObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_2.ObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_3.ObjectId
                                     END AS ReceiptId_Main
                              FROM ObjectLink AS ObjectLink_Receipt_Goods
                                   INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                      AND Object_Receipt.isErased = FALSE
                                   INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                            ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                           AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                           AND ObjectBoolean_Main.ValueData = TRUE
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                        ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                       AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                        ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                       AND ObjectLink_Receipt_Parent_1.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                        ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                       AND ObjectLink_Receipt_Parent_2.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                        ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                       AND ObjectLink_Receipt_Parent_3.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                              WHERE  ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                             )
                , tmpFind AS (SELECT tmpFind_all.GoodsId
                                   , tmpFind_all.ReceiptId_Basis
                                   , tmpFind_all.ReceiptId_Main
                                   , ROW_NUMBER() OVER (PARTITION BY tmpFind_all.GoodsId ORDER BY COALESCE (tmpFind_all.ReceiptId_Basis, 0) DESC, COALESCE (tmpFind_all.ReceiptId_Main, 0) DESC) AS Ord
                              FROM tmpFind_all
                             )
         -- Результат
         SELECT Object.Id
              , ObjectLink_Receipt_Goods_Basis.ChildObjectId AS GoodsId_Basis
              , ObjectLink_Receipt_Goods_Main.ChildObjectId  AS GoodsId_Main
         FROM Object
              LEFT JOIN tmpFind ON tmpFind.GoodsId = Object.Id
                               AND tmpFind.Ord     = 1
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Basis
                                   ON ObjectLink_Receipt_Goods_Basis.ObjectId = tmpFind.ReceiptId_Basis
                                  AND ObjectLink_Receipt_Goods_Basis.DescId   = zc_ObjectLink_Receipt_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Main
                                   ON ObjectLink_Receipt_Goods_Main.ObjectId = tmpFind.ReceiptId_Main
                                  AND ObjectLink_Receipt_Goods_Main.DescId   = zc_ObjectLink_Receipt_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsBasis
                                   ON ObjectLink_GoodsBasis.ObjectId = Object.Id
                                  AND ObjectLink_GoodsBasis.DescId   = zc_ObjectLink_Goods_GoodsBasis()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsMain
                                   ON ObjectLink_GoodsMain.ObjectId = Object.Id
                                  AND ObjectLink_GoodsMain.DescId   = zc_ObjectLink_Goods_GoodsMain()
         WHERE Object.DesCId = zc_Object_Goods()
           AND (ObjectLink_GoodsBasis.ObjectId > 0
             OR ObjectLink_GoodsMain.ObjectId  > 0
             OR tmpFind.GoodsId                > 0
               )
        ) AS tmp;


   -- 2. пересчитали свойство - !!! у GoodsByGoodsKind_View !!!
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsBasis(), tmp.Id, tmp.GoodsId_Basis)
         , lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsMain(),  tmp.Id, tmp.GoodsId_Main)

   FROM (WITH tmpFind_all AS (SELECT COALESCE (ObjectLink_Receipt_Goods.ChildObjectId,     0) AS GoodsId
                                   , COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                   , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                     END AS ReceiptId_Basis
                                   , CASE -- !!!сразу - Парент!!!
                                          WHEN 1=1
                                               THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                          -- следующий за WorkProgress
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_0.ObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_1.ObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_2.ObjectId
                                          WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                               THEN ObjectLink_Receipt_Parent_3.ObjectId
                                     END AS ReceiptId_Main
                              FROM ObjectLink AS ObjectLink_Receipt_Goods
                                   INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                      AND Object_Receipt.isErased = FALSE
                                   INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                            ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                           AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                           AND ObjectBoolean_Main.ValueData = TRUE
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                        ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                       AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                        ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                       AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                        ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                       AND ObjectLink_Receipt_Parent_1.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                        ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                       AND ObjectLink_Receipt_Parent_2.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                        ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                       AND ObjectLink_Receipt_Parent_3.DescId = zc_ObjectLink_Receipt_Parent()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                        ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                       AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId = zc_ObjectLink_Receipt_GoodsKind()
    
                              WHERE  ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                             )
                , tmpFind AS (SELECT tmpFind_all.GoodsId
                                   , tmpFind_all.GoodsKindId
                                   , tmpFind_all.ReceiptId_Basis
                                   , tmpFind_all.ReceiptId_Main
                                   , ROW_NUMBER() OVER (PARTITION BY tmpFind_all.GoodsId, tmpFind_all.GoodsKindId ORDER BY COALESCE (tmpFind_all.ReceiptId_Basis, 0) DESC, COALESCE (tmpFind_all.ReceiptId_Main, 0) DESC) AS Ord
                              FROM tmpFind_all
                             )
         -- Результат
         SELECT Object.Id
              , ObjectLink_Receipt_Goods_Basis.ChildObjectId AS GoodsId_Basis
              , ObjectLink_Receipt_Goods_Main.ChildObjectId  AS GoodsId_Main
         FROM Object
              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                   ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object.Id
                                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = Object.Id
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
              LEFT JOIN tmpFind ON tmpFind.GoodsId     = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                               AND tmpFind.GoodsKindId = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
                               AND tmpFind.Ord     = 1
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Basis
                                   ON ObjectLink_Receipt_Goods_Basis.ObjectId = tmpFind.ReceiptId_Basis
                                  AND ObjectLink_Receipt_Goods_Basis.DescId   = zc_ObjectLink_Receipt_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Main
                                   ON ObjectLink_Receipt_Goods_Main.ObjectId = tmpFind.ReceiptId_Main
                                  AND ObjectLink_Receipt_Goods_Main.DescId   = zc_ObjectLink_Receipt_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsBasis
                                   ON ObjectLink_GoodsBasis.ObjectId = Object.Id
                                  AND ObjectLink_GoodsBasis.DescId   = zc_ObjectLink_Goods_GoodsBasis()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsMain
                                   ON ObjectLink_GoodsMain.ObjectId = Object.Id
                                  AND ObjectLink_GoodsMain.DescId   = zc_ObjectLink_Goods_GoodsMain()
         WHERE Object.DesCId = zc_Object_GoodsByGoodsKind()
           AND (ObjectLink_GoodsBasis.ObjectId > 0
             OR ObjectLink_GoodsMain.ObjectId  > 0
             OR tmpFind.GoodsId                > 0
               )
        ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_Object_Receipt_Parent (Integer, Integer, Integer) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.03.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Receipt_Parent (0, 0, 0);
