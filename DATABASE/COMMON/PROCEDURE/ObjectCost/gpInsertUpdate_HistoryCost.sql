-- Function: gpInsertUpdate_HistoryCost()

-- DROP FUNCTION gpInsertUpdate_HistoryCost (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_HistoryCost(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)                              
--  RETURNS VOID AS
  RETURNS TABLE (Price TFloat, ObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat)
AS
$BODY$
   DECLARE vbItearation Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());


     -- таблица - Список сущностей которые являются элементами с/с.
     CREATE TEMP TABLE _tmpMaster (ObjectCostId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat) ON COMMIT DROP;
     -- таблица - расходы для Master
     CREATE TEMP TABLE _tmpChild (MasterObjectCostId Integer, ObjectCostId Integer, OperCount TFloat) ON COMMIT DROP;

     -- таблица - движения за период
     CREATE TEMP TABLE _tmpItem (MovementDescId Integer, ObjectCostId Integer, MovementItemId Integer, ObjectId Integer, AllCount TFloat, AllSumm TFloat) ON COMMIT DROP;
     -- таблица - Остаток + движения за период
     CREATE TEMP TABLE _tmpRemains (ObjectCostId Integer, AllCount TFloat, AllSumm TFloat, EndCount TFloat, EndSumm TFloat) ON COMMIT DROP;

/*
     -- заполняем таблицу - движения
     INSERT INTO _tmpItem (MovementDescId, ObjectCostId, MovementItemId, ObjectId, AllCount, AllSumm)
        SELECT
        FROM MovementItemContainer AS MIContainer_Summ
             LEFT JOIN ContainerObjectCost ON ContainerObjectCost.ContainerId = MIContainer_Summ.ContainerId
        WHERE MIContainer_Summ.OperDate BETWEEN inStartDate AND inEndDate
          AND MIContainer_Summ.DescId = zc_MIContainer_Summ
        GROUP BY ContainerObjectCost.ObjectCostId;


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
     WHILE vbItearation < 10 
     LOOP
         vbItearation:=vbItearation+1;
         UPDATE _tmpMaster SET CalcSumm = _tmpSumm.CalcSumm
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterObjectCostId AS ObjectCostId
                    , SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS CalcSumm
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
     END LOOP;



     RETURN QUERY SELECT CAST (CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) <> 0
                                 THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                         END AS TFloat) AS Price
                      , _tmpMaster.ObjectCostId, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm
                  FROM _tmpMaster; 

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 10.07.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')

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
*/