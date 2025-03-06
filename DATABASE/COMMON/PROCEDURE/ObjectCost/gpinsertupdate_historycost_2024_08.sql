-- Function: gpinsertupdate_historycost(tdatetime, tdatetime, integer, integer, integer, tfloat, tvarchar)

-- DROP FUNCTION gpinsertupdate_historycost(tdatetime, tdatetime, integer, integer, integer, tfloat, tvarchar);

CREATE OR REPLACE FUNCTION gpinsertupdate_historycost(
    IN instartdate tdatetime,
    IN inenddate tdatetime,
    IN inbranchid integer,
    IN initearationcount integer,
    IN ininsert integer,
    IN indiffsumm tfloat,
    IN insession tvarchar)
  RETURNS TABLE(vbitearation integer, vbcountdiff integer, price tfloat, pricenext tfloat, price_external tfloat, pricenext_external tfloat, fromcontainerid integer, containerid integer, goodsid integer, goodskindid integer, infomoneyid integer, infomoneyid_detail integer, accountid integer, juridicalid_basis integer, isinfomoney_80401 boolean, calcsummcurrent tfloat, calcsummnext tfloat, calcsummcurrent_external tfloat, calcsummnext_external tfloat, startcount tfloat, startsumm tfloat, incomecount tfloat, incomesumm tfloat, calccount tfloat, calcsumm tfloat, calccount_external tfloat, calcsumm_external tfloat, outcount tfloat, outsumm tfloat, unitid integer, unitname tvarchar) AS
$BODY$
   DECLARE vbStartDate_zavod TDateTime;
   DECLARE vbEndDate_zavod   TDateTime;

   DECLARE vbItearation Integer;
   DECLARE vbCountDiff  Integer;

   DECLARE vbItearationCount_err Integer;
   DECLARE vbOperDate_StartBegin TDateTime;

   DECLARE vbIsBranch_Itearation Boolean;

   DECLARE vbExec_str TVarChar;
   DECLARE vbMONTH_str TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());

     -- !!!выход!!!
     -- IF inStartDate >= '01.03.2020' THEN RETURN; END IF;
     -- IF inBranchId IN (8379, 3080683) THEN RETURN; END IF;
     -- IF inBranchId IN (0) THEN RETURN; END IF;

     --if inItearationCount > 1 then inItearationCount:= 0;  END IF;


     --
     vbIsBranch_Itearation:= FALSE;
     --vbIsBranch_Itearation:= TRUE;


RAISE INFO ' start all .<%>', CLOCK_TIMESTAMP();

     IF inItearationCount > 80 THEN inItearationCount:= 80; END IF;
     inDiffSumm       := 0.009;

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

     CREATE TEMP TABLE _tmpErr (ContainerId Integer, UnitId Integer) ON COMMIT DROP;
     -- таблица - Список Master для с/с.
     CREATE TEMP TABLE _tmpMaster (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean
                                 , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                 , calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat
                                 , OutCount TFloat, OutSumm TFloat
                                 , AccountId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, JuridicalId_basis Integer
                                 , isZavod Boolean
                                  ) ON COMMIT DROP;
     -- таблица - расходы для Master
     CREATE TEMP TABLE _tmpChild (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean, DescId Integer
                                , AccountId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, JuridicalId_basis Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                , AccountId_master Integer, UnitId_master Integer, GoodsId_master Integer, GoodsKindId_master Integer, JuridicalId_basis_master Integer, InfoMoneyId_master Integer, InfoMoneyId_Detail_master Integer
                                 ) ON COMMIT DROP;
     -- таблица - "округления"
     --* CREATE TEMP TABLE _tmpDiff (ContainerId Integer, MovementItemId_diff Integer, Summ_diff TFloat) ON COMMIT DROP;

     CREATE TEMP TABLE _tmpHistoryCost_PartionCell (UnitId Integer, GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                                  , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                                  , CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, CalcSumm_external TFloat
                                                  , OutCount TFloat, OutSumm TFloat
                                                  , AccountId Integer, isInfoMoney_80401 Boolean
                                                  , JuridicalId_basis Integer
                                                   ) ON COMMIT DROP;

     -- таблица - филиалы
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

     -- таблица - филиалы
     CREATE TEMP TABLE _tmpContainer_branch (ContainerId Integer) ON COMMIT DROP;
     INSERT INTO _tmpContainer_branch (ContainerId)
        SELECT ContainerLinkObject.ContainerId
        FROM _tmpUnit_branch
             INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                           AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
       ;

     -- !!!Оптимизация!!!
     ANALYZE _tmpContainer_branch;


     -- Суммы, если есть Остаток или Движение - 2024.08
     CREATE TEMP TABLE tmpContainerList ON COMMIT DROP AS
        WITH tmpContainerS_zavod AS (SELECT Container_Summ.*
                                          , CLO_Unit.ObjectId                    AS UnitId
                                          , CLO_Goods.ObjectId                   AS GoodsId
                                          , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , CLO_JuridicalBasis.ObjectId          AS JuridicalId_basis
                                          , CLO_InfoMoney.ObjectId               AS InfoMoneyId
                                          , CLO_InfoMoneyDetail.ObjectId         AS InfoMoneyId_Detail
                                      FROM Container AS Container_Summ
                                           LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container_Summ.Id

                                           LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                         ON CLO_Unit.ContainerId = Container_Summ.Id
                                                                        AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container_Summ.Id
                                                                                         AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                                                                               AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                           LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = Container_Summ.Id
                                                                                     AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                           LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container_Summ.Id
                                                                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                           LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = Container_Summ.Id
                                                                                              AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()

                                      WHERE _tmpContainer_branch.ContainerId IS NULL
                                        AND Container_Summ.DescId = zc_Container_Summ()
                                        AND Container_Summ.ParentId > 0
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
                                     )
           , tmpContainerS_branch AS (SELECT Container_Summ.*
                                      FROM Container AS Container_Summ
                                           INNER JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container_Summ.Id
                                      WHERE Container_Summ.DescId = zc_Container_Summ()
                                        AND Container_Summ.ParentId > 0
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                        AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
                                     )
, tmpContainer_Summ_union AS (SELECT tmpContainerS_zavod.GoodsId
                                   , tmpContainerS_zavod.UnitId
                                     -- 20101 - Продукция
                                   , MAX (CASE WHEN tmpContainerS_zavod.ObjectId    = 9086 THEN tmpContainerS_zavod.ObjectId    ELSE 0 END) AS ObjectId
                                     -- Готовая продукция
                                   , MAX (CASE WHEN tmpContainerS_zavod.InfoMoneyId = 8962 THEN tmpContainerS_zavod.InfoMoneyId ELSE 0 END) AS InfoMoneyId
                              FROM tmpContainerS_zavod
                              GROUP BY tmpContainerS_zavod.GoodsId
                                     , tmpContainerS_zavod.UnitId
                             )
            -- или Начальный ост или есть движение
          , tmpContainer_count_RK AS (SELECT Container_count.Id AS ContainerId
                                      FROM Container AS Container_count
                                           INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                          ON CLO_Unit.ContainerId = Container_count.Id
                                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                         AND CLO_Unit.ObjectId    = zc_Unit_RK()
                                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                                         ON ContainerLinkObject_Account.ContainerId = Container_count.Id
                                                                        AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                                           LEFT JOIN MovementItemContainer AS MIContainer
                                                                           ON MIContainer.ContainerId = Container_count.Id
                                                                          AND MIContainer.OperDate >= vbStartDate_zavod
                                      WHERE Container_count.DescId = zc_Container_Count()
                                        AND ContainerLinkObject_Account.ContainerId IS NULL
                                      GROUP BY Container_count.Id, Container_count.Amount
                                      HAVING Container_count.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                          OR 0 <> SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount <> 0 THEN 1 ELSE 0 END)
                                     )
        -- Результат - Суммы, если есть Остаток или Движение
        SELECT Container_Summ.Id AS ContainerId, Container_Summ.ParentId AS ContainerId_count
             , CASE WHEN tmpContainer_Summ_union.ObjectId > 0 THEN tmpContainer_Summ_union.ObjectId ELSE Container_Summ.ObjectId END AS AccountId
             , TRUE AS isZavod
             , Container_Summ.UnitId
             , Container_Summ.GoodsId
             , Container_Summ.GoodsKindId
             , Container_Summ.JuridicalId_basis
             , CASE WHEN tmpContainer_Summ_union.InfoMoneyId > 0 THEN tmpContainer_Summ_union.InfoMoneyId ELSE Container_Summ.InfoMoneyId END AS InfoMoneyId
             , Container_Summ.InfoMoneyId_Detail
        FROM tmpContainerS_zavod AS Container_Summ
             LEFT JOIN tmpContainer_count_RK ON tmpContainer_count_RK.ContainerId = Container_Summ.ParentId
             --
             LEFT JOIN tmpContainer_Summ_union ON tmpContainer_Summ_union.GoodsId = Container_Summ.GoodsId
                                              AND tmpContainer_Summ_union.UnitId  = Container_Summ.UnitId
             LEFT JOIN MovementItemContainer AS MIContainer
                                             ON MIContainer.ContainerId = Container_Summ.Id
                                            AND MIContainer.OperDate >= vbStartDate_zavod
                                            AND MIContainer.AccountId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                            AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110132()
        WHERE Container_Summ.DescId = zc_Container_Summ()
          AND Container_Summ.ParentId > 0
          AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
          AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
          AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
        GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount
               , CASE WHEN tmpContainer_Summ_union.ObjectId > 0 THEN tmpContainer_Summ_union.ObjectId ELSE Container_Summ.ObjectId END
               , Container_Summ.UnitId
               , Container_Summ.GoodsId
               , Container_Summ.GoodsKindId
               , Container_Summ.JuridicalId_basis
               , CASE WHEN tmpContainer_Summ_union.InfoMoneyId > 0 THEN tmpContainer_Summ_union.InfoMoneyId ELSE Container_Summ.InfoMoneyId END
               , Container_Summ.InfoMoneyId_Detail
        HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
            -- или движение Container_Summ
            OR MAX (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN Container_Summ.Id ELSE 0 END) > 0
            -- или движение Container_count_RK
            OR MAX (CASE WHEN tmpContainer_count_RK.ContainerId > 0 THEN tmpContainer_count_RK.ContainerId ELSE 0 END) > 0

       UNION ALL
        -- добавили пустые
        SELECT 0 AS ContainerId, tmpContainer_count_RK.ContainerId AS ContainerId_count, 0 AS AccountId, TRUE AS isZavod
             , 0 AS UnitId
             , 0 AS GoodsId
             , 0 AS GoodsKindId
             , 0 AS JuridicalId_basis
             , 0 AS InfoMoneyId
             , 0 AS InfoMoneyId_Detail
        FROM tmpContainer_count_RK
             LEFT JOIN tmpContainerS_zavod AS Container_Summ ON Container_Summ.ParentId = tmpContainer_count_RK.ContainerId
        WHERE Container_Summ.ParentId IS NULL

       UNION ALL
        -- филиалы
        SELECT Container_Summ.Id AS ContainerId, Container_Summ.ParentId AS ContainerId_count, Container_Summ.ObjectId AS AccountId, TRUE AS isZavod
             , 0 AS UnitId
             , 0 AS GoodsId
             , 0 AS GoodsKindId
             , 0 AS JuridicalId_basis
             , 0 AS InfoMoneyId
             , 0 AS InfoMoneyId_Detail
        FROM tmpContainerS_branch AS Container_Summ
             LEFT JOIN MovementItemContainer AS MIContainer
                                             ON MIContainer.ContainerId = Container_Summ.Id
                                            AND MIContainer.OperDate >= inStartDate
                                            AND MIContainer.AccountId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                            AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                            AND MIContainer.AccountId <> zc_Enum_Account_110132()
        WHERE Container_Summ.DescId = zc_Container_Summ()
          AND Container_Summ.ParentId > 0
          AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- Запасы + Оборотная тара
          AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
          AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
          AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
        GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount, Container_Summ.ObjectId
        HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
            OR MAX (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN Container_Summ.Id ELSE 0 END) > 0
       ;
     -- !!!Оптимизация!!!
     ANALYZE tmpContainerList;

RAISE INFO '_end tmpContainerList on ContainerId_count = .<%>  <%>'
, (select count(*) from tmpContainerList WHERE tmpContainerList.ContainerId_count = 5043563)
, (select count(*) from tmpContainerList WHERE tmpContainerList.ContainerId_count = 8651068)
;

     -- группировка ПАРТИЙ - на складах ГП + zc_Unit_RK - 2024.08
     CREATE TEMP TABLE tmpContainerList_partion ON COMMIT DROP AS
        SELECT DISTINCT
               tmpContainerList.ContainerId_count
             , tmpContainerList.AccountId
             , tmpContainerList.UnitId
             , tmpContainerList.GoodsId
             , tmpContainerList.GoodsKindId
             , tmpContainerList.JuridicalId_basis
             , tmpContainerList.InfoMoneyId
             , tmpContainerList.InfoMoneyId_Detail
        -- здесь только zc_Container_Summ
        FROM tmpContainerList
             INNER JOIN ObjectLink AS OL_AccountDirection
                                   ON OL_AccountDirection.ObjectId      = tmpContainerList.AccountId
                                  AND OL_AccountDirection.DescId        = zc_ObjectLink_Account_AccountDirection()
                                  -- на складах ГП
                                  AND OL_AccountDirection.ChildObjectId = zc_Enum_AccountDirection_20100()
        WHERE tmpContainerList.UnitId IN (zc_Unit_RK())
          -- !!!
          AND inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
       ;
     -- !!!Оптимизация!!!
     ANALYZE tmpContainerList_partion;


     -- заполняем таблицу Количество и Сумма - ост, приход, расход
       WITH -- только по этому списку - оптимизация
            tmpList AS (SELECT DISTINCT tmpContainerList.ContainerId FROM tmpContainerList WHERE tmpContainerList.ContainerId > 0
                       UNION
                        SELECT DISTINCT tmpContainerList.ContainerId_count FROM tmpContainerList -- WHERE tmpContainerList.ContainerId > 0
                       )
          , tmpContainer_zavod AS (SELECT Container.*, COALESCE (Object_Unit.Id, 0) AS UnitId
                                        , CASE WHEN 1 = 1 AND ObjectLink_Unit_HistoryCost.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isHistoryCost_ReturnIn
                                   FROM Container
                                        -- только по этому списку - оптимизация
                                        JOIN tmpList ON tmpList.ContainerId = Container.Id
                                        --
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
                                       OR (Container.DescId = zc_Container_Summ() AND Container.ParentId > 0
                                       AND Container.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                       AND Container.ObjectId <> zc_Enum_Account_110102()
                                       AND Container.ObjectId <> zc_Enum_Account_110111()
                                       AND Container.ObjectId <> zc_Enum_Account_110112()
                                       AND Container.ObjectId <> zc_Enum_Account_110121()
                                       AND Container.ObjectId <> zc_Enum_Account_110122()
                                       AND Container.ObjectId <> zc_Enum_Account_110131()
                                       AND Container.ObjectId <> zc_Enum_Account_110132()
                                         ))
                                  )
    , tmpContainer_branch AS (SELECT Container.*, COALESCE (Object_Unit.Id, 0) AS UnitId
                                   , CASE WHEN ObjectLink_Unit_HistoryCost.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isHistoryCost_ReturnIn
                              FROM Container
                                   -- только по этому списку - оптимизация
                                   JOIN tmpList ON tmpList.ContainerId = Container.Id
                                   --
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
                                  OR (Container.DescId = zc_Container_Summ() AND Container.ParentId > 0
                                  AND Container.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                    AND Container.ObjectId <> zc_Enum_Account_110102()
                                    AND Container.ObjectId <> zc_Enum_Account_110111()
                                    AND Container.ObjectId <> zc_Enum_Account_110112()
                                    AND Container.ObjectId <> zc_Enum_Account_110121()
                                    AND Container.ObjectId <> zc_Enum_Account_110122()
                                    AND Container.ObjectId <> zc_Enum_Account_110131()
                                    AND Container.ObjectId <> zc_Enum_Account_110132()
                                    ))
                             )
       -- , tmpAccount_60000 AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- Прибыль будущих периодов
      , tmpMIFloat_Summ AS (SELECT MIFloat_Summ.MovementItemId, MIFloat_Summ.DescId, MIFloat_Summ.ValueData
                            FROM MovementItem
                                 JOIN Movement ON Movement.Id = MovementItem.MovementId
                                              AND Movement.OperDate between inStartDate AND  inEndDate
                                              AND Movement.DescId  = zc_Movement_Inventory()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                             ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                            /*WHERE MovementItem.MovementId = 24210332 -- ЦЕХ упаковки - 30.12.2022
                              AND MovementItem.DescId = zc_MI_Master()*/
                              AND MovementItem.isErased = FALSE
                              -- AND inEndDate < '01.01.2023'
                           )
     -- заполняем таблицу Количество и Сумма - ост, приход, расход
     INSERT INTO _tmpMaster (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm
                           , AccountId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail, JuridicalId_basis
                           , isZavod
                            )
        SELECT CASE WHEN COALESCE (tmpContainerList_partion.ContainerId_count, tmpContainerList_partion_find.ContainerId_count) > 0
                         THEN 0
                    ELSE COALESCE (Container_Summ.ContainerId, tmpContainer.ContainerId)
               END AS ContainerId

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
               -- новая группировка для партионного учета
             , COALESCE (tmpContainerList_partion.AccountId,          CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.AccountId          ELSE 0 END) AS AccountId
             , COALESCE (tmpContainerList_partion.GoodsId,            CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.GoodsId            ELSE 0 END) AS GoodsId
             , COALESCE (tmpContainerList_partion.GoodsKindId,        CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.GoodsKindId        ELSE 0 END) AS GoodsKindId
             , COALESCE (tmpContainerList_partion.InfoMoneyId,        CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.InfoMoneyId        ELSE 0 END) AS InfoMoneyId
             , COALESCE (tmpContainerList_partion.InfoMoneyId_Detail, CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.InfoMoneyId_Detail ELSE 0 END) AS InfoMoneyId_Detail
             , COALESCE (tmpContainerList_partion.JuridicalId_basis,  CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.JuridicalId_basis  ELSE 0 END) AS JuridicalId_basis
               --
             , tmpContainer.isZavod

        FROM (SELECT Container.Id AS ContainerId
                   , Container.UnitId
                   , Container.isHistoryCost_ReturnIn
                   , Container.DescId
                   , Container.ObjectId
                     -- Start
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END AS StartSumm
                     -- Income
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount > 0*/
                                                                                                THEN MIContainer.Amount
                                                                                                WHEN MIContainer.MovementDescId IN (zc_Movement_Inventory()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod
                                                                                                     AND MIFloat_Summ.ValueData <> 0
                                                                                                THEN MIContainer.Amount
                                                                                                ELSE 0
                                                                                           END), 0) ELSE 0 END AS IncomeCount
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod /*AND MIContainer.Amount > 0*/
                                                                                                THEN MIContainer.Amount
                                                                                                WHEN MIContainer.MovementDescId IN (zc_Movement_Inventory()) AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod
                                                                                                     AND MIFloat_Summ.ValueData <> 0
                                                                                                THEN MIContainer.Amount
                                                                                                ELSE 0
                                                                                           END), 0) ELSE 0 END AS IncomeSumm
                     -- SendOnPrice
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = TRUE /*MIContainer.Amount > 0*/ THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = FALSE /*MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountOut
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.isActive = FALSE /*MIContainer.Amount < 0*/ THEN -1 * MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummOut

                     -- <> Транзит + товар в пути
                   , CASE WHEN Container.DescId = zc_Container_Count() THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceCountIn_Cost
                   , CASE WHEN Container.DescId = zc_Container_Summ()  THEN COALESCE (SUM (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110101()
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                                                                                 AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                                                                                 AND MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END AS SendOnPriceSummIn_Cost

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

                   , TRUE AS isZavod
              FROM tmpContainer_zavod AS Container
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
                   LEFT JOIN tmpMIFloat_Summ AS MIFloat_Summ
                                             ON MIFloat_Summ.MovementItemId = MIContainer.MovementItemId
                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                          --AND MIContainer.MovementId = 24210332 -- ЦЕХ упаковки - 30.12.2022

              GROUP BY Container.Id
                     , Container.UnitId
                     , Container.isHistoryCost_ReturnIn
                     , Container.DescId
                     , Container.ObjectId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount > 0 THEN      MIContainer.Amount ELSE 0 END), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) <> 0)
                  OR (COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod AND MIFloat_Summ.ValueData <> 0 AND MIContainer.MovementDescId IN (zc_Movement_Inventory()) THEN MIFloat_Summ.ValueData ELSE 0 END), 0) <> 0)

             UNION ALL
              SELECT Container.Id     AS ContainerId
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
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MLO_From.ObjectId                  = 8411    -- Склад ГП ф.Киев"
                                          AND MLO_To.ObjectId                    = 3080691 -- Склад ГП ф.Львов"
                                        --AND MIContainer.WhereObjectId_Analyzer = 3080691 -- Склад ГП ф.Львов"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 8411    -- Склад ГП ф.Киев"
                                          AND inBranchId                         = 3080683 -- филиал Львов
                                        -- AND MovementBoolean_HistoryCost.ValueData = TRUE
                                        --AND MIContainer.isActive               = TRUE
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MIContainer.WhereObjectId_Analyzer = 8411    -- Склад ГП ф.Киев"
                                          AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- Склад ГП ф.Львов"
                                          AND inBranchId                         = 8379    -- филиал Киев
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN 0
                                         WHEN MIContainer.WhereObjectId_Analyzer = 3080691 -- Склад ГП ф.Львов"
                                          AND MIContainer.ObjectExtId_Analyzer   = 8411    -- Склад ГП ф.Киев"
                                          AND inBranchId                         = 3080683 -- филиал Львов
                                          AND MIContainer.AccountId <> zc_Enum_Account_110101()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                          AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN 0

                                         WHEN 1=1
                                         THEN COALESCE (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110101()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                                              AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END, 0)
                                         ELSE COALESCE (CASE WHEN MovementBoolean_HistoryCost.ValueData = TRUE
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110101()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                                              AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                                              AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END, 0)
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

                   , FALSE AS isZavod
              FROM tmpContainer_branch AS Container
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

             -- нашли партию если кол-во
             LEFT JOIN tmpContainerList_partion ON tmpContainerList_partion.ContainerId_count = tmpContainer.ContainerId
                                               AND tmpContainer.DescId                        = zc_Container_Count()
             -- нашли подстановку для кол-во - Container_Summ.Id
             LEFT JOIN tmpContainerList AS Container_Summ ON Container_Summ.ContainerId_count = tmpContainer.ContainerId
                                                         AND tmpContainer.DescId              = zc_Container_Count()
                                                         -- !!!
                                                         AND Container_Summ.ContainerId > 0
                                                         -- !!!
                                                         AND tmpContainerList_partion.ContainerId_count IS NULL

             -- если это zc_Container_Summ
             LEFT JOIN tmpContainerList AS Container_Summ_find ON Container_Summ_find.ContainerId = tmpContainer.ContainerId
                                                              AND tmpContainer.DescId             = zc_Container_Summ()
             -- проверка - нужна ли партия для zc_Container_Summ
             LEFT JOIN (SELECT DISTINCT tmpContainerList_partion.ContainerId_count FROM tmpContainerList_partion
                       ) AS tmpContainerList_partion_find
                         ON tmpContainerList_partion_find.ContainerId_count = Container_Summ_find.ContainerId_count

             /*LEFT JOIN Container AS Container_Summ
                                 ON Container_Summ.ParentId = tmpContainer.ContainerId
                                AND Container_Summ.DescId = zc_Container_Summ()
                                AND Container_Summ.ObjectId <> zc_Enum_Account_20901() -- "Оборотная тара"
                                AND tmpContainer.DescId = zc_Container_Count()*/

             /*LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                           ON ContainerLinkObject_Business.ContainerId = tmpContainer.ContainerId
                                          AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                                          AND tmpContainer.DescId = zc_Container_Count()*/
             /*LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId = tmpContainer.ObjectId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = COALESCE (ContainerLinkObject_JuridicalBasis.ObjectId, 0)
                                                                                 AND lfContainerSumm_20901.BusinessId = COALESCE (ContainerLinkObject_Business.ObjectId, 0)
                                                                                 AND tmpContainer.DescId = zc_Container_Count()*/

             /*LEFT JOIN ContainerObjectCost ON ContainerObjectCost.ObjectCostId = COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, tmpContainer.ContainerId))
                                          AND ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis()*/

             -- LEFT JOIN tmpAccount_60000 ON tmpAccount_60000.AccountId = COALESCE (Container_Summ.ObjectId, tmpContainer.ObjectId)
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                           ON ContainerLinkObject_InfoMoney.ContainerId = COALESCE (Container_Summ.ContainerId, tmpContainer.ContainerId)
                                          AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = COALESCE (Container_Summ.ContainerId, tmpContainer.ContainerId)
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()

        -- GROUP BY COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, tmpContainer.ContainerId)) -- ContainerObjectCost.ObjectCostId
        GROUP BY CASE WHEN COALESCE (tmpContainerList_partion.ContainerId_count, tmpContainerList_partion_find.ContainerId_count) > 0
                           THEN 0
                      ELSE COALESCE (Container_Summ.ContainerId, tmpContainer.ContainerId)
                 END
               , tmpContainer.UnitId
               , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           THEN TRUE
                      ELSE FALSE
                 END
                 -- новая группировка для партионного учета
               , COALESCE (tmpContainerList_partion.AccountId,          CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.AccountId          ELSE 0 END)
               , COALESCE (tmpContainerList_partion.GoodsId,            CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.GoodsId            ELSE 0 END)
               , COALESCE (tmpContainerList_partion.GoodsKindId,        CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.GoodsKindId        ELSE 0 END)
               , COALESCE (tmpContainerList_partion.InfoMoneyId,        CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.InfoMoneyId        ELSE 0 END)
               , COALESCE (tmpContainerList_partion.InfoMoneyId_Detail, CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.InfoMoneyId_Detail ELSE 0 END)
               , COALESCE (tmpContainerList_partion.JuridicalId_basis,  CASE WHEN tmpContainerList_partion_find.ContainerId_count > 0 THEN Container_Summ_find.JuridicalId_basis  ELSE 0 END)
                 --
               , tmpContainer.isZavod
       ;

-- INSERT INTO _tmpMaster (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
--    RAISE EXCEPTION 'Ошибка.<%>', (select _tmpMaster.IncomeCount from _tmpMaster where _tmpMaster.ContainerId = 156902)
--    , (select _tmpMaster.IncomeSumm from _tmpMaster where _tmpMaster.ContainerId = 156902)
--    ;


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

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3502863); -- 04.2021

     --DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3324068, 3323606, 3325351, 2350884, 2349571, 2354329, 2350886, 2354546, 2349569, -- 07.2021
     -- 159538, 256304, 159542, 539314, 158860, 539309, 256017, 539308, 158859, 159537, 539307, 159539, 158864, 539315, 158861, 3617386, 449444, 539312, 467021);

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (926000, 924971); -- 03.2022

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (548224, 530876); -- 04.2022

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (SELECT Container.Id FROM Container WHERE Container.ParentId = 3112320); -- 07.2022


RAISE INFO 'end master CLOCK_TIMESTAMP  .<%>', CLOCK_TIMESTAMP();

     IF inBranchId = 0 OR vbIsBranch_Itearation = TRUE -- OR 1 = 1
     THEN
         -- !!!1.1. Оптимизация!!!
         CREATE TEMP TABLE tmpMIContainer_Summ_Out ON COMMIT DROP
           AS (SELECT DISTINCT
                      MIContainer_Summ_Out.Id, MIContainer_Summ_Out.MovementId, MIContainer_Summ_Out.MovementItemId
                    , MIContainer_Summ_Out.ParentId, MIContainer_Summ_Out.ContainerId
                      -- есть всегда
                    , _tmpMaster.AccountId
                    , _tmpMaster.UnitId
                    , _tmpMaster.GoodsId
                    , _tmpMaster.GoodsKindId
                    , _tmpMaster.JuridicalId_basis
                    , _tmpMaster.InfoMoneyId
                    , _tmpMaster.InfoMoneyId_Detail

               FROM tmpContainerList AS _tmpMaster
                    INNER JOIN MovementItemContainer AS MIContainer_Summ_Out
                                                     ON MIContainer_Summ_Out.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer_Summ_Out.ContainerId = _tmpMaster.ContainerId
                                                    AND MIContainer_Summ_Out.DescId      = zc_MIContainer_Summ()
                                                    AND MIContainer_Summ_Out.isActive    = FALSE
                                                    AND MIContainer_Summ_Out.ParentId    > 0
                                                    AND MIContainer_Summ_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND COALESCE (MIContainer_Summ_Out.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss()
               -- !!!
               WHERE _tmpMaster.ContainerId > 0
              );
         -- !!!Оптимизация!!!
         ANALYZE tmpMIContainer_Summ_Out;

         -- !!!1.2. Оптимизация!!!
         CREATE TEMP TABLE tmpMIContainer_Summ_In ON COMMIT DROP
           AS (WITH tmp AS (SELECT DISTINCT MIContainer_Summ_Out.ParentId FROM tmpMIContainer_Summ_Out AS MIContainer_Summ_Out)
                  , tmpContainer_master AS (SELECT tmpContainerList.ContainerId
                                                   -- есть всегда
                                                 , tmpContainerList.AccountId
                                                 , tmpContainerList.UnitId
                                                 , tmpContainerList.GoodsId
                                                 , tmpContainerList.GoodsKindId
                                                 , tmpContainerList.JuridicalId_basis
                                                 , tmpContainerList.InfoMoneyId
                                                 , tmpContainerList.InfoMoneyId_Detail
                                            FROM tmpContainerList
                                            -- не фИЛИАЛ + или надо для фИЛИАЛА
                                            WHERE (tmpContainerList.isZavod = TRUE OR vbIsBranch_Itearation = TRUE)
                                              -- !!!
                                              AND tmpContainerList.ContainerId > 0
                                           )
                  , MIContainer_Summ_In AS (SELECT MIContainer_Summ_In.Id, tmp.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                                                 , SUM (MIContainer_Summ_In.Amount) AS Amount
                                            FROM tmp
                                                 INNER JOIN MovementItemContainer AS MIContainer_Summ_In ON MIContainer_Summ_In.Id = tmp.ParentId
                                            GROUP BY MIContainer_Summ_In.Id, tmp.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                                           )
               --
               SELECT MIContainer_Summ_In.Id, MIContainer_Summ_In.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                    , MIContainer_Summ_In.Amount
                      -- есть всегда
                    , tmpContainer_master.AccountId
                    , tmpContainer_master.UnitId
                    , tmpContainer_master.GoodsId
                    , tmpContainer_master.GoodsKindId
                    , tmpContainer_master.JuridicalId_basis
                    , tmpContainer_master.InfoMoneyId
                    , tmpContainer_master.InfoMoneyId_Detail

               FROM MIContainer_Summ_In
                    INNER JOIN tmpContainer_master ON tmpContainer_master.ContainerId = MIContainer_Summ_In.ContainerId
              );
         -- !!!Оптимизация!!!
         ANALYZE tmpMIContainer_Summ_In;

         -- !!!1.3. Оптимизация!!!
         CREATE TEMP TABLE tmpContainer_count ON COMMIT DROP
           AS (SELECT Container.Id AS ContainerId
                      -- есть НЕ всегда
                    , tmpContainerList_partion.AccountId
                    , tmpContainerList_partion.UnitId
                    , tmpContainerList_partion.GoodsId
                    , tmpContainerList_partion.GoodsKindId
                    , tmpContainerList_partion.JuridicalId_basis
                    , tmpContainerList_partion.InfoMoneyId
                    , tmpContainerList_partion.InfoMoneyId_Detail
                      --
                    , tmpContainerList_partion.ContainerId_count
               --FROM Container
               -- только по этому списку - оптимизация
               FROM (SELECT DISTINCT tmpContainerList.ContainerId_count AS Id
                     FROM tmpContainerList
                     -- не фИЛИАЛ + или надо для фИЛИАЛА
                     WHERE (tmpContainerList.isZavod = TRUE OR vbIsBranch_Itearation = TRUE)
                       AND tmpContainerList.ContainerId > 0
                    ) AS Container
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                  ON ContainerLinkObject_Account.ContainerId = Container.Id
                                                 AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                    LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container.Id
                    --
                    LEFT JOIN tmpContainerList_partion ON tmpContainerList_partion.ContainerId_count = Container.Id

               --WHERE Container.DescId = zc_Container_Count() AND
               WHERE ContainerLinkObject_Account.ContainerId IS NULL
                 -- не фИЛИАЛ + или надо для фИЛИАЛА
                 AND (_tmpContainer_branch.ContainerId IS NULL OR vbIsBranch_Itearation = TRUE)
              );
         -- !!!Оптимизация!!!
         ANALYZE tmpContainer_count;

         -- !!!1.4. Оптимизация!!!
         CREATE TEMP TABLE MIContainer_Count_In  ON COMMIT DROP
           AS (SELECT MIContainer_Count_In.Id, MIContainer_Count_In.MovementItemId, MIContainer_Count_In.MovementId, MIContainer_Count_In.MovementDescId, MIContainer_Count_In.ContainerId, MIContainer_Count_In.WhereObjectId_Analyzer
                    , SUM (MIContainer_Count_In.Amount) AS Amount
                      -- есть НЕ всегда
                    , tmpContainer_count.AccountId
                    , tmpContainer_count.UnitId
                    , tmpContainer_count.GoodsId
                    , tmpContainer_count.GoodsKindId
                    , tmpContainer_count.JuridicalId_basis
                    , tmpContainer_count.InfoMoneyId
                    , tmpContainer_count.InfoMoneyId_Detail
                      --
                    , tmpContainer_count.ContainerId_count
               FROM tmpContainer_count
                    INNER JOIN MovementItemContainer AS MIContainer_Count_In
                                                     ON MIContainer_Count_In.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer_Count_In.ContainerId  = tmpContainer_count.ContainerId
                                                    AND MIContainer_Count_In.DescId       = zc_MIContainer_Count()
                                                    AND MIContainer_Count_In.isActive     = TRUE
                                                    AND MIContainer_Count_In.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
               GROUP BY MIContainer_Count_In.Id, MIContainer_Count_In.MovementItemId, MIContainer_Count_In.MovementId, MIContainer_Count_In.MovementDescId, MIContainer_Count_In.ContainerId, MIContainer_Count_In.WhereObjectId_Analyzer
                        -- есть НЕ всегда
                      , tmpContainer_count.AccountId
                      , tmpContainer_count.UnitId
                      , tmpContainer_count.GoodsId
                      , tmpContainer_count.GoodsKindId
                      , tmpContainer_count.JuridicalId_basis
                      , tmpContainer_count.InfoMoneyId
                      , tmpContainer_count.InfoMoneyId_Detail
                        --
                      , tmpContainer_count.ContainerId_count
              );
         -- !!!Оптимизация!!!
         ANALYZE MIContainer_Count_In;


RAISE INFO 'start MIContainer_Count_Out CLOCK_TIMESTAMP  .<%>', CLOCK_TIMESTAMP();

         CREATE TEMP TABLE MIContainer_Count_Out  ON COMMIT DROP
            AS (SELECT MIContainer_Count_Out.Id, MIContainer_Count_Out.ParentId, MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer
                     , SUM (MIContainer_Count_Out.Amount) AS Amount
                       -- есть НЕ всегда
                     , tmpContainer_count.AccountId
                     , tmpContainer_count.UnitId
                     , tmpContainer_count.GoodsId
                     , tmpContainer_count.GoodsKindId
                     , tmpContainer_count.JuridicalId_basis
                     , tmpContainer_count.InfoMoneyId
                     , tmpContainer_count.InfoMoneyId_Detail
                       --
                     , tmpContainer_count.ContainerId_count
                FROM tmpContainer_count
                     INNER JOIN MovementItemContainer AS MIContainer_Count_Out
                                                      ON MIContainer_Count_Out.OperDate BETWEEN inStartDate AND inEndDate
                                                     AND MIContainer_Count_Out.ContainerId = tmpContainer_count.ContainerId
                                                     AND MIContainer_Count_Out.DescId      = zc_MIContainer_Count()
                                                     AND MIContainer_Count_Out.isActive    = FALSE
                                                     AND MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                GROUP BY MIContainer_Count_Out.Id, MIContainer_Count_Out.ParentId, MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer
                         --
                       , tmpContainer_count.AccountId
                       , tmpContainer_count.UnitId
                       , tmpContainer_count.GoodsId
                       , tmpContainer_count.GoodsKindId
                       , tmpContainer_count.JuridicalId_basis
                       , tmpContainer_count.InfoMoneyId
                       , tmpContainer_count.InfoMoneyId_Detail
                         --
                       , tmpContainer_count.ContainerId_count
               );
         -- !!!Оптимизация!!!
         ANALYZE MIContainer_Count_Out;

RAISE INFO 'start res_1 CLOCK_TIMESTAMP  .<%>', CLOCK_TIMESTAMP();
         CREATE TEMP TABLE res_1 ON COMMIT DROP
                               AS (SELECT MIContainer_Count_Out.MovementDescId
                                        , MIContainer_Count_Out.MovementId
                                          -- !!!Ключ!!!
                                        , CASE WHEN MIContainer_Count_Out.MovementDescId = zc_Movement_ProductionUnion()
                                                    THEN MovementItem.ParentId
                                               ELSE MIContainer_Count_Out.MovementItemId
                                          END AS MovementItemId
                                        , MIContainer_Count_Out.WhereObjectId_Analyzer
                                          -- !!!в этом разница
                                        , CASE WHEN MIContainer_Count_Out.MovementDescId = zc_Movement_Send()
                                                    THEN MIContainer_Count_Out.ParentId
                                               ELSE 0
                                          END AS ParentId
                                          -- !!! для zc_Movement_Send - не понадобится
                                        , SUM (MIContainer_Count_Out.Amount) AS Amount
                                          -- есть всегда, т.к. это для партий
                                        , MIContainer_Count_Out.AccountId
                                        , MIContainer_Count_Out.UnitId
                                        , MIContainer_Count_Out.GoodsId
                                        , MIContainer_Count_Out.GoodsKindId
                                        , MIContainer_Count_Out.JuridicalId_basis
                                        , MIContainer_Count_Out.InfoMoneyId
                                        , MIContainer_Count_Out.InfoMoneyId_Detail

                                   FROM MIContainer_Count_Out
                                        LEFT JOIN MovementItem ON MovementItem.Id = MIContainer_Count_Out.MovementItemId
                                                              AND MIContainer_Count_Out.MovementDescId IN (zc_Movement_ProductionUnion())
                                        -- ДА - партии в расходе
                                   WHERE MIContainer_Count_Out.ContainerId_count > 0

                                   GROUP BY MIContainer_Count_Out.MovementDescId
                                          , MIContainer_Count_Out.MovementId
                                          , CASE WHEN MIContainer_Count_Out.MovementDescId = zc_Movement_ProductionUnion()
                                                      THEN MovementItem.ParentId
                                                 ELSE MIContainer_Count_Out.MovementItemId
                                            END
                                          , MIContainer_Count_Out.WhereObjectId_Analyzer
                                            -- !!!
                                          , CASE WHEN MIContainer_Count_Out.MovementDescId = zc_Movement_Send()
                                                      THEN MIContainer_Count_Out.ParentId
                                                 ELSE 0
                                            END
                                            -- есть НЕ всегда
                                          , MIContainer_Count_Out.AccountId
                                          , MIContainer_Count_Out.UnitId
                                          , MIContainer_Count_Out.GoodsId
                                          , MIContainer_Count_Out.GoodsKindId
                                          , MIContainer_Count_Out.JuridicalId_basis
                                          , MIContainer_Count_Out.InfoMoneyId
                                          , MIContainer_Count_Out.InfoMoneyId_Detail
                                            --
                                          , MIContainer_Count_Out.ContainerId_count
                                  );
         -- !!!Оптимизация!!!
         ANALYZE res_1;


RAISE INFO 'start res_2 CLOCK_TIMESTAMP  .<%>', CLOCK_TIMESTAMP();
         CREATE TEMP TABLE res_2 ON COMMIT DROP
                                    AS (SELECT MIContainer_Count_In.MovementId
                                             , MIContainer_Count_In.MovementItemId
                                             , MIContainer_Count_In.WhereObjectId_Analyzer
                                             , MIContainer_Count_In.MovementDescId
                                               -- !!!в этом разница
                                             , CASE WHEN MIContainer_Count_In.MovementDescId = zc_Movement_Send()
                                                         THEN MIContainer_Count_In.Id
                                                    ELSE 0
                                               END AS Id
                                               -- подставится из прихода
                                             , SUM (MIContainer_Count_In.Amount) AS Amount
                                               -- есть НЕ всегда
                                             , MIContainer_Count_In.AccountId
                                             , MIContainer_Count_In.UnitId
                                             , MIContainer_Count_In.GoodsId
                                             , MIContainer_Count_In.GoodsKindId
                                             , MIContainer_Count_In.JuridicalId_basis
                                             , MIContainer_Count_In.InfoMoneyId
                                             , MIContainer_Count_In.InfoMoneyId_Detail
                                               --
                                             , MIContainer_Count_In.ContainerId_count
                                        FROM MIContainer_Count_In
                                        -- ДА - партии в приходе
                                        WHERE MIContainer_Count_In.ContainerId_count > 0
                                        -- !!! в этом разница !!!
                                        -- WHERE MIContainer_Count_In.MovementDescId = zc_Movement_Send()
                                        GROUP BY MIContainer_Count_In.MovementId
                                               , MIContainer_Count_In.MovementItemId
                                               , MIContainer_Count_In.WhereObjectId_Analyzer
                                               , MIContainer_Count_In.MovementDescId
                                                 -- !!! в этом разница !!!
                                               , CASE WHEN MIContainer_Count_In.MovementDescId = zc_Movement_Send()
                                                           THEN MIContainer_Count_In.Id
                                                      ELSE 0
                                                 END
                                                 -- есть НЕ всегда
                                               , MIContainer_Count_In.AccountId
                                               , MIContainer_Count_In.UnitId
                                               , MIContainer_Count_In.GoodsId
                                               , MIContainer_Count_In.GoodsKindId
                                               , MIContainer_Count_In.JuridicalId_basis
                                               , MIContainer_Count_In.InfoMoneyId
                                               , MIContainer_Count_In.InfoMoneyId_Detail
                                                 --
                                               , MIContainer_Count_In.ContainerId_count
                                       );
         -- !!!Оптимизация!!!
         ANALYZE res_2;


RAISE INFO 'count res_1 = <%> res_2 = <%> CLOCK_TIMESTAMP = <%>'
    , (select count(*) from res_1)
    , (select count(*) from res_2)
    , CLOCK_TIMESTAMP()
    ;

RAISE INFO 'start _tmpChild CLOCK_TIMESTAMP  .<%>', CLOCK_TIMESTAMP();

         -- расходы в Child для Master
         INSERT INTO _tmpChild (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount, isExternal, DescId
                              , AccountId, UnitId, GoodsId, GoodsKindId, JuridicalId_basis, InfoMoneyId, InfoMoneyId_Detail
                              , AccountId_master, UnitId_master, GoodsId_master, GoodsKindId_master, JuridicalId_basis_master, InfoMoneyId_master, InfoMoneyId_Detail_master
                               )
            WITH MIContainer_Summ_Out AS (SELECT DISTINCT /*tmpMIContainer_Summ_Out.Id, */
                                                 tmpMIContainer_Summ_Out.MovementId, tmpMIContainer_Summ_Out.MovementItemId
                                               , tmpMIContainer_Summ_Out.ParentId, tmpMIContainer_Summ_Out.ContainerId
                                                 -- есть всегда
                                               , tmpMIContainer_Summ_Out.AccountId
                                               , tmpMIContainer_Summ_Out.UnitId
                                               , tmpMIContainer_Summ_Out.GoodsId
                                               , tmpMIContainer_Summ_Out.GoodsKindId
                                               , tmpMIContainer_Summ_Out.JuridicalId_basis
                                               , tmpMIContainer_Summ_Out.InfoMoneyId
                                               , tmpMIContainer_Summ_Out.InfoMoneyId_Detail
                                               --
                                               -- , tmpMIContainer_Summ_Out.ContainerId_count
                                          FROM tmpMIContainer_Summ_Out
                                         )
                , MIContainer_Summ_In AS (SELECT tmpMIContainer_Summ_In.Id, tmpMIContainer_Summ_In.ParentId, tmpMIContainer_Summ_In.MovementId, tmpMIContainer_Summ_In.ContainerId, tmpMIContainer_Summ_In.MovementItemId, tmpMIContainer_Summ_In.WhereObjectId_Analyzer, tmpMIContainer_Summ_In.Amount
                                                 -- есть всегда
                                               , tmpMIContainer_Summ_In.AccountId
                                               , tmpMIContainer_Summ_In.UnitId
                                               , tmpMIContainer_Summ_In.GoodsId
                                               , tmpMIContainer_Summ_In.GoodsKindId
                                               , tmpMIContainer_Summ_In.JuridicalId_basis
                                               , tmpMIContainer_Summ_In.InfoMoneyId
                                               , tmpMIContainer_Summ_In.InfoMoneyId_Detail
                                               --
                                               --, tmpMIContainer_Summ_In.ContainerId_count
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
                , MIContainer_Count_Out_SendOnPrice
                             AS (SELECT MIContainer_Count_Out.ParentId, MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate
                                      , MIContainer_Count_Out.MovementItemId
                                        -- в этом разница
                                      , MAX (MIContainer_Count_Out.ContainerId) AS ContainerId
                                        --
                                      , MIContainer_Count_Out.WhereObjectId_Analyzer
                                        -- в этом разница
                                      , SUM (MIContainer_Count_Out.Amount) AS Amount
                                        -- есть НЕ всегда
                                      , MIContainer_Count_Out.AccountId
                                      , MIContainer_Count_Out.UnitId
                                      , MIContainer_Count_Out.GoodsId
                                      , MIContainer_Count_Out.GoodsKindId
                                      , MIContainer_Count_Out.JuridicalId_basis
                                      , MIContainer_Count_Out.InfoMoneyId
                                      , MIContainer_Count_Out.InfoMoneyId_Detail
                                        -- в этом разница
                                      , MAX (MIContainer_Count_Out.ContainerId_count) AS ContainerId_count
                                 FROM MIContainer_Count_Out
                                 -- в этом разница
                                 WHERE MIContainer_Count_Out.MovementDescId = zc_Movement_SendOnPrice()
                                 --
                                 GROUP BY MIContainer_Count_Out.ParentId, MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate
                                        , MIContainer_Count_Out.MovementItemId
                                        , MIContainer_Count_Out.WhereObjectId_Analyzer
                                          -- есть НЕ всегда
                                        , MIContainer_Count_Out.AccountId
                                        , MIContainer_Count_Out.UnitId
                                        , MIContainer_Count_Out.GoodsId
                                        , MIContainer_Count_Out.GoodsKindId
                                        , MIContainer_Count_Out.JuridicalId_basis
                                        , MIContainer_Count_Out.InfoMoneyId
                                        , MIContainer_Count_Out.InfoMoneyId_Detail
                                )

                , tmpRes AS (-- 1.1. = zc_Movement_Send
                             SELECT CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                              -- нет партий в приходе
                                              THEN COALESCE (MIContainer_Summ_In.ContainerId, 0)
                                         ELSE 0
                                    END AS MasterContainerId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                              -- нет партий в расходе
                                              THEN COALESCE (MIContainer_Summ_Out.ContainerId, 0)
                                         ELSE 0
                                    END AS ContainerId

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                              -- нет партий в приходе
                                              THEN COALESCE (MIContainer_Count_In.ContainerId, 0)
                                         ELSE 0
                                    END AS MasterContainerId_Count

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                              -- нет партий в расходе
                                              THEN COALESCE (MIContainer_Count_Out.ContainerId, 0)
                                         ELSE 0
                                    END AS ContainerId_Count

                                  , SUM (CASE WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                                                  THEN COALESCE (1 * MIContainer_Count_In.Amount, 0)
                                              WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_ProductionUnion())
                                                  THEN COALESCE (-1 * MIContainer_Count_Out.Amount, 0)
                                              ELSE 0
                                         END) AS OperCount

                                  , CASE WHEN MIContainer_Count_Out.WhereObjectId_Analyzer = MIContainer_Summ_In.WhereObjectId_Analyzer THEN FALSE ELSE TRUE END AS isExternal
                                  , 0 AS MovementDescId
                               -- , MIContainer_Count_Out.MovementDescId

                                    --
                                    -- расход
                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.AccountId
                                         ELSE 0
                                    END AS AccountId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.UnitId
                                         ELSE 0
                                    END AS UnitId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.GoodsId
                                         ELSE 0
                                    END AS GoodsId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.GoodsKindId
                                         ELSE 0
                                    END AS GoodsKindId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.JuridicalId_basis
                                         ELSE 0
                                    END AS JuridicalId_basis

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.InfoMoneyId
                                         ELSE 0
                                    END AS InfoMoneyId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.InfoMoneyId_Detail
                                         ELSE 0
                                    END AS InfoMoneyId_Detail

                                    --
                                    -- приход
                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.AccountId
                                         ELSE 0
                                    END AS AccountId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.UnitId
                                         ELSE 0
                                    END AS UnitId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.GoodsId
                                         ELSE 0
                                    END AS GoodsId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.GoodsKindId
                                         ELSE 0
                                    END AS GoodsKindId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.JuridicalId_basis
                                         ELSE 0
                                    END AS JuridicalId_basis_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.InfoMoneyId
                                         ELSE 0
                                    END AS InfoMoneyId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.InfoMoneyId_Detail
                                         ELSE 0
                                    END AS InfoMoneyId_Detail_master

                             FROM MIContainer_Count_Out
                                  -- партии в расходе
                                  --LEFT JOIN tmpContainerList_partion ON tmpContainerList_partion.ContainerId_count = MIContainer_Count_Out.ContainerId

                                  JOIN MIContainer_Summ_Out ON MIContainer_Summ_Out.MovementId          = MIContainer_Count_Out.MovementId
                                                           AND MIContainer_Summ_Out.MovementItemId      = MIContainer_Count_Out.MovementItemId
                                                           AND (MIContainer_Summ_Out.InfoMoneyId_Detail = MIContainer_Count_Out.InfoMoneyId_Detail
                                                             OR MIContainer_Count_Out.ContainerId_count IS NULL
                                                               )
                                  -- лишняя проверка???
                                  JOIN Container AS Container_Summ_Out ON Container_Summ_Out.Id       = MIContainer_Summ_Out.ContainerId
                                                                      AND Container_Summ_Out.ParentId = MIContainer_Count_Out.ContainerId

                                  JOIN MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
                                  JOIN Container AS Container_Summ_In ON Container_Summ_In.Id       = MIContainer_Summ_In.ContainerId

                                  JOIN MIContainer_Count_In ON MIContainer_Count_In.MovementItemId      = MIContainer_Summ_In.MovementItemId
                                                           AND MIContainer_Count_In.ContainerId         = Container_Summ_In.ParentId
                                                           AND (MIContainer_Count_In.InfoMoneyId_Detail = MIContainer_Summ_In.InfoMoneyId_Detail
                                                             OR MIContainer_Count_In.ContainerId_count  IS NULL
                                                               )
                                                           -- !!! в этом разница !!!
                                                           AND MIContainer_Count_In.Id             = MIContainer_Count_Out.ParentId
                                  -- партии в приходе
                                  -- LEFT JOIN tmpContainerList_partion AS tmpContainerList_partion_master ON tmpContainerList_partion_master.ContainerId_count = MIContainer_Count_In.ContainerId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                               ON MovementLinkObject_User.MovementId = MIContainer_Count_Out.MovementId
                                                              AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                                              AND MovementLinkObject_User.ObjectId   = zc_Enum_Process_Auto_Defroster()

                             WHERE MovementLinkObject_User.MovementId IS NULL
                               -- !!! в этом разница !!!
                               AND MIContainer_Count_Out.MovementDescId = zc_Movement_Send()
                                    -- нет партий в расходе
                               AND (MIContainer_Count_Out.ContainerId_count IS NULL
                                    -- нет партий в приходе
                                 OR MIContainer_Count_In.ContainerId_count IS NULL
                                   )
                             GROUP BY CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                               -- нет партий в приходе
                                               THEN COALESCE (MIContainer_Summ_In.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                               -- нет партий в расходе
                                               THEN COALESCE (MIContainer_Summ_Out.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                               -- нет партий в приходе
                                               THEN COALESCE (MIContainer_Count_In.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                               -- нет партий в расходе
                                               THEN COALESCE (MIContainer_Count_Out.ContainerId, 0)
                                          ELSE 0
                                     END

                                    , MIContainer_Count_Out.WhereObjectId_Analyzer
                                    , MIContainer_Summ_In.WhereObjectId_Analyzer
                                    -- , MIContainer_Count_Out.MovementDescId

                                     --
                                     -- расход
                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.AccountId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.UnitId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.GoodsId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.GoodsKindId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.JuridicalId_basis
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.InfoMoneyId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.InfoMoneyId_Detail
                                          ELSE 0
                                     END

                                     --
                                     -- приход
                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.AccountId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.UnitId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.GoodsId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.GoodsKindId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.JuridicalId_basis
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.InfoMoneyId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.InfoMoneyId_Detail
                                          ELSE 0
                                     END

                            UNION ALL
                             -- 1.2. = zc_Movement_SendOnPrice
                             SELECT CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                              -- нет партий в приходе
                                              THEN COALESCE (MIContainer_Summ_In.ContainerId, 0)
                                         ELSE 0
                                    END AS MasterContainerId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                              -- нет партий в расходе
                                              THEN COALESCE (MIContainer_Summ_Out.ContainerId, 0)
                                         ELSE 0
                                    END AS ContainerId

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                              -- нет партий в приходе
                                              THEN COALESCE (MIContainer_Count_In.ContainerId, 0)
                                         ELSE 0
                                    END AS MasterContainerId_Count

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                              -- нет партий в расходе
                                              THEN COALESCE (MIContainer_Count_Out.ContainerId, 0)
                                         ELSE 0
                                    END AS ContainerId_Count

                                  , SUM (CASE WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                                                  THEN COALESCE (1 * MIContainer_Count_In.Amount, 0)
                                              WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_ProductionUnion())
                                                  THEN COALESCE (-1 * MIContainer_Count_Out.Amount, 0)
                                              ELSE 0
                                         END) AS OperCount

                                  , CASE WHEN MIContainer_Count_Out.WhereObjectId_Analyzer = MIContainer_Summ_In.WhereObjectId_Analyzer THEN FALSE ELSE TRUE END AS isExternal
                                  , 0 AS MovementDescId
                               -- , MIContainer_Count_Out.MovementDescId

                                    --
                                    -- расход
                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.AccountId
                                         ELSE 0
                                    END AS AccountId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.UnitId
                                         ELSE 0
                                    END AS UnitId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.GoodsId
                                         ELSE 0
                                    END AS GoodsId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.GoodsKindId
                                         ELSE 0
                                    END AS GoodsKindId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.JuridicalId_basis
                                         ELSE 0
                                    END AS JuridicalId_basis

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.InfoMoneyId
                                         ELSE 0
                                    END AS InfoMoneyId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.InfoMoneyId_Detail
                                         ELSE 0
                                    END AS InfoMoneyId_Detail

                                    --
                                    -- приход
                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.AccountId
                                         ELSE 0
                                    END AS AccountId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.UnitId
                                         ELSE 0
                                    END AS UnitId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.GoodsId
                                         ELSE 0
                                    END AS GoodsId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.GoodsKindId
                                         ELSE 0
                                    END AS GoodsKindId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.JuridicalId_basis
                                         ELSE 0
                                    END AS JuridicalId_basis_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.InfoMoneyId
                                         ELSE 0
                                    END AS InfoMoneyId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.InfoMoneyId_Detail
                                         ELSE 0
                                    END AS InfoMoneyId_Detail_master

                             -- !!! в этом разница !!!
                             FROM MIContainer_Count_Out_SendOnPrice AS MIContainer_Count_Out
                                  -- партии в расходе
                                  --LEFT JOIN tmpContainerList_partion ON tmpContainerList_partion.ContainerId_count = MIContainer_Count_Out.ContainerId

                                  JOIN MIContainer_Summ_Out ON MIContainer_Summ_Out.MovementId          = MIContainer_Count_Out.MovementId
                                                           AND MIContainer_Summ_Out.MovementItemId      = MIContainer_Count_Out.MovementItemId
                                                           AND (MIContainer_Summ_Out.InfoMoneyId_Detail = MIContainer_Count_Out.InfoMoneyId_Detail
                                                             OR MIContainer_Count_Out.ContainerId_count IS NULL
                                                               )
                                  -- лишняя проверка???
                                  JOIN Container AS Container_Summ_Out ON Container_Summ_Out.Id       = MIContainer_Summ_Out.ContainerId
                                                                      AND Container_Summ_Out.ParentId = MIContainer_Count_Out.ContainerId

                                  JOIN MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
                                  JOIN Container AS Container_Summ_In ON Container_Summ_In.Id       = MIContainer_Summ_In.ContainerId

                                  JOIN MIContainer_Count_In ON MIContainer_Count_In.MovementItemId      = MIContainer_Summ_In.MovementItemId
                                                           AND MIContainer_Count_In.ContainerId         = Container_Summ_In.ParentId
                                                           AND (MIContainer_Count_In.InfoMoneyId_Detail = MIContainer_Summ_In.InfoMoneyId_Detail
                                                             OR MIContainer_Count_In.ContainerId_count  IS NULL
                                                               )
                                                           -- !!! в этом разница !!!
                                                           AND MIContainer_Count_In.Id             = MIContainer_Count_Out.ParentId
                                  -- партии в приходе
                                  -- LEFT JOIN tmpContainerList_partion AS tmpContainerList_partion_master ON tmpContainerList_partion_master.ContainerId_count = MIContainer_Count_In.ContainerId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                               ON MovementLinkObject_User.MovementId = MIContainer_Count_Out.MovementId
                                                              AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                                              AND MovementLinkObject_User.ObjectId   = zc_Enum_Process_Auto_Defroster()

                             WHERE MovementLinkObject_User.MovementId IS NULL
                               -- !!! в этом разница !!!
                               AND MIContainer_Count_Out.MovementDescId = zc_Movement_SendOnPrice()
                                    -- нет партий в расходе
                               AND (MIContainer_Count_Out.ContainerId_count IS NULL
                                    -- нет партий в приходе
                                 OR MIContainer_Count_In.ContainerId_count IS NULL
                                   )
                             GROUP BY CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                               -- нет партий в приходе
                                               THEN COALESCE (MIContainer_Summ_In.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                               -- нет партий в расходе
                                               THEN COALESCE (MIContainer_Summ_Out.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                               -- нет партий в приходе
                                               THEN COALESCE (MIContainer_Count_In.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                               -- нет партий в расходе
                                               THEN COALESCE (MIContainer_Count_Out.ContainerId, 0)
                                          ELSE 0
                                     END

                                    , MIContainer_Count_Out.WhereObjectId_Analyzer
                                    , MIContainer_Summ_In.WhereObjectId_Analyzer
                                    -- , MIContainer_Count_Out.MovementDescId

                                     --
                                     -- расход
                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.AccountId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.UnitId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.GoodsId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.GoodsKindId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.JuridicalId_basis
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.InfoMoneyId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.InfoMoneyId_Detail
                                          ELSE 0
                                     END

                                     --
                                     -- приход
                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.AccountId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.UnitId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.GoodsId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.GoodsKindId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.JuridicalId_basis
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.InfoMoneyId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.InfoMoneyId_Detail
                                          ELSE 0
                                     END

                            UNION ALL
                             -- 1.3. <> zc_Movement_Send, zc_Movement_SendOnPrice
                             SELECT CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                              -- нет партий в приходе
                                              THEN COALESCE (MIContainer_Summ_In.ContainerId, 0)
                                         ELSE 0
                                    END AS MasterContainerId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                              -- нет партий в расходе
                                              THEN COALESCE (MIContainer_Summ_Out.ContainerId, 0)
                                         ELSE 0
                                    END AS ContainerId

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                              -- нет партий в приходе
                                              THEN COALESCE (MIContainer_Count_In.ContainerId, 0)
                                         ELSE 0
                                    END AS MasterContainerId_Count

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                              -- нет партий в расходе
                                              THEN COALESCE (MIContainer_Count_Out.ContainerId, 0)
                                         ELSE 0
                                    END AS ContainerId_Count

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

                                    --
                                    -- расход
                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.AccountId
                                         ELSE 0
                                    END AS AccountId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.UnitId
                                         ELSE 0
                                    END AS UnitId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.GoodsId
                                         ELSE 0
                                    END AS GoodsId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.GoodsKindId
                                         ELSE 0
                                    END AS GoodsKindId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.JuridicalId_basis
                                         ELSE 0
                                    END AS JuridicalId_basis

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.InfoMoneyId
                                         ELSE 0
                                    END AS InfoMoneyId

                                  , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                              -- партии в расходе
                                              THEN MIContainer_Count_Out.InfoMoneyId_Detail
                                         ELSE 0
                                    END AS InfoMoneyId_Detail

                                    --
                                    -- приход
                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.AccountId
                                         ELSE 0
                                    END AS AccountId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.UnitId
                                         ELSE 0
                                    END AS UnitId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.GoodsId
                                         ELSE 0
                                    END AS GoodsId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.GoodsKindId
                                         ELSE 0
                                    END AS GoodsKindId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.JuridicalId_basis
                                         ELSE 0
                                    END AS JuridicalId_basis_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.InfoMoneyId
                                         ELSE 0
                                    END AS InfoMoneyId_master

                                  , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                              -- партии в приходе
                                              THEN MIContainer_Count_In.InfoMoneyId_Detail
                                         ELSE 0
                                    END AS InfoMoneyId_Detail_master

                             FROM MIContainer_Count_Out
                                  -- партии в расходе
                                  --LEFT JOIN tmpContainerList_partion ON tmpContainerList_partion.ContainerId_count = MIContainer_Count_Out.ContainerId

                                  JOIN MIContainer_Summ_Out ON MIContainer_Summ_Out.MovementId     = MIContainer_Count_Out.MovementId
                                                           AND MIContainer_Summ_Out.MovementItemId = MIContainer_Count_Out.MovementItemId
                                                           AND (MIContainer_Summ_Out.InfoMoneyId_Detail = MIContainer_Count_Out.InfoMoneyId_Detail
                                                             OR MIContainer_Count_Out.ContainerId_count IS NULL
                                                               )
                                  -- лишняя проверка???
                                  JOIN Container AS Container_Summ_Out ON Container_Summ_Out.Id       = MIContainer_Summ_Out.ContainerId
                                                                      AND Container_Summ_Out.ParentId = MIContainer_Count_Out.ContainerId

                                  JOIN MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
                                  JOIN Container AS Container_Summ_In ON Container_Summ_In.Id       = MIContainer_Summ_In.ContainerId

                                  JOIN MIContainer_Count_In ON MIContainer_Count_In.MovementItemId = MIContainer_Summ_In.MovementItemId
                                                           AND MIContainer_Count_In.ContainerId    = Container_Summ_In.ParentId
                                                           AND (MIContainer_Count_In.InfoMoneyId_Detail = MIContainer_Summ_In.InfoMoneyId_Detail
                                                             OR MIContainer_Count_In.ContainerId_count  IS NULL
                                                               )
                                                           -- !!! в этом разница !!!
                                                           --AND MIContainer_Count_In.Id             = MIContainer_Count_Out.ParentId
                                  -- партии в приходе
                                  -- LEFT JOIN tmpContainerList_partion AS tmpContainerList_partion_master ON tmpContainerList_partion_master.ContainerId_count = MIContainer_Count_In.ContainerId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                               ON MovementLinkObject_User.MovementId = MIContainer_Count_Out.MovementId
                                                              AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                                              AND MovementLinkObject_User.ObjectId   = zc_Enum_Process_Auto_Defroster()

                                  LEFT JOIN tmpSeparate AS _tmp ON _tmp.MovementId = MIContainer_Count_Out.MovementId
                                                               AND _tmp.ContainerId = MIContainer_Summ_Out.ContainerId
                                                               AND _tmp.MovementItemId = MIContainer_Summ_Out.MovementItemId
                                                               AND MIContainer_Count_Out.MovementDescId = zc_Movement_ProductionSeparate()
                                                               -- нет партий в расходе
                                                               AND MIContainer_Count_Out.ContainerId_count IS NULL
                                                               -- нет партий в приходе
                                                               AND MIContainer_Count_In.ContainerId_count IS NULL
                             WHERE MovementLinkObject_User.MovementId IS NULL
                               -- !!! в этом разница !!!
                               AND MIContainer_Count_Out.MovementDescId NOT IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                                    -- нет партий в расходе
                               AND (MIContainer_Count_Out.ContainerId_count IS NULL
                                    -- нет партий в приходе
                                 OR MIContainer_Count_In.ContainerId_count IS NULL
                                   )
                             GROUP BY CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                               -- нет партий в приходе
                                               THEN COALESCE (MIContainer_Summ_In.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                               -- нет партий в расходе
                                               THEN COALESCE (MIContainer_Summ_Out.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count IS NULL
                                               -- нет партий в приходе
                                               THEN COALESCE (MIContainer_Count_In.ContainerId, 0)
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count IS NULL
                                               -- нет партий в расходе
                                               THEN COALESCE (MIContainer_Count_Out.ContainerId, 0)
                                          ELSE 0
                                     END

                                    , MIContainer_Count_Out.WhereObjectId_Analyzer
                                    , MIContainer_Summ_In.WhereObjectId_Analyzer
                                    -- , MIContainer_Count_Out.MovementDescId

                                     --
                                     -- расход
                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.AccountId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.UnitId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.GoodsId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.GoodsKindId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.JuridicalId_basis
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.InfoMoneyId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_Out.ContainerId_count > 0
                                               -- партии в расходе
                                               THEN MIContainer_Count_Out.InfoMoneyId_Detail
                                          ELSE 0
                                     END

                                     --
                                     -- приход
                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.AccountId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.UnitId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.GoodsId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.GoodsKindId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.JuridicalId_basis
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.InfoMoneyId
                                          ELSE 0
                                     END

                                   , CASE WHEN MIContainer_Count_In.ContainerId_count > 0
                                               -- партии в приходе
                                               THEN MIContainer_Count_In.InfoMoneyId_Detail
                                          ELSE 0
                                     END

                            UNION ALL
                             -- 2.1. партии в приходе - есть, партии в расходе - есть = zc_Movement_Send, zc_Movement_SendOnPrice
                             SELECT 0 AS MasterContainerId
                                  , 0 AS ContainerId
                                  , 0 AS MasterContainerId_Count
                                  , 0 AS ContainerId_Count

                                  , SUM (CASE WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                                                  THEN COALESCE (1 * MIContainer_Count_In.Amount, 0)
                                              WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_ProductionUnion())
                                                  THEN COALESCE (-1 * MIContainer_Count_Out.Amount, 0)
                                              ELSE 0
                                         END) AS OperCount

                                  , CASE WHEN MIContainer_Count_Out.WhereObjectId_Analyzer = MIContainer_Count_In.WhereObjectId_Analyzer THEN FALSE ELSE TRUE END AS isExternal
                                  , 0 AS MovementDescId
                                  -- , MIContainer_Count_Out.MovementDescId
                                    --
                                  , MIContainer_Count_Out.AccountId
                                  , MIContainer_Count_Out.UnitId
                                  , MIContainer_Count_Out.GoodsId
                                  , MIContainer_Count_Out.GoodsKindId
                                  , MIContainer_Count_Out.JuridicalId_basis
                                  , MIContainer_Count_Out.InfoMoneyId
                                  , MIContainer_Count_Out.InfoMoneyId_Detail
                                    --
                                  , MIContainer_Count_In.AccountId
                                  , MIContainer_Count_In.UnitId
                                  , MIContainer_Count_In.GoodsId
                                  , MIContainer_Count_In.GoodsKindId
                                  , MIContainer_Count_In.JuridicalId_basis
                                  , MIContainer_Count_In.InfoMoneyId
                                  , MIContainer_Count_In.InfoMoneyId_Detail

                             FROM res_1 AS MIContainer_Count_Out

                                  JOIN res_2 AS MIContainer_Count_In ON MIContainer_Count_In.MovementItemId     = MIContainer_Count_Out.MovementItemId
                                                                    AND MIContainer_Count_In.MovementId         = MIContainer_Count_Out.MovementId
                                                                    -- !!! в этом разница !!!
                                                                    AND MIContainer_Count_In.Id                 = MIContainer_Count_Out.ParentId
                                                                    --
                                                                    /*AND MIContainer_Count_In.AccountId          = MIContainer_Count_Out.AccountId
                                                                    AND MIContainer_Count_In.UnitId             = MIContainer_Count_Out.UnitId
                                                                    AND MIContainer_Count_In.JuridicalId_basis  = MIContainer_Count_Out.JuridicalId_basis
                                                                    AND MIContainer_Count_In.InfoMoneyId        = MIContainer_Count_Out.InfoMoneyId*/
                                                                    AND MIContainer_Count_In.InfoMoneyId_Detail = MIContainer_Count_Out.InfoMoneyId_Detail

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                               ON MovementLinkObject_User.MovementId = MIContainer_Count_Out.MovementId
                                                              AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                                              AND MovementLinkObject_User.ObjectId   = zc_Enum_Process_Auto_Defroster()

                             WHERE MovementLinkObject_User.MovementId IS NULL
                               -- !!! в этом разница !!!
                               AND MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())

                             GROUP BY MIContainer_Count_Out.WhereObjectId_Analyzer
                                    , MIContainer_Count_In.WhereObjectId_Analyzer
                                    -- , MIContainer_Count_Out.MovementDescId
                                      --
                                    , MIContainer_Count_Out.AccountId
                                    , MIContainer_Count_Out.UnitId
                                    , MIContainer_Count_Out.GoodsId
                                    , MIContainer_Count_Out.GoodsKindId
                                    , MIContainer_Count_Out.JuridicalId_basis
                                    , MIContainer_Count_Out.InfoMoneyId
                                    , MIContainer_Count_Out.InfoMoneyId_Detail
                                      --
                                    , MIContainer_Count_In.AccountId
                                    , MIContainer_Count_In.UnitId
                                    , MIContainer_Count_In.GoodsId
                                    , MIContainer_Count_In.GoodsKindId
                                    , MIContainer_Count_In.JuridicalId_basis
                                    , MIContainer_Count_In.InfoMoneyId
                                    , MIContainer_Count_In.InfoMoneyId_Detail

                            UNION ALL
                             -- 2.2. партии в приходе - есть, партии в расходе - есть <> zc_Movement_Send, zc_Movement_SendOnPrice
                             SELECT 0 AS MasterContainerId
                                  , 0 AS ContainerId
                                  , 0 AS MasterContainerId_Count
                                  , 0 AS ContainerId_Count

                                  , SUM (CASE WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                                                  THEN COALESCE (1 * MIContainer_Count_In.Amount, 0)
                                              WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_ProductionUnion())
                                                  THEN COALESCE (-1 * MIContainer_Count_Out.Amount, 0)
                                              ELSE 0
                                         END) AS OperCount

                                  , CASE WHEN MIContainer_Count_Out.WhereObjectId_Analyzer = MIContainer_Count_In.WhereObjectId_Analyzer THEN FALSE ELSE TRUE END AS isExternal
                                  , 0 AS MovementDescId
                                  -- , MIContainer_Count_Out.MovementDescId
                                    --
                                  , MIContainer_Count_Out.AccountId
                                  , MIContainer_Count_Out.UnitId
                                  , MIContainer_Count_Out.GoodsId
                                  , MIContainer_Count_Out.GoodsKindId
                                  , MIContainer_Count_Out.JuridicalId_basis
                                  , MIContainer_Count_Out.InfoMoneyId
                                  , MIContainer_Count_Out.InfoMoneyId_Detail
                                    --
                                  , MIContainer_Count_In.AccountId
                                  , MIContainer_Count_In.UnitId
                                  , MIContainer_Count_In.GoodsId
                                  , MIContainer_Count_In.GoodsKindId
                                  , MIContainer_Count_In.JuridicalId_basis
                                  , MIContainer_Count_In.InfoMoneyId
                                  , MIContainer_Count_In.InfoMoneyId_Detail

                             FROM res_1 AS MIContainer_Count_Out

                                  JOIN res_2 AS MIContainer_Count_In ON MIContainer_Count_In.MovementItemId = MIContainer_Count_Out.MovementItemId
                                                                    AND MIContainer_Count_In.MovementId     = MIContainer_Count_Out.MovementId
                                                                    -- !!! в этом разница !!!
                                                                    --AND MIContainer_Count_In.Id             = MIContainer_Count_Out.ParentId
                                                                    --
                                                                    /*AND MIContainer_Count_In.AccountId          = MIContainer_Count_Out.AccountId
                                                                    AND MIContainer_Count_In.UnitId             = MIContainer_Count_Out.UnitId
                                                                    AND MIContainer_Count_In.JuridicalId_basis  = MIContainer_Count_Out.JuridicalId_basis
                                                                    AND MIContainer_Count_In.InfoMoneyId        = MIContainer_Count_Out.InfoMoneyId*/
                                                                    AND MIContainer_Count_In.InfoMoneyId_Detail = MIContainer_Count_Out.InfoMoneyId_Detail

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                               ON MovementLinkObject_User.MovementId = MIContainer_Count_Out.MovementId
                                                              AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                                              AND MovementLinkObject_User.ObjectId   = zc_Enum_Process_Auto_Defroster()

                                  -- !!! для партий ЭТО ВРЕМЕННО не реализованно
                                  --LEFT JOIN tmpSeparate AS _tmp ON _tmp.MovementId = MIContainer_Count_Out.MovementId
                                  --                             AND _tmp.ContainerId = MIContainer_Summ_Out.ContainerId
                                  --                             AND _tmp.MovementItemId = MIContainer_Summ_Out.MovementItemId
                                  --                             AND MIContainer_Count_Out.MovementDescId = zc_Movement_ProductionSeparate()

                             WHERE MovementLinkObject_User.MovementId IS NULL
                               -- !!! в этом разница !!!
                               AND MIContainer_Count_Out.MovementDescId NOT IN (zc_Movement_Send(), zc_Movement_SendOnPrice())

                             GROUP BY MIContainer_Count_Out.WhereObjectId_Analyzer
                                    , MIContainer_Count_In.WhereObjectId_Analyzer
                                    -- , MIContainer_Count_Out.MovementDescId
                                      --
                                    , MIContainer_Count_Out.AccountId
                                    , MIContainer_Count_Out.UnitId
                                    , MIContainer_Count_Out.GoodsId
                                    , MIContainer_Count_Out.GoodsKindId
                                    , MIContainer_Count_Out.JuridicalId_basis
                                    , MIContainer_Count_Out.InfoMoneyId
                                    , MIContainer_Count_Out.InfoMoneyId_Detail
                                      --
                                    , MIContainer_Count_In.AccountId
                                    , MIContainer_Count_In.UnitId
                                    , MIContainer_Count_In.GoodsId
                                    , MIContainer_Count_In.GoodsKindId
                                    , MIContainer_Count_In.JuridicalId_basis
                                    , MIContainer_Count_In.InfoMoneyId
                                    , MIContainer_Count_In.InfoMoneyId_Detail
                            )
            -- Результат
            SELECT tmpRes.MasterContainerId
                 , tmpRes.ContainerId
                 , tmpRes.MasterContainerId_Count
                 , tmpRes.ContainerId_Count

                 , SUM (tmpRes.OperCount) AS OperCount
                 , tmpRes.isExternal
                 , tmpRes.MovementDescId

                 , tmpRes.AccountId
                 , tmpRes.UnitId
                 , tmpRes.GoodsId
                 , tmpRes.GoodsKindId
                 , tmpRes.JuridicalId_basis
                 , tmpRes.InfoMoneyId
                 , tmpRes.InfoMoneyId_Detail

                 , tmpRes.AccountId_master
                 , tmpRes.UnitId_master
                 , tmpRes.GoodsId_master
                 , tmpRes.GoodsKindId_master
                 , tmpRes.JuridicalId_basis_master
                 , tmpRes.InfoMoneyId_master
                 , tmpRes.InfoMoneyId_Detail_master

            FROM tmpRes
            GROUP BY tmpRes.MasterContainerId
                   , tmpRes.ContainerId
                   , tmpRes.MasterContainerId_Count
                   , tmpRes.ContainerId_Count

                   , tmpRes.isExternal
                   , tmpRes.MovementDescId

                   , tmpRes.AccountId
                   , tmpRes.UnitId
                   , tmpRes.GoodsId
                   , tmpRes.GoodsKindId
                   , tmpRes.JuridicalId_basis
                   , tmpRes.InfoMoneyId
                   , tmpRes.InfoMoneyId_Detail

                   , tmpRes.AccountId_master
                   , tmpRes.UnitId_master
                   , tmpRes.GoodsId_master
                   , tmpRes.GoodsKindId_master
                   , tmpRes.JuridicalId_basis_master
                   , tmpRes.InfoMoneyId_master
                   , tmpRes.InfoMoneyId_Detail_master
            ;

         -- !!!Оптимизация!!!
         ANALYZE _tmpChild;

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


     END IF; -- if inBranchId = 0 and INSERT INTO _tmpChild



    RAISE INFO 'CLOCK_TIMESTAMP - 0 .<%>', CLOCK_TIMESTAMP();

IF inBranchId <= 0
THEN
     -- 1
     IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
     THEN
         DELETE FROM _tmpMaster_2024_07;
     ELSE
         truncate table _tmpMaster_2024_07;
     END IF;
     INSERT INTO _tmpMaster_2024_07 (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm
                           , AccountId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail, JuridicalId_basis
                           , isZavod
                            )
        SELECT * FROM _tmpMaster;

     -- 2
     IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
     THEN
         DELETE FROM _tmpContainerList_2024_07;
     ELSE
         truncate table _tmpContainerList_2024_07;
     END IF;
     INSERT INTO _tmpContainerList_2024_07 (ContainerId, ContainerId_count, AccountId, isZavod,
                                            UnitId, GoodsId, GoodsKindId, JuridicalId_basis, InfoMoneyId, InfoMoneyId_Detail
                                           )
        SELECT * FROM tmpContainerList;

     -- 3
     IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
     THEN
         DELETE FROM _tmpContainerList_partion_2024_07;
     ELSE
         truncate table _tmpContainerList_partion_2024_07;
     END IF;
     INSERT INTO _tmpContainerList_partion_2024_07 (ContainerId_count, AccountId,
                                            UnitId, GoodsId, GoodsKindId, JuridicalId_basis, InfoMoneyId, InfoMoneyId_Detail
                                           )
        SELECT *FROM tmpContainerList_partion;

     -- 4
     IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
     THEN
         DELETE FROM _tmpChild_2024_07;
     ELSE
         truncate table _tmpChild_2024_07;
     END IF;
     INSERT INTO _tmpChild_2024_07 (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount, isExternal, DescId
                              , AccountId, UnitId, GoodsId, GoodsKindId, JuridicalId_basis, InfoMoneyId, InfoMoneyId_Detail
                              , AccountId_master, UnitId_master, GoodsId_master, GoodsKindId_master, JuridicalId_basis_master, InfoMoneyId_master, InfoMoneyId_Detail_master
                            )
        SELECT * FROM _tmpChild;

   RAISE INFO 'CLOCK_TIMESTAMP - 4 .<%>', CLOCK_TIMESTAMP();

ELSE

     IF vbIsBranch_Itearation = TRUE
     THEN

         -- 1
         IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
         THEN
             DELETE FROM _tmpMaster_2024_07_b;
         ELSE
             truncate table _tmpMaster_2024_07_b;
         END IF;
         INSERT INTO _tmpMaster_2024_07_b (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm
                               , AccountId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail, JuridicalId_basis
                               , isZavod
                                )
            SELECT * FROM _tmpMaster;

         -- 2
         IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
         THEN
             DELETE FROM _tmpChild_2024_07_b;
         ELSE
             truncate table _tmpChild_2024_07_b;
         END IF;
         INSERT INTO _tmpChild_2024_07_b (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount, isExternal, DescId
                                  , AccountId, UnitId, GoodsId, GoodsKindId, JuridicalId_basis, InfoMoneyId, InfoMoneyId_Detail
                                  , AccountId_master, UnitId_master, GoodsId_master, GoodsKindId_master, JuridicalId_basis_master, InfoMoneyId_master, InfoMoneyId_Detail_master
                                )
            SELECT * FROM _tmpChild;

     END IF;

END IF;



     -- проверка 1.1.
     IF EXISTS (SELECT _tmpMaster.ContainerId FROM _tmpMaster WHERE _tmpMaster.ContainerId > 0 GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1)
     THEN
RAISE INFO 'проверка 1.1.';
return;

         RAISE EXCEPTION 'проверка 1.1. - SELECT ContainerId FROM _tmpMaster GROUP BY ContainerId HAVING COUNT(*) > 1 ContainerId = % + count = %'
                       , (SELECT _tmpMaster.ContainerId FROM _tmpMaster WHERE _tmpMaster.ContainerId > 0 GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1 LIMIT 1)
                       , (SELECT COUNT(*) FROM (SELECT _tmpMaster.ContainerId FROM _tmpMaster WHERE _tmpMaster.ContainerId > 0 GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1) AS tmpSelect)
                        ;
     END IF;

     -- проверка 1.2.
     IF EXISTS (SELECT _tmpChild.MasterContainerId, _tmpChild.ContainerId FROM _tmpChild WHERE _tmpChild.MasterContainerId > 0 AND _tmpChild.ContainerId > 0 GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1)
     THEN
RAISE INFO 'проверка 1.2.';
return;
         RAISE EXCEPTION 'проверка 1.2. - SELECT MasterContainerId, ContainerId FROM _tmpChild GROUP BY MasterContainerId, ContainerId HAVING COUNT(*) > 1 :  MasterContainerId = % and ContainerId = %'
                       , (SELECT _tmpChild.MasterContainerId FROM _tmpChild WHERE _tmpChild.MasterContainerId > 0 AND _tmpChild.ContainerId > 0 GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
                       , (SELECT _tmpChild.ContainerId FROM _tmpChild WHERE _tmpChild.MasterContainerId > 0 AND _tmpChild.ContainerId > 0 GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
                        ;
     END IF;


     -- проверка 2.1.
     IF EXISTS (SELECT _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis
                FROM _tmpMaster
                WHERE _tmpMaster.ContainerId = 0
                GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis
                HAVING COUNT(*) > 1)
     THEN
         RAISE INFO 'проверка 2.1.';
         return;
         --
         RAISE EXCEPTION 'проверка 2.1. - SELECT all keys FROM _tmpMaster GROUP BY all keys HAVING COUNT(*) > 1 UnitId = % AccountId = % GoodsId = % GoodsKindId = % InfoMoneyId = % InfoMoneyId_Detail = % JuridicalId_basis = %  + count = %'
                       , (SELECT _tmpMaster.UnitId FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       , (SELECT _tmpMaster.AccountId FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       , (SELECT _tmpMaster.GoodsId FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       , (SELECT _tmpMaster.GoodsKindId FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       , (SELECT _tmpMaster.GoodsKindId FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       , (SELECT _tmpMaster.InfoMoneyId FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       , (SELECT _tmpMaster.InfoMoneyId_Detail FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       , (SELECT _tmpMaster.JuridicalId_basis FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1 ORDER BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis LIMIT 1)
                       --, (SELECT COUNT(*) FROM (SELECT _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis FROM _tmpMaster WHERE _tmpMaster.ContainerId = 0 GROUP BY _tmpMaster.UnitId, _tmpMaster.AccountId, _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.JuridicalId_basis HAVING COUNT(*) > 1) AS tmpSelect)
                        ;
     END IF;

     -- проверка 2.2.
     IF EXISTS (SELECT _tmpChild.AccountId, _tmpChild.UnitId, _tmpChild.GoodsId, _tmpChild.GoodsKindId, _tmpChild.JuridicalId_basis, _tmpChild.InfoMoneyId, _tmpChild.InfoMoneyId_Detail
                     , _tmpChild.AccountId_master, _tmpChild.UnitId_master, _tmpChild.GoodsId_master, _tmpChild.GoodsKindId_master, _tmpChild.JuridicalId_basis_master, _tmpChild.InfoMoneyId_master, _tmpChild.InfoMoneyId_Detail_master
                FROM _tmpChild
                WHERE _tmpChild.MasterContainerId = 0 AND _tmpChild.ContainerId = 0
                GROUP BY _tmpChild.AccountId, _tmpChild.UnitId, _tmpChild.GoodsId, _tmpChild.GoodsKindId, _tmpChild.JuridicalId_basis, _tmpChild.InfoMoneyId, _tmpChild.InfoMoneyId_Detail
                       , _tmpChild.AccountId_master, _tmpChild.UnitId_master, _tmpChild.GoodsId_master, _tmpChild.GoodsKindId_master, _tmpChild.JuridicalId_basis_master, _tmpChild.InfoMoneyId_master, _tmpChild.InfoMoneyId_Detail_master
                HAVING COUNT(*) > 1)
     THEN

         RAISE INFO 'проверка 2.2.';
         return;
         --
         RAISE EXCEPTION 'проверка 2.2. - SELECT all keys FROM _tmpChild GROUP BY all keys HAVING COUNT(*) > 1 :  Master_Keys = % and Keys = %'
                       , (SELECT COALESCE (_tmpChild.AccountId, 0) :: TVarChar || ' ' || COALESCE (_tmpChild.UnitId, 0) :: TVarChar || ' ' || COALESCE (_tmpChild.GoodsId, 0) :: TVarChar || '' || COALESCE (_tmpChild.GoodsKindId, 0) :: TVarChar || '' || COALESCE (_tmpChild.JuridicalId_basis, 0) :: TVarChar || '' || COALESCE (_tmpChild.InfoMoneyId, 0) :: TVarChar || '' || COALESCE (_tmpChild.InfoMoneyId_Detail, 0) :: TVarChar
                          FROM _tmpChild
                          GROUP BY _tmpChild.AccountId, _tmpChild.UnitId, _tmpChild.GoodsId, _tmpChild.GoodsKindId, _tmpChild.JuridicalId_basis, _tmpChild.InfoMoneyId, _tmpChild.InfoMoneyId_Detail
                                 , _tmpChild.AccountId_master, _tmpChild.UnitId_master, _tmpChild.GoodsId_master, _tmpChild.GoodsKindId_master, _tmpChild.JuridicalId_basis_master, _tmpChild.InfoMoneyId_master, _tmpChild.InfoMoneyId_Detail_master
                          HAVING COUNT(*) > 1
                          ORDER BY _tmpChild.AccountId, _tmpChild.UnitId, _tmpChild.GoodsId, _tmpChild.GoodsKindId, _tmpChild.JuridicalId_basis, _tmpChild.InfoMoneyId, _tmpChild.InfoMoneyId_Detail
                                 , _tmpChild.AccountId_master, _tmpChild.UnitId_master, _tmpChild.GoodsId_master, _tmpChild.GoodsKindId_master, _tmpChild.JuridicalId_basis_master, _tmpChild.InfoMoneyId_master, _tmpChild.InfoMoneyId_Detail_master
                          LIMIT 1
                         )
                       , (SELECT COALESCE (_tmpChild.AccountId_master, 0) :: TVarChar || ' ' || COALESCE (_tmpChild.UnitId_master, 0) :: TVarChar || ' ' || COALESCE (_tmpChild.GoodsId_master, 0) :: TVarChar || '' || COALESCE (_tmpChild.GoodsKindId_master, 0) :: TVarChar || '' || COALESCE (_tmpChild.JuridicalId_basis_master, 0) :: TVarChar || '' || COALESCE (_tmpChild.InfoMoneyId_master, 0) :: TVarChar || '' || COALESCE (_tmpChild.InfoMoneyId_Detail_master, 0) :: TVarChar
                          FROM _tmpChild
                          GROUP BY _tmpChild.AccountId, _tmpChild.UnitId, _tmpChild.GoodsId, _tmpChild.GoodsKindId, _tmpChild.JuridicalId_basis, _tmpChild.InfoMoneyId, _tmpChild.InfoMoneyId_Detail
                                 , _tmpChild.AccountId_master, _tmpChild.UnitId_master, _tmpChild.GoodsId_master, _tmpChild.GoodsKindId_master, _tmpChild.JuridicalId_basis_master, _tmpChild.InfoMoneyId_master, _tmpChild.InfoMoneyId_Detail_master
                          HAVING COUNT(*) > 1
                          ORDER BY _tmpChild.AccountId, _tmpChild.UnitId, _tmpChild.GoodsId, _tmpChild.GoodsKindId, _tmpChild.JuridicalId_basis, _tmpChild.InfoMoneyId, _tmpChild.InfoMoneyId_Detail
                                 , _tmpChild.AccountId_master, _tmpChild.UnitId_master, _tmpChild.GoodsId_master, _tmpChild.GoodsKindId_master, _tmpChild.JuridicalId_basis_master, _tmpChild.InfoMoneyId_master, _tmpChild.InfoMoneyId_Detail_master
                          LIMIT 1
                         )
                        ;
     END IF;

-- return;
-- RAISE EXCEPTION 'end INSERT INTO _tmpChild';

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - итерации для с/с !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

RAISE INFO ' start-1 1-ая итерация для всех.<%>', CLOCK_TIMESTAMP();

         -- Расчет цены
         CREATE TEMP TABLE _tmpPrice_calc ON COMMIT DROP
             AS (SELECT _tmpMaster.ContainerId
                      , _tmpMaster.AccountId
                      , _tmpMaster.UnitId
                      , _tmpMaster.GoodsId
                      , _tmpMaster.GoodsKindId
                      , _tmpMaster.JuridicalId_basis
                      , _tmpMaster.InfoMoneyId
                      , _tmpMaster.InfoMoneyId_Detail
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
                 FROM _tmpMaster
                 -- нет партий в расходе
                 -- WHERE _tmpMaster.ContainerId > 0
                );

         -- !!!Оптимизация!!!
         ANALYZE _tmpPrice_calc;

RAISE INFO ' end-1 1-ая итерация для всех.<%>  OperPrice = <%>', CLOCK_TIMESTAMP()
, (select _tmpPrice_calc.OperPrice FROM _tmpPrice_calc WHERE _tmpPrice_calc.ContainerId = 2019143)
;


         -- Расчет суммы всех составляющих
         CREATE TEMP TABLE _tmpSumm_calc ON COMMIT DROP
           AS (SELECT tmpSumm_calc.ContainerId
                      --
                    , tmpSumm_calc.AccountId_master
                    , tmpSumm_calc.UnitId_master
                    , tmpSumm_calc.GoodsId_master
                    , tmpSumm_calc.GoodsKindId_master
                    , tmpSumm_calc.JuridicalId_basis_master
                    , tmpSumm_calc.InfoMoneyId_master
                    , tmpSumm_calc.InfoMoneyId_Detail_master

                    , CAST (SUM (tmpSumm_calc.CalcSumm) AS TFloat) AS CalcSumm
                    , CAST (SUM (tmpSumm_calc.CalcSumm_external) AS TFloat) AS CalcSumm_external

               FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                            --
                          , _tmpChild.AccountId_master
                          , _tmpChild.UnitId_master
                          , _tmpChild.GoodsId_master
                          , _tmpChild.GoodsKindId_master
                          , _tmpChild.JuridicalId_basis_master
                          , _tmpChild.InfoMoneyId_master
                          , _tmpChild.InfoMoneyId_Detail_master
                            --
                          , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                          , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                     FROM _tmpChild
                          -- Расчет цены
                          JOIN _tmpPrice_calc AS
                               _tmpPrice ON _tmpPrice.ContainerId = _tmpChild.ContainerId
                                        AND _tmpPrice.ContainerId > 0
                     -- !!!нет партий в приходе
                     -- WHERE _tmpChild.MasterContainerId > 0
                     --
                     -- Отбрасываем в том случае если сам в себя
                     -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

                     GROUP BY _tmpChild.MasterContainerId
                              --
                            , _tmpChild.AccountId_master
                            , _tmpChild.UnitId_master
                            , _tmpChild.GoodsId_master
                            , _tmpChild.GoodsKindId_master
                            , _tmpChild.JuridicalId_basis_master
                            , _tmpChild.InfoMoneyId_master
                            , _tmpChild.InfoMoneyId_Detail_master

                    UNION ALL
                     SELECT _tmpChild.MasterContainerId AS ContainerId
                            --
                          , _tmpChild.AccountId_master
                          , _tmpChild.UnitId_master
                          , _tmpChild.GoodsId_master
                          , _tmpChild.GoodsKindId_master
                          , _tmpChild.JuridicalId_basis_master
                          , _tmpChild.InfoMoneyId_master
                          , _tmpChild.InfoMoneyId_Detail_master
                            --
                          , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                          , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                     FROM _tmpChild
                          -- Расчет цены
                          JOIN _tmpPrice_calc AS
                              _tmpPrice ON _tmpPrice.AccountId          = _tmpChild.AccountId
                                        AND _tmpPrice.UnitId             = _tmpChild.UnitId
                                        AND _tmpPrice.GoodsId            = _tmpChild.GoodsId
                                        AND _tmpPrice.GoodsKindId        = _tmpChild.GoodsKindId
                                        AND _tmpPrice.JuridicalId_basis  = _tmpChild.JuridicalId_basis
                                        AND _tmpPrice.InfoMoneyId        = _tmpChild.InfoMoneyId
                                        AND _tmpPrice.InfoMoneyId_Detail = _tmpChild.InfoMoneyId_Detail
                                        AND _tmpPrice.ContainerId        = 0
                     -- !!!нет партий в приходе
                     -- WHERE _tmpChild.MasterContainerId > 0
                     --
                     -- Отбрасываем в том случае если сам в себя
                     -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

                     GROUP BY _tmpChild.MasterContainerId
                              --
                            , _tmpChild.AccountId_master
                            , _tmpChild.UnitId_master
                            , _tmpChild.GoodsId_master
                            , _tmpChild.GoodsKindId_master
                            , _tmpChild.JuridicalId_basis_master
                            , _tmpChild.InfoMoneyId_master
                            , _tmpChild.InfoMoneyId_Detail_master
                    ) AS tmpSumm_calc
               GROUP BY tmpSumm_calc.ContainerId
                        --
                      , tmpSumm_calc.AccountId_master
                      , tmpSumm_calc.UnitId_master
                      , tmpSumm_calc.GoodsId_master
                      , tmpSumm_calc.GoodsKindId_master
                      , tmpSumm_calc.JuridicalId_basis_master
                      , tmpSumm_calc.InfoMoneyId_master
                      , tmpSumm_calc.InfoMoneyId_Detail_master
              );

         -- !!!Оптимизация!!!
         ANALYZE _tmpSumm_calc;


RAISE INFO ' end-2 1-ая итерация для всех.<%>  CalcSumm = <%> + <%>', CLOCK_TIMESTAMP()
, (select _tmpSumm_calc.CalcSumm FROM _tmpSumm_calc WHERE _tmpSumm_calc.ContainerId = 2019143)
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 2019143)
;


         -- !!!обнулили!!!
         UPDATE _tmpMaster SET CalcSumm          = 0
                             , CalcSumm_external = 0
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND _tmpMaster.ContainerId > 0
          ;

         UPDATE _tmpMaster SET CalcSumm          = 0
                             , CalcSumm_external = 0
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm

         WHERE _tmpMaster.AccountId          = _tmpSumm.AccountId_master
           AND _tmpMaster.UnitId             = _tmpSumm.UnitId_master
           AND _tmpMaster.GoodsId            = _tmpSumm.GoodsId_master
           AND _tmpMaster.GoodsKindId        = _tmpSumm.GoodsKindId_master
           AND _tmpMaster.JuridicalId_basis  = _tmpSumm.JuridicalId_basis_master
           AND _tmpMaster.InfoMoneyId        = _tmpSumm.InfoMoneyId_master
           AND _tmpMaster.InfoMoneyId_Detail = _tmpSumm.InfoMoneyId_Detail_master
           AND _tmpMaster.ContainerId        = 0
          ;

/*

RAISE INFO ' CalcSumm = <%>  <%>  <%> '
          , (select min (_tmpMaster.CalcSumm) FROM _tmpSumm_calc AS _tmpMaster WHERE _tmpMaster.GoodsId_master = 10087668 and _tmpMaster.GoodsKindId_master = 8348
               and _tmpMaster.InfoMoneyId_Detail_master = 8913 -- 8906
               and _tmpMaster.UnitId_master = zc_Unit_RK()
            )
          , (select max (_tmpMaster.CalcSumm) FROM _tmpSumm_calc AS _tmpMaster WHERE _tmpMaster.GoodsId_master = 10087668 and _tmpMaster.GoodsKindId_master = 8348
               and _tmpMaster.InfoMoneyId_Detail_master = 8913 -- 8906
               and _tmpMaster.UnitId_master = zc_Unit_RK()
            )
          , (select sum (_tmpMaster.CalcSumm) FROM _tmpSumm_calc AS _tmpMaster WHERE _tmpMaster.GoodsId_master = 10087668 and _tmpMaster.GoodsKindId_master = 8348
               and _tmpMaster.InfoMoneyId_Detail_master = 8913 -- 8906
               and _tmpMaster.UnitId_master = zc_Unit_RK()
            )
           ;


RAISE INFO ' start-2 1-ая итерация для всех.<%>', CLOCK_TIMESTAMP();

     -- !!! 1-ая итерация для всех !!!
         UPDATE _tmpMaster SET CalcSumm          = _tmpMaster.CalcSumm          + _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpMaster.CalcSumm_external + _tmpSumm.CalcSumm_external
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm

         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND _tmpMaster.ContainerId > 0
          ;

RAISE INFO ' CalcSumm = <%>  <%>'
          , (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.GoodsId = 10087668 and _tmpMaster.GoodsKindId = 8348
               and _tmpMaster.InfoMoneyId_Detail = 8913 -- 8906
               and _tmpMaster.UnitId = zc_Unit_RK()
            )
          , (select _tmpMaster.CalcSumm_external FROM _tmpMaster WHERE _tmpMaster.GoodsId = 10087668 and _tmpMaster.GoodsKindId = 8348
               and _tmpMaster.InfoMoneyId_Detail = 8913 -- 8906
               and _tmpMaster.UnitId = zc_Unit_RK()
            )
           ;


RAISE INFO ' start-3 1-ая итерация для всех.<%>', CLOCK_TIMESTAMP();

         UPDATE _tmpMaster SET CalcSumm          = _tmpMaster.CalcSumm          + _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpMaster.CalcSumm_external + _tmpSumm.CalcSumm_external
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm

         WHERE _tmpMaster.AccountId          = _tmpSumm.AccountId_master
           AND _tmpMaster.UnitId             = _tmpSumm.UnitId_master
           AND _tmpMaster.GoodsId            = _tmpSumm.GoodsId_master
           AND _tmpMaster.GoodsKindId        = _tmpSumm.GoodsKindId_master
           AND _tmpMaster.JuridicalId_basis  = _tmpSumm.JuridicalId_basis_master
           AND _tmpMaster.InfoMoneyId        = _tmpSumm.InfoMoneyId_master
           AND _tmpMaster.InfoMoneyId_Detail = _tmpSumm.InfoMoneyId_Detail_master
           AND _tmpMaster.ContainerId        = 0
          ;

RAISE INFO ' end 1-ая итерация для всех.<%>', CLOCK_TIMESTAMP();

RAISE INFO ' CalcSumm = <%>  <%>'
          , (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.GoodsId = 10087668 and _tmpMaster.GoodsKindId = 8348
               and _tmpMaster.InfoMoneyId_Detail = 8913 -- 8906
               and _tmpMaster.UnitId = zc_Unit_RK()
            )
          , (select _tmpMaster.CalcSumm_external FROM _tmpMaster WHERE _tmpMaster.GoodsId = 10087668 and _tmpMaster.GoodsKindId = 8348
               and _tmpMaster.InfoMoneyId_Detail = 8913 -- 8906
               and _tmpMaster.UnitId = zc_Unit_RK()
            )
           ;
*/

-- return;

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
         INSERT INTO _tmpErr (ContainerId, UnitId) SELECT _tmpMaster.ContainerId, _tmpMaster.UnitId FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 11231231201;
         DELETE FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 11231231201;


         -- !!!ВРЕМЕННО!!!
         --DELETE FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 11231231201;
         --UPDATE _tmpMaster SET  WHERE ABS (_tmpMaster.calcSumm) > 11231231201;


         -- !!! error - 15.06.2024!!!
         /*if inBranchId = 0
         then
             -- !!! error - 15.06.2024!!!
             UPDATE _tmpMaster SET CalcSumm          = 0.1 * _tmpMaster.calcCount
                                 , CalcSumm_external = 0.1 * _tmpMaster.calcCount_external
             FROM
                  (with tmp_1 AS (SELECT Container.*
                                  FROM Container
                                       INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                      ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                     AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                     AND ContainerLinkObject_Unit.ObjectId IN (8450) -- ЦЕХ пакування + Склад База ГП + Дільниця термічної обробки
                                  WHERE Container.DescId = zc_Container_Count()
                                    AND Container.ObjectId in (3569176  -- 953
                                                              )
                                 )
                      SELECT Container.Id
                      FROM Container
                      WHERE Container.DescId = zc_Container_Summ()
                        AND Container.ParentId in (SELECT tmp_1.Id FROM tmp_1)
                  ) AS tmp
             WHERE tmp.Id = _tmpMaster.ContainerId
            ;

         end if;*/


         DELETE FROM _tmpPrice_calc;
         -- Расчет цены
         INSERT INTO _tmpPrice_calc (ContainerId
                                     --
                                   , AccountId
                                   , UnitId
                                   , GoodsId
                                   , GoodsKindId
                                   , JuridicalId_basis
                                   , InfoMoneyId
                                   , InfoMoneyId_Detail
                                     --
                                   , OperPrice
                                    )
                 SELECT _tmpMaster.ContainerId
                      , _tmpMaster.AccountId
                      , _tmpMaster.UnitId
                      , _tmpMaster.GoodsId
                      , _tmpMaster.GoodsKindId
                      , _tmpMaster.JuridicalId_basis
                      , _tmpMaster.InfoMoneyId
                      , _tmpMaster.InfoMoneyId_Detail
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
                 FROM _tmpMaster
                 -- нет партий в расходе
                 -- WHERE _tmpMaster.ContainerId > 0
                ;
         -- !!!Оптимизация!!!
         ANALYZE _tmpPrice_calc;


         DELETE FROM _tmpSumm_calc;
         -- Расчет суммы всех составляющих
         INSERT INTO _tmpSumm_calc (ContainerId
                                    --
                                  , AccountId_master
                                  , UnitId_master
                                  , GoodsId_master
                                  , GoodsKindId_master
                                  , JuridicalId_basis_master
                                  , InfoMoneyId_master
                                  , InfoMoneyId_Detail_master
                                    --
                                  , CalcSumm
                                  , CalcSumm_external
                                   )
               -- Результат
               SELECT tmpSumm_calc.ContainerId
                      --
                    , tmpSumm_calc.AccountId_master
                    , tmpSumm_calc.UnitId_master
                    , tmpSumm_calc.GoodsId_master
                    , tmpSumm_calc.GoodsKindId_master
                    , tmpSumm_calc.JuridicalId_basis_master
                    , tmpSumm_calc.InfoMoneyId_master
                    , tmpSumm_calc.InfoMoneyId_Detail_master

                    , CAST (SUM (tmpSumm_calc.CalcSumm) AS TFloat) AS CalcSumm
                    , CAST (SUM (tmpSumm_calc.CalcSumm_external) AS TFloat) AS CalcSumm_external

               FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                            --
                          , _tmpChild.AccountId_master
                          , _tmpChild.UnitId_master
                          , _tmpChild.GoodsId_master
                          , _tmpChild.GoodsKindId_master
                          , _tmpChild.JuridicalId_basis_master
                          , _tmpChild.InfoMoneyId_master
                          , _tmpChild.InfoMoneyId_Detail_master
                            --
                          , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                          , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                     FROM _tmpChild
                          -- Расчет цены
                          JOIN _tmpPrice_calc AS
                               _tmpPrice ON _tmpPrice.ContainerId = _tmpChild.ContainerId
                                        AND _tmpPrice.ContainerId > 0
                     -- !!!нет партий в приходе
                     -- WHERE _tmpChild.MasterContainerId > 0
                     --
                     -- Отбрасываем в том случае если сам в себя
                     -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

                     GROUP BY _tmpChild.MasterContainerId
                              --
                            , _tmpChild.AccountId_master
                            , _tmpChild.UnitId_master
                            , _tmpChild.GoodsId_master
                            , _tmpChild.GoodsKindId_master
                            , _tmpChild.JuridicalId_basis_master
                            , _tmpChild.InfoMoneyId_master
                            , _tmpChild.InfoMoneyId_Detail_master

                    UNION ALL
                     SELECT _tmpChild.MasterContainerId AS ContainerId
                            --
                          , _tmpChild.AccountId_master
                          , _tmpChild.UnitId_master
                          , _tmpChild.GoodsId_master
                          , _tmpChild.GoodsKindId_master
                          , _tmpChild.JuridicalId_basis_master
                          , _tmpChild.InfoMoneyId_master
                          , _tmpChild.InfoMoneyId_Detail_master
                            --
                          , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                          , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                     FROM _tmpChild
                          -- Расчет цены
                          JOIN _tmpPrice_calc AS
                              _tmpPrice ON _tmpPrice.AccountId          = _tmpChild.AccountId
                                        AND _tmpPrice.UnitId             = _tmpChild.UnitId
                                        AND _tmpPrice.GoodsId            = _tmpChild.GoodsId
                                        AND _tmpPrice.GoodsKindId        = _tmpChild.GoodsKindId
                                        AND _tmpPrice.JuridicalId_basis  = _tmpChild.JuridicalId_basis
                                        AND _tmpPrice.InfoMoneyId        = _tmpChild.InfoMoneyId
                                        AND _tmpPrice.InfoMoneyId_Detail = _tmpChild.InfoMoneyId_Detail
                                        AND _tmpPrice.ContainerId        = 0
                     -- !!!нет партий в приходе
                     -- WHERE _tmpChild.MasterContainerId > 0
                     --
                     -- Отбрасываем в том случае если сам в себя
                     -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

                     GROUP BY _tmpChild.MasterContainerId
                              --
                            , _tmpChild.AccountId_master
                            , _tmpChild.UnitId_master
                            , _tmpChild.GoodsId_master
                            , _tmpChild.GoodsKindId_master
                            , _tmpChild.JuridicalId_basis_master
                            , _tmpChild.InfoMoneyId_master
                            , _tmpChild.InfoMoneyId_Detail_master
                    ) AS tmpSumm_calc
               GROUP BY tmpSumm_calc.ContainerId
                        --
                      , tmpSumm_calc.AccountId_master
                      , tmpSumm_calc.UnitId_master
                      , tmpSumm_calc.GoodsId_master
                      , tmpSumm_calc.GoodsKindId_master
                      , tmpSumm_calc.JuridicalId_basis_master
                      , tmpSumm_calc.InfoMoneyId_master
                      , tmpSumm_calc.InfoMoneyId_Detail_master
              ;
         -- !!!Оптимизация!!!
         ANALYZE _tmpSumm_calc;


         -- !!!обнулили!!!
         UPDATE _tmpMaster SET CalcSumm          = 0
                             , CalcSumm_external = 0
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm

         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND _tmpMaster.ContainerId > 0
          ;
         -- !!!обнулили!!!
         UPDATE _tmpMaster SET CalcSumm          = 0
                             , CalcSumm_external = 0
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm

         WHERE _tmpMaster.AccountId          = _tmpSumm.AccountId_master
           AND _tmpMaster.UnitId             = _tmpSumm.UnitId_master
           AND _tmpMaster.GoodsId            = _tmpSumm.GoodsId_master
           AND _tmpMaster.GoodsKindId        = _tmpSumm.GoodsKindId_master
           AND _tmpMaster.JuridicalId_basis  = _tmpSumm.JuridicalId_basis_master
           AND _tmpMaster.InfoMoneyId        = _tmpSumm.InfoMoneyId_master
           AND _tmpMaster.InfoMoneyId_Detail = _tmpSumm.InfoMoneyId_Detail_master
           AND _tmpMaster.ContainerId        = 0
          ;


         -- расчет с/с
         UPDATE _tmpMaster SET CalcSumm          = _tmpMaster.CalcSumm          + _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpMaster.CalcSumm_external + _tmpSumm.CalcSumm_external
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm

         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND _tmpMaster.ContainerId > 0
          ;

         -- расчет с/с
         UPDATE _tmpMaster SET CalcSumm          = _tmpMaster.CalcSumm          + _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpMaster.CalcSumm_external + _tmpSumm.CalcSumm_external
         FROM -- Сумма всех составляющих
              _tmpSumm_calc AS _tmpSumm

         WHERE _tmpMaster.AccountId          = _tmpSumm.AccountId_master
           AND _tmpMaster.UnitId             = _tmpSumm.UnitId_master
           AND _tmpMaster.GoodsId            = _tmpSumm.GoodsId_master
           AND _tmpMaster.GoodsKindId        = _tmpSumm.GoodsKindId_master
           AND _tmpMaster.JuridicalId_basis  = _tmpSumm.JuridicalId_basis_master
           AND _tmpMaster.InfoMoneyId        = _tmpSumm.InfoMoneyId_master
           AND _tmpMaster.InfoMoneyId_Detail = _tmpSumm.InfoMoneyId_Detail_master
           AND _tmpMaster.ContainerId        = 0
          ;


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
                     -- !!! временно, потом надо для всех
                     WHERE _tmpMaster.ContainerId > 0

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


if vbItearation <= 10
then
RAISE INFO ' vbCountDiff = <%> vbItearation = <%> CalcSumm = <%> + <%>', vbCountDiff, vbItearation
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 2019143)
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.GoodsId = 1560410 and _tmpMaster.GoodsKindId = 8346 and _tmpMaster.InfoMoneyId = 8962
   and _tmpMaster.InfoMoneyId_Detail = 8907 -- 8906
   and _tmpMaster.UnitId = zc_Unit_RK())
;

end if;

if vbItearation % 10 = 0 AND  vbItearation > 10
then
RAISE INFO ' vbCountDiff = <%> vbItearation = <%> CalcSumm = <%> + <%>', vbCountDiff, vbItearation
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 2019143)
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.GoodsId = 1560410 and _tmpMaster.GoodsKindId = 8346 and _tmpMaster.InfoMoneyId = 8962
   and _tmpMaster.InfoMoneyId_Detail = 8907 -- 8906
   and _tmpMaster.UnitId = zc_Unit_RK())
;

end if;


     END LOOP;


RAISE INFO ' end <%> итерация для всех.<%>', vbItearation, CLOCK_TIMESTAMP();

-- RAISE INFO 'CalcSumm = <%>  <%>'
-- , (select _tmpMaster.CalcSumm from _tmpMaster where _tmpMaster.ContainerId = 704771)
-- , (select _tmpSumm_calc.CalcSumm from _tmpSumm_calc where _tmpSumm_calc.ContainerId = 704771)
-- ;


IF inBranchId <= 0
THEN
     -- 1
     IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
     THEN
         DELETE FROM _tmpMaster_2024_07_;
     ELSE
         truncate table _tmpMaster_2024_07_;
     END IF;
     INSERT INTO _tmpMaster_2024_07_ (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm
                           , AccountId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail, JuridicalId_basis
                           , isZavod
                            )
        SELECT * FROM _tmpMaster;
END IF;

     /*IF EXISTS (select 1 from _tmpErr ) -- WHERE _tmpErr.ContainerId = 151207
     THEN
           -- test
           RAISE EXCEPTION 'Ошибка. <%>', (select count(*) from _tmpErr);
           RAISE EXCEPTION 'Ошибка. <%>   <%>   <%>', vbItearation, (select count(*) from _tmpErr) , (select STRING_AGG (_tmpErr.ContainerId :: TVarChar, ';') from _tmpErr order by 1 limit 1);
     END IF;*/

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


         -- Расчет - для селект - ФИЛИАЛЫ
         CREATE TEMP TABLE _tmpHistoryCost_insert ON COMMIT DROP
           AS (SELECT _tmpMaster.ContainerId
               FROM _tmpMaster
               WHERE _tmpMaster.ContainerId IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch)
              );
         -- !!!Оптимизация!!!
         ANALYZE _tmpHistoryCost_insert;


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
     ELSE -- IF inBranchId > 0


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


         -- предыдущая с/с, т.к. в этом периоде ошибка с зацикливанием при расчете цены
         INSERT INTO _tmpMaster (ContainerId, UnitId, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm)
            SELECT HistoryCost.ContainerId, _tmpErr.UnitId, 2, 1 * HistoryCost.Price, -1, 0, 0, 0, 0, 0, 0, 0
            FROM _tmpErr
                 JOIN HistoryCost ON HistoryCost.ContainerId = _tmpErr.ContainerId
                                 AND HistoryCost.StartDate   = DATE_TRUNC ('MONTH', inStartDate - INTERVAL '1 DAY')
        ;


RAISE INFO ' start INSERT INTO _tmpHistoryCost_PartionCell .<%>', CLOCK_TIMESTAMP();

         -- 1. для партионного учета - zc_Unit_RK
         INSERT INTO _tmpHistoryCost_PartionCell (UnitId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail
                                                , StartCount, StartSumm, IncomeCount, IncomeSumm
                                                , CalcCount, CalcSumm, CalcCount_external, CalcSumm_external
                                                , OutCount, OutSumm
                                                , AccountId, isInfoMoney_80401
                                                , JuridicalId_basis
                                                 )
            SELECT _tmpMaster.UnitId
                 , _tmpMaster.GoodsId
                 , _tmpMaster.GoodsKindId
                 , _tmpMaster.InfoMoneyId
                 , _tmpMaster.InfoMoneyId_Detail
                 , SUM (_tmpMaster.StartCount) AS StartCount, SUM (_tmpMaster.StartSumm) AS StartSumm, SUM (_tmpMaster.IncomeCount) AS IncomeCount, SUM (_tmpMaster.IncomeSumm) AS IncomeSumm
                 , SUM (_tmpMaster.CalcCount) AS CalcCount, SUM (_tmpMaster.CalcSumm) AS CalcSumm, SUM (_tmpMaster.CalcCount_external) AS CalcCount_external, SUM (_tmpMaster.CalcSumm_external) AS CalcSumm_external
                 , SUM (_tmpMaster.OutCount) AS OutCount, SUM (_tmpMaster.OutSumm) AS OutSumm
                 , _tmpMaster.AccountId
                 , COALESCE (_tmpMaster.isInfoMoney_80401, FALSE) AS isInfoMoney_80401
                 , _tmpMaster.JuridicalId_basis
            FROM _tmpMaster
            -- Розподільчий комплекс
            WHERE _tmpMaster.ContainerId = 0
              AND inStartDate       >= lfGet_Object_Unit_PartionDate_isPartionCell()
            GROUP BY _tmpMaster.UnitId
                   , _tmpMaster.GoodsId
                   , _tmpMaster.GoodsKindId
                   , _tmpMaster.InfoMoneyId
                   , _tmpMaster.InfoMoneyId_Detail
                   , _tmpMaster.AccountId
                   , COALESCE (_tmpMaster.isInfoMoney_80401, FALSE)
                   , _tmpMaster.JuridicalId_basis
                    ;

         -- для теста
         IF EXTRACT (MONTH FROM inStartDate) IN (5, 6, 7)
         THEN vbMONTH_str:= EXTRACT (MONTH FROM inStartDate) :: TVarChar;
         ELSE vbMONTH_str:= '7';
         END IF;
         -- для теста
         /*PERFORM gpExecSql ('\ _tmpMaster_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpMaster_2024_0 (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm
                           , AccountId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail, JuridicalId_basis
                           , isZavod)' || vbMONTH_str || ' select * from _tmpMaster', inSession);
         -- для теста
         PERFORM gpExecSql ('truncate table _tmpChild_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpChild_2024_0 (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount, isExternal, DescId
                              , AccountId, UnitId, GoodsId, GoodsKindId, JuridicalId_basis, InfoMoneyId, InfoMoneyId_Detail
                              , AccountId_master, UnitId_master, GoodsId_master, GoodsKindId_master, JuridicalId_basis_master, InfoMoneyId_master, InfoMoneyId_Detail_master)' || vbMONTH_str || ' select * from _tmpChild', inSession);
                              */
         -- для теста

         IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
         THEN
             PERFORM gpExecSql ('DELETE FROM _tmpHistoryCost_PartionCell_2024_0' || vbMONTH_str, inSession);
         ELSE
             PERFORM gpExecSql ('truncate table _tmpHistoryCost_PartionCell_2024_0' || vbMONTH_str, inSession);
         END IF;
         PERFORM gpExecSql ('insert into _tmpHistoryCost_PartionCell_2024_0' || vbMONTH_str || ' (UnitId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail
                                                , StartCount, StartSumm, IncomeCount, IncomeSumm
                                                , CalcCount, CalcSumm, CalcCount_external, CalcSumm_external
                                                , OutCount, OutSumm
                                                , AccountId, isInfoMoney_80401) select UnitId, GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail
                                                , StartCount, StartSumm, IncomeCount, IncomeSumm
                                                , CalcCount, CalcSumm, CalcCount_external, CalcSumm_external
                                                , OutCount, OutSumm
                                                , AccountId, isInfoMoney_80401 from _tmpHistoryCost_PartionCell', inSession);

-- return;

         -- для партионного учета
         IF inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
         AND 1=1
         THEN
 RAISE INFO ' start-1 создание ContainerSumm .<%>', CLOCK_TIMESTAMP();

         -- создание ContainerSumm
         CREATE TEMP TABLE _tmpContainerSumm_Goods_insert (UnitId                 Integer
                                                         , JuridicalId_basis      Integer
                                                         , AccountId              Integer
                                                         , InfoMoneyDestinationId Integer
                                                         , InfoMoneyId            Integer
                                                         , InfoMoneyId_Detail     Integer
                                                         , ContainerId_Goods      Integer
                                                         , GoodsId                Integer
                                                         , GoodsKindId            Integer
                                                         , PartionGoodsId         Integer
                                                         , AssetId                Integer
                                                          ) ON COMMIT DROP;
         -- создание ContainerSumm - tmpContainerSumm_Goods_insert_2024_07
         INSERT INTO _tmpContainerSumm_Goods_insert
             -- Результат
              SELECT tmpList_goods.UnitId
                   , tmpList_goods.JuridicalId_basis
                   , tmpList_goods.AccountId
                   , OL_InfoMoney_InfoMoneyDestination.ChildObjectId AS InfoMoneyDestinationId
                   , tmpList_goods.InfoMoneyId
                   , tmpList_goods.InfoMoneyId_Detail
                   , Container.Id                                    AS ContainerId_Goods
                   , tmpList_goods.GoodsId
                   , tmpList_goods.GoodsKindId
                   , CLO_PartionGoods.ObjectId                       AS PartionGoodsId
                   , CLO_Asset.ObjectId                              AS AssetId
              FROM (-- параметры для суммовых Container - zc_Unit_RK
                    SELECT DISTINCT tmpContainerList_partion.AccountId
                                  , tmpContainerList_partion.UnitId
                                  , tmpContainerList_partion.GoodsId
                                  , tmpContainerList_partion.GoodsKindId
                                  , tmpContainerList_partion.InfoMoneyId
                                  , tmpContainerList_partion.InfoMoneyId_Detail
                                  , tmpContainerList_partion.JuridicalId_basis

                    FROM tmpContainerList_partion
                    WHERE tmpContainerList_partion.GoodsKindId > 0
                       OR tmpContainerList_partion.InfoMoneyId = 8963 -- 30102 Тушенка
                   ) AS tmpList_goods
                   INNER JOIN Container ON Container.ObjectId = tmpList_goods.GoodsId
                                       AND Container.DescId   = zc_Container_Count()

                   -- !!!ограничили списком
                   INNER JOIN (SELECT DISTINCT tmpContainerList.ContainerId_count FROM tmpContainerList
                              ) AS tmpContainerList_check
                                ON tmpContainerList_check.ContainerId_count = Container.Id

                   INNER JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ObjectId    = tmpList_goods.UnitId


                   LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                 AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()

                   -- прочие
                   LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                    AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                   LEFT JOIN ContainerLinkObject AS CLO_Asset ON CLO_Asset.ContainerId = Container.Id
                                                             AND CLO_Asset.DescId      = zc_ContainerLinkObject_AssetTo()
                   LEFT JOIN ObjectLink AS OL_InfoMoney_InfoMoneyDestination ON OL_InfoMoney_InfoMoneyDestination.ObjectId = tmpList_goods.InfoMoneyId
                                                                            AND OL_InfoMoney_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()

                   -- существующие
                   LEFT JOIN (SELECT DISTINCT tmpContainerList_partion.ContainerId_count AS ContainerId
                                            , Container.ObjectId                         AS AccountId
                                            , CLO_Unit.ObjectId                          AS UnitId
                                            , CLO_Goods.ObjectId                         AS GoodsId
                                            , COALESCE (CLO_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , CLO_InfoMoney.ObjectId                     AS InfoMoneyId
                                            , CLO_InfoMoneyDetail.ObjectId               AS InfoMoneyId_Detail
                                            , CLO_JuridicalBasis.ObjectId                AS JuridicalId_basis

                              -- Список Количества - по ним есть движение за период
                              FROM (SELECT DISTINCT tmpContainerList_partion.ContainerId_count FROM tmpContainerList_partion) AS tmpContainerList_partion
                                   INNER JOIN Container ON Container.ParentId = tmpContainerList_partion.ContainerId_count
                                                       AND Container.DescId   = zc_Container_Summ()
                                   LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id
                                                                                 AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                   LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = Container.Id
                                                                                       AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                   LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = Container.Id
                                                                             AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                   LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                                 AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                   LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = Container.Id
                                                                            AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                   LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                                                      AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()
                             ) AS tmpList_check
                               ON tmpList_check.ContainerId        = Container.Id
                              AND tmpList_check.UnitId             = tmpList_goods.UnitId
                              AND tmpList_check.JuridicalId_basis  = tmpList_goods.JuridicalId_basis
                              AND tmpList_check.AccountId          = tmpList_goods.AccountId
                              AND tmpList_check.InfoMoneyId        = tmpList_goods.InfoMoneyId
                              AND tmpList_check.InfoMoneyId_Detail = tmpList_goods.InfoMoneyId_Detail
                              AND tmpList_check.GoodsId            = tmpList_goods.GoodsId
                              AND tmpList_check.GoodsKindId        = tmpList_goods.GoodsKindId

              WHERE COALESCE (CLO_GoodsKind.ObjectId, 0)  = COALESCE (tmpList_goods.GoodsKindId, 0)
                AND tmpList_check.ContainerId IS NULL
             ;

              IF EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) < 8 AND EXTRACT (HOUR FROM CLOCK_TIMESTAMP()) > 0
              THEN
                  DELETE FROM _tmpContainerSumm_Goods_insert_2024_07;
              ELSE
                  truncate table _tmpContainerSumm_Goods_insert_2024_07;
              END IF;

              --
              INSERT INTO _tmpContainerSumm_Goods_insert_2024_07 SELECT * FROM _tmpContainerSumm_Goods_insert;


RAISE INFO ' start-2 создание ContainerSumm .<%>', CLOCK_TIMESTAMP();
              -- сквозное создание ContainerSumm
              PERFORM lpInsertUpdate_ContainerSumm_Goods (inOperDate               := inStartDate
                                                        , inUnitId                 := _tmpContainerSumm_Goods_insert.UnitId
                                                        , inCarId                  := NULL
                                                        , inMemberId               := NULL
                                                        , inBranchId               := zc_Branch_Basis()
                                                        , inJuridicalId_basis      := _tmpContainerSumm_Goods_insert.JuridicalId_basis
                                                        , inBusinessId             := NULL
                                                        , inAccountId              := _tmpContainerSumm_Goods_insert.AccountId
                                                        , inInfoMoneyDestinationId := _tmpContainerSumm_Goods_insert.InfoMoneyDestinationId
                                                        , inInfoMoneyId            := _tmpContainerSumm_Goods_insert.InfoMoneyId
                                                        , inInfoMoneyId_Detail     := _tmpContainerSumm_Goods_insert.InfoMoneyId_Detail
                                                        , inContainerId_Goods      := _tmpContainerSumm_Goods_insert.ContainerId_Goods
                                                        , inGoodsId                := _tmpContainerSumm_Goods_insert.GoodsId
                                                        , inGoodsKindId            := _tmpContainerSumm_Goods_insert.GoodsKindId
                                                        , inIsPartionSumm          := NULL
                                                        , inPartionGoodsId         := _tmpContainerSumm_Goods_insert.PartionGoodsId
                                                        , inAssetId                := _tmpContainerSumm_Goods_insert.AssetId
                                                         )
              FROM _tmpContainerSumm_Goods_insert
             ;


         END IF; -- if inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell() - lpInsertUpdate_ContainerSumm_Goods


IF 1=1 AND 0 < (select COUNT(*) -- Container_2.Id as ContainerId
                from Container
                     left join ContainerLinkObject as CLO_0 on CLO_0.ContainerId = Container.Id and CLO_0.DescId = zc_ContainerLinkObject_Account()
                     inner join ContainerLinkObject as CLO_1 on CLO_1.ContainerId = Container.Id and CLO_1.DescId = zc_ContainerLinkObject_Unit() and CLO_1.ObjectId = zc_Unit_rk()
                     left join ContainerLinkObject as CLO_2 on CLO_2.ContainerId = Container.Id and CLO_2.DescId = zc_ContainerLinkObject_PartionGoods()

                     join Container as Container_2 on Container_2.ParentId = Container.Id
                                                  and Container_2.DescId = 2
                     left join ContainerLinkObject as CLO_22 on CLO_22.ContainerId = Container_2.Id and CLO_22.DescId = zc_ContainerLinkObject_PartionGoods()
                     -- left join Container_err_2024_08 on Container_err_2024_08.ContainerId = Container_2.Id
                where Container.DescId = 1
                  and coalesce (CLO_22.ObjectId, 0) <> coalesce (CLO_2.ObjectId, 0)
                  -- and Container_err_2024_08.ContainerId is null
                  and CLO_0.ObjectId is null
               )
THEN
    RAISE EXCEPTION 'Ошибка.<%> and 0'
    --RAISE INFO 'Ошибка.<%> and 0'
, (select COUNT(*) -- Container_2.Id as ContainerId
from Container
left join ContainerLinkObject as CLO_0 on CLO_0.ContainerId = Container.Id and CLO_0.DescId = zc_ContainerLinkObject_Account()

join ContainerLinkObject as CLO_1 on CLO_1.ContainerId = Container.Id and CLO_1.DescId = zc_ContainerLinkObject_Unit() and CLO_1.ObjectId = zc_Unit_rk()
left join ContainerLinkObject as CLO_2 on CLO_2.ContainerId = Container.Id and CLO_2.DescId = zc_ContainerLinkObject_PartionGoods()
join Container as Container_2 on Container_2.ParentId = Container.Id
                             and Container_2.DescId = 2
left join ContainerLinkObject as CLO_22 on CLO_22.ContainerId = Container_2.Id and CLO_22.DescId = zc_ContainerLinkObject_PartionGoods()
-- left join Container_err_2024_08 on Container_err_2024_08.ContainerId = Container_2.Id
where Container.DescId = 1
and coalesce (CLO_22.ObjectId, 0) <> coalesce (CLO_2.ObjectId, 0)
-- and Container_err_2024_08.ContainerId is null
and CLO_0.ObjectId is null
/*
                                           AND Container_2.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                           AND Container_2.ObjectId <> zc_Enum_Account_110102()
                                           AND Container_2.ObjectId <> zc_Enum_Account_110111()
                                           AND Container_2.ObjectId <> zc_Enum_Account_110112()
                                           AND Container_2.ObjectId <> zc_Enum_Account_110121()
                                           AND Container_2.ObjectId <> zc_Enum_Account_110122()
                                           AND Container_2.ObjectId <> zc_Enum_Account_110131()
                                           AND Container_2.ObjectId <> zc_Enum_Account_110132()
*/
);

END IF;


RAISE INFO ' start - 1 del .<%>', CLOCK_TIMESTAMP();
         -- запомнили время начала Следующего действия
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

         -- !!!Оптимизация!!!
         ANALYZE _tmpContainer_branch;
         -- Расчет
         CREATE TEMP TABLE _tmpHistoryCost_del ON COMMIT DROP
           AS (SELECT HistoryCost.ContainerId
               FROM HistoryCost
                    LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = HistoryCost.ContainerId
               WHERE HistoryCost.StartDate       = inStartDate -- IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
               --AND HistoryCost.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch)
                 AND _tmpContainer_branch.ContainerId IS NULL
              );
         -- !!!Оптимизация!!!
         ANALYZE _tmpHistoryCost_del;

RAISE INFO ' start - 2 del .<%>', CLOCK_TIMESTAMP();

         -- Удаляем предыдущую с/с - !!!кроме всех Филиалов!!!
         DELETE FROM HistoryCost -- WHERE ((HistoryCost.StartDate BETWEEN inStartDate AND inEndDate) OR (HistoryCost.EndDate BETWEEN inStartDate AND inEndDate))
                                 WHERE HistoryCost.StartDate       = inStartDate -- IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
                                   -- !!!временно для '08.2023'!!!
                                 /*AND HistoryCost.ContainerId NOT IN (SELECT DISTINCT HistoryCost.ContainerId
                                                                       FROM Container AS Container_Summ
                                                                            INNER JOIN Container ON Container.Id = Container_Summ.ParentId
                                                                                                AND Container.ObjectId = 6883420
                                                                            INNER JOIN HistoryCost ON HistoryCost.ContainerId  = Container_Summ.Id
                                                                                                  AND HistoryCost.StartDate     = 20:13 15.09.2023
                                                                       WHERE Container_Summ.DescId = zc_Container_Summ()
                                                                        AND inStartDate = '01.08.2023'
                                                                      )*/
                                   --
                                   AND HistoryCost.ContainerId IN (SELECT DISTINCT _tmpHistoryCost_del.ContainerId FROM _tmpHistoryCost_del);
                                   -- AND HistoryCost.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
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


RAISE INFO ' start-1 insert .<%>', CLOCK_TIMESTAMP();
         -- Расчет
         CREATE TEMP TABLE _tmpHistoryCost_insert ON COMMIT DROP
           AS (SELECT _tmpMaster.ContainerId
               FROM _tmpMaster
                    LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = _tmpMaster.ContainerId
               WHERE _tmpMaster.ContainerId > 0
               --AND _tmpMaster.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch)
                 AND _tmpContainer_branch.ContainerId IS NULL
              );
         -- !!!Оптимизация!!!
         ANALYZE _tmpHistoryCost_insert;

RAISE INFO ' start-2 insert .<%>', CLOCK_TIMESTAMP();
         -- Сохраняем что насчитали - !!!кроме всех Филиалов!!!
         INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
            WITH
           -- !!! error - 15.06.2024!!!
           tmp AS (with tmp_1 AS (SELECT Container.*
                                  FROM Container
                                       INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                      ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                     AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                     AND ContainerLinkObject_Unit.ObjectId IN (8450) -- Дільниця термічної обробки
                                  WHERE Container.DescId = zc_Container_Count()
                                    AND Container.ObjectId in (3569176  -- 953
                                                              )
                                    AND 1=0
                                 )
                      SELECT Container.Id
                      FROM Container
                      WHERE Container.DescId = zc_Container_Summ()
                        AND Container.ParentId in (SELECT tmp_1.Id FROM tmp_1)
                        AND 1=0
                  )

            SELECT DISTINCT
                  _tmpMaster.ContainerId, inStartDate AS StartDate
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
            WHERE _tmpMaster.ContainerId > 0
              AND _tmpMaster.ContainerId IN (SELECT DISTINCT _tmpHistoryCost_insert.ContainerId FROM _tmpHistoryCost_insert)
            --AND _tmpMaster.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch)

           UNION ALL
            -- 2. для партионного учета - Розподільчий комплекс
            SELECT Container.Id AS ContainerId, inStartDate AS StartDate
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

                 , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount
                 , _tmpMaster.CalcSumm, _tmpMaster.CalcCount_external, _tmpMaster.CalcSumm_external
                 , _tmpMaster.OutCount, _tmpMaster.OutSumm

                 , 0 AS MovementItemId_diff, 0 AS Summ_diff

            FROM _tmpHistoryCost_PartionCell AS _tmpMaster

                 JOIN Container ON Container.ObjectId = _tmpMaster.AccountId
                               AND Container.DescId   = zc_Container_Summ()
                               -- только этот список
                               AND Container.ParentId IN (SELECT DISTINCT tmpContainerList_partion.ContainerId_count FROM tmpContainerList_partion
                                                         UNION
                                                          SELECT DISTINCT _tmpContainerSumm_Goods_insert.ContainerId_Goods FROM _tmpContainerSumm_Goods_insert
                                                         )


                 INNER JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = Container.Id
                                               AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                               AND CLO_Goods.ObjectId    = _tmpMaster.GoodsId
                 INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ContainerId = Container.Id
                                               AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                               -- !!! Розподільчий комплекс
                                               AND CLO_Unit.ObjectId    = _tmpMaster.UnitId

                 LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                               ON CLO_GoodsKind.ContainerId = Container.Id
                                              AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                               ON CLO_InfoMoney.ContainerId = Container.Id
                                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                               ON CLO_InfoMoneyDetail.ContainerId = Container.Id
                                              AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()

                 LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                               ON CLO_JuridicalBasis.ContainerId = Container.Id
                                              AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()

            WHERE _tmpMaster.GoodsKindId        = COALESCE (CLO_GoodsKind.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId        = COALESCE (CLO_InfoMoney.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId_Detail = COALESCE (CLO_InfoMoneyDetail.ObjectId, 0)
              AND _tmpMaster.JuridicalId_basis  = COALESCE (CLO_JuridicalBasis.ObjectId, 0)

              -- !!!
              AND inStartDate    >= lfGet_Object_Unit_PartionDate_isPartionCell()
             ;

     END IF; -- else IF inBranchId > 0


RAISE INFO ' end INSERT INTO HistoryCost .<%>', CLOCK_TIMESTAMP();

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

     /*ELSE

         -- для теста
         IF EXTRACT (MONTH FROM inStartDate) IN (5, 6, 7)
         THEN vbMONTH_str:= EXTRACT (MONTH FROM inStartDate) :: TVarChar;
         ELSE vbMONTH_str:= '5';
         END IF;
         -- для теста
         PERFORM gpExecSql ('truncate table _tmpMaster_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpMaster_2024_0' || vbMONTH_str || ' select * from _tmpMaster', inSession);
         -- для теста
         PERFORM gpExecSql ('truncate table _tmpChild_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpChild_2024_0' || vbMONTH_str || ' select * from _tmpChild', inSession);
         -- для теста
         PERFORM gpExecSql ('truncate table _tmpHistoryCost_PartionCell_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpHistoryCost_PartionCell_2024_0' || vbMONTH_str || ' select * from _tmpHistoryCost_PartionCell', inSession);*/


     ELSE

         -- Расчет - для селект - ФИЛИАЛЫ
         CREATE TEMP TABLE _tmpHistoryCost_insert ON COMMIT DROP
           AS (SELECT _tmpMaster.ContainerId
               FROM _tmpMaster
              );
         -- !!!Оптимизация!!!
         ANALYZE _tmpHistoryCost_insert;

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
             , _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.AccountId, _tmpMaster.JuridicalId_basis

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
                     WHERE _tmpMaster.ContainerId > 0
                       AND _tmpMaster.ContainerId IN (SELECT DISTINCT _tmpHistoryCost_insert.ContainerId FROM _tmpHistoryCost_insert)
                    ) AS _tmpPrice
                    JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                  -- Отбрасываем в том случае если сам в себя
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
               GROUP BY _tmpChild.MasterContainerId
--                      , _tmpChild.ContainerId
              ) AS _tmpSumm ON _tmpMaster.ContainerId = _tmpSumm.ContainerId
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpMaster.UnitId

         WHERE _tmpMaster.ContainerId > 0
           AND _tmpMaster.ContainerId IN (SELECT DISTINCT _tmpHistoryCost_insert.ContainerId FROM _tmpHistoryCost_insert)

       UNION ALL
         -- 2. для партионного учета - Розподільчий комплекс
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
             , 0 :: TFloat AS PriceNext

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
             , 0 :: TFloat AS PriceNext_external

             , 0 :: Integer AS FromContainerId
             , 0 :: Integer AS ContainerId
             , _tmpMaster.GoodsId, _tmpMaster.GoodsKindId, _tmpMaster.InfoMoneyId, _tmpMaster.InfoMoneyId_Detail, _tmpMaster.AccountId, _tmpMaster.JuridicalId_basis
             , _tmpMaster.isInfoMoney_80401
             , _tmpMaster.CalcSumm          AS CalcSummCurrent,          0 :: TFloat AS CalcSummNext
             , _tmpMaster.CalcSumm_external AS CalcSummCurrent_external, 0 :: TFloat AS CalcSummNext_external
             , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpMaster.CalcCount_external, _tmpMaster.CalcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm
             , _tmpMaster.UnitId
             , Object_Unit.ValueData AS UnitName

         FROM _tmpHistoryCost_PartionCell AS _tmpMaster
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpMaster.UnitId

        ;


     END IF; -- if inInsert <> 12345

IF inBranchId <= 0
THEN

RAISE INFO ' start delete err HistoryCost.<%>', CLOCK_TIMESTAMP();

RAISE INFO ' count delete = .<%>', (select Count(*) FROM HistoryCost
                                    WHERE HistoryCost.StartDate = inStartDate
                                      and HistoryCost.ContainerId in (select Container_2.Id
                                                                      from Container
                                                                           join ContainerLinkObject as CLO_1 on CLO_1.ContainerId = Container.Id and CLO_1.DescId = zc_ContainerLinkObject_Unit() and CLO_1.ObjectId = zc_Unit_rk()
                                                                           left join ContainerLinkObject as CLO_2 on CLO_2.ContainerId = Container.Id and CLO_2.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                           join Container as Container_2 on Container_2.ParentId = Container.Id
                                                                                                        and Container_2.DescId = 2
                                                                           left join ContainerLinkObject as CLO_22 on CLO_22.ContainerId = Container_2.Id and CLO_22.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                      where Container.DescId = 1
                                                                      and coalesce (CLO_22.ObjectId, 0) <> coalesce (CLO_2.ObjectId, 0)
                                                                     )
                                   );

delete FROM HistoryCost WHERE HistoryCost.StartDate = inStartDate and HistoryCost.ContainerId
in (
select Container_2.Id
from Container
join ContainerLinkObject as CLO_1 on CLO_1.ContainerId = Container.Id and CLO_1.DescId = zc_ContainerLinkObject_Unit() and CLO_1.ObjectId = zc_Unit_rk()
left join ContainerLinkObject as CLO_2 on CLO_2.ContainerId = Container.Id and CLO_2.DescId = zc_ContainerLinkObject_PartionGoods()
join Container as Container_2 on Container_2.ParentId = Container.Id
                             and Container_2.DescId = 2
left join ContainerLinkObject as CLO_22 on CLO_22.ContainerId = Container_2.Id and CLO_22.DescId = zc_ContainerLinkObject_PartionGoods()
where Container.DescId = 1
and coalesce (CLO_22.ObjectId, 0) <> coalesce (CLO_2.ObjectId, 0)
);


RAISE INFO ' end all HistoryCost.<%>', CLOCK_TIMESTAMP();

END IF;

--    RAISE EXCEPTION 'Ошибка.<ok>';



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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpinsertupdate_historycost(tdatetime, tdatetime, integer, integer, integer, tfloat, tvarchar)
  OWNER TO project;
