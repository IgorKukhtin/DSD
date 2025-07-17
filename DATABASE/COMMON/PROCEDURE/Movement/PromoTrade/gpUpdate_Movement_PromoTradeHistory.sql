-- Function: gpUpdate_Movement_PromoTradeHistory()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PromoTradeHistory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_PromoTradeHistory(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd   TDateTime;
   DECLARE vbOperDate      TDateTime;
   DECLARE vbJuridicalId   Integer;
   DECLARE vbContractId    Integer;
   DECLARE vbAccountId     Integer;
   DECLARE vbPaidKindId    Integer;

   DECLARE vbMovementId_PromoTradeHistory Integer;

   DECLARE vbMonthPromo TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());

     -- Проверили - Ви товара  для расчета с/с 
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                           ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                          AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                         , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                         , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                                          )
                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Необходимо заполнить колонку вид товара.';
     END IF;



     -- параметры из документа
     SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
          , MovementLinkObject_Contract.ObjectId        AS ContractId
          , ObjectLink_Contract_PaidKind.ChildObjectId  AS PaidKindId
            -- статистики продаж/возвраты за последние 3 месяца
          , MovementDate_OperDateStart.ValueData        AS OperDateStart
            -- статистики продаж/возвраты за последние 3 месяца
          , MovementDate_OperDateEnd.ValueData          AS OperDateEnd

          , Movement_PromoTrade.OperDate

            INTO vbJuridicalId, vbContractId, vbPaidKindId
               , vbOperDateStart, vbOperDateEnd, vbOperDate
     FROM Movement AS Movement_PromoTrade
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement_PromoTrade.Id
                                      AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()

          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                               ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement_PromoTrade.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement_PromoTrade.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

     WHERE Movement_PromoTrade.Id = inMovementId
    ;

     -- параметры - Счет
     vbAccountId:= (SELECT Object_Account_View.AccountId
                    FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                         LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                              ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Contract_InfoMoney.ChildObjectId
                                             AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                         INNER JOIN Object_Account_View
                                 ON Object_Account_View.InfoMoneyDestinationId = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
                                 -- 30000; "Дебиторы"; 30100; "Покупатели"
                                AND Object_Account_View.AccountDirectionId     = zc_Enum_AccountDirection_30100()
                    WHERE ObjectLink_Contract_InfoMoney.ObjectId = vbContractId
                      AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                   );

     IF COALESCE (vbAccountId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Счет не найден для <%> + <%>.'
                       , lfGet_Object_ValueData (vbContractId)
                       , lfGet_Object_ValueData ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbContractId AND OL.DescId   = zc_ObjectLink_Contract_InfoMoney()))
                        ;
     END IF;



    -- Нашли PromoTradeCondition - История клиента
    vbMovementId_PromoTradeHistory := (SELECT Movement.Id
                                       FROM Movement
                                       WHERE Movement.DescId    = zc_Movement_PromoTradeHistory()
                                         AND Movement.ParentId =  inMovementId
                                      );

    -- Если не нашли
    IF COALESCE (vbMovementId_PromoTradeHistory,0) = 0
    THEN
        -- создаем документ
        vbMovementId_PromoTradeHistory:= (SELECT lpInsertUpdate_Movement (0, zc_Movement_PromoTradeHistory(), Movement.InvNumber, Movement.OperDate, Movement.Id, 0)
                                          FROM Movement
                                          WHERE Movement.Id = inMovementId
                                         );
    END IF;


     -- данные по Просроченная дебиторская задолженность
     CREATE TEMP TABLE _tmpJuridical (AccountId Integer, JuridicalId Integer, PartnerId Integer, BranchId Integer, PaidKindId Integer, ContractId Integer
                                      -- Долг с отсрочкой
                                    , DefermentPaymentRemains TFloat
                                      -- Долг с отсрочкой - по накладной
                                    , TotalSumm_diff_Deferment TFloat
                                      -- Кол. дней отсрочки
                                    , DayCount_condition TFloat
                                      -- Просрочено дней - по накладной
                                    , DelayDay_calc TFloat
                                      -- Итого
                                    , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
                                     ) ON COMMIT DROP;

     -- Данные
     INSERT INTO _tmpJuridical (AccountId, JuridicalId, PartnerId, BranchId, PaidKindId, ContractId
                                -- Долг с отсрочкой
                              , DefermentPaymentRemains
                                -- Долг с отсрочкой - по накладной
                              , TotalSumm_diff_Deferment
                                -- Кол. дней отсрочки
                              , DayCount_condition
                                -- Просрочено дней - по накладной
                              , DelayDay_calc
                                -- Итого
                              , SaleSumm1, SaleSumm2, SaleSumm3, SaleSumm4, SaleSumm5
                               )
        -- Результат
        SELECT gpReport.AccountId, gpReport.JuridicalId, gpReport.PartnerId, gpReport.BranchId, gpReport.PaidKindId, gpReport.ContractId
               -- Долг с отсрочкой
             , gpReport.DefermentPaymentRemains
               -- Долг с отсрочкой - по накладной
             , gpReport.TotalSumm_diff_Deferment
               -- Кол. дней отсрочки
             , gpReport.DayCount_condition
               -- Просрочено дней - по накладной
             , gpReport.DelayDay_calc
               -- Итого
             , gpReport.SaleSumm1, gpReport.SaleSumm2, gpReport.SaleSumm3, gpReport.SaleSumm4, gpReport.SaleSumm5

        FROM gpReport_JuridicalDefermentPaymentMovement_jur(inOperDate         := vbOperDate
                                                          , inEmptyParam       := vbOperDate
                                                          , inAccountId        := vbAccountId
                                                          , inPaidKindId       := vbPaidKindId
                                                          , inBranchId         := 0
                                                          , inJuridicalGroupId := 0
                                                          , inJuridicalId      := vbJuridicalId
                                                          , inContractId       := vbContractId
                                                          , inSession          := inSession
                                                           ) AS gpReport;

     -- данные по продажам/возвратам
     CREATE TEMP TABLE _tmpData (SaleAmount TFloat, ReturnAmount TFloat, SaleSumm TFloat, ReturnSumm TFloat) ON COMMIT DROP;

     -- Данные
     INSERT INTO _tmpData (SaleAmount, ReturnAmount, SaleSumm, ReturnSumm)
        WITH tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                                  , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                             FROM Constant_ProfitLoss_AnalyzerId_View
                            )
           , tmpContainer AS (SELECT MIContainer.ObjectId_analyzer    AS GoodsId
                                   , MIContainer.ObjectIntId_analyzer AS GoodsKindId

                                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()
                                                    THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                               ELSE 0
                                          END) AS Sale_AmountPartner
                                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800()
                                                    THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                               ELSE 0
                                          END) AS Return_AmountPartner

                                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ
                              FROM tmpAnalyzer
                                     INNER JOIN MovementItemContainer AS MIContainer
                                                                      ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                     AND MIContainer.OperDate BETWEEN vbOperDateStart AND vbOperDateEnd     --'01.06.2024' AND '31.08.2024'--
                                                                     AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                     INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                    ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                                   AND ContainerLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                                                                   AND ContainerLO_Juridical.ObjectId    = vbJuridicalId  --15412  -- 14866 --vbJuridicalId inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)

                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                   ON MovementLinkObject_Contract.MovementId = MIContainer.MovementId
                                                                  AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                  AND MovementLinkObject_Contract.ObjectId   = vbContractId

                                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                         ON ObjectLink_Goods_Measure.ObjectId = MIContainer.ObjectId_analyzer
                                                        AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                          ON ObjectFloat_Weight.ObjectId = MIContainer.ObjectId_analyzer
                                                         AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                              GROUP BY MIContainer.ObjectId_analyzer
                                     , MIContainer.ObjectIntId_analyzer
                              )
        -- Результат
        SELECT SUM (tmpContainer.Sale_AmountPartner)   AS SaleAmount
             , SUM (tmpContainer.Return_AmountPartner) AS ReturnAmount
             , SUM (tmpContainer.Sale_Summ)            AS SaleSumm
             , SUM (tmpContainer.Return_Summ)          AS ReturnSumm
        FROM tmpContainer
       ;

      -- Результат -
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountSale(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.SaleAmount, 0))
            , lpInsertUpdate_MovementFloat (zc_MovementFloat_SummSale(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.SaleSumm, 0))
            , lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountReturnIn(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.ReturnAmount, 0))
            , lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReturnIn(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.ReturnSumm, 0))
      FROM (SELECT 1 AS x) AS a
           CROSS JOIN _tmpData
     ;

      -- Результат
      PERFORM -- Просроченная дебиторская задолженность, дней
              lpInsertUpdate_MovementFloat (zc_MovementFloat_DebtDay(), vbMovementId_PromoTradeHistory, COALESCE (_tmpJuridical.DelayDay_calc, 0))

              -- Просроченная дебиторская задолженность, грн 
               , lpInsertUpdate_MovementFloat (zc_MovementFloat_DebtSumm(), vbMovementId_PromoTradeHistory, COALESCE (_tmpJuridical.TotalSumm_diff_Deferment, 0))

      FROM (SELECT 1 AS x) AS a
           CROSS JOIN (SELECT -- Долг с отсрочкой
                              SUM (_tmpJuridical.DefermentPaymentRemains)  AS DefermentPaymentRemains
                              -- Долг с отсрочкой - по накладной
                            , SUM (_tmpJuridical.TotalSumm_diff_Deferment) AS TotalSumm_diff_Deferment
                            
                              -- Просрочено дней - по накладной
                            , MAX (CASE WHEN _tmpJuridical.TotalSumm_diff_Deferment > 0 THEN _tmpJuridical.DelayDay_calc ELSE 0 END) AS DelayDay_calc

                              -- Просрочено дней - по накладной
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm1) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_1
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm2) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_2
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm3) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_3
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm4) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_4
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm5) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_5

                       FROM _tmpJuridical
                      ) AS _tmpJuridical
     ;

-- 
     --  считаем с/с  
     
     -- Проверили - Вид товара   (в начало процедуры перенесла)
     /*IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                           ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                          AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                         , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                         , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                                          )
                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Необходимо заполнить колонку вид товара.';
     END IF;
     */
     -- нашли месяц
     vbMonthPromo := (SELECT CASE WHEN EXTRACT (DAY FROM MovementDate_Insert.ValueData) BETWEEN 1 AND 10
                                       THEN DATE_TRUNC ('MONTH', (MovementDate_Insert.ValueData - INTERVAL '1 MONTH'))
                                  WHEN EXTRACT (DAY FROM MovementDate_Insert.ValueData) BETWEEN 11 AND 31
                                       THEN DATE_TRUNC ('MONTH', MovementDate_Insert.ValueData)
                                  ELSE DATE_TRUNC ('MONTH', MovementDate_StartPromo.ValueData)
                        END :: TDateTime
                      FROM Movement
                           LEFT JOIN MovementDate AS MovementDate_Insert
                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                           LEFT JOIN MovementDate AS MovementDate_StartPromo
                                                  ON MovementDate_StartPromo.MovementId = Movement.Id
                                                 AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                      WHERE Movement.Id = inMovementId
                     );

     -- расчет цен за предыдущий месяц от проведения акции
     vbEndDate   := (vbMonthPromo - INTERVAL '1 DAY') :: TDateTime;
     vbStartDate := DATE_TRUNC ('MONTH', vbEndDate) :: TDateTime;


     -- сохранили расчет с/с за какой месяц
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), inMovementId, vbStartDate);


     CREATE TEMP TABLE _tmpData_in (ReceiptId Integer, GoodsId Integer, GoodsKindId Integer
                                  , Price3_cost_real TFloat, Price3_cost TFloat, PriceSale TFloat, Price_cost TFloat, Price_cost_tax TFloat
                                  , Price3_cost_all_real TFloat, Price3_cost_all TFloat, PriceSale_all TFloat, Price_cost_all TFloat, Price_cost_tax_all TFloat
                                  , Price1_plan TFloat, ReceiptId_plan Integer
                                  , OperCount_sale TFloat, SummIn_sale TFloat
                                  , Ord Integer
                                   ) ON COMMIT DROP;
     WITH tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                          FROM Constant_ProfitLoss_AnalyzerId_View
                          WHERE DescId = zc_Object_AnalyzerId()
                         )

        , tmpMI AS (SELECT DISTINCT
                           MovementItem.ObjectId AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                   )
        , tmpGoods AS (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)

          -- ВСЕ рецептуры
        , tmpChildReceiptTable AS (SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                                        , lpSelect.ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out, lpSelect.Amount_out, lpSelect.isStart, lpSelect.isCost
                                        , COALESCE(PriceList3.Price, PriceList3_test.Price, 0) AS Price3
                                   FROM lpSelect_Object_ReceiptChildDetail () AS lpSelect
                                        -- 46 - ПРАЙС - ФАКТ калькуляции без бонусов
                                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = 18885
                                                                                                AND PriceList3.GoodsId     = lpSelect.GoodsId_out
                                                                                                AND vbEndDate >= PriceList3.StartDate AND vbEndDate < PriceList3.EndDate
                                        -- 46 - ПРАЙС - ФАКТ калькуляции без бонусов
                                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_test ON PriceList3_test.PriceListId = 18885
                                                                                                     AND PriceList3_test.GoodsId     = lpSelect.GoodsId_out
                                                                                                     AND CURRENT_DATE >= PriceList3_test.StartDate AND CURRENT_DATE < PriceList3_test.EndDate
                                                                                                     AND vbUserId = 5
                                  )

        , tmpReceipt AS (SELECT tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) AS  GoodsKindId
                              , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                         FROM tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
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
                         GROUP BY tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                  
                        )

          -- факт цена продажи
        , tmpMIContainer AS (SELECT tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                  , SUM (tmpContainer.OperCountPartner)  AS OperCount_sale
                                  , SUM (tmpContainer.SummInPartner)     AS SummIn_sale
                             FROM
                                 (SELECT MIContainer.ObjectId_Analyzer       AS GoodsId
                                       , CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer, 0) = 0 THEN zc_GoodsKind_Basis() ELSE MIContainer.ObjectIntId_analyzer END AS GoodsKindId
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

                                  FROM tmpAnalyzer
                                       INNER JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                       AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate--inStartDate AND inEndDate
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.MovementDescId = zc_Movement_Sale()
                                  GROUP BY MIContainer.ObjectId_Analyzer
                                         , MIContainer.ObjectIntId_analyzer
                                  ) AS tmpContainer
                             GROUP BY tmpContainer.GoodsId
                                    , tmpContainer.GoodsKindId
                             )

        , tmpAll AS (-- факт цена продажи
                     SELECT COALESCE (tmpReceipt.ReceiptId, 0) AS ReceiptId
                          , tmpMIContainer.GoodsId
                          , tmpMIContainer.GoodsKindId
                            --
                          , SUM (tmpMIContainer.OperCount_sale)         AS OperCount_sale
                          , SUM (tmpMIContainer.SummIn_sale)            AS SummIn_sale
                          , 0 AS Summ3_cost
                     FROM tmpMIContainer
                          LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMIContainer.GoodsId
                                              AND tmpReceipt.GoodsKindId = tmpMIContainer.GoodsKindId
                     GROUP BY COALESCE (tmpReceipt.ReceiptId, 0)
                            , tmpMIContainer.GoodsId
                            , tmpMIContainer.GoodsKindId

                    UNION ALL
                     -- Сумма затрат из рецептуры - только если были Продажи
                     SELECT tmp.ReceiptId
                          , tmpMI.GoodsId
                          , tmpMI.GoodsKindId
                            --
                          , 0 AS OperCount_sale
                          , 0 AS SummIn_sale
                          , SUM (tmp.Summ3_cost) AS Summ3_cost
                     FROM (SELECT tmpChildReceiptTable.ReceiptId
                                , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.GoodsId_out ELSE 0 END) AS GoodsId_isCost
                                , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost
                           FROM tmpChildReceiptTable
                           WHERE tmpChildReceiptTable.ReceiptId_from = 0
                           GROUP BY tmpChildReceiptTable.ReceiptId
                          ) AS tmp
                          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                               ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                              AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                               ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                              AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                          -- факт цена продажи
                          INNER JOIN (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                      FROM tmpMIContainer
                                      -- только если были Продажи
                                      WHERE tmpMIContainer.OperCount_sale <> 0
                                      GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                     ) AS tmpMI ON tmpMI.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                               AND tmpMI.GoodsKindId = COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                     GROUP BY tmp.ReceiptId
                            , tmpMI.GoodsId
                            , tmpMI.GoodsKindId

                    UNION ALL
                     -- факт список из Акции
                     SELECT DISTINCT
                            tmpReceipt.ReceiptId
                          , tmpMI.GoodsId
                          , tmpMI.GoodsKindId
                            --
                          , 0 AS OperCount_sale
                          , 0 AS SummIn_sale
                          , 0 AS Summ3_cost
                     FROM tmpMI
                          LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI.GoodsId
                                              AND tmpReceipt.GoodsKindId = tmpMI.GoodsKindId
                     -- если установлен GoodsKind
                     WHERE tmpMI.GoodsKindId > 0
                    )

          -- цена с/с  план - новая схема по прайсу 47-ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)
        , tmpPrice1_plan AS (SELECT tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
                                  , SUM (CASE WHEN ObjectFloatReceipt_Value.ValueData > 0
                                                  THEN CAST (_calcChildReceiptTable.Amount_out * COALESCE (PriceList1_gk.Price, PriceList1.Price, 0) / ObjectFloatReceipt_Value.ValueData -- _calcChildReceiptTable.Amount_in
                                                             AS NUMERIC (16,2))
                                                  ELSE 0
                                         END) AS Price_47
                             FROM tmpReceipt

                                  INNER JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                                         ON ObjectFloatReceipt_Value.ObjectId = tmpReceipt.ReceiptId
                                                        AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

                                  INNER JOIN tmpChildReceiptTable AS _calcChildReceiptTable
                                                                  ON _calcChildReceiptTable.ReceiptId = tmpReceipt.ReceiptId
                                                                   -- без затрат
                                                                   AND _calcChildReceiptTable.isCost = FALSE
                                                                   -- без этого
                                                                   AND _calcChildReceiptTable.ReceiptId_from = 0

                                  /*INNER JOIN _calcChildReceiptTable ON _calcChildReceiptTable.ReceiptId = tmpReceipt.ReceiptId
                                                                   -- без затрат
                                                                   AND _calcChildReceiptTable.isCost = FALSE
                                                                   -- без этого
                                                                   AND _calcChildReceiptTable.ReceiptId_from = 0*/

                                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_gk ON PriceList1_gk.PriceListId = 18886 -- inPriceListId_1
                                                                                             AND PriceList1_gk.GoodsId     = _calcChildReceiptTable.GoodsId_out
                                                                                             AND PriceList1_gk.GoodsKindId = _calcChildReceiptTable.GoodsKindId_out
                                                                                             AND CURRENT_DATE >= PriceList1_gk.StartDate AND CURRENT_DATE < PriceList1_gk.EndDate

                                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = 18886 -- inPriceListId_1
                                                                                          AND PriceList1.GoodsId     = _calcChildReceiptTable.GoodsId_out
                                                                                          AND PriceList1.GoodsKindId = 0
                                                                                          AND CURRENT_DATE >= PriceList1.StartDate AND CURRENT_DATE < PriceList1.EndDate
                                                                                          AND PriceList1_gk.GoodsId IS NULL

                             GROUP BY tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
                            )

       INSERT INTO _tmpData_in (ReceiptId, GoodsId, GoodsKindId
                           , Price3_cost_real, Price3_cost, PriceSale, Price_cost, Price_cost_tax
                           , Price3_cost_all_real, Price3_cost_all, PriceSale_all, Price_cost_all, Price_cost_tax_all
                           , Price1_plan, ReceiptId_plan
                           , OperCount_sale, SummIn_sale
                           , Ord
                            )
       SELECT tmp.ReceiptId
            , tmp.GoodsId
            , tmp.GoodsKindId

              -- 1.0. цена затраты - старая схема - от затрат в рецептуре
            , tmp.Price3_cost AS Price3_cost_real

              -- 1.1. цена затраты - старая схема - от затрат в рецептуре
            , tmp.Price3_cost
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                 -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)

              -- 1.2. цена с/с
            , CASE WHEN tmp.OperCount_sale <> 0 THEN CAST (tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END AS PriceSale

              -- 1.3. цена с/с
            , COALESCE (tmp.Price3_cost,0)
              -- + затраты - старая схема
            + COALESCE (CASE WHEN tmp.OperCount_sale <> 0 THEN CAST ( tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END,0)
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                  -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)
              AS Price_cost

              -- 1.41. цена затраты - новая схема - от факт с/с
            , CASE WHEN tmp.OperCount_sale <> 0 THEN CAST (tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END
            * CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102() THEN 0.3 ELSE 0.5 END
              AS Price_cost_tax

              -- 2.0. цена затраты - старая схема - от затрат в рецептуре
            , tmp_all.Price3_cost AS Price3_cost_all_real

              -- 2.1. цена затраты - старая схема - от затрат в рецептуре
            , tmp_all.Price3_cost
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                  -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)
              AS Price3_cost_all

              -- 2.2. цена с/с
            , CASE WHEN tmp_all.OperCount_sale <> 0 THEN CAST (tmp_all.SummIn_sale / tmp_all.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END AS PriceSale_all
              -- 2.3. цена с/с
            , COALESCE (tmp_all.Price3_cost,0)
              -- + затраты - старая схема
            + COALESCE (CASE WHEN tmp_all.OperCount_sale <> 0 THEN CAST ( tmp_all.SummIn_sale / tmp_all.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END,0)
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                  -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)
              AS Price_cost_all

              -- 2.4. цена затраты - новая схема - от факт с/с
            , CASE WHEN tmp_all.OperCount_sale <> 0 THEN CAST (tmp_all.SummIn_sale / tmp_all.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END
            * CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102() THEN 0.3 ELSE 0.5 END
              AS Price_cost_tax_all

             -- 3. цена с/с  план - новая схема по прайсу 47-ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)
            , tmpPrice1_plan.Price_47  AS Price1_plan
            , tmpPrice1_plan.ReceiptId AS ReceiptId_plan

            , tmp.OperCount_sale
            , tmp.SummIn_sale

              -- № п/п
            , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId) AS Ord

       FROM (SELECT MAX (tmpAll.ReceiptId) AS ReceiptId
                  , tmpAll.GoodsId
                  , tmpAll.GoodsKindId
                  , SUM (tmpAll.OperCount_sale) AS OperCount_sale
                  , SUM (tmpAll.SummIn_sale)    AS SummIn_sale
                --, SUM (tmpAll.Summ3_cost)     AS Summ3_cost
                  , MAX (CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 2)) ELSE 0 END) AS Price3_cost
             FROM tmpAll
                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                         ON ObjectFloat_Value.ObjectId = tmpAll.ReceiptId
                                        AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()
             GROUP BY tmpAll.GoodsId
                    , tmpAll.GoodsKindId
            ) AS tmp
             LEFT JOIN (SELECT tmpAll.GoodsId
                             , SUM (tmpAll.OperCount_sale) AS OperCount_sale
                             , SUM (tmpAll.SummIn_sale)    AS SummIn_sale
                           --, SUM (tmpAll.Summ3_cost)     AS Summ3_cost
                             , MAX (CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 2)) ELSE 0 END) AS Price3_cost
                        FROM tmpAll
                              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = tmpAll.ReceiptId
                                                   AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()
                        GROUP BY tmpAll.GoodsId
                       ) AS tmp_all
                         ON tmp_all.GoodsId = tmp.GoodsId
             --
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmp.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                         ON ObjectFloat_Goods_Weight.ObjectId = tmp.GoodsId
                                        AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          -- 1497 - ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
          LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = 11812271
                                                                  AND PriceList3.GoodsId     = tmp.GoodsId
                                                                  AND PriceList3.GoodsKindId = tmp.GoodsKindId
                                                                  AND CASE WHEN vbEndDate < '01.01.2025' THEN '01.01.2025' ELSE vbEndDate END >= PriceList3.StartDate
                                                                  AND CASE WHEN vbEndDate < '01.01.2025' THEN '01.01.2025' ELSE vbEndDate END < PriceList3.EndDate
                                                                  -- убрали ТРУД
                                                                  AND 1=0

          -- цена с/с  план - новая схема по прайсу 47-ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)
          LEFT JOIN tmpPrice1_plan ON tmpPrice1_plan.GoodsId     = tmp.GoodsId
                                  AND tmpPrice1_plan.GoodsKindId = tmp.GoodsKindId
      ;

     -- сохраняем полученную с/с
     PERFORM 
             -- план  = план ИЛИ факт с/с * 110 % + затраты
            lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), MovementItem.Id
                                             , 
case when vbUserId = 5 AND 1=0 then COALESCE (_tmpData_in.Price1_plan, 0)
else
                                               -- затраты - !!!СТАРАЯ СХЕМА - товар "расходы..."!!!
                                               CASE WHEN _tmpData_in.PriceSale > 0
                                                         THEN COALESCE (_tmpData_in.Price3_cost, 0)
                                                    ELSE COALESCE (_tmpData_in_all.Price3_cost_all, 0)
                                               END

                                               -- план с/с - Новая схема
                                             + CASE WHEN _tmpData_in.Price1_plan > 0 THEN _tmpData_in.Price1_plan

                                                    ELSE -- факт с/с * 110 %
                                                         CAST (1.1 * CASE WHEN _tmpData_in.PriceSale > 0
                                                                              THEN _tmpData_in.PriceSale
                                                                          ELSE COALESCE (_tmpData_in_all.PriceSale_all, 0)
                                                                     END
                                                               AS NUMERIC (16, 2))
                                               END
end
                                              )
           ,  -- план  = план ИЛИ факт с/с * 110 % + затраты
            lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1_Calc(), MovementItem.Id               --всегда сохраняем  паралельно расчетные, т.к с/с можно менять в гриде
                                             , -- затраты - !!!СТАРАЯ СХЕМА - товар "расходы..."!!!
                                               CASE WHEN _tmpData_in.PriceSale > 0
                                                         THEN COALESCE (_tmpData_in.Price3_cost, 0)
                                                    ELSE COALESCE (_tmpData_in_all.Price3_cost_all, 0)
                                               END

                                               -- план с/с - Новая схема
                                             + CASE WHEN _tmpData_in.Price1_plan > 0 THEN _tmpData_in.Price1_plan

                                                    ELSE -- факт с/с * 110 %
                                                         CAST (1.1 * CASE WHEN _tmpData_in.PriceSale > 0
                                                                              THEN _tmpData_in.PriceSale
                                                                          ELSE COALESCE (_tmpData_in_all.PriceSale_all, 0)
                                                                     END
                                                               AS NUMERIC (16, 2))
                                               END
                                              )

             -- !!!затраты - новая схема - товар "расходы..."!!!
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePrice(), MovementItem.Id, COALESCE (_tmpData_in_all.Price3_cost_all, _tmpData_in.Price3_cost, 0))

     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

          -- цены с учетом GoodsKindId
          LEFT JOIN _tmpData_in ON _tmpData_in.GoodsId     = MovementItem.ObjectId
                            AND _tmpData_in.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                            -- AND _tmpData_in.PriceSale > 0
                            AND MILinkObject_GoodsKind.ObjectId > 0
          -- цены БЕЗ учета GoodsKindId
          LEFT JOIN _tmpData_in AS _tmpData_in_all
                             ON _tmpData_in_all.GoodsId = MovementItem.ObjectId
                            AND _tmpData_in_all.Ord     = 1
                            -- если не нашли с учетом GoodsKindId
                            -- AND _tmpData_in.GoodsId     IS NULL
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = FALSE
    ;

       -- сохранили протокол
       PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Master()
         AND MovementItem.isErased = FALSE
        ;
-----------------------------------


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.09.24         *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_PromoTradeHistory (inMovementId:= 29309489 , inSession:= zfCalc_UserAdmin())
