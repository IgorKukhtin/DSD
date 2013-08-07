-- Function: gpInsertUpdate_HistoryCost()

-- DROP FUNCTION gpInsertUpdate_HistoryCost (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_HistoryCost(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inItearationCount Integer , --
    IN inInsert          Integer , --
    IN inSession         TVarChar    -- сессия пользователя
)                              
--  RETURNS VOID
  RETURNS TABLE (vbItearation Integer, vbCountDiff Integer, Price TFloat, PriceNext TFloat, ObjectCostId Integer, FromObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat, CalcSummNext TFloat)
--  RETURNS TABLE (MasterObjectCostId Integer, ObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat)
AS
$BODY$
   DECLARE vbItearation Integer;
   DECLARE vbCountDiff Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());


     -- таблица - Список сущностей которые являются элементами с/с.
     CREATE TEMP TABLE _tmpMaster (ObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat) ON COMMIT DROP;
     -- таблица - расходы для Master
     CREATE TEMP TABLE _tmpChild (MasterObjectCostId Integer, ObjectCostId Integer, OperCount TFloat) ON COMMIT DROP;

     -- таблица - движения за период
     CREATE TEMP TABLE _tmpAll (MasterObjectCostId Integer, ObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat) ON COMMIT DROP;
     -- таблица - Остаток + движения за период
     CREATE TEMP TABLE _tmpRemains (ObjectCostId Integer, AllCount TFloat, AllSumm TFloat, EndCount TFloat, EndSumm TFloat) ON COMMIT DROP;


     -- заполняем таблицу - движения
     INSERT INTO _tmpAll (MasterObjectCostId, ObjectCostId, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm)
        -- Количество - ост, приход
        SELECT 0 AS MasterObjectCostId
             , COALESCE (ContainerObjectCost.ObjectCostId, 0) AS ObjectCostId
             , tmpContainer.StartCount
             , 0 AS StartSumm
             , tmpContainer.IncomeCount
             , 0 AS IncomeSumm
             , 0 AS CalcCount
             , 0 AS CalcSumm
        FROM (SELECT Container.Id AS ContainerId
                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartCount
                   , COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) AS IncomeCount
                   -- , 0 AS OutCount -- COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) AS OutCount
              FROM Container
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.Containerid = Container.Id
                                                  AND MIContainer.OperDate >= inStartDate
              WHERE Container.DescId = zc_Container_Count()
-- and 1=0
              GROUP BY Container.Id
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) <> 0)
                  -- OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
             ) AS tmpContainer
             LEFT JOIN Container AS Container_Summ
                                 ON Container_Summ.ParentId = tmpContainer.ContainerId
                                AND Container_Summ.DescId = zc_Container_Summ()
             LEFT JOIN ContainerObjectCost ON ContainerObjectCost.Containerid = Container_Summ.Id
                                          AND ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis()
       UNION ALL
        -- Сумма - ост, приход
        SELECT 0 AS MasterObjectCostId
             , COALESCE (ContainerObjectCost.ObjectCostId, 0) AS ObjectCostId
             , 0 AS StartCount
             , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartSumm
             , 0 AS IncomeCount
             , COALESCE (SUM (CASE WHEN Movement.DescId NOT IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) AS IncomeSumm
--             , COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) AS IncomeSumm
             , 0 AS CalcCount
             , COALESCE (SUM (CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) AS CalcSumm
        FROM Container AS Container_Count
             JOIN Container ON Container.ParentId = Container_Count.Id
                           AND Container.DescId = zc_Container_Summ()
             LEFT JOIN MovementItemContainer AS MIContainer
                                             ON MIContainer.Containerid = Container.Id
                                            AND MIContainer.OperDate >= inStartDate
             LEFT JOIN ContainerObjectCost ON ContainerObjectCost.Containerid = Container.Id
                                          AND ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
        WHERE Container_Count.DescId = zc_Container_Count()
-- and 1=0
        GROUP BY ContainerObjectCost.ObjectCostId
               , Container.Amount
        HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
            OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) <> 0)
            -- OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
/*       UNION ALL
        -- Количество - РАСХОД Перемещение
        SELECT COALESCE (ContainerObjectCost_In.ObjectCostId, 0) AS MasterObjectCostId
             , COALESCE (ContainerObjectCost_Out.ObjectCostId, 0) AS ObjectCostId
             , 0 AS StartCount
             , 0 AS StartSumm
             , 0 AS IncomeCount
             , 0 AS IncomeSumm
             , - SUM (MIContainer_Count_Out.Amount) AS CalcCount
             , - SUM (MIContainer_Summ_Out.Amount) AS CalcSumm
        FROM Movement
             JOIN MovementItemContainer AS MIContainer_Count_Out
                                        ON MIContainer_Count_Out.MovementId = Movement.Id
                                       AND MIContainer_Count_Out.Amount < 0
                                       AND MIContainer_Count_Out.DescId = zc_MIContainer_Count()
             JOIN MovementItemContainer AS MIContainer_Count_In
                                        ON MIContainer_Count_In.MovementItemId = MIContainer_Count_Out.MovementItemId
                                       AND MIContainer_Count_In.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_In.Amount > 0
             JOIN MovementItemContainer AS MIContainer_Summ_Out
                                        ON MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                                       AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()
                                       AND MIContainer_Summ_Out.Amount < 0
             JOIN MovementItemContainer AS MIContainer_Summ_In
                                        ON MIContainer_Summ_In.MovementItemId = MIContainer_Count_In.MovementItemId
                                       AND MIContainer_Summ_In.DescId = zc_MIContainer_Summ()
                                       AND MIContainer_Summ_In.Amount > 0
             LEFT JOIN ContainerObjectCost AS ContainerObjectCost_Out
                                           ON ContainerObjectCost_Out.Containerid = MIContainer_Summ_Out.ContainerId
                                          AND ContainerObjectCost_Out.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN ContainerObjectCost AS ContainerObjectCost_In
                                           ON ContainerObjectCost_In.Containerid = MIContainer_Summ_In.ContainerId
                                          AND ContainerObjectCost_In.ObjectCostDescId = zc_ObjectCost_Basis()
        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId = zc_Movement_Send()
          AND Movement.StatusId = zc_Enum_Status_Complete()
        GROUP BY ContainerObjectCost_In.ObjectCostId
               , ContainerObjectCost_Out.ObjectCostId
       UNION ALL
        -- Количество - РАСХОД Смешивание
        SELECT COALESCE (ContainerObjectCost_In.ObjectCostId, 0) AS MasterObjectCostId
             , COALESCE (ContainerObjectCost_Out.ObjectCostId, 0) AS ObjectCostId
             , 0 AS StartCount
             , 0 AS StartSumm
             , 0 AS IncomeCount
             , 0 AS IncomeSumm
             , - SUM (MIContainer_Count_Out.Amount) AS CalcCount
             , - SUM (MIContainer_Summ_Out.Amount) AS CalcSumm
        FROM Movement
             JOIN MovementItemContainer AS MIContainer_Count_Out
                                        ON MIContainer_Count_Out.MovementId = Movement.Id
                                       AND MIContainer_Count_Out.Amount < 0
                                       AND MIContainer_Count_Out.DescId = zc_MIContainer_Count()
             JOIN MovementItem AS MI_Out ON MI_Out.Id = MIContainer_Count_Out.MovementItemId
             JOIN MovementItemContainer AS MIContainer_Count_In
                                        ON MIContainer_Count_In.MovementItemId = MI_Out.ParentId
                                       AND MIContainer_Count_In.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_In.Amount >= 0
             JOIN MovementItemContainer AS MIContainer_Summ_Out
                                        ON MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                                       AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()
--                                       AND MIContainer_Summ_Out.Amount < 0
             JOIN MovementItemContainer AS MIContainer_Summ_In
                                        ON MIContainer_Summ_In.MovementItemId = MIContainer_Count_In.MovementItemId
                                       AND MIContainer_Summ_In.DescId = zc_MIContainer_Summ()
--                                       AND MIContainer_Summ_In.Amount > 0
             LEFT JOIN ContainerObjectCost AS ContainerObjectCost_Out
                                           ON ContainerObjectCost_Out.Containerid = MIContainer_Summ_Out.ContainerId
                                          AND ContainerObjectCost_Out.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN ContainerObjectCost AS ContainerObjectCost_In
                                           ON ContainerObjectCost_In.Containerid = MIContainer_Summ_In.ContainerId
                                          AND ContainerObjectCost_In.ObjectCostDescId = zc_ObjectCost_Basis()
        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId = zc_Movement_ProductionUnion()
          AND Movement.StatusId = zc_Enum_Status_Complete()
        GROUP BY ContainerObjectCost_In.ObjectCostId
               , ContainerObjectCost_Out.ObjectCostId
       UNION ALL
        -- Количество - РАСХОД Разделение (приводим N:N как 1:1)
        SELECT COALESCE (ContainerObjectCost_In.ObjectCostId, 0) AS MasterObjectCostId
             , COALESCE (ContainerObjectCost_Out.ObjectCostId, 0) AS ObjectCostId
             , 0 AS StartCount
             , 0 AS StartSumm
             , 0 AS IncomeCount
             , 0 AS IncomeSumm
             , SUM (CASE WHEN _tmp.Summ <> 0 THEN COALESCE (-MIContainer_Count_Out.Amount * MIContainer_Summ_In.Amount / _tmp.Summ, 0) ELSE 0 END) AS CalcCount
             , SUM (CASE WHEN _tmp.Summ <> 0 THEN COALESCE (-MIContainer_Count_Out.Amount * MIContainer_Summ_In.Amount / _tmp.Summ, 0)
                                                * COALESCE (CASE WHEN MIContainer_Count_Out.Amount <> 0 THEN MIContainer_Summ_Out.Amount / MIContainer_Count_Out.Amount ELSE 0 END, 0)
                         ELSE 0
                    END) AS CalcSumm
        FROM Movement
             JOIN MovementItemContainer AS MIContainer_Count_Out
                                        ON MIContainer_Count_Out.MovementId = Movement.Id
                                       AND MIContainer_Count_Out.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_Out.Amount < 0
             JOIN MovementItemContainer AS MIContainer_Count_In
                                        ON MIContainer_Count_In.MovementId = Movement.Id
                                       AND MIContainer_Count_In.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_In.Amount >= 0
             JOIN MovementItemContainer AS MIContainer_Summ_Out
                                        ON MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                                       AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()
--                                       AND MIContainer_Summ_Out.Amount < 0
             JOIN MovementItemContainer AS MIContainer_Summ_In
                                        ON MIContainer_Summ_In.MovementItemId = MIContainer_Count_In.MovementItemId
                                       AND MIContainer_Summ_In.DescId = zc_MIContainer_Summ()
--                                       AND MIContainer_Summ_In.Amount > 0
             LEFT JOIN ContainerObjectCost AS ContainerObjectCost_Out
                                           ON ContainerObjectCost_Out.Containerid = MIContainer_Summ_Out.ContainerId
                                          AND ContainerObjectCost_Out.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN ContainerObjectCost AS ContainerObjectCost_In
                                           ON ContainerObjectCost_In.Containerid = MIContainer_Summ_In.ContainerId
                                          AND ContainerObjectCost_In.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN
             (SELECT Movement.Id AS  MovementId
                   , COALESCE (SUM (-MIContainer_Summ_Out.Amount), 0) AS Summ
              FROM Movement
                   LEFT JOIN MovementItemContainer AS MIContainer_Summ_Out
                                                   ON MIContainer_Summ_Out.MovementId = Movement.Id
                                                  AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()
                                                  AND MIContainer_Summ_Out.Amount < 0
              WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                AND Movement.DescId = zc_Movement_ProductionSeparate()
                AND Movement.StatusId = zc_Enum_Status_Complete()
              GROUP BY Movement.Id
             ) AS _tmp ON _tmp.MovementId = Movement.Id

        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId = zc_Movement_ProductionSeparate()
          AND Movement.StatusId = zc_Enum_Status_Complete()
        GROUP BY ContainerObjectCost_In.ObjectCostId
               , ContainerObjectCost_Out.ObjectCostId*/
        ;


     -- tmp - test
     /*RETURN QUERY
      SELECT _tmpAll.MasterObjectCostId, _tmpAll.ObjectCostId, _tmpAll.StartCount, _tmpAll.StartSumm, _tmpAll.IncomeCount, _tmpAll.IncomeSumm, _tmpAll.CalcCount, _tmpAll.CalcSumm FROM _tmpAll
      WHERE (_tmpAll.MasterObjectCostId in (14837, 14886, 14849,  13928, 8212) or _tmpAll.ObjectCostId in (14837, 14886, 14849,  13928, 8212)) -- AND _tmpAll.ObjectCostId = 14837
      ORDER BY 1, 2;
     RETURN;*/
     


     -- Формируется Master для итераций
     INSERT INTO _tmpMaster (ObjectCostId, StartCount, StartSumm, IncomeCount, IncomeSumm , CalcCount, CalcSumm)
        SELECT _tmpAll.ObjectCostId, SUM (_tmpAll.StartCount), SUM (_tmpAll.StartSumm), SUM (_tmpAll.IncomeCount), SUM (_tmpAll.IncomeSumm)
             , 0 -- SUM (CASE WHEN _tmpAll.MasterObjectCostId = _tmpAll.ObjectCostId THEN _tmpAll.CalcCount ELSE 0 END) AS CalcCount
             , 0 -- SUM (CASE WHEN _tmpAll.MasterObjectCostId = _tmpAll.ObjectCostId THEN -_tmpAll.CalcSumm WHEN _tmpAll.MasterObjectCostId = 0 THEN _tmpAll.CalcSumm ELSE 0 END) AS CalcSumm
        FROM _tmpAll GROUP BY _tmpAll.ObjectCostId;

     -- Формируется Child для итераций
     INSERT INTO _tmpChild (MasterObjectCostId, ObjectCostId, OperCount)
        SELECT _tmpAll.MasterObjectCostId, _tmpAll.ObjectCostId, SUM (_tmpAll.CalcCount) FROM _tmpAll WHERE _tmpAll.CalcCount <> 0 GROUP BY _tmpAll.MasterObjectCostId, _tmpAll.ObjectCostId;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - САМА с/с !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     vbItearation:=0;
     vbCountDiff:= 100000;
     WHILE vbItearation < inItearationCount AND vbCountDiff > 0
     LOOP
         UPDATE _tmpMaster SET CalcSumm = _tmpSumm.CalcSumm
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterObjectCostId AS ObjectCostId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ObjectCostId
                          , CASE WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                     THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount)
                                 ELSE 0
                            END AS OperPrice
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ObjectCostId = _tmpPrice.ObjectCostId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterObjectCostId <> _tmpChild.ObjectCostId

               GROUP BY _tmpChild.MasterObjectCostId
              ) AS _tmpSumm 
         WHERE _tmpMaster.ObjectCostId = _tmpSumm.ObjectCostId;

         -- увеличивам итерации
         vbItearation:= vbItearation + 1;
         -- сколько записей еще с неправильной с/с
         SELECT Count(*) INTO vbCountDiff
         FROM _tmpMaster
               -- Расчет суммы всех составляющих
            , (SELECT _tmpChild.MasterObjectCostId AS ObjectCostId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ObjectCostId
                          , CASE WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                     THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount)
                                 ELSE 0
                            END AS OperPrice
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ObjectCostId = _tmpPrice.ObjectCostId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterObjectCostId <> _tmpChild.ObjectCostId
               GROUP BY _tmpChild.MasterObjectCostId
              ) AS _tmpSumm 
         WHERE _tmpMaster.ObjectCostId = _tmpSumm.ObjectCostId
           AND _tmpMaster.CalcSumm <> _tmpSumm.CalcSumm;

     END LOOP;


     IF inInsert > 0 THEN

     -- Удаляем предыдущую с/с
     DELETE FROM HistoryCost WHERE (inStartDate BETWEEN StartDate AND EndDate) OR (inEndDate BETWEEN StartDate AND EndDate);

     -- Сохраняем что насчитали
     INSERT INTO HistoryCost (ObjectCostId, StartDate, EndDate, Price, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm)
        SELECT _tmpMaster.ObjectCostId, inStartDate AS StartDate, inEndDate AS EndDate
             , CASE WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                       OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                        THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount)
                    ELSE 0
               END AS Price
             , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm
        FROM _tmpMaster
        WHERE ((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) <> 0)
        ;

     END IF; -- if inInsert > 0

     IF inInsert <> 12345 THEN -- 12345 - для Load_PostgreSql
     -- tmp - test
     RETURN QUERY
        SELECT vbItearation, vbCountDiff
             , CAST (CASE WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount - _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount - _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                              THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount - _tmpMaster.CalcCount)
                      END AS TFloat) AS Price
             , CAST (CASE WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount - _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount - _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) < 0))
                              THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount - _tmpMaster.CalcCount)
                     END AS TFloat) AS PriceNext
             , _tmpMaster.ObjectCostId
             , _tmpSumm.FromObjectCostId
             , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpSumm.CalcSumm AS CalcSummNext
         FROM _tmpMaster LEFT JOIN
               -- Расчет суммы всех составляющих
              (SELECT _tmpChild.MasterObjectCostId AS ObjectCostId
--                    , _tmpChild.ObjectCostId AS FromObjectCostId
                    , 0 AS FromObjectCostId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ObjectCostId
                          , CASE WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                     THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount)
                                 ELSE 0
                            END AS OperPrice
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ObjectCostId = _tmpPrice.ObjectCostId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterObjectCostId <> _tmpChild.ObjectCostId
               GROUP BY _tmpChild.MasterObjectCostId
--                      , _tmpChild.ObjectCostId
              ) AS _tmpSumm ON _tmpMaster.ObjectCostId = _tmpSumm.ObjectCostId
        ;
     END IF; -- if inInsert <> 12345

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.13                                        * add JOIN Container
 10.07.13                                        *
*/

/*
     INSERT INTO _tmpMaster (ObjectCostId, StartCount, StartSumm, IncomeCount, IncomeSumm , CalcCount, CalcSumm)
        SELECT CAST (1 AS Integer) AS ObjectCostId, CAST (30 AS TFloat) AS StartCount, CAST (280 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (2 AS Integer) AS ObjectCostId, CAST (50 AS TFloat) AS StartCount, CAST (340 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (3 AS Integer) AS ObjectCostId, CAST (20 AS TFloat) AS StartCount, CAST (0 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (4 AS Integer) AS ObjectCostId, CAST (13 AS TFloat) AS StartCount, CAST (14 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (5 AS Integer) AS ObjectCostId, CAST (20 AS TFloat) AS StartCount, CAST (20 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       ;
     -- таблица - Все расходы
     INSERT INTO _tmpChild (MasterObjectCostId, ObjectCostId, OperCount)
        SELECT 3 AS MasterObjectCostId, 1 AS ObjectCostId, 5 AS OperCount
       UNION ALL
        SELECT 3 AS MasterObjectCostId, 2 AS ObjectCostId, 7 AS OperCount
       UNION ALL
        SELECT 3 AS MasterObjectCostId, 5 AS ObjectCostId, 2 AS OperCount
       UNION ALL
        SELECT 5 AS MasterObjectCostId, 1 AS ObjectCostId, 4 AS OperCount
       UNION ALL
        SELECT 5 AS MasterObjectCostId, 2 AS ObjectCostId, 6 AS OperCount
       UNION ALL
        SELECT 5 AS MasterObjectCostId, 3 AS ObjectCostId, 2 AS OperCount
       UNION ALL
        SELECT 5 AS MasterObjectCostId, 4 AS ObjectCostId, 1 AS OperCount
       UNION ALL
        SELECT 4 AS MasterObjectCostId, 3 AS ObjectCostId, 10 AS OperCount
       ;


     INSERT INTO _tmpMaster (ObjectCostId, StartCount, StartSumm, IncomeCount, IncomeSumm , CalcCount, CalcSumm)
        SELECT CAST (1 AS Integer) AS ObjectCostId, CAST (60 AS TFloat) AS StartCount, CAST (280 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (2 AS Integer) AS ObjectCostId, CAST (60 AS TFloat) AS StartCount, CAST (0 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (3 AS Integer) AS ObjectCostId, CAST (4 AS TFloat) AS StartCount, CAST (14 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (4 AS Integer) AS ObjectCostId, CAST (5 AS TFloat) AS StartCount, CAST (20 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       ;
     -- таблица - Все расходы
     INSERT INTO _tmpChild (MasterObjectCostId, ObjectCostId, OperCount)
        SELECT 2 AS MasterObjectCostId, 1 AS ObjectCostId, 30 AS OperCount
       UNION ALL
        SELECT 2 AS MasterObjectCostId, 3 AS ObjectCostId, 1 AS OperCount
       UNION ALL
        SELECT 2 AS MasterObjectCostId, 4 AS ObjectCostId, 1 AS OperCount
       UNION ALL
        SELECT 2 AS MasterObjectCostId, 2 AS ObjectCostId, 30 AS OperCount
       UNION ALL
        SELECT 1 AS MasterObjectCostId, 2 AS ObjectCostId, 30 AS OperCount
       ;

*/

-- тест
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.01.2013', inEndDate:= '31.01.2013', inItearationCount:= 1, inInsert:= -1, inSession:= '2') WHERE ObjectCostId = 15148
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.01.2013', inEndDate:= '31.01.2013', inItearationCount:= 100, inInsert:= -1, inSession:= '2') WHERE Price <> PriceNext

