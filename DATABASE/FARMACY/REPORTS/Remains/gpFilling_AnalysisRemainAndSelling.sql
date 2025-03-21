-- Function:  gpFilling_AnalysisRemainAndSelling()

DROP FUNCTION IF EXISTS gpFilling_AnalysisRemainAndSelling ();

CREATE OR REPLACE FUNCTION gpFilling_AnalysisRemainAndSelling ()
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

  DROP TABLE IF EXISTS AnalysisContainerTemp;
  CREATE TABLE AnalysisContainerTemp
  (
    Id               SERIAL    NOT NULL PRIMARY KEY,
    UnitID           INTEGER,
    GoodsId          INTEGER,

    Price            TFloat    NOT NULL DEFAULT 0,
    PriceWith        TFloat    NOT NULL DEFAULT 0,

    Saldo            TFloat    NOT NULL DEFAULT 0  )
  WITH (
    OIDS=FALSE
  );
  ALTER TABLE AnalysisContainerTemp
    OWNER TO postgres;

    -- Заполняем текуший остаток с ценами по партиям
  INSERT INTO AnalysisContainerTemp (
    ID,
    UnitID,
    GoodsId,
    Price,
    PriceWith,
    Saldo)
  SELECT Container.Id
       , Container.WhereObjectId
       , Container.ObjectId
       , COALESCE (MIFloat_JuridicalPrice.ValueData, 0)   AS Price
       , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)  AS PriceWith
       , Container.Amount
  FROM Container
        -- партия
       LEFT OUTER JOIN ContainerLinkObject AS CLI_MI
                                           ON CLI_MI.ContainerId = Container.Id
                                          AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                   ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()

         -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
       LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                   ON MIFloat_JuridicalPrice.MovementItemId = COALESCE (MIFloat_MovementItem.ValueData :: Integer, Object_PartionMovementItem.ObjectCode)
                                  AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()

         -- цена без учета НДС, для элемента прихода от поставщика (или NULL)
       LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                   ON MIFloat_PriceWithOutVAT.MovementItemId = COALESCE (MIFloat_MovementItem.ValueData :: Integer, Object_PartionMovementItem.ObjectCode)
                                  AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()

  WHERE Container.DescId = zc_Container_count();

  CREATE INDEX idx_AnalysisContainerTemp_Id_UnitId_GoodsId_Saldo ON AnalysisContainerTemp(ID, UnitId, GoodsId, Saldo, Price);
  
  ANALYSE AnalysisContainerTemp;

  DROP TABLE IF EXISTS AnalysisContainerItemTemp;
  CREATE TABLE AnalysisContainerItemTemp
  (
    Id                      SERIAL    NOT NULL PRIMARY KEY,

    UnitID                  INTEGER,
    GoodsId                 INTEGER,

    OperDate                TDateTime,

    AmountIncome            TFloat,  -- Приход
    AmountIncomeSumWith     TFloat,
    AmountIncomeSum         TFloat,

    AmountReturnOut         TFloat,  -- Возврат поставщику
    AmountReturnOutSum      TFloat,

    AmountCheck             TFloat,  -- Кассовый чек
    AmountCheckSumJuridical TFloat,
    AmountCheckSum          TFloat,

    AmountReturnIn             TFloat,  -- Возврат покупателя
    AmountReturnInSumJuridical TFloat,
    AmountReturnInSum          TFloat,

    AmountSale              TFloat,  -- Продажа
    AmountSaleSumJuridical  TFloat,
    AmountSaleSum           TFloat,

    AmountInventory         TFloat,  -- Переучет
    AmountInventorySum      TFloat,

    AmountLoss              TFloat,  -- Списание
    AmountLossSum           TFloat,

    AmountSend              TFloat,  -- Перемещение
    AmountSendSum           TFloat,

    Saldo                   TFloat    NOT NULL DEFAULT 0,
    SaldoSum                TFloat    NOT NULL DEFAULT 0
  )
  WITH (
    OIDS=FALSE
  );
  ALTER TABLE AnalysisContainerItemTemp
    OWNER TO postgres;

  INSERT INTO AnalysisContainerItemTemp (
    UnitID,
    GoodsId,

    OperDate,

    AmountIncome,
    AmountIncomeSumWith,
    AmountIncomeSum,

    AmountReturnOut,
    AmountReturnOutSum,

    AmountCheck,
    AmountCheckSumJuridical,
    AmountCheckSum,

    AmountReturnIn,
    AmountReturnInSumJuridical,
    AmountReturnInSum,

    AmountSale,
    AmountSaleSumJuridical,
    AmountSaleSum,

    AmountInventory,
    AmountInventorySum,

    AmountLoss,
    AmountLossSum,

    AmountSend,
    AmountSendSum,

    Saldo,
    SaldoSum)

      SELECT
          AnalysisContainer.UnitID
        , AnalysisContainer.GoodsId
        , DATE_TRUNC ('DAY', MovementItemAll.OperDate)

        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Income() then
            MovementItemAll.Amount end)                                                AS AmountIncome       -- Приход
        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Income() then
            (MovementItemAll.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountIncomeSumWith
        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Income() then
            (MovementItemAll.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountIncomeSum

        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_ReturnOut() then
           MovementItemAll.Amount end)                                                 AS AmountReturnOut   -- Возврат поставщику
        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_ReturnOut() then
            (MovementItemAll.Amount * COALESCE (MIFloat_Price.ValueData, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountReturnOutSum

        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_Check() then
            MovementItemAll.Amount end)                                                AS AmountCheck       -- Кассовый чек
        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_Check() then
            (MovementItemAll.Amount * COALESCE ( AnalysisContainer.Price, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountCheckSumJuridical
        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_Check() then
            (MovementItemAll.Amount * COALESCE (MIFloat_Price.ValueData, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountCheckSum

        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_ReturnIn() then
          MovementItemAll.Amount end)                                                  AS AmountReturnIn    -- Возвраты покупателей
        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_ReturnIn() then
          (MovementItemAll.Amount * COALESCE ( AnalysisContainer.Price, 0))
          ::NUMERIC (16, 2) end)::TFloat                                               AS AmountReturnInSumJuridical
        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_ReturnIn() then
          (MovementItemAll.Amount * COALESCE (MIFloat_Price.ValueData, 0))
          ::NUMERIC (16, 2) end)::TFloat                                               AS AmountReturnInSum

        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_Sale() then
            MovementItemAll.Amount end)                                                AS AmountSale        -- Продажа
        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_Sale() then
            (MovementItemAll.Amount * COALESCE ( AnalysisContainer.Price, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountSaleSumJuridical
        , - SUM(case when MovementItemAll.MovementDescId = zc_Movement_Sale() then
            (MovementItemAll.Amount * COALESCE (MIFloat_Price.ValueData, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountSaleSum

        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Inventory() then
            MovementItemAll.Amount end)                                                AS AmountInventory   -- Переучет
        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Inventory() then
            (MovementItemAll.Amount * COALESCE (MIFloat_Price.ValueData, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountInventorySum

        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Loss() then
            MovementItemAll.Amount end)                                                AS AmountLoss        -- Списание
        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Loss() then
            (MovementItemAll.Amount * COALESCE (MIFloat_Price.ValueData, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountLossSum

        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Send() then
            MovementItemAll.Amount end)                                                AS AmountSend        -- Перемещение
        , SUM(case when MovementItemAll.MovementDescId = zc_Movement_Send() then
            (MovementItemAll.Amount * COALESCE ( AnalysisContainer.Price, 0))
            ::NUMERIC (16, 2) end)::TFloat                                             AS AmountSendSum

        , SUM(MovementItemAll.Amount)                                                  AS Saldo
        , SUM(MovementItemAll.Amount * COALESCE ( AnalysisContainer.Price, 0))
            ::NUMERIC (16, 2)::TFloat                                                  AS SaldoSum

      FROM AnalysisContainerTemp AS  AnalysisContainer
        INNER JOIN MovementItemContainer AS MovementItemAll
                                         ON MovementItemAll.ContainerId =  AnalysisContainer.Id

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItemAll.movementitemid
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                    ON MIFloat_JuridicalPrice.MovementItemId = MovementItemAll.movementitemid
                                   AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()

        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                    ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItemAll.movementitemid
                                   AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()

      GROUP BY  AnalysisContainer.UnitID, AnalysisContainer.GoodsId, DATE_TRUNC ('DAY', MovementItemAll.OperDate);

  DROP INDEX idx_AnalysisContainerTemp_Id_UnitId_GoodsId_Saldo;
  
  DROP TABLE IF EXISTS AnalysisContainer;
  ALTER TABLE AnalysisContainerTemp RENAME TO AnalysisContainer;
  CREATE INDEX idx_AnalysisContainer_UnitId_GoodsId_Saldo ON AnalysisContainer(UnitId, GoodsId, Saldo);

  DROP TABLE IF EXISTS AnalysisContainerItem;
  ALTER TABLE AnalysisContainerItemTemp RENAME TO AnalysisContainerItem;
  CREATE INDEX idx_AnalysisContainerItem_UnitId_GoodsId_OperDate_Saldo ON AnalysisContainerItem(UnitId, GoodsId, OperDate, Saldo);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 10.02.20        *
 07.08.18        *
 07.07.18        *
 25.05.18        *
 15.04.18        *

*/

-- тест
-- SELECT * FROM gpFilling_AnalysisRemainAndSelling();
-- SELECT Count(*) FROM AnalysisRemainsUnit;
-- SELECT Count(*) FROM AnalysisSellingDeyUnit;
-- SELECT Count(*) FROM AnalysisContainer;
-- SELECT Count(*) FROM AnalysisContainerItem;    -- 45771425
