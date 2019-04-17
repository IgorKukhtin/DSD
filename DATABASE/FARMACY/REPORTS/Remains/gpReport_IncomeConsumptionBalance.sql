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
  vbEndDate := DATE_TRUNC ('DAY', inEndDate);

     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                   AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr =  '172.17.2.4') AS Value2
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr <> '172.17.2.4') AS Value3
             , 0 AS Value4
             , 0 AS Value5
             , CLOCK_TIMESTAMP() AS Time1
             , CLOCK_TIMESTAMP() AS Time2
             , CLOCK_TIMESTAMP() AS Time3
             , CLOCK_TIMESTAMP() AS Time4
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpReport_IncomeConsumptionBalance'
               -- ProtocolData
             , ''
        WHERE vbUserId > 0
        ;


  OPEN cur1 FOR
  WITH
    tmpContainer AS (
                        SELECT AnalysisContainer.UnitID                                                      AS UnitID
                             , AnalysisContainer.GoodsId                                                     AS GoodsId
                             , SUM(AnalysisContainer.Saldo)::TFloat                                          AS Saldo
                             , SUM((AnalysisContainer.Saldo  *
                                 AnalysisContainer.Price)::NUMERIC (16, 2))::TFloat                          AS Summa
                        FROM AnalysisContainer AS AnalysisContainer
                        GROUP BY AnalysisContainer.UnitID
                               , AnalysisContainer.GoodsId
                        ),

    tmpSaldoOut AS (
                        SELECT MovementItem.UnitID                                                       AS UnitID
                             , MovementItem.GoodsId                                                      AS GoodsId
                             , SUM(MovementItem.Saldo)                                                   AS Saldo
                             , SUM(MovementItem.SaldoSum)                                                AS Summa
                        FROM AnalysisContainerItem AS MovementItem
                        WHERE MovementItem.Operdate > vbEndDate
                        GROUP BY MovementItem.UnitID
                               , MovementItem.GoodsId ),

    tmContainerItem AS (SELECT
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
                  
                          , SUM(AnalysisContainerItem.Saldo)                   AS Saldo
                          , SUM(AnalysisContainerItem.SaldoSum)                AS Summa
                  
                          , Count(*)                                           AS CountItem
                        FROM AnalysisContainerItem AS AnalysisContainerItem
                        WHERE AnalysisContainerItem.Operdate >= vbStartDate
                          AND AnalysisContainerItem.Operdate <= vbEndDate
                        GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsId
                        )

  , tmpGoodsChecked AS (SELECT DISTINCT MI_Goods.ObjectId  AS GoodsId
                        FROM Movement
                          INNER JOIN MovementItem AS MI_Goods 
                                                  ON MI_Goods.MovementId = Movement.Id
                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                 AND MI_Goods.isErased = FALSE
                          INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                         ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                        AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                        AND MIBoolean_Checked.ValueData = TRUE
                        WHERE Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.DescId = zc_Movement_Promo()
                        )


    SELECT
        Object_Parent.ValueData              AS ParentName
      , Object_Unit.ValueData                AS UnitName

      , Object_Goods.ObjectCode              AS GoodsId
      , Object_Goods.ValueData               AS GoodsName

      , tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0) - 
           COALESCE(tmpMovement.Saldo, 0)    AS SaldoIn
      , tmpContainer.Summa - COALESCE(tmpSaldoOut.Summa, 0) - 
           COALESCE(tmpMovement.Summa, 0)    AS SummaIn

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

      , tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0)    AS SaldoOut
      , tmpContainer.Summa - COALESCE(tmpSaldoOut.Summa, 0)    AS SummaOut

      , CASE WHEN tmpGoodsChecked.GoodsId IS NOT NULL THEN TRUE ELSE FALSE END  ::Boolean  AS isChecked
      , CASE WHEN tmpGoodsChecked.GoodsId IS NULL     THEN TRUE ELSE FALSE END  ::Boolean  AS isReport
    FROM tmpContainer as tmpContainer
    
        LEFT JOIN tmpSaldoOut AS tmpSaldoOut 
                              ON tmpSaldoOut.UnitID = tmpContainer.UnitID
                             AND tmpSaldoOut.GoodsId = tmpContainer.GoodsId

        LEFT JOIN tmContainerItem AS tmpMovement 
                                  ON tmpMovement.UnitID = tmpContainer.UnitID
                                 AND tmpMovement.GoodsId = tmpContainer.GoodsId

        INNER JOIN Object AS Object_Unit  ON Object_Unit.Id  = tmpContainer.UnitID
        INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContainer.GoodsId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent
                         ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

        LEFT JOIN tmpGoodsChecked ON tmpGoodsChecked.GoodsId = tmpContainer.GoodsId

    WHERE COALESCE(tmpMovement.CountItem, tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0)) <> 0
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
               , Sum(CASE WHEN AnalysisContainerItem.OperDate <= vbEndDate THEN
                    AnalysisContainerItem.AmountCheck END)                                  AS Amount
               , Sum(CASE WHEN AnalysisContainerItem.OperDate <= vbEndDate THEN
                   AnalysisContainerItem.Saldo END)                                         AS Saldo
          FROM AnalysisContainerItem AS AnalysisContainerItem
          WHERE AnalysisContainerItem.OperDate >= vbStartDate
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
        Movement.InvNumber AS PromoId
      , Object_Goods.ObjectCode AS GoodsId
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
             Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 12.11.18       *               
 24.05.18                                                      *
*/

-- тест
-- select * from gpReport_IncomeConsumptionBalance(inStartDate := ('01.04.2018')::TDateTime , inEndDate := ('30.04.2018')::TDateTime , inSession := '3');
