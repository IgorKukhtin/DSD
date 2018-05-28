-- Function: gpReport_IncomeConsumptionBalance()

DROP FUNCTION IF EXISTS gpReport_IncomeConsumptionBalance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeConsumptionBalance(
    IN inStartDate     TDateTime , -- Начало периода
    IN inEndDate       TDateTime , -- Конец периода
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE cur3 refcursor;
   DECLARE cur4 refcursor;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

  vbStartDate := DATE_TRUNC ('DAY', inStartDate);
  vbEndDate := DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY';

  OPEN cur1 FOR
  WITH
    tmpContainer AS (
                        SELECT tmpContainer_AllPrice.Id
                             , tmpContainer_AllPrice.UnitID                                                      AS UnitID
                             , tmpContainer_AllPrice.GoodsId                                                     AS GoodsId
                             , (tmpContainer_AllPrice.Saldo - COALESCE(SUM(MovementItem.Amount), 0))::TFloat     AS SaldoIn
                             , (((tmpContainer_AllPrice.Saldo - COALESCE(SUM(MovementItem.Amount), 0)) *
                                 tmpContainer_AllPrice.Price)::NUMERIC (16, 2))::TFloat                          AS SummaIn
                             , (tmpContainer_AllPrice.Saldo - COALESCE(SUM(CASE WHEN
                                 MovementItem.Operdate >= vbEndDate THEN MovementItem.Amount
                                 ELSE 0 END), 0))::TFloat                                                        AS SaldoOut
                             , (((tmpContainer_AllPrice.Saldo - COALESCE(SUM(CASE WHEN
                                 MovementItem.Operdate >= vbEndDate THEN MovementItem.Amount
                                 ELSE 0 END), 0)) * tmpContainer_AllPrice.Price)::NUMERIC (16, 2))::TFloat       AS SummaOut
                        FROM AnalysisContainer AS tmpContainer_AllPrice
                           LEFT JOIN MovementItemContainer AS MovementItem
                                                           ON MovementItem.ContainerId = tmpContainer_AllPrice.Id
                                                          AND MovementItem.Operdate >= vbStartDate
                        GROUP BY tmpContainer_AllPrice.Id
                               , tmpContainer_AllPrice.UnitID
                               , tmpContainer_AllPrice.GoodsId
                               , tmpContainer_AllPrice.Saldo
                               , tmpContainer_AllPrice.Price),

    tmpSaldo AS (
                        SELECT tmpContainer.UnitID                                               AS UnitID
                             , tmpContainer.GoodsId                                              AS GoodsId
                             , Sum(tmpContainer.SaldoIn)                                         AS SaldoIn
                             , Sum(tmpContainer.SummaIn)                                         AS SummaIn
                             , Sum(tmpContainer.SaldoOut)                                        AS SaldoOut
                             , Sum(tmpContainer.SummaOut)                                        AS SummaOut
                        FROM tmpContainer AS tmpContainer
                        GROUP BY tmpContainer.UnitID, tmpContainer.GoodsId),

    tmContainerItem AS (
      SELECT
          AnalysisContainerItem.UnitID                       AS UnitID
        , AnalysisContainerItem.GoodsId                      AS GoodsId

        , SUM(AnalysisContainerItem.AmountIncome)            AS AmountIncome             -- Приход
        , SUM(AnalysisContainerItem.AmountIncomeSumWith)     AS AmountIncomeSumWith
        , SUM(AnalysisContainerItem.AmountIncomeSum)         AS AmountIncomeSum

        , SUM(AnalysisContainerItem.AmountReturnOut)         AS AmountReturnOut          -- Возврат поставщику
        , SUM(AnalysisContainerItem.AmountReturnOutSum)      AS AmountReturnOutSum

        , SUM(AnalysisContainerItem.AmountCheck)             AS AmountCheck              -- Кассовый чек
        , SUM(AnalysisContainerItem.AmountCheckSumJuridical) AS AmountCheckSumJuridical
        , SUM(AnalysisContainerItem.AmountCheckSum)          AS AmountCheckSum

        , SUM(AnalysisContainerItem.AmountSale)              AS AmountSale               -- Продажа
        , SUM(AnalysisContainerItem.AmountSaleSumJuridical)  AS AmountSaleSumJuridical
        , SUM(AnalysisContainerItem.AmountSaleSum)           AS AmountSaleSum

        , SUM(AnalysisContainerItem.AmountInventory)         AS AmountInventory          -- Переучет
        , SUM(AnalysisContainerItem.AmountInventorySum)      AS AmountInventorySum

        , SUM(AnalysisContainerItem.AmountLoss)              AS AmountLoss               -- Списание
        , SUM(AnalysisContainerItem.AmountLossSum)           AS AmountLossSum

        , SUM(AnalysisContainerItem.AmountSend)              AS AmountSend               -- Перемещение
        , SUM(AnalysisContainerItem.AmountSendSum)           AS AmountSendSum

        , Count(*)                                           AS CountItem
      FROM AnalysisContainerItem AS AnalysisContainerItem
      WHERE AnalysisContainerItem.Operdate >= vbStartDate
        AND AnalysisContainerItem.Operdate < vbEndDate
      GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsId)

    SELECT
        Object_Parent.ValueData              AS ParentName
      , Object_Unit.ValueData                AS UnitName

      , Object_Goods.ObjectCode              AS GoodsId
      , Object_Goods.ValueData               AS GoodsName

      , tmpSaldo.SaldoIn                     AS SaldoIn
      , tmpSaldo.SummaIn                     AS SummaIn

      , tmpMovement.AmountIncome             AS AmountIncome       -- Приход
      , tmpMovement.AmountIncomeSumWith      AS AmountIncomeSumWith
      , tmpMovement.AmountIncomeSum          AS AmountIncomeSum

      , tmpMovement.AmountReturnOut          AS AmountReturnOut   -- Возврат поставщику
      , tmpMovement.AmountReturnOutSum       AS AmountReturnOutSum

      , tmpMovement.AmountCheck              AS AmountCheck       -- Кассовый чек
      , tmpMovement.AmountCheckSumJuridical  AS AmountCheckSumJuridical
      , tmpMovement.AmountCheckSum           AS AmountCheckSum

      , tmpMovement.AmountSale               AS AmountSale        -- Продажа
      , tmpMovement.AmountSaleSumJuridical   AS AmountSaleSumJuridical
      , tmpMovement.AmountSaleSum            AS AmountSaleSum

      , tmpMovement.AmountInventory          AS AmountInventory   -- Переучет
      , tmpMovement.AmountInventorySum       AS AmountInventorySum

      , tmpMovement.AmountLoss               AS AmountLoss        -- Списание
      , tmpMovement.AmountLossSum            AS AmountLossSum

      , tmpMovement.AmountSend               AS AmountSend        -- Перемещение
      , tmpMovement.AmountSendSum            AS AmountSendSum

      , tmpSaldo.SaldoOut                    AS SaldoOut
      , tmpSaldo.SummaOut                    AS SummaOut

    FROM tmpSaldo as tmpSaldo

        LEFT JOIN tmContainerItem AS tmpMovement ON tmpMovement.UnitID = tmpSaldo.UnitID
                                 AND tmpMovement.GoodsId = tmpSaldo.GoodsId

        INNER JOIN Object AS Object_Unit
                          ON Object_Unit.ID = tmpSaldo.UnitID
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = tmpSaldo.GoodsId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent
                         ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

    WHERE COALESCE(tmpMovement.CountItem, tmpSaldo.SaldoOut) > 0
    ORDER BY Object_Goods.ObjectCode, Object_Parent.ValueData, Object_Unit.ValueData;

    RETURN NEXT cur1;

       -- Медикаменты
    OPEN cur2 FOR
        SELECT DISTINCT
           Object_Goods.ObjectCode       AS GoodsId
         , Object_Goods.ValueData        AS GoodsName
    FROM
     (SELECT 
        AnalysisContainer.GoodsId
      FROM (SELECT
           AnalysisContainer.UnitId,
           AnalysisContainer.GoodsId,
           Sum(AnalysisContainer.Saldo) AS Saldo
         FROM AnalysisContainer
         GROUP BY AnalysisContainer.UnitId, AnalysisContainer.GoodsId) AS AnalysisContainer

         LEFT OUTER JOIN
         (SELECT AnalysisContainerItem.UnitID                                               AS UnitID
               , AnalysisContainerItem.GoodsId                                              AS GoodsId
               , Sum(CASE WHEN AnalysisContainerItem.OperDate < '2018-05-01'::TDateTime THEN
                    AnalysisContainerItem.AmountCheck END)                                  AS Amount
               , Sum(CASE WHEN AnalysisContainerItem.OperDate >= '2018-05-01'::TDateTime THEN
                   AnalysisContainerItem.Saldo END)                                         AS Saldo
          FROM AnalysisContainerItem AS AnalysisContainerItem
          WHERE AnalysisContainerItem.OperDate >= '2018-04-01'::TDateTime
          GROUP BY AnalysisContainerItem.UnitID
                 , AnalysisContainerItem.GoodsId) AS AnalysisContainerItem
          ON AnalysisContainer.UnitId = AnalysisContainerItem.UnitId AND
             AnalysisContainer.GoodsId = AnalysisContainerItem.GoodsId

      WHERE ((AnalysisContainer.Saldo - COALESCE(AnalysisContainerItem.Saldo, 0)) <> 0 OR
             COALESCE(AnalysisContainerItem.Amount, 0) <> 0)) AS T1

         INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = T1.GoodsId
      ORDER BY Object_Goods.ValueData;

    RETURN NEXT cur2;

      -- Маркетинговые контракты
    OPEN cur3 FOR
    SELECT DISTINCT
       Movement.InvNumber AS PromoID
     , Object_Maker.valuedata AS MakerName
    FROM Movement
       INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                     ON MovementLinkObject_Maker.MovementId = Movement.Id
                                    AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
       LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId
    WHERE Movement.StatusId = zc_Enum_Status_Complete()
      AND Movement.DescId = zc_Movement_Promo();
    RETURN NEXT cur3;

      -- Товары маркетинговых контрактов
    OPEN cur4 FOR
    SELECT DISTINCT
        Movement.InvNumber AS PromoID
      , Object_Goods.ObjectCode AS GoodsID
    FROM Movement
      INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                         AND MI_Goods.DescId = zc_MI_Master()
                                         AND MI_Goods.isErased = FALSE
      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Goods.ObjectId
    WHERE Movement.StatusId = zc_Enum_Status_Complete()
      AND Movement.DescId = zc_Movement_Promo();
    RETURN NEXT cur4;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 24.05.18        *
*/

-- тест
-- select * from gpReport_IncomeConsumptionBalance(inStartDate := ('01.04.2018')::TDateTime , inEndDate := ('30.04.2018')::TDateTime , inSession := '3');
