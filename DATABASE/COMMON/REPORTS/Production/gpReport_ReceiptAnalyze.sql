-- Function: gpReport_ReceiptAnalyze ()

DROP FUNCTION IF EXISTS gpReport_ReceiptAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ReceiptAnalyze (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReceiptAnalyze (
    IN inGoodsGroupId     Integer   ,
    IN inGoodsId          Integer   ,
    IN inPriceListId_1    Integer,
    IN inPriceListId_2    Integer,
    IN inPriceListId_3    Integer,
    IN inPriceListId_sale Integer,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor

AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    -- !!!пересчет Рецептур, временно захардкодил!!!
    --PERFORM lpUpdate_Object_Receipt_Total (Object.Id, zfCalc_UserAdmin() :: Integer) FROM Object WHERE DescId = zc_Object_Receipt();
    -- !!!пересчет Рецептур, временно захардкодил!!!
    --PERFORM lpUpdate_Object_Receipt_Parent (0, 0, 0);


     CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpChildReceiptTable')
     THEN
         DELETE FROM tmpChildReceiptTable;
     ELSE
         CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                               , ReceiptId_calc Integer, Amount_in_calc TFloat, Amount_in_calc_two TFloat, Amount_out_calc TFloat
                                               , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, Amount_out_start TFloat, isStart Integer, isCost Boolean
                                               , Price1 TFloat, Price2 TFloat, Price3 TFloat
                                               , Price1_calc TFloat, Price2_calc TFloat, Price3_calc TFloat
                                               , Koeff1_bon TFloat, Koeff2_bon TFloat, Koeff3_bon TFloat, Price1_bon TFloat, Price2_bon TFloat, Price3_bon TFloat
                                                ) ON COMMIT DROP;
     END IF;


   -- Ограничения по товару
   IF COALESCE( inGoodsId,0) <> 0
    THEN
        -- заполнение
        INSERT INTO _tmpGoods (GoodsId)
           SELECT inGoodsId;
    ELSE
     IF COALESCE( inGoodsGroupId,0) <> 0 and COALESCE( inGoodsId,0) = 0
     THEN
         WITH RECURSIVE tmpGroup (GoodsGroupId, GoodsGroupParentId)
           AS (SELECT Object.Id, NULL :: Integer
               FROM Object
               WHERE Object.Id = inGoodsGroupId
              UNION
               SELECT ObjectLink_GoodsGroup.ObjectId, tmpGroup.GoodsGroupId
               FROM tmpGroup
                   INNER JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ChildObjectId = tmpGroup.GoodsGroupId
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
              )

         INSERT INTO _tmpGoods (GoodsId)
            SELECT ObjectLink_Goods_GoodsGroup.ObjectId
            FROM tmpGroup
                 INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                       ON ObjectLink_Goods_GoodsGroup.ChildObjectId = tmpGroup.GoodsGroupId
                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup();
      ELSE
            INSERT INTO _tmpGoods (GoodsId)
                 SELECT Object_Goods.Id AS GoodsId
                 FROM Object AS Object_Goods
                 WHERE Object_Goods.DescId = zc_Object_Goods();

      END IF;
   END IF;

     -- ВСЕ рецептуры
     INSERT INTO tmpChildReceiptTable (ReceiptId_parent, ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in, ReceiptId_calc, Amount_in_calc, Amount_in_calc_two, Amount_out_calc
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, Amount_out_start, isStart, isCost
                                     , Price1, Price2, Price3, Price1_calc, Price2_calc, Price3_calc
                                     , Koeff1_bon, Koeff2_bon, Koeff3_bon, Price1_bon, Price2_bon, Price3_bon
                                      )
          --
          SELECT lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId, 0 AS GoodsId_in, 0 AS GoodsKindId_in, lpSelect.Amount_in

               , CASE WHEN ObjectLink_Receipt_GoodsKind_parent_two.ChildObjectId = zc_GoodsKind_WorkProgress()
                           THEN ObjectLink_Receipt_Parent_two.ObjectId
                      WHEN ObjectLink_Receipt_GoodsKind_parent.ChildObjectId = zc_GoodsKind_WorkProgress()
                           THEN ObjectLink_Receipt_Parent.ObjectId
                 END AS ReceiptId_calc
               , CASE WHEN ObjectFloat_Value_find.ValueData > 0 AND ObjectFloat_Value_find.ValueData <> lpSelect.Amount_in AND lpSelect.Amount_in > 0
                           THEN ObjectFloat_Value_find.ValueData
                             / CASE WHEN ObjectLink_Measure.ChildObjectId = ObjectLink_Measure_parent.ChildObjectId
                                         THEN 1
                                    WHEN ObjectLink_Measure.ChildObjectId        =  zc_Measure_Sh()
                                     AND ObjectLink_Measure_parent.ChildObjectId <> zc_Measure_Sh()
                                     AND ObjectFloat_Weight.ValueData             > 0
                                         THEN ObjectFloat_Weight.ValueData
                                    WHEN ObjectLink_Measure.ChildObjectId        <>  zc_Measure_Sh()
                                     AND ObjectLink_Measure_parent.ChildObjectId = zc_Measure_Sh()
                                     AND ObjectFloat_Weight_parent.ValueData      > 0
                                         THEN ObjectFloat_Weight_parent.ValueData
                                    ELSE 1
                               END
                           ELSE lpSelect.Amount_in
                 END AS Amount_in_calc

               , CASE WHEN ObjectFloat_Value_find_two.ValueData > 0 AND ObjectFloat_Value_find_two.ValueData <> lpSelect.Amount_in AND lpSelect.Amount_in > 0
                           THEN ObjectFloat_Value_find_two.ValueData
                             / CASE WHEN ObjectLink_Measure.ChildObjectId = ObjectLink_Measure_parent.ChildObjectId
                                         THEN 1
                                    WHEN ObjectLink_Measure.ChildObjectId        =  zc_Measure_Sh()
                                     AND ObjectLink_Measure_parent.ChildObjectId <> zc_Measure_Sh()
                                     AND ObjectFloat_Weight.ValueData             > 0
                                         THEN ObjectFloat_Weight.ValueData
                                    WHEN ObjectLink_Measure.ChildObjectId        <>  zc_Measure_Sh()
                                     AND ObjectLink_Measure_parent.ChildObjectId = zc_Measure_Sh()
                                     AND ObjectFloat_Weight_parent.ValueData      > 0
                                         THEN ObjectFloat_Weight_parent.ValueData
                                    ELSE 1
                               END
                           ELSE lpSelect.Amount_in
                 END AS Amount_in_calc_two

               , SUM (CASE WHEN ObjectFloat_Value_find.ValueData > 0 AND ObjectFloat_Value_find.ValueData <> lpSelect.Amount_in AND lpSelect.Amount_in > 0
                                THEN lpSelect.Amount_out / lpSelect.Amount_in * ObjectFloat_Value_find.ValueData
                                   / CASE WHEN ObjectLink_Measure.ChildObjectId = ObjectLink_Measure_parent.ChildObjectId
                                               THEN 1
                                          WHEN ObjectLink_Measure.ChildObjectId        =  zc_Measure_Sh()
                                           AND ObjectLink_Measure_parent.ChildObjectId <> zc_Measure_Sh()
                                           AND ObjectFloat_Weight.ValueData             > 0
                                               THEN ObjectFloat_Weight.ValueData
                                          WHEN ObjectLink_Measure.ChildObjectId        <>  zc_Measure_Sh()
                                           AND ObjectLink_Measure_parent.ChildObjectId = zc_Measure_Sh()
                                           AND ObjectFloat_Weight_parent.ValueData      > 0
                                               THEN ObjectFloat_Weight_parent.ValueData
                                          ELSE 1
                                     END
                                ELSE lpSelect.Amount_out
                      END) AS Amount_out_calc

               , 0 AS ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
               , SUM (lpSelect.Amount_out) AS Amount_out
               , SUM (CASE WHEN lpSelect.isStart = TRUE THEN lpSelect.Amount_out ELSE 0 END) AS Amount_out_start
               , MAX (CASE WHEN lpSelect.isStart = TRUE THEN 1 ELSE 0 END) AS isStart

               , lpSelect.isCost

                 -- Price1
               , COALESCE (PriceList1_gk.Price, PriceList1.Price, 0)
                 -- Price2
               , COALESCE (PriceList2_gk.Price, PriceList2.Price, 0)
                 -- Price3
               , COALESCE (PriceList3_gk.Price, PriceList3.Price, 0)

                 -- Price1_calc
               , COALESCE (PriceList1_gk.Price, PriceList1.Price, 0)
                 -- Price2_calc
               , COALESCE (PriceList2_gk.Price, PriceList2.Price, 0)
                 -- Price3_calc
               , COALESCE (PriceList3_gk.Price, PriceList3.Price, 0)

                 -- Koeff1_bon
               , COALESCE (PriceList1_bon_gk.Price, PriceList1_bon_gk_b.Price, PriceList1_bon.Price, 0)
                 -- Koeff2_bon
               , COALESCE (PriceList2_bon_gk.Price, PriceList2_bon_gk_b.Price, PriceList2_bon.Price, 0)
                 -- Koeff3_bon
               , COALESCE (PriceList3_bon_gk.Price, PriceList3_bon_gk_b.Price, PriceList3_bon.Price, 0)

                 -- Price1_bon
               , COALESCE (PriceList1_bon_gk.Price, PriceList1_bon_gk_b.Price, PriceList1_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2
                 -- Price2_bon
               , COALESCE (PriceList2_bon_gk.Price, PriceList2_bon_gk_b.Price, PriceList2_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2
                 -- Price3_bon
               , COALESCE (PriceList3_bon_gk.Price, PriceList3_bon_gk_b.Price, PriceList3_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2

               --, ObjectLink_Receipt_Goods.ChildObjectId     AS GoodsId_in_bon
               -- , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId_in_bon


          FROM lpSelect_Object_ReceiptChildDetail (TRUE) AS lpSelect
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                    ON ObjectLink_Receipt_Goods.ObjectId = lpSelect.ReceiptId
                                   AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = lpSelect.ReceiptId
                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                    ON ObjectLink_Receipt_Parent.ObjectId = lpSelect.ReceiptId_parent
                                   AND ObjectLink_Receipt_Parent.DescId   = zc_ObjectLink_Receipt_Parent()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_two
                                    ON ObjectLink_Receipt_Parent_two.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                   AND ObjectLink_Receipt_Parent_two.DescId   = zc_ObjectLink_Receipt_Parent()

               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                    ON ObjectLink_Receipt_Goods_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                   AND ObjectLink_Receipt_Goods_parent.DescId   = zc_ObjectLink_Receipt_Goods()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent_two
                                    ON ObjectLink_Receipt_Goods_parent_two.ObjectId = ObjectLink_Receipt_Parent_two.ChildObjectId
                                   AND ObjectLink_Receipt_Goods_parent_two.DescId   = zc_ObjectLink_Receipt_Goods()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_parent
                                    ON ObjectLink_Receipt_GoodsKind_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                   AND ObjectLink_Receipt_GoodsKind_parent.DescId   = zc_ObjectLink_Receipt_GoodsKind()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_parent_two
                                    ON ObjectLink_Receipt_GoodsKind_parent_two.ObjectId = ObjectLink_Receipt_Parent_two.ChildObjectId
                                   AND ObjectLink_Receipt_GoodsKind_parent_two.DescId   = zc_ObjectLink_Receipt_GoodsKind()

               LEFT JOIN Object AS Object_Goods_parent ON Object_Goods_parent.Id = CASE WHEN ObjectLink_Receipt_GoodsKind_parent_two.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                             THEN ObjectLink_Receipt_Goods_parent_two.ChildObjectId
                                                                                        WHEN ObjectLink_Receipt_GoodsKind_parent.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                             THEN ObjectLink_Receipt_Goods_parent.ChildObjectId
                                                                                   END
               LEFT JOIN ObjectFloat AS ObjectFloat_Value_find
                                     ON ObjectFloat_Value_find.ObjectId = CASE WHEN ObjectLink_Receipt_GoodsKind_parent_two.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                    THEN ObjectLink_Receipt_Parent_two.ObjectId
                                                                               WHEN ObjectLink_Receipt_GoodsKind_parent.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                    THEN ObjectLink_Receipt_Parent.ObjectId
                                                                          END
                                    AND ObjectFloat_Value_find.DescId   = zc_ObjectFloat_Receipt_Value()

               LEFT JOIN ObjectFloat AS ObjectFloat_Value_find_two
                                     ON ObjectFloat_Value_find_two.ObjectId = CASE WHEN ObjectLink_Receipt_GoodsKind_parent_two.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                    THEN ObjectLink_Receipt_Parent_two.ChildObjectId
                                                                               WHEN ObjectLink_Receipt_GoodsKind_parent.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                    THEN ObjectLink_Receipt_Parent.ChildObjectId
                                                                          END
                                    AND ObjectFloat_Value_find_two.DescId   = zc_ObjectFloat_Receipt_Value()

               LEFT JOIN ObjectLink AS ObjectLink_Measure
                                    ON ObjectLink_Measure.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                   AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
               LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                     ON ObjectFloat_Weight.ObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                    AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
               LEFT JOIN ObjectLink AS ObjectLink_Measure_parent
                                    ON ObjectLink_Measure_parent.ObjectId = Object_Goods_parent.Id
                                   AND ObjectLink_Measure_parent.DescId   = zc_ObjectLink_Goods_Measure()
               LEFT JOIN ObjectFloat AS ObjectFloat_Weight_parent
                                     ON ObjectFloat_Weight_parent.ObjectId = Object_Goods_parent.Id
                                    AND ObjectFloat_Weight_parent.DescId   = zc_ObjectFloat_Goods_Weight()


              LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk ON PriceListSale_gk.PriceListId = inPriceListId_sale
                                                                            AND PriceListSale_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                            AND PriceListSale_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                            AND CURRENT_DATE >= PriceListSale_gk.StartDate AND CURRENT_DATE < PriceListSale_gk.EndDate
                                                                            AND PriceListSale_gk.Price <> 0
                                                                            AND lpSelect.isCost = TRUE
              LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk_b ON PriceListSale_gk_b.PriceListId = inPriceListId_sale
                                                                              AND PriceListSale_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceListSale_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                              AND CURRENT_DATE >= PriceListSale_gk_b.StartDate AND CURRENT_DATE < PriceListSale_gk_b.EndDate
                                                                              AND PriceListSale_gk_b.Price <> 0
                                                                              AND PriceListSale_gk.GoodsId IS NULL
                                                                              AND lpSelect.isCost = TRUE
              LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                         AND PriceListSale.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                         AND PriceListSale.GoodsKindId = 0
                                                                         AND CURRENT_DATE >= PriceListSale.StartDate AND CURRENT_DATE < PriceListSale.EndDate
                                                                         AND PriceListSale.Price <> 0
                                                                         AND PriceListSale_gk_b.GoodsId IS NULL
                                                                         AND PriceListSale_gk.GoodsId IS NULL
                                                                         AND lpSelect.isCost = TRUE

               -- Бонус коэфф - 1 + gk
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_bon_gk ON PriceList1_bon_gk.PriceListId = inPriceListId_1
                                                                              AND PriceList1_bon_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceList1_bon_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                              AND PriceList1_bon_gk.Price <> 0
                                                                              AND CURRENT_DATE >= PriceList1_bon_gk.StartDate AND CURRENT_DATE < PriceList1_bon_gk.EndDate
                                                                              AND lpSelect.isCost = TRUE
               -- Бонус коэфф - 2 + gk
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_bon_gk ON PriceList2_bon_gk.PriceListId = inPriceListId_2
                                                                              AND PriceList2_bon_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceList2_bon_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                              AND PriceList2_bon_gk.Price <> 0
                                                                              AND CURRENT_DATE >= PriceList2_bon_gk.StartDate AND CURRENT_DATE < PriceList2_bon_gk.EndDate
                                                                              AND lpSelect.isCost = TRUE
               -- Бонус коэфф - 3 + gk
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_bon_gk ON PriceList3_bon_gk.PriceListId = inPriceListId_3
                                                                              AND PriceList3_bon_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceList3_bon_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                              AND PriceList3_bon_gk.Price <> 0
                                                                              AND CURRENT_DATE >= PriceList3_bon_gk.StartDate AND CURRENT_DATE < PriceList3_bon_gk.EndDate
                                                                              AND lpSelect.isCost = TRUE

               -- Бонус коэфф - 1 + gk = zc_GoodsKind_Basis
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_bon_gk_b ON PriceList1_bon_gk_b.PriceListId = inPriceListId_1
                                                                                AND PriceList1_bon_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                                AND PriceList1_bon_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                                AND PriceList1_bon_gk_b.Price <> 0
                                                                                AND CURRENT_DATE >= PriceList1_bon_gk_b.StartDate AND CURRENT_DATE < PriceList1_bon_gk_b.EndDate
                                                                                AND lpSelect.isCost = TRUE
                                                                                AND PriceList1_bon_gk.GoodsId IS NULL
               -- Бонус коэфф - 2 + gk = zc_GoodsKind_Basis
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_bon_gk_b ON PriceList2_bon_gk_b.PriceListId = inPriceListId_2
                                                                                AND PriceList2_bon_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                                AND PriceList2_bon_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                                AND PriceList2_bon_gk_b.Price <> 0
                                                                                AND CURRENT_DATE >= PriceList2_bon_gk_b.StartDate AND CURRENT_DATE < PriceList2_bon_gk_b.EndDate
                                                                                AND lpSelect.isCost = TRUE
                                                                                AND PriceList2_bon_gk_b.GoodsId IS NULL
               -- Бонус коэфф - 3 + gk = zc_GoodsKind_Basis
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_bon_gk_b ON PriceList3_bon_gk_b.PriceListId = inPriceListId_3
                                                                                AND PriceList3_bon_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                                AND PriceList3_bon_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                                AND PriceList3_bon_gk_b.Price <> 0
                                                                                AND CURRENT_DATE >= PriceList3_bon_gk_b.StartDate AND CURRENT_DATE < PriceList3_bon_gk_b.EndDate
                                                                                AND lpSelect.isCost = TRUE
                                                                                AND PriceList3_bon_gk_b.GoodsId IS NULL

               -- Бонус коэфф - 1 + gk = 0
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_bon ON PriceList1_bon.PriceListId = inPriceListId_1
                                                                           AND PriceList1_bon.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                           AND PriceList1_bon.GoodsKindId = 0
                                                                           AND PriceList1_bon.Price <> 0
                                                                           AND CURRENT_DATE >= PriceList1_bon.StartDate AND CURRENT_DATE < PriceList1_bon.EndDate
                                                                           AND lpSelect.isCost = TRUE
                                                                           AND PriceList1_bon_gk_b.GoodsId IS NULL
                                                                           AND PriceList1_bon_gk.GoodsId IS NULL
               -- Бонус коэфф - 2 + gk = 0
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_bon ON PriceList2_bon.PriceListId = inPriceListId_2
                                                                           AND PriceList2_bon.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                           AND PriceList2_bon.GoodsKindId = 0
                                                                           AND PriceList2_bon.Price <> 0
                                                                           AND CURRENT_DATE >= PriceList2_bon.StartDate AND CURRENT_DATE < PriceList2_bon.EndDate
                                                                           AND lpSelect.isCost = TRUE
                                                                           AND PriceList2_bon_gk_b.GoodsId IS NULL
                                                                           AND PriceList2_bon_gk.GoodsId IS NULL
               -- Бонус коэфф - 3 + gk = 0
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_bon ON PriceList3_bon.PriceListId = inPriceListId_3
                                                                           AND PriceList3_bon.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                           AND PriceList3_bon.GoodsKindId = 0
                                                                           AND PriceList3_bon.Price <> 0
                                                                           AND CURRENT_DATE >= PriceList3_bon.StartDate AND CURRENT_DATE < PriceList3_bon.EndDate
                                                                           AND lpSelect.isCost = TRUE
                                                                           AND PriceList3_bon_gk_b.GoodsId IS NULL
                                                                           AND PriceList3_bon_gk.GoodsId IS NULL

               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_gk ON PriceList1_gk.PriceListId = inPriceListId_1
                                                                          AND PriceList1_gk.GoodsId = lpSelect.GoodsId_out
                                                                          AND PriceList1_gk.GoodsKindId = lpSelect.GoodsKindId_out
                                                                          AND CURRENT_DATE >= PriceList1_gk.StartDate AND CURRENT_DATE < PriceList1_gk.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = inPriceListId_1
                                                                       AND PriceList1.GoodsId     = lpSelect.GoodsId_out
                                                                       AND PriceList1.GoodsKindId = 0
                                                                       AND CURRENT_DATE >= PriceList1.StartDate AND CURRENT_DATE < PriceList1.EndDate
                                                                       AND PriceList1_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_gk ON PriceList2_gk.PriceListId = inPriceListId_2
                                                                          AND PriceList2_gk.GoodsId = lpSelect.GoodsId_out
                                                                          AND PriceList2_gk.GoodsKindId = lpSelect.GoodsKindId_out
                                                                          AND CURRENT_DATE >= PriceList2_gk.StartDate AND CURRENT_DATE < PriceList2_gk.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2 ON PriceList2.PriceListId = inPriceListId_2
                                                                       AND PriceList2.GoodsId = lpSelect.GoodsId_out
                                                                       AND PriceList2.GoodsKindId = 0
                                                                       AND CURRENT_DATE >= PriceList2.StartDate AND CURRENT_DATE < PriceList2.EndDate
                                                                       AND PriceList2_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_gk ON PriceList3_gk.PriceListId = inPriceListId_3
                                                                          AND PriceList3_gk.GoodsId = lpSelect.GoodsId_out
                                                                          AND PriceList3_gk.GoodsKindId = lpSelect.GoodsKindId_out
                                                                          AND CURRENT_DATE >= PriceList3_gk.StartDate AND CURRENT_DATE < PriceList3_gk.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = inPriceListId_3
                                                                       AND PriceList3.GoodsId = lpSelect.GoodsId_out
                                                                       AND PriceList3.GoodsKindId = 0
                                                                       AND CURRENT_DATE >= PriceList3.StartDate AND CURRENT_DATE < PriceList3.EndDate
                                                                       AND PriceList3_gk.GoodsId IS NULL
          GROUP BY lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.Amount_in

                 , CASE WHEN ObjectLink_Receipt_GoodsKind_parent_two.ChildObjectId = zc_GoodsKind_WorkProgress()
                             THEN ObjectLink_Receipt_Parent_two.ObjectId
                        WHEN ObjectLink_Receipt_GoodsKind_parent.ChildObjectId = zc_GoodsKind_WorkProgress()
                             THEN ObjectLink_Receipt_Parent.ObjectId
                   END
                 , CASE WHEN ObjectFloat_Value_find.ValueData > 0 AND ObjectFloat_Value_find.ValueData <> lpSelect.Amount_in AND lpSelect.Amount_in > 0
                             THEN ObjectFloat_Value_find.ValueData
                               / CASE WHEN ObjectLink_Measure.ChildObjectId = ObjectLink_Measure_parent.ChildObjectId
                                           THEN 1
                                      WHEN ObjectLink_Measure.ChildObjectId        =  zc_Measure_Sh()
                                       AND ObjectLink_Measure_parent.ChildObjectId <> zc_Measure_Sh()
                                       AND ObjectFloat_Weight.ValueData             > 0
                                           THEN ObjectFloat_Weight.ValueData
                                      WHEN ObjectLink_Measure.ChildObjectId        <>  zc_Measure_Sh()
                                       AND ObjectLink_Measure_parent.ChildObjectId = zc_Measure_Sh()
                                       AND ObjectFloat_Weight_parent.ValueData      > 0
                                           THEN ObjectFloat_Weight_parent.ValueData
                                      ELSE 1
                                 END
                             ELSE lpSelect.Amount_in
                   END

                 , CASE WHEN ObjectFloat_Value_find_two.ValueData > 0 AND ObjectFloat_Value_find_two.ValueData <> lpSelect.Amount_in AND lpSelect.Amount_in > 0
                             THEN ObjectFloat_Value_find_two.ValueData
                               / CASE WHEN ObjectLink_Measure.ChildObjectId = ObjectLink_Measure_parent.ChildObjectId
                                           THEN 1
                                      WHEN ObjectLink_Measure.ChildObjectId        =  zc_Measure_Sh()
                                       AND ObjectLink_Measure_parent.ChildObjectId <> zc_Measure_Sh()
                                       AND ObjectFloat_Weight.ValueData             > 0
                                           THEN ObjectFloat_Weight.ValueData
                                      WHEN ObjectLink_Measure.ChildObjectId        <>  zc_Measure_Sh()
                                       AND ObjectLink_Measure_parent.ChildObjectId = zc_Measure_Sh()
                                       AND ObjectFloat_Weight_parent.ValueData      > 0
                                           THEN ObjectFloat_Weight_parent.ValueData
                                      ELSE 1
                                 END
                             ELSE lpSelect.Amount_in
                   END

                 , lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
                 -- , lpSelect.isStart
                 , lpSelect.isCost
                 , COALESCE (PriceList1_gk.Price, PriceList1.Price, 0)
                 , COALESCE (PriceList2_gk.Price, PriceList2.Price, 0)
                 , COALESCE (PriceList3_gk.Price, PriceList3.Price, 0)

               , COALESCE (PriceList1_bon_gk.Price, PriceList1_bon_gk_b.Price, PriceList1_bon.Price, 0)
               , COALESCE (PriceList2_bon_gk.Price, PriceList2_bon_gk_b.Price, PriceList2_bon.Price, 0)
               , COALESCE (PriceList3_bon_gk.Price, PriceList3_bon_gk_b.Price, PriceList3_bon.Price, 0)

               , COALESCE (PriceList1_bon_gk.Price, PriceList1_bon_gk_b.Price, PriceList1_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2
               , COALESCE (PriceList2_bon_gk.Price, PriceList2_bon_gk_b.Price, PriceList2_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2
               , COALESCE (PriceList3_bon_gk.Price, PriceList3_bon_gk_b.Price, PriceList3_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2

               --, ObjectLink_Receipt_Goods.ChildObjectId
               --, ObjectLink_Receipt_GoodsKind.ChildObjectId
         ;


     -- Результат
     OPEN Cursor1 FOR
     WITH  tmpAll AS
           (SELECT tmp.ReceiptId_parent
                 , tmp.ReceiptId
                 , tmp.ReceiptId_calc
                 , tmp.Amount_in_calc
                 , tmp.Amount_in_calc_two
                 , COALESCE (ObjectLink_Receipt_Goods.ChildObjectId, 0)               AS GoodsId
                 , COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)           AS GoodsKindId
                 , CASE WHEN ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress()
                         AND COALESCE (ObjectLink_Receipt_GoodsKind_complete.ChildObjectId, 0) = 0
                             THEN zc_GoodsKind_Basis()
                        ELSE COALESCE (ObjectLink_Receipt_GoodsKind_complete.ChildObjectId, 0)
                   END AS GoodsKindId_complete

                 , SUM (tmp.Summ1)      AS Summ1
                 , SUM (tmp.Summ2)      AS Summ2
                 , SUM (tmp.Summ3)      AS Summ3
                 , SUM (tmp.Summ1_cost) AS Summ1_cost
                 , SUM (tmp.Summ2_cost) AS Summ2_cost
                 , SUM (tmp.Summ3_cost) AS Summ3_cost

                 , SUM (tmp.Summ1_calc) AS Summ1_calc
                 , SUM (tmp.Summ2_calc) AS Summ2_calc
                 , SUM (tmp.Summ3_calc) AS Summ3_calc
                 , SUM (tmp.Summ1_cost_calc) AS Summ1_cost_calc
                 , SUM (tmp.Summ2_cost_calc) AS Summ2_cost_calc
                 , SUM (tmp.Summ3_cost_calc) AS Summ3_cost_calc

                 , MAX (tmp.Koeff1_bon) AS Koeff1_bon
                 , MAX (tmp.Koeff2_bon) AS Koeff2_bon
                 , MAX (tmp.Koeff3_bon) AS Koeff3_bon

                 , SUM (tmp.Summ1_bon) AS Summ1_bon
                 , SUM (tmp.Summ2_bon) AS Summ2_bon
                 , SUM (tmp.Summ3_bon) AS Summ3_bon

                 , SUM (tmp.Summ1_bon_calc) AS Summ1_bon_calc
                 , SUM (tmp.Summ2_bon_calc) AS Summ2_bon_calc
                 , SUM (tmp.Summ3_bon_calc) AS Summ3_bon_calc

            FROM (SELECT tmpChildReceiptTable.ReceiptId_parent
                       , tmpChildReceiptTable.ReceiptId
                       , tmpChildReceiptTable.ReceiptId_calc
                       , tmpChildReceiptTable.Amount_in_calc
                       , tmpChildReceiptTable.Amount_in_calc_two

                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1) AS Summ1
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2) AS Summ2
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1 ELSE 0 END) AS Summ1_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2 ELSE 0 END) AS Summ2_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost

                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_in_calc * tmpChildReceiptTable.Price1_bon ELSE 0 END) AS Summ1_bon
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_in_calc * tmpChildReceiptTable.Price2_bon ELSE 0 END) AS Summ2_bon
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_in_calc * tmpChildReceiptTable.Price3_bon ELSE 0 END) AS Summ3_bon


                       , SUM (tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price1) AS Summ1_calc
                       , SUM (tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price2) AS Summ2_calc
                       , SUM (tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price3) AS Summ3_calc
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price1 ELSE 0 END) AS Summ1_cost_calc
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price2 ELSE 0 END) AS Summ2_cost_calc
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost_calc

                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_in_calc * tmpChildReceiptTable.Price1_bon ELSE 0 END) AS Summ1_bon_calc
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_in_calc * tmpChildReceiptTable.Price2_bon ELSE 0 END) AS Summ2_bon_calc
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_in_calc * tmpChildReceiptTable.Price3_bon ELSE 0 END) AS Summ3_bon_calc

                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Koeff1_bon ELSE 0 END) AS Koeff1_bon
                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Koeff2_bon ELSE 0 END) AS Koeff2_bon
                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Koeff3_bon ELSE 0 END) AS Koeff3_bon

                  FROM tmpChildReceiptTable
                  WHERE tmpChildReceiptTable.ReceiptId_from = 0
                  GROUP BY tmpChildReceiptTable.ReceiptId_parent
                         , tmpChildReceiptTable.ReceiptId
                         , tmpChildReceiptTable.ReceiptId_calc
                         , tmpChildReceiptTable.Amount_in_calc
                         , tmpChildReceiptTable.Amount_in_calc_two
                 ) AS tmp
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                      ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                      ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_complete
                                      ON ObjectLink_Receipt_GoodsKind_complete.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_GoodsKind_complete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
                 INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = ObjectLink_Receipt_Goods.ChildObjectId

            GROUP BY tmp.ReceiptId_parent
                   , tmp.ReceiptId
                   , tmp.ReceiptId_calc
                   , tmp.Amount_in_calc
                   , tmp.Amount_in_calc_two
                   , COALESCE (ObjectLink_Receipt_Goods.ChildObjectId, 0)
                   , COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                   , CASE WHEN ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress()
                           AND COALESCE (ObjectLink_Receipt_GoodsKind_complete.ChildObjectId, 0) = 0
                               THEN zc_GoodsKind_Basis()
                          ELSE COALESCE (ObjectLink_Receipt_GoodsKind_complete.ChildObjectId, 0)
                     END
            )

        , tmpResult AS
           (SELECT tmpAll.ReceiptId_parent
                 , tmpAll.ReceiptId
                 , tmpAll.ReceiptId_calc
                 , MAX (tmpAll.Amount_in_calc)     AS Amount_in_calc
                 , MAX (tmpAll.Amount_in_calc_two) AS Amount_in_calc_two
                 , tmpAll.GoodsId
                 , tmpAll.GoodsKindId
                 , tmpAll.GoodsKindId_complete
                 , SUM (tmpAll.Summ1)      AS Summ1
                 , SUM (tmpAll.Summ2)      AS Summ2
                 , SUM (tmpAll.Summ3)      AS Summ3
                 , SUM (tmpAll.Summ1_cost) AS Summ1_cost
                 , SUM (tmpAll.Summ2_cost) AS Summ2_cost
                 , SUM (tmpAll.Summ3_cost) AS Summ3_cost

                 , SUM (tmpAll.Summ1_calc)      AS Summ1_calc
                 , SUM (tmpAll.Summ2_calc)      AS Summ2_calc
                 , SUM (tmpAll.Summ3_calc)      AS Summ3_calc
                 , SUM (tmpAll.Summ1_cost_calc) AS Summ1_cost_calc
                 , SUM (tmpAll.Summ2_cost_calc) AS Summ2_cost_calc
                 , SUM (tmpAll.Summ3_cost_calc) AS Summ3_cost_calc

                 , SUM (tmpAll.Summ1_bon)         AS Summ1_bon
                 , SUM (tmpAll.Summ2_bon)         AS Summ2_bon
                 , SUM (tmpAll.Summ3_bon)         AS Summ3_bon
                 , SUM (tmpAll.Summ1_bon_calc)    AS Summ1_bon_calc
                 , SUM (tmpAll.Summ2_bon_calc)    AS Summ2_bon_calc
                 , SUM (tmpAll.Summ3_bon_calc)    AS Summ3_bon_calc

                 , MAX (tmpAll.Koeff1_bon) AS Koeff1_bon
                 , MAX (tmpAll.Koeff2_bon) AS Koeff2_bon
                 , MAX (tmpAll.Koeff3_bon) AS Koeff3_bon

            FROM tmpAll
            GROUP BY tmpAll.ReceiptId_parent
                   , tmpAll.ReceiptId
                   , tmpAll.ReceiptId_calc
                 --, tmpAll.Amount_in_calc
                 --, tmpAll.Amount_in_calc_two
                   , tmpAll.GoodsId
                   , tmpAll.GoodsKindId
                   , tmpAll.GoodsKindId_complete
           )
      -- Результат
      SELECT (CURRENT_DATE + INTERVAL '0 DAY') :: TDateTime      AS OperDate
           , (tmpResult.ReceiptId_parent :: TVarChar || '_' || tmpResult.ReceiptId :: TVarChar) :: TVarChar AS ReceiptId_link
           , tmpResult.ReceiptId_parent
           , tmpResult.ReceiptId
           , Object_Receipt.ObjectCode      AS Code
           , ObjectString_Code.ValueData    AS ReceiptCode
           , ObjectString_Comment.ValueData AS Comment

           , Object_Receipt_calc.ObjectCode      AS Code_calc
           , ObjectString_Code_calc.ValueData    AS ReceiptCode_calc
           , ObjectString_Comment_calc.ValueData AS Comment_calc

           , ObjectFloat_Value.ValueData         AS Amount
           , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS Amount_Weight

           , tmpResult.Amount_in_calc     :: TFloat AS Amount_calc
           , tmpResult.Amount_in_calc_two :: TFloat AS Amount_calc_two
           , (tmpResult.Amount_in_calc     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS Amount_Weight_calc
           , (tmpResult.Amount_in_calc_two * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS Amount_Weight_calc_two

           , ObjectFloat_TaxExit.ValueData       AS TaxExit
           , ObjectFloat_TaxLoss.ValueData       AS TaxLoss
           , ObjectBoolean_Main.ValueData        AS isMain

           , ObjectFloat_TaxExit_calc.ValueData  AS TaxExit_calc
           , ObjectFloat_TaxLoss_calc.ValueData  AS TaxLoss_calc
           , ObjectBoolean_Main_calc.ValueData   AS isMain_calc

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
           , Object_GoodsTag.ValueData                   AS GoodsTagName
           , Object_TradeMark.ValueData                  AS TradeMarkName
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_GoodsKindComplete.ValueData          AS GoodsKindCompleteName
           , Object_Measure.ValueData                    AS MeasureName

           , tmpResult.ReceiptId_parent
           , Object_Receipt_Parent.ObjectCode            AS Code_Parent
           , ObjectString_Code_Parent.ValueData          AS ReceiptCode_Parent
           , ObjectBoolean_Main_Parent.ValueData         AS isMain_Parent
           , Object_Goods_Parent.ObjectCode              AS GoodsCode_Parent
           , Object_Goods_Parent.ValueData               AS GoodsName_Parent
           , Object_Measure_Parent.ValueData             AS MeasureName_Parent
           , Object_GoodsKind_Parent.ValueData           AS GoodsKindName_Parent
           , Object_GoodsKindComplete_Parent.ValueData   AS GoodsKindCompleteName_Parent

         --, (tmpChild.Amount_out * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS Amount_out_Weight
           , tmpChild.Amount_out_Weight      :: TFloat AS Amount_out_Weight
           , tmpChild.Amount_out_Weight_calc :: TFloat AS Amount_out_Weight_calc

           , CAST (tmpResult.Summ1 / ObjectFloat_Value.ValueData + CASE WHEN vbUserId = 0 THEN COALESCE (tmpResult.Summ1_bon, 0) / tmpResult.Amount_in_calc
                                                                                             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                        WHEN tmpResult.Amount_in_calc > 0 THEN COALESCE (tmpResult.Summ1_bon, 0) / tmpResult.Amount_in_calc
                                                                                                             * CASE WHEN 1=1 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                        ELSE 0
                                                                   END AS NUMERIC (16, 3)) :: TFloat AS Price1
           , CAST (tmpResult.Summ2 / ObjectFloat_Value.ValueData + CASE WHEN vbUserId = 0 THEN COALESCE (tmpResult.Summ1_bon, 0) / tmpResult.Amount_in_calc
                                                                                             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                        WHEN tmpResult.Amount_in_calc > 0 THEN COALESCE (tmpResult.Summ1_bon, 0) / tmpResult.Amount_in_calc
                                                                                                             * CASE WHEN 1=1 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                        ELSE 0
                                                                   END AS NUMERIC (16, 3)) :: TFloat AS Price2
           , CAST (tmpResult.Summ3 / ObjectFloat_Value.ValueData + CASE WHEN vbUserId = 0 THEN COALESCE (tmpResult.Summ1_bon, 0) / tmpResult.Amount_in_calc
                                                                                            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                        WHEN tmpResult.Amount_in_calc > 0 THEN COALESCE (tmpResult.Summ1_bon, 0) / tmpResult.Amount_in_calc
                                                                                                             * CASE WHEN 1=1 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                        ELSE 0
                                                                   END AS NUMERIC (16, 3)) :: TFloat AS Price3

           , CAST (tmpResult.Summ1_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) :: TFloat AS Price1_cost
           , CAST (tmpResult.Summ2_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) :: TFloat AS Price2_cost
           , CAST (tmpResult.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) :: TFloat AS Price3_cost

           , CAST (tmpResult.Summ1_calc / tmpResult.Amount_in_calc + COALESCE (tmpResult.Summ1_bon_calc, 0) / tmpResult.Amount_in_calc
                                                                   * CASE WHEN 1=1 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                    AS NUMERIC (16, 3)) :: TFloat AS Price1_calc

           , CAST (tmpResult.Summ2_calc / tmpResult.Amount_in_calc + COALESCE (tmpResult.Summ1_bon_calc, 0) / tmpResult.Amount_in_calc
                                                                   * CASE WHEN 1=1 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                   AS NUMERIC (16, 3)) :: TFloat AS Price2_calc

           , CAST (tmpResult.Summ3_calc / tmpResult.Amount_in_calc + COALESCE (tmpResult.Summ1_bon_calc, 0) / tmpResult.Amount_in_calc
                                                                   * CASE WHEN 1=1 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                    AS NUMERIC (16, 3)) :: TFloat AS Price3_calc

           , CAST (tmpResult.Summ1_cost_calc / tmpResult.Amount_in_calc AS NUMERIC (16, 3)) :: TFloat AS Price1_cost_calc
           , CAST (tmpResult.Summ2_cost_calc / tmpResult.Amount_in_calc AS NUMERIC (16, 3)) :: TFloat AS Price2_cost_calc
           , CAST (tmpResult.Summ3_cost_calc / tmpResult.Amount_in_calc AS NUMERIC (16, 3)) :: TFloat AS Price3_cost_calc

           , (COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2) :: TFloat AS Price_sale -- !!!захардкодил временно!!!

           , tmpResult.Koeff1_bon :: TFloat AS Price1_bon
           , tmpResult.Koeff1_bon :: TFloat AS Price2_bon
           , tmpResult.Koeff1_bon :: TFloat AS Price3_bon

           , CASE WHEN tmpResult.Amount_in_calc > 0 THEN COALESCE (tmpResult.Summ1_bon / tmpResult.Amount_in_calc, 0)
                                                                                       * CASE when vbUserId = 5 OR 1=1 then 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                  ELSE 0 END :: TFloat AS Price1_bon_sale
           , CASE WHEN tmpResult.Amount_in_calc > 0 THEN COALESCE (tmpResult.Summ1_bon / tmpResult.Amount_in_calc, 0)
                                                                                       * CASE when vbUserId = 5 OR 1=1 then 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                  ELSE 0 END :: TFloat AS Price2_bon_sale
           , CASE WHEN tmpResult.Amount_in_calc > 0 THEN COALESCE (tmpResult.Summ1_bon / tmpResult.Amount_in_calc, 0)
                                                                                       * CASE when vbUserId = 5 OR 1=1 then 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                  ELSE 0 END :: TFloat AS Price3_bon_sale


           , CASE WHEN Object_Goods.Id <> Object_Goods_Parent.Id THEN TRUE ELSE FALSE END AS isCheck_Parent

       FROM tmpResult
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk ON PriceListSale_gk.PriceListId = inPriceListId_sale
                                                                          AND PriceListSale_gk.GoodsId = tmpResult.GoodsId
                                                                          AND PriceListSale_gk.GoodsKindId = tmpResult.GoodsKindId
                                                                          AND CURRENT_DATE >= PriceListSale_gk.StartDate AND CURRENT_DATE < PriceListSale_gk.EndDate
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                       AND PriceListSale.GoodsId = tmpResult.GoodsId
                                                                       AND PriceListSale.GoodsKindId = 0
                                                                       AND CURRENT_DATE >= PriceListSale.StartDate AND CURRENT_DATE < PriceListSale.EndDate
                                                                       AND PriceListSale_gk.GoodsId IS NULL
            LEFT JOIN Object AS Object_Receipt   ON Object_Receipt.Id   = tmpResult.ReceiptId
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpResult.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpResult.GoodsKindId_complete

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                 ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
            LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                 ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId


            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                  ON ObjectFloat_Value.ObjectId = tmpResult.ReceiptId
                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                  ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id
                                 AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                  ON ObjectFloat_TaxLoss.ObjectId = Object_Receipt.Id
                                 AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                    ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
            LEFT JOIN ObjectString AS ObjectString_Code
                                   ON ObjectString_Code.ObjectId = tmpResult.ReceiptId
                                  AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = tmpResult.ReceiptId
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Receipt_Comment()

          LEFT JOIN Object AS Object_Receipt_Parent ON Object_Receipt_Parent.Id = tmpResult.ReceiptId_parent
          LEFT JOIN Object AS Object_Receipt_calc   ON Object_Receipt_calc.Id   = tmpResult.ReceiptId_calc

          LEFT JOIN ObjectString AS ObjectString_Code_Parent
                                 ON ObjectString_Code_Parent.ObjectId = Object_Receipt_Parent.Id
                                AND ObjectString_Code_Parent.DescId   = zc_ObjectString_Receipt_Code()
          LEFT JOIN ObjectString AS ObjectString_Code_calc
                                 ON ObjectString_Code_calc.ObjectId = Object_Receipt_calc.Id
                                AND ObjectString_Code_calc.DescId   = zc_ObjectString_Receipt_Code()

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit_calc
                                ON ObjectFloat_TaxExit_calc.ObjectId = Object_Receipt_calc.Id
                               AND ObjectFloat_TaxExit_calc.DescId   = zc_ObjectFloat_Receipt_TaxExit()
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss_calc
                                ON ObjectFloat_TaxLoss_calc.ObjectId = Object_Receipt_calc.Id
                               AND ObjectFloat_TaxLoss_calc.DescId   = zc_ObjectFloat_Receipt_TaxLoss()
          LEFT JOIN ObjectString AS ObjectString_Comment_calc
                                 ON ObjectString_Comment_calc.ObjectId = Object_Receipt_calc.Id
                                AND ObjectString_Comment_calc.DescId   = zc_ObjectString_Receipt_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent
                               ON ObjectLink_Receipt_Goods_Parent.ObjectId = Object_Receipt_Parent.Id
                              AND ObjectLink_Receipt_Goods_Parent.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = ObjectLink_Receipt_Goods_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_Parent
                               ON ObjectLink_Goods_Measure_Parent.ObjectId = Object_Goods_Parent.Id
                              AND ObjectLink_Goods_Measure_Parent.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure_Parent ON Object_Measure_Parent.Id = ObjectLink_Goods_Measure_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent
                              ON ObjectLink_Receipt_GoodsKind_Parent.ObjectId = Object_Receipt_Parent.Id
                             AND ObjectLink_Receipt_GoodsKind_Parent.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = ObjectLink_Receipt_GoodsKind_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete_Parent
                               ON ObjectLink_Receipt_GoodsKindComplete_Parent.ObjectId = Object_Receipt_Parent.Id
                              AND ObjectLink_Receipt_GoodsKindComplete_Parent.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
          LEFT JOIN Object AS Object_GoodsKindComplete_Parent ON Object_GoodsKindComplete_Parent.Id = ObjectLink_Receipt_GoodsKindComplete_Parent.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_Parent
                                  ON ObjectBoolean_Main_Parent.ObjectId = Object_Receipt_Parent.Id
                                 AND ObjectBoolean_Main_Parent.DescId   = zc_ObjectBoolean_Receipt_Main()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_calc
                                  ON ObjectBoolean_Main_calc.ObjectId = Object_Receipt_calc.Id
                                 AND ObjectBoolean_Main_calc.DescId   = zc_ObjectBoolean_Receipt_Main()

          LEFT JOIN (SELECT tmpChildReceiptTable.ReceiptId_parent
                          , tmpChildReceiptTable.ReceiptId
                          , SUM (tmpChildReceiptTable.Amount_out      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount_out_Weight
                          , SUM (tmpChildReceiptTable.Amount_out_calc * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount_out_Weight_calc
                        --, SUM (CASE WHEN tmpChildReceiptTable.ReceiptId_from = 0  AND ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh() THEN tmpChildReceiptTable.Amount_out_calc ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount_out_Weight_calc
                     FROM tmpChildReceiptTable
                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                ON ObjectFloat_Weight.ObjectId = tmpChildReceiptTable.GoodsId_out
                                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                               ON ObjectLink_Goods_Measure.ObjectId = tmpChildReceiptTable.GoodsId_out
                                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                     WHERE tmpChildReceiptTable.ReceiptId_from <> 0
                     GROUP BY tmpChildReceiptTable.ReceiptId_parent
                            , tmpChildReceiptTable.ReceiptId
                    ) AS tmpChild
                      ON tmpChild.ReceiptId_parent = Object_Receipt_Parent.Id
                     AND tmpChild.ReceiptId = tmpResult.ReceiptId
          ;
      -- Результат
      RETURN NEXT Cursor1;


     -- Результат
     OPEN Cursor2 FOR
       WITH tmpChild_calc AS (SELECT tmpChildReceiptTable.ReceiptId_parent
                                   , tmpChildReceiptTable.ReceiptId
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1) AS Summ1
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2) AS Summ2
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                                   , SUM (tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price1) AS Summ1_calc
                                   , SUM (tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price2) AS Summ2_calc
                                   , SUM (tmpChildReceiptTable.Amount_out_calc * tmpChildReceiptTable.Price3) AS Summ3_calc

                              FROM (SELECT tmpChildReceiptTable.ReceiptId_parent, tmpChildReceiptTable.ReceiptId_from FROM tmpChildReceiptTable WHERE tmpChildReceiptTable.ReceiptId_from > 0 GROUP BY tmpChildReceiptTable.ReceiptId_parent, tmpChildReceiptTable.ReceiptId_from
                                   ) AS tmp
                                   INNER JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId_parent = tmp.ReceiptId_parent
                                                                  AND tmpChildReceiptTable.ReceiptId = tmp.ReceiptId_from
                                                                  AND tmpChildReceiptTable.isCost = FALSE
                              GROUP BY tmpChildReceiptTable.ReceiptId_parent, tmpChildReceiptTable.ReceiptId
                             )
       SELECT (tmpReceiptChild.ReceiptId_parent :: TVarChar || '_' || tmpReceiptChild.ReceiptId :: TVarChar) :: TVarChar AS ReceiptId_link
            , tmpReceiptChild.ReceiptId_parent
            , tmpReceiptChild.ReceiptId
            , tmpReceiptChild.GroupNumber

            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Goods.Objectcode     AS GoodsCode
            , CASE WHEN tmpReceiptChild.GoodsId_out = zc_Enum_InfoMoney_21501()
                        THEN 'БОНУСИ'
                   ELSE Object_Goods.ValueData
              END :: TVarChar AS GoodsName

            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Measure.ValueData    AS MeasureName

            , Object_Receipt.ObjectCode   AS ReceiptCode
            , ObjectString_Code.ValueData AS ReceiptCode_user

            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyCode            END :: Integer  AS InfoMoneyCode
            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyGroupName       END :: TVarChar AS InfoMoneyGroupName
            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyDestinationName END :: TVarChar AS InfoMoneyDestinationName
            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyName            END :: TVarChar AS InfoMoneyName
            , CASE WHEN tmpReceiptChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                        THEN tmpReceiptChild.InfoMoneyDestinationName
                   ELSE tmpReceiptChild.InfoMoneyName
              END :: TVarChar AS InfoMoneyName_print
            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce()
                        THEN 1
                   ELSE tmpReceiptChild.GroupNumber
              END :: Integer AS GroupNumber_print

            , tmpReceiptChild.ReceiptId_from AS ReceiptId_from
            , tmpReceiptChild.Amount_in
            , tmpReceiptChild.Amount_in_calc

-- tmpReceiptChild.GoodsId_out = zc_Enum_InfoMoney_21501() AND vbUserId = 5 THEN ObjectFloatReceipt_Value.ValueData
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END AS Amount
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price1 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ1 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price1
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price2 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ2 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price2
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price3 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ3 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price3

            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 AND tmpReceiptChild.GroupNumber = 8 THEN CAST (tmpReceiptChild.Amount_out_calc AS NUMERIC(16,3))
                   WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out_calc
                   ELSE 0
              END :: TFloat AS Amount_calc
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price1_calc WHEN tmpReceiptChild.Amount_in_calc > 0 THEN tmpChild_calc.Summ1_calc / tmpReceiptChild.Amount_in_calc ELSE 0 END AS Price1_calc
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price2_calc WHEN tmpReceiptChild.Amount_in_calc > 0 THEN tmpChild_calc.Summ2_calc / tmpReceiptChild.Amount_in_calc ELSE 0 END AS Price2_calc
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price3_calc WHEN tmpReceiptChild.Amount_in_calc > 0 THEN tmpChild_calc.Summ3_calc / tmpReceiptChild.Amount_in_calc ELSE 0 END AS Price3_calc

            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price1 AS Summ1
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price2 AS Summ2
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price3 AS Summ3

            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out_calc ELSE 0 END * tmpReceiptChild.Price1 AS Summ1_calc
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out_calc ELSE 0 END * tmpReceiptChild.Price2 AS Summ2_calc
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out_calc ELSE 0 END * tmpReceiptChild.Price3 AS Summ3_calc

            , tmpReceiptChild.isCost
            , CASE WHEN tmpReceiptChild.isCost = TRUE THEN 1 ELSE 0 END :: Integer AS isCostValue
            , CASE WHEN tmpReceiptChild.isStart = 1 THEN TRUE ELSE FALSE END :: Boolean AS isStart
            , CASE WHEN tmpReceiptChild.InfoMoneyId = zc_Enum_InfoMoney_10203() THEN TRUE ELSE FALSE END :: Boolean AS isInfoMoney_10203

            , tmpReceiptChild.Amount_out_start AS Amount_start
            , tmpReceiptChild.Amount_out_start * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price1 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ1 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Summ1_Start
            , tmpReceiptChild.Amount_out_start * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price2 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ2 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Summ2_Start
            , tmpReceiptChild.Amount_out_start * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price3 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ3 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Summ3_Start

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

       FROM (SELECT tmpChildReceiptTable.ReceiptId_parent, tmpChildReceiptTable.ReceiptId_from, tmpChildReceiptTable.ReceiptId, tmpChildReceiptTable.GoodsId_in, tmpChildReceiptTable.GoodsKindId_in, tmpChildReceiptTable.Amount_in
                  , tmpChildReceiptTable.ReceiptId_calc, tmpChildReceiptTable.Amount_in_calc, tmpChildReceiptTable.Amount_in_calc_two, tmpChildReceiptTable.Amount_out_calc
                  , tmpChildReceiptTable.ReceiptChildId
                    --
                  , tmpChildReceiptTable.GoodsId_out
                  , tmpChildReceiptTable.GoodsKindId_out
                  , tmpChildReceiptTable.Amount_out
                  , tmpChildReceiptTable.Amount_out_start
                  , tmpChildReceiptTable.isStart
                  , tmpChildReceiptTable.isCost

                  , tmpChildReceiptTable.Price1, tmpChildReceiptTable.Price2, tmpChildReceiptTable.Price3
                  , tmpChildReceiptTable.Price1_calc, tmpChildReceiptTable.Price2_calc, tmpChildReceiptTable.Price3_calc
                  , tmpChildReceiptTable.Price1_bon, tmpChildReceiptTable.Price2_bon, tmpChildReceiptTable.Price3_bon

                  , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := tmpChildReceiptTable.GoodsId_out
                                                   , inGoodsKindId            := tmpChildReceiptTable.GoodsKindId_out
                                                   , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                   , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                   , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                   , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                    ) AS GroupNumber
                  , Object_InfoMoney_View.InfoMoneyCode
                  , Object_InfoMoney_View.InfoMoneyGroupName
                  , Object_InfoMoney_View.InfoMoneyDestinationName
                  , Object_InfoMoney_View.InfoMoneyName
                  , Object_InfoMoney_View.InfoMoneyDestinationId
                  , Object_InfoMoney_View.InfoMoneyId
             FROM tmpChildReceiptTable
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = tmpChildReceiptTable.GoodsId_out
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CASE WHEN tmpChildReceiptTable.GoodsId_out = zc_Goods_WorkIce() THEN zc_Enum_InfoMoney_10105() ELSE ObjectLink_Goods_InfoMoney.ChildObjectId END
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                          ON ObjectBoolean_WeightMain.ObjectId = tmpChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                          ON ObjectBoolean_TaxExit.ObjectId = tmpChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()

            UNION ALL
             SELECT tmpChildReceiptTable.ReceiptId_parent, tmpChildReceiptTable.ReceiptId_from, tmpChildReceiptTable.ReceiptId, tmpChildReceiptTable.GoodsId_in, tmpChildReceiptTable.GoodsKindId_in, tmpChildReceiptTable.Amount_in
                  , tmpChildReceiptTable.ReceiptId_calc

                  , tmpChildReceiptTable.Amount_in_calc
                  , tmpChildReceiptTable.Amount_in_calc_two

                  , CASE WHEN 1=1 THEN tmpChildReceiptTable.Amount_in_calc ELSE tmpChildReceiptTable.Amount_out_calc END AS Amount_out_calc

                  , tmpChildReceiptTable.ReceiptChildId
                    --
                  , zc_Enum_InfoMoney_21501() AS GoodsId_out
                  , 0 AS GoodsKindId_out

                  , CASE WHEN 1=1 THEN tmpChildReceiptTable.Amount_in      ELSE tmpChildReceiptTable.Amount_out       END AS Amount_out
                  , CASE WHEN 1=1 THEN tmpChildReceiptTable.Amount_in_calc ELSE tmpChildReceiptTable.Amount_out_start END AS Amount_out_start

                  , tmpChildReceiptTable.isStart
                  , tmpChildReceiptTable.isCost

                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price1
                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price2
                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price3

                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price1_calc
                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price2_calc
                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price3_calc

                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price1_bon_sale
                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price2_bon_sale
                  , COALESCE (tmpChildReceiptTable.Price1_bon, 0) :: TFloat AS Price3_bon_sale

                --, 11 AS GroupNumber
                  , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := tmpChildReceiptTable.GoodsId_out
                                                   , inGoodsKindId            := tmpChildReceiptTable.GoodsKindId_out
                                                   , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                   , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                   , inIsWeightMain           := FALSE
                                                   , inIsTaxExit              := FALSE
                                                    ) AS GroupNumber
                  , Object_InfoMoney_View.InfoMoneyCode
                  , Object_InfoMoney_View.InfoMoneyGroupName
                  , Object_InfoMoney_View.InfoMoneyDestinationName
                  , Object_InfoMoney_View.InfoMoneyName
                  , Object_InfoMoney_View.InfoMoneyDestinationId
                  , Object_InfoMoney_View.InfoMoneyId
             FROM tmpChildReceiptTable
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_21501()

             WHERE tmpChildReceiptTable.isCost = TRUE
               AND tmpChildReceiptTable.Price1_bon > 0
               --AND 1=0
            ) AS tmpReceiptChild
            LEFT JOIN tmpChild_calc ON tmpChild_calc.ReceiptId        = tmpReceiptChild.ReceiptId_from
                                   AND tmpChild_calc.ReceiptId_parent = tmpReceiptChild.ReceiptId_parent
            LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                  ON ObjectFloatReceipt_Value.ObjectId = tmpReceiptChild.ReceiptId_from
                                 AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReceiptChild.GoodsId_out
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpReceiptChild.GoodsKindId_out

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpReceiptChild.ReceiptId_from
            LEFT JOIN ObjectString AS ObjectString_Code
                                   ON ObjectString_Code.ObjectId = tmpReceiptChild.ReceiptId_from
                                  AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
           ;

     RETURN NEXT Cursor2;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.19         *
*/

-- тест
-- SELECT * FROM gpReport_ReceiptAnalyze (inGoodsGroupId:= 0, inGoodsId:=6694178, inPriceListId_1:= 18886, inPriceListId_2:= 18887, inPriceListId_3:= 18873, inPriceListId_sale:= 18840, inSession:= zfCalc_UserAdmin()) -- FETCH ALL "<unnamed portal 1>";
