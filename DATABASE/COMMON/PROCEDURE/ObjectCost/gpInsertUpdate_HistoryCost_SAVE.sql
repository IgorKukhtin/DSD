-- Function: gpInsertUpdate_HistoryCost()

DROP FUNCTION IF EXISTS gpInsertUpdate_HistoryCost (TDateTime, TDateTime, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_HistoryCost (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_HistoryCost(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inBranchId        Integer , --
    IN inItearationCount Integer , --
    IN inInsert          Integer , --
    IN inDiffSumm        TFloat , --
    IN inSession         TVarChar    -- сессия пользователя
)                              
--  RETURNS VOID
  RETURNS TABLE (vbItearation Integer, vbCountDiff Integer, Price TFloat, PriceNext TFloat, Price_external TFloat, PriceNext_external TFloat, FromContainerId Integer, ContainerId Integer, isInfoMoney_80401 Boolean, CalcSummCurrent TFloat, CalcSummNext TFloat, CalcSummCurrent_external TFloat, CalcSummNext_external TFloat, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat, UnitId Integer, UnitName TVarChar)
--  RETURNS TABLE (ContainerId Integer, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, OutCount TFloat, OutSumm TFloat)
--  RETURNS TABLE (MasterContainerId Integer, ContainerId Integer, OperCount TFloat)
AS
$BODY$
   DECLARE vbStartDate_zavod TDateTime;
   DECLARE vbEndDate_zavod TDateTime;

   DECLARE vbItearation Integer;
   DECLARE vbCountDiff Integer;
   DECLARE vb11 TFloat;
   DECLARE vb12 TFloat;
   DECLARE vb21 TFloat;
   DECLARE vb22 TFloat;
   DECLARE vb31 TFloat;
   DECLARE vb32 TFloat;
   DECLARE vb41 TFloat;
   DECLARE vb42 TFloat;
   DECLARE vb51 TFloat;
   DECLARE vb52 TFloat;
   DECLARE vb61 TFloat;
   DECLARE vb62 TFloat;
   DECLARE vb71 TFloat;
   DECLARE vb72 TFloat;
   DECLARE vb81 TFloat;
   DECLARE vb82 TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());


     -- !!!если не филиал, тогда начальная дата всегда 1-ое число месяца!!!
     vbStartDate_zavod:= DATE_TRUNC ('MONTH', inStartDate);
     -- !!!если не филиал, тогда конечная дата всегда последнее число месяца!!!
     vbEndDate_zavod:= DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


     -- таблица - Список сущностей которые являются элементами с/с.
     CREATE TEMP TABLE _tmpMaster (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat) ON COMMIT DROP;
     -- таблица - расходы для Master
     CREATE TEMP TABLE _tmpChild (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean) ON COMMIT DROP;
     -- таблица - "округления"
     CREATE TEMP TABLE _tmpDiff (ContainerId Integer, MovementItemId_diff Integer, Summ_diff TFloat) ON COMMIT DROP;

     -- таблица - филиал Одесса + филиал Запорожье
     CREATE TEMP TABLE _tmpUnit_branch (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_branch (UnitId)
        SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE COALESCE (inBranchId, 0) = 0
          -- AND ObjectLink_Unit_Branch.ChildObjectId <> zc_Branch_Basis()
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          AND ObjectLink_Unit_Branch.ChildObjectId IN (8374, 301310) -- филиал Одесса + филиал Запорожье
      UNION
       SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE inBranchId <> 0
          AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
       ;     
     -- таблица - филиал Одесса + филиал Запорожье
     CREATE TEMP TABLE _tmpContainer_branch (ContainerId Integer) ON COMMIT DROP;
     INSERT INTO _tmpContainer_branch (ContainerId)
        SELECT ContainerLinkObject.ContainerId
        FROM _tmpUnit_branch
             INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                           AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
       ;


     -- заполняем таблицу Количество и Сумма - ост, приход, расход
       WITH tmpContainerS_zavod AS (SELECT Container_Summ.*
                                    FROM Container AS Container_Summ
                                         LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container_Summ.Id
                                    WHERE _tmpContainer_branch.ContainerId IS NULL
                                      AND Container_Summ.DescId = zc_Container_Summ()
                                      AND Container_Summ.ParentId > 0
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                   )
         , tmpContainerS_branch AS (SELECT Container_Summ.*
                                    FROM Container AS Container_Summ
                                         INNER JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container_Summ.Id
                                    WHERE Container_Summ.DescId = zc_Container_Summ()
                                      AND Container_Summ.ParentId > 0
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                   )
           , tmpContainerList AS (SELECT Container_Summ.Id, Container_Summ.ParentId, Container_Summ.ObjectId
                                  FROM tmpContainerS_zavod AS Container_Summ
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container_Summ.Id
                                                                      AND MIContainer.OperDate >= vbStartDate_zavod
                                  WHERE Container_Summ.DescId = zc_Container_Summ()
                                    AND Container_Summ.ParentId > 0
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                  GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount, Container_Summ.ObjectId
                                  HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0 -- AS StartSumm
                                      OR MAX (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN Container_Summ.Id ELSE 0 END) > 0
                                 UNION ALL
                                  SELECT Container_Summ.Id, Container_Summ.ParentId, Container_Summ.ObjectId
                                  FROM tmpContainerS_branch AS Container_Summ
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container_Summ.Id
                                                                      AND MIContainer.OperDate >= inStartDate
                                  WHERE Container_Summ.DescId = zc_Container_Summ()
                                    AND Container_Summ.ParentId > 0
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                  GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount, Container_Summ.ObjectId
                                  HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0 -- AS StartSumm
                                      OR MAX (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN Container_Summ.Id ELSE 0 END) > 0
                                 )
     , tmpContainer_zavod AS (SELECT Container.*, COALESCE (ContainerLinkObject_Unit.ObjectId, 0) AS UnitId
                                   , CASE WHEN ObjectLink_Unit_HistoryCost.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isHistoryCost_ReturnIn
                              FROM Container
                                   LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container.Id
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                 ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                                        ON ObjectLink_Unit_HistoryCost.ObjectId = ContainerLinkObject_Unit.ObjectId
                                                       AND ObjectLink_Unit_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
                              WHERE _tmpContainer_branch.ContainerId IS NULL
                                AND ((Container.DescId = zc_Container_Count() AND ContainerLinkObject_Account.ContainerId IS NULL)
                                  OR (Container.DescId = zc_Container_Summ() AND Container.ParentId > 0 AND Container.ObjectId <> zc_Enum_Account_110101()) -- Транзит + товар в пути
                                    )
                             )
    , tmpContainer_branch AS (SELECT Container.*, COALESCE (ContainerLinkObject_Unit.ObjectId, 0) AS UnitId
                                   , CASE WHEN ObjectLink_Unit_HistoryCost.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isHistoryCost_ReturnIn
                              FROM Container
                                   INNER JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container.Id
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                 ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                                        ON ObjectLink_Unit_HistoryCost.ObjectId = ContainerLinkObject_Unit.ObjectId
                                                       AND ObjectLink_Unit_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
                              WHERE ((Container.DescId = zc_Container_Count() AND ContainerLinkObject_Account.ContainerId IS NULL)
                                  OR (Container.DescId = zc_Container_Summ() AND Container.ParentId > 0 AND Container.ObjectId <> zc_Enum_Account_110101()) -- Транзит + товар в пути
                                    )
                             )
       -- , tmpAccount_60000 AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- Прибыль будущих периодов

     INSERT INTO _tmpMaster (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
        SELECT COALESCE (Container_Summ.Id, tmpContainer.ContainerId) AS ContainerId
             , tmpContainer.UnitId AS UnitId
             , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401()
                         THEN TRUE
                    ELSE FALSE
               END AS isInfoMoney_80401 -- прибыль текущего периода

             , SUM (tmpContainer.StartCount) AS StartCount
             , SUM (tmpContainer.StartSumm)  AS StartSumm
             , SUM (tmpContainer.IncomeCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                             THEN tmpContainer.SendOnPriceCountIn_Cost
                                                          ELSE 0 -- tmpContainer.SendOnPriceCountIn
                                                     END)
                                              + SUM (CASE WHEN tmpContainer.isHistoryCost_ReturnIn = TRUE
                                                             THEN tmpContainer.ReturnInCount
                                                          ELSE 0
                                                     END) AS IncomeCount
             , SUM (tmpContainer.IncomeSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                              THEN tmpContainer.SendOnPriceSummIn_Cost
                                                         ELSE 0 -- tmpContainer.SendOnPriceSummIn
                                                    END)
                                              + SUM (CASE WHEN tmpContainer.isHistoryCost_ReturnIn = TRUE
                                                             THEN tmpContainer.ReturnInSumm
                                                          ELSE 0
                                                     END) AS IncomeSumm
             , SUM (tmpContainer.calcCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                             THEN 0
                                                          ELSE tmpContainer.SendOnPriceCountIn
                                                     END) AS calcCount
             , SUM (tmpContainer.calcSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                              THEN 0
                                                         ELSE tmpContainer.SendOnPriceSummIn
                                                    END) AS calcSumm

             , SUM (tmpContainer.calcCount_external) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                             THEN 0
                                                          ELSE tmpContainer.SendOnPriceCountIn
                                                     END) AS calcCount_external
             , SUM (tmpContainer.calcSumm_external) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                              THEN 0
                                                         ELSE tmpContainer.SendOnPriceSummIn
                                                    END) AS calcSumm_external

             , SUM (tmpContainer.OutCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                            THEN tmpContainer.SendOnPriceCountOut_Cost
                                                       ELSE tmpContainer.SendOnPriceCountOut
                                                  END) AS OutCount
             , SUM (tmpContainer.OutSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                           THEN tmpContainer.SendOnPriceSummOut_Cost
                                                      ELSE tmpContainer.SendOnPriceSummOut
                                                 END) AS OutSumm
        FROM (SELECT Container.Id AS ContainerId
                   , Container.UnitId
                   , Container.isHistoryCost_ReturnIn
                   , Container.DescId
                   , Container.ObjectId
                     -- Start
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartSumm
                     -- Income
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeSumm
                     -- SendOnPrice
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut_Cost
                     -- Calc
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm
                     -- Calc_external, т.е. AnalyzerId <> UnitId
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) <> Container.UnitId AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount_external
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) <> Container.UnitId AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND COALESCE (MIContainer.AnalyzerId, 0) <> Container.UnitId AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm_external
                     -- ReturnIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInSumm
                     -- Out
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutSumm
              FROM tmpContainer_zavod AS Container
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.ContainerId = Container.Id
                                                  AND MIContainer.OperDate >= vbStartDate_zavod
                   LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                             ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                            AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
              GROUP BY Container.Id
                     , Container.UnitId
                     , Container.isHistoryCost_ReturnIn
                     , Container.DescId
                     , Container.ObjectId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
             UNION ALL
              SELECT Container.Id AS ContainerId
                   , Container.UnitId
                   , Container.isHistoryCost_ReturnIn
                   , Container.DescId
                   , Container.ObjectId
                     -- Start
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartSumm
                     -- Income
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeSumm
                     -- SendOnPrice
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut_Cost
                     -- Calc
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm
                     -- Calc_external, т.е. AnalyzerId <> UnitId
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) <> Container.UnitId AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount_external
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) <> Container.UnitId AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND COALESCE (MIContainer.AnalyzerId, 0) <> Container.UnitId AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm_external
                     -- ReturnIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInSumm
                     -- Out
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutSumm
              FROM tmpContainer_branch AS Container
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.ContainerId = Container.Id
                                                  AND MIContainer.OperDate >= inStartDate
                   LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                             ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                            AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
              GROUP BY Container.Id
                     , Container.UnitId
                     , Container.isHistoryCost_ReturnIn
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

             -- LEFT JOIN tmpAccount_60000 ON tmpAccount_60000.AccountId = COALESCE (Container_Summ.ObjectId, tmpContainer.ObjectId)
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                           ON ContainerLinkObject_InfoMoney.ContainerId = COALESCE (Container_Summ.Id, tmpContainer.ContainerId)
                                          AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = COALESCE (Container_Summ.Id, tmpContainer.ContainerId)
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()

        -- GROUP BY COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, tmpContainer.ContainerId)) -- ContainerObjectCost.ObjectCostId
        GROUP BY COALESCE (Container_Summ.Id, tmpContainer.ContainerId) -- ContainerObjectCost.ObjectCostId
               , tmpContainer.UnitId
               , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           THEN TRUE
                      ELSE FALSE
                 END
       ;

     -- Ошибка !!! Recycled !!!
     /*DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (250904, 244751
                                                           , 140871, 132557, 278535, 204974
                                                           , 240687, 250652
                                                            );*/

     IF inBranchId = 0 OR 1 = 1
     THEN
     -- расходы для Master
     INSERT INTO _tmpChild (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount, isExternal)
        /*WITH MIContainer_Count_Out AS (SELECT Movement.Id AS MovementId, Movement.DescId AS MovementDescId, Movement.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer, SUM (MIContainer_Count_Out.Amount) AS Amount
                                       FROM _tmpMaster
                                            JOIN MovementItemContainer AS MIContainer_Summ_Out
                                                                       ON MIContainer_Summ_Out.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod
                                                                      AND MIContainer_Summ_Out.ContainerId = _tmpMaster.ContainerId
                                                                      AND MIContainer_Summ_Out.DescId     = zc_MIContainer_Summ()
                                                                      AND MIContainer_Summ_Out.isActive   = TRUE
                                                                      AND MIContainer_Summ_Out.ParentId > 0
                                       WHERE Movement.
                                         -- AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY Movement.Id, Movement.DescId, Movement.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer
                                     )*/
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
             , CASE WHEN MIContainer_Count_Out.WhereObjectId_Analyzer = MIContainer_Count_In.WhereObjectId_Analyzer THEN FALSE ELSE TRUE END AS isExternal
        FROM Movement
             JOIN MovementItemContainer AS MIContainer_Count_Out
                                        ON MIContainer_Count_Out.MovementId = Movement.Id
                                       AND MIContainer_Count_Out.DescId     = zc_MIContainer_Count()
                                       AND MIContainer_Count_Out.isActive   = FALSE
             JOIN MovementItemContainer AS MIContainer_Summ_Out
                                        ON MIContainer_Summ_Out.MovementId     = MIContainer_Count_Out.MovementId
                                       AND MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                                       AND MIContainer_Summ_Out.DescId         = zc_MIContainer_Summ()

             JOIN MovementItemContainer AS MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
             LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = MIContainer_Summ_In.ContainerId
             JOIN MovementItemContainer AS MIContainer_Count_In
                                        ON MIContainer_Count_In.MovementId     = MIContainer_Summ_In.MovementId
                                       AND MIContainer_Count_In.MovementItemId = MIContainer_Summ_In.MovementItemId
                                       AND MIContainer_Count_In.DescId         = zc_MIContainer_Count()
                                       AND MIContainer_Count_In.isActive       = TRUE

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
                        WHERE Movement.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod
                          AND Movement.DescId = zc_Movement_ProductionSeparate()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY Movement.Id
                               , MIContainer_Summ_Out.MovementItemId
                               , MIContainer_Summ_Out.ContainerId
                       ) AS _tmp ON _tmp.MovementId = Movement.Id
                                AND _tmp.ContainerId = MIContainer_Summ_Out.ContainerId
                                AND _tmp.MovementItemId = MIContainer_Summ_Out.MovementItemId
                                AND Movement.DescId = zc_Movement_ProductionSeparate()
        WHERE Movement.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod
          -- AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
          AND Movement.StatusId = zc_Enum_Status_Complete()
          AND _tmpContainer_branch.ContainerId IS NULL
        GROUP BY MIContainer_Summ_In.ContainerId
               , MIContainer_Summ_Out.ContainerId
               , MIContainer_Count_In.ContainerId
               , MIContainer_Count_Out.ContainerId
               , MIContainer_Count_Out.WhereObjectId_Analyzer
               , MIContainer_Count_In.WhereObjectId_Analyzer
                ;

     END IF; -- if inBranchId = 0

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
         RAISE EXCEPTION 'проверка2 - SELECT MasterContainerId, ContainerId FROM _tmpChild GROUP BY MasterContainerId, ContainerId HAVING COUNT(*) > 1 :  MasterContainerId = % and ContainerId = %'
        , (SELECT _tmpChild.MasterContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
        , (SELECT _tmpChild.ContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
         ;
     END IF;


     -- тест 
     -- RAISE EXCEPTION '%     %', (SELECT _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431), (SELECT _tmpMaster.CalcSumm_external FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431);
     -- тест***
     -- SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb11, vb12 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - итерации для с/с !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- !!! 1-ая итерация для всех !!!
         UPDATE _tmpMaster SET CalcSumm          = _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpSumm.CalcSumm_external
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ContainerId
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                 ELSE 0
                            END AS OperPrice
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                 ELSE 0
                            END AS OperPrice_external
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm 
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId;


     -- тест***
     -- SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb21, vb22 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431;


     -- !!! остальные итерации без Упаковки !!!
     vbItearation:=0;
     vbCountDiff:= 100000;
     WHILE vbItearation < inItearationCount AND vbCountDiff > 0
     LOOP
         UPDATE _tmpMaster SET CalcSumm          = _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpSumm.CalcSumm_external
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external
               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ContainerId
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                 ELSE 0
                            END AS OperPrice
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                 ELSE 0
                            END AS OperPrice_external
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm 
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8451 END -- Цех Упаковки
        ;

         -- тест***
         -- IF vbItearation = 0 THEN SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb31, vb32 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431; END IF;
         -- IF vbItearation = 1 THEN SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb41, vb42 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431; END IF;
         -- IF vbItearation = 2 THEN SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb51, vb52 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431; END IF;
         -- IF vbItearation = 3 THEN SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb61, vb62 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431; END IF;
         -- IF vbItearation = 4 THEN SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb71, vb72 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431; END IF;
         -- IF vbItearation = 5 THEN SELECT _tmpMaster.CalcSumm, _tmpMaster.CalcSumm_external INTO vb81, vb82 TSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 590431; END IF;

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
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
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
           AND ABS (_tmpMaster.CalcSumm - _tmpSumm.CalcSumm) > inDiffSumm
           AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8451 END -- Цех Упаковки
        ;

         -- увеличивам итерации
         vbItearation:= vbItearation + 1;

     END LOOP;


     -- тест***
     -- RAISE EXCEPTION '%   % ; %   % ; %   % ; %   % ; %   % ; %   % ; %   % ; %   % ; ', vb11, vb12, vb21, vb22, vb31, vb32, vb41, vb42, vb51, vb52, vb61, vb62, vb71, vb72, vb81, vb82;



     IF inInsert > 0 THEN

     -- Сохранили Diff
     /*INSERT INTO _tmpDiff (ContainerId, MovementItemId_diff, Summ_diff)
        SELECT HistoryCost.ContainerId, MAX (HistoryCost.MovementItemId_diff), SUM (HistoryCost.Summ_diff) FROM HistoryCost WHERE HistoryCost.Summ_diff <> 0 AND ((inStartDate BETWEEN StartDate AND EndDate) OR (inEndDate BETWEEN StartDate AND EndDate)) GROUP BY HistoryCost.ContainerId;
     */
     IF inBranchId <> 0
     THEN
         -- Удаляем предыдущую с/с - !!!для 1-ого Филиала!!!
         DELETE FROM HistoryCost WHERE ((inStartDate BETWEEN StartDate AND EndDate) OR (inEndDate BETWEEN StartDate AND EndDate))
                                   AND HistoryCost.ContainerId IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                                  /*(SELECT ContainerLinkObject.ContainerId
                                                                   FROM _tmpUnit_branch
                                                                        INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                                  );*/
         -- Сохраняем что насчитали - !!!для 1-ого Филиала!!!
         INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
            SELECT _tmpMaster.ContainerId, inStartDate AS StartDate, inEndDate AS EndDate
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                        ELSE 0
                   END AS Price
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                        ELSE 0
                   END AS Price_external
                 , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpMaster.CalcCount_external, _tmpMaster.CalcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm
                 , _tmpDiff.MovementItemId_diff, _tmpDiff.Summ_diff
            FROM _tmpMaster
                 LEFT JOIN _tmpDiff ON _tmpDiff.ContainerId = _tmpMaster.ContainerId
            WHERE (((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm)          <> 0)
                OR ((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) <> 0)
                  )
              AND _tmpMaster.ContainerId IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                            /*(SELECT ContainerLinkObject.ContainerId
                                             FROM _tmpUnit_branch
                                                  INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                            );*/
     ELSE
         -- Удаляем предыдущую с/с - !!!кроме всех Филиалов!!!
         DELETE FROM HistoryCost WHERE ((inStartDate BETWEEN StartDate AND EndDate) OR (inEndDate BETWEEN StartDate AND EndDate))
                                   AND HistoryCost.ContainerId NOT IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                                      /*(SELECT ContainerLinkObject.ContainerId
                                                                       FROM _tmpUnit_branch
                                                                            INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                                          AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                                      );*/
         -- Сохраняем что насчитали - !!!кроме всех Филиалов!!!
         INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
            SELECT _tmpMaster.ContainerId, inStartDate AS StartDate, inEndDate AS EndDate
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                        ELSE 0
                   END AS Price
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                        ELSE 0
                   END AS Price_external
                 , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpMaster.CalcCount_external, _tmpMaster.CalcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm
                 , _tmpDiff.MovementItemId_diff, _tmpDiff.Summ_diff
            FROM _tmpMaster
                 LEFT JOIN _tmpDiff ON _tmpDiff.ContainerId = _tmpMaster.ContainerId
            WHERE (((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm)          <> 0)
                OR ((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) <> 0)
                  )
              AND _tmpMaster.ContainerId NOT IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                /*(SELECT ContainerLinkObject.ContainerId
                                                 FROM _tmpUnit_branch
                                                      INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                );*/
     END IF;




        -- !!!ВРЕМЕННО-1!!!
        /*UPDATE MovementItemContainer SET ContainerIntId_analyzer = ContainerId
        WHERE MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
          AND MovementItemContainer.MovementDescId = zc_Movement_Sale()
          AND MovementItemContainer.DescId = zc_MIContainer_Count()
          AND MovementItemContainer.ContainerIntId_analyzer IS NULL
       ;
        -- !!!ВРЕМЕННО-2!!!
        CREATE TEMP TABLE _tmpMIContainer_update_analyzer (MovementId Integer, MovementItemId Integer, ContainerId Integer) ON COMMIT DROP;
        INSERT INTO _tmpMIContainer_update_analyzer (MovementId, MovementItemId, ContainerId)
              SELECT DISTINCT MIContainer.MovementId, MIContainer.MovementItemId, MIContainer.ContainerId
              FROM MovementItemContainer AS MIContainer
              WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                AND MIContainer.MovementDescId = zc_Movement_Sale()
                AND MIContainer.DescId = zc_MIContainer_Count()
       ;
        UPDATE MovementItemContainer SET ContainerIntId_analyzer = _tmpMIContainer_update_analyzer.ContainerId
        FROM _tmpMIContainer_update_analyzer
        WHERE MovementItemContainer.MovementId     = _tmpMIContainer_update_analyzer.MovementId
          AND MovementItemContainer.MovementItemId = _tmpMIContainer_update_analyzer.MovementItemId
          AND MovementItemContainer.DescId         = zc_MIContainer_Summ()
          AND MovementItemContainer.ContainerIntId_analyzer IS NULL
       ;*/

     END IF; -- if inInsert > 0

     IF inInsert <> 12345 THEN -- 12345 - для Load_PostgreSql
     -- tmp - test
     RETURN QUERY
        SELECT vbItearation, vbCountDiff
             , CAST (CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                               THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                          ELSE 0
                     END AS TFloat) AS Price
             , CAST (CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                               THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
                          ELSE 0
                     END AS TFloat) AS PriceNext

             , CAST (CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                               THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external)
                          ELSE 0
                     END AS TFloat) AS Price_external
             , CAST (CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                               THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm_external, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm_external, 0)) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm_external, 0)) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + COALESCE (_tmpSumm.CalcSumm_external, 0)) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external)
                          ELSE 0
                     END AS TFloat) AS PriceNext_external

             , _tmpSumm.FromContainerId
             , _tmpMaster.ContainerId
             , _tmpMaster.isInfoMoney_80401
             , _tmpMaster.CalcSumm          AS CalcSummCurrent,          CAST (COALESCE (_tmpSumm.CalcSumm, 0)          AS TFloat) AS CalcSummNext
             , _tmpMaster.CalcSumm_external AS CalcSummCurrent_external, CAST (COALESCE (_tmpSumm.CalcSumm_external, 0) AS TFloat) AS CalcSummNext_external
             , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpMaster.CalcCount_external, _tmpMaster.CalcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm
             , _tmpMaster.UnitId
             , Object_Unit.ValueData AS UnitName

         FROM _tmpMaster LEFT JOIN
               -- Расчет суммы всех составляющих
              (SELECT _tmpChild.MasterContainerId AS ContainerId
--                    , _tmpChild.ContainerId AS FromContainerId
                    , 0 AS FromContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external

               FROM 
                    -- Расчет цены
                    (SELECT _tmpMaster.ContainerId
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                      THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                 ELSE 0
                            END AS OperPrice
                          , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                                      THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                 ELSE 0
                            END AS OperPrice_external
                     FROM _tmpMaster
                    ) AS _tmpPrice 
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
               GROUP BY _tmpChild.MasterContainerId
--                      , _tmpChild.ContainerId
              ) AS _tmpSumm ON _tmpMaster.ContainerId = _tmpSumm.ContainerId
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpMaster.UnitId
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
 24.08.15                                        * add inBranchId
 08.11.14                                        * add zc_ObjectLink_Unit_HistoryCost
 13.08.14                                        * ObjectCostId -> ContainerId
 10.08.14                                        * add SendOnPrice
 15.09.13                                        * add zc_Container_CountSupplier and zc_Enum_Account_20901
 13.07.13                                        * add JOIN Container
 10.07.13                                        *
*/

-- DELETE FROM HistoryCost WHERE ('01.06.2014' BETWEEN StartDate AND EndDate) OR ('30.06.2014' BETWEEN StartDate AND EndDate);
-- DELETE FROM HistoryCost WHERE ('01.01.2015' BETWEEN StartDate AND EndDate) OR ('31.01.2015' BETWEEN StartDate AND EndDate);

-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 8462, 8459); -- Склад Брак -> Склад Реализации 
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 8461, 8459); -- Склад Возвратов -> Склад Реализации 
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 256716, 8459); -- Склад УТИЛЬ -> Склад Реализации 
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 309599, 301309); -- Склад возвратов ф.Запорожье -> Склад гп ф.Запорожье

-- select 'zc_isHistoryCost', zc_isHistoryCost()union all select 'zc_isHistoryCost_byInfoMoneyDetail', zc_isHistoryCost_byInfoMoneyDetail() order by 1;
-- SELECT MIN (MovementItemContainer.OperDate), MAX (MovementItemContainer.OperDate), Count(*), MovementDesc.Code FROM MovementItemContainer left join Movement on Movement.Id = MovementId left join MovementDesc on MovementDesc.Id = Movement.DescId where MovementItemContainer.OperDate between '01.01.2013' and '31.01.2013' group by MovementDesc.Code;
-- SELECT StartDate, EndDate, Count(*) FROM HistoryCost GROUP BY StartDate, EndDate ORDER BY 1;

-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.11.2014', inEndDate:= '25.11.2014', inBranchId:= 0, inItearationCount:= 1000, inInsert:= 12345, inDiffSumm:= 0.009, inSession:= '2') -- WHERE CalcSummCurrent <> CalcSummNext
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '26.11.2014', inEndDate:= '30.11.2014', inBranchId:= 0, inItearationCount:= 1000, inInsert:= 12345, inDiffSumm:= 0.009, inSession:= '2') -- WHERE CalcSummCurrent <> CalcSummNext

-- UPDATE HistoryCost SET Price = 100 WHERE Price > 100 AND StartDate = '01.06.2014' AND EndDate = '30.06.2014'
-- тест
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inBranchId:= 0, inItearationCount:= 500, inInsert:= -1, inDiffSumm:= 0, inSession:= '2')  WHERE Price <> PriceNext
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.08.2015', inEndDate:= '31.08.2015', inBranchId:= 0, inItearationCount:= 100, inInsert:= -1, inDiffSumm:= 0.009, inSession:= '2') -- WHERE CalcSummCurrent <> CalcSummNext

-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.08.2015', inEndDate:= '17.08.2015', inBranchId:= 301310,  inItearationCount:= 10, inInsert:= -1, inDiffSumm:= 0.009, inSession:= '2') WHERE ContainerId in (410621)
