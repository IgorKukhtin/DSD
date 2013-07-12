-- Function: gpInsertUpdate_HistoryCost()

-- DROP FUNCTION gpInsertUpdate_HistoryCost (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_HistoryCost(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)                              
--  RETURNS VOID AS
  RETURNS TABLE (vbItearation Integer, Price TFloat, PriceNext TFloat, ObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat, CalcSummNext TFloat)
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
     CREATE TEMP TABLE _tmpAll (MasterObjectCostId Integer, ObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, OutCount TFloat, OutSumm TFloat) ON COMMIT DROP;
     -- таблица - Остаток + движения за период
     CREATE TEMP TABLE _tmpRemains (ObjectCostId Integer, AllCount TFloat, AllSumm TFloat, EndCount TFloat, EndSumm TFloat) ON COMMIT DROP;


     -- заполняем таблицу - движения
     INSERT INTO _tmpAll (MasterObjectCostId, ObjectCostId, StartCount, StartSumm, IncomeCount, IncomeSumm, OutCount, OutSumm)
        -- Количество
        SELECT 0 AS MasterObjectCostId
             , COALESCE (ContainerObjectCost.ObjectCostId, 0) AS ObjectCostId
             , tmpContainer.StartCount
             , 0 AS StartSumm
             , tmpContainer.IncomeCount
             , 0 AS IncomeSumm
             , tmpContainer.OutCount
             , 0 AS OutSumm
        FROM (SELECT Container.Id AS ContainerId
                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartCount
                   , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS IncomeCount
                   , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) AS OutCount
              FROM Container
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.Containerid = Container.Id
                                                  AND MIContainer.OperDate >= inStartDate
              WHERE Container.DescId = zc_Container_Count()
              GROUP BY Container.Id
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
             ) AS tmpContainer
             LEFT JOIN Container AS Container_Summ
                                 ON Container_Summ.ParentId = tmpContainer.ContainerId
                                AND Container_Summ.DescId = zc_Container_Summ()
             LEFT JOIN ContainerObjectCost ON ContainerObjectCost.Containerid = Container_Summ.Id
                                          AND ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis()
       UNION ALL
        -- Сумма
        SELECT 0 AS MasterObjectCostId
             , COALESCE (ContainerObjectCost.ObjectCostId, 0) AS ObjectCostId
             , 0 AS StartCount
             , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartSumm
             , 0 AS IncomeCount
             , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS IncomeSumm
             , 0 AS OutCount
             , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) AS OutSumm
        FROM Container
             LEFT JOIN MovementItemContainer AS MIContainer
                                             ON MIContainer.Containerid = Container.Id
                                            AND MIContainer.OperDate >= inStartDate
             LEFT JOIN ContainerObjectCost ON ContainerObjectCost.Containerid = Container.Id
                                          AND ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis()
        WHERE Container.DescId = zc_Container_Summ()
-- and 1=0
        GROUP BY ContainerObjectCost.ObjectCostId
               , Container.Amount
        HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) <> 0)
            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
        ;

     INSERT INTO _tmpMaster (ObjectCostId, StartCount, StartSumm, IncomeCount, IncomeSumm , CalcCount, CalcSumm)
        SELECT _tmpAll.ObjectCostId, SUM (_tmpAll.StartCount), SUM (_tmpAll.StartSumm), SUM (_tmpAll.IncomeCount), SUM (_tmpAll.IncomeSumm), SUM (_tmpAll.OutCount), SUM (_tmpAll.OutSumm) FROM _tmpAll GROUP BY _tmpAll.ObjectCostId;

/*
     -- заполняем таблицу - Остаток
     INSERT INTO _tmpMaster (MasterObjectCostId, ChildObjectCostId, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm)
        SELECT
              ContainerObjectCost.ObjectCostId
            , 
        FROM MovementItemContainer AS MIContainer_Summ
             LEFT JOIN ContainerObjectCost ON ContainerObjectCost.ContainerId = MIContainer_Summ.ContainerId
        WHERE MIContainer_Summ.OperDate BETWEEN inStartDate AND inEndDate
          AND MIContainer_Summ.DescId = zc_MIContainer_Summ
        GROUP BY ContainerObjectCost.ObjectCostId;

*/

--     return;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - САМА с/с !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     vbItearation:=0;
     vbCountDiff:= 100000;
     WHILE vbItearation < 100 AND vbCountDiff > 0
     LOOP
         UPDATE _tmpMaster SET CalcSumm = _tmpSumm.CalcSumm
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterObjectCostId AS ObjectCostId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                      FROM 
                          -- Расчет цены
                          (SELECT _tmpMaster.ObjectCostId
                                , CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0
                                          THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                                       WHEN  (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0
                                          THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                                       ELSE 0
                                  END AS OperPrice
                           FROM _tmpMaster
                          ) AS _tmpPrice 
                          JOIN _tmpChild ON _tmpChild.ObjectCostId = _tmpPrice.ObjectCostId
                                            -- Отбрасываем в том случае если сам в себя
                                        AND _tmpChild.MasterObjectCostId <> _tmpChild.ObjectCostId

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
                                , CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0
                                          THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                                       WHEN  (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0
                                          THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                                       ELSE 0
                                  END AS OperPrice
                           FROM _tmpMaster
                          ) AS _tmpPrice 
                          JOIN _tmpChild ON _tmpChild.ObjectCostId = _tmpPrice.ObjectCostId
                                            -- Отбрасываем в том случае если сам в себя
                                        AND _tmpChild.MasterObjectCostId <> _tmpChild.ObjectCostId

                      GROUP BY _tmpChild.MasterObjectCostId
                     ) AS _tmpSumm 
         WHERE _tmpMaster.ObjectCostId = _tmpSumm.ObjectCostId
           AND _tmpMaster.CalcSumm <> _tmpSumm.CalcSumm;

     END LOOP;

     -- tmp return
     RETURN QUERY SELECT vbItearation
                       , CAST (CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) <> 0
                                       THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                               END AS TFloat) AS Price
                       , CAST (CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) <> 0
                                       THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                               END AS TFloat) AS PriceNext
                       , _tmpMaster.ObjectCostId, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpSumm.CalcSumm AS CalcSummNext
                  FROM _tmpMaster LEFT JOIN
               -- Расчет суммы всех составляющих
              (SELECT _tmpChild.MasterObjectCostId AS ObjectCostId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                      FROM 
                          -- Расчет цены
                          (SELECT _tmpMaster.ObjectCostId
                                , CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0
                                          THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                                       WHEN  (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0
                                          THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                                       ELSE 0
                                  END AS OperPrice
                           FROM _tmpMaster
                          ) AS _tmpPrice 
                          JOIN _tmpChild ON _tmpChild.ObjectCostId = _tmpPrice.ObjectCostId
                                            -- Отбрасываем в том случае если сам в себя
                                        AND _tmpChild.MasterObjectCostId <> _tmpChild.ObjectCostId

                      GROUP BY _tmpChild.MasterObjectCostId
                     ) AS _tmpSumm ON _tmpMaster.ObjectCostId = _tmpSumm.ObjectCostId
     ;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
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
*/

-- тест
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
