 -- Function: gpReport_IlliquidReductionPlanAll()

DROP FUNCTION IF EXISTS gpReport_IlliquidReductionPlanAll (TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IlliquidReductionPlanAll(
    IN inStartDate         TDateTime , -- Дата в месяце
    IN inProcGoods         TFloat ,    -- % продажи для вып.
    IN inProcUnit          TFloat ,    -- % вып. по аптеке.
    IN inPlanAmount        TFloat ,    -- План от суммы
    IN inPenalty           TFloat ,    -- Штраф за 1% невыполнения
    IN inisPenaltyInfo     Boolean,
    IN inPenaltySum        TFloat ,    -- Штраф за 1% невыполнения по сумме
    IN inisPenaltySumInfo  Boolean, 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId            Integer   --
             , UserCode          Integer   --
             , UserName          TVarChar  --
             , UnitId            Integer   --
             , UnitName          TVarChar  --
             , AmountAll         Integer   -- Товаров без продаж
             , AmountStart       Integer   -- Без продаж  на начало
             , AmountSale        Integer   -- Продано
             , SummaSale         TFloat    -- Сумма продажи
             , ProcSaleIlliquid  TFloat    -- Процент от суммы нелеквидов
             , ProcSale          TFloat    -- % продаж
             , SummaPenaltyCount TFloat    -- Сумма штрафа по количеству 
             , SummaPenaltySum   TFloat    -- Сумма штрафа по сумме
             , SummaPenalty      TFloat    -- Сумма штрафа
             , ManDays           Integer   -- Отработано дней в месяце
             , DaysWorked        Integer   -- Отработано дней
             , PositionName      TVarChar  -- Должность
             , Color_Calc        Integer   --
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', inStartDate);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    IF NOT EXISTS(SELECT 1
                  FROM Movement

                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                  WHERE Movement.OperDate >= vbDateStart
                    AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                    AND Movement.DescId = zc_Movement_IlliquidUnit()
                    AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
       RAISE EXCEPTION 'Зафиксированные неликвиды по подразделениям не найдены.';
    END IF;

      -- Мовементы по сотрудникам
    DROP TABLE IF EXISTS tmpMovementAll;
    CREATE TEMP TABLE tmpMovementAll (
            ID                 Integer,
            OperDate           TDateTime
      ) ON COMMIT DROP;

    INSERT INTO tmpMovementAll
    SELECT
           Movement.ID                                      AS ID
         , date_trunc('day', COALESCE(MovementDate_Insert.ValueData, MovementDate_UserConfirmedKind.ValueData,  Movement.OperDate))    AS OperDate
    FROM Movement
         LEFT JOIN MovementDate AS MovementDate_UserConfirmedKind
                                ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                               AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()

         LEFT JOIN MovementDate AS MovementDate_Insert
                                ON MovementDate_Insert.MovementId = Movement.Id
                               AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
    WHERE Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();
      
    ANALYSE tmpMovementAll;

--raise notice 'Value 11: %', CLOCK_TIMESTAMP();
            

      -- Мовементы по сотрудникам
    DROP TABLE IF EXISTS tmpMovement;
    CREATE TEMP TABLE tmpMovement (
            MovementID         Integer,
            OperDate           TDateTime,

            UnitID             Integer,
            UserID             Integer            
      ) ON COMMIT DROP;

       -- Добовляем простые продажи
    WITH tmpMovement AS (SELECT
                                Movement.ID                                                                                 AS ID
                              , Movement.OperDate                                                                           AS OperDate
                              , MovementLinkObject_Unit.ObjectId                                                            AS UnitId
                              , COALESCE(MovementLinkObject_Insert.ObjectId, MovementLinkObject_UserConfirmedKind.ObjectId) AS UserID
                         FROM tmpMovementAll AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                             ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                            AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                                             ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                                            AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()

                               )

    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                      AS ID
         , Movement.OperDate                                AS OperDate
         , Movement.UnitId                                  AS UnitId
         , Movement.UserID                                  AS UserID
    FROM tmpMovement AS Movement
    ;

    ANALYSE tmpMovement;
    
    DELETE FROM tmpMovement
    WHERE tmpMovement.UnitId IS NULL
       OR tmpMovement.UserID IS NULL
       OR tmpMovement.UnitId NOT IN (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitID
                                     FROM ObjectLink AS ObjectLink_Juridical_Retail

                                          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                                ON ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                               AND ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId

                                     WHERE ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                       AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                       AND ObjectLink_Juridical_Retail.ChildObjectId = 4)
       OR tmpMovement.UserID NOT IN (SELECT ObjectLink_User_Member.ObjectId AS UserID
                                     FROM ObjectLink AS ObjectLink_User_Member

                                          INNER JOIN  ObjectLink AS ObjectLink_Member_Position
                                                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                                                                AND ObjectLink_Member_Position.ChildObjectId = 1672498
                                     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member())
    ;

--raise notice 'Value 2: %', CLOCK_TIMESTAMP();

      -- Подразделение + сотрудники
    DROP TABLE IF EXISTS tmpUnitUser;
    CREATE TEMP TABLE tmpUnitUser (
            UnitID         Integer,
            UserID         TFloat
      ) ON COMMIT DROP;

    WITH tmpUser AS (SELECT DISTINCT tmpMovement.UserId
                      FROM tmpMovement)
       , tmpEmployeeSchedule AS (SELECT MIMaster.ObjectId AS UserId
                                      , MILinkObject_Unit.ObjectId AS UnitId
                                 FROM Movement
                                                                   
                                      INNER JOIN MovementItem AS MIMaster
                                                              ON MIMaster.MovementId = Movement.ID
                                                             AND MIMaster.DescId = zc_MI_Master()
                                                                                                                                                                         
                                      INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                        ON MILinkObject_Unit.MovementItemId = MIMaster.Id
                                                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                                                 
                                 WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                                   AND Movement.OperDate = vbDateStart)

    INSERT INTO tmpUnitUser
    SELECT tmpEmployeeSchedule.UnitId
         , tmpUser.UserId
    FROM tmpUser
         LEFT JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.UserId =  tmpUser.UserId;
         
    ANALYSE tmpUnitUser;
    
--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

      -- Товары без продаж
    DROP TABLE IF EXISTS tmpGoods;
    CREATE TEMP TABLE tmpGoods (
            UnitID         Integer,
            GoodsID         Integer,
            Remains         TFloat,
            RemainsOut      TFloat,
            SummaIlliquid   TFloat
      ) ON COMMIT DROP;


    -- Заполняем остаток на конец периода
    IF vbDateEnd > CURRENT_DATE
    THEN
      WITH
           tmpGoods AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitID
                             , MovementItem.ObjectId            AS GoodsID
                             , MovementItem.Amount              AS Amount
                        FROM Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE

                        WHERE Movement.OperDate >= vbDateStart
                          AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                          AND Movement.DescId = zc_Movement_IlliquidUnit()
                          AND Movement.StatusId = zc_Enum_Status_Complete())

         , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
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
                                                           AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                               )  
         , tmpContainer AS (SELECT tmpGoods.UnitID           AS UnitID
                                 , tmpGoods.GoodsID          AS GoodsID
                                 , SUM(Container.Amount)     AS Saldo
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


      INSERT INTO tmpGoods (UnitID, GoodsID, Remains, RemainsOut, SummaIlliquid)  
      SELECT
             tmpGoods.UnitID               AS UnitID
           , tmpGoods.GoodsID              AS Goods
           , tmpGoods.Amount               AS Remains
           , COALESCE(CASE WHEN CASE WHEN COALESCE(Container.SaldoOut, 0) < tmpGoods.Amount - COALESCE(Container.CheckAmount, 0) 
                                     THEN COALESCE(Container.SaldoOut, 0) ELSE tmpGoods.Amount - COALESCE(Container.CheckAmount, 0) END <= 0
                      THEN 0
                      ELSE CASE WHEN COALESCE(Container.SaldoOut, 0) < tmpGoods.Amount - COALESCE(Container.CheckAmount, 0) 
                                THEN COALESCE(Container.SaldoOut, 0) ELSE tmpGoods.Amount - COALESCE(Container.CheckAmount, 0) END END, 0) AS RemainsOut
           , ROUND(tmpObject_Price.Price * tmpGoods.Amount, 2) AS SummaIlliquid
      FROM tmpGoods
           LEFT JOIN tmpRemains AS Container
                                ON tmpGoods.GoodsId = Container.GoodsId
                               AND tmpGoods.UnitID = Container.UnitID
           LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = tmpGoods.GoodsId
                                    AND tmpObject_Price.UnitID = tmpGoods.UnitID;
                                    
    ELSE
      WITH
           tmpGoods AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitID
                             , MovementItem.ObjectId            AS GoodsID
                             , MovementItem.Amount              AS Amount
                        FROM Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE

                        WHERE Movement.OperDate >= vbDateStart
                          AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                          AND Movement.DescId = zc_Movement_IlliquidUnit()
                          AND Movement.StatusId = zc_Enum_Status_Complete())
         , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
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
                                                           AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                               )  
         , tmpContainer AS (SELECT AnalysisContainer.UnitID         AS UnitID
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


      INSERT INTO tmpGoods (UnitID, GoodsID, Remains, RemainsOut, SummaIlliquid)
      SELECT
             tmpGoods.UnitID               AS UnitID
           , tmpGoods.GoodsID              AS Goods
           , tmpGoods.Amount               AS SaldoOut
           , CASE WHEN CASE WHEN Container.SaldoOut < tmpGoods.Amount - Container.CheckAmount THEN Container.SaldoOut ELSE tmpGoods.Amount - Container.CheckAmount END <= 0
             THEN 0
             ELSE CASE WHEN Container.SaldoOut < tmpGoods.Amount - Container.CheckAmount THEN Container.SaldoOut ELSE tmpGoods.Amount - Container.CheckAmount END END
           , ROUND(tmpObject_Price.Price * tmpGoods.Amount, 2) AS SummaIlliquid
      FROM tmpGoods
           LEFT JOIN tmpRemains AS Container
                                ON tmpGoods.GoodsId = Container.GoodsId
                               AND tmpGoods.UnitID = Container.UnitID
           LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Container.GoodsId
                                    AND tmpObject_Price.UnitID = Container.UnitID;
    END IF;

    ANALYSE tmpGoods;

--raise notice 'Value 4: %', CLOCK_TIMESTAMP();

    DROP TABLE IF EXISTS tmpImplementation;
    CREATE TEMP TABLE tmpImplementation (
             UserId Integer,
             UnitId Integer,
             GoodsId Integer,
             Amount TFloat,
             Summa TFloat
      ) ON COMMIT DROP;

    -- Заполняем данные по продажам
    WITH tmpGoodsList AS (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
       , tmpImplementationAll AS (SELECT tmpMovement.UserId
                                       , tmpGoodsList.GoodsId                                AS GoodsId
                                       , MIC.WhereObjectId_Analyzer                          AS UnitId
                                       , Sum(-1 * MIC.Amount)::TFloat                        AS Amount
                                       , Sum(Round(-1 * MIC.Amount * MIC.price, 2))::TFloat  AS Summa
                                  FROM tmpGoodsList

                                       INNER JOIN MovementItemContainer AS MIC
                                                                        ON MIC.ObjectId_Analyzer = tmpGoodsList.GoodsId
                                                                       AND MIC.OperDate >= vbDateStart
                                                                       AND MIC.OperDate < vbDateEnd
                                                                       AND MIC.MovementDescId = zc_Movement_Check()
                                                                       AND MIC.DescId = zc_MIContainer_Count()

                                       INNER JOIN tmpMovement ON tmpMovement.MovementId = MIC.MovementId

                                  GROUP BY tmpMovement.UserId, tmpGoodsList.GoodsId, MIC.WhereObjectId_Analyzer)  
       , tmpUserGoodsAll AS (SELECT tmpImplementationAll.UserId
                                  , tmpImplementationAll.GoodsId
                                  , tmpImplementationAll.UnitId
                             FROM tmpImplementationAll
                             GROUP BY tmpImplementationAll.UserId
                                    , tmpImplementationAll.GoodsId
                                    , tmpImplementationAll.UnitId
                             )   
                             
       , tmpUserGoods AS (SELECT tmpUserGoodsAll.UserId
                               , tmpUserGoodsAll.GoodsId
                               , COALESCE(tmpGoodsUser.UnitId, tmpGoods.UnitId) AS UnitId
                               , ROW_NUMBER() OVER (PARTITION BY tmpUserGoodsAll.UserId, tmpUserGoodsAll.GoodsId 
                                              ORDER BY COALESCE(tmpGoodsUser.UnitId, tmpGoods.UnitId) = tmpUnitUser.UnitId DESC, tmpGoods.Remains DESC) AS ORD
                          FROM tmpUserGoodsAll
                          
                               INNER JOIN tmpUnitUser ON tmpUnitUser.UserId = tmpUserGoodsAll.UserId

                               LEFT JOIN tmpGoods ON tmpGoods.UnitId = tmpUserGoodsAll.UnitId
                                                  AND tmpGoods.GoodsId = tmpUserGoodsAll.GoodsId
                                                  AND vbDateStart >= '01.06.2021'
                                                  
                               LEFT JOIN tmpGoods AS tmpGoodsUser 
                                                  ON tmpGoodsUser.UnitId = tmpUnitUser.UnitId
                                                 AND tmpGoodsUser.GoodsId = tmpUserGoodsAll.GoodsId
                                                 
                          WHERE COALESCE(tmpGoodsUser.UnitId, tmpGoods.UnitId, 0) > 0
                          )   
                

    INSERT INTO tmpImplementation
    SELECT tmpImplementationAll.UserId
         , tmpUserGoods.UnitId
         , tmpImplementationAll.GoodsId                             AS GoodsId
         , Sum(tmpImplementationAll.Amount)::TFloat                 AS Amount
         , Sum(tmpImplementationAll.Summa)::TFloat                  AS Summa
    FROM tmpImplementationAll

         INNER JOIN tmpUserGoods ON tmpUserGoods.UserId = tmpImplementationAll.UserId   
                                AND tmpUserGoods.GoodsId = tmpImplementationAll.GoodsId         
                                AND tmpUserGoods.Ord = 1

    GROUP BY tmpImplementationAll.UserId, tmpUserGoods.UnitId, tmpImplementationAll.GoodsId;

    ANALYSE tmpImplementation;
    
--raise notice 'Value 6: %', CLOCK_TIMESTAMP();

    IF vbDateStart < '01.03.2020'
    THEN
      RETURN QUERY
      WITH tmpNoSales AS (SELECT tmpUnitUser.UnitId
                               , tmpUnitUser.UserId
                               , COUNT(*)                                                                                              AS CountCheckAll
                               , SUM(CASE WHEN tmpGoods.RemainsOut > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0 THEN 1 ELSE 0 END) AS CountCheck
                               , SUM(tmpImplementation.Summa)                                                                          AS SummaSale
                          FROM tmpGoods

                               INNER JOIN tmpUnitUser ON tmpGoods.UnitId = tmpUnitUser.UnitID

                               LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUnitUser.UserId
                                                          AND tmpImplementation.GoodsId = tmpGoods.GoodsId

                          GROUP BY tmpUnitUser.UnitId, tmpUnitUser.UserId)
         , tmpSummaIlliquid AS (SELECT tmpGoods.UnitId
                                     , SUM(tmpGoods.SummaIlliquid)                                                                  AS SummaIlliquid
                                FROM tmpGoods
                                GROUP BY tmpGoods.UnitId)
         , tmpUserSalesOk AS (SELECT tmpUnitUser.UserId
                                   , count(*)                       AS CountCheck
                              FROM tmpGoods

                                   INNER JOIN tmpUnitUser ON tmpGoods.UnitId = tmpUnitUser.UnitID

                                   LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUnitUser.UserId
                                                              AND tmpImplementation.GoodsId = tmpGoods.GoodsId

                              WHERE (tmpImplementation.Amount >= 0.2 OR COALESCE(tmpGoods.RemainsOut, 0) = 0)
                                AND (tmpImplementation.Amount::TFloat / tmpGoods.Remains::TFloat)::TFloat >= (inProcGoods / 100.0)
                                AND (COALESCE(tmpGoods.RemainsOut, 0) > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0)
                              GROUP BY tmpUnitUser.UserId)
         , tmpUserUnitDay AS (SELECT Movement.UserId
                                   , Movement.UnitId
                                   , Movement.OperDate
                                   , Count(*)                                    AS CountCheck
                              FROM tmpMovement AS Movement
                              GROUP BY Movement.UserId
                                     , Movement.UnitId
                                     , Movement.OperDate)
         , tmpUserUnitManDays AS (SELECT tmpUserUnitDay.UserID,
                                         tmpUserUnitDay.UnitID,
                                         Count(*)::Integer as ManDays
                                  FROM tmpUserUnitDay
                                  WHERE CountCheck >= 10
                                  GROUP BY tmpUserUnitDay.UserID, tmpUserUnitDay.UnitID)
         , tmpUser AS (SELECT MIMaster.ObjectId                                                                     AS UserId
                            , MIN(Movement.OperDate + ((MIChild.Amount - 1)::Integer::tvarchar||' DAY')::INTERVAL)  AS DateIn
                       FROM Movement
                      
                            INNER JOIN MovementItem AS MIMaster
                                                    ON MIMaster.MovementId = Movement.ID
                                                   AND MIMaster.DescId = zc_MI_Master()
                           
                            INNER JOIN MovementItem AS MIChild
                                                    ON MIChild.MovementId = Movement.ID
                                                   AND MIChild.ParentId = MIMaster.ID
                                                   AND MIChild.DescId = zc_MI_Child()
                                                   
                       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                       GROUP BY MIMaster.ObjectId)
         , tmPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Member.IsErased) AS Ord
                                    , Object_User.Id              AS UserID
                                    , Object_Position.ObjectCode  AS PositionCode
                                    , Object_Position.ValueData   AS PositionName
                               FROM Object AS Object_User
                               
                                    INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                          ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                    LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                                    
                                    LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                         ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                        AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                                    LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

                               WHERE Object_User.DescId = zc_Object_User())

      SELECT
             Object_User.ID                      AS UserId
           , Object_User.ObjectCode              AS UserCode
           , Object_User.ValueData               AS UserName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           , tmpNoSales.CountCheckAll::Integer   AS AmountAll
           , tmpNoSales.CountCheck::Integer      AS AmountStart
           , tmpUserSalesOk.CountCheck::Integer  AS AmountSale
           , tmpNoSales.SummaSale                AS SummaSale
           , CASE WHEN COALESCE (tmpSummaIlliquid.SummaIlliquid, 0) = 0 THEN 0
                  ELSE ROUND(tmpNoSales.SummaSale / tmpSummaIlliquid.SummaIlliquid *  100, 2) END::TFloat AS  ProcSaleIlliquid
           , CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                  ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END ::TFloat AS ProcSale
           , 0::TFloat    AS SummaPenaltyAmount
           
           , 0::TFloat    AS SummaPenaltySum
           
           , CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 100
                            ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END < inProcUnit
                  THEN ROUND(((inProcUnit - (COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat) * 100) * inPenalty), 2) ELSE 0 END::TFloat AS SummaPenalty
 
           , tmpUserUnitManDays.ManDays          AS ManDays 
           , CASE WHEN date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER > 0 
                  THEN date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER 
                  ELSE 0 END::INTEGER            AS DaysWorked
           , Personal_View.PositionName          AS PositionName
           , CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                            ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END < inProcUnit
                  THEN 16440317 ELSE zc_Color_GreenL() END AS Color_calc
      FROM tmpUnitUser

           INNER JOIN Object AS Object_User ON Object_User.ID = tmpUnitUser.UserID

           INNER JOIN Object AS Object_Unit ON Object_Unit.ID = tmpUnitUser.UnitID

           LEFT JOIN tmpNoSales ON tmpNoSales.UnitId = tmpUnitUser.UnitID
                               AND tmpNoSales.UserId = tmpUnitUser.UserId

           LEFT JOIN tmpSummaIlliquid ON tmpSummaIlliquid.UnitId = tmpUnitUser.UnitID

           LEFT JOIN tmpUserSalesOk ON tmpUserSalesOk.UserId = tmpUnitUser.UserId

           LEFT JOIN tmpUserUnitManDays ON tmpUserUnitManDays.UnitId = tmpUnitUser.UnitID
                                       AND tmpUserUnitManDays.UserId = tmpUnitUser.UserId
           LEFT JOIN tmpUser ON tmpUser.UserID = tmpUnitUser.UserId
          
           LEFT JOIN tmPersonal_View AS Personal_View 
                                     ON Personal_View.UserID =  tmpUnitUser.UserId
                                    AND Personal_View.Ord = 1;  
    ELSE
      RETURN QUERY
      WITH tmpUserGoodsAll AS (SELECT tmpUnitUser.UserId, tmpUnitUser.UnitId, tmpGoods.GoodsId
                               FROM tmpUnitUser 

                                    LEFT JOIN tmpGoods ON tmpGoods.UnitId = tmpUnitUser.UnitId
                               UNION ALL                     
                               SELECT tmpUnitUser.UserId, tmpUnitUser.UnitId, tmpImplementation.GoodsId
                               FROM tmpUnitUser 

                                    LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUnitUser.UserId
                               
                               )
         , tmpUserGoods AS (SELECT tmpUserGoodsAll.UserId, tmpUserGoodsAll.UnitId, tmpUserGoodsAll.GoodsId
                            FROM tmpUserGoodsAll 
                            GROUP BY tmpUserGoodsAll.UserId, tmpUserGoodsAll.UnitId, tmpUserGoodsAll.GoodsId
                           )                     
         , tmpNoSales AS (SELECT tmpUserGoods.UnitId
                               , tmpUserGoods.UserId
                               , COUNT(*)                                                                                              AS CountCheckAll
                               , SUM(CASE WHEN tmpGoods.RemainsOut > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0 THEN 1 ELSE 0 END) AS CountCheck
                               , SUM(tmpImplementation.Summa)                                                                          AS SummaSale
                          FROM tmpUserGoods 

                               LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUserGoods.UserId
                                                          AND tmpImplementation.GoodsId = tmpUserGoods.GoodsId

                               LEFT JOIN tmpGoods ON tmpGoods.UnitId = COALESCE(tmpImplementation.UnitID, tmpUserGoods.UnitId)
                                                 AND tmpGoods.GoodsId = COALESCE(tmpImplementation.GoodsId, tmpUserGoods.GoodsId)
                                                 
                          GROUP BY tmpUserGoods.UnitId, tmpUserGoods.UserId)
         , tmpSummaIlliquid AS (SELECT tmpUserGoods.UserId
                                     , SUM(tmpGoods.SummaIlliquid)                                                                  AS SummaIlliquid
                                FROM tmpUserGoods 

                                     LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUserGoods.UserId
                                                                AND tmpImplementation.GoodsId = tmpUserGoods.GoodsId

                                     LEFT JOIN tmpGoods ON tmpGoods.UnitId = COALESCE(tmpImplementation.UnitID, tmpUserGoods.UnitId)
                                                       AND tmpGoods.GoodsId = COALESCE(tmpImplementation.GoodsId, tmpUserGoods.GoodsId)
                                GROUP BY tmpUserGoods.UserId)
         , tmpUserSalesOk AS (SELECT tmpUserGoods.UserId
                                   , count(*) AS CountCheck
                                   , SUM(tmpImplementation.Summa)   AS SummaSale
                              FROM tmpUserGoods 

                                   LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUserGoods.UserId
                                                              AND tmpImplementation.GoodsId = tmpUserGoods.GoodsId

                                   LEFT JOIN tmpGoods ON tmpGoods.UnitId = COALESCE(tmpImplementation.UnitID, tmpUserGoods.UnitId)
                                                     AND tmpGoods.GoodsId = COALESCE(tmpImplementation.GoodsId, tmpUserGoods.GoodsId)
                                                 
                              WHERE COALESCE(tmpGoods.UnitId, 0) <> 0
                                AND NOT (COALESCE(tmpGoods.Remains, 0) < 0.2 AND tmpGoods.RemainsOut > 0  OR
                                         COALESCE(tmpGoods.Remains, 0) >= 0.2 AND COALESCE(tmpGoods.Remains, 0) < 1.0 AND
                                            COALESCE(tmpImplementation.Amount, 0) < 0.2  OR
                                          CASE WHEN COALESCE(tmpGoods.Remains, 0) = 0 THEN 0
                                             ELSE COALESCE(tmpImplementation.Amount, 0) / tmpGoods.Remains * 100 END < inProcGoods AND
                                             tmpGoods.Remains >= 1)
                                AND (COALESCE(tmpGoods.RemainsOut, 0) > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0)
                              GROUP BY tmpUserGoods.UserId)
         , tmpUserUnitDay AS (SELECT Movement.UserId
                                   , Movement.UnitId
                                   , Movement.OperDate
                                   , Count(*)                                    AS CountCheck
                              FROM tmpMovement AS Movement
                              GROUP BY Movement.UserId
                                     , Movement.UnitId
                                     , Movement.OperDate)
         , tmpUserUnitManDays AS (SELECT tmpUserUnitDay.UserID,
                                         tmpUserUnitDay.UnitID,
                                         Count(*)::Integer as ManDays
                                  FROM tmpUserUnitDay
                                  WHERE CountCheck >= 10
                                  GROUP BY tmpUserUnitDay.UserID, tmpUserUnitDay.UnitID)
         , tmpUser AS (SELECT MIMaster.ObjectId                                                                     AS UserId
                            , MIN(Movement.OperDate + ((MIChild.Amount - 1)::Integer::tvarchar||' DAY')::INTERVAL)  AS DateIn
                       FROM Movement
                      
                            INNER JOIN MovementItem AS MIMaster
                                                    ON MIMaster.MovementId = Movement.ID
                                                   AND MIMaster.DescId = zc_MI_Master()
                           
                            INNER JOIN MovementItem AS MIChild
                                                    ON MIChild.MovementId = Movement.ID
                                                   AND MIChild.ParentId = MIMaster.ID
                                                   AND MIChild.DescId = zc_MI_Child()
                                                   
                       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                       GROUP BY MIMaster.ObjectId)
         , tmPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Member.IsErased) AS Ord
                                    , Object_User.Id              AS UserID
                                    , Object_Position.ObjectCode  AS PositionCode
                                    , Object_Position.ValueData   AS PositionName
                               FROM Object AS Object_User
                               
                                    INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                          ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                    LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                                    
                                    LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                         ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                        AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                                    LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

                               WHERE Object_User.DescId = zc_Object_User())

      SELECT
             Object_User.ID                      AS UserId
           , Object_User.ObjectCode              AS UserCode
           , Object_User.ValueData               AS UserName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           , tmpNoSales.CountCheckAll::Integer   AS AmountAll
           , tmpNoSales.CountCheck::Integer      AS AmountStart
           , tmpUserSalesOk.CountCheck::Integer  AS AmountSale
           , tmpNoSales.SummaSale::TFloat        AS SummaSale
           , CASE WHEN COALESCE (tmpSummaIlliquid.SummaIlliquid, 0) = 0 THEN 0
                  ELSE ROUND(tmpNoSales.SummaSale / tmpSummaIlliquid.SummaIlliquid *  100, 2) END::TFloat AS  ProcSaleIlliquid
           , CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                  ELSE ROUND(COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0, 2) END ::TFloat  AS ProcSale

           , CASE WHEN (date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER > 90) THEN
             CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 OR COALESCE(tmpUserUnitManDays.ManDays, 0) = 0 THEN 100
                            ELSE ROUND(COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0, 2) END < 
                            CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                 THEN inProcUnit * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inProcUnit END
                  THEN ROUND(((CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                    THEN inProcUnit * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inProcUnit END - 
                                    ROUND(COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0, 2)) * inPenalty), 2) 
                  ELSE 0 END ELSE 0 END::TFloat AS SummaPenaltyAmount
           
           , CASE WHEN (date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER > 90) THEN
             CASE WHEN CASE WHEN COALESCE(tmpSummaIlliquid.SummaIlliquid, 0) = 0 OR COALESCE(tmpUserUnitManDays.ManDays, 0) = 0 THEN 100
                            ELSE ROUND(tmpNoSales.SummaSale / tmpSummaIlliquid.SummaIlliquid *  100, 2) END < 
                            CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                 THEN inPlanAmount * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inPlanAmount END
                  THEN ROUND(((CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                    THEN inPlanAmount * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inPlanAmount END - 
                                    ROUND(tmpNoSales.SummaSale / tmpSummaIlliquid.SummaIlliquid *  100, 2)) * inPenaltySum), 2) 
                  ELSE 0 END ELSE 0 END::TFloat AS SummaPenaltySum
           
           , (CASE WHEN (date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER > 90) AND COALESCE(inisPenaltyInfo, False) = False THEN
               CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 OR COALESCE(tmpUserUnitManDays.ManDays, 0) = 0 THEN 100
                             ELSE ROUND(COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0, 2) END < 
                             CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                  THEN inProcUnit * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inProcUnit END
                   THEN ROUND(((CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                     THEN inProcUnit * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inProcUnit END - 
                                     ROUND(COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0, 2)) * inPenalty), 2) ELSE 0 END ELSE 0 END +
              CASE WHEN (date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER > 90) AND COALESCE(inisPenaltySumInfo, False) = False THEN
              CASE WHEN CASE WHEN COALESCE(tmpSummaIlliquid.SummaIlliquid, 0) = 0 OR COALESCE(tmpUserUnitManDays.ManDays, 0) = 0 THEN 100
                             ELSE ROUND(tmpNoSales.SummaSale / tmpSummaIlliquid.SummaIlliquid *  100, 2) END < 
                             CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                  THEN inPlanAmount * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inPlanAmount END
                   THEN ROUND(((CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                     THEN inPlanAmount * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inPlanAmount END - 
                                     ROUND(tmpNoSales.SummaSale / tmpSummaIlliquid.SummaIlliquid *  100, 2)) * inPenaltySum), 2) 
                   ELSE 0 END ELSE 0 END)::TFloat AS SummaPenalty
 
           , tmpUserUnitManDays.ManDays          AS ManDays 
           , CASE WHEN date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER > 0 
                  THEN date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER 
                  ELSE 0 END::INTEGER            AS DaysWorked
           , Personal_View.PositionName          AS PositionName
           , CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                            ELSE ROUND(COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0, 2) END <  
                            CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                                 THEN inProcUnit * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inProcUnit END
                       AND COALESCE(inisPenaltyInfo, False) = False          
                       OR CASE WHEN COALESCE (tmpSummaIlliquid.SummaIlliquid, 0) = 0 THEN 0
                               ELSE ROUND(tmpNoSales.SummaSale / tmpSummaIlliquid.SummaIlliquid *  100, 2) END <        
                          CASE WHEN tmpUserUnitManDays.ManDays < COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) 
                              THEN inPlanAmount * tmpUserUnitManDays.ManDays / COALESCE (ObjectFloat_NormOfManDays.ValueData::Integer, 15) ELSE inPlanAmount END  
                       AND COALESCE(inisPenaltySumInfo, False) = False        
                  THEN 16440317 ELSE zc_Color_GreenL() END AS Color_calc
      FROM tmpUnitUser

           INNER JOIN Object AS Object_User ON Object_User.ID = tmpUnitUser.UserID

           INNER JOIN Object AS Object_Unit ON Object_Unit.ID = tmpUnitUser.UnitID

           LEFT JOIN tmpNoSales ON tmpNoSales.UnitId = tmpUnitUser.UnitID
                               AND tmpNoSales.UserId = tmpUnitUser.UserId
                               
           LEFT JOIN tmpSummaIlliquid ON tmpSummaIlliquid.UserID = tmpUnitUser.UserID

           LEFT JOIN tmpUserSalesOk ON tmpUserSalesOk.UserId = tmpUnitUser.UserId
           
           LEFT JOIN tmpUserUnitManDays ON tmpUserUnitManDays.UnitId = tmpUnitUser.UnitID
                                       AND tmpUserUnitManDays.UserId = tmpUnitUser.UserId

           LEFT JOIN ObjectFloat AS ObjectFloat_NormOfManDays
                                 ON ObjectFloat_NormOfManDays.ObjectId = Object_Unit.Id
                                AND ObjectFloat_NormOfManDays.DescId = zc_ObjectFloat_Unit_NormOfManDays()

           LEFT JOIN tmpUser ON tmpUser.UserID = tmpUnitUser.UserId
          
           LEFT JOIN tmPersonal_View AS Personal_View 
                                     ON Personal_View.UserID =  tmpUnitUser.UserId
                                    AND Personal_View.Ord = 1;  
    END IF;


--raise notice 'Value 7: %', CLOCK_TIMESTAMP();

--  --raise notice 'Value 06: %', (select Count(*) from tmpMovement where tmpMovement.UserID = 4036597);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.02.20                                                       *
 19.12.19                                                       *
 18.12.19                                                       *
 27.10.19                                                       *
*/

-- тест
-- select * from gpReport_IlliquidReductionPlanAll(inStartDate := ('01.06.2021')::TDateTime , inProcGoods := 20 , inProcUnit := 10 , inPlanAmount := 5 , inPenalty := 250 , inisPenaltyInfo := 'False' , inPenaltySum := 250 , inisPenaltySumInfo := 'False' ,  inSession := '3')
 

select * FROM gpReport_IlliquidReductionPlanAll(inStartDate := '31.12.2022', inProcGoods :=20, inProcUnit := 8, inPlanAmount := 4, inPenalty := 250, inisPenaltyInfo := FALSE, inPenaltySum := 250, inisPenaltySumInfo := False, inSession := '3') 