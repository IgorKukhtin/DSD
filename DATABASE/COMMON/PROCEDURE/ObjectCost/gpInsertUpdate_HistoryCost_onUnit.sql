-- Function: gpInsertUpdate_HistoryCost()

DROP FUNCTION IF EXISTS gpInsertUpdate_HistoryCost (TDateTime, TDateTime, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_HistoryCost(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inItearationCount Integer , --
    IN inInsert          Integer , --
    IN inDiffSumm        TFloat , --
    IN inSession         TVarChar    -- сессия пользователя
)                              
--  RETURNS VOID
  RETURNS TABLE (vbItearation Integer, vbCountDiff Integer, Price TFloat, PriceNext TFloat, FromContainerId Integer, ContainerId Integer, isInfoMoney_80401 Boolean, CalcSummCurrent TFloat, CalcSummNext TFloat, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, OutCount TFloat, OutSumm TFloat)
--  RETURNS TABLE (ContainerId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, OutCount TFloat, OutSumm TFloat)
--  RETURNS TABLE (MasterContainerId Integer, ContainerId Integer, OperCount TFloat)
AS
$BODY$
   DECLARE vbItearation Integer;
   DECLARE vbCountDiff Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());


     -- таблица - Список сущностей которые являются элементами с/с.
     CREATE TEMP TABLE _tmpMaster (ContainerId Integer, isInfoMoney_80401 Boolean, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, OutCount TFloat, OutSumm TFloat) ON COMMIT DROP;
     -- таблица - расходы для Master
     CREATE TEMP TABLE _tmpChild (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat) ON COMMIT DROP;

     -- таблица - расходы для Master
     CREATE TEMP TABLE _tmpUnit_only (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_only (UnitId)
        SELECT 345023 -- Кротон хранение
       UNION ALL
        SELECT 403933 -- Дюков хранение
       UNION ALL
        SELECT 8455   -- Склад специй
       ;


     -- таблица
     CREATE TEMP TABLE _tmpContainer_only (ContainerId Integer) ON COMMIT DROP;

        WITH tmp AS (SELECT MIContainer.MovementId
                     FROM Container
                          INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                  ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                 AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                          INNER JOIN _tmpUnit_only ON _tmpUnit_only.UnitId = ContainerLinkObject_Unit.ObjectId

                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.ContainerId = Container.Id
                                                         AND MIContainer.OperDate between  inStartDate and inEndDate
                     GROUP BY MIContainer.MovementId
                    )
     INSERT INTO _tmpContainer_only (ContainerId) 
         SELECT MIContainer.ContainerId
         FROM tmp
              LEFT JOIN MovementItemContainer AS MIContainer
                                              ON MIContainer.MovementId = tmp.MovementId
         GROUP BY MIContainer.ContainerId;


     -- заполняем таблицу Количество и Сумма - ост, приход, расход
        WITH tmpContainerList AS (SELECT Container_Summ.Id, Container_Summ.ParentId
                                  FROM Container AS Container_Summ
                                       inner join _tmpContainer_only ON _tmpContainer_only.ContainerId = Container_Summ.Id
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container_Summ.Id
                                                                      AND MIContainer.OperDate >= inStartDate
        
                                  WHERE Container_Summ.DescId = zc_Container_Summ()
                                    AND Container_Summ.ParentId > 0
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_20901() -- Оборотная тара
                                  GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount
                                  HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0 -- AS StartSumm
                                      OR MAX (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN Container_Summ.Id ELSE 0 END) > 0
                                 )
     INSERT INTO _tmpMaster (ContainerId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, OutCount, OutSumm)
        SELECT COALESCE (Container_Summ.Id, tmpContainer.ContainerId) AS ContainerId
             , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                         THEN TRUE
                    ELSE FALSE
               END AS isInfoMoney_80401 -- прибыль текущего периода

             , SUM (tmpContainer.StartCount)
             , SUM (tmpContainer.StartSumm)
             , SUM (tmpContainer.IncomeCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                                                             THEN tmpContainer.SendOnPriceCountIn_Cost
                                                          ELSE 0 -- tmpContainer.SendOnPriceCountIn
                                                     END)
                                              + SUM (CASE WHEN ObjectLink_Unit_HistoryCost.ChildObjectId > 0 
                                                             THEN tmpContainer.ReturnInCount
                                                          ELSE 0
                                                     END)
             , SUM (tmpContainer.IncomeSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                                                              THEN tmpContainer.SendOnPriceSummIn_Cost
                                                         ELSE 0 -- tmpContainer.SendOnPriceSummIn
                                                    END)
                                              + SUM (CASE WHEN ObjectLink_Unit_HistoryCost.ChildObjectId > 0
                                                             THEN tmpContainer.ReturnInSumm
                                                          ELSE 0
                                                     END)
             , SUM (tmpContainer.calcCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                                                             THEN 0
                                                          ELSE tmpContainer.SendOnPriceCountIn
                                                     END)
             , SUM (tmpContainer.calcSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                                                              THEN 0
                                                         ELSE tmpContainer.SendOnPriceSummIn
                                                    END)
             , SUM (tmpContainer.OutCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                                                            THEN tmpContainer.SendOnPriceCountOut_Cost
                                                       ELSE tmpContainer.SendOnPriceCountOut
                                                  END)
             , SUM (tmpContainer.OutSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                                                           THEN tmpContainer.SendOnPriceSummOut_Cost
                                                      ELSE tmpContainer.SendOnPriceSummOut
                                                 END)
        FROM (SELECT Container.Id AS ContainerId
                   , Container.DescId
                   , Container.ObjectId
                     -- Start
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartSumm
                     -- Income
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN Movement.DescId IN (zc_Movement_Income()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN Movement.DescId IN (zc_Movement_Income()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeSumm
                     -- SendOnPrice
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut_Cost
                     -- Calc
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN Movement.DescId IN (zc_Movement_ProductionUnion()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm
                     -- ReturnIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInSumm
                     -- Out
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN Movement.DescId NOT IN (zc_Movement_Income(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN Movement.DescId NOT IN (zc_Movement_Income(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutSumm
              FROM Container
                   inner join _tmpContainer_only ON _tmpContainer_only.ContainerId = Container.Id

                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.ContainerId = Container.Id
                                                  AND MIContainer.OperDate >= inStartDate
                   LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                             ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                            AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                   LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
              -- WHERE Container.DescId = IN (zc_Container_Summ(), zc_Container_Count())
              -- where 1=0
              GROUP BY Container.Id
                     , Container.DescId
                     , Container.ObjectId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
             ) AS tmpContainer
             LEFT JOIN tmpContainerList AS Container_Summ ON Container_Summ.ParentId = tmpContainer.ContainerId
                                                         AND tmpContainer.DescId = zc_Container_Count()
             /*LEFT JOIN Container AS Container_Summ
                                 ON Container_Summ.ParentId = tmpContainer.ContainerId
                                AND Container_Summ.DescId = zc_Container_Summ()
                                AND Container_Summ.ObjectId <> zc_Enum_Account_20901() -- "Оборотная тара"
                                AND tmpContainer.DescId = zc_Container_Count()*/
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                           ON ContainerLinkObject_JuridicalBasis.ContainerId = tmpContainer.ContainerId
                                          AND ContainerLinkObject_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                          AND tmpContainer.DescId = zc_Container_Count()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                           ON ContainerLinkObject_Business.ContainerId = tmpContainer.ContainerId
                                          AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                                          AND tmpContainer.DescId = zc_Container_Count()
             /*LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId = tmpContainer.ObjectId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = COALESCE (ContainerLinkObject_JuridicalBasis.ObjectId, 0)
                                                                                 AND lfContainerSumm_20901.BusinessId = COALESCE (ContainerLinkObject_Business.ObjectId, 0)
                                                                                 AND tmpContainer.DescId = zc_Container_Count()*/

             /*LEFT JOIN ContainerObjectCost ON ContainerObjectCost.ObjectCostId = COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, tmpContainer.ContainerId))
                                          AND ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis()*/

             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                           ON ContainerLinkObject_InfoMoney.ContainerId = COALESCE (Container_Summ.Id, tmpContainer.ContainerId)
                                          AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = COALESCE (Container_Summ.Id, tmpContainer.ContainerId)
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()

             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                           ON ContainerLinkObject_Unit.ContainerId = tmpContainer.ContainerId
                                          AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                  ON ObjectLink_Unit_HistoryCost.ObjectId = ContainerLinkObject_Unit.ObjectId
                                 AND ObjectLink_Unit_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
        --GROUP BY COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, tmpContainer.ContainerId)) -- ContainerObjectCost.ObjectCostId
        GROUP BY COALESCE (Container_Summ.Id, tmpContainer.ContainerId) -- ContainerObjectCost.ObjectCostId
               , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() 
                           THEN TRUE
                      ELSE FALSE
                 END
       ;

     -- Ошибка !!! Recycled !!!
     DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (250904, 244751
                                                           , 140871, 132557, 278535, 204974
                                                           , 240687, 250652
                                                            );

     -- расходы для Master
     INSERT INTO _tmpChild (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount)
        SELECT COALESCE (MIContainer_Summ_In.ContainerId, 0)   AS MasterContainerId
             , COALESCE (MIContainer_Summ_Out.ContainerId, 0)  AS ContainerId
             , COALESCE (MIContainer_Count_In.ContainerId, 0)  AS MasterContainerId_Count
             , COALESCE (MIContainer_Count_Out.ContainerId, 0) AS ContainerId_Count
             , SUM (CASE WHEN Movement.DescId IN (zc_Movement_ProductionSeparate())
                             THEN CASE WHEN  COALESCE (_tmp.Summ, 0) <> 0 THEN COALESCE (-MIContainer_Count_Out.Amount * MIContainer_Summ_In.Amount / _tmp.Summ, 0) ELSE 0 END
                         WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                             THEN COALESCE (1 * MIContainer_Count_In.Amount, 0)
                         WHEN Movement.DescId IN (zc_Movement_ProductionUnion())
                             THEN COALESCE (-1 * MIContainer_Count_Out.Amount, 0)
                         ELSE 0
                    END) AS OperCount
        FROM Movement
             JOIN MovementItemContainer AS MIContainer_Count_Out
                                        ON MIContainer_Count_Out.MovementId = Movement.Id
                                       AND MIContainer_Count_Out.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_Out.isActive = FALSE
             JOIN MovementItemContainer AS MIContainer_Summ_Out
                                        ON MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                                       AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()

             JOIN MovementItemContainer AS MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
             JOIN MovementItemContainer AS MIContainer_Count_In
                                        ON MIContainer_Count_In.MovementItemId = MIContainer_Summ_In.MovementItemId
                                       AND MIContainer_Count_In.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_In.isActive = TRUE

             inner join _tmpContainer_only ON _tmpContainer_only.ContainerId = MIContainer_Summ_Out.ContainerId

             /*LEFT JOIN ContainerObjectCost AS ContainerObjectCost_Out
                                           ON ContainerObjectCost_Out.ContainerId = MIContainer_Summ_Out.ContainerId
                                          AND ContainerObjectCost_Out.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN ContainerObjectCost AS ContainerObjectCost_In
                                           ON ContainerObjectCost_In.ContainerId = MIContainer_Summ_In.ContainerId
                                          AND ContainerObjectCost_In.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN (SELECT Movement.Id AS  MovementId
                             , MIContainer_Summ_Out.MovementItemId
                             , MIContainer_Summ_Out.ContainerId
                             , COALESCE (SUM (-1 * MIContainer_Summ_Out.Amount), 0) AS Summ
                        FROM Movement
                             LEFT JOIN MovementItemContainer AS MIContainer_Summ_Out
                                                             ON MIContainer_Summ_Out.MovementId = Movement.Id
                                                            AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()
                                                            AND MIContainer_Summ_Out.isActive = FALSE
                             inner join _tmpContainer_only ON _tmpContainer_only.ContainerId = MIContainer_Summ_Out.ContainerId
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_ProductionSeparate()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY Movement.Id
                               , MIContainer_Summ_Out.MovementItemId
                               , MIContainer_Summ_Out.ContainerId
                       ) AS _tmp ON _tmp.MovementId = Movement.Id
                                AND _tmp.ContainerId = MIContainer_Summ_Out.ContainerId
                                AND _tmp.MovementItemId = MIContainer_Summ_Out.MovementItemId
                                AND Movement.DescId = zc_Movement_ProductionSeparate()
        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          -- AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
          AND Movement.StatusId = zc_Enum_Status_Complete()
        GROUP BY MIContainer_Summ_In.ContainerId
               , MIContainer_Summ_Out.ContainerId
               , MIContainer_Count_In.ContainerId
               , MIContainer_Count_Out.ContainerId
        ;

/*
     -- добавляются связи которых нет (т.к. нулевые проводки не формируются)
     INSERT INTO _tmpChild (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount)
        SELECT HistoryCostContainerLink.MasterContainerId_Summ
             , HistoryCostContainerLink.ChildContainerId_Summ
             , HistoryCostContainerLink.MasterContainerId_Count
             , HistoryCostContainerLink.ChildContainerId_Count
             , SUM (_tmpChild_group.OperCount) AS OperCount
        FROM (SELECT MasterContainerId_Count, ContainerId_Count, OperCount FROM _tmpChild GROUP BY MasterContainerId_Count, ContainerId_Count, OperCount) AS _tmpChild_group
             INNER JOIN HistoryCostContainerLink ON HistoryCostContainerLink.MasterContainerId_Count = _tmpChild_group.MasterContainerId_Count
                                                AND HistoryCostContainerLink.ChildContainerId_Count = _tmpChild_group.ContainerId_Count
             INNER JOIN _tmpMaster ON _tmpMaster.ContainerId = HistoryCostContainerLink.ChildContainerId_Summ -- условие что б отбросить "нулевые"
                                  AND (_tmpMaster.StartSumm <> 0 OR _tmpMaster.IncomeSumm <> 0 OR _tmpMaster.calcSumm <> 0)
             LEFT JOIN _tmpChild ON _tmpChild.MasterContainerId_Count = HistoryCostContainerLink.MasterContainerId_Count
                                AND _tmpChild.ContainerId_Count       = HistoryCostContainerLink.ChildContainerId_Count
                                AND _tmpChild.MasterContainerId       = HistoryCostContainerLink.MasterContainerId_Summ
                                AND _tmpChild.ContainerId             = HistoryCostContainerLink.ChildContainerId_Summ
        WHERE _tmpChild.MasterContainerId_Count IS NULL
        GROUP BY HistoryCostContainerLink.MasterContainerId_Summ
               , HistoryCostContainerLink.ChildContainerId_Summ
               , HistoryCostContainerLink.MasterContainerId_Count
               , HistoryCostContainerLink.ChildContainerId_Count;

     -- сохраняем связи, что б не формировать нулевые проводки
     INSERT INTO HistoryCostContainerLink (MasterContainerId_Count, ChildContainerId_Count, MasterContainerId_Summ, ChildContainerId_Summ)
        SELECT _tmpChild.MasterContainerId_Count, _tmpChild.ContainerId_Count, _tmpChild.MasterContainerId, _tmpChild.ContainerId
        FROM _tmpChild
             LEFT JOIN HistoryCostContainerLink ON HistoryCostContainerLink.MasterContainerId_Count = _tmpChild.MasterContainerId_Count
                                               AND HistoryCostContainerLink.ChildContainerId_Count  = _tmpChild.ContainerId_Count
                                               AND HistoryCostContainerLink.MasterContainerId_Summ  = _tmpChild.MasterContainerId
                                               AND HistoryCostContainerLink.ChildContainerId_Summ   = _tmpChild.ContainerId
        WHERE HistoryCostContainerLink.MasterContainerId_Count IS NULL
        GROUP BY _tmpChild.MasterContainerId_Count, _tmpChild.ContainerId_Count, _tmpChild.MasterContainerId, _tmpChild.ContainerId;
*/
/*
     -- добавляются связи которых нет (т.к. нулевые проводки не формируются) !!!по прошлому периоду если он > 01.06.2014!!!
     WITH tmpList_oldPeriod AS
       (SELECT COALESCE (MIContainer_Summ_In.ContainerId, 0)   AS MasterContainerId_Summ
             , COALESCE (MIContainer_Summ_Out.ContainerId, 0)  AS ChildContainerId_Summ
             , COALESCE (MIContainer_Count_In.ContainerId, 0)  AS MasterContainerId_Count
             , COALESCE (MIContainer_Count_Out.ContainerId, 0) AS ChildContainerId_Count
        FROM Movement
             JOIN MovementItemContainer AS MIContainer_Count_Out
                                        ON MIContainer_Count_Out.MovementId = Movement.Id
                                       AND MIContainer_Count_Out.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_Out.isActive = FALSE
             JOIN MovementItemContainer AS MIContainer_Summ_Out
                                        ON MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                                       AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()

             JOIN MovementItemContainer AS MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
             JOIN MovementItemContainer AS MIContainer_Count_In
                                        ON MIContainer_Count_In.MovementItemId = MIContainer_Summ_In.MovementItemId
                                       AND MIContainer_Count_In.DescId = zc_MIContainer_Count()
                                       AND MIContainer_Count_In.isActive = TRUE
             LEFT JOIN (SELECT Movement.Id AS  MovementId
                             , MIContainer_Summ_Out.MovementItemId
                             , MIContainer_Summ_Out.ContainerId
                             , COALESCE (SUM (-1 * MIContainer_Summ_Out.Amount), 0) AS Summ
                        FROM Movement
                             LEFT JOIN MovementItemContainer AS MIContainer_Summ_Out
                                                             ON MIContainer_Summ_Out.MovementId = Movement.Id
                                                            AND MIContainer_Summ_Out.DescId = zc_MIContainer_Summ()
                                                            AND MIContainer_Summ_Out.isActive = FALSE
                        WHERE Movement.OperDate BETWEEN (inStartDate - INTERVAL '1 MONTH') AND (inStartDate - INTERVAL '1 DAY')
                          AND inStartDate >= '01.07.2014' :: TDateTime
                          AND Movement.DescId = zc_Movement_ProductionSeparate()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY Movement.Id
                               , MIContainer_Summ_Out.MovementItemId
                               , MIContainer_Summ_Out.ContainerId
                       ) AS _tmp ON _tmp.MovementId = Movement.Id
                                AND _tmp.ContainerId = MIContainer_Summ_Out.ContainerId
                                AND _tmp.MovementItemId = MIContainer_Summ_Out.MovementItemId
                                AND Movement.DescId = zc_Movement_ProductionSeparate()
        WHERE Movement.OperDate BETWEEN (inStartDate - INTERVAL '1 MONTH') AND (inStartDate - INTERVAL '1 DAY')
          AND inStartDate >= '01.07.2014' :: TDateTime
          AND Movement.StatusId = zc_Enum_Status_Complete()
        GROUP BY MIContainer_Summ_In.ContainerId
               , MIContainer_Summ_Out.ContainerId
               , MIContainer_Count_In.ContainerId
               , MIContainer_Count_Out.ContainerId
       )
     INSERT INTO _tmpChild (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount)
        SELECT HistoryCostContainerLink.MasterContainerId_Summ
             , HistoryCostContainerLink.ChildContainerId_Summ
             , HistoryCostContainerLink.MasterContainerId_Count
             , HistoryCostContainerLink.ChildContainerId_Count
             , SUM (_tmpChild_group.OperCount) AS OperCount
        FROM (SELECT MasterContainerId_Count, ContainerId_Count, OperCount FROM _tmpChild GROUP BY MasterContainerId_Count, ContainerId_Count, OperCount) AS _tmpChild_group
             INNER JOIN tmpList_oldPeriod AS HistoryCostContainerLink ON HistoryCostContainerLink.MasterContainerId_Count = _tmpChild_group.MasterContainerId_Count
                                                                     AND HistoryCostContainerLink.ChildContainerId_Count = _tmpChild_group.ContainerId_Count
             INNER JOIN _tmpMaster ON _tmpMaster.ContainerId = HistoryCostContainerLink.ChildContainerId_Summ -- условие что б отбросить "нулевые"
                                  AND (_tmpMaster.StartSumm <> 0 OR _tmpMaster.IncomeSumm <> 0 OR _tmpMaster.calcSumm <> 0)
             LEFT JOIN _tmpChild ON _tmpChild.MasterContainerId_Count = HistoryCostContainerLink.MasterContainerId_Count
                                AND _tmpChild.ContainerId_Count       = HistoryCostContainerLink.ChildContainerId_Count
                                AND _tmpChild.MasterContainerId       = HistoryCostContainerLink.MasterContainerId_Summ
                                AND _tmpChild.ContainerId             = HistoryCostContainerLink.ChildContainerId_Summ
        WHERE _tmpChild.MasterContainerId_Count IS NULL
        GROUP BY HistoryCostContainerLink.MasterContainerId_Summ
               , HistoryCostContainerLink.ChildContainerId_Summ
               , HistoryCostContainerLink.MasterContainerId_Count
               , HistoryCostContainerLink.ChildContainerId_Count
       ;
*/

     -- проверка1
     IF EXISTS (SELECT _tmpMaster.ContainerId FROM _tmpMaster GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'проверка1 - SELECT ContainerId FROM _tmpMaster GROUP BY ContainerId HAVING COUNT(*) > 1';
     END IF;
     -- проверка2
     IF EXISTS (SELECT _tmpChild.MasterContainerId, _tmpChild.ContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'проверка2 - SELECT MasterContainerId, ContainerId FROM _tmpChild GROUP BY MasterContainerId, ContainerId HAVING COUNT(*) > 1 :  MasterContainerId = % and ContainerId = %',
          (SELECT MAX (_tmpChild.MasterContainerId) FROM _tmpChild WHERE MasterContainerId IN (SELECT _tmpChild.MasterContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1))
        , (SELECT MAX (_tmpChild.ContainerId) FROM _tmpChild WHERE _tmpChild.MasterContainerId IN (SELECT MAX (_tmpChild.MasterContainerId) FROM _tmpChild WHERE MasterContainerId IN (SELECT _tmpChild.MasterContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1))
                                                               AND _tmpChild.ContainerId IN (SELECT _tmpChild.ContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1))
         ;
     END IF;


     -- tmp - test
     /*RETURN QUERY
      SELECT _tmpMaster.ContainerId, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.calcCount, _tmpMaster.calcSumm, _tmpMaster.OutCount, _tmpMaster.OutSumm FROM _tmpMaster;
      -- SELECT _tmpChild.MasterContainerId, _tmpChild.ContainerId, _tmpChild.OperCount FROM _tmpChild;
     RETURN;*/



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - итерации для с/с !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     vbItearation:=0;
     vbCountDiff:= 100000;
     WHILE vbItearation < inItearationCount AND vbCountDiff > 0
     LOOP
         UPDATE _tmpMaster SET CalcSumm = _tmpSumm.CalcSumm
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ContainerId
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                 ELSE 0
                            END AS OperPrice
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm 
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId;

         -- увеличивам итерации
         vbItearation:= vbItearation + 1;
         -- сколько записей с еще неправильной с/с
         SELECT Count(*) INTO vbCountDiff
         FROM _tmpMaster
               -- Расчет суммы всех составляющих
            , (SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ContainerId
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                     THEN  (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                 ELSE 0
                            END AS OperPrice
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm 
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND ABS (_tmpMaster.CalcSumm - _tmpSumm.CalcSumm) > inDiffSumm;

     END LOOP;


     IF inInsert > 0 THEN

     -- Удаляем предыдущую с/с
     DELETE FROM HistoryCost WHERE ((inStartDate BETWEEN StartDate AND EndDate) OR (inEndDate BETWEEN StartDate AND EndDate))
                               AND HistoryCost.ContainerId IN (SELECT ContainerLinkObject.ContainerId
                                                               FROM ContainerLinkObject
                                                               WHERE ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                                 AND ContainerLinkObject.ObjectId IN (SELECT _tmpUnit_only.UnitId FROM _tmpUnit_only)
                                                              );

     -- Сохраняем что насчитали
     INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, OutCount, OutSumm)
        SELECT _tmpMaster.ContainerId, inStartDate AS StartDate, inEndDate AS EndDate
             , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                         THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0
                                        THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                   ELSE  0
                              END
                    WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                       OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                         THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                    ELSE 0
               END AS Price
             , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpMaster.OutCount, _tmpMaster.OutSumm
        FROM _tmpMaster
        WHERE ((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) <> 0)
           AND _tmpMaster.ContainerId IN (SELECT ContainerLinkObject.ContainerId
                                          FROM ContainerLinkObject
                                          WHERE ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                            AND ContainerLinkObject.ObjectId IN (SELECT _tmpUnit_only.UnitId FROM _tmpUnit_only)
                                         )
        ;                  

     END IF; -- if inInsert > 0

     IF inInsert <> 12345 THEN -- 12345 - для Load_PostgreSql
     -- tmp - test
     RETURN QUERY
        SELECT vbItearation, vbCountDiff
             , CAST (CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                               THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                          ELSE 0
                     END AS TFloat) AS Price
             , CAST (CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                               THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                          ELSE 0
                     END AS TFloat) AS PriceNext
             , _tmpSumm.FromContainerId
             , _tmpMaster.ContainerId
             , _tmpMaster.isInfoMoney_80401
             , _tmpMaster.CalcSumm AS CalcSummCurrent, CAST (COALESCE (_tmpSumm.CalcSumm, 0) AS TFloat) AS CalcSummNext
             , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpMaster.OutCount, _tmpMaster.OutSumm
         FROM _tmpMaster LEFT JOIN
               -- Расчет суммы всех составляющих
              (SELECT _tmpChild.MasterContainerId AS ContainerId
--                    , _tmpChild.ContainerId AS FromContainerId
                    , 0 AS FromContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ContainerId
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                      THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                 ELSE 0
                            END AS OperPrice
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
               GROUP BY _tmpChild.MasterContainerId
--                      , _tmpChild.ContainerId
              ) AS _tmpSumm ON _tmpMaster.ContainerId = _tmpSumm.ContainerId
        ;
     END IF; -- if inInsert <> 12345

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
     INSERT INTO _tmpMaster (ContainerId, StartCount, StartSumm, IncomeCount, IncomeSumm , CalcCount, CalcSumm)
        SELECT CAST (1 AS Integer) AS ContainerId, CAST (30 AS TFloat) AS StartCount, CAST (280 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (2 AS Integer) AS ContainerId, CAST (50 AS TFloat) AS StartCount, CAST (340 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (3 AS Integer) AS ContainerId, CAST (20 AS TFloat) AS StartCount, CAST (0 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (4 AS Integer) AS ContainerId, CAST (13 AS TFloat) AS StartCount, CAST (14 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       UNION ALL
        SELECT CAST (5 AS Integer) AS ContainerId, CAST (20 AS TFloat) AS StartCount, CAST (20 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm
       ;
     -- таблица - Все расходы
     INSERT INTO _tmpChild (MasterContainerId, ContainerId, OperCount)
        SELECT 3 AS MasterContainerId, 1 AS ContainerId, 5 AS OperCount
       UNION ALL
        SELECT 3 AS MasterContainerId, 2 AS ContainerId, 7 AS OperCount
       UNION ALL
        SELECT 3 AS MasterContainerId, 5 AS ContainerId, 2 AS OperCount
       UNION ALL
        SELECT 5 AS MasterContainerId, 1 AS ContainerId, 4 AS OperCount
       UNION ALL
        SELECT 5 AS MasterContainerId, 2 AS ContainerId, 6 AS OperCount
       UNION ALL
        SELECT 5 AS MasterContainerId, 3 AS ContainerId, 2 AS OperCount
       UNION ALL
        SELECT 5 AS MasterContainerId, 4 AS ContainerId, 1 AS OperCount
       UNION ALL
        SELECT 4 AS MasterContainerId, 3 AS ContainerId, 10 AS OperCount
       ;


     INSERT INTO _tmpMaster (ContainerId, StartCount, StartSumm, IncomeCount, IncomeSumm , CalcCount, CalcSumm)
     INSERT INTO _tmpMaster (ContainerId, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, OutCount, OutSumm)
        SELECT CAST (1 AS Integer) AS ContainerId, CAST (60 AS TFloat) AS StartCount, CAST (280 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm, CAST (0 AS TFloat) AS OutCount, CAST (0 AS TFloat) AS OutSumm
       UNION ALL
        SELECT CAST (2 AS Integer) AS ContainerId, CAST (60 AS TFloat) AS StartCount, CAST (0 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm, CAST (0 AS TFloat) AS OutCount, CAST (0 AS TFloat) AS OutSumm
       UNION ALL
        SELECT CAST (3 AS Integer) AS ContainerId, CAST (4 AS TFloat) AS StartCount, CAST (14 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm, CAST (0 AS TFloat) AS OutCount, CAST (0 AS TFloat) AS OutSumm
       UNION ALL
        SELECT CAST (4 AS Integer) AS ContainerId, CAST (5 AS TFloat) AS StartCount, CAST (20 AS TFloat) AS StartSumm, CAST (0 AS TFloat) AS IncomeCount, CAST (0 AS TFloat) AS IncomeSumm, CAST (0 AS TFloat) AS CalcCount, CAST (0 AS TFloat) AS CalcSumm, CAST (0 AS TFloat) AS OutCount, CAST (0 AS TFloat) AS OutSumm
       ;
     -- таблица - Все расходы
     INSERT INTO _tmpChild (MasterContainerId, ContainerId, OperCount)
        SELECT 2 AS MasterContainerId, 1 AS ContainerId, 30 AS OperCount
       UNION ALL
        SELECT 2 AS MasterContainerId, 3 AS ContainerId, 1 AS OperCount
       UNION ALL
        SELECT 2 AS MasterContainerId, 4 AS ContainerId, 1 AS OperCount
       UNION ALL
        SELECT 2 AS MasterContainerId, 2 AS ContainerId, 30 AS OperCount
       UNION ALL
        SELECT 1 AS MasterContainerId, 2 AS ContainerId, 30 AS OperCount
       ;

*/

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.14                                        * add zc_ObjectLink_Unit_HistoryCost
 13.08.14                                        * ObjectCostId -> ContainerId
 10.08.14                                        * add SendOnPrice
 15.09.13                                        * add zc_Container_CountSupplier and zc_Enum_Account_20901
 13.07.13                                        * add JOIN Container
 10.07.13                                        *
*/

-- DELETE FROM HistoryCost WHERE ('01.06.2014' BETWEEN StartDate AND EndDate) OR ('30.06.2014' BETWEEN StartDate AND EndDate);

-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 8462, 8459); -- Склад Брак -> Склад Реализации 
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 8461, 8459); -- Склад Возвратов -> Склад Реализации 
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 256716, 8459); -- Склад УТИЛЬ -> Склад Реализации 
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 309599, 301309); -- Склад возвратов ф.Запорожье -> Склад гп ф.Запорожье

-- select 'zc_isHistoryCost', zc_isHistoryCost()union all select 'zc_isHistoryCost_byInfoMoneyDetail', zc_isHistoryCost_byInfoMoneyDetail() order by 1;
-- SELECT MIN (MovementItemContainer.OperDate), MAX (MovementItemContainer.OperDate), Count(*), MovementDesc.Code FROM MovementItemContainer left join Movement on Movement.Id = MovementId left join MovementDesc on MovementDesc.Id = Movement.DescId where MovementItemContainer.OperDate between '01.01.2013' and '31.01.2013' group by MovementDesc.Code;
-- SELECT StartDate, EndDate, Count(*) FROM HistoryCost GROUP BY StartDate, EndDate ORDER BY 1;

-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.11.2014', inEndDate:= '25.11.2014', inItearationCount:= 1000, inInsert:= 12345, inDiffSumm:= 0.009, inSession:= '2') -- WHERE CalcSummCurrent <> CalcSummNext
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '26.11.2014', inEndDate:= '30.11.2014', inItearationCount:= 1000, inInsert:= 12345, inDiffSumm:= 0.009, inSession:= '2') -- WHERE CalcSummCurrent <> CalcSummNext

-- UPDATE HistoryCost SET Price = 100 WHERE Price > 100 AND StartDate = '01.06.2014' AND EndDate = '30.06.2014'
-- тест
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inItearationCount:= 500, inInsert:= 12345, inDiffSumm:= 0, inSession:= '2')  WHERE Price <> PriceNext
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inItearationCount:= 100, inInsert:= -1, inDiffSumm:= 0.009, inSession:= '2') -- WHERE CalcSummCurrent <> CalcSummNext
