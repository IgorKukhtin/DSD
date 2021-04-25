-- Function: gpInsertUpdate_HistoryCost()

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
   DECLARE vbEndDate_zavod   TDateTime;

   DECLARE vbItearation Integer;
   DECLARE vbCountDiff  Integer;

   DECLARE vbItearationCount_err Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());

     -- !!!выход!!!
     -- IF inStartDate >= '01.03.2020' THEN RETURN; END IF;
     -- IF inBranchId IN (8379, 3080683) THEN RETURN; END IF;

     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- меняем дату, если месяц не закрыт
     IF     -- если в "текущем" месяце
            EXTRACT ('MONTH' FROM inStartDate) = EXTRACT ('MONTH' FROM CURRENT_DATE - INTERVAL '0 DAY')
            -- после 12:00
        AND EXTRACT (HOUR FROM CURRENT_TIMESTAMP) >= 12
     THEN
         -- надо брать -1 день
         inEndDate:= CURRENT_DATE - INTERVAL '1 DAY';

     ELSEIF -- если в "текущем" месяце
            EXTRACT ('MONTH' FROM inStartDate) = EXTRACT ('MONTH' FROM CURRENT_DATE - INTERVAL '1 DAY')
            -- до 12:00
        AND EXTRACT (HOUR FROM CURRENT_TIMESTAMP) < 12
     THEN
         -- надо брать -2 день
         inEndDate:= CURRENT_DATE - INTERVAL '2 DAY';
     END IF;


     -- !!!ВРЕМЕННО!!!
     /*IF inStartDate >= '01.02.2018' THEN
          return;
     END IF;*/


     -- IF inBranchId <> 8379 THEN RETURN; END IF; -- филиал Киев
     -- IF inBranchId <> 3080683 AND inStartDate = '01.06.2019' THEN RETURN; END IF; -- филиал Львов
     -- IF inBranchId <> 0 THEN RETURN; END IF;


     vbItearationCount_err:= 5;

     --inItearationCount:= 50;


-- !!!ВРЕМЕННО!!!
-- IF inStartDate = '01.01.2017' THEN inItearationCount:= 100; END IF;
-- IF inItearationCount >= 800 THEN inItearationCount:= 400; END IF;
-- !!!ВРЕМЕННО!!!

     -- !!!если не филиал, тогда начальная дата всегда 1-ое число месяца!!!
     vbStartDate_zavod:= DATE_TRUNC ('MONTH', inStartDate);
     -- !!!если не филиал, тогда конечная дата всегда последнее число месяца!!!
     vbEndDate_zavod:= DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
/*
-- if inBranchId = 0 then return; end if;
if inBranchId = 0 then
     inStartDate:= '01.05.2016';
     inEndDate  := '30.05.2016';
     vbStartDate_zavod:= '01.05.2016';
     vbEndDate_zavod  := '30.05.2016';
end if;
*/

-- inEndDate:= '27.03.2017';

     -- таблица - Список сущностей которые являются элементами с/с.
     CREATE TEMP TABLE _tmpMaster (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMaster_err (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat) ON COMMIT DROP;
     -- таблица - расходы для Master
     CREATE TEMP TABLE _tmpChild (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean, DescId Integer) ON COMMIT DROP;
     -- таблица - "округления"
     --* CREATE TEMP TABLE _tmpDiff (ContainerId Integer, MovementItemId_diff Integer, Summ_diff TFloat) ON COMMIT DROP;

     -- таблица - филиал Одесса + филиал Запорожье
     CREATE TEMP TABLE _tmpUnit_branch (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_branch (UnitId)
        SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE COALESCE (inBranchId, 0) <= 0
          -- AND ObjectLink_Unit_Branch.ChildObjectId <> zc_Branch_Basis()
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          AND ObjectLink_Unit_Branch.ChildObjectId IN (8374    -- 4. филиал Одесса
                                                     , 301310  -- 11. филиал Запорожье
                                                     , 8373    -- 3. филиал Николаев (Херсон)
                                                     , 8375    -- 5. филиал Черкассы (Кировоград)
                                                     , 8377    -- 7. филиал Кр.Рог
                                                     , 8381    -- 9. филиал Харьков
                                                     , 8379    -- 2. филиал Киев
                                                     , 3080683 -- филиал Львов
                                                      )
      UNION
       SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE inBranchId > 0
          AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
       ;

     -- таблица - остальные филиалы
     /*CREATE TEMP TABLE _tmpUnit_branch_oth (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_branch_oth (UnitId)
        SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE inBranchId > 0
          AND ObjectLink_Unit_Branch.ObjectId NOT IN (SELECT _tmpUnit_branch.UnitId FROM _tmpUnit_branch)
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          AND ObjectLink_Unit_Branch.ChildObjectId IN (8374    -- 4. филиал Одесса
                                                     , 301310  -- 11. филиал Запорожье
                                                     , 8373    -- 3. филиал Николаев (Херсон)
                                                     , 8375    -- 5. филиал Черкассы (Кировоград)
                                                     , 8377    -- 7. филиал Кр.Рог
                                                     , 8381    -- 9. филиал Харьков
                                                     , 8379    -- 2. филиал Киев
                                                     , 3080683 -- филиал Львов
                                                      )
       ;*/

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
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110101() -- Транзит + товар в пути
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
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                  WHERE Container_Summ.DescId = zc_Container_Summ()
                                    AND Container_Summ.ParentId > 0
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                  GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount, Container_Summ.ObjectId
                                  HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0 -- AS StartSumm
                                      OR MAX (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN Container_Summ.Id ELSE 0 END) > 0
                                 )
     , tmpContainer_zavod AS (SELECT Container.*, COALESCE (Object_Unit.Id, 0) AS UnitId
                                   , CASE WHEN 1 = 0 /*ObjectLink_Unit_HistoryCost.ChildObjectId > 0*/ THEN TRUE ELSE FALSE END AS isHistoryCost_ReturnIn
                              FROM Container
                                   LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container.Id
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                 ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id     = ContainerLinkObject_Unit.ObjectId
                                                                  AND Object_Unit.Id     <> zc_Juridical_Basis()
                                                                  -- AND Object_Unit.DescId <> zc_Object_Juridical()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                                        ON ObjectLink_Unit_HistoryCost.ObjectId = ContainerLinkObject_Unit.ObjectId
                                                       AND ObjectLink_Unit_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
                              WHERE _tmpContainer_branch.ContainerId IS NULL
                                AND ((Container.DescId = zc_Container_Count() AND ContainerLinkObject_Account.ContainerId IS NULL)
                                  OR (Container.DescId = zc_Container_Summ() AND Container.ParentId > 0 AND Container.ObjectId <> zc_Enum_Account_110101()) -- Транзит + товар в пути
                                    )
                             )
    , tmpContainer_branch AS (SELECT Container.*, COALESCE (Object_Unit.Id, 0) AS UnitId
                                   , CASE WHEN ObjectLink_Unit_HistoryCost.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isHistoryCost_ReturnIn
                              FROM Container
                                   INNER JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container.Id
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                 ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id     = ContainerLinkObject_Unit.ObjectId
                                                                  AND Object_Unit.Id     <> zc_Juridical_Basis()
                                                                  -- AND Object_Unit.DescId <> zc_Object_Juridical()
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
                                                          ELSE CASE WHEN inBranchId > 0 THEN 0 ELSE tmpContainer.SendOnPriceCountIn END
                                                     END)
                                              + SUM (CASE WHEN tmpContainer.isHistoryCost_ReturnIn = TRUE
                                                             THEN tmpContainer.ReturnInCount
                                                          ELSE 0
                                                     END) AS IncomeCount
             , SUM (tmpContainer.IncomeSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                              THEN tmpContainer.SendOnPriceSummIn_Cost
                                                         ELSE CASE WHEN inBranchId > 0 THEN 0 ELSE tmpContainer.SendOnPriceSummIn END
                                                    END)
                                              + SUM (CASE WHEN tmpContainer.isHistoryCost_ReturnIn = TRUE
                                                             THEN tmpContainer.ReturnInSumm
                                                          ELSE 0
                                                     END) AS IncomeSumm
             , SUM (tmpContainer.calcCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                             THEN 0
                                                          ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceCountIn ELSE 0 END
                                                     END) AS calcCount
             , SUM (tmpContainer.calcSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                              THEN 0
                                                         ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceSummIn ELSE 0 END
                                                    END) AS calcSumm

             , SUM (tmpContainer.calcCount_external) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                             THEN 0
                                                          ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceCountIn ELSE 0 END
                                                     END) AS calcCount_external
             , SUM (tmpContainer.calcSumm_external) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                              THEN 0
                                                         ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceSummIn ELSE 0 END
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
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeSumm
                     -- SendOnPrice
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = FALSE /*MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = FALSE /*MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut

                     -- <> Транзит + товар в пути
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.AccountId <> zc_Enum_Account_110101() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn_Cost

                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut_Cost
                     -- Calc
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = FALSE /*MIContainer.Amount < 0*/ AND MovementLinkObject_User.ObjectId = zc_Enum_Process_Auto_Defroster() THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount
                   , SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss() THEN COALESCE (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END, 0) ELSE 0 END)
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   - CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.ParentId IS NULL AND MovementLinkObject_User.ObjectId = zc_Enum_Process_Auto_Defroster() THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm
                     -- Calc_external, т.е. AnalyzerId <> UnitId
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (Container.UnitId, zc_Enum_AnalyzerId_ProfitLoss()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount_external
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (Container.UnitId, zc_Enum_AnalyzerId_ProfitLoss()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (Container.UnitId, zc_Enum_AnalyzerId_ProfitLoss()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm_external
                     -- ReturnIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInSumm
                     -- Out
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_IncomeAsset(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = FALSE /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = FALSE /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutSumm
              FROM tmpContainer_zavod AS Container
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.ContainerId = Container.Id
                                                  AND MIContainer.OperDate >= vbStartDate_zavod
                                                  -- AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_110101() -- Транзит + товар в пути
                   LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                             ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                            AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                ON MovementLinkObject_User.MovementId = MIContainer.MovementId
                                               AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
              GROUP BY Container.Id
                     , Container.UnitId
                     , Container.isHistoryCost_ReturnIn
                     , Container.DescId
                     , Container.ObjectId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN      MIContainer.Amount ELSE 0 END), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) <> 0)
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
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate /*AND MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS IncomeSumm
                     -- SendOnPrice
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE /*MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE /*MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut

                     -- <> Транзит + товар в пути
                   , SUM (CASE WHEN Container.DescId = zc_Container_Count()
                               THEN CASE /*WHEN MIContainer.WhereObjectId_Analyzer IN (SELECT _tmpUnit_branch.UnitId     FROM _tmpUnit_branch)
                                          AND MIContainer.ObjectExtId_Analyzer   IN (SELECT _tmpUnit_branch_oth.UnitId FROM _tmpUnit_branch_oth)
                                          AND MIContainer.isActive               = FALSE
                                              THEN 0*/
                                         WHEN MLO_From.ObjectId                  = 3080691 -- Склад ГП ф.Львов"
                                          AND MLO_To.ObjectId                    = 8411    -- Склад ГП ф.Киев"
                                        --AND MIContainer.WhereObjectId_Analyzer = 8411    -- Склад ГП ф.Киев"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- Склад ГП ф.Львов"
                                          AND inBranchId                         = 8379    -- филиал Киев
                                        -- AND MovementBoolean_HistoryCost.ValueData = TRUE
                                        --AND MIContainer.isActive               = TRUE
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MLO_From.ObjectId                  = 8411    -- Склад ГП ф.Киев"
                                          AND MLO_To.ObjectId                    = 3080691 -- Склад ГП ф.Львов"
                                        --AND MIContainer.WhereObjectId_Analyzer = 3080691 -- Склад ГП ф.Львов"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 8411    -- Склад ГП ф.Киев"
                                          AND inBranchId                         = 3080683 -- филиал Львов
                                        -- AND MovementBoolean_HistoryCost.ValueData = TRUE
                                        --AND MIContainer.isActive               = TRUE
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MIContainer.WhereObjectId_Analyzer = 8411    -- Склад ГП ф.Киев"
                                          AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- Склад ГП ф.Львов"
                                          AND inBranchId                         = 8379    -- филиал Киев
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN 0

                                         WHEN MIContainer.WhereObjectId_Analyzer = 3080691 -- Склад ГП ф.Львов"
                                          AND MIContainer.ObjectExtId_Analyzer   = 8411    -- Склад ГП ф.Киев"
                                          AND inBranchId                         = 3080683 -- филиал Львов
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN 0

                                         WHEN 1=1
                                         THEN COALESCE (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END, 0)
                                         ELSE COALESCE (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END, 0)
                                    END
                               ELSE 0
                          END) AS SendOnPriceCountIn_Cost
                   , SUM (CASE WHEN Container.DescId = zc_Container_Summ()
                               THEN CASE /*WHEN MIContainer.WhereObjectId_Analyzer IN (SELECT _tmpUnit_branch.UnitId     FROM _tmpUnit_branch)
                                          AND MIContainer.ObjectExtId_Analyzer   IN (SELECT _tmpUnit_branch_oth.UnitId FROM _tmpUnit_branch_oth)
                                          AND MIContainer.isActive               = FALSE
                                              THEN 0*/
                                         WHEN MLO_From.ObjectId                  = 3080691 -- Склад ГП ф.Львов"
                                          AND MLO_To.ObjectId                    = 8411    -- Склад ГП ф.Киев"
                                        --AND MIContainer.WhereObjectId_Analyzer = 8411    -- Склад ГП ф.Киев"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- Склад ГП ф.Львов"
                                          AND inBranchId                         = 8379    -- филиал Киев
                                        -- AND MovementBoolean_HistoryCost.ValueData = TRUE
                                        --AND MIContainer.isActive               = TRUE
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MLO_From.ObjectId                  = 8411    -- Склад ГП ф.Киев"
                                          AND MLO_To.ObjectId                    = 3080691 -- Склад ГП ф.Львов"
                                        --AND MIContainer.WhereObjectId_Analyzer = 3080691 -- Склад ГП ф.Львов"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 8411    -- Склад ГП ф.Киев"
                                          AND inBranchId                         = 3080683 -- филиал Львов
                                        -- AND MovementBoolean_HistoryCost.ValueData = TRUE
                                        --AND MIContainer.isActive               = TRUE
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MIContainer.WhereObjectId_Analyzer = 8411    -- Склад ГП ф.Киев"
                                          AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- Склад ГП ф.Львов"
                                          AND inBranchId                         = 8379    -- филиал Киев
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN 0
                                         WHEN MIContainer.WhereObjectId_Analyzer = 3080691 -- Склад ГП ф.Львов"
                                          AND MIContainer.ObjectExtId_Analyzer   = 8411    -- Склад ГП ф.Киев"
                                          AND inBranchId                         = 3080683 -- филиал Львов
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN 0

                                         WHEN 1=1
                                         THEN COALESCE (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.AccountId <> zc_Enum_Account_110101() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END, 0)
                                         ELSE COALESCE (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.AccountId <> zc_Enum_Account_110101() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END, 0)
                                    END
                               ELSE 0
                          END) AS SendOnPriceSummIn_Cost

                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut_Cost
                     -- Calc
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount
                   , SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss() THEN COALESCE (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END, 0) ELSE 0 END)
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm
                     -- Calc_external, т.е. AnalyzerId <> UnitId
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (Container.UnitId, zc_Enum_AnalyzerId_ProfitLoss()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_CountSupplier() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) + COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcCount_external
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionSeparate()) AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (Container.UnitId, zc_Enum_AnalyzerId_ProfitLoss()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN  MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                   + CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (Container.UnitId, zc_Enum_AnalyzerId_ProfitLoss()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.ParentId IS NULL THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END
                     AS CalcSumm_external
                     -- ReturnIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS ReturnInSumm
                     -- Out
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_IncomeAsset(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset(), zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE /*AND MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS OutSumm
              FROM tmpContainer_branch AS Container
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                 ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.ContainerId = Container.Id
                                                  AND MIContainer.OperDate >= inStartDate
                                                  -- AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_110101() -- Транзит + товар в пути

                   LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                             ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                            AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                   LEFT JOIN MovementLinkObject AS MLO_From
                                                ON MLO_From.MovementId = MIContainer.MovementId
                                               AND MLO_From.DescId     = zc_MovementLinkObject_From()
                   LEFT JOIN MovementLinkObject AS MLO_To
                                                ON MLO_To.MovementId = MIContainer.MovementId
                                               AND MLO_To.DescId     = zc_MovementLinkObject_To()
              GROUP BY Container.Id
                     , Container.UnitId
                     , Container.isHistoryCost_ReturnIn
                     , Container.DescId
                     , Container.ObjectId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0 THEN      MIContainer.Amount ELSE 0 END), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) <> 0)
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

     -- !!!Оптимизация!!!
     ANALYZE _tmpMaster;
     -- ANALYZE _tmpContainer_branch;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "Название" FieldValue = "end - INSERT INTO _tmpMaster"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Itearation" FieldValue = "0"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
           , TRUE;
     -- запомнили время начала Следующего действия
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- тест***
     /*IF inBranchId = 0 THEN DELETE FROM HistoryCost_test; END IF;
     INSERT INTO HistoryCost_test (InsertDate, Itearation, CountDiff, ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
        SELECT CURRENT_TIMESTAMP, -1, 0, _tmpMaster.ContainerId, _tmpMaster.UnitId, _tmpMaster.isInfoMoney_80401, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.calcCount, _tmpMaster.calcSumm, _tmpMaster.calcCount_external, _tmpMaster.calcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm FROM _tmpMaster;
*/

-- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240);
-- select CLO2.ObjectId from ContainerLinkObject AS CLO2 where CLO2.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240) and CLO2.DescId = zc_ContainerLinkObject_Goods()
-- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (select Container.Id from Container where Container.ObjectId IN (select CLO2.ObjectId from ContainerLinkObject AS CLO2 where CLO2.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240) and CLO2.DescId = zc_ContainerLinkObject_Goods()) union select CLO.ContainerId from ContainerLinkObject AS CLO where CLO.ObjectId IN (select CLO2.ObjectId from ContainerLinkObject AS CLO2 where CLO2.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240) and CLO2.DescId = zc_ContainerLinkObject_Goods()) and CLO.DescId = zc_ContainerLinkObject_Goods());

     -- Ошибка !!! Recycled !!!
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (976442, 976754); -- 06.2016
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (10705, 295520); -- 06.2016
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (142372, 147559); -- 08.2016
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (955225, 147523  -- 09.2016
     --                                                       , 955228, 189406, 955227, 147524, 955226, 147525, 955221, 147522, 1088976, 699999, 955223, 955224, 393568, 149497);
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (647643, 663076, 639413, 633042, 633033); -- 11.2016
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (923943, 922627); -- 03.2017
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (1196707, 1196716, 1196720, 1171167, 1172189); -- 05.2017
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (1153992, 1159046, 1154906, 1145420, 1154908, 1145419) -- 06.2017
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (1153989, 1145422); -- 06.2017
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (130771, 128511, 1489115, 131613, 1453527, 129793); -- 08.2017
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (2811931, 2807719); -- 12.2019
--      DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (141327, 912120, 132601, 140990, 910322, 149565
--                                                            , 939977, 1511515, 125986, 939920, 1496124, 129848, 939979, 1496297, 125540, 935652, 1494455, 716864, 943278, 141221, 1496128, 1530795, 1510665, 716862, 539342, 1512974
--                                                             ); -- 01.2020


/*   -- 04.2018
     DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (1150822, 1164386, 1178003, 1177898);
     DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (
select Container.Id --, O1.*, O2.*, O3.*
from Container
join ContainerLinkObject as CLO1 on CLO1.ContainerId = Container.Id
                                AND CLO1.DescId = zc_ContainerLinkObject_Unit()
                                AND CLO1.ObjectId = 8451
join ContainerLinkObject as CLO2 on CLO2.ContainerId = Container.Id
                                AND CLO2.DescId = zc_ContainerLinkObject_Goods()
                                AND CLO2.ObjectId = 695837
join ContainerLinkObject as CLO3 on CLO3.ContainerId = Container.Id
                                AND CLO3.DescId = zc_ContainerLinkObject_GoodsKind()
                                AND CLO3.ObjectId = 8347
);
*/

     -- DELETE FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 10123123123;
--     DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (SELECT CLO.ContainerId FROM ContainerLinkObject as CLO WHERE CLO.DescId = zc_ContainerLinkObject_Member()
--                                                                                                                      AND CLO.ObjectId = 12573); -- Однокопила Ірина Борисівна


     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (154253, 154250); -- 12.2018

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3190338, 3193380); -- 09.2020
     
     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3231332, 3234249); -- 10.2020

--     DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3502863); -- 04.2021


     IF inBranchId = 0 -- OR 1 = 1
     THEN
         -- !!!1.1. Оптимизация!!!
         CREATE TEMP TABLE tmpMIContainer_Summ_Out ON COMMIT DROP
           AS (SELECT DISTINCT MIContainer_Summ_Out.MovementId, MIContainer_Summ_Out.MovementItemId
                    , MIContainer_Summ_Out.ParentId, MIContainer_Summ_Out.ContainerId
               FROM _tmpMaster
                    INNER JOIN MovementItemContainer AS MIContainer_Summ_Out
                                                     ON MIContainer_Summ_Out.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer_Summ_Out.ContainerId = _tmpMaster.ContainerId
                                                    AND MIContainer_Summ_Out.DescId      = zc_MIContainer_Summ()
                                                    AND MIContainer_Summ_Out.isActive    = FALSE
                                                    AND MIContainer_Summ_Out.ParentId    > 0
                                                    AND MIContainer_Summ_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND COALESCE (MIContainer_Summ_Out.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss()
              );
         -- !!!Оптимизация!!!
         ANALYZE tmpMIContainer_Summ_Out;

         -- !!!1.2. Оптимизация!!!
         CREATE TEMP TABLE tmpMIContainer_Summ_In ON COMMIT DROP
           AS (WITH tmp AS (SELECT DISTINCT MIContainer_Summ_Out.ParentId FROM tmpMIContainer_Summ_Out AS MIContainer_Summ_Out)
                  , tmpContainer_master AS (SELECT _tmpMaster.ContainerId
                                            FROM _tmpMaster
                                                 LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = _tmpMaster.ContainerId
                                            WHERE _tmpContainer_branch.ContainerId IS NULL
                                           )
                  , MIContainer_Summ_In AS (SELECT tmp.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                                                 , SUM (MIContainer_Summ_In.Amount) AS Amount
                                            FROM tmp
                                                 INNER JOIN MovementItemContainer AS MIContainer_Summ_In ON MIContainer_Summ_In.Id = tmp.ParentId
                                            GROUP BY tmp.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                                           )
               SELECT MIContainer_Summ_In.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                    , MIContainer_Summ_In.Amount
               FROM MIContainer_Summ_In
                    INNER JOIN tmpContainer_master ON tmpContainer_master.ContainerId = MIContainer_Summ_In.ContainerId
              );
         -- !!!Оптимизация!!!
         ANALYZE tmpMIContainer_Summ_In;

         -- !!!1.3. Оптимизация!!!
         CREATE TEMP TABLE tmpContainer_count ON COMMIT DROP
           AS (SELECT Container.Id AS ContainerId
               FROM Container
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                  ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                 AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                    LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container.Id
               WHERE Container.DescId = zc_Container_Count() AND ContainerLinkObject_Account.ContainerId IS NULL
                 AND _tmpContainer_branch.ContainerId IS NULL
              );
         -- !!!Оптимизация!!!
         ANALYZE tmpContainer_count;

         -- !!!1.4. Оптимизация!!!
         CREATE TEMP TABLE MIContainer_Count_In  ON COMMIT DROP
           AS (SELECT MIContainer_Count_In.MovementItemId, MIContainer_Count_In.ContainerId, SUM (MIContainer_Count_In.Amount) AS Amount
               FROM tmpContainer_count
                    INNER JOIN MovementItemContainer AS MIContainer_Count_In
                                                     ON MIContainer_Count_In.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer_Count_In.ContainerId  = tmpContainer_count.ContainerId
                                                    AND MIContainer_Count_In.DescId       = zc_MIContainer_Count()
                                                    AND MIContainer_Count_In.isActive     = TRUE
                                                    AND MIContainer_Count_In.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
               GROUP BY MIContainer_Count_In.MovementItemId, MIContainer_Count_In.ContainerId
              );
         -- !!!Оптимизация!!!
         ANALYZE MIContainer_Count_In;


         -- расходы в Child для Master
         INSERT INTO _tmpChild (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount, isExternal, DescId)
            WITH MIContainer_Count_Out AS (SELECT MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer, SUM (MIContainer_Count_Out.Amount) AS Amount
                                           FROM tmpContainer_count
                                                INNER JOIN MovementItemContainer AS MIContainer_Count_Out
                                                                                 ON MIContainer_Count_Out.OperDate BETWEEN inStartDate AND inEndDate
                                                                                AND MIContainer_Count_Out.ContainerId = tmpContainer_count.ContainerId
                                                                                AND MIContainer_Count_Out.DescId      = zc_MIContainer_Count()
                                                                                AND MIContainer_Count_Out.isActive    = FALSE
                                                                                AND MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                           GROUP BY MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer
                                          )
               , MIContainer_Summ_Out AS (SELECT tmpMIContainer_Summ_Out.MovementId, tmpMIContainer_Summ_Out.MovementItemId
                                               , tmpMIContainer_Summ_Out.ParentId, tmpMIContainer_Summ_Out.ContainerId
                                          FROM tmpMIContainer_Summ_Out
                                         )
                , MIContainer_Summ_In AS (SELECT tmpMIContainer_Summ_In.ParentId, tmpMIContainer_Summ_In.MovementId, tmpMIContainer_Summ_In.ContainerId, tmpMIContainer_Summ_In.MovementItemId, tmpMIContainer_Summ_In.WhereObjectId_Analyzer, tmpMIContainer_Summ_In.Amount
                                          FROM tmpMIContainer_Summ_In
                                         )
                , tmpSeparate AS (SELECT Movement.Id AS  MovementId
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
                                 )
            -- Результат
            SELECT COALESCE (MIContainer_Summ_In.ContainerId, 0)   AS MasterContainerId
                 , COALESCE (MIContainer_Summ_Out.ContainerId, 0)  AS ContainerId
                 , COALESCE (MIContainer_Count_In.ContainerId, 0)  AS MasterContainerId_Count
                 , COALESCE (MIContainer_Count_Out.ContainerId, 0) AS ContainerId_Count
                 , SUM (CASE WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_ProductionSeparate())
                                 THEN CASE WHEN  COALESCE (_tmp.Summ, 0) <> 0 THEN COALESCE (-1 * MIContainer_Count_Out.Amount * MIContainer_Summ_In.Amount / _tmp.Summ, 0) ELSE 0 END
                             WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                                 THEN COALESCE (1 * MIContainer_Count_In.Amount, 0)
                             WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_ProductionUnion())
                                 THEN COALESCE (-1 * MIContainer_Count_Out.Amount, 0)
                             ELSE 0
                        END) AS OperCount
                 , CASE WHEN MIContainer_Count_Out.WhereObjectId_Analyzer = MIContainer_Summ_In.WhereObjectId_Analyzer THEN FALSE ELSE TRUE END AS isExternal
                 , 0 AS MovementDescId
                 -- , MIContainer_Count_Out.MovementDescId
            FROM MIContainer_Count_Out
                 JOIN MIContainer_Summ_Out ON MIContainer_Summ_Out.MovementId     = MIContainer_Count_Out.MovementId
                                          AND MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                 JOIN Container AS Container_Summ_Out ON Container_Summ_Out.Id       = MIContainer_Summ_Out.ContainerId
                                                     AND Container_Summ_Out.ParentId = MIContainer_Count_Out.ContainerId

                 JOIN MIContainer_Summ_In ON MIContainer_Summ_In.ParentId = MIContainer_Summ_Out.ParentId
                 JOIN Container AS Container_Summ_In ON Container_Summ_In.Id       = MIContainer_Summ_In.ContainerId

                 JOIN MIContainer_Count_In ON MIContainer_Count_In.MovementItemId = MIContainer_Summ_In.MovementItemId
                                          AND MIContainer_Count_In.ContainerId    = Container_Summ_In.ParentId

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = MIContainer_Count_Out.MovementId
                                             AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                             AND MovementLinkObject_User.ObjectId   = zc_Enum_Process_Auto_Defroster()

                 LEFT JOIN tmpSeparate AS _tmp ON _tmp.MovementId = MIContainer_Count_Out.MovementId
                                              AND _tmp.ContainerId = MIContainer_Summ_Out.ContainerId
                                              AND _tmp.MovementItemId = MIContainer_Summ_Out.MovementItemId
                                              AND MIContainer_Count_Out.MovementDescId = zc_Movement_ProductionSeparate()
            WHERE MovementLinkObject_User.MovementId IS NULL
            GROUP BY MIContainer_Summ_In.ContainerId
                   , MIContainer_Summ_Out.ContainerId
                   , MIContainer_Count_In.ContainerId
                   , MIContainer_Count_Out.ContainerId
                   , MIContainer_Count_Out.WhereObjectId_Analyzer
                   , MIContainer_Summ_In.WhereObjectId_Analyzer
                   -- , MIContainer_Count_Out.MovementDescId
            ;

            -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
            INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
              SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
                      , '<XML>'
                     || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
                     || '<Field FieldName = "Название" FieldValue = "end - INSERT INTO _tmpChild"/>'
                     || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
                     || '<Field FieldName = "Itearation" FieldValue = "0"/>'
                     || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
                     || '</XML>'
                  , TRUE;
            -- запомнили время начала Следующего действия
            vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     END IF; -- if inBranchId = 0


/*     -- добавляются связи которых нет (т.к. нулевые проводки не формируются)
       -- добавляются связи которых нет (т.к. нулевые проводки не формируются) !!!по прошлому периоду если он > 01.06.2014!!!*/


     -- !!!временно, пока ошибка!!!
     -- delete from _tmpChild where _tmpChild.MasterContainerId IN ( SELECT _tmpChild.MasterContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1);


     -- проверка1
     IF EXISTS (SELECT _tmpMaster.ContainerId FROM _tmpMaster GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'проверка1 - SELECT ContainerId FROM _tmpMaster GROUP BY ContainerId HAVING COUNT(*) > 1 ContainerId = % + count = %'
                       , (SELECT _tmpMaster.ContainerId FROM _tmpMaster GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1 LIMIT 1)
                       , (SELECT COUNT(*) FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (SELECT _tmpMaster.ContainerId FROM _tmpMaster GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1))
                        ;
     END IF;
     -- проверка2
     IF EXISTS (SELECT _tmpChild.MasterContainerId, _tmpChild.ContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'проверка2 - SELECT MasterContainerId, ContainerId FROM _tmpChild GROUP BY MasterContainerId, ContainerId HAVING COUNT(*) > 1 :  MasterContainerId = % and ContainerId = %'
                       , (SELECT _tmpChild.MasterContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
                       , (SELECT _tmpChild.ContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
                        ;
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - итерации для с/с !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- !!! 1-ая итерация для всех !!!
         UPDATE _tmpMaster SET CalcSumm          = _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpSumm.CalcSumm_external
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.DescId = zc_Movement_Send() THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
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
                          /*, CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                 ELSE 0
                            END AS OperPrice_external*/
                     FROM _tmpMaster
                    ) AS _tmpPrice
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId;



     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "Название" FieldValue = "end - UPDATE _tmpMaster - 0.1."/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Itearation" FieldValue = "0"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
           , TRUE;
     -- запомнили время начала Следующего действия
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     -- тест***
     /*INSERT INTO HistoryCost_test (InsertDate, Itearation, CountDiff, ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
        SELECT CURRENT_TIMESTAMP, 0, 0, _tmpMaster.ContainerId, _tmpMaster.UnitId, _tmpMaster.isInfoMoney_80401, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.calcCount, _tmpMaster.calcSumm, _tmpMaster.calcCount_external, _tmpMaster.calcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm FROM _tmpMaster;
*/

     -- !!! остальные итерации без Упаковки !!!
     vbItearation:=0;
     vbCountDiff:= 100000;
     WHILE vbItearation < inItearationCount AND vbCountDiff > 0
     LOOP
         -- !!!ВРЕМЕННО!!!
         -- DELETE FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 112312312;

         -- т.к. ошибка
         IF vbItearation = vbItearationCount_err AND inStartDate < '01.07.2018'
         THEN
             /*-- delete
             select * from HistoryCost WHERE '01.06.2018' = StartDate and ContainerId in (
                                   SELECT DISTINCT ContainerId
                                   FROM ContainerLinkObject AS CLO
                                   WHERE ObjectId   = 5662
                                     AND CLO.DescId = zc_ContainerLinkObject_Goods())*/
             -- сохранили - для "некоторых" товаров
             INSERT INTO _tmpMaster_err
                WITH tmpGoods AS (SELECT 5662  AS GoodsId
                                 UNION
                                  SELECT 3902   AS GoodsId
                                 UNION
                                  SELECT 607384   AS GoodsId
                                 UNION
                                  SELECT 1076606   AS GoodsId
                                 )
                SELECT DISTINCT _tmpMaster.*
                FROM _tmpMaster
                     INNER JOIN ContainerLinkObject AS CLO
                                                    ON CLO.ContainerId = _tmpMaster.ContainerId
                                                   AND CLO.DescId      = zc_ContainerLinkObject_Goods()
                     INNER JOIN tmpGoods ON tmpGoods.GoodsId = CLO.ObjectId
                WHERE 1=0
               ;

         END IF;

         -- расчет с/с
         UPDATE _tmpMaster SET CalcSumm          = _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpSumm.CalcSumm_external
               -- Расчет суммы всех составляющих
         FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * CASE WHEN _tmpPrice.OperPrice_external > 12345 THEN 1.2345 ELSE _tmpPrice.OperPrice_external END ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.DescId = zc_Movement_Send() THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
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
                          /*, CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                 ELSE 0
                            END AS OperPrice_external*/
                     FROM _tmpMaster
                    ) AS _tmpPrice
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           --*** AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8451 END -- Цех Упаковки
           -- AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8440 END -- Дефростер
        ;

         -- т.к. ошибка - восстановили
         IF EXISTS (SELECT 1 FROM _tmpMaster_err)
         THEN
             -- для "некоторых" товаров
             UPDATE _tmpMaster SET CalcSumm          = _tmpMaster_err.CalcSumm
                                 , CalcSumm_external = _tmpMaster_err.CalcSumm_external
             FROM _tmpMaster_err
             WHERE _tmpMaster.ContainerId = _tmpMaster_err.ContainerId
            ;

         END IF;


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
                          LEFT JOIN _tmpMaster_err ON _tmpMaster_err.ContainerId =_tmpMaster.ContainerId
                     WHERE _tmpMaster_err.ContainerId IS NULL

                    ) AS _tmpPrice
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND ABS (_tmpMaster.CalcSumm - _tmpSumm.CalcSumm) > inDiffSumm
           --*** AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8451 END -- Цех Упаковки
           -- AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8440 END -- Дефростер
        ;

         -- увеличивам итерации
         vbItearation:= vbItearation + 1;

         -- тест***
         /*INSERT INTO HistoryCost_test (InsertDate, Itearation, CountDiff, ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
            SELECT CURRENT_TIMESTAMP, vbItearation, vbCountDiff, _tmpMaster.ContainerId, _tmpMaster.UnitId, _tmpMaster.isInfoMoney_80401, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.calcCount, _tmpMaster.calcSumm, _tmpMaster.calcCount_external, _tmpMaster.calcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm FROM _tmpMaster;
*/
     END LOOP;



     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "Название" FieldValue = "end - CALC"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Itearation" FieldValue = "' || vbItearation :: TVarChar || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
           , TRUE;
     -- запомнили время начала Следующего действия
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     IF inInsert > 0 THEN

     -- Сохранили Diff
     /*INSERT INTO _tmpDiff (ContainerId, MovementItemId_diff, Summ_diff)
        SELECT HistoryCost.ContainerId, MAX (HistoryCost.MovementItemId_diff), SUM (HistoryCost.Summ_diff) FROM HistoryCost WHERE HistoryCost.Summ_diff <> 0 AND ((inStartDate BETWEEN StartDate AND EndDate) OR (inEndDate BETWEEN StartDate AND EndDate)) GROUP BY HistoryCost.ContainerId;
     */
     IF inBranchId > 0
     THEN
         -- Удаляем предыдущую с/с - !!!для 1-ого Филиала!!!
         DELETE FROM HistoryCost -- WHERE ((StartDate BETWEEN inStartDate AND inEndDate) OR (EndDate BETWEEN inStartDate AND inEndDate))
                                 WHERE HistoryCost.StartDate   IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
                                   AND HistoryCost.ContainerId IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                                  /*(SELECT ContainerLinkObject.ContainerId
                                                                   FROM _tmpUnit_branch
                                                                        INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                                  );*/

         -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "Название" FieldValue = "end - DELETE-1"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- запомнили время начала Следующего действия
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


         -- !!!УДАЛИЛИ НУЛИ!!!
         DELETE FROM _tmpMaster
         WHERE (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm          = 0)
           AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external = 0)
          ;

         -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "Название" FieldValue = "end - delete-2"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- запомнили время начала Следующего действия
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


         -- Сохраняем что насчитали - !!!для 1-ого Филиала!!!
         INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
            /*WITH tmpErr AS (SELECT Container.*
                            FROM Container
                                 INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.ObjectId = 8411 -- Склад ГП ф.Киев
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                 INNER JOIN ContainerLinkObject as CLO2 ON CLO2.ContainerId = Container.Id
                                                               AND CLO2.ObjectId = 621819 -- С/К МАХАН по-татарськи 1г, ТМ Наші Колбаси
                                                               AND CLO2.DescId = zc_ContainerLinkObject_Goods()
                            WHERE Container.DescId = zc_Container_Summ()
                              AND inEndDate <= '31.03.2018'
                              AND inBranchId = 8379 -- ф.Киев
                           )*/
            -- Результат
            SELECT _tmpMaster.ContainerId, inStartDate AS StartDate, inEndDate AS EndDate
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE -- OR tmpErr.Id > 0 -- !!!временно!!!
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                        ELSE 0
                   END AS Price
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE -- OR tmpErr.Id > 0 -- !!!временно!!!
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
                 , 0 AS MovementItemId_diff, 0 AS Summ_diff
                 -- , _tmpDiff.MovementItemId_diff, _tmpDiff.Summ_diff
            FROM _tmpMaster
                 -- LEFT JOIN _tmpDiff ON _tmpDiff.ContainerId = _tmpMaster.ContainerId
                 -- !!!временно!!!
                 -- LEFT JOIN tmpErr ON tmpErr.Id = _tmpMaster.ContainerId

            WHERE /*(((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm)          <> 0)
                OR ((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) <> 0)
                  )
              AND*/ _tmpMaster.ContainerId IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                            /*(SELECT ContainerLinkObject.ContainerId
                                             FROM _tmpUnit_branch
                                                  INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                            );*/
     ELSE
         -- Удаляем предыдущую с/с - !!!кроме всех Филиалов!!!
         DELETE FROM HistoryCost -- WHERE ((HistoryCost.StartDate BETWEEN inStartDate AND inEndDate) OR (HistoryCost.EndDate BETWEEN inStartDate AND inEndDate))
                                 WHERE HistoryCost.StartDate       IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
                                   AND HistoryCost.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                                      /*(SELECT ContainerLinkObject.ContainerId
                                                                       FROM _tmpUnit_branch
                                                                            INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                                          AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                                      );*/

         -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "Название" FieldValue = "end - DELETE-1"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- запомнили время начала Следующего действия
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


         -- !!!УДАЛИЛИ НУЛИ!!!
         DELETE FROM _tmpMaster
         WHERE (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm          = 0)
           AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external = 0)
          ;
         -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "Название" FieldValue = "end - delete-2"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- запомнили время начала Следующего действия
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


         -- Сохраняем что насчитали - !!!кроме всех Филиалов!!!
         INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
            SELECT _tmpMaster.ContainerId, inStartDate AS StartDate
                 , DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
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
                 -- , _tmpDiff.MovementItemId_diff, _tmpDiff.Summ_diff
                 , 0 AS MovementItemId_diff, 0 AS Summ_diff
            FROM _tmpMaster
                 -- LEFT JOIN _tmpDiff ON _tmpDiff.ContainerId = _tmpMaster.ContainerId
            WHERE /*(((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm)          <> 0)
                OR ((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) <> 0)
                  )
              AND*/ _tmpMaster.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                /*(SELECT ContainerLinkObject.ContainerId
                                                 FROM _tmpUnit_branch
                                                      INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                );*/
     END IF;


     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
           , '<XML>'
          || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
          || '<Field FieldName = "Название" FieldValue = "end - insert ALL"/>'
          || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
          || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
          || '</XML>'
           , TRUE;
     -- запомнили время начала Следующего действия
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


        -- !!!ВРЕМЕННО!!!
        UPDATE HistoryCost SET Price          = 1.1234 * CASE WHEN HistoryCost.Price < 0 THEN -1 ELSE 1 END
                             , Price_external = 1.1234 * CASE WHEN HistoryCost.Price < 0 THEN -1 ELSE 1 END
        FROM Container
             INNER JOIN ContainerLinkObject AS ContainerLO_Goods
                                            ON ContainerLO_Goods.ContainerId = Container.Id
                                           AND ContainerLO_Goods.DescId = zc_ContainerLinkObject_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ContainerLO_Goods.ObjectId
                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                               AND (View_InfoMoney.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_30000()) -- Доходы
                                                                 OR View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                                                            , zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                                                            , zc_Enum_InfoMoneyDestination_21000() -- Чапли
                                                                                                            , zc_Enum_InfoMoneyDestination_21100() -- Дворкин
                                                                                                             )
                                                                   )
        WHERE HistoryCost.StartDate = inStartDate
          AND ABS (HistoryCost.Price) >  10800
          AND HistoryCost.ContainerId = Container.Id
       ;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
           , '<XML>'
          || '<Field FieldName = "Код" FieldValue = "HistoryCost"/>'
          || '<Field FieldName = "Название" FieldValue = "end - update Price"/>'
          || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
          || '<Field FieldName = "StartDate" FieldValue = "'     || zfConvert_DateToString (inStartDate) || '"/>'
          || '<Field FieldName = "EndDate" FieldValue = "'     || zfConvert_DateToString (inEndDate) || '"/>'
          || '</XML>'
           , TRUE;

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
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm <> 0 THEN _tmpSumm.CalcSumm ELSE _tmpMaster.CalcSumm END) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm <> 0 THEN _tmpSumm.CalcSumm ELSE _tmpMaster.CalcSumm END) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm <> 0 THEN _tmpSumm.CalcSumm ELSE _tmpMaster.CalcSumm END) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm <> 0 THEN _tmpSumm.CalcSumm ELSE _tmpMaster.CalcSumm END) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount)
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
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external)
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
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external

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
                          /*, CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                      THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) <> 0
                                                     THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                                ELSE  0
                                           END
                                 WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) > 0)
                                    OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) < 0))
                                      THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                 ELSE 0
                            END AS OperPrice_external*/
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

/*
delete from HistoryCost where HistoryCost.ContainerId
in (

SELECT distinct HistoryCost.ContainerId
FROM HistoryCost
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                      ON ContainerLinkObject_InfoMoney.ContainerId = HistoryCost.ContainerId
--                                     AND ContainerLinkObject_InfoMoney.DescId     = zc_ContainerLinkObject_InfoMoney()
                                     AND ContainerLinkObject_InfoMoney.DescId     = zc_ContainerLinkObject_InfoMoneyDetail()
                                     and ContainerLinkObject_InfoMoney.ObjectId      = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
             inner JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                      ON ContainerLinkObject_Unit.ContainerId = HistoryCost.ContainerId
                                     AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
             inner JOIN Object  ON Object.Id = ContainerLinkObject_Unit.ObjectId
WHERE '01.03.2018' <= StartDate
-- and HistoryCost.ContainerId in (828591)
and Object.Id in (8459, 8451)


)
 and StartDate  >=  '01.03.2018'
;
*/

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

-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 8462, 8462 /*8459*/); -- Склад Брак -> Склад Реализации
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 8461, 8461 /*8459*/); -- Склад Возвратов -> Склад Реализации
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 256716, 256716 /*8459*/); -- Склад УТИЛЬ -> Склад Реализации
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 428365, 428365 ); -- Склад возвратов ф.Киев
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 309599, 301309); -- Склад возвратов ф.Запорожье -> Склад гп ф.Запорожье
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 428366 , 428366 ); -- Склад возвратов ф.Кривой Рог
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 428364 , 428364 ); -- Склад возвратов ф.Николаев (Херсон)
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 409007 , 409007 ); -- Склад возвратов ф.Харьков
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 428363 ,428363 ); -- Склад возвратов ф.Черкассы (Кировоград)
-- select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_HistoryCost(), 3080696,3080696 ); -- Склад возвратов ф.Львов

-- select 'zc_isHistoryCost', zc_isHistoryCost()union all select 'zc_isHistoryCost_byInfoMoneyDetail', zc_isHistoryCost_byInfoMoneyDetail() order by 1;

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

-- SELECT * FROM HistoryCost where ContainerId in ( 141708) ORDER BY 1 DESC

/*
select distinct Object.ObjectCode, Object.ValueData, Object2.ObjectCode, Object2.ValueData, Object3.ObjectCode, Object3.ValueData, Object4.ValueData
from Container
     left join ContainerLinkObject on ContainerLinkObject.ContainerId = Container.Id and ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit() left join Object on Object.Id = ContainerLinkObject.ObjectId
     left join ContainerLinkObject as clo2 on clo2.ContainerId = Container.Id and clo2.DescId = zc_ContainerLinkObject_Goods()                      left join Object as Object2 on Object2.Id = clo2.ObjectId
     left join ContainerLinkObject as clo3 on clo3.ContainerId = Container.Id and clo3.DescId = zc_ContainerLinkObject_GoodsKind()                  left join Object as Object3 on Object3.Id = clo3.ObjectId
     left join ContainerLinkObject as clo4 on clo4.ContainerId = Container.Id and clo4.DescId = zc_ContainerLinkObject_PartionGoods()               left join Object as Object4 on Object4.Id = clo4.ObjectId
where  Container.Id in (SELECT HistoryCost.ContainerId FROM HistoryCost WHERE ('01.12.2016' BETWEEN StartDate AND EndDate) and abs (Price) = 1.1234 and CalcSumm > 1000)
order by 3, 5

SELECT * FROM HistoryCost WHERE ('01.03.2017' BETWEEN StartDate AND EndDate) and abs (Price) = 1.1234 order by Price desc -- and CalcSumm > 1000000
*/

-- тест***
-- CREATE TABLE HistoryCost_test (InsertDate TDateTime, OperDate TDateTime, Itearation Integer, CountDiff Integer, ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat); CREATE INDEX idx_HistoryCost_test_ContainerId ON HistoryCost_test(ContainerId);

-- SELECT * FROM HistoryCost_test WHERE ContainerId = 1260491 ORDER BY InsertDate;

-- филиал Киев
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.01.2016', inEndDate:= '31.01.2016', inBranchId:= 8379, inItearationCount:= 1000, inInsert:= 12345, inDiffSumm:= 0.009, inSession:= '2') -- WHERE CalcSummCurrent <> CalcSummNext

-- тест
-- SELECT * FROM  ObjectProtocol WHERE ObjectId = zfCalc_UserAdmin() :: Integer ORDER BY ID DESC LIMIT 100
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.03.2020', inEndDate:= '01.03.2020', inBranchId:= 0, inItearationCount:= 10, inInsert:= -1, inDiffSumm:= 1, inSession:= '2') WHERE ContainerId in (2459386, 2459377) -- ORDER BY ABS (Price) DESC -- Price <> PriceNext-- WHERE CalcSummCurrent <> CalcSummNext
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.09.2020', inEndDate:= '31.09.2020', inBranchId:= 301310, inItearationCount:= 10, inInsert:= 12345, inDiffSumm:= 1, inSession:= '2') WHERE ContainerId in (2459386, 2459377) -- ORDER BY ABS (Price) DESC -- Price <> PriceNext-- WHERE CalcSummCurrent <> CalcSummNext
-- SELECT * FROM gpInsertUpdate_HistoryCost (inStartDate:= '01.04.2021', inEndDate:= '23.04.2021', inBranchId:= 0, inItearationCount:= 200, inInsert:= -1, inDiffSumm:= 1, inSession:= '2') WHERE ContainerId in (769262) -- ORDER BY ABS (Price) DESC -- Price <> PriceNext-- WHERE CalcSummCurrent <> CalcSummNext
