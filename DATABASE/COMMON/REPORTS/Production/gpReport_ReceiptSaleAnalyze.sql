-- Function: gpReport_ReceiptSaleAnalyze()

DROP FUNCTION IF EXISTS gpReport_ReceiptSaleAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ReceiptSaleAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReceiptSaleAnalyze (
    IN inStartDate        TDateTime ,
    IN inEndDate          TDateTime ,
    IN inUnitId_sale      Integer   ,
    IN inUnitId_return    Integer   ,
    IN inGoodsGroupId     Integer   ,
    IN inPriceListId_1    Integer,
    IN inPriceListId_2    Integer,
    IN inPriceListId_3    Integer,
    IN inPriceListId_sale Integer,
    IN inIsGoodsKind      Boolean,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor

AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

    -- !!!пересчет Рецептур, временно захардкодил!!!
    --PERFORM lpUpdate_Object_Receipt_Total (Object.Id, zfCalc_UserAdmin() :: Integer) FROM Object WHERE DescId = zc_Object_Receipt();
    -- !!!пересчет Рецептур, временно захардкодил!!!
    --PERFORM lpUpdate_Object_Receipt_Parent (0, 0, 0);


     CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;

     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, isStart Boolean, isCost Boolean
                                           , Price1 TFloat, Price2 TFloat, Price3 TFloat, Price4 TFloat) ON COMMIT DROP;

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
     INSERT INTO _tmpUnit (UnitId)
        SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId_sale) AS lfSelect
       UNION
        SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId_return) AS lfSelect
       ;

     -- ВСЕ рецептуры
     INSERT INTO tmpChildReceiptTable (ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, isStart, isCost
                                     , Price1, Price2, Price3, Price4)
          SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
               , lpSelect.ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out, lpSelect.Amount_out, lpSelect.isStart, lpSelect.isCost
               , COALESCE (PriceList1.Price, 0),  COALESCE (PriceList2.Price, 0), COALESCE(PriceList3.Price, 0), COALESCE(PriceList4.Price, 0)
          FROM lpSelect_Object_ReceiptChildDetail () AS lpSelect
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = inPriceListId_1
                                                                       AND PriceList1.GoodsId = lpSelect.GoodsId_out
                                                                       AND inEndDate >= PriceList1.StartDate AND inEndDate < PriceList1.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2 ON PriceList2.PriceListId = inPriceListId_2
                                                                       AND PriceList2.GoodsId = lpSelect.GoodsId_out
                                                                       AND inEndDate >= PriceList2.StartDate AND inEndDate < PriceList2.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = inPriceListId_3
                                                                       AND PriceList3.GoodsId = lpSelect.GoodsId_out
                                                                       AND inEndDate >= PriceList3.StartDate AND inEndDate < PriceList3.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList4 ON PriceList4.PriceListId = inPriceListId_sale
                                                                       AND PriceList4.GoodsId = lpSelect.GoodsId_out
                                                                       AND inEndDate >= PriceList4.StartDate AND inEndDate < PriceList4.EndDate
         ;


     -- Результат
     OPEN Cursor1 FOR
     WITH tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                          FROM Constant_ProfitLoss_AnalyzerId_View
                          WHERE DescId = zc_Object_AnalyzerId()
                         )
        , tmpAccount AS (SELECT Object_Account_View.AccountGroupId, Object_Account_View.AccountId
                         FROM Object_Account_View
                         WHERE Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_60000()  -- Прибыль будущих периодов
                                                                    , zc_Enum_AccountGroup_110000() -- Транзит
                                                                     )
                        UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummIn_110101() AS AccountId -- Сумма, забалансовый счет, приход транзит, хотя поле пишется в AccountId, при этом ContainerId - стандартный и в нем другой AccountId
                        UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummOut_110101() AS AccountId -- Сумма, забалансовый счет, расходтранзит, хотя поле пишется в AccountId, при этом ContainerId - стандартный и в нем другой AccountId
                        )
        , tmpMIContainer AS
           (SELECT tmpContainer.GoodsId
                 , tmpContainer.GoodsKindId

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() AND tmpAccount.AccountGroupId IS NULL
                                  THEN tmpContainer.OperCount
                                     - tmpContainer.OperCount_Change
                                     + tmpContainer.OperCount_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS OperCount_sale

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() AND (tmpAccount.AccountGroupId IS NULL OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000())
                                  THEN tmpContainer.SummIn
                                     - tmpContainer.SummIn_Change
                                     + tmpContainer.SummIn_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS SummIn_sale

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() THEN tmpContainer.SummOut_PriceList ELSE 0 END
                      + CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_PriceList ELSE 0 END
                      - CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_PriceList ELSE 0 END
                       ) AS SummOut_PriceList_sale

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() THEN tmpContainer.SummOut_Partner ELSE 0 END
                      + CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummOut_Partner *  1 ELSE 0 END   -- !!!знак!!!
                      - CASE WHEN tmpContainer.MovementDescId = zc_Movement_Sale() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummOut_Partner * -1 ELSE 0 END   -- !!!знак!!!
                       ) AS SummOut_sale



                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() AND tmpAccount.AccountGroupId IS NULL
                                  THEN tmpContainer.OperCount
                                     - tmpContainer.OperCount_Change
                                     - tmpContainer.OperCount_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS OperCount_return

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() AND (tmpAccount.AccountGroupId IS NULL OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000())
                                  THEN tmpContainer.SummIn
                                     - tmpContainer.SummIn_Change
                                     - tmpContainer.SummIn_40200  -- !!!знак!!!
                             ELSE 0
                        END) AS SummIn_return


                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() THEN tmpContainer.SummOut_PriceList ELSE 0 END
                      + CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_PriceList ELSE 0 END
                      - CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_PriceList ELSE 0 END
                       ) AS SummOut_PriceList_return

                 , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() THEN tmpContainer.SummOut_Partner ELSE 0 END
                      + CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = FALSE /* TRUE */ THEN tmpContainer.SummOut_Partner * -1 ELSE 0 END   -- !!!знак!!!
                      - CASE WHEN tmpContainer.MovementDescId = zc_Movement_ReturnIn() AND tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = TRUE  /* FALSE*/ THEN tmpContainer.SummOut_Partner *  1 ELSE 0 END   -- !!!знак!!!
                       ) AS SummOut_return

            FROM
           (SELECT MIContainer.ObjectId_Analyzer       AS GoodsId
                 , CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer, 0) = 0 THEN zc_GoodsKind_Basis() ELSE MIContainer.ObjectIntId_analyzer END AS GoodsKindId
                 , MIContainer.isActive
                 , MIContainer.MovementDescId
                 , COALESCE (MIContainer.AccountId, 0) AS AccountId

                        -- 1.1. Кол-во, без AnalyzerId
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount
                        -- 1.2. Себестоимость, без AnalyzerId
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                   -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_SaleSumm_10500(), zc_Enum_AnalyzerId_SaleSumm_40200())
                                       THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                   -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ReturnInSumm_40200()
                                       THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn

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
                 INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                 LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
            WHERE (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
            GROUP BY MIContainer.ObjectId_Analyzer
                   , MIContainer.ObjectIntId_analyzer
                   , MIContainer.isActive
                   , MIContainer.MovementDescId
                   , MIContainer.AccountId
           ) AS tmpContainer
           LEFT JOIN tmpAccount ON tmpAccount.AccountId = tmpContainer.AccountId
           GROUP BY tmpContainer.GoodsId
                  , tmpContainer.GoodsKindId
           )
/*
           , tmp_Send AS (SELECT gpReport.GoodsId, gpReport.GoodsKindId
                               , SUM (gpReport.AmountIn)       AS Amount_Count
                               , SUM (gpReport.SummIn_branch)  AS Amount_Summ
                               , SUM (gpReport.SummOut_zavod)  AS Amount_SummIn
                               , 0 AS Amount_CountRet
                               , 0 AS Amount_SummRet
                               , 0 AS Amount_SummInRet
                          FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                        , inEndDate      := inEndDate
                                                        , inDescId       := zc_Movement_SendOnPrice()
                                                        , inFromId       := -123
                                                        , inToId         := 0
                                                        , inGoodsGroupId := inGoodsGroupId
                                                        , inIsMO_all     := FALSE
                                                        , inSession      := inSession
                                                         ) AS gpReport
                          GROUP BY gpReport.GoodsId, gpReport.GoodsKindId
                         UNION ALL
                          SELECT MovementItem.ObjectId           AS GoodsId
                               , MILinkObject_GoodsKind.ObjectId AS GoodsKindId

                               , 0 AS Amount_Count
                               , 0 AS Amount_Summ
                               , 0 AS Amount_SummIn

                               , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0) / *MovementItem.Amount* /) AS Amount_CountRet
                               , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0) / *MovementItem.Amount* /
                                    * CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END * 1.2
                                     ) AS Amount_SummRet
                               , 0 AS Amount_SummInRet
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               INNER JOIN _tmpUnit AS _tmpUnit_To ON _tmpUnit_To.UnitId = MovementLinkObject_To.ObjectId
                                                                 AND _tmpUnit_To.UnitId > 0
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_SendOnPrice()
                            AND (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
                          GROUP BY MovementItem.ObjectId
                                 , MILinkObject_GoodsKind.ObjectId
                         UNION ALL
                          SELECT MIContainer.ObjectId_Analyzer    AS GoodsId
                               , MIContainer.ObjectIntId_Analyzer AS GoodsKindId
                               , 0 AS Amount_Count
                               , 0 AS Amount_Summ
                               , 0 AS Amount_SummIn

                               , 0 AS Amount_CountRet
                               , 0 AS Amount_SummRet
                               , SUM (CASE WHEN MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount_SummInRet
                          FROM _tmpUnit
                               INNER JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.WhereObjectId_analyzer = _tmpUnit.UnitId
                                                               AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_in()
                                                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                               AND MIContainer.isActive = TRUE
                               LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                          WHERE (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
                          GROUP BY MIContainer.ObjectId_Analyzer
                                 , MIContainer.ObjectIntId_Analyzer
                         )
*/

          , tmp_Send AS  (SELECT MovementItem.ObjectId                         AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) /*COALESCE (MIFloat_AmountChangePercent.ValueData, 0)*/ ELSE 0 END) AS Amount_Count
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_Summ.ValueData, 0) ELSE 0 END -- COALESCE (MIFloat_AmountPartner.ValueData, 0) /*COALESCE (MIFloat_AmountChangePercent.ValueData, 0)*/ ELSE 0 END
                                    /** CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END * 1.2*/
                                     ) AS Amount_Summ
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_SummPriceList.ValueData, 0) ELSE 0 END) AS Amount_Summ_PriceList
                               , 0 AS Amount_SummIn

                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) /*MovementItem.Amount*/ ELSE 0 END) AS Amount_CountRet
                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_Summ.ValueData, 0) ELSE 0 END -- COALESCE (MIFloat_AmountPartner.ValueData, 0) /*MovementItem.Amount*/ ELSE 0 END
                                    /** CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END * 1.2*/
                                     ) AS Amount_SummRet
                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_SummPriceList.ValueData, 0) ELSE 0 END) AS Amount_SummRet_PriceList
                               , 0 AS Amount_SummInRet

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN _tmpUnit AS tmp_Unit_From ON tmp_Unit_From.UnitId = MovementLinkObject_From.ObjectId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN _tmpUnit AS tmp_Unit_To ON tmp_Unit_To.UnitId = MovementLinkObject_To.ObjectId

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                               /*LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                           ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()*/

                               LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                           ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummPriceList
                                                           ON MIFloat_SummPriceList.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummPriceList.DescId = zc_MIFloat_SummPriceList()
                               /*LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()*/
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_SendOnPrice()
                            AND (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
                            AND (tmp_Unit_From.UnitId > 0
                              OR tmp_Unit_To.UnitId > 0)
                          GROUP BY MovementItem.ObjectId
                                 , MILinkObject_GoodsKind.ObjectId
                         UNION ALL
                          SELECT MIContainer.ObjectId_Analyzer    AS GoodsId
                               , MIContainer.ObjectIntId_Analyzer AS GoodsKindId
                               , 0 AS Amount_Count
                               , 0 AS Amount_Summ
                               , 0 AS Amount_Summ_PriceList
                               , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_SummIn

                               , 0 AS Amount_CountRet
                               , 0 AS Amount_SummRet
                               , 0 AS Amount_SummRet_PriceList
                               , SUM (CASE WHEN MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount_SummInRet
                          FROM _tmpUnit
                               INNER JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.WhereObjectId_analyzer = _tmpUnit.UnitId
                                                               AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SendSumm_in(), zc_Enum_AnalyzerId_LossSumm_10900())
                                                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                               AND MIContainer.AccountId NOT IN (zc_Enum_Account_100301() -- Собственный капитал + Прибыль текущего периода
                                                                                               , zc_Enum_Account_110101() -- Транзит + товар в пути
                                                                                               , zc_Enum_Account_110102() -- Транзит + товар в пути
                                                                                               , zc_Enum_Account_110111() -- Транзит + товар в пути
                                                                                               , zc_Enum_Account_110112() -- Транзит + товар в пути
                                                                                               , zc_Enum_Account_110121() -- Транзит + товар в пути
                                                                                               , zc_Enum_Account_110122() -- Транзит + товар в пути
                                                                                               , zc_Enum_Account_110131() -- Транзит + товар в пути
                                                                                               , zc_Enum_Account_110132() -- Транзит + товар в пути

                                                                                               , zc_Enum_Account_110151() -- Транзит + Прибыль в пути
                                                                                               , zc_Enum_Account_110152() -- Транзит + Прибыль в пути
                                                                                               , zc_Enum_Account_110161() -- Транзит + Прибыль в пути
                                                                                               , zc_Enum_Account_110162() -- Транзит + Прибыль в пути
                                                                                               , zc_Enum_Account_110171() -- Транзит + Прибыль в пути
                                                                                               , zc_Enum_Account_110172() -- Транзит + Прибыль в пути
                                                                                               , zc_Enum_Account_110181() -- Транзит + Прибыль в пути
                                                                                               , zc_Enum_Account_110182() -- Транзит + Прибыль в пути

                                                                                               , zc_Enum_AnalyzerId_SummIn_110101()
                                                                                               , zc_Enum_AnalyzerId_SummOut_110101()
                                                                                               , zc_Enum_AnalyzerId_SummIn_80401()
                                                                                               , zc_Enum_AnalyzerId_SummOut_80401()
                                                                                                )
                               LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                          WHERE (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
                          GROUP BY MIContainer.ObjectId_Analyzer
                                 , MIContainer.ObjectIntId_Analyzer
                         )

        , tmpReceipt AS (SELECT tmp.GoodsId, tmp.GoodsKindId, MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                         FROM (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId FROM tmpMIContainer GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                              UNION
                               SELECT tmp_Send.GoodsId, tmp_Send.GoodsKindId FROM tmp_Send GROUP BY tmp_Send.GoodsId, tmp_Send.GoodsKindId
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
            FROM tmpMIContainer
                 LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMIContainer.GoodsId
                                     AND tmpReceipt.GoodsKindId = tmpMIContainer.GoodsKindId
            GROUP BY COALESCE (tmpReceipt.ReceiptId, 0)
                   , tmpMIContainer.GoodsId
                   , tmpMIContainer.GoodsKindId

           UNION ALL
            SELECT COALESCE (tmpReceipt.ReceiptId, 0) AS ReceiptId
                 , 0 AS GoodsId_isCost
                 , tmp_Send.GoodsId
                 , tmp_Send.GoodsKindId
                 , SUM (tmp_Send.Amount_Count)          AS OperCount_sale
                 , SUM (tmp_Send.Amount_SummIn)         AS SummIn_sale
                 , SUM (tmp_Send.Amount_Summ_PriceList) AS SummOut_PriceList_sale
                 , SUM (tmp_Send.Amount_Summ)           AS SummOut_sale

                 , SUM (tmp_Send.Amount_CountRet)          AS OperCount_return
                 , SUM (tmp_Send.Amount_SummInRet)         AS SummIn_return
                 , SUM (tmp_Send.Amount_SummRet_PriceList) AS SummOut_PriceList_return
                 , SUM (tmp_Send.Amount_SummRet)           AS SummOut_return

                 , 0 AS Summ1
                 , 0 AS Summ2
                 , 0 AS Summ3
                 , 0 AS Summ1_cost
                 , 0 AS Summ2_cost
                 , 0 AS Summ3_cost
                 , 0 AS Summ4_cost
            FROM tmp_Send
                 LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmp_Send.GoodsId
                                     AND tmpReceipt.GoodsKindId = tmp_Send.GoodsKindId
            GROUP BY COALESCE (tmpReceipt.ReceiptId, 0)
                   , tmp_Send.GoodsId
                   , tmp_Send.GoodsKindId

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
            FROM (SELECT tmpChildReceiptTable.ReceiptId
                       , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.GoodsId_out ELSE 0 END) AS GoodsId_isCost
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1) AS Summ1
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2) AS Summ2
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1 ELSE 0 END) AS Summ1_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2 ELSE 0 END) AS Summ2_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost
                       , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price4 ELSE 0 END) AS Summ4_cost
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
                            UNION
                             SELECT tmp_Send.GoodsId, tmp_Send.GoodsKindId FROM tmp_Send WHERE tmp_Send.Amount_Count <> 0 OR tmp_Send.Amount_CountRet <> 0 GROUP BY tmp_Send.GoodsId, tmp_Send.GoodsKindId
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

                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ1 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm1
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ2 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm2
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm3
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ1_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm1_cost
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ2_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm2_cost
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm3_cost
                 , SUM (tmpAll.OperCount_sale * CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ4_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) ELSE 0 END) AS newSumm4_cost

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
                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
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

           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price1, 0)
                        WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                + COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm1 / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ1 / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price1
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price2, 0)
                        WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                + COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm2 <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm2 / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ2 / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price2
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price3, 0)
                        WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                + COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm3 <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm3 / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ3 / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price3

           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price1, 0)
                        WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm1_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm1_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ1_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price1_cost
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price2, 0)
                        WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm2_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ2_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price2_cost
           , CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                             THEN COALESCE (tmpPrice_10100.Price3, 0)
                        WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                          OR tmpGoods_20900.GoodsId > 0
                             THEN COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                        WHEN tmpResult.newSumm3_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm3_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ3_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price3_cost

           , CAST (CASE WHEN tmpResult.newSumm4_cost <> 0 AND tmpResult.OperCount_sale <> 0
                             THEN tmpResult.newSumm4_cost / tmpResult.OperCount_sale
                        ELSE tmpResult.Summ4_cost / tmpResult.Value_receipt
                   END AS NUMERIC (16, 3)) AS Price4_cost

           , (COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2) :: TFloat AS Price_sale -- !!!захардкодил временно!!!

           , CASE WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900())
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm1
                  ELSE
             tmpResult.OperCount_sale * CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price1, 0)
                                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                     OR tmpGoods_20900.GoodsId > 0
                                                        THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                                           + COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                                   ELSE tmpResult.Summ1 / tmpResult.Value_receipt
                                              END AS NUMERIC (16, 3)) END AS SummPrice1_sale -- с/с реализ по план1
           , CASE WHEN tmpResult.newSumm2 <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900())
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm2
                  ELSE
             tmpResult.OperCount_sale * CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price2, 0)
                                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                     OR tmpGoods_20900.GoodsId > 0
                                                        THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                                           + COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                                   ELSE tmpResult.Summ2 / tmpResult.Value_receipt
                                              END AS NUMERIC (16, 3)) END AS SummPrice2_sale -- с/с реализ по план2
           , CASE WHEN tmpResult.newSumm3 <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900())
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm3
                  ELSE
             tmpResult.OperCount_sale * CAST (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price3, 0)
                                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                     OR tmpGoods_20900.GoodsId > 0
                                                        THEN COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85
                                                           + COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                                   ELSE tmpResult.Summ3 / tmpResult.Value_receipt
                                              END AS NUMERIC (16, 3)) END AS SummPrice3_sale -- с/с реализ по план3

             -- сумма по прайсу расчетному
           , (tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2) :: TFloat AS Summ_sale

           , CASE WHEN tmpResult.newSumm1_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900())
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm1_cost
                  ELSE
             tmpResult.OperCount_sale * CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price1, 0)
                                             WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                               OR tmpGoods_20900.GoodsId > 0
                                                  THEN COALESCE (tmpPrice_20900.Price1, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                             ELSE CAST (tmpResult.Summ1_cost / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                        END END AS SummCost1_sale -- сумма затрат на реализ по план1
           , CASE WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900())
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm2_cost
                  ELSE
             tmpResult.OperCount_sale * CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price2, 0)
                                             WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                               OR tmpGoods_20900.GoodsId > 0
                                                  THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                             ELSE CAST (tmpResult.Summ2_cost / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                        END END AS SummCost2_sale -- сумма затрат на реализ по план2
           , CASE WHEN tmpResult.newSumm3_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900())
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm3_cost
                  ELSE
             tmpResult.OperCount_sale * CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        THEN COALESCE (tmpPrice_10100.Price3, 0)
                                             WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                               OR tmpGoods_20900.GoodsId > 0
                                                  THEN COALESCE (tmpPrice_20900.Price3, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                             ELSE CAST (tmpResult.Summ3_cost / tmpResult.Value_receipt AS NUMERIC (16, 3))
                                        END END AS SummCost3_sale -- сумма затрат на реализ по план3

           , CASE WHEN tmpResult.newSumm4_cost <> 0 AND tmpResult.OperCount_sale <> 0
                   AND COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900())
                   AND tmpGoods_20900.GoodsId IS NULL
                       THEN tmpResult.newSumm4_cost
                  ELSE
             tmpResult.OperCount_sale * CAST (tmpResult.Summ4_cost / tmpResult.Value_receipt AS NUMERIC (16, 3)) END AS SummCost4_sale -- сумма затрат на реализ по план4

           , CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                    OR tmpGoods_20900.GoodsId > 0
                       THEN 100 * 1
                                / 0.85
                          - 100
                  WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                       THEN 100 * (tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2)
                                / (tmpResult.newSumm1)
                          - 100
                  WHEN (tmpResult.OperCount_sale * tmpResult.Summ1 / tmpResult.Value_receipt) <> 0
                       THEN 100 * (tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2)
                                / (tmpResult.OperCount_sale * CAST (tmpResult.Summ1 / tmpResult.Value_receipt AS NUMERIC (16, 3)))
                          - 100
                       ELSE 0
             END AS Tax_Summ_sale -- % рент. для план1 / сумма по прайсу расчетному

           , CASE WHEN (View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                     OR tmpGoods_20900.GoodsId > 0)
                   AND tmpResult.OperCount_sale * COALESCE (PriceListSale_gk.Price, PriceListSale.Price) <> 0
                       THEN 100 * tmpResult.SummOut_sale
                                / (tmpResult.OperCount_sale * CAST (COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 * 0.85 AS NUMERIC (16, 3)))
                          - 100
                  WHEN tmpResult.newSumm1 <> 0 AND tmpResult.OperCount_sale <> 0
                       THEN 100 * tmpResult.SummOut_sale
                                / (tmpResult.newSumm1)
                          - 100
                  WHEN (tmpResult.OperCount_sale * tmpResult.Summ1 / tmpResult.Value_receipt) <> 0
                       THEN 100 * tmpResult.SummOut_sale
                                / (tmpResult.OperCount_sale * CAST (tmpResult.Summ1 / tmpResult.Value_receipt AS NUMERIC (16, 3)))
                          - 100
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
                                                    + (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                 THEN COALESCE (tmpPrice_10100.Price2, 0)
                                                            WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                              OR tmpGoods_20900.GoodsId > 0
                                                                 THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                                            WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                                                                 THEN tmpResult.newSumm2_cost / tmpResult.OperCount_sale
                                                            ELSE tmpResult.Summ2_cost / tmpResult.Value_receipt
                                                       END))
                                                )
                   - tmpResult.SummOut_return ) AS NUMERIC (16, 3) )  AS Profit
           -- если  чистая прибыль отриц. подсвечиваем красным
           , CASE WHEN (tmpResult.OperCount_sale * ((CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END)
                                                   - ( (CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummIn_sale / tmpResult.OperCount_sale ELSE 0 END)
                                                       + (CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                    THEN COALESCE (tmpPrice_10100.Price2, 0)
                                                               WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                  OR tmpGoods_20900.GoodsId > 0
                                                                    THEN COALESCE (tmpPrice_20900.Price2, 0) * CASE WHEN tmpResult.OperCount_sale <> 0 THEN tmpResult.SummOut_sale / tmpResult.OperCount_sale ELSE 0 END
                                                               WHEN tmpResult.newSumm2_cost <> 0 AND tmpResult.OperCount_sale <> 0
                                                                    THEN tmpResult.newSumm2_cost / tmpResult.OperCount_sale
                                                               ELSE tmpResult.Summ2_cost / tmpResult.Value_receipt
                                                          END))
                                                   )
                   - tmpResult.SummOut_return ) < 0 THEN zc_Color_Red() ELSE zc_Color_Black() END AS Color_Profit

           , CASE WHEN Object_Goods.Id <> Object_Goods_Parent.Id THEN TRUE ELSE FALSE END AS isCheck_Parent

           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

       FROM tmpResult
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk ON PriceListSale_gk.PriceListId = inPriceListId_sale
                                                                          AND PriceListSale_gk.GoodsId = tmpResult.GoodsId
                                                                          AND PriceListSale_gk.GoodsKindId = tmpResult.GoodsKindId
                                                                          AND inEndDate >= PriceListSale_gk.StartDate AND inEndDate < PriceListSale_gk.EndDate
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                       AND PriceListSale.GoodsId = tmpResult.GoodsId
                                                                       AND PriceListSale.GoodsKindId = 0
                                                                       AND inEndDate >= PriceListSale.StartDate AND inEndDate < PriceListSale.EndDate
                                                                       AND PriceListSale_gk.GoodsId IS NULL
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
          LEFT JOIN tmpPrice_20900 ON View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                   OR tmpGoods_20900.GoodsId > 0
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
            , Object_Goods.ValueData      AS GoodsName
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

       FROM (SELECT tmpChildReceiptTable.*
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
-- SELECT * FROM gpReport_ReceiptSaleAnalyze (inStartDate:= '01.06.2021', inEndDate:= '01.06.2021', inUnitId_sale:= 8447, inUnitId_return:= 8447, inGoodsGroupId:= 0, inPriceListId_1:= 0, inPriceListId_2:= 0, inPriceListId_3:= 0, inPriceListId_sale:= 0, inIsGoodsKind:= FALSE, inSession:= zfCalc_UserAdmin())
