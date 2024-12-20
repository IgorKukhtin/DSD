-- Function: gpReport_IlliquidReductionPlanUser()

DROP FUNCTION IF EXISTS gpReport_IlliquidReductionPlanUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IlliquidReductionPlanUser(
    IN inStartDate      TDateTime , -- Дата в месяце
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitName TVarChar;
   DECLARE vbIlliquidUnitId Integer;
   DECLARE vbNormOfManDays Integer;
   DECLARE vbManDays Integer;
   DECLARE vbProcUnitCorr Integer;
   DECLARE vbProcGoods TFloat;
   DECLARE vbProcUnit TFloat;
   DECLARE vbPlanAmount TFloat;
   DECLARE vbPenalty TFloat;
   DECLARE vbPenaltySum TFloat;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbDateIn TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', inStartDate);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');
    vbUserId := lpGetUserBySession (inSession);
    
    SELECT GetIlliquidReduction.ProcGoods
         , GetIlliquidReduction.ProcUnit
         , GetIlliquidReduction.PlanAmount
         , GetIlliquidReduction.Penalty 
         , GetIlliquidReduction.PenaltySum
    INTO vbProcGoods 
       , vbProcUnit
       , vbPlanAmount
       , vbPenalty
       , vbPenaltySum
    FROM gpReport_GetIlliquidReductionPlanUser (inStartDate, inSession) AS GetIlliquidReduction;


    IF inSession = '3'
    THEN
      vbUserId := 6002014;
    END IF;

    -- Начало работы
    vbDateIn := (SELECT MIN(Movement.OperDate + ((MIChild.Amount - 1)::Integer::tvarchar||' DAY')::INTERVAL)  AS DateIn
                 FROM Movement
                      
                      INNER JOIN MovementItem AS MIMaster
                                              ON MIMaster.MovementId = Movement.ID
                                             AND MIMaster.DescId = zc_MI_Master()
                                             AND MIMaster.ObjectId   = vbUserId
                                                   
                           
                      INNER JOIN MovementItem AS MIChild
                                              ON MIChild.MovementId = Movement.ID
                                             AND MIChild.ParentId = MIMaster.ID
                                             AND MIChild.DescId = zc_MI_Child()
                                                   
                 WHERE Movement.DescId = zc_Movement_EmployeeSchedule());
                 
     -- Основное подразделение по графику
    SELECT MILinkObject_Unit.ObjectId AS UnitId , Object_Unit.ValueData, COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
    INTO vbUnitId, vbUnitName, vbNormOfManDays
    FROM Movement
                                      
         INNER JOIN MovementItem AS MIMaster
                                 ON MIMaster.MovementId = Movement.ID
                                AND MIMaster.DescId = zc_MI_Master()
                                AND MIMaster.ObjectId   = vbUserId
                                                                   
                                           
         INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MIMaster.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                   
         LEFT JOIN ObjectFloat AS ObjectFloat_NormOfManDays
                               ON ObjectFloat_NormOfManDays.ObjectId = MILinkObject_Unit.ObjectId
                              AND ObjectFloat_NormOfManDays.DescId = zc_ObjectFloat_Unit_NormOfManDays()
                              
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

    WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
      AND Movement.OperDate = vbDateStart;
      
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
      AND MovementLinkObject_Insert.ObjectId = vbUserId
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

      -- Добовляем отборы
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                           AS ID
         , date_trunc('day', COALESCE(MovementDate_UserConfirmedKind.ValueData, Movement.OperDate))  AS OperDate
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

          LEFT JOIN MovementDate AS MovementDate_UserConfirmedKind
                                 ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                                AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()

    WHERE Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND MovementLinkObject_UserConfirmedKind.ObjectId = vbUserId
      AND MovementLinkObject_Insert.ObjectId IS NULL
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

    ANALYSE tmpMovement;

--raise notice 'Value 03: %', (SELECT count(*) FROM tmpMovement);

    IF vbUserId = vbUserId
    THEN

      IF NOT EXISTS(SELECT * FROM tmpMovement)
      THEN
           RAISE EXCEPTION 'По вам ненайдены чеки.';
      END IF;
    ELSE

      IF NOT EXISTS(SELECT * FROM tmpMovement)
      THEN
           RAISE EXCEPTION 'По сотруднику не найдены чеки.';
      END IF;
    END IF;
    
    WITH tmpUserUnitDay AS (SELECT Movement.OperDate
                                 , Movement.UnitId 
                                 , Count(*)                                    AS CountCheck
                            FROM tmpMovement AS Movement
                            GROUP BY Movement.OperDate, Movement.UnitId )
                            
    SELECT Count(*)::Integer as ManDays
    INTO vbManDays
    FROM tmpUserUnitDay
    WHERE CountCheck >= 10
      AND tmpUserUnitDay.UnitID = vbUnitId;
                                                                    
    --raise notice 'Value 03: % % %', vbNormOfManDays, vbManDays, vbProcUnit;

      -- Товары без продаж
    CREATE TEMP TABLE tmpGoods (
            UnitID          Integer,
            GoodsID         Integer,
            Remains         TFloat,
            RemainsOut      TFloat,
            Price           TFloat,
            SummaIlliquid   TFloat,
            ExpirationDate TDateTime
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
       WITH 
       tmpIlliquidUnit AS (SELECT Movement.ID
                            , MovementLinkObject_Unit.ObjectId AS UnitId
                       FROM Movement

                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbDateStart >= '01.06.2021') 

                       WHERE Movement.OperDate >= vbDateStart
                         AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                         AND Movement.DescId = zc_Movement_IlliquidUnit()
                         AND Movement.StatusId = zc_Enum_Status_Complete()),
       tmpRealization AS (SELECT MIC.WhereObjectId_Analyzer  AS UnitId
                               , MIC.ObjectId_Analyzer       AS GoodsId
                          FROM tmpMovement              
                         
                               INNER JOIN MovementItemContainer AS MIC
                                                                ON MIC.MovementId = tmpMovement.MovementID
                                                               AND MIC.MovementDescId = zc_Movement_Check()
                                                               AND MIC.DescId = zc_MIContainer_Count()
                          GROUP BY MIC.WhereObjectId_Analyzer
                                 , MIC.ObjectId_Analyzer),
       tmpData AS (SELECT Movement.UnitId
                        , MovementItem.ObjectId
                        , MovementItem.Amount
                        , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.UnitId = vbUnitId DESC, MovementItem.Amount DESC) AS ORD
                   FROM tmpIlliquidUnit AS Movement
                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ID
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = FALSE
                        LEFT JOIN tmpRealization ON tmpRealization.UnitId = Movement.UnitId
                                                AND tmpRealization.GoodsId = MovementItem.ObjectId
                   WHERE COALESCE(tmpRealization.UnitId, 0) > 0
                      OR Movement.UnitId = vbUnitId
                   )
                                
       INSERT INTO tmpGoods (UnitId, GoodsID, Remains, RemainsOut, Price, SummaIlliquid)
       SELECT Movement.UnitId, Movement.ObjectId, Movement.Amount, 0, 0, 0
       FROM tmpData AS Movement
       WHERE Movement.ORD = 1;
    ELSE
       RAISE EXCEPTION 'Зафиксированные неликвиды по подразделениям не найдены.';
    END IF;
    ANALYSE tmpGoods;

    -- Заполняем сроки годности
    WITH tmpContainer AS (SELECT Container.ID             AS ID
                               , Container.WhereObjectId  AS UnitID
                               , Container.ObjectId       AS GoodsID
                               , Container.Amount         AS Amount
                          FROM Container
                               INNER JOIN tmpGoods ON tmpGoods.GoodsID = Container.ObjectId
                                                  AND tmpGoods.UnitID = Container.WhereObjectId 
                          WHERE Container.DescId = zc_Container_Count()
                         )
       , tmpRemains AS (SELECT Container.ID
                             , Container.GoodsID
                             , Container.UnitID
                             , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Saldo
                        FROM tmpContainer AS Container
                             LEFT JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.ID = Container.ID
                                                            AND MIContainer.OperDate >= vbDateStart
                                                            AND MIContainer.DescId = zc_Container_Count()
                        GROUP BY Container.ID, Container.GoodsID, Container.UnitID, Container.Amount
                        HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                        )
       , tmpExpirationDateAll AS (SELECT Container.ID
                                       , Container.GoodsID
                                       , Container.UnitID
                                       , Container.Saldo
                                       , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate
                                  FROM tmpRemains AS Container

                                       LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                     ON ContainerLinkObject_MovementItem.Containerid = Container.id
                                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                       -- элемент прихода
                                       LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                       -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                   ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                       -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                       LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                            -- AND 1=0
                                       LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                         ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                        AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                  )
       , tmpContainerPD AS (SELECT tmpContainerId.ContainerId,
                                   Min(COALESCE(ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
                            FROM (SELECT DISTINCT tmpExpirationDateAll.ID as ContainerId FROM tmpExpirationDateAll) AS tmpContainerId
                                 INNER JOIN Container ON Container.ParentId = tmpContainerId.ContainerId
                                                     AND Container.DescId  = zc_Container_CountPartionDate()

                                 LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                            GROUP BY tmpContainerId.ContainerId
                            )
       , tmpExpirationDate AS (SELECT tmpExpirationDateAll.GoodsId,
                                      tmpExpirationDateAll.UnitId,

                                      Min(COALESCE(tmpContainerPD.ExpirationDate, tmpExpirationDateAll.ExpirationDate))      AS ExpirationDate

                                 FROM tmpExpirationDateAll

                                      LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = tmpExpirationDateAll.Id

                                 GROUP BY tmpExpirationDateAll.GoodsId, tmpExpirationDateAll.UnitId)


    UPDATE tmpGoods SET ExpirationDate = date_trunc('day',tmpExpirationDate.ExpirationDate)
    FROM tmpExpirationDate
    WHERE tmpGoods.GoodsId = tmpExpirationDate.GoodsId
      AND tmpGoods.UnitId = tmpExpirationDate.UnitId;

--raise notice 'Value 00: %', (SELECT count(*) FROM tmpGoods);

    -- Заполняем остаток на конец периода
    IF vbDateEnd > CURRENT_DATE
    THEN
      WITH tmpContainer AS (SELECT tmpGoods.UnitID         AS UnitID
                                 , tmpGoods.GoodsID        AS GoodsID
                                 , SUM(Container.Amount)   AS Saldo
                            FROM tmpGoods
                                 INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsID
                                                     AND Container.WhereObjectId = tmpGoods.UnitID
                                                     AND Container.Amount <> 0
                            GROUP BY tmpGoods.UnitID, tmpGoods.GoodsID
                           )
         , tmpCheck AS (SELECT tmpGoods.UnitID                               AS UnitID
                             , tmpGoods.GoodsID                              AS GoodsID
                             , SUM(- MIContainer.Amount)                     AS Amount
                        FROM tmpGoods

                             LEFT JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.OperDate >= vbDateStart
                                                            AND MIContainer.OperDate < vbDateEnd
                                                            AND MIContainer.DescId = zc_Container_Count()
                                                            AND MIContainer.MovementDescId = zc_Movement_Check()
                                                            AND MIContainer.WhereObjectid_Analyzer = tmpGoods.UnitID
                                                            AND MIContainer.Objectid_Analyzer = tmpGoods.GoodsID

                        GROUP BY tmpGoods.UnitID, tmpGoods.GoodsID)
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
                   Container.UnitId                AS UnitId
                 , Container.GoodsID               AS GoodsId
                 , Container.SaldoOut::TFloat      AS SaldoOut
                 , Container.CheckAmount::TFloat   AS CheckAmount
            FROM tmpRemains AS Container) AS SaldoOut
      WHERE tmpGoods.GoodsId = SaldoOut.GoodsId
        AND tmpGoods.UnitId = SaldoOut.UnitId
        AND CASE WHEN SaldoOut.SaldoOut < Remains - SaldoOut.CheckAmount THEN SaldoOut.SaldoOut ELSE Remains - SaldoOut.CheckAmount END > 0;
    ELSE
      WITH tmpContainer AS (SELECT AnalysisContainer.UnitID         AS UnitID
                                 , AnalysisContainer.GoodsID        AS GoodsID
                                 , SUM(AnalysisContainer.Saldo)     AS Saldo
                            FROM tmpGoods 
                                 INNER JOIN AnalysisContainer ON AnalysisContainer.GoodsID  = tmpGoods.GoodsID
                                                             AND AnalysisContainer.UnitID = tmpGoods.UnitID
                            GROUP BY AnalysisContainer.UnitID, AnalysisContainer.GoodsID
                           )
         , tmpMovementItemContainer AS (SELECT tmpGoods.UnitID                                 AS UnitID
                                             , tmpGoods.GoodsID                                AS GoodsID
                                             , SUM(AnalysisContainerItem.Saldo)                AS Saldo
                                        FROM tmpGoods
                                             INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsID = tmpGoods.GoodsID
                                                                             AND AnalysisContainerItem.UnitID = tmpGoods.UnitID
                                        WHERE AnalysisContainerItem.OperDate >= vbDateEnd
                                        GROUP BY tmpGoods.UnitID, tmpGoods.GoodsID)
         , tmpCheck AS (SELECT tmpGoods.UnitID                               AS UnitID
                             , tmpGoods.GoodsID                              AS GoodsID
                             , SUM(- MIContainer.Amount)                     AS Amount
                        FROM tmpGoods

                             LEFT JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.OperDate >= vbDateStart
                                                            AND MIContainer.OperDate < vbDateEnd
                                                            AND MIContainer.DescId = zc_Container_Count()
                                                            AND MIContainer.MovementDescId = zc_Movement_Check()
                                                            AND MIContainer.WhereObjectid_Analyzer = tmpGoods.UnitID
                                                            AND MIContainer.Objectid_Analyzer = tmpGoods.GoodsID

                        GROUP BY tmpGoods.UnitID, tmpGoods.GoodsID)
         , tmpRemains AS (SELECT Container.UnitID
                               , Container.GoodsID
                               , Container.Saldo - COALESCE(MovementItemContainer.Saldo, 0) AS SaldoOut
                               , COALESCE(tmpCheck.Amount, 0)                               AS CheckAmount
                          FROM tmpContainer AS Container
                               LEFT JOIN tmpMovementItemContainer AS MovementItemContainer
                                                                  ON MovementItemContainer.UnitID = Container.UnitID
                                                                 AND MovementItemContainer.GoodsID = Container.GoodsID
                               LEFT JOIN tmpCheck AS tmpCheck
                                                  ON tmpCheck.UnitID = Container.UnitID
                                                 AND tmpCheck.GoodsID = Container.GoodsID)

      UPDATE tmpGoods SET RemainsOut = CASE WHEN SaldoOut.SaldoOut < Remains - SaldoOut.CheckAmount THEN SaldoOut.SaldoOut ELSE Remains - SaldoOut.CheckAmount END
      FROM (SELECT
                   Container.UnitId                AS UnitId
                 , Container.GoodsID               AS GoodsId
                 , Container.SaldoOut::TFloat      AS SaldoOut
                 , Container.CheckAmount::TFloat   AS CheckAmount
            FROM tmpRemains AS Container) AS SaldoOut
      WHERE tmpGoods.GoodsId = SaldoOut.GoodsId
        AND tmpGoods.UnitId = SaldoOut.UnitId
        AND CASE WHEN SaldoOut.SaldoOut < Remains - SaldoOut.CheckAmount THEN SaldoOut.SaldoOut ELSE Remains - SaldoOut.CheckAmount END > 0;
    END IF;
    
--raise notice 'Value 01: %', (SELECT count(*) FROM tmpGoods);

    
    -- Заполнили сумму нелеквидов
    UPDATE tmpGoods SET Price = tmpObject_Price.Price
                      , SummaIlliquid = ROUND(tmpObject_Price.Price * tmpGoods.Remains, 2)
    FROM (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                        AND ObjectFloat_Goods_Price.ValueData > 0
                       THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                       ELSE ROUND (Price_Value.ValueData, 2)
                  END :: TFloat                           AS Price
                , tmpGoods.GoodsId                        AS GoodsId
                , tmpGoods.UnitId                         AS UnitId
          FROM tmpGoods 
                    
               INNER JOIN ObjectLink AS ObjectLink_Price_Unit 
                                     ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                    AND ObjectLink_Price_Unit.ChildObjectId = tmpGoods.UnitId 
               
               INNER JOIN ObjectLink AS Price_Goods
                                     ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                    AND Price_Goods.ChildObjectId = tmpGoods.GoodsId 
                                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                  
               LEFT JOIN ObjectFloat AS Price_Value
                                     ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
               -- Фикс цена для всей Сети
               LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                      ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                     AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
               LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                       ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                      AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()) AS tmpObject_Price
                                      
    WHERE tmpGoods.GoodsId = tmpObject_Price.GoodsId
      AND tmpGoods.UnitId = tmpObject_Price.UnitId;
    
--raise notice 'Value 02: %', (SELECT count(*) FROM tmpGoods);

    ANALYSE tmpGoods;

    -- Заполняем данные по продажам
    CREATE TEMP TABLE tmpImplementation (
             GoodsId Integer,
             Amount TFloat,
             Summa TFloat
      ) ON COMMIT DROP;

    INSERT INTO tmpImplementation
    SELECT tmpGoods.GoodsId                                    AS GoodsId
         , Sum(-1 * MIC.Amount)::TFloat                        AS Amount
         , Sum(Round(-1 * MIC.Amount * MIC.price, 2))::TFloat  AS Summa
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

--raise notice 'Value 03: %', (SELECT count(*) FROM tmpGoods);
--raise notice 'Value 03: %', (SELECT count(*) FROM tmpImplementation);

/*    SELECT MovementItem.ObjectId                         AS GoodsId
         , Sum(MovementItem.Amount)::TFloat              AS Amount
    FROM tmpMovement

         INNER JOIN MovementItem AS MovementItem
                                 ON MovementItem.MovementId = tmpMovement.MovementID
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.DescId     = zc_MI_Master()

         INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

    GROUP BY MovementItem.ObjectId
    HAVING Sum(MovementItem.Amount)::TFloat > 0;
*/
       -- Вывод результата

     IF vbDateStart < '01.03.2020'
     THEN
       OPEN cur1 FOR SELECT tmpGoods.GoodsId
                          , Object_Goods_Main.ObjectCode AS GoodsCode
                          , Object_Goods_Main.Name       AS GoodsName
                          , tmpGoods.Remains             AS AmountStart
                          , tmpImplementation.Amount     AS AmountSale
                          , tmpImplementation.Summa      AS SummaSale
                          , CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN Null
                                 ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END ::TFloat AS ProcSale
                          , Object_Price.Price               AS Price
                          , (Object_Price.Price * tmpGoods.Remains)               AS Summa
                          , tmpGoods.RemainsOut              AS RemainsOut
                          , Object_Accommodation.ValueData   AS AccommodationName
                          , Object_GoodsGroup.ValueData      AS GoodsGroupName
                          , tmpGoods.ExpirationDate
                          , CASE WHEN tmpGoods.RemainsOut = 0 AND COALESCE(tmpImplementation.Amount, 0) = 0 THEN zc_Color_White()
                                 ELSE CASE WHEN COALESCE(tmpImplementation.Amount, 0) < 0.2 AND tmpGoods.RemainsOut > 0 OR
                                           CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods
                                           THEN 16440317
                                           ELSE zc_Color_GreenL() END END AS Color_calc
                          , CASE WHEN tmpGoods.RemainsOut = 0 AND COALESCE(tmpImplementation.Amount, 0) = 0 THEN 8421504
                                 ELSE zc_Color_Black() END AS Color_font
                          , CASE WHEN tmpGoods.RemainsOut = 0 AND COALESCE(tmpImplementation.Amount, 0) = 0 THEN 3
                                 ELSE CASE WHEN COALESCE(tmpImplementation.Amount, 0) < 0.2 AND tmpGoods.RemainsOut > 0 OR
                                           CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods
                                           THEN 2
                                           ELSE 1 END END AS Check_Filter

                     FROM tmpGoods
                          LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpGoods.GoodsId
                          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                          LEFT JOIN tmpImplementation ON tmpImplementation.GoodsId = tmpGoods.GoodsId
                          LEFT JOIN (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                                  AND ObjectFloat_Goods_Price.ValueData > 0
                                                 THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                                 ELSE ROUND (Price_Value.ValueData, 2)
                                            END :: TFloat                           AS Price
                                          , Price_Goods.ChildObjectId               AS GoodsId
                                     FROM ObjectLink AS ObjectLink_Price_Unit
                                        LEFT JOIN ObjectLink AS Price_Goods
                                                             ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                        LEFT JOIN ObjectFloat AS Price_Value
                                                              ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                        -- Фикс цена для всей Сети
                                        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                               ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                              AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                                ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                               AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                                     WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                       AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                     ) AS Object_Price ON Object_Price.GoodsId = tmpGoods.GoodsId
                          LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                                 ON Accommodation.UnitId = vbUnitId
                                                                AND Accommodation.GoodsId = tmpGoods.GoodsId
                                                                AND Accommodation.isErased = False
                          -- Размещение товара
                          LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
                          -- Группа
                          LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.ID = Object_Goods_Main.GoodsGroupId
                     ORDER BY Object_Goods_Main.ObjectCode;
       RETURN NEXT cur1;

       OPEN cur2 FOR SELECT 1::Integer                         AS ID
                          , MAX(AmountAll.AmountAll)::Integer  AS AmountAll
                          , COUNT(*)::Integer                  AS AmountStart
                          , SUM(CASE WHEN COALESCE(tmpImplementation.Amount, 0) < 0.2 AND tmpGoods.RemainsOut > 0 OR
                                      CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                           ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods
                                 THEN 0 ELSE 1 END)::Integer AS AmountSale
                          , CASE WHEN COUNT(*) = 0 THEN 0.0
                                 ELSE 1.0 *SUM(CASE WHEN COALESCE(tmpImplementation.Amount, 0) < 0.2 AND tmpGoods.RemainsOut > 0 OR
                                          CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                          ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods
                                 THEN 0.0 ELSE 1.0 END) / COUNT(*)::TFloat * 100.0 END::TFloat  AS ProcSale

                          , CASE WHEN CASE WHEN COUNT(*) = 0 THEN 100
                                           ELSE 1.0 *SUM(CASE WHEN COALESCE(tmpImplementation.Amount, 0) < 0.2 AND tmpGoods.RemainsOut > 0 OR
                                                    CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0.0
                                                    ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods
                                 THEN 0.0 ELSE 1.0 END) / COUNT(*)::TFloat * 100.0 END < vbProcUnit
                                 THEN ROUND((vbProcUnit::TFLOAT - SUM(CASE WHEN COALESCE(tmpImplementation.Amount, 0) < 0.2 AND tmpGoods.RemainsOut > 0 OR
                                                    CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                    ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods
                                                    THEN 0.0 ELSE 1.0 END) / COUNT(*)::TFloat * 100.0) * vbPenalty, 2) ELSE 0 END::TFloat AS SummaPenaltyCount

                          , CASE WHEN CASE WHEN COUNT(*) = 0 THEN 0
                                           ELSE 1.0 *SUM(CASE WHEN COALESCE(tmpImplementation.Amount, 0) < 0.2 AND tmpGoods.RemainsOut > 0 OR
                                                    CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0.0
                                                    ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods
                                 THEN 0.0 ELSE 1.0 END) / COUNT(*)::TFloat * 100.0 END < vbProcUnit
                                 THEN 16440317 ELSE zc_Color_GreenL() END AS Color_calc
                          , vbUnitName AS UnitName
                     FROM tmpGoods
                          LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpGoods.GoodsId
                          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                          LEFT JOIN tmpImplementation ON tmpImplementation.GoodsId = tmpGoods.GoodsId
                          LEFT JOIN (SELECT COUNT(*) AS AmountAll FROM tmpGoods) AS AmountAll ON 1 = 1
                     WHERE tmpGoods.RemainsOut > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0
                     ;
       RETURN NEXT cur2;
     ELSE
       OPEN cur1 FOR SELECT tmpGoods.GoodsId
                          , Object_Goods_Main.ObjectCode     AS GoodsCode
                          , Object_Goods_Main.Name           AS GoodsName
                          , tmpGoods.Remains                 AS AmountStart
                          , tmpImplementation.Amount         AS AmountSale
                          , tmpImplementation.Summa          AS SummaSale
                          , CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                 ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END ::TFloat AS ProcSale
                          , tmpGoods.Price                   AS Price
                          , tmpGoods.SummaIlliquid           AS Summa
                          , tmpGoods.RemainsOut              AS RemainsOut
                          , Object_Accommodation.ValueData   AS AccommodationName
                          , Object_GoodsGroup.ValueData      AS GoodsGroupName
                          , tmpGoods.ExpirationDate
                          , CASE WHEN tmpGoods.RemainsOut = 0 AND COALESCE(tmpImplementation.Amount, 0) = 0 THEN zc_Color_White()
                                 ELSE CASE WHEN
                                                COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                  COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                   ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                   tmpGoods.Remains >= 1
                                                OR 
                                                CASE WHEN COALESCE (tmpGoods.SummaIlliquid, 0) = 0 THEN 0
                                                     ELSE ROUND(tmpImplementation.Summa / tmpGoods.SummaIlliquid *  100, 2) END <        
                                                CASE WHEN vbManDays < vbNormOfManDays THEN vbPlanAmount * vbManDays / vbNormOfManDays ELSE vbPlanAmount END AND
                                                tmpGoods.Remains >= 1
                                           THEN 16440317
                                           ELSE zc_Color_GreenL() END END AS Color_calc
                          , CASE WHEN tmpGoods.RemainsOut = 0 AND COALESCE(tmpImplementation.Amount, 0) = 0 THEN 8421504
                                 ELSE zc_Color_Black() END AS Color_font
                          , CASE WHEN tmpGoods.RemainsOut = 0 AND COALESCE(tmpImplementation.Amount, 0) = 0 THEN 3
                                 ELSE CASE WHEN COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                  COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                   ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                   tmpGoods.Remains >= 1
                                                OR 
                                                CASE WHEN COALESCE (tmpGoods.SummaIlliquid, 0) = 0 THEN 0
                                                     ELSE ROUND(tmpImplementation.Summa / tmpGoods.SummaIlliquid *  100, 2) END <        
                                                CASE WHEN vbManDays < vbNormOfManDays THEN vbPlanAmount * vbManDays / vbNormOfManDays ELSE vbPlanAmount END AND
                                                tmpGoods.Remains >= 1
                                           THEN 2
                                           ELSE 1 END END AS Check_Filter
                     FROM tmpGoods
                          LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpGoods.GoodsId
                          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                          LEFT JOIN tmpImplementation ON tmpImplementation.GoodsId = tmpGoods.GoodsId
                          LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                                 ON Accommodation.UnitId = vbUnitId
                                                                AND Accommodation.GoodsId = tmpGoods.GoodsId
                          -- Размещение товара
                          LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
                          -- Группа
                          LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.ID = Object_Goods_Main.GoodsGroupId
                     ORDER BY Object_Goods_Main.ObjectCode;
       RETURN NEXT cur1;

       OPEN cur2 FOR SELECT 1::Integer                         AS ID
                          , MAX(AmountAll.AmountAll)::Integer  AS AmountAll
                          , COUNT(*)::Integer                  AS AmountStart
                          , SUM(CASE WHEN NOT (COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                   COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                   ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                   tmpGoods.Remains >= 1)
                                     THEN 1 ELSE 0 END)::Integer AS AmountSale
                          , CASE WHEN COUNT(*) = 0 THEN 0.0
                                 ELSE ROUND(SUM(CASE WHEN COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                          COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                             COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                          CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                             ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                             tmpGoods.Remains >= 1
                                                     THEN 0 ELSE 1 END)::TFloat / COUNT(*)::TFloat * 100.0, 2) END::TFloat  AS ProcSale

                          , CASE WHEN (date_part('day', vbDateStart - vbDateIn)::INTEGER > 90) THEN
                            CASE WHEN CASE WHEN COUNT(*) = 0 OR vbManDays = 0 /*OR CURRENT_DATE < vbDateEnd + INTERVAL '4 day'*/ THEN 100
                                           ELSE ROUND(SUM(CASE WHEN COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                                    COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                                       COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                                    CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                                       ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                                       tmpGoods.Remains >= 1
                                                               THEN 0 ELSE 1 END)::TFloat / COUNT(*)::TFloat * 100.0, 2) END < 
                                                               CASE WHEN vbManDays < vbNormOfManDays
                                                                    THEN vbProcUnit * vbManDays / vbNormOfManDays ELSE vbProcUnit END
                                 THEN ROUND((CASE WHEN vbManDays < vbNormOfManDays
                                                  THEN vbProcUnit * vbManDays / vbNormOfManDays ELSE vbProcUnit END - 
                                                                    ROUND(SUM(CASE WHEN COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                                              COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                                                 COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                                              CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                                                 ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                                                 tmpGoods.Remains >= 1
                                                                         THEN 0 ELSE 1 END)::TFloat / COUNT(*)::TFloat * 100.0, 2)) * vbPenalty, 2) ELSE 0 END ELSE 0 END::TFloat AS SummaPenaltyCount
                                                    
                          , SUM(tmpImplementation.Summa)   AS SummaSale
                          , CASE WHEN COALESCE (SUM(tmpGoods.SummaIlliquid), 0) = 0 THEN 0
                            ELSE ROUND(MAX(ImplementationAll.Summa) / MAX(SummaIlliquid.Summa) *  100, 2) END::TFloat AS  ProcSaleIlliquid

                          , CASE WHEN (date_part('day', vbDateStart - vbDateIn)::INTEGER > 90) THEN
                            CASE WHEN CASE WHEN COALESCE(MAX(SummaIlliquid.Summa), 0) = 0 OR vbManDays = 0 THEN 100
                                           ELSE ROUND(MAX(ImplementationAll.Summa) / MAX(SummaIlliquid.Summa) *  100, 2) END < 
                                           CASE WHEN vbManDays < vbNormOfManDays 
                                                THEN vbPlanAmount * vbManDays / vbNormOfManDays ELSE vbPlanAmount END
                                 THEN ROUND(((CASE WHEN vbManDays < vbNormOfManDays
                                                   THEN vbPlanAmount * vbManDays / vbNormOfManDays ELSE vbPlanAmount END - 
                                                   ROUND(MAX(ImplementationAll.Summa) / MAX(SummaIlliquid.Summa) *  100, 2)) * vbPenaltySum), 2) 
                                 ELSE 0 END ELSE 0 END::TFloat AS SummaPenaltySum

                          , (CASE WHEN (date_part('day', vbDateStart - vbDateIn)::INTEGER > 90) /*AND COALESCE(vbisPenaltyInfo, False) = False*/ THEN
                             CASE WHEN CASE WHEN COUNT(*) = 0 OR vbManDays = 0 /*OR CURRENT_DATE < vbDateEnd + INTERVAL '4 day'*/ THEN 100
                                           ELSE ROUND(SUM(CASE WHEN COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                                    COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                                       COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                                    CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                                       ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                                       tmpGoods.Remains >= 1
                                                               THEN 0 ELSE 1 END)::TFloat / COUNT(*)::TFloat * 100.0, 2) END < 
                                                               CASE WHEN vbManDays < vbNormOfManDays
                                                                    THEN vbProcUnit * vbManDays / vbNormOfManDays ELSE vbProcUnit END
                                 THEN ROUND((CASE WHEN vbManDays < vbNormOfManDays
                                                  THEN vbProcUnit * vbManDays / vbNormOfManDays ELSE vbProcUnit END - 
                                                                    ROUND(SUM(CASE WHEN COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                                              COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                                                 COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                                              CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                                                 ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                                                 tmpGoods.Remains >= 1
                                                                         THEN 0 ELSE 1 END)::TFloat / COUNT(*)::TFloat * 100.0, 2)) * vbPenalty, 2) ELSE 0 END ELSE 0 END+
                            CASE WHEN (date_part('day', vbDateStart - vbDateIn)::INTEGER > 90) /*AND COALESCE(inisPenaltySumInfo, False) = False*/ THEN
                             CASE WHEN CASE WHEN MAX(SummaIlliquid.Summa) = 0 OR vbManDays = 0 THEN 100
                                            ELSE ROUND(MAX(ImplementationAll.Summa) / MAX(SummaIlliquid.Summa) *  100, 2) END < 
                                            CASE WHEN vbManDays < vbNormOfManDays
                                                 THEN vbPlanAmount * vbManDays / vbNormOfManDays ELSE vbPlanAmount END
                                  THEN ROUND(((CASE WHEN vbManDays < vbNormOfManDays
                                                    THEN vbPlanAmount * vbManDays / vbNormOfManDays ELSE vbPlanAmount END - 
                                                    ROUND(MAX(ImplementationAll.Summa) / MAX(SummaIlliquid.Summa) *  100, 2)) * vbPenaltySum), 2) 
                                  ELSE 0 END ELSE 0 END)::TFloat AS SummaPenalty

                          , CASE WHEN CASE WHEN COUNT(*) = 0 THEN 0
                                           ELSE 1.0 * SUM(CASE WHEN COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                                COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                                  COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                                CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                                   ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < vbProcGoods AND
                                                   tmpGoods.Remains >= 1
                                 THEN 0.0 ELSE 1.0 END) / COUNT(*)::TFloat * 100.0 END < CASE WHEN vbManDays < vbNormOfManDays
                                                                                         THEN vbProcUnit * vbManDays / vbNormOfManDays ELSE vbProcUnit END
                                 /*AND COALESCE(vbisPenaltyInfo, False) = False*/
                                 OR 
                                 CASE WHEN COALESCE (MAX(SummaIlliquid.Summa), 0) = 0 THEN 0
                                      ELSE ROUND(MAX(ImplementationAll.Summa) / MAX(SummaIlliquid.Summa) *  100, 2) END <        
                                 CASE WHEN vbManDays < vbNormOfManDays THEN vbPlanAmount * vbManDays / vbNormOfManDays ELSE vbPlanAmount END  
                                 /*AND COALESCE(inisPenaltySumInfo, False) = False*/
                                 THEN 16440317 ELSE zc_Color_GreenL() END AS Color_calc
                          , vbUnitName AS UnitName
                     FROM tmpGoods
                          LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpGoods.GoodsId
                          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                          LEFT JOIN tmpImplementation ON tmpImplementation.GoodsId = tmpGoods.GoodsId
                          LEFT JOIN (SELECT COUNT(*) AS AmountAll FROM tmpGoods) AS AmountAll ON 1 = 1
                          LEFT JOIN (SELECT SUM(tmpImplementation.Summa) AS Summa FROM tmpImplementation) AS ImplementationAll ON 1 = 1
                          LEFT JOIN (SELECT SUM(tmpGoods.SummaIlliquid) AS Summa FROM tmpGoods) AS SummaIlliquid ON 1 = 1
                     WHERE COALESCE(tmpGoods.RemainsOut, 0) > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0
                     ;
       RETURN NEXT cur2;

--       raise notice 'Value 06: % %', vbUnitId, (SELECT SUM(tmpGoods.SummaIlliquid) AS Summa FROM tmpGoods);

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.02.20                                                       *
 17.01.20                                                       *
 19.12.19                                                       *
 18.12.19                                                       *
 04.12.19                                                       *
*/

-- тест 

select * from gpReport_IlliquidReductionPlanUser(inStartDate := ('02.06.2021')::TDateTime ,  inSession := '3');