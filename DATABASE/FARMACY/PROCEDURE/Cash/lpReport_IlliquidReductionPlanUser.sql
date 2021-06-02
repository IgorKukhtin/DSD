-- Function: lpReport_IlliquidReductionPlanUser()

DROP FUNCTION IF EXISTS lpReport_IlliquidReductionPlanUser (Integer);

CREATE OR REPLACE FUNCTION lpReport_IlliquidReductionPlanUser(
    IN inUserID        Integer    -- сессия пользователя
)
RETURNS TABLE (GoodsID Integer)
AS
$BODY$
   DECLARE vbUnitId Integer;
   DECLARE vbIlliquidUnitId Integer;
   DECLARE vbProcGoods TFloat;
   DECLARE vbProcUnit TFloat;
   DECLARE vbPenalty TFloat;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', CURRENT_DATE);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');

      -- Мовементы по сотруднику
    CREATE TEMP TABLE tmpMovement (
            MovementID         Integer,

            OperDate           TDateTime,
            UnitID             Integer,
            ConfirmedKind      Boolean

      ) ON COMMIT DROP;

       -- Добовляем простые продажи
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                      AS ID
         , date_trunc('day', MovementDate_Insert.ValueData) AS OperDate
         , MovementLinkObject_Unit.ObjectId                 AS UnitId
         , False                                            AS ConfirmedKind
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

          INNER JOIN MovementDate AS MovementDate_Insert
                                  ON MovementDate_Insert.MovementId = Movement.Id
                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

    WHERE /*MovementDate_Insert.ValueData >= vbDateStart
      AND MovementDate_Insert.ValueData < vbDateEnd*/
          Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND MovementLinkObject_Insert.ObjectId = inUserID
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

      -- Добовляем отборы
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                           AS ID
         , date_trunc('day', Movement.OperDate)  AS OperDate
         , MovementLinkObject_Unit.ObjectId      AS UnitId
         , True                                  AS ConfirmedKind
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                        ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                       AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
    WHERE Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND MovementLinkObject_UserConfirmedKind.ObjectId = inUserID
      AND MovementLinkObject_Insert.ObjectId IS NULL
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

    ANALYSE tmpMovement;

    IF NOT EXISTS(SELECT * FROM tmpMovement)
    THEN
      Return;
    END IF;

/*    WITH tmpCount AS (SELECT tmpMovement.UnitId
                           , count(*) AS CountCheck
                      FROM tmpMovement
                      GROUP BY tmpMovement.UnitId)
    SELECT tmpCount.UnitId
    INTO vbUnitId
    FROM tmpCount
    ORDER BY tmpCount.CountCheck DESC
    LIMIT 1;*/
    
     -- Основное подразделение по графику
    SELECT MILinkObject_Unit.ObjectId AS UnitId
    INTO vbUnitId
    FROM Movement
                                      
         INNER JOIN MovementItem AS MIMaster
                                 ON MIMaster.MovementId = Movement.ID
                                AND MIMaster.DescId = zc_MI_Master()
                                AND MIMaster.ObjectId   = inUserId
                                                                   
                                           
         INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MIMaster.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                                                 
    WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
      AND Movement.OperDate = vbDateStart;
    
      -- Товары без продаж
    CREATE TEMP TABLE tmpGoods (
            GoodsID         Integer,
            Remains         TFloat,
            RemainsOut      TFloat
      ) ON COMMIT DROP;

    IF EXISTS(SELECT 1
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId = vbUnitId

              WHERE Movement.OperDate >= vbDateStart
                AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                AND Movement.DescId = zc_Movement_IlliquidUnit()
                AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
       SELECT Movement.ID, MovementFloat_ProcGoods.ValueData, MovementFloat_ProcUnit.ValueData, MovementFloat_Penalty.ValueData
       INTO vbIlliquidUnitId, vbProcGoods, vbProcUnit, vbPenalty
       FROM Movement

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId

            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProcGoods
                                          ON MovementFloat_ProcGoods.MovementId = Movement.Id
                                         AND MovementFloat_ProcGoods.DescId = zc_MovementFloat_ProcGoods()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProcUnit
                                          ON MovementFloat_ProcUnit.MovementId = Movement.Id
                                         AND MovementFloat_ProcUnit.DescId = zc_MovementFloat_ProcUnit()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_Penalty
                                          ON MovementFloat_Penalty.MovementId = Movement.Id
                                         AND MovementFloat_Penalty.DescId = zc_MovementFloat_Penalty()

       WHERE Movement.OperDate >= vbDateStart
         AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
         AND Movement.DescId = zc_Movement_IlliquidUnit()
         AND Movement.StatusId = zc_Enum_Status_Complete()
       LIMIT 1;

       INSERT INTO tmpGoods (GoodsID, Remains, RemainsOut)
       SELECT MovementItem.ObjectId, MovementItem.Amount, 0
       FROM MovementItem
       WHERE MovementItem.MovementId = vbIlliquidUnitId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE;

    ELSE
       Return;
    END IF;
    ANALYSE tmpGoods;

    WITH tmpContainer AS (SELECT Container.WhereObjectId   AS UnitID
                               , Container.ObjectId        AS GoodsID
                               , SUM(Container.Amount)     AS Saldo
                          FROM Container
                          WHERE Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                          GROUP BY Container.WhereObjectId, Container.ObjectId
                         )
       , tmpCheck AS (SELECT MovementLinkObject_Unit.ObjectId                   AS UnitID
                           , MovementItem.ObjectID                              AS GoodsID
                           , SUM(MovementItem.Amount)                           AS Amount
                      FROM Movement
                           INNER JOIN MovementItem AS MovementItem
                                                   ON MovementItem.MovementId = Movement.ID
                                                  AND MovementItem.isErased   = FALSE
                                                  AND MovementItem.DescId     = zc_MI_Master()
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId

                      WHERE Movement.OperDate >= vbDateStart
                        AND Movement.OperDate < vbDateEnd
                        AND Movement.DescId = zc_Movement_Check()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      GROUP BY MovementLinkObject_Unit.ObjectId, MovementItem.ObjectID)
       , tmpRemains AS (SELECT Container.UnitID
                             , Container.GoodsID
                             , Container.Saldo                                  AS SaldoOut
                             , COALESCE(tmpCheck.Amount, 0)                     AS CheckAmount
                        FROM tmpContainer AS Container
                             LEFT JOIN tmpCheck AS tmpCheck
                                                ON tmpCheck.UnitID = Container.UnitID
                                               AND tmpCheck.GoodsID = Container.GoodsID)

    UPDATE tmpGoods SET RemainsOut = CASE WHEN SaldoOut.SaldoOut < Remains - SaldoOut.CheckAmount THEN SaldoOut.SaldoOut ELSE Remains - SaldoOut.CheckAmount END
    FROM (SELECT
                 Container.GoodsID               AS GoodsId
               , Container.SaldoOut::TFloat      AS SaldoOut
               , Container.CheckAmount::TFloat   AS CheckAmount
          FROM tmpRemains AS Container) AS SaldoOut
    WHERE tmpGoods.GoodsId = SaldoOut.GoodsId
      AND CASE WHEN SaldoOut.SaldoOut < Remains - SaldoOut.CheckAmount THEN SaldoOut.SaldoOut ELSE Remains - SaldoOut.CheckAmount END > 0;

    ANALYSE tmpGoods;

    CREATE TEMP TABLE tmpImplementation (
             GoodsId Integer,
             Amount TFloat
      ) ON COMMIT DROP;

    -- Заполняем данные по продажам
    INSERT INTO tmpImplementation
    SELECT tmpGoods.GoodsId                          AS GoodsId
         , Sum(-1 * MIC.Amount)::TFloat              AS Amount
    FROM (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods) tmpGoods

         INNER JOIN MovementItemContainer AS MIC
                                          ON MIC.ObjectId_Analyzer = tmpGoods.GoodsId
                                         AND MIC.OperDate >= vbDateStart
                                         AND MIC.OperDate < vbDateEnd
                                         AND MIC.MovementDescId = zc_Movement_Check()
                                         AND MIC.DescId = zc_MIContainer_Count()

         INNER JOIN tmpMovement ON tmpMovement.MovementId = MIC.MovementId

    GROUP BY tmpGoods.GoodsId
    HAVING Sum(-1 * MIC.Amount)::TFloat > 0;

       -- Вывод результата
     RETURN QUERY
     SELECT tmpGoods.GoodsId
                   FROM tmpGoods
                        LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpGoods.GoodsId
                        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                        LEFT JOIN tmpImplementation ON tmpImplementation.GoodsId = tmpGoods.GoodsId
                   WHERE tmpGoods.RemainsOut > 0 AND (COALESCE(tmpImplementation.Amount, 0) < 0.2 OR
                         CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0 ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.01.20                                                       *
*/

-- тест select * from lpReport_IlliquidReductionPlanUser(inUserID := 3997097);


SELECT * FROM lpReport_IlliquidReductionPlanUser(inUserID := '4093498')