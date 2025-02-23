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
  RETURNS TABLE(vbitearation integer, vbcountdiff integer, price tfloat, pricenext tfloat, price_external tfloat, pricenext_external tfloat, fromcontainerid integer, containerid integer, isinfomoney_80401 boolean, calcsummcurrent tfloat, calcsummnext tfloat, calcsummcurrent_external tfloat, calcsummnext_external tfloat, startcount tfloat, startsumm tfloat, incomecount tfloat, incomesumm tfloat, calccount tfloat, calcsumm tfloat, calccount_external tfloat, calcsumm_external tfloat, outcount tfloat, outsumm tfloat, unitid integer, unitname tvarchar) AS
$BODY$
   DECLARE vbStartDate_zavod TDateTime;
   DECLARE vbEndDate_zavod   TDateTime;

   DECLARE vbItearation Integer;
   DECLARE vbCountDiff  Integer;

   DECLARE vbItearationCount_err Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
   
   DECLARE vbExec_str TVarChar;
   DECLARE vbMONTH_str TVarChar;
BEGIN
  RAISE INFO ' Start = <%> ', CLOCK_TIMESTAMP();
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());

     -- !!!�����!!!
     -- IF inStartDate >= '01.03.2020' THEN RETURN; END IF;
     -- IF inBranchId IN (8379, 3080683) THEN RETURN; END IF;
     -- IF inBranchId IN (0) THEN RETURN; END IF;

     --if inItearationCount > 1 then inItearationCount:= 0;  END IF;

     IF inItearationCount > 80 THEN inItearationCount:= 80; END IF;
     inDiffSumm       := 0.009;

     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- ������ ����, ���� ����� �� ������
     IF     -- ���� � "�������" ������
            EXTRACT ('MONTH' FROM inStartDate) = EXTRACT ('MONTH' FROM CURRENT_DATE - INTERVAL '0 DAY')
            -- ����� 12:00
        AND EXTRACT (HOUR FROM CURRENT_TIMESTAMP) >= 12
     THEN
         -- ���� ����� -1 ����
         inEndDate:= CURRENT_DATE - INTERVAL '1 DAY';

     ELSEIF -- ���� � "�������" ������
            EXTRACT ('MONTH' FROM inStartDate) = EXTRACT ('MONTH' FROM CURRENT_DATE - INTERVAL '1 DAY')
            -- �� 12:00
        AND EXTRACT (HOUR FROM CURRENT_TIMESTAMP) < 12
     THEN
         -- ���� ����� -2 ����
         inEndDate:= CURRENT_DATE - INTERVAL '2 DAY';
     END IF;


     -- !!!��������!!!
     /*IF inStartDate >= '01.02.2018' THEN
          return;
     END IF;*/


     -- IF inBranchId <> 8379 THEN RETURN; END IF; -- ������ ����
     -- IF inBranchId <> 3080683 AND inStartDate = '01.06.2019' THEN RETURN; END IF; -- ������ �����
     -- IF inBranchId <> 0 THEN RETURN; END IF;


     vbItearationCount_err:= 5;

     --inItearationCount:= 50;


-- !!!��������!!!
-- IF inStartDate = '01.01.2017' THEN inItearationCount:= 100; END IF;
-- IF inItearationCount >= 800 THEN inItearationCount:= 400; END IF;
-- !!!��������!!!

     -- !!!���� �� ������, ����� ��������� ���� ������ 1-�� ����� ������!!!
     vbStartDate_zavod:= DATE_TRUNC ('MONTH', inStartDate);
     -- !!!���� �� ������, ����� �������� ���� ������ ��������� ����� ������!!!
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
     -- ������� - ������ ��������� ������� �������� ���������� �/�.
     CREATE TEMP TABLE _tmpMaster (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMaster_err (ContainerId Integer, UnitId Integer, isInfoMoney_80401 Boolean, StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat) ON COMMIT DROP;
     -- ������� - ������� ��� Master
     CREATE TEMP TABLE _tmpChild (MasterContainerId Integer, ContainerId Integer, MasterContainerId_Count Integer, ContainerId_Count Integer, OperCount TFloat, isExternal Boolean, DescId Integer) ON COMMIT DROP;
     -- ������� - "����������"
     --* CREATE TEMP TABLE _tmpDiff (ContainerId Integer, MovementItemId_diff Integer, Summ_diff TFloat) ON COMMIT DROP;

     CREATE TEMP TABLE _tmpHistoryCost_PartionCell (GoodsId Integer, GoodsKindId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                                                  , StartDate TDateTime, EndDate TDateTime
                                                  , Price TFloat, Price_external TFloat
                                                  , StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat
                                                  , CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, CalcSumm_external TFloat
                                                  , OutCount TFloat, OutSumm TFloat
                                                  , AccountId Integer, isInfoMoney_80401 Boolean
                                                   ) ON COMMIT DROP;


     -- ������� - ������ ������ + ������ ���������
     CREATE TEMP TABLE _tmpUnit_branch (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_branch (UnitId)
        SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE COALESCE (inBranchId, 0) <= 0
          -- AND ObjectLink_Unit_Branch.ChildObjectId <> zc_Branch_Basis()
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          AND ObjectLink_Unit_Branch.ChildObjectId IN (8374    -- 4. ������ ������
                                                     , 301310  -- 11. ������ ���������
                                                     , 8373    -- 3. ������ �������� (������)
                                                     , 8375    -- 5. ������ �������� (����������)
                                                     , 8377    -- 7. ������ ��.���
                                                     , 8381    -- 9. ������ �������
                                                     , 8379    -- 2. ������ ����
                                                     , 3080683 -- ������ �����
                                                      )
      UNION
       SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE inBranchId > 0
          AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
       ;

     -- ������� - ��������� �������
     /*CREATE TEMP TABLE _tmpUnit_branch_oth (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_branch_oth (UnitId)
        SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
        FROM ObjectLink AS ObjectLink_Unit_Branch
        WHERE inBranchId > 0
          AND ObjectLink_Unit_Branch.ObjectId NOT IN (SELECT _tmpUnit_branch.UnitId FROM _tmpUnit_branch)
          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          AND ObjectLink_Unit_Branch.ChildObjectId IN (8374    -- 4. ������ ������
                                                     , 301310  -- 11. ������ ���������
                                                     , 8373    -- 3. ������ �������� (������)
                                                     , 8375    -- 5. ������ �������� (����������)
                                                     , 8377    -- 7. ������ ��.���
                                                     , 8381    -- 9. ������ �������
                                                     , 8379    -- 2. ������ ����
                                                     , 3080683 -- ������ �����
                                                      )
       ;*/

     -- ������� - ������ ������ + ������ ���������
     CREATE TEMP TABLE _tmpContainer_branch (ContainerId Integer) ON COMMIT DROP;
     INSERT INTO _tmpContainer_branch (ContainerId)
        SELECT ContainerLinkObject.ContainerId
        FROM _tmpUnit_branch
             INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                           AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
       ;


     -- ��������� ������� ���������� � ����� - ���, ������, ������
       WITH tmpContainerS_zavod AS (SELECT Container_Summ.*
                                    FROM Container AS Container_Summ
                                         LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = Container_Summ.Id
                                    WHERE _tmpContainer_branch.ContainerId IS NULL
                                      AND Container_Summ.DescId = zc_Container_Summ()
                                      AND Container_Summ.ParentId > 0
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- ������ + ��������� ����
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- ������� + ����� � ����
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
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- ������ + ��������� ����
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- ������� + ����� � ����
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                      AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
                                   )
           , tmpContainerList AS (SELECT Container_Summ.Id, Container_Summ.ParentId, Container_Summ.ObjectId
                                  FROM tmpContainerS_zavod AS Container_Summ
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container_Summ.Id
                                                                      AND MIContainer.OperDate >= vbStartDate_zavod
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110101() -- ������� + ����� � ����
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                  WHERE Container_Summ.DescId = zc_Container_Summ()
                                    AND Container_Summ.ParentId > 0
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- ������ + ��������� ����
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- ������� + ����� � ����
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
                                  GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount, Container_Summ.ObjectId
                                  HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0 -- AS StartSumm
                                      OR MAX (CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_zavod AND vbEndDate_zavod THEN Container_Summ.Id ELSE 0 END) > 0
                                 UNION ALL
                                  SELECT Container_Summ.Id, Container_Summ.ParentId, Container_Summ.ObjectId
                                  FROM tmpContainerS_branch AS Container_Summ
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container_Summ.Id
                                                                      AND MIContainer.OperDate >= inStartDate
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110101() -- ������� + ����� � ����
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110102()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110111()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110112()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110121()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110122()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110131()
                                                                      AND MIContainer.AccountId <> zc_Enum_Account_110132()
                                  WHERE Container_Summ.DescId = zc_Container_Summ()
                                    AND Container_Summ.ParentId > 0
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_20901()  -- ������ + ��������� ����
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- ������� + ����� � ����
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110102()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110111()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110112()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110121()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110122()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110131()
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110132()
                                  GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount, Container_Summ.ObjectId
                                  HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0 -- AS StartSumm
                                      OR MAX (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN Container_Summ.Id ELSE 0 END) > 0
                                 )
     , tmpContainer_zavod AS (SELECT Container.*, COALESCE (Object_Unit.Id, 0) AS UnitId
                                   , CASE WHEN 1 = 1 AND ObjectLink_Unit_HistoryCost.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isHistoryCost_ReturnIn
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
                                  OR (Container.DescId = zc_Container_Summ() AND Container.ParentId > 0
                                  AND Container.ObjectId <> zc_Enum_Account_110101() -- ������� + ����� � ����
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
                                  AND Container.ObjectId <> zc_Enum_Account_110101() -- ������� + ����� � ����
                                    AND Container.ObjectId <> zc_Enum_Account_110102()
                                    AND Container.ObjectId <> zc_Enum_Account_110111()
                                    AND Container.ObjectId <> zc_Enum_Account_110112()
                                    AND Container.ObjectId <> zc_Enum_Account_110121()
                                    AND Container.ObjectId <> zc_Enum_Account_110122()
                                    AND Container.ObjectId <> zc_Enum_Account_110131()
                                    AND Container.ObjectId <> zc_Enum_Account_110132()
                                    ))
                             )
       -- , tmpAccount_60000 AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- ������� ������� ��������
      , tmpMIFloat_Summ AS (SELECT MIFloat_Summ.MovementItemId, MIFloat_Summ.DescId, MIFloat_Summ.ValueData
                            FROM MovementItem
                                 JOIN Movement ON Movement.Id = MovementItem.MovementId
                                              AND Movement.OperDate between inStartDate AND  inEndDate
                                              AND Movement.DescId  = zc_Movement_Inventory()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                             ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                            /*WHERE MovementItem.MovementId = 24210332 -- ��� �������� - 30.12.2022
                              AND MovementItem.DescId = zc_MI_Master()*/
                              AND MovementItem.isErased = FALSE
                              -- AND inEndDate < '01.01.2023'
                           )


     INSERT INTO _tmpMaster (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
        SELECT COALESCE (Container_Summ.Id, tmpContainer.ContainerId) AS ContainerId
             , tmpContainer.UnitId AS UnitId
             , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401()
                         THEN TRUE
                    ELSE FALSE
               END AS isInfoMoney_80401 -- ������� �������� �������

             , SUM (tmpContainer.StartCount) AS StartCount
             , SUM (tmpContainer.StartSumm)  AS StartSumm
             , SUM (tmpContainer.IncomeCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                             THEN tmpContainer.SendOnPriceCountIn_Cost
                                                          ELSE CASE WHEN inBranchId > 0 THEN 0 ELSE tmpContainer.SendOnPriceCountIn END
                                                     END)
                                              + SUM (CASE WHEN tmpContainer.isHistoryCost_ReturnIn = TRUE
                                                             THEN tmpContainer.ReturnInCount
                                                          ELSE 0
                                                     END) AS IncomeCount
             , SUM (tmpContainer.IncomeSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                              THEN tmpContainer.SendOnPriceSummIn_Cost
                                                         ELSE CASE WHEN inBranchId > 0 THEN 0 ELSE tmpContainer.SendOnPriceSummIn END
                                                    END)
                                              + SUM (CASE WHEN tmpContainer.isHistoryCost_ReturnIn = TRUE
                                                             THEN tmpContainer.ReturnInSumm
                                                          ELSE 0
                                                     END) AS IncomeSumm
             , SUM (tmpContainer.calcCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                             THEN 0
                                                          ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceCountIn ELSE 0 END
                                                     END) AS calcCount
             , SUM (tmpContainer.calcSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                              THEN 0
                                                         ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceSummIn ELSE 0 END
                                                    END) AS calcSumm

             , SUM (tmpContainer.calcCount_external) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                             THEN 0
                                                          ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceCountIn ELSE 0 END
                                                     END) AS calcCount_external
             , SUM (tmpContainer.calcSumm_external) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                              THEN 0
                                                         ELSE CASE WHEN inBranchId > 0 THEN tmpContainer.SendOnPriceSummIn ELSE 0 END
                                                    END) AS calcSumm_external

             , SUM (tmpContainer.OutCount) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                            THEN tmpContainer.SendOnPriceCountOut_Cost
                                                       ELSE tmpContainer.SendOnPriceCountOut
                                                  END) AS OutCount
             , SUM (tmpContainer.OutSumm) + SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
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

                     -- <> ������� + ����� � ����
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
                     -- Calc_external, �.�. AnalyzerId <> UnitId
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
                                                  -- AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_110101() -- ������� + ����� � ����
                   LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                             ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                            AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                ON MovementLinkObject_User.MovementId = MIContainer.MovementId
                                               AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                   LEFT JOIN tmpMIFloat_Summ AS MIFloat_Summ
                                             ON MIFloat_Summ.MovementItemId = MIContainer.MovementItemId
                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                          --AND MIContainer.MovementId = 24210332 -- ��� �������� - 30.12.2022

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

                     -- <> ������� + ����� � ����
                   , SUM (CASE WHEN Container.DescId = zc_Container_Count()
                               THEN CASE /*WHEN MIContainer.WhereObjectId_Analyzer IN (SELECT _tmpUnit_branch.UnitId     FROM _tmpUnit_branch)
                                          AND MIContainer.ObjectExtId_Analyzer   IN (SELECT _tmpUnit_branch_oth.UnitId FROM _tmpUnit_branch_oth)
                                          AND MIContainer.isActive               = FALSE
                                              THEN 0*/
                                         WHEN MLO_From.ObjectId                  = 3080691 -- ����� �� �.�����"
                                          AND MLO_To.ObjectId                    = 8411    -- ����� �� �.����"
                                        --AND MIContainer.WhereObjectId_Analyzer = 8411    -- ����� �� �.����"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- ����� �� �.�����"
                                          AND inBranchId                         = 8379    -- ������ ����
                                        -- AND MovementBoolean_HistoryCost.ValueData = TRUE
                                        --AND MIContainer.isActive               = TRUE
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MLO_From.ObjectId                  = 8411    -- ����� �� �.����"
                                          AND MLO_To.ObjectId                    = 3080691 -- ����� �� �.�����"
                                        --AND MIContainer.WhereObjectId_Analyzer = 3080691 -- ����� �� �.�����"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 8411    -- ����� �� �.����"
                                          AND inBranchId                         = 3080683 -- ������ �����
                                        -- AND MovementBoolean_HistoryCost.ValueData = TRUE
                                        --AND MIContainer.isActive               = TRUE
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN MIContainer.Amount

                                         WHEN MIContainer.WhereObjectId_Analyzer = 8411    -- ����� �� �.����"
                                          AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- ����� �� �.�����"
                                          AND inBranchId                         = 8379    -- ������ ����
                                          AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN 0

                                         WHEN MIContainer.WhereObjectId_Analyzer = 3080691 -- ����� �� �.�����"
                                          AND MIContainer.ObjectExtId_Analyzer   = 8411    -- ����� �� �.����"
                                          AND inBranchId                         = 3080683 -- ������ �����
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
                                         WHEN MLO_From.ObjectId                  = 3080691 -- ����� �� �.�����"
                                          AND MLO_To.ObjectId                    = 8411    -- ����� �� �.����"
                                        --AND MIContainer.WhereObjectId_Analyzer = 8411    -- ����� �� �.����"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- ����� �� �.�����"
                                          AND inBranchId                         = 8379    -- ������ ����
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

                                         WHEN MLO_From.ObjectId                  = 8411    -- ����� �� �.����"
                                          AND MLO_To.ObjectId                    = 3080691 -- ����� �� �.�����"
                                        --AND MIContainer.WhereObjectId_Analyzer = 3080691 -- ����� �� �.�����"
                                        --AND MIContainer.ObjectExtId_Analyzer   = 8411    -- ����� �� �.����"
                                          AND inBranchId                         = 3080683 -- ������ �����
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

                                         WHEN MIContainer.WhereObjectId_Analyzer = 8411    -- ����� �� �.����"
                                          AND MIContainer.ObjectExtId_Analyzer   = 3080691 -- ����� �� �.�����"
                                          AND inBranchId                         = 8379    -- ������ ����
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
                                         WHEN MIContainer.WhereObjectId_Analyzer = 3080691 -- ����� �� �.�����"
                                          AND MIContainer.ObjectExtId_Analyzer   = 8411    -- ����� �� �.����"
                                          AND inBranchId                         = 3080683 -- ������ �����
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
                     -- Calc_external, �.�. AnalyzerId <> UnitId
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
                                                  -- AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_110101() -- ������� + ����� � ����

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
                                AND Container_Summ.ObjectId <> zc_Enum_Account_20901() -- "��������� ����"
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
               , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401() OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- ������� �������� �������
                           THEN TRUE
                      ELSE FALSE
                 END
       ;

-- INSERT INTO _tmpMaster (ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
--    RAISE EXCEPTION '������.<%>', (select _tmpMaster.IncomeCount from _tmpMaster where _tmpMaster.ContainerId = 156902)
--    , (select _tmpMaster.IncomeSumm from _tmpMaster where _tmpMaster.ContainerId = 156902)
--    ;


     -- !!!�����������!!!
     ANALYZE _tmpMaster;
     -- ANALYZE _tmpContainer_branch;

     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "��������" FieldValue = "end - INSERT INTO _tmpMaster"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Itearation" FieldValue = "0"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
           , TRUE;
     -- ��������� ����� ������ ���������� ��������
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- ����***
     /*IF inBranchId = 0 THEN DELETE FROM HistoryCost_test; END IF;
     INSERT INTO HistoryCost_test (InsertDate, Itearation, CountDiff, ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
        SELECT CURRENT_TIMESTAMP, -1, 0, _tmpMaster.ContainerId, _tmpMaster.UnitId, _tmpMaster.isInfoMoney_80401, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.calcCount, _tmpMaster.calcSumm, _tmpMaster.calcCount_external, _tmpMaster.calcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm FROM _tmpMaster;
*/

-- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240);
-- select CLO2.ObjectId from ContainerLinkObject AS CLO2 where CLO2.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240) and CLO2.DescId = zc_ContainerLinkObject_Goods()
-- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (select Container.Id from Container where Container.ObjectId IN (select CLO2.ObjectId from ContainerLinkObject AS CLO2 where CLO2.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240) and CLO2.DescId = zc_ContainerLinkObject_Goods()) union select CLO.ContainerId from ContainerLinkObject AS CLO where CLO.ObjectId IN (select CLO2.ObjectId from ContainerLinkObject AS CLO2 where CLO2.ContainerId IN (1270241, 1275307, 1270242, 1270239, 1270240) and CLO2.DescId = zc_ContainerLinkObject_Goods()) and CLO.DescId = zc_ContainerLinkObject_Goods());

     -- ������ !!! Recycled !!!
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
--                                                                                                                      AND CLO.ObjectId = 12573); -- ���������� ����� ��������


     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (154253, 154250); -- 12.2018

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3190338, 3193380); -- 09.2020

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3231332, 3234249); -- 10.2020

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3502863); -- 04.2021

     --DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (3324068, 3323606, 3325351, 2350884, 2349571, 2354329, 2350886, 2354546, 2349569, -- 07.2021
     -- 159538, 256304, 159542, 539314, 158860, 539309, 256017, 539308, 158859, 159537, 539307, 159539, 158864, 539315, 158861, 3617386, 449444, 539312, 467021);

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (926000, 924971); -- 03.2022

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (548224, 530876); -- 04.2022

     -- DELETE FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (SELECT Container.Id FROM Container WHERE Container.ParentId = 3112320); -- 07.2022


     IF inBranchId = 0 -- OR 1 = 1
     THEN
         -- !!!1.1. �����������!!!
         CREATE TEMP TABLE tmpMIContainer_Summ_Out ON COMMIT DROP
           AS (SELECT DISTINCT MIContainer_Summ_Out.Id, MIContainer_Summ_Out.MovementId, MIContainer_Summ_Out.MovementItemId
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
         -- !!!�����������!!!
         ANALYZE tmpMIContainer_Summ_Out;

         -- !!!1.2. �����������!!!
         CREATE TEMP TABLE tmpMIContainer_Summ_In ON COMMIT DROP
           AS (WITH tmp AS (SELECT DISTINCT MIContainer_Summ_Out.ParentId FROM tmpMIContainer_Summ_Out AS MIContainer_Summ_Out)
                  , tmpContainer_master AS (SELECT _tmpMaster.ContainerId
                                            FROM _tmpMaster
                                                 LEFT JOIN _tmpContainer_branch ON _tmpContainer_branch.ContainerId = _tmpMaster.ContainerId
                                            WHERE _tmpContainer_branch.ContainerId IS NULL
                                           )
                  , MIContainer_Summ_In AS (SELECT MIContainer_Summ_In.Id, tmp.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                                                 , SUM (MIContainer_Summ_In.Amount) AS Amount
                                            FROM tmp
                                                 INNER JOIN MovementItemContainer AS MIContainer_Summ_In ON MIContainer_Summ_In.Id = tmp.ParentId
                                            GROUP BY MIContainer_Summ_In.Id, tmp.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                                           )
               SELECT MIContainer_Summ_In.Id, MIContainer_Summ_In.ParentId, MIContainer_Summ_In.MovementId, MIContainer_Summ_In.ContainerId, MIContainer_Summ_In.MovementItemId, MIContainer_Summ_In.WhereObjectId_Analyzer
                    , MIContainer_Summ_In.Amount
               FROM MIContainer_Summ_In
                    INNER JOIN tmpContainer_master ON tmpContainer_master.ContainerId = MIContainer_Summ_In.ContainerId
              );
         -- !!!�����������!!!
         ANALYZE tmpMIContainer_Summ_In;

         -- !!!1.3. �����������!!!
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
         -- !!!�����������!!!
         ANALYZE tmpContainer_count;

         -- !!!1.4. �����������!!!
         CREATE TEMP TABLE MIContainer_Count_In  ON COMMIT DROP
           AS (SELECT MIContainer_Count_In.Id, MIContainer_Count_In.MovementItemId, MIContainer_Count_In.MovementId, MIContainer_Count_In.ContainerId, SUM (MIContainer_Count_In.Amount) AS Amount
               FROM tmpContainer_count
                    INNER JOIN MovementItemContainer AS MIContainer_Count_In
                                                     ON MIContainer_Count_In.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer_Count_In.ContainerId  = tmpContainer_count.ContainerId
                                                    AND MIContainer_Count_In.DescId       = zc_MIContainer_Count()
                                                    AND MIContainer_Count_In.isActive     = TRUE
                                                    AND MIContainer_Count_In.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
               GROUP BY MIContainer_Count_In.Id, MIContainer_Count_In.MovementItemId, MIContainer_Count_In.MovementId, MIContainer_Count_In.ContainerId
              );
         -- !!!�����������!!!
         ANALYZE MIContainer_Count_In;


         -- ������� � Child ��� Master
         INSERT INTO _tmpChild (MasterContainerId, ContainerId, MasterContainerId_Count, ContainerId_Count, OperCount, isExternal, DescId)
            WITH MIContainer_Count_Out AS (SELECT MIContainer_Count_Out.Id, MIContainer_Count_Out.ParentId, MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer, SUM (MIContainer_Count_Out.Amount) AS Amount
                                           FROM tmpContainer_count
                                                INNER JOIN MovementItemContainer AS MIContainer_Count_Out
                                                                                 ON MIContainer_Count_Out.OperDate BETWEEN inStartDate AND inEndDate
                                                                                AND MIContainer_Count_Out.ContainerId = tmpContainer_count.ContainerId
                                                                                AND MIContainer_Count_Out.DescId      = zc_MIContainer_Count()
                                                                                AND MIContainer_Count_Out.isActive    = FALSE
                                                                                AND MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                           GROUP BY MIContainer_Count_Out.Id, MIContainer_Count_Out.ParentId, MIContainer_Count_Out.MovementId, MIContainer_Count_Out.MovementDescId, MIContainer_Count_Out.OperDate, MIContainer_Count_Out.MovementItemId, MIContainer_Count_Out.ContainerId, MIContainer_Count_Out.WhereObjectId_Analyzer
                                          )
               , MIContainer_Summ_Out AS (SELECT tmpMIContainer_Summ_Out.Id, tmpMIContainer_Summ_Out.MovementId, tmpMIContainer_Summ_Out.MovementItemId
                                               , tmpMIContainer_Summ_Out.ParentId, tmpMIContainer_Summ_Out.ContainerId
                                               , tmpMIContainer_Summ_Out.Id
                                          FROM tmpMIContainer_Summ_Out
                                         )
                , MIContainer_Summ_In AS (SELECT tmpMIContainer_Summ_In.Id, tmpMIContainer_Summ_In.ParentId, tmpMIContainer_Summ_In.MovementId, tmpMIContainer_Summ_In.ContainerId, tmpMIContainer_Summ_In.MovementItemId, tmpMIContainer_Summ_In.WhereObjectId_Analyzer, tmpMIContainer_Summ_In.Amount
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
                , tmpRes AS (SELECT COALESCE (MIContainer_Summ_In.ContainerId, 0)   AS MasterContainerId
                                  , COALESCE (MIContainer_Summ_Out.ContainerId, 0)  AS ContainerId
                                  , COALESCE (MIContainer_Count_In.ContainerId, 0)  AS MasterContainerId_Count
                                  , COALESCE (MIContainer_Count_Out.ContainerId, 0) AS ContainerId_Count

                                  , SUM (CASE WHEN MIContainer_Count_Out.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
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

                                  JOIN MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
                                  JOIN Container AS Container_Summ_In ON Container_Summ_In.Id       = MIContainer_Summ_In.ContainerId

                                  JOIN MIContainer_Count_In ON MIContainer_Count_In.MovementItemId = MIContainer_Summ_In.MovementItemId
                                                           AND MIContainer_Count_In.ContainerId    = Container_Summ_In.ParentId
                                                           -- !!! � ���� ������� !!!
                                                           AND MIContainer_Count_In.Id             = MIContainer_Count_Out.ParentId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                               ON MovementLinkObject_User.MovementId = MIContainer_Count_Out.MovementId
                                                              AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                                              AND MovementLinkObject_User.ObjectId   = zc_Enum_Process_Auto_Defroster()

                             WHERE MovementLinkObject_User.MovementId IS NULL
                               -- !!! � ���� ������� !!!
                               AND MIContainer_Count_Out.MovementDescId = zc_Movement_Send()
                             GROUP BY MIContainer_Summ_In.ContainerId
                                    , MIContainer_Summ_Out.ContainerId
                                    , MIContainer_Count_In.ContainerId
                                    , MIContainer_Count_Out.ContainerId
                                    , MIContainer_Count_Out.WhereObjectId_Analyzer
                                    , MIContainer_Summ_In.WhereObjectId_Analyzer
                                    -- , MIContainer_Count_Out.MovementDescId
                            UNION ALL
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

                                  JOIN MIContainer_Summ_In ON MIContainer_Summ_In.Id = MIContainer_Summ_Out.ParentId
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
                               -- !!! � ���� ������� !!!
                               AND MIContainer_Count_Out.MovementDescId <> zc_Movement_Send()
                             GROUP BY MIContainer_Summ_In.ContainerId
                                    , MIContainer_Summ_Out.ContainerId
                                    , MIContainer_Count_In.ContainerId
                                    , MIContainer_Count_Out.ContainerId
                                    , MIContainer_Count_Out.WhereObjectId_Analyzer
                                    , MIContainer_Summ_In.WhereObjectId_Analyzer
                                    -- , MIContainer_Count_Out.MovementDescId
                            )
            -- ���������
            SELECT tmpRes.MasterContainerId
                 , tmpRes.ContainerId
                 , tmpRes.MasterContainerId_Count
                 , tmpRes.ContainerId_Count
                 , SUM (tmpRes.OperCount) AS OperCount
                 , tmpRes.isExternal
                 , tmpRes.MovementDescId
            FROM tmpRes
            GROUP BY tmpRes.MasterContainerId
                   , tmpRes.ContainerId
                   , tmpRes.MasterContainerId_Count
                   , tmpRes.ContainerId_Count
                   , tmpRes.isExternal
                   , tmpRes.MovementDescId
            ;

            -- !!!�������� - �������� - �����������!!!
            INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
              SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
                      , '<XML>'
                     || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
                     || '<Field FieldName = "��������" FieldValue = "end - INSERT INTO _tmpChild"/>'
                     || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
                     || '<Field FieldName = "Itearation" FieldValue = "0"/>'
                     || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
                     || '</XML>'
                  , TRUE;
            -- ��������� ����� ������ ���������� ��������
            vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     END IF; -- if inBranchId = 0

     /*if inBranchId = 0
     then
        delete from _tmpChild_2024_06_12;
        insert into _tmpChild_2024_06_12 select * from _tmpChild;
     end if;*/

--    RAISE EXCEPTION '������.<%>   %', (select sum(_tmpChild.OperCount) from _tmpChild where _tmpChild.MasterContainerId_Count = 2389013)
-- , (select count(*) from _tmpChild where _tmpChild.MasterContainerId_Count = 2389013)
--;

/*     -- ����������� ����� ������� ��� (�.�. ������� �������� �� �����������)
       -- ����������� ����� ������� ��� (�.�. ������� �������� �� �����������) !!!�� �������� ������� ���� �� > 01.06.2014!!!*/


     -- !!!��������, ���� ������!!!
     -- delete from _tmpChild where _tmpChild.MasterContainerId IN ( SELECT _tmpChild.MasterContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1);


     -- ��������1
     IF EXISTS (SELECT _tmpMaster.ContainerId FROM _tmpMaster GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '��������1 - SELECT ContainerId FROM _tmpMaster GROUP BY ContainerId HAVING COUNT(*) > 1 ContainerId = % + count = %'
                       , (SELECT _tmpMaster.ContainerId FROM _tmpMaster GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1 LIMIT 1)
                       , (SELECT COUNT(*) FROM _tmpMaster WHERE _tmpMaster.ContainerId IN (SELECT _tmpMaster.ContainerId FROM _tmpMaster GROUP BY _tmpMaster.ContainerId HAVING COUNT(*) > 1))
                        ;
     END IF;
     -- ��������2
     IF EXISTS (SELECT _tmpChild.MasterContainerId, _tmpChild.ContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '��������2 - SELECT MasterContainerId, ContainerId FROM _tmpChild GROUP BY MasterContainerId, ContainerId HAVING COUNT(*) > 1 :  MasterContainerId = % and ContainerId = %'
                       , (SELECT _tmpChild.MasterContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
                       , (SELECT _tmpChild.ContainerId FROM _tmpChild GROUP BY _tmpChild.MasterContainerId, _tmpChild.ContainerId HAVING COUNT(*) > 1 ORDER BY _tmpChild.MasterContainerId, _tmpChild.ContainerId LIMIT 1)
                        ;
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� ��� �/� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- test
/*     RAISE EXCEPTION '������.<%>  <%>'
     , (select _tmpChild.OperCount
      from _tmpChild
      where _tmpChild.MasterContainerId = 3098974 and _tmpChild.ContainerId = 120200
      )
     , (select _tmpChild.OperCount  * _tmpPrice.OperPrice
      from _tmpChild
       JOIN (SELECT _tmpMaster.ContainerId
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
                     ON _tmpChild.ContainerId = _tmpPrice.ContainerId

      where _tmpChild.MasterContainerId = 3098974 and _tmpChild.ContainerId = 120200
      );
*/

     if inBranchId = 0 AND 1=0
     then
         delete from _tmpMaster_2024_06_12;
         insert into _tmpMaster_2024_06_12 select * from _tmpMaster;

         -- !!! error - 15.06.2024!!!||
         /*UPDATE _tmpMaster SET CalcSumm          = 0.1 * _tmpMaster.calcCount
                             , CalcSumm_external = 0.1 * _tmpMaster.calcCount_external
         FROM
              (with tmp_1 AS (SELECT Container.*
                              FROM Container
                                   INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                  ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                 AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                 AND ContainerLinkObject_Unit.ObjectId IN (8450) -- ��� ��������� + ����� ���� �� + ĳ������ ������� �������
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
        ;*/

     end if;

         truncate table _tmpMaster_2024_07;
         insert into _tmpMaster_2024_07 select * from _tmpMaster;

         truncate table _tmpChild_2024_07;
         insert into _tmpChild_2024_07 select * from _tmpChild;



RAISE INFO ' 1 - vbCountDiff = <%> vbItearation = <%> CalcSumm = <%> <%>', vbCountDiff, vbItearation
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550) -- 4251786
, (select _tmpMaster.CalcSumm / _tmpMaster.CalcCount FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550)
;

     -- !!! 1-�� �������� ��� ���� !!!
         UPDATE _tmpMaster SET CalcSumm          = _tmpSumm.CalcSumm
                             , CalcSumm_external = _tmpSumm.CalcSumm_external
               -- ������ ����� ���� ������������
         FROM (WITH tmp_const AS  (SELECT HistoryCost.ContainerId, MAX (HistoryCost.Price) AS Price
                                   FROM Container AS Container_Summ
                                        INNER JOIN Container ON Container.Id = Container_Summ.ParentId
                                                            AND Container.ObjectId = 6883420
                                        INNER JOIN HistoryCost ON HistoryCost.ContainerId  = Container_Summ.Id
                                                              AND HistoryCost.StartDate     = '01.08.2023'
                                   WHERE Container_Summ.DescId = zc_Container_Summ()
                                     AND inStartDate = '01.08.2023'
                                     AND 1=0
                                   GROUP BY HistoryCost.ContainerId
                                  )
               --
               SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * COALESCE (tmp_const.Price, _tmpPrice.OperPrice)) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * COALESCE (tmp_const.Price, _tmpPrice.OperPrice) ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.DescId = zc_Movement_Send() THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
               FROM
                    -- ������ ����
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
                                  -- ����������� � ��� ������ ���� ��� � ����
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

                    -- !!!�������� ��� '08.2023'!!!
                    LEFT JOIN tmp_const ON tmp_const.ContainerId = _tmpPrice.ContainerId

               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId;

RAISE INFO ' 2 - vbCountDiff = <%> vbItearation = <%> CalcSumm = <%> <%>', vbCountDiff, vbItearation
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550)
, (select _tmpMaster.CalcSumm / _tmpMaster.CalcCount FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550)
;

/*
     -- test
     RAISE EXCEPTION '������.<%>  <%>'
     , (select _tmpMaster.CalcSumm from _tmpMaster where _tmpMaster.ContainerId = 3098974)
     , (select CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE -- OR tmpErr.Id > 0 -- !!!��������!!!
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                        ELSE 0
                   END AS Price
        from _tmpMaster where _tmpMaster.ContainerId = 3098974)
     ;*/


     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "��������" FieldValue = "end - UPDATE _tmpMaster - 0.1."/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Itearation" FieldValue = "0"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
           , TRUE;
     -- ��������� ����� ������ ���������� ��������
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     -- ����***
     /*INSERT INTO HistoryCost_test (InsertDate, Itearation, CountDiff, ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
        SELECT CURRENT_TIMESTAMP, 0, 0, _tmpMaster.ContainerId, _tmpMaster.UnitId, _tmpMaster.isInfoMoney_80401, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.calcCount, _tmpMaster.calcSumm, _tmpMaster.calcCount_external, _tmpMaster.calcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm FROM _tmpMaster;
*/



     -- "�����" ���� Itearation
     CREATE TEMP TABLE _tmpMaster_Itearation_one ON COMMIT DROP
       -- ������� ��� �2, ����
       AS (SELECT CLO.ContainerId FROM ContainerLinkObject AS CLO
           WHERE CLO.DescId  = zc_ContainerLinkObject_Goods() AND CLO.ObjectId IN (4077)
             AND inStartDate = '01.08.2024'
             AND 1=0
          );


     -- !!! ��������� �������� ��� �������� !!!
     vbItearation:=0;
     vbCountDiff:= 100000;
     WHILE vbItearation < inItearationCount AND vbCountDiff > 0
     LOOP
         -- !!!��������!!!
         INSERT INTO _tmpErr (ContainerId, UnitId) SELECT _tmpMaster.ContainerId, _tmpMaster.UnitId FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 11231231201;
         DELETE FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 11231231201;


         -- !!!��������!!!
         --DELETE FROM _tmpMaster WHERE ABS (_tmpMaster.calcSumm) > 11231231201;
         --UPDATE _tmpMaster SET  WHERE ABS (_tmpMaster.calcSumm) > 11231231201;

         -- �.�. ������
         IF vbItearation = vbItearationCount_err AND inStartDate < lfGet_Object_Unit_PartionDate_isPartionCell()
         THEN
             /*-- delete
             select * from HistoryCost WHERE '01.06.2018' = StartDate and ContainerId in (
                                   SELECT DISTINCT ContainerId
                                   FROM ContainerLinkObject AS CLO
                                   WHERE ObjectId   = 5662
                                     AND CLO.DescId = zc_ContainerLinkObject_Goods())*/
             -- ��������� - ��� "���������" �������
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
                                                                     AND ContainerLinkObject_Unit.ObjectId IN (8450) -- ��� ��������� + ����� ���� �� + ĳ������ ������� �������
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

         -- ������ �/�
         UPDATE _tmpMaster SET CalcSumm          = CASE WHEN _tmpSumm.isItearation_one = TRUE THEN _tmpMaster.CalcSumm          ELSE _tmpSumm.CalcSumm          END
                             , CalcSumm_external = CASE WHEN _tmpSumm.isItearation_one = TRUE THEN _tmpMaster.CalcSumm_external ELSE _tmpSumm.CalcSumm_external END

               -- ������ ����� ���� ������������
         FROM (WITH tmp_const AS  (SELECT HistoryCost.ContainerId, MAX (HistoryCost.Price) AS Price
                                   FROM Container AS Container_Summ
                                        INNER JOIN Container ON Container.Id = Container_Summ.ParentId
                                                            AND Container.ObjectId = 6883420
                                        INNER JOIN HistoryCost ON HistoryCost.ContainerId  = Container_Summ.Id
                                                              AND HistoryCost.StartDate     = '01.08.2023'
                                   WHERE Container_Summ.DescId = zc_Container_Summ()
                                     AND inStartDate = '01.08.2023'
                                     AND 1=0
                                   GROUP BY HistoryCost.ContainerId
                                  )
               --
               SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * COALESCE (tmp_const.Price, _tmpPrice.OperPrice)) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * COALESCE (tmp_const.Price, _tmpPrice.OperPrice) ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * CASE WHEN _tmpPrice.OperPrice_external > 12345 THEN 1.2345 ELSE _tmpPrice.OperPrice_external END ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.DescId = zc_Movement_Send() THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external

                      -- "�����" ���� Itearation
                    , CASE WHEN _tmpMaster_Itearation_one.ContainerId > 0 AND vbItearation > 2 THEN TRUE ELSE FALSE END AS isItearation_one
               FROM
                    -- ������ ����
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
                                  -- ����������� � ��� ������ ���� ��� � ����
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
                    -- !!!�������� ��� '08.2023'!!!
                    LEFT JOIN tmp_const ON tmp_const.ContainerId = _tmpPrice.ContainerId
                    
                    -- 
                    LEFT JOIN _tmpMaster_Itearation_one ON _tmpMaster_Itearation_one.ContainerId = _tmpChild.MasterContainerId


               GROUP BY _tmpChild.MasterContainerId
                        -- "�����" ���� Itearation
                      , CASE WHEN _tmpMaster_Itearation_one.ContainerId > 0 AND vbItearation > 2 THEN TRUE ELSE FALSE END
              ) AS _tmpSumm
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           --*** AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8451 END -- ��� ��������
           -- AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8440 END -- ���������
        ;

         -- �.�. ������ - ������������
         IF EXISTS (SELECT 1 FROM _tmpMaster_err)
         THEN
             -- ��� "���������" �������
             UPDATE _tmpMaster SET CalcSumm          = _tmpMaster_err.CalcSumm
                                 , CalcSumm_external = _tmpMaster_err.CalcSumm_external
             FROM _tmpMaster_err
             WHERE _tmpMaster.ContainerId = _tmpMaster_err.ContainerId
            ;

         END IF;


         -- ������� ������� � ��� ������������ �/�
         SELECT Count(*) INTO vbCountDiff
         FROM _tmpMaster
               -- ������ ����� ���� ������������
            , (SELECT _tmpChild.MasterContainerId AS ContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
               FROM
                    -- ������ ����
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
                                  -- ����������� � ��� ������ ���� ��� � ����
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
               GROUP BY _tmpChild.MasterContainerId
              ) AS _tmpSumm
         WHERE _tmpMaster.ContainerId = _tmpSumm.ContainerId
           AND ABS (_tmpMaster.CalcSumm - _tmpSumm.CalcSumm) > inDiffSumm
           --*** AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8451 END -- ��� ��������
           -- AND COALESCE (_tmpMaster.UnitId, 0) <> CASE WHEN vbItearation < 2 THEN -1 ELSE 8440 END -- ���������
        ;

         -- ���������� ��������
         vbItearation:= vbItearation + 1;


if vbItearation <= 10
then
RAISE INFO ' vbCountDiff = <%> vbItearation = <%> CalcSumm = <%> <%>', vbCountDiff, vbItearation
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550)
, (select _tmpMaster.CalcSumm / _tmpMaster.CalcCount FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550)
;
end if;

if vbItearation % 10 = 0 AND  vbItearation > 10
then
RAISE INFO ' vbCountDiff = <%> vbItearation = <%> CalcSumm = <%> <%>', vbCountDiff, vbItearation
, (select _tmpMaster.CalcSumm FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550)
, (select _tmpMaster.CalcSumm / _tmpMaster.CalcCount FROM _tmpMaster WHERE _tmpMaster.ContainerId = 4285550)
;
end if;

         -- ����***
         /*INSERT INTO HistoryCost_test (InsertDate, Itearation, CountDiff, ContainerId, UnitId, isInfoMoney_80401, StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm)
            SELECT CURRENT_TIMESTAMP, vbItearation, vbCountDiff, _tmpMaster.ContainerId, _tmpMaster.UnitId, _tmpMaster.isInfoMoney_80401, _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.calcCount, _tmpMaster.calcSumm, _tmpMaster.calcCount_external, _tmpMaster.calcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm FROM _tmpMaster;
*/
     END LOOP;

  RAISE INFO ' vbItearation = <%> end = <%> ', vbItearation, CLOCK_TIMESTAMP();


         truncate table _tmpMaster_2024_07_;
         insert into _tmpMaster_2024_07_ select * from _tmpMaster;
-- return;

     /*IF EXISTS (select 1 from _tmpErr ) -- WHERE _tmpErr.ContainerId = 151207
     THEN
           -- test
           RAISE EXCEPTION '������. <%>', (select count(*) from _tmpErr);
           RAISE EXCEPTION '������. <%>   <%>   <%>', vbItearation, (select count(*) from _tmpErr) , (select STRING_AGG (_tmpErr.ContainerId :: TVarChar, ';') from _tmpErr order by 1 limit 1);
     END IF;*/

     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "��������" FieldValue = "end - CALC"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Itearation" FieldValue = "' || vbItearation :: TVarChar || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
           , TRUE;
     -- ��������� ����� ������ ���������� ��������
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     IF inInsert > 0 THEN

     -- ��������� Diff
     /*INSERT INTO _tmpDiff (ContainerId, MovementItemId_diff, Summ_diff)
        SELECT HistoryCost.ContainerId, MAX (HistoryCost.MovementItemId_diff), SUM (HistoryCost.Summ_diff) FROM HistoryCost WHERE HistoryCost.Summ_diff <> 0 AND ((inStartDate BETWEEN StartDate AND EndDate) OR (inEndDate BETWEEN StartDate AND EndDate)) GROUP BY HistoryCost.ContainerId;
     */
     IF inBranchId > 0
     THEN
         -- ������� ���������� �/� - !!!��� 1-��� �������!!!
         DELETE FROM HistoryCost -- WHERE ((StartDate BETWEEN inStartDate AND inEndDate) OR (EndDate BETWEEN inStartDate AND inEndDate))
                                 WHERE HistoryCost.StartDate   IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
                                   AND HistoryCost.ContainerId IN (SELECT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                                  /*(SELECT ContainerLinkObject.ContainerId
                                                                   FROM _tmpUnit_branch
                                                                        INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                                  );*/

         -- !!!�������� - �������� - �����������!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "��������" FieldValue = "end - DELETE-1"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- ��������� ����� ������ ���������� ��������
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


         -- !!!������� ����!!!
         DELETE FROM _tmpMaster
         WHERE (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm          = 0)
           AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external = 0)
          ;

         -- !!!�������� - �������� - �����������!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "��������" FieldValue = "end - delete-2"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- ��������� ����� ������ ���������� ��������
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


         -- ��������� ��� ��������� - !!!��� 1-��� �������!!!
         INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
            /*WITH tmpErr AS (SELECT Container.*
                            FROM Container
                                 INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.ObjectId = 8411 -- ����� �� �.����
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                 INNER JOIN ContainerLinkObject as CLO2 ON CLO2.ContainerId = Container.Id
                                                               AND CLO2.ObjectId = 621819 -- �/� ����� ��-��������� 1�, �� ���� �������
                                                               AND CLO2.DescId = zc_ContainerLinkObject_Goods()
                            WHERE Container.DescId = zc_Container_Summ()
                              AND inEndDate <= '31.03.2018'
                              AND inBranchId = 8379 -- �.����
                           )*/
            -- ���������
            SELECT _tmpMaster.ContainerId, inStartDate AS StartDate, inEndDate AS EndDate
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE -- OR tmpErr.Id > 0 -- !!!��������!!!
                             THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                            THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                       ELSE  0
                                  END
                        WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                           OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                             THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                        ELSE 0
                   END AS Price
                 , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE -- OR tmpErr.Id > 0 -- !!!��������!!!
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
                 -- !!!��������!!!
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
  RAISE INFO ' start del = <%> ', CLOCK_TIMESTAMP();

         -- ������� ���������� �/� - !!!����� ���� ��������!!!
         DELETE FROM HistoryCost -- WHERE ((HistoryCost.StartDate BETWEEN inStartDate AND inEndDate) OR (HistoryCost.EndDate BETWEEN inStartDate AND inEndDate))
                                 WHERE HistoryCost.StartDate       IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
                                   -- !!!�������� ��� '08.2023'!!!
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
                                   AND HistoryCost.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch);
                                                                      /*(SELECT ContainerLinkObject.ContainerId
                                                                       FROM _tmpUnit_branch
                                                                            INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                                          AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                                      );*/

         -- !!!�������� - �������� - �����������!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "��������" FieldValue = "end - DELETE-1"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- ��������� ����� ������ ���������� ��������
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


         -- !!!������� ����!!!
         DELETE FROM _tmpMaster
         WHERE (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm          = 0)
           AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external = 0)
          ;
         -- !!!�������� - �������� - �����������!!!
         INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
           SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
               , '<XML>'
              || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
              || '<Field FieldName = "��������" FieldValue = "end - delete-2"/>'
              || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
              || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
              || '</XML>'
               , TRUE;
         -- ��������� ����� ������ ���������� ��������
         vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


  RAISE INFO ' start-1 insert = <%> ', CLOCK_TIMESTAMP();

         -- ���������� �/�, �.�. � ���� ������� ������ � ������������� ��� ������� ����
         INSERT INTO _tmpMaster (ContainerId, UnitId, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm)
            SELECT HistoryCost.ContainerId, _tmpErr.UnitId, 2, 1 * HistoryCost.Price, -1, 0, 0, 0, 0, 0, 0, 0
            FROM _tmpErr
                 JOIN HistoryCost ON HistoryCost.ContainerId = _tmpErr.ContainerId
                                 AND HistoryCost.StartDate   = DATE_TRUNC ('MONTH', inStartDate - INTERVAL '1 DAY')
        ;


         -- 1. ��� ����������� ����� - PartionCell - ����������� ��������
         INSERT INTO _tmpHistoryCost_PartionCell (GoodsId, GoodsKindId, InfoMoneyId, InfoMoneyId_Detail
                                                , StartCount, StartSumm, IncomeCount, IncomeSumm
                                                , CalcCount, CalcSumm, CalcCount_external, CalcSumm_external
                                                , OutCount, OutSumm
                                                , AccountId, isInfoMoney_80401
                                                 )
            SELECT CLO_Goods.ObjectId AS GoodsId
                 , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , COALESCE (CLO_InfoMoney.ObjectId, 0) AS InfoMoneyId
                 , COALESCE (CLO_InfoMoneyDetail.ObjectId, 0)  AS InfoMoneyId_Detail
                 , SUM (_tmpMaster.StartCount) AS StartCount, SUM (_tmpMaster.StartSumm) AS StartSumm, SUM (_tmpMaster.IncomeCount) AS IncomeCount, SUM (_tmpMaster.IncomeSumm) AS IncomeSumm
                 , SUM (_tmpMaster.CalcCount) AS CalcCount, SUM (_tmpMaster.CalcSumm) AS CalcSumm, SUM (_tmpMaster.CalcCount_external) AS CalcCount_external, SUM (_tmpMaster.CalcSumm_external) AS CalcSumm_external
                 , SUM (_tmpMaster.OutCount) AS OutCount, SUM (_tmpMaster.OutSumm) AS OutSumm
                 , Container.ObjectId AS AccountId
                 , COALESCE (_tmpMaster.isInfoMoney_80401, FALSE) AS isInfoMoney_80401
            FROM _tmpMaster
                 LEFT JOIN Container ON Container.Id = _tmpMaster.ContainerId
                 LEFT JOIN ContainerLinkObject AS CLO_Goods
                                               ON CLO_Goods.ContainerId = _tmpMaster.ContainerId
                                              AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                 LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                               ON CLO_GoodsKind.ContainerId = _tmpMaster.ContainerId
                                              AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                               ON CLO_InfoMoney.ContainerId = _tmpMaster.ContainerId
                                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                               ON CLO_InfoMoneyDetail.ContainerId = _tmpMaster.ContainerId
                                              AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
            -- ����������� ��������
            WHERE _tmpMaster.UnitId = zc_Unit_RK()
              AND inStartDate       >= lfGet_Object_Unit_PartionDate_isPartionCell()
              AND Container.ObjectId <> zc_Enum_Account_110101()
              AND Container.ObjectId <> zc_Enum_Account_110102()
              AND Container.ObjectId <> zc_Enum_Account_110111()
              AND Container.ObjectId <> zc_Enum_Account_110112()
              AND Container.ObjectId <> zc_Enum_Account_110121()
              AND Container.ObjectId <> zc_Enum_Account_110122()
              AND Container.ObjectId <> zc_Enum_Account_110131()
              AND Container.ObjectId <> zc_Enum_Account_110132()

            GROUP BY CLO_Goods.ObjectId
                   , COALESCE (CLO_GoodsKind.ObjectId, 0)
                   , COALESCE (CLO_InfoMoney.ObjectId, 0)
                   , COALESCE (CLO_InfoMoneyDetail.ObjectId, 0)
                   , Container.ObjectId
                   , COALESCE (_tmpMaster.isInfoMoney_80401, FALSE)
                    ;

         -- ��� �����
         IF EXTRACT (MONTH FROM inStartDate) IN (5, 6, 7)
         THEN vbMONTH_str:= EXTRACT (MONTH FROM inStartDate) :: TVarChar;
         ELSE vbMONTH_str:= '5';
         END IF;
         -- ��� �����
         /*PERFORM gpExecSql ('truncate table _tmpMaster_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpMaster_2024_0' || vbMONTH_str || ' select * from _tmpMaster', inSession);
         -- ��� �����
         PERFORM gpExecSql ('truncate table _tmpChild_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpChild_2024_0' || vbMONTH_str || ' select * from _tmpChild', inSession);
         -- ��� �����
         PERFORM gpExecSql ('truncate table _tmpHistoryCost_PartionCell_2024_0' || vbMONTH_str, inSession);
         PERFORM gpExecSql ('insert into _tmpHistoryCost_PartionCell_2024_0' || vbMONTH_str || ' select * from _tmpHistoryCost_PartionCell', inSession);*/


  RAISE INFO ' start-2 insert = <%> ', CLOCK_TIMESTAMP();

         -- ��������� ��� ��������� - !!!����� ���� ��������!!!
         INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
            WITH tmpChild_find AS (SELECT DISTINCT tmpContainer_count.ContainerId
                                   FROM tmpContainer_count
                                        INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                       ON CLO_Unit.ContainerId = tmpContainer_count.ContainerId
                                                                      AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                      AND CLO_Unit.ObjectId    = zc_Unit_RK()
                                        INNER JOIN MovementItemContainer AS MIContainer_Count
                                                                         ON MIContainer_Count.OperDate BETWEEN inStartDate AND inEndDate
                                                                        AND MIContainer_Count.ContainerId  = tmpContainer_count.ContainerId
                                                                        AND MIContainer_Count.DescId       = zc_MIContainer_Count()
                                                                      --AND MIContainer_Count.isActive     = TRUE
                                   WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                                  )

          , tmpMaster_find AS (SELECT DISTINCT _tmpMaster.ContainerId FROM _tmpMaster
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT _tmpChild.ContainerId FROM _tmpChild
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT Container.Id
                               FROM _tmpChild
                                    JOIN Container ON Container.ParentId = _tmpChild.ContainerId_Count
                                                  AND Container.DescId   = zc_Container_Summ()
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT Container.Id
                               FROM _tmpChild
                                    JOIN Container ON Container.ParentId = _tmpChild.MasterContainerId_Count
                                                  AND Container.DescId   = zc_Container_Summ()
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT Container.Id
                               FROM tmpChild_find
                                    JOIN Container ON Container.ParentId = tmpChild_find.ContainerId
                                                  AND Container.DescId   = zc_Container_Summ()
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              )
           -- !!! error - 15.06.2024!!!
         , tmp AS (with tmp_1 AS (SELECT Container.*
                                  FROM Container
                                       INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                      ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                     AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                     AND ContainerLinkObject_Unit.ObjectId IN (8450) -- ĳ������ ������� �������
                                  WHERE Container.DescId = zc_Container_Count()
                                    AND Container.ObjectId in (3569176  -- 953
                                                              )
                                    AND 1=0
                                 )
                      SELECT Container.Id
                      FROM Container
                      WHERE Container.DescId = zc_Container_Summ()
                        AND Container.ParentId in (SELECT tmp_1.Id FROM tmp_1)
                  )

            SELECT _tmpMaster.ContainerId, inStartDate AS StartDate
                 , DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
                 , CASE WHEN tmp.Id > 0 AND 1=0
                              -- !!! error - 15.06.2024!!!
                             THEN 0.1
                        WHEN _tmpMaster.isInfoMoney_80401 = TRUE
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

                 -- !!! error - 15.06.2024!!!
                 LEFT JOIN tmp ON tmp.Id = _tmpMaster.ContainerId

            WHERE (_tmpMaster.UnitId <> zc_Unit_RK()
                OR inStartDate       < lfGet_Object_Unit_PartionDate_isPartionCell()
                  )
/*(((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm)          <> 0)
                OR ((_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm_external) <> 0)
                  )*/
              AND _tmpMaster.ContainerId NOT IN (SELECT DISTINCT _tmpContainer_branch.ContainerId FROM _tmpContainer_branch)
                                                /*(SELECT ContainerLinkObject.ContainerId
                                                 FROM _tmpUnit_branch
                                                      INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpUnit_branch.UnitId
                                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                );*/
                -- !!!�������� ��� '08.2023'!!!
              /*AND _tmpMaster.ContainerId NOT IN (SELECT DISTINCT HistoryCost.ContainerId
                                                   FROM Container AS Container_Summ
                                                        INNER JOIN Container ON Container.Id = Container_Summ.ParentId
                                                                            AND Container.ObjectId = 6883420
                                                        INNER JOIN HistoryCost ON HistoryCost.ContainerId  = Container_Summ.Id
                                                                              AND HistoryCost.StartDate     = '01.08.2023'
                                                   WHERE Container_Summ.DescId = zc_Container_Summ()
                                                     AND inStartDate = '01.08.2023'
                                                  )*/

           UNION ALL
            -- 2. ��� ����������� ����� - PartionCell - ����������� ��������
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

                 -- !!!�����������!!!
                 JOIN tmpMaster_find ON tmpMaster_find.ContainerId = Container.Id

                 INNER JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = Container.Id
                                               AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                               AND CLO_Goods.ObjectId    = _tmpMaster.GoodsId
                 INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ContainerId = Container.Id
                                               AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                               -- !!! ����������� ��������
                                               AND CLO_Unit.ObjectId    = zc_Unit_RK()

                 LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                               ON CLO_GoodsKind.ContainerId = Container.Id
                                              AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                               ON CLO_InfoMoney.ContainerId = Container.Id
                                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                               ON CLO_InfoMoneyDetail.ContainerId = Container.Id
                                              AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()

            WHERE _tmpMaster.GoodsKindId        = COALESCE (CLO_GoodsKind.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId        = COALESCE (CLO_InfoMoney.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId_Detail = COALESCE (CLO_InfoMoneyDetail.ObjectId, 0)
              -- !!!
              AND inStartDate    >= lfGet_Object_Unit_PartionDate_isPartionCell()
             ;

     END IF;

  RAISE INFO ' end all = <%> ', CLOCK_TIMESTAMP();

     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
           , '<XML>'
          || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
          || '<Field FieldName = "��������" FieldValue = "end - insert ALL"/>'
          || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
          || '<Field FieldName = "Time" FieldValue = "'     || (CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: TVarChar || '"/>'
          || '</XML>'
           , TRUE;
     -- ��������� ����� ������ ���������� ��������
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


        -- !!!��������!!!
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
                                                               AND (View_InfoMoney.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                                                                 OR View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                                                                                                            , zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                                                            , zc_Enum_InfoMoneyDestination_21000() -- �����
                                                                                                            , zc_Enum_InfoMoneyDestination_21100() -- �������
                                                                                                             )
                                                                   )
        WHERE HistoryCost.StartDate = inStartDate
          AND ABS (HistoryCost.Price) >  10800
          AND HistoryCost.ContainerId = Container.Id
       ;

     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT zfCalc_UserAdmin() :: Integer, CLOCK_TIMESTAMP(), zfCalc_UserAdmin() :: Integer
           , '<XML>'
          || '<Field FieldName = "���" FieldValue = "HistoryCost"/>'
          || '<Field FieldName = "��������" FieldValue = "end - update Price"/>'
          || '<Field FieldName = "BranchId" FieldValue = "' || lfGet_Object_ValueData_sh (inBranchId) || '"/>'
          || '<Field FieldName = "StartDate" FieldValue = "'     || zfConvert_DateToString (inStartDate) || '"/>'
          || '<Field FieldName = "EndDate" FieldValue = "'     || zfConvert_DateToString (inEndDate) || '"/>'
          || '</XML>'
           , TRUE;

        -- !!!��������-1!!!
        /*UPDATE MovementItemContainer SET ContainerIntId_analyzer = ContainerId
        WHERE MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
          AND MovementItemContainer.MovementDescId = zc_Movement_Sale()
          AND MovementItemContainer.DescId = zc_MIContainer_Count()
          AND MovementItemContainer.ContainerIntId_analyzer IS NULL
       ;
        -- !!!��������-2!!!
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

     IF inInsert <> 12345 THEN -- 12345 - ��� Load_PostgreSql
     -- tmp - test
     RETURN QUERY
            WITH tmpChild_find AS (SELECT DISTINCT tmpContainer_count.ContainerId
                                   FROM tmpContainer_count
                                        INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                       ON CLO_Unit.ContainerId = tmpContainer_count.ContainerId
                                                                      AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                      AND CLO_Unit.ObjectId    = zc_Unit_RK()
                                        INNER JOIN MovementItemContainer AS MIContainer_Count
                                                                         ON MIContainer_Count.OperDate BETWEEN inStartDate AND inEndDate
                                                                        AND MIContainer_Count.ContainerId  = tmpContainer_count.ContainerId
                                                                        AND MIContainer_Count.DescId       = zc_MIContainer_Count()
                                                                      --AND MIContainer_Count.isActive     = TRUE
                                   WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                                  )

          , tmpMaster_find AS (SELECT DISTINCT _tmpMaster.ContainerId FROM _tmpMaster
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT _tmpChild.ContainerId FROM _tmpChild
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT Container.Id
                               FROM _tmpChild
                                    JOIN Container ON Container.ParentId = _tmpChild.ContainerId_Count
                                                  AND Container.DescId   = zc_Container_Summ()
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT Container.Id
                               FROM _tmpChild
                                    JOIN Container ON Container.ParentId = _tmpChild.MasterContainerId_Count
                                                  AND Container.DescId   = zc_Container_Summ()
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              UNION
                               SELECT DISTINCT Container.Id
                               FROM tmpChild_find
                                    JOIN Container ON Container.ParentId = tmpChild_find.ContainerId
                                                  AND Container.DescId   = zc_Container_Summ()
                               WHERE inStartDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              )
        -- ���������
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
               -- ������ ����� ���� ������������
              (SELECT _tmpChild.MasterContainerId AS ContainerId
--                    , _tmpChild.ContainerId AS FromContainerId
                    , 0 AS FromContainerId
                    , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                    , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                    -- , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external

               FROM
                    -- ������ ����
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
                                  -- ����������� � ��� ������ ���� ��� � ����
                                  -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
               GROUP BY _tmpChild.MasterContainerId
--                      , _tmpChild.ContainerId
              ) AS _tmpSumm ON _tmpMaster.ContainerId = _tmpSumm.ContainerId
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpMaster.UnitId

         WHERE (_tmpMaster.UnitId <> zc_Unit_RK()
             OR inStartDate       < lfGet_Object_Unit_PartionDate_isPartionCell()
               )

       UNION ALL
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
                                              THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END)
                                                 / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount_external)
                                         ELSE  0
                                    END
                          WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END) > 0)
                             OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END) < 0))
                               THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + CASE WHEN _tmpSumm.CalcSumm_external <> 0 THEN _tmpSumm.CalcSumm_external ELSE _tmpMaster.CalcSumm_external END) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.CalcCount_external)
                          ELSE 0
                     END AS TFloat) AS PriceNext_external

             , _tmpSumm.FromContainerId
             , Container.Id AS ContainerId
             , _tmpMaster.isInfoMoney_80401
             , _tmpMaster.CalcSumm          AS CalcSummCurrent,          CAST (COALESCE (_tmpSumm.CalcSumm, 0)          AS TFloat) AS CalcSummNext
             , _tmpMaster.CalcSumm_external AS CalcSummCurrent_external, CAST (COALESCE (_tmpSumm.CalcSumm_external, 0) AS TFloat) AS CalcSummNext_external
             , _tmpMaster.StartCount, _tmpMaster.StartSumm, _tmpMaster.IncomeCount, _tmpMaster.IncomeSumm, _tmpMaster.CalcCount, _tmpMaster.CalcSumm, _tmpMaster.CalcCount_external, _tmpMaster.CalcSumm_external, _tmpMaster.OutCount, _tmpMaster.OutSumm
             , Object_Unit.Id        AS UnitId
             , Object_Unit.ValueData AS UnitName

         FROM _tmpHistoryCost_PartionCell AS _tmpMaster
              JOIN Container ON Container.ObjectId = _tmpMaster.AccountId
                            AND Container.DescId   = zc_Container_Summ()
              -- !!!�����������!!!
              JOIN tmpMaster_find ON tmpMaster_find.ContainerId = Container.Id


              INNER JOIN ContainerLinkObject AS CLO_Goods
                                             ON CLO_Goods.ContainerId = Container.Id
                                            AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                            AND CLO_Goods.ObjectId    = _tmpMaster.GoodsId
              INNER JOIN ContainerLinkObject AS CLO_Unit
                                             ON CLO_Unit.ContainerId = Container.Id
                                            AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                            -- !!! ����������� ��������
                                            AND CLO_Unit.ObjectId    = zc_Unit_RK()

              LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                            ON CLO_GoodsKind.ContainerId = Container.Id
                                           AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                            ON CLO_InfoMoney.ContainerId = Container.Id
                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
              LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                            ON CLO_InfoMoneyDetail.ContainerId = Container.Id
                                           AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()


              LEFT JOIN (SELECT CLO_Goods.ObjectId                         AS GoodsId
                              , COALESCE (CLO_GoodsKind.ObjectId, 0)       AS GoodsKindId
                              , COALESCE (CLO_InfoMoney.ObjectId, 0)       AS InfoMoneyId
                              , COALESCE (CLO_InfoMoneyDetail.ObjectId, 0) AS InfoMoneyId_Detail
                              , _tmpMaster.FromContainerId                 AS FromContainerId
                              , SUM (_tmpMaster.CalcSumm)                  AS CalcSumm
                              , SUM (_tmpMaster.CalcSumm_external)         AS CalcSumm_external
                         FROM
                              -- ������ ����� ���� ������������
                             (SELECT _tmpChild.MasterContainerId AS ContainerId
               --                    , _tmpChild.ContainerId AS FromContainerId
                                   , 0 AS FromContainerId
                                   , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                                   , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
                                   -- , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice_external ELSE 0 END) AS TFloat) AS CalcSumm_external

                              FROM
                                   -- ������ ����
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
                                    -- ����������� ��������
                                    WHERE _tmpMaster.UnitId = zc_Unit_RK()
                                      AND inStartDate       >= lfGet_Object_Unit_PartionDate_isPartionCell()
                                   ) AS _tmpPrice
                                   JOIN _tmpChild ON _tmpChild.ContainerId = _tmpPrice.ContainerId
                                                 -- ����������� � ��� ������ ���� ��� � ����
                                                 -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId
                              GROUP BY _tmpChild.MasterContainerId
               --                      , _tmpChild.ContainerId
                             ) AS _tmpMaster

                             LEFT JOIN Container ON Container.Id = _tmpMaster.ContainerId
                             LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                           ON CLO_Goods.ContainerId = _tmpMaster.ContainerId
                                                          AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                           ON CLO_GoodsKind.ContainerId = _tmpMaster.ContainerId
                                                          AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                           ON CLO_InfoMoney.ContainerId = _tmpMaster.ContainerId
                                                          AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                           ON CLO_InfoMoneyDetail.ContainerId = _tmpMaster.ContainerId
                                                          AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                         GROUP BY CLO_Goods.ObjectId
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)
                                , COALESCE (CLO_InfoMoney.ObjectId, 0)
                                , COALESCE (CLO_InfoMoneyDetail.ObjectId, 0)
                                , _tmpMaster.FromContainerId

                        ) AS _tmpSumm ON _tmpSumm.GoodsId            = _tmpMaster.GoodsId
                                     AND _tmpSumm.GoodsKindId        = _tmpMaster.GoodsKindId
                                     AND _tmpSumm.InfoMoneyId        = _tmpMaster.InfoMoneyId
                                     AND _tmpSumm.InfoMoneyId_Detail = _tmpMaster.InfoMoneyId_Detail

              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = zc_Unit_RK()

            WHERE _tmpMaster.GoodsKindId        = COALESCE (CLO_GoodsKind.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId        = COALESCE (CLO_InfoMoney.ObjectId, 0)
              AND _tmpMaster.InfoMoneyId_Detail = COALESCE (CLO_InfoMoneyDetail.ObjectId, 0)
        ;

     END IF; -- if inInsert <> 12345

--    RAISE EXCEPTION 'ok.all';

/*
delete from HistoryCost where HistoryCost.ContainerId
in (

SELECT distinct HistoryCost.ContainerId
FROM HistoryCost
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                      ON ContainerLinkObject_InfoMoney.ContainerId = HistoryCost.ContainerId
--                                     AND ContainerLinkObject_InfoMoney.DescId     = zc_ContainerLinkObject_InfoMoney()
                                     AND ContainerLinkObject_InfoMoney.DescId     = zc_ContainerLinkObject_InfoMoneyDetail()
                                     and ContainerLinkObject_InfoMoney.ObjectId      = zc_Enum_InfoMoney_80401() -- ������� �������� �������
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
  OWNER TO admin;
