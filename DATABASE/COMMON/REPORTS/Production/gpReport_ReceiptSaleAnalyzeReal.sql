-- Function: gpReport_ReceiptSaleAnalyzeReal()

--DROP FUNCTION IF EXISTS gpReport_ReceiptSaleAnalyzeReal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_ReceiptSaleAnalyzeReal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean,Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ReceiptSaleAnalyzeReal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReceiptSaleAnalyzeReal(
    IN inStartDate        TDateTime ,
    IN inEndDate          TDateTime ,
    IN inUnitId_sale      Integer   ,
    IN inUnitId_return    Integer   ,
    IN inJuridicalId      Integer   ,
    IN inGoodsGroupId     Integer   ,
    IN inPriceListId_1    Integer,
    IN inPriceListId_2    Integer,
    IN inPriceListId_3    Integer,
    IN inPriceListId_sale Integer,
    IN inPriceListId_5    Integer,
    IN inPriceListId_6    Integer,
    IN inIsGoodsKind      Boolean,
    IN inisExclude        Boolean, -- исключить да/нет выбранное юр.лицо
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Cursor1  refcursor;
  DECLARE Cursor2  refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!пересчет Рецептур, временно захардкодил!!!
    IF vbUserId <> 5 OR (inStartDate >= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                             -- последний день предыдущего месяца
                                             THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
                
                                             -- последний день ДВА месяца назад
                                             ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                                         END)
                      OR inEndDate   >= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                             -- последний день предыдущего месяца
                                             THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
                
                                             -- последний день ДВА месяца назад
                                             ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                                         END)
                        )
    THEN PERFORM lpUpdate_Object_Receipt_Total (Object.Id, zfCalc_UserAdmin() :: Integer) FROM Object WHERE DescId = zc_Object_Receipt();
    END IF;
    -- !!!пересчет Рецептур, временно захардкодил!!!
    IF vbUserId <> 5 OR (inStartDate >= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                             -- последний день предыдущего месяца
                                             THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
                
                                             -- последний день ДВА месяца назад
                                             ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                                         END)
                      OR inEndDate   >= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                             -- последний день предыдущего месяца
                                             THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
                
                                             -- последний день ДВА месяца назад
                                             ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                                         END)
                        )
    THEN PERFORM lpUpdate_Object_Receipt_Parent (0, 0, 0);
    END IF;


     CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
     -- CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;

     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, isStart Boolean, isCost Boolean
                                           , Price1 TFloat, Price2 TFloat, Price3 TFloat, Price4 TFloat
                                           , Koeff1_bon TFloat, Koeff2_bon TFloat, Koeff3_bon TFloat, Price1_bon TFloat, Price2_bon TFloat, Price3_bon TFloat
                                           , Price_pl TFloat
                                            ) ON COMMIT DROP;

     -- Ограничения по товару
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
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
       ;

     -- группа подразделений или подразделение
     /*INSERT INTO _tmpUnit (UnitId)
        SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId_sale) AS lfSelect WHERE inUnitId_sale <> 0
       UNION
        SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId_return) AS lfSelect WHERE inUnitId_return <> 0
       ;*/

     -- ВСЕ рецептуры
     INSERT INTO tmpChildReceiptTable (ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, isStart, isCost
                                     , Price1, Price2, Price3, Price4
                                     , Koeff1_bon, Koeff2_bon, Koeff3_bon, Price1_bon, Price2_bon, Price3_bon
                                     , Price_pl
                                      )
          SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
               , lpSelect.ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out, lpSelect.Amount_out, lpSelect.isStart
               , lpSelect.isCost
               , COALESCE (PriceList1_gk.Price, PriceList1.Price, 0)
               , COALESCE (PriceList2_gk.Price, PriceList2.Price, 0)
               , COALESCE (PriceList3_gk.Price, PriceList3.Price, 0)
               , COALESCE (PriceList4_gk.Price, PriceList4.Price, 0)

               , COALESCE (PriceList1_bon_gk.Price, PriceList1_bon_gk_b.Price, PriceList1_bon.Price, 0)
               , COALESCE (PriceList2_bon_gk.Price, PriceList2_bon_gk_b.Price, PriceList2_bon.Price, 0)
               , COALESCE (PriceList3_bon_gk.Price, PriceList3_bon_gk_b.Price, PriceList3_bon.Price, 0)

               , COALESCE (PriceList1_bon_gk.Price, PriceList1_bon_gk_b.Price, PriceList1_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2
               , COALESCE (PriceList2_bon_gk.Price, PriceList2_bon_gk_b.Price, PriceList2_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2
               , COALESCE (PriceList3_bon_gk.Price, PriceList3_bon_gk_b.Price, PriceList3_bon.Price, 0) * COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2
               
               , COALESCE (PriceListSale_gk.Price, PriceListSale_gk_b.Price, PriceListSale.Price) * 1.2 AS Price_pl

          FROM lpSelect_Object_ReceiptChildDetail() AS lpSelect
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                    ON ObjectLink_Receipt_Goods.ObjectId = lpSelect.ReceiptId
                                   AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = lpSelect.ReceiptId
                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

              LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk ON PriceListSale_gk.PriceListId = inPriceListId_sale
                                                                            AND PriceListSale_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                            AND PriceListSale_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                            AND inEndDate >= PriceListSale_gk.StartDate AND inEndDate < PriceListSale_gk.EndDate
                                                                            AND PriceListSale_gk.Price <> 0
                                                                            AND lpSelect.isCost = TRUE
              LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk_b ON PriceListSale_gk_b.PriceListId = inPriceListId_sale
                                                                              AND PriceListSale_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceListSale_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                              AND inEndDate >= PriceListSale_gk_b.StartDate AND inEndDate < PriceListSale_gk_b.EndDate
                                                                              AND PriceListSale_gk_b.Price <> 0
                                                                              AND PriceListSale_gk.GoodsId IS NULL
                                                                              AND lpSelect.isCost = TRUE
              LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                         AND PriceListSale.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                         AND PriceListSale.GoodsKindId = 0
                                                                         AND inEndDate >= PriceListSale.StartDate AND inEndDate < PriceListSale.EndDate
                                                                         AND PriceListSale.Price <> 0
                                                                         AND PriceListSale_gk_b.GoodsId IS NULL
                                                                         AND PriceListSale_gk.GoodsId IS NULL
                                                                         AND lpSelect.isCost = TRUE

               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_bon_gk ON PriceList1_bon_gk.PriceListId = inPriceListId_1
                                                                              AND PriceList1_bon_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceList1_bon_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                              AND PriceList1_bon_gk.Price <> 0
                                                                              AND inEndDate >= PriceList1_bon_gk.StartDate AND inEndDate < PriceList1_bon_gk.EndDate
                                                                              AND lpSelect.isCost = TRUE
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_bon_gk ON PriceList2_bon_gk.PriceListId = inPriceListId_2
                                                                              AND PriceList2_bon_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceList2_bon_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                              AND PriceList2_bon_gk.Price <> 0
                                                                              AND inEndDate >= PriceList2_bon_gk.StartDate AND inEndDate < PriceList2_bon_gk.EndDate
                                                                              AND lpSelect.isCost = TRUE
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_bon_gk ON PriceList3_bon_gk.PriceListId = inPriceListId_3
                                                                              AND PriceList3_bon_gk.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                              AND PriceList3_bon_gk.GoodsKindId = ObjectLink_Receipt_GoodsKind.ChildObjectId
                                                                              AND PriceList3_bon_gk.Price <> 0
                                                                              AND inEndDate >= PriceList3_bon_gk.StartDate AND inEndDate < PriceList3_bon_gk.EndDate
                                                                              AND lpSelect.isCost = TRUE

               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_bon_gk_b ON PriceList1_bon_gk_b.PriceListId = inPriceListId_1
                                                                                AND PriceList1_bon_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                                AND PriceList1_bon_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                                AND PriceList1_bon_gk_b.Price <> 0
                                                                                AND inEndDate >= PriceList1_bon_gk_b.StartDate AND inEndDate < PriceList1_bon_gk_b.EndDate
                                                                                AND lpSelect.isCost = TRUE
                                                                                AND PriceList1_bon_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_bon_gk_b ON PriceList2_bon_gk_b.PriceListId = inPriceListId_2
                                                                                AND PriceList2_bon_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                                AND PriceList2_bon_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                                AND PriceList2_bon_gk_b.Price <> 0
                                                                                AND inEndDate >= PriceList2_bon_gk_b.StartDate AND inEndDate < PriceList2_bon_gk_b.EndDate
                                                                                AND lpSelect.isCost = TRUE
                                                                                AND PriceList2_bon_gk_b.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_bon_gk_b ON PriceList3_bon_gk_b.PriceListId = inPriceListId_3
                                                                                AND PriceList3_bon_gk_b.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                                AND PriceList3_bon_gk_b.GoodsKindId = zc_GoodsKind_Basis()
                                                                                AND PriceList3_bon_gk_b.Price <> 0
                                                                                AND inEndDate >= PriceList3_bon_gk_b.StartDate AND inEndDate < PriceList3_bon_gk_b.EndDate
                                                                                AND lpSelect.isCost = TRUE
                                                                                AND PriceList3_bon_gk_b.GoodsId IS NULL

               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_bon ON PriceList1_bon.PriceListId = inPriceListId_1
                                                                           AND PriceList1_bon.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                           AND PriceList1_bon.GoodsKindId = 0
                                                                           AND PriceList1_bon.Price <> 0
                                                                           AND inEndDate >= PriceList1_bon.StartDate AND inEndDate < PriceList1_bon.EndDate
                                                                           AND lpSelect.isCost = TRUE
                                                                           AND PriceList1_bon_gk_b.GoodsId IS NULL
                                                                           AND PriceList1_bon_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_bon ON PriceList2_bon.PriceListId = inPriceListId_2
                                                                           AND PriceList2_bon.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                           AND PriceList2_bon.GoodsKindId = 0
                                                                           AND PriceList2_bon.Price <> 0
                                                                           AND inEndDate >= PriceList2_bon.StartDate AND inEndDate < PriceList2_bon.EndDate
                                                                           AND lpSelect.isCost = TRUE
                                                                           AND PriceList2_bon_gk_b.GoodsId IS NULL
                                                                           AND PriceList2_bon_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_bon ON PriceList3_bon.PriceListId = inPriceListId_3
                                                                           AND PriceList3_bon.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                                           AND PriceList3_bon.GoodsKindId = 0
                                                                           AND PriceList3_bon.Price <> 0
                                                                           AND inEndDate >= PriceList3_bon.StartDate AND inEndDate < PriceList3_bon.EndDate
                                                                           AND lpSelect.isCost = TRUE
                                                                           AND PriceList3_bon_gk_b.GoodsId IS NULL
                                                                           AND PriceList3_bon_gk.GoodsId IS NULL

               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_gk ON PriceList1_gk.PriceListId = inPriceListId_1
                                                                          AND PriceList1_gk.GoodsId     = lpSelect.GoodsId_out
                                                                          AND PriceList1_gk.GoodsKindId = lpSelect.GoodsKindId_out
                                                                          AND PriceList1_gk.Price <> 0
                                                                          AND inEndDate >= PriceList1_gk.StartDate AND inEndDate < PriceList1_gk.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2_gk ON PriceList2_gk.PriceListId = inPriceListId_2
                                                                          AND PriceList2_gk.GoodsId     = lpSelect.GoodsId_out
                                                                          AND PriceList2_gk.GoodsKindId = lpSelect.GoodsKindId_out
                                                                          AND PriceList2_gk.Price <> 0
                                                                          AND inEndDate >= PriceList2_gk.StartDate AND inEndDate < PriceList2_gk.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_gk ON PriceList3_gk.PriceListId = inPriceListId_3
                                                                          AND PriceList3_gk.GoodsId     = lpSelect.GoodsId_out
                                                                          AND PriceList3_gk.GoodsKindId = lpSelect.GoodsKindId_out
                                                                          AND PriceList3_gk.Price <> 0
                                                                          AND inEndDate >= PriceList3_gk.StartDate AND inEndDate < PriceList3_gk.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList4_gk ON PriceList4_gk.PriceListId = inPriceListId_sale
                                                                          AND PriceList4_gk.GoodsId     = lpSelect.GoodsId_out
                                                                          AND PriceList4_gk.GoodsKindId = lpSelect.GoodsKindId_out
                                                                          AND PriceList4_gk.Price <> 0
                                                                          AND inEndDate >= PriceList4_gk.StartDate AND inEndDate < PriceList4_gk.EndDate

               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = inPriceListId_1
                                                                       AND PriceList1.GoodsId     = lpSelect.GoodsId_out
                                                                       AND PriceList1.GoodsKindId = 0
                                                                       AND PriceList1.Price <> 0
                                                                       AND inEndDate >= PriceList1.StartDate AND inEndDate < PriceList1.EndDate
                                                                       AND PriceList1_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2 ON PriceList2.PriceListId = inPriceListId_2
                                                                       AND PriceList2.GoodsId     = lpSelect.GoodsId_out
                                                                       AND PriceList2.GoodsKindId = 0
                                                                       AND PriceList2.Price <> 0
                                                                       AND inEndDate >= PriceList2.StartDate AND inEndDate < PriceList2.EndDate
                                                                       AND PriceList2_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = inPriceListId_3
                                                                       AND PriceList3.GoodsId     = lpSelect.GoodsId_out
                                                                       AND PriceList3.GoodsKindId = 0
                                                                       AND PriceList3.Price <> 0
                                                                       AND inEndDate >= PriceList3.StartDate AND inEndDate < PriceList3.EndDate
                                                                       AND PriceList3_gk.GoodsId IS NULL
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList4 ON PriceList4.PriceListId = inPriceListId_sale
                                                                       AND PriceList4.GoodsId     = lpSelect.GoodsId_out
                                                                       AND PriceList4.GoodsKindId = 0
                                                                       AND PriceList4.Price <> 0
                                                                       AND inEndDate >= PriceList4.StartDate AND inEndDate < PriceList4.EndDate
                                                                       AND PriceList4_gk.GoodsId IS NULL
         ;


     -- Результат
     OPEN Cursor1 FOR
     WITH tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                          FROM Constant_ProfitLoss_AnalyzerId_View
                          WHERE DescId = zc_Object_AnalyzerId()
                         )
        /*, tmpAccount AS (SELECT Object_Account_View.AccountGroupId, Object_Account_View.AccountId
                         FROM Object_Account_View
                         WHERE Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_60000()  -- Прибыль будущих периодов
                                                                    , zc_Enum_AccountGroup_110000() -- Транзит
                                                                     )*/
                        /*UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummIn_110101() AS AccountId -- Сумма, забалансовый счет, приход транзит, хотя поле пишется в AccountId, при этом ContainerId - стандартный и в нем другой AccountId
                        UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummOut_110101() AS AccountId -- Сумма, забалансовый счет, расходтранзит, хотя поле пишется в AccountId, при этом ContainerId - стандартный и в нем другой AccountId
                        */
                       /*)*/

        --выбираем контагентов ограничиваем входными параметрами
        , tmpJuridical AS (SELECT Object_Juridical.Id AS JuridicalId
                           FROM Object AS Object_Juridical
                           WHERE Object_Juridical.DescId = zc_Object_Juridical()
                             AND ((Object_Juridical.Id = inJuridicalId AND inisExclude = FALSE) OR inJuridicalId = 0)
                         UNION
                           SELECT Object_Juridical.Id AS JuridicalId
                           FROM Object AS Object_Juridical
                           WHERE Object_Juridical.DescId = zc_Object_Juridical()
                             AND (Object_Juridical.Id <> inJuridicalId AND inJuridicalId <> 0)
                             AND inisExclude = TRUE
                          )

        , tmpMIContainer AS
           (SELECT tmpContainer.GoodsId
                 , tmpContainer.GoodsKindId

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale()
                                  THEN tmpContainer.OperCountPartner
                             WHEN tmpContainer.MovementDescId = zc_Movement_Sale()
                                  THEN tmpContainer.OperCount
                                     - tmpContainer.OperCount_Change
                                     + tmpContainer.OperCount_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS OperCount_sale

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale()
                                  THEN tmpContainer.SummInPartner
                             WHEN tmpContainer.MovementDescId = zc_Movement_Sale()
                                  THEN tmpContainer.SummIn
                                     - tmpContainer.SummIn_Change
                                     + tmpContainer.SummIn_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS SummIn_sale

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() THEN tmpContainer.SummOut_PriceList ELSE 0 END
                       ) AS SummOut_PriceList_sale

                 , SUM (CASE WHEN tmpContainer.MovementDescId <> zc_Movement_ReturnIn() THEN tmpContainer.SummOut_Partner ELSE 0 END
                       ) AS SummOut_sale



                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn()
                                  THEN tmpContainer.OperCountPartner
                             WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn()
                                  THEN tmpContainer.OperCount
                                     - tmpContainer.OperCount_Change
                                     - tmpContainer.OperCount_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS OperCount_return

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn()
                                  THEN tmpContainer.SummInPartner
                             WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn()
                                  THEN tmpContainer.SummIn
                                     - tmpContainer.SummIn_Change
                                     - tmpContainer.SummIn_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS SummIn_return


                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() THEN tmpContainer.SummOut_PriceList ELSE 0 END
                       ) AS SummOut_PriceList_return

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() THEN tmpContainer.SummOut_Partner ELSE 0 END
                       ) AS SummOut_return

            FROM
           (SELECT MIContainer.ObjectId_Analyzer       AS GoodsId
                 , CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer, 0) = 0 THEN zc_GoodsKind_Basis() ELSE MIContainer.ObjectIntId_analyzer END AS GoodsKindId
                 -- , MIContainer.isActive
                 , MIContainer.MovementDescId
                 -- , COALESCE (MIContainer.AccountId, 0) AS AccountId

                        -- 1.1. Кол-во, без AnalyzerId
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCountPartner
                        -- 1.2. Себестоимость, без AnalyzerId
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                   -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_SaleSumm_10500(), zc_Enum_AnalyzerId_SaleSumm_40200())
                                       THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                   -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ReturnInSumm_40200()
                                       THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()
                                       THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800()
                                       THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummInPartner

                        -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND tmpAnalyzer.isLoss = FALSE THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND tmpAnalyzer.isLoss = FALSE THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_Partner

                        -- 2.1. Кол-во - Скидка за вес
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Change
                        -- 2.2. Себестоимость - Скидка за вес
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Change

                        -- 3.1. Кол-во Разница в весе
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN 1 * MIContainer.Amount  -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN 1 * MIContainer.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                  ELSE 0
                             END) AS OperCount_40200
                        -- 3.2. Себестоимость - Разница в весе
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN 1 * MIContainer.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                  ELSE 0
                             END) AS SummIn_40200


                        -- 5.3.1. Сумма у покупателя По прайсу
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_PriceList
            FROM tmpAnalyzer
                 INNER JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                 --ограничения по юр.лицам
                 LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                               ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_analyzer
                                              AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                 INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = ContainerLO_Juridical.ObjectId

                 -- LEFT JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                 LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer




            WHERE (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
              -- AND (_tmpUnit.UnitId > 0 OR COALESCE (inUnitId_sale, 0) = 0 OR COALESCE (inUnitId_return, 0) = 0)
            GROUP BY MIContainer.ObjectId_Analyzer
                   , MIContainer.ObjectIntId_analyzer
                   -- , MIContainer.isActive
                   , MIContainer.MovementDescId
                   -- , MIContainer.AccountId
           ) AS tmpContainer
           -- LEFT JOIN tmpAccount ON tmpAccount.AccountId = tmpContainer.AccountId
           GROUP BY tmpContainer.GoodsId
                  , tmpContainer.GoodsKindId
           )


        , tmpReceipt AS (SELECT tmp.GoodsId, tmp.GoodsKindId, MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                         FROM (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId FROM tmpMIContainer GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                              ) AS tmp
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ChildObjectId = tmp.GoodsId
                                                   AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                   ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                         WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmp.GoodsKindId
                         GROUP BY tmp.GoodsId, tmp.GoodsKindId
                        )
        , tmpAll AS
           (SELECT COALESCE (tmpReceipt.ReceiptId, 0) AS ReceiptId
                 , 0 AS GoodsId_isCost
                 , tmpMIContainer.GoodsId
                 , tmpMIContainer.GoodsKindId
                 , SUM (tmpMIContainer.OperCount_sale)         AS OperCount_sale
                 , SUM (tmpMIContainer.SummIn_sale)            AS SummIn_sale
                 , SUM (tmpMIContainer.SummOut_PriceList_sale) AS SummOut_PriceList_sale
                 , SUM (tmpMIContainer.SummOut_sale)           AS SummOut_sale

                 , SUM (tmpMIContainer.OperCount_return)         AS OperCount_return
                 , SUM (tmpMIContainer.SummIn_return)            AS SummIn_return
                 , SUM (tmpMIContainer.SummOut_PriceList_return) AS SummOut_PriceList_return
                 , SUM (tmpMIContainer.SummOut_return)           AS SummOut_return

                 , 0 AS Summ1
                 , 0 AS Summ2
                 , 0 AS Summ3

                 , 0 AS Summ1_cost
                 , 0 AS Summ2_cost
                 , 0 AS Summ3_cost
                 , 0 AS Summ4_cost

                 , 0 AS Summ1_bon
                 , 0 AS Summ2_bon
                 , 0 AS Summ3_bon

                 , 0 AS Summ_pl

                 , 0 AS Koeff1_bon
                 , 0 AS Koeff2_bon
                 , 0 AS Koeff3_bon

            FROM tmpMIContainer
                 LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMIContainer.GoodsId
                                     AND tmpReceipt.GoodsKindId = tmpMIContainer.GoodsKindId
            GROUP BY COALESCE (tmpReceipt.ReceiptId, 0)
                   , tmpMIContainer.GoodsId
                   , tmpMIContainer.GoodsKindId

           UNION ALL
            SELECT tmp.ReceiptId
                 , MAX (tmp.GoodsId_isCost) AS GoodsId_isCost
                 , tmpMI.GoodsId
                 , tmpMI.GoodsKindId
                 , 0 AS OperCount_sale
                 , 0 AS SummIn_sale
                 , 0 AS SummOut_PriceList_sale
                 , 0 AS SummOut_sale
                 , 0 AS OperCount_return
                 , 0 AS SummIn_return
                 , 0 AS SummOut_PriceList_return
                 , 0 AS SummOut_return

                 , SUM (tmp.Summ1) AS Summ1
                 , SUM (tmp.Summ2) AS Summ2
                 , SUM (tmp.Summ3) AS Summ3

                 , SUM (tmp.Summ1_cost) AS Summ1_cost
                 , SUM (tmp.Summ2_cost) AS Summ2_cost
                 , SUM (tmp.Summ3_cost) AS Summ3_cost
                 , SUM (tmp.Summ4_cost) AS Summ4_cost

                 , SUM (tmp.Summ1_bon) AS Summ1_bon
                 , SUM (tmp.Summ2_bon) AS Summ2_bon
                 , SUM (tmp.Summ3_bon) AS Summ3_bon

                 , SUM (tmp.Summ_pl) AS Summ_pl

                 , MAX (tmp.Koeff1_bon) AS Koeff1_bon
                 , MAX (tmp.Koeff2_bon) AS Koeff2_bon
                 , MAX (tmp.Koeff3_bon) AS Koeff3_bon

            FROM (SELECT tmpChildReceiptTable.ReceiptId
                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.GoodsId_out ELSE 0 END) AS GoodsId_isCost
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1) AS Summ1
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2) AS Summ2
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3

                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1 ELSE 0 END) AS Summ1_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2 ELSE 0 END) AS Summ2_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price4 ELSE 0 END) AS Summ4_cost
                       
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1_bon ELSE 0 END) AS Summ1_bon
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2_bon ELSE 0 END) AS Summ2_bon
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3_bon ELSE 0 END) AS Summ3_bon

                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Koeff1_bon ELSE 0 END) AS Koeff1_bon
                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Koeff2_bon ELSE 0 END) AS Koeff2_bon
                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Koeff3_bon ELSE 0 END) AS Koeff3_bon

                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price_pl ELSE 0 END) AS Summ_pl

                  FROM tmpChildReceiptTable
                  WHERE tmpChildReceiptTable.ReceiptId_from = 0
                  GROUP BY  tmpChildReceiptTable.ReceiptId
                 ) AS tmp
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                      ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                      ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                 INNER JOIN (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId FROM tmpMIContainer WHERE tmpMIContainer.OperCount_sale <> 0 OR tmpMIContainer.OperCount_return <> 0 GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                            ) AS tmpMI ON tmpMI.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                      AND tmpMI.GoodsKindId = COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
            GROUP BY tmp.ReceiptId
                   , tmpMI.GoodsId
                   , tmpMI.GoodsKindId
           )

        , tmpResult AS
           (SELECT CASE WHEN inIsGoodsKind = TRUE THEN tmpAll.ReceiptId ELSE tmpAll.GoodsId END AS ReceiptId
                 , MAX (tmpAll.GoodsId_isCost)                                                  AS GoodsId_isCost
                 , tmpAll.GoodsId
                 , tmpAll.GoodsKindId
                 , CASE WHEN SUM (COALESCE (ObjectFloat_Value.ValueData, 0)) = 0 THEN NULL ELSE SUM (COALESCE (ObjectFloat_Value.ValueData, 0)) END :: TFloat AS Value_receipt
                 , SUM (tmpAll.OperCount_sale)         AS OperCount_sale
                 , SUM (tmpAll.SummIn_sale)            AS SummIn_sale
                 , SUM (tmpAll.SummOut_PriceList_sale) AS SummOut_PriceList_sale
                 , SUM (tmpAll.SummOut_sale)           AS SummOut_sale
                 , SUM (tmpAll.OperCount_return)         AS OperCount_return
                 , SUM (tmpAll.SummIn_return)            AS SummIn_return
                 , SUM (tmpAll.SummOut_PriceList_return) AS SummOut_PriceList_return
                 , SUM (tmpAll.SummOut_return)           AS SummOut_return
                 , SUM (tmpAll.Summ1)      AS Summ1
                 , SUM (tmpAll.Summ2)      AS Summ2
                 , SUM (tmpAll.Summ3)      AS Summ3
                 , SUM (tmpAll.Summ1_cost) AS Summ1_cost
                 , SUM (tmpAll.Summ2_cost) AS Summ2_cost
                 , SUM (tmpAll.Summ3_cost) AS Summ3_cost
                 , SUM (tmpAll.Summ4_cost) AS Summ4_cost

                 , SUM (tmpAll.Summ1_bon) AS Summ1_bon
                   -- ??? 1 или 2 ???
                 , SUM (tmpAll.Summ1_bon) AS Summ2_bon
                   -- ??? 1 или 3 ???
                 , SUM (tmpAll.Summ1_bon) AS Summ3_bon

                 , SUM (tmpAll.Summ_pl)   AS Summ_pl

                 , MAX (tmpAll.Koeff1_bon) AS Koeff1_bon
                 , MAX (tmpAll.Koeff2_bon) AS Koeff2_bon
                 , MAX (tmpAll.Koeff3_bon) AS Koeff3_bon

                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ1 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm1
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ2 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm2
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm3
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ1_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm1_cost
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ2_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm2_cost
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm3_cost
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ4_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm4_cost

                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ1_bon / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm1_bon
                   -- ??? 1 или 2???
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ1_bon / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm2_bon
                   -- ??? 1 или 3 ???
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ1_bon / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm3_bon

                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ_pl / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm_pl

            FROM
           (SELECT tmpAll.ReceiptId
                 , MAX (tmpAll.GoodsId_isCost) AS GoodsId_isCost
                 , tmpAll.GoodsId
                 , CASE WHEN inIsGoodsKind = TRUE THEN tmpAll.GoodsKindId ELSE 0 END AS GoodsKindId
                 , SUM (tmpAll.OperCount_sale)         AS OperCount_sale
                 , SUM (tmpAll.SummIn_sale)            AS SummIn_sale
                 , SUM (tmpAll.SummOut_PriceList_sale) AS SummOut_PriceList_sale
                 , SUM (tmpAll.SummOut_sale)           AS SummOut_sale
                 , SUM (tmpAll.OperCount_return)         AS OperCount_return
                 , SUM (tmpAll.SummIn_return)            AS SummIn_return
                 , SUM (tmpAll.SummOut_PriceList_return) AS SummOut_PriceList_return
                 , SUM (tmpAll.SummOut_return)           AS SummOut_return
                 , SUM (tmpAll.Summ1)      AS Summ1
                 , SUM (tmpAll.Summ2)      AS Summ2
                 , SUM (tmpAll.Summ3)      AS Summ3
                 , SUM (tmpAll.Summ1_cost) AS Summ1_cost
                 , SUM (tmpAll.Summ2_cost) AS Summ2_cost
                 , SUM (tmpAll.Summ3_cost) AS Summ3_cost
                 , SUM (tmpAll.Summ4_cost) AS Summ4_cost

                 , SUM (tmpAll.Summ1_bon)  AS Summ1_bon
                 , SUM (tmpAll.Summ2_bon)  AS Summ2_bon
                 , SUM (tmpAll.Summ3_bon)  AS Summ3_bon
                 , SUM (tmpAll.Summ_pl)    AS Summ_pl

                 , MAX (tmpAll.Koeff1_bon) AS Koeff1_bon
                 , MAX (tmpAll.Koeff2_bon) AS Koeff2_bon
                 , MAX (tmpAll.Koeff3_bon) AS Koeff3_bon

            FROM tmpAll
            GROUP BY tmpAll.ReceiptId
                   , tmpAll.GoodsId
                   , CASE WHEN inIsGoodsKind = TRUE THEN tmpAll.GoodsKindId ELSE 0 END
            HAVING 0 <> SUM (tmpAll.OperCount_sale)
                OR 0 <> SUM (tmpAll.SummIn_sale)
                OR 0 <> SUM (tmpAll.SummOut_PriceList_sale)
                OR 0 <> SUM (tmpAll.SummOut_sale)
                OR 0 <> SUM (tmpAll.OperCount_return)
                OR 0 <> SUM (tmpAll.SummIn_return)
                OR 0 <> SUM (tmpAll.SummOut_PriceList_return)
                OR 0 <> SUM (tmpAll.SummOut_return)
           ) AS tmpAll
            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                  ON ObjectFloat_Value.ObjectId = tmpAll.ReceiptId
                                 AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()
            GROUP BY CASE WHEN inIsGoodsKind = TRUE THEN tmpAll.ReceiptId ELSE tmpAll.GoodsId END
                   , tmpAll.GoodsId
                   , tmpAll.GoodsKindId
           )
        , tmpPrice_10100 AS
           (SELECT COALESCE (PriceList1.Price, 0) AS Price1,  COALESCE (PriceList2.Price, 0) AS Price2, COALESCE(PriceList3.Price, 0) AS Price3
            FROM Object
                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = inPriceListId_1
                                                                          AND PriceList1.GoodsId = Object.Id
                                                                          AND inEndDate >= PriceList1.StartDate AND inEndDate < PriceList1.EndDate
                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2 ON PriceList2.PriceListId = inPriceListId_2
                                                                          AND PriceList2.GoodsId = Object.Id
                                                                          AND inEndDate >= PriceList2.StartDate AND inEndDate < PriceList2.EndDate
                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = inPriceListId_3
                                                                          AND PriceList3.GoodsId = Object.Id
                                                                          AND inEndDate >= PriceList3.StartDate AND inEndDate < PriceList3.EndDate
            WHERE Object.Id = 2167 -- (94134) РАСХОДЫ ЦЕХА Мясо
            LIMIT 1
           )
          -- Товары ГП, если в рецептуре указаны расходы = (94133) РАСХОДІ ИРНА
        , tmpGoods_20900 AS
           (SELECT DISTINCT
                   COALESCE (ObjectLink_Receipt_Goods.ChildObjectId, 0)     AS GoodsId
               --, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) AS GoodsKindId
            FROM ObjectLink AS ObjectLink_Receipt_ReceiptCost
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                       ON ObjectLink_Receipt_Goods.ObjectId = ObjectLink_Receipt_ReceiptCost.ObjectId
                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_ReceiptCost.ObjectId
                                                    AND Object_Receipt.isErased = FALSE
                 INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                          ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                         AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                         AND ObjectBoolean_Main.ValueData = TRUE
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                      ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                     AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
            WHERE ObjectLink_Receipt_ReceiptCost.ChildObjectId = 487092 -- (94133) РАСХОДІ ИРНА
              AND ObjectLink_Receipt_ReceiptCost.DescId        = zc_ObjectLink_Receipt_ReceiptCost()
              AND 1=0
           )
        , tmpPrice_20900 AS
           (SELECT COALESCE (PriceList1.Price, 0) AS Price1,  COALESCE (PriceList2.Price, 0) AS Price2, COALESCE(PriceList3.Price, 0) AS Price3
            FROM Object
                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = inPriceListId_1
                                                                          AND PriceList1.GoodsId = Object.Id
                                                                          AND inEndDate >= PriceList1.StartDate AND inEndDate < PriceList1.EndDate
                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2 ON PriceList2.PriceListId = inPriceListId_2
                                                                          AND PriceList2.GoodsId = Object.Id
                                                                          AND inEndDate >= PriceList2.StartDate AND inEndDate < PriceList2.EndDate
                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = inPriceListId_3
                                                                          AND PriceList3.GoodsId = Object.Id
                                                                          AND inEndDate >= PriceList3.StartDate AND inEndDate < PriceList3.EndDate
            WHERE Object.Id = 487092 -- (94133) РАСХОДІ ИРНА
            LIMIT 1
           )
      -- Результат
      SELECT tmpResult.ReceiptId
           , Object_Receipt.ObjectCode      AS Code
           , ObjectString_Code.ValueData    AS ReceiptCode
           , ObjectString_Comment.ValueData AS Comment

           , tmpResult.Value_receipt             AS Amount
           , (tmpResult.Value_receipt * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS Amount_Weight
           , ObjectFloat_TaxExit.ValueData       AS TaxExit
           , ObjectFloat_TaxLoss.ValueData       AS TaxLoss
           , ObjectBoolean_Main.ValueData        AS isMain

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
           , Object_GoodsTag.ValueData                   AS GoodsTagName
           , Object_TradeMark.ValueData                  AS TradeMarkName
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_Measure.ValueData                    AS MeasureName

           , Object_Goods_isCost.ObjectCode              AS GoodsCode_isCost
           , Object_Goods_isCost.ValueData               AS GoodsName_isCost

           , Object_Receipt_Parent.ObjectCode            AS Code_Parent
           , ObjectString_Code_Parent.ValueData          AS ReceiptCode_Parent
           , ObjectBoolean_Main_Parent.ValueData         AS isMain_Parent
           , Object_Goods_Parent.ObjectCode              AS GoodsCode_Parent
           , Object_Goods_Parent.ValueData               AS GoodsName_Parent
           , Object_Measure_Parent.ValueData             AS MeasureName_Parent
           , Object_GoodsKind_Parent.ValueData           AS GoodsKindName_Parent
           , Object_GoodsKindComplete_Parent.ValueData   AS GoodsKindCompleteName_Parent

             -- Price1
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price1, 0)
                        WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR*/ tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                + COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                        WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm1 / tmpResult.OperCount_sale
                                  -- добавили бонусы
                                + tmpResult.newSumm1_bon / tmpResult.OperCount_sale

                        ELSE tmpResult.Summ1 / tmpResult.Value_receipt
                             -- добавили бонусы
                           + tmpResult.Summ1_bon / tmpResult.Value_receipt

                   END AS NUMERIC (16, 3)) AS Price1

             -- Price2
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price2, 0)
                        WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR*/ tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                + COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                        WHEN tmpResult.newSumm2 <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm2 / tmpResult.OperCount_sale
                                  -- добавили бонусы
                                + tmpResult.newSumm2_bon / tmpResult.OperCount_sale

                        ELSE tmpResult.Summ2 / tmpResult.Value_receipt
                             -- добавили бонусы
                           + tmpResult.Summ2_bon / tmpResult.Value_receipt

                   END AS NUMERIC (16, 3)) AS Price2

             -- Price3
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price3, 0)
                        WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR*/ tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                + COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                        WHEN tmpResult.newSumm3 <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm3 / tmpResult.OperCount_sale
                                  -- добавили бонусы
                                + tmpResult.newSumm3_bon / tmpResult.OperCount_sale

                        ELSE tmpResult.Summ3 / tmpResult.Value_receipt
                             -- добавили бонусы
                           + tmpResult.Summ3_bon / tmpResult.Value_receipt

                   END AS NUMERIC (16, 3)) AS Price3

             -- Price1_cost
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price1, 0)

                    /*WHEN (View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                        OR tmpGoods_20900.GoodsId > 0) and vbUserId = 5
                         --THEN COALESCE (tmpPrice_20900.Price1, 0)
                           THEN tmpResult.SummOut_sale*/

                        WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR*/ tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                        WHEN tmpResult.newSumm1_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm1_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ1_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price1_cost

             -- Price2_cost
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price2, 0)

                      /*WHEN (View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR tmpGoods_20900.GoodsId > 0) and vbUserId = 5
                           --THEN COALESCE (tmpPrice_20900.Price1, 0)
                             THEN tmpResult.OperCount_sale*/

                        WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR*/ tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm2_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ2_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price2_cost

             -- Price3_cost
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price3, 0)
                        WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR*/ tmpGoods_20900.GoodsId > 0
                              THEN COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm3_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm3_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ3_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price3_cost

             -- Price4_cost
           , CAST (CASE WHEN tmpResult.newSumm4_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm4_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ4_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price4_cost
             --
           , (COALESCE (PriceList5_gk.Price, PriceList5.Price) * 1.2) :: TFloat AS Price5_cost
           , (COALESCE (PriceList6_gk.Price, PriceList6.Price) * 1.2) :: TFloat AS Price6_cost

             -- Price_sale
           , (COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2) :: TFloat AS Price_sale -- !!!захардкодил временно!!!

             -- с/с реализ по план1
           , CASE WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100()/*, zc_Enum_InfoMoneyDestination_20900()*/)
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm1
                            -- добавили бонусы
                          + tmpResult.newSumm1_bon
                  ELSE
             tmpResult.OperCount_sale * CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price1, 0)
                                                   WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                     OR*/ tmpGoods_20900.GoodsId > 0
                                                        THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                                           + COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                                                   ELSE tmpResult.Summ1 / tmpResult.Value_receipt
                                                        -- добавили бонусы
                                                      + tmpResult.Summ1_bon / tmpResult.Value_receipt

                                              END AS NUMERIC (16, 3)) END AS SummPrice1_sale

             -- с/с реализ по план2
           , CASE WHEN tmpResult.newSumm2 <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100()/*, zc_Enum_InfoMoneyDestination_20900()*/)
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm2
                            -- добавили бонусы
                          + tmpResult.newSumm2_bon
                  ELSE
             tmpResult.OperCount_sale * CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price2, 0)
                                                   WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                     OR*/ tmpGoods_20900.GoodsId > 0
                                                        THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                                           + COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                                                   ELSE tmpResult.Summ2 / tmpResult.Value_receipt
                                                        -- добавили бонусы
                                                      + tmpResult.Summ2_bon / tmpResult.Value_receipt

                                              END AS NUMERIC (16, 3)) END AS SummPrice2_sale

             -- с/с реализ по план3
           , CASE WHEN tmpResult.newSumm3 <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100()/*, zc_Enum_InfoMoneyDestination_20900()*/)
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm3
                            -- добавили бонусы
                          + tmpResult.newSumm3_bon
                  ELSE
             tmpResult.OperCount_sale * CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price3, 0)
                                                   WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                     OR*/ tmpGoods_20900.GoodsId > 0
                                                        THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                                           + COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                                                   ELSE tmpResult.Summ3 / tmpResult.Value_receipt
                                                        -- добавили бонусы
                                                      + tmpResult.Summ3_bon / tmpResult.Value_receipt

                                              END AS NUMERIC (16, 3)) END AS SummPrice3_sale

           , (tmpResult.OperCount_sale * COALESCE (PriceList5_gk.Price, PriceList5.Price) * 1.2) :: TFloat AS SummCost5_sale -- сумма по прайсу 5
           , (tmpResult.OperCount_sale * COALESCE (PriceList6_gk.Price, PriceList6.Price) * 1.2) :: TFloat AS SummCost6_sale -- сумма по прайсу 6

             -- сумма по прайсу расчетному
           , (tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2) :: TFloat AS Summ_sale

             -- сумма затрат на реализ по план1
           , CASE WHEN tmpResult.newSumm1_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100()/*, zc_Enum_InfoMoneyDestination_20900()*/)
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm1_cost
                  ELSE
             tmpResult.OperCount_sale * CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price1, 0)
                                             WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                               OR*/ tmpGoods_20900.GoodsId > 0
                                                  THEN COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                             ELSE CAST (tmpResult.Summ1_cost / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                        END END AS SummCost1_sale

             -- сумма затрат на реализ по план3
           , CASE WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100()/*, zc_Enum_InfoMoneyDestination_20900()*/)
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm2_cost
                  ELSE
             tmpResult.OperCount_sale * CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price2, 0)
                                             WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                               OR*/ tmpGoods_20900.GoodsId > 0
                                                  THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                             ELSE CAST (tmpResult.Summ2_cost / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                        END END AS SummCost2_sale

             -- сумма затрат на реализ по план3
           , CASE WHEN tmpResult.newSumm3_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100()/*, zc_Enum_InfoMoneyDestination_20900()*/)
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm3_cost
                  ELSE
             tmpResult.OperCount_sale * CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price3, 0)
                                             WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                               OR*/ tmpGoods_20900.GoodsId > 0
                                                  THEN COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                             ELSE CAST (tmpResult.Summ3_cost / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                        END END AS SummCost3_sale

             -- сумма затрат на реализ по план4
           , CASE WHEN tmpResult.newSumm4_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100()/*, zc_Enum_InfoMoneyDestination_20900()*/)
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm4_cost
                  ELSE
             tmpResult.OperCount_sale * CAST (tmpResult.Summ4_cost / tmpResult.Value_receipt AS NUMERIC (16, 3)) END AS SummCost4_sale

           , CASE WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                    OR*/ tmpGoods_20900.GoodsId > 0
                       THEN 100 - 100 / 1
                                * 0.85
                          -- -100
                  WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                       THEN 100 - 100 / (tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2)
                                * (tmpResult.newSumm1
                                   -- добавили бонусы
                                 + tmpResult.newSumm1_bon
                                  )
                          -- -100
                  WHEN (tmpResult.OperCount_sale * tmpResult.Summ1 / tmpResult.Value_receipt) <> 0
                       THEN 100 - 100 / (tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2)
                                * (tmpResult.OperCount_sale * (CAST (tmpResult.Summ1 / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                                               -- добавили бонусы
                                                             + CAST (tmpResult.Summ1_bon / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                                              )
                                  )
                          -- -100
                       ELSE 0
             END AS Tax_Summ_sale -- % рент. для план1 / сумма по прайсу расчетному

           , CASE WHEN (/*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                     OR*/ tmpGoods_20900.GoodsId > 0)
                   AND tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) <> 0
                       THEN 100 - 100 / tmpResult.SummOut_sale
                                * (tmpResult.OperCount_sale * CAST (COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85 AS NUMERIC (16, 3)))
                          -- - 100

                  WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                       THEN 100 - 100 / tmpResult.SummOut_sale
                                * (tmpResult.newSumm1
                                   -- добавили бонусы
                                 + tmpResult.newSumm1_bon
                                  )
                          -- - 100
                  WHEN (tmpResult.OperCount_sale * tmpResult.Summ1 / tmpResult.Value_receipt) <> 0
                       THEN 100 - 100 / tmpResult.SummOut_sale
                                * (tmpResult.OperCount_sale * (CAST (tmpResult.Summ1 / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                                               -- добавили бонусы
                                                             + CAST (tmpResult.Summ1_bon / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                                              )
                                  )
                          -- -100
                       ELSE 0
             END AS Tax_SummOut_sale -- % рент. для план1 / сумма реализ факт

           , CASE WHEN tmpResult.OperCount_sale <> 0
                       THEN 100 * tmpResult.OperCount_return / tmpResult.OperCount_sale
                       ELSE 0
             END AS Tax_return -- % возврата

           , tmpResult.OperCount_sale AS OperCount_sale
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpResult.OperCount_sale ELSE 0 END AS OperCount_sh_sale
           , tmpResult.OperCount_sale * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_Weight_sale
           , tmpResult.SummIn_sale AS SummIn_sale
           , CAST (CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummIn_sale / tmpResult.OperCount_sale ELSE 0 END AS NUMERIC (16, 3)) AS Price_in_sale
           , tmpResult.SummOut_PriceList_sale AS SummOut_PriceList_sale
           , CAST (CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_PriceList_sale / tmpResult.OperCount_sale ELSE 0 END AS NUMERIC (16, 3)) AS Price_out_pl_sale
           , tmpResult.SummOut_sale AS SummOut_sale
           , CAST (CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END AS NUMERIC (16, 3)) AS Price_out_sale

           , tmpResult.OperCount_return AS OperCount_return
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpResult.OperCount_return ELSE 0 END AS OperCount_sh_return
           , tmpResult.OperCount_return * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_Weight_return
           , tmpResult.SummIn_return AS SummIn_return
           , CAST (CASE WHEN tmpResult.OperCount_return <> 0 THEN tmpResult.SummIn_return / tmpResult.OperCount_return ELSE 0 END AS NUMERIC (16, 3)) AS Price_in_return
           , tmpResult.SummOut_PriceList_return AS SummOut_PriceList_return
           , CAST (CASE WHEN tmpResult.OperCount_return <> 0 THEN tmpResult.SummOut_PriceList_return / tmpResult.OperCount_return ELSE 0 END AS NUMERIC (16, 3)) AS Price_out_pl_return
           , tmpResult.SummOut_return AS SummOut_return
           , CAST (CASE WHEN tmpResult.OperCount_return <> 0 THEN tmpResult.SummOut_return / tmpResult.OperCount_return ELSE 0 END AS NUMERIC (16, 3)) AS Price_out_return

             -- чистая прибыль
           , CAST ((tmpResult.OperCount_sale * ((CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END)
                                                - ( (CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummIn_sale / tmpResult.OperCount_sale ELSE 0 END)
                                                    -- плюс затраты
                                                  + CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                              THEN COALESCE (tmpPrice_10100.Price2, 0)
                                                         WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                           OR*/ tmpGoods_20900.GoodsId > 0
                                                              THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                                                         WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                                                              THEN tmpResult.newSumm2_cost / tmpResult.OperCount_sale
                                                                   -- плюс бонусы - ??? 1 или 2 ???
                                                                 + tmpResult.newSumm2_bon / tmpResult.OperCount_sale

                                                         ELSE tmpResult.Summ2_cost / tmpResult.Value_receipt
                                                              -- плюс бонусы - ??? 1 или 2 ???
                                                            + tmpResult.Summ2_bon / tmpResult.Value_receipt
                                                    END
                                                  )
                                                )
                   - tmpResult.SummOut_return ) AS NUMERIC (16, 3) )  AS Profit

             -- если  чистая прибыль отриц. подсвечиваем красным
           , CASE WHEN (tmpResult.OperCount_sale * ((CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END)
                                                   - ( (CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummIn_sale / tmpResult.OperCount_sale ELSE 0 END)
                                                     + CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                 THEN COALESCE (tmpPrice_10100.Price2, 0)
                                                            WHEN /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                               OR*/ tmpGoods_20900.GoodsId > 0
                                                                 THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END

                                                            WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                                                                 THEN tmpResult.newSumm2_cost / tmpResult.OperCount_sale
                                                                      -- плюс бонусы - ??? 1 или 2 ???
                                                                    + tmpResult.newSumm2_bon / tmpResult.OperCount_sale

                                                            ELSE tmpResult.Summ2_cost / tmpResult.Value_receipt
                                                                 -- плюс бонусы - ??? 1 или 2 ???
                                                               + tmpResult.Summ2_bon / tmpResult.Value_receipt
                                                       END
                                                     )
                                                   )
                   - tmpResult.SummOut_return ) < 0 THEN zc_Color_Red() ELSE zc_Color_Black() END AS Color_Profit

           , CASE WHEN Object_Goods.Id <> Object_Goods_Parent.Id THEN TRUE ELSE FALSE END AS isCheck_Parent

           , tmpResult.Koeff1_bon :: TFloat AS Koef1_bon
           , tmpResult.Koeff2_bon :: TFloat AS Koef2_bon
           , tmpResult.Koeff3_bon :: TFloat AS Koef3_bon

           , CAST (tmpResult.Summ1_bon / tmpResult.Value_receipt AS NUMERIC (16, 3)) :: TFloat AS Price1_bon
           , CAST (tmpResult.Summ2_bon / tmpResult.Value_receipt AS NUMERIC (16, 3)) :: TFloat AS Price2_bon
           , CAST (tmpResult.Summ3_bon / tmpResult.Value_receipt AS NUMERIC (16, 3)) :: TFloat AS Price3_bon

             -- сумма бонусы
           , tmpResult.newSumm1_bon :: TFloat AS Summ1_bon
           , tmpResult.newSumm2_bon :: TFloat AS Summ2_bon
           , tmpResult.newSumm3_bon :: TFloat AS Summ3_bon

           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

       FROM tmpResult
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk ON PriceListSale_gk.PriceListId = inPriceListId_sale
                                                                          AND PriceListSale_gk.GoodsId     = tmpResult.GoodsId
                                                                          AND PriceListSale_gk.GoodsKindId = tmpResult.GoodsKindId
                                                                          AND inEndDate >= PriceListSale_gk.StartDate AND inEndDate < PriceListSale_gk.EndDate
                                                                          AND PriceListSale_gk.Price <> 0
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                       AND PriceListSale.GoodsId     = tmpResult.GoodsId
                                                                       AND PriceListSale.GoodsKindId = 0
                                                                       AND inEndDate >= PriceListSale.StartDate AND inEndDate < PriceListSale.EndDate
                                                                       AND PriceListSale.Price <> 0
                                                                       AND PriceListSale_gk.GoodsId IS NULL

            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList5_gk ON PriceList5_gk.PriceListId = inPriceListId_5
                                                                       AND PriceList5_gk.GoodsId     = tmpResult.GoodsId
                                                                       AND PriceList5_gk.GoodsKindId = tmpResult.GoodsKindId
                                                                       AND inEndDate >= PriceList5_gk.StartDate AND inEndDate < PriceList5_gk.EndDate
                                                                       AND PriceList5_gk.Price <> 0
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList5 ON PriceList5.PriceListId = inPriceListId_5
                                                                    AND PriceList5.GoodsId     = tmpResult.GoodsId
                                                                    AND PriceList5.GoodsKindId = 0
                                                                    AND inEndDate >= PriceList5.StartDate AND inEndDate < PriceList5.EndDate
                                                                    AND PriceList5.Price <> 0
                                                                    AND PriceList5_gk.GoodsId IS NULL

            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList6_gk ON PriceList6_gk.PriceListId = inPriceListId_6
                                                                       AND PriceList6_gk.GoodsId     = tmpResult.GoodsId
                                                                       AND PriceList6_gk.GoodsKindId = tmpResult.GoodsKindId
                                                                       AND inEndDate >= PriceList6_gk.StartDate AND inEndDate < PriceList6_gk.EndDate
                                                                       AND PriceList6_gk.Price <> 0
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList6 ON PriceList6.PriceListId = inPriceListId_6
                                                                    AND PriceList6.GoodsId     = tmpResult.GoodsId
                                                                    AND PriceList6.GoodsKindId = 0
                                                                    AND inEndDate >= PriceList6.StartDate AND inEndDate < PriceList6.EndDate
                                                                    AND PriceList6.Price <> 0
                                                                    AND PriceList6_gk.GoodsId IS NULL

            LEFT JOIN Object AS Object_Receipt   ON Object_Receipt.Id   = tmpResult.ReceiptId
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpResult.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId

            LEFT JOIN tmpGoods_20900 ON tmpGoods_20900.GoodsId     = tmpResult.GoodsId
                                  --AND tmpGoods_20900.GoodsKindId = tmpResult.GoodsKindId

            LEFT JOIN Object AS Object_Goods_isCost ON Object_Goods_isCost.Id = tmpResult.GoodsId_isCost

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

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                               ON ObjectLink_Receipt_Parent.ObjectId = tmpResult.ReceiptId
                              AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
          LEFT JOIN Object AS Object_Receipt_Parent ON Object_Receipt_Parent.Id = ObjectLink_Receipt_Parent.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Code_Parent
                                 ON ObjectString_Code_Parent.ObjectId = Object_Receipt_Parent.Id
                                AND ObjectString_Code_Parent.DescId = zc_ObjectString_Receipt_Code()

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
                                 AND ObjectBoolean_Main_Parent.DescId = zc_ObjectBoolean_Receipt_Main()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN tmpPrice_10100 ON View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
          LEFT JOIN tmpPrice_20900 ON /*View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                   OR*/ tmpGoods_20900.GoodsId > 0
-- where inSession <> '5' or tmpGoods_20900.GoodsId > 0
         ;

      -- Результат
      RETURN NEXT Cursor1;


     -- Результат
     OPEN Cursor2 FOR
       WITH tmpChild_calc AS (SELECT tmpChildReceiptTable.ReceiptId
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1) AS Summ1
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2) AS Summ2
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                              FROM (SELECT tmpChildReceiptTable.ReceiptId_from FROM tmpChildReceiptTable WHERE tmpChildReceiptTable.ReceiptId_from > 0 GROUP BY tmpChildReceiptTable.ReceiptId_from
                                   ) AS tmp
                                   INNER JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmp.ReceiptId_from
                                                                  AND tmpChildReceiptTable.isCost = FALSE
                              GROUP BY tmpChildReceiptTable.ReceiptId
                             )
       SELECT CASE WHEN inIsGoodsKind = TRUE THEN tmpReceiptChild.ReceiptId ELSE tmpReceiptChild.GoodsId_in END AS ReceiptId
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

            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END AS Amount
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price1 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ1 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price1
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price2 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ2 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price2
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price3 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ3 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price3

            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price1 AS Summ1
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price2 AS Summ2
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price3 AS Summ3

            , tmpReceiptChild.isStart
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out ELSE 0 END AS Amount_start
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price1 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ1 / ObjectFloatReceipt_Value.ValueData ELSE 0 END ELSE 0 END AS Summ1_Start
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price2 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ2 / ObjectFloatReceipt_Value.ValueData ELSE 0 END ELSE 0 END AS Summ2_Start
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price3 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ3 / ObjectFloatReceipt_Value.ValueData ELSE 0 END ELSE 0 END AS Summ3_Start

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

       FROM (SELECT tmpChildReceiptTable.ReceiptId_from, tmpChildReceiptTable.ReceiptId, tmpChildReceiptTable.GoodsId_in, tmpChildReceiptTable.GoodsKindId_in, tmpChildReceiptTable.Amount_in
                  , tmpChildReceiptTable.ReceiptChildId
                    --
                  , tmpChildReceiptTable.GoodsId_out
                  , tmpChildReceiptTable.GoodsKindId_out
                  , tmpChildReceiptTable.Amount_out
                  , tmpChildReceiptTable.isStart
                  , tmpChildReceiptTable.isCost

                  , tmpChildReceiptTable.Price1, tmpChildReceiptTable.Price2, tmpChildReceiptTable.Price3, tmpChildReceiptTable.Price4

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
             FROM tmpChildReceiptTable
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = tmpChildReceiptTable.GoodsId_out
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                          ON ObjectBoolean_WeightMain.ObjectId = tmpChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                          ON ObjectBoolean_TaxExit.ObjectId = tmpChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()

            UNION ALL
             SELECT tmpChildReceiptTable.ReceiptId_from, tmpChildReceiptTable.ReceiptId, tmpChildReceiptTable.GoodsId_in, tmpChildReceiptTable.GoodsKindId_in, tmpChildReceiptTable.Amount_in
                  , tmpChildReceiptTable.ReceiptChildId
                    --
                  , zc_Enum_InfoMoney_21501() AS GoodsId_out
                  , 0 AS GoodsKindId_out
                  , tmpChildReceiptTable.Amount_out
                  , tmpChildReceiptTable.isStart
                  , tmpChildReceiptTable.isCost

                  , tmpChildReceiptTable.Price1_bon :: TFloat AS Price1
                   -- ??? 1 или 2???
                  , tmpChildReceiptTable.Price1_bon :: TFloat AS Price2
                   -- ??? 1 или 3 ???
                  , tmpChildReceiptTable.Price1_bon :: TFloat AS Price3

                  , 0 :: TFloat AS Price4

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
             FROM tmpChildReceiptTable
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_21501()

             WHERE tmpChildReceiptTable.isCost = TRUE
               AND tmpChildReceiptTable.Price1_bon > 0

            ) AS tmpReceiptChild

            LEFT JOIN tmpChild_calc ON tmpChild_calc.ReceiptId = tmpReceiptChild.ReceiptId_from
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
 02.08.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_ReceiptSaleAnalyzeReal (inStartDate:= '01.06.2021', inEndDate:= '01.06.2021', inUnitId_sale:= 8447, inUnitId_return:= 8447, inGoodsGroupId:= 0, inPriceListId_1:= 0, inPriceListId_2:= 0, inPriceListId_3:= 0, inPriceListId_sale:= 0, inIsGoodsKind:= FALSE, inSession:= zfCalc_UserAdmin())
--  SELECT * FROM gpReport_ReceiptSaleAnalyzeReal (inStartDate:= '01.06.2021', inEndDate:= '01.06.2021', inUnitId_sale:= 8447, inUnitId_return:= 8447, inJuridicalId:= 15512, inGoodsGroupId:= 0, inPriceListId_1:= 0, inPriceListId_2:= 0, inPriceListId_3:= 0, inPriceListId_sale:= 0, inPriceListId_5:= 0, inPriceListId_6:=0, inIsGoodsKind:= FALSE, inisExclude:=FALSE, inSession:= zfCalc_UserAdmin())
