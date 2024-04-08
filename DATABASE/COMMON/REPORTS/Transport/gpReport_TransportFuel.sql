-- Function: gpReport_Transport ()

DROP FUNCTION IF EXISTS gpReport_TransportFuel (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_TransportFuel (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_TransportFuel (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TransportFuel(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inFuelId        Integer   , --
    IN inCarId         Integer   , --
    IN inBranchId      Integer   , -- филиал
    IN inIsCar         Boolean   , --
    IN inIsPartner     Boolean   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (CarModelName TVarChar, CarId Integer, CarCode Integer, CarName TVarChar
             , FuelId Integer, FuelCode Integer, FuelName TVarChar
             , BranchId Integer, BranchName TVarChar
             , FromId Integer, FromName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , StartAmount TFloat, InAmount TFloat, OutAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, InSumm TFloat, OutSumm TFloat, EndSumm TFloat
             , outSumm_Income        TFloat
             , outSumm_ZP            TFloat
             , outSumm_ZP_pl         TFloat
             , outSumm_Zatraty       TFloat
             , outSumm_Kompensaciya  TFloat
             , outSumm_Juridical     TFloat
             , outSumm_virt          TFloat
             , outSumm_Transport     TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());
      vbUserId:= lpGetUserBySession (inSession);
      
      -- !!!Только просмотр Аудитор!!!
      PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

      RETURN QUERY
      WITH
         -- список Авто с ограничением по inBranchId and inCarId
         tmpCar AS (SELECT Object_Car.Id                        AS CarId
                         , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                    FROM Object AS Object_Car
                         LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                              ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id    --ObjectLink_Unit_Branch.ObjectId
                                             AND ObjectLink_Car_Unit.DescId   = zc_ObjectLink_Car_Unit()
                         LEFT JOIN Objectlink AS ObjectLink_Unit_Branch
                                              ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                             AND ObjectLink_Unit_Branch.descid   = zc_Objectlink_Unit_Branch()
                    WHERE Object_Car.DescId = zc_Object_Car()
                      AND (Object_Car.Id = inCarId OR COALESCE (inCarId, 0) = 0)
                      AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                        OR inBranchId = 0
                        OR (inBranchId = zc_Branch_Basis() AND COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) = 0)
                          )
                   )
        -- список Сотрудников с ограничением по inBranchId
      , tmpPersonal AS (SELECT Object_Personal.Id        AS PersonalId
                             , Object_Branch.Id          AS BranchId
                             , Object_Branch.ValueData   AS BranchName
                        FROM Object AS Object_Personal
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                  ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                 AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                  ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                                 AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
                        WHERE Object_Personal.DescId = zc_Object_Personal()
                          AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                            OR inBranchId = 0
                            OR (inBranchId = zc_Branch_Basis() AND COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) = 0)
                              )
                          AND COALESCE (inCarId, 0) = 0 -- если нет ограничения по Авто
                       )

        -- товары у которых есть ObjectLink_Goods_Fuel
      , tmpGoodsFuel AS (SELECT DISTINCT
                                ObjectLink_Goods_Fuel.ObjectId      AS GoodsId
                              , ObjectLink_Goods_Fuel.ChildObjectId AS FuelId
                         FROM ObjectLink AS ObjectLink_Goods_Fuel
                         WHERE ObjectLink_Goods_Fuel.DescId         = zc_ObjectLink_Goods_Fuel()
                           AND ObjectLink_Goods_Fuel.ChildObjectId  > 0
                           AND (ObjectLink_Goods_Fuel.ChildObjectId = inFuelId OR inFuelId = 0)
                        )
        -- список Container.Id - zc_Container_Count, по которым строится отчет
      , tmpContainer_count AS (-- для Fuel
                               SELECT Container.Id
                                    , Container.Amount
                                    , Container.ObjectId AS ObjectId
                               FROM Container
                                    INNER JOIN Object AS Object_Fuel
                                                      ON Object_Fuel.DescId = zc_Object_Fuel()
                                                     AND Object_Fuel.Id = Container.ObjectId
                                                     AND (Object_Fuel.Id = inFuelId OR inFuelId = 0)
                               WHERE Container.DescId = zc_Container_Count()
                              UNION
                               -- для Goods
                               SELECT Container.Id
                                    , Container.Amount
                                    , tmpGoodsFuel.FuelId AS ObjectId
                               FROM Container
                                    INNER JOIN tmpGoodsFuel ON tmpGoodsFuel.GoodsId = Container.ObjectId
                               WHERE Container.DescId = zc_Container_Count()
                              )
        -- список ВСЕ Container.Id - добавлены zc_Container_Summ, по которым строится отчет
      , tmpContainer AS (SELECT tmpContainer_count.Id, zc_Container_Count() AS DescId, tmpContainer_count.Amount
                                -- здесь Fuel
                              , tmpContainer_count.ObjectId
                                -- финальный список группируется по этому полю
                              , tmpContainer_count.Id AS ContainerId_main
                         FROM tmpContainer_count
                        UNION ALL
                         SELECT Container.Id, Container.DescId, Container.Amount
                                -- здесь Fuel
                              , tmpContainer_count.ObjectId
                                -- финальный список группируется по этому полю
                              , tmpContainer_count.Id AS ContainerId_main
                         FROM Container
                              JOIN tmpContainer_count ON tmpContainer_count.Id = Container.ParentId
                         WHERE Container.DescId = zc_Container_Summ()
                        )
  -- Для скорости - отдельно, здесь по ContainerId
, tmpMIContainer_tmp AS (SELECT MIContainer.*
                         FROM MovementItemContainer AS MIContainer
                         WHERE MIContainer.ContainerId IN (SELECT tmpContainer.Id FROM tmpContainer)
                           AND MIContainer.OperDate    >= inStartDate
                        )
    , tmpMIContainer AS (SELECT MIContainer.*
                              , tmpContainer.ContainerId_main
                         FROM tmpContainer
                              INNER JOIN tmpMIContainer_tmp AS MIContainer ON MIContainer.ContainerId = tmpContainer.Id
                        )
      -- список документов прихода, НО в них есть и затраты и т.п.
    , tmpMov AS (SELECT DISTINCT
                        tmpMIContainer.ContainerId_main
                      , tmpMIContainer.MovementId
                 FROM tmpContainer
                      INNER JOIN tmpMIContainer ON tmpMIContainer.ContainerId = tmpContainer.Id
                                               AND tmpMIContainer.OperDate    <= inEndDate
                                               AND tmpMIContainer.MovementDescId = zc_Movement_Income()
                 WHERE tmpContainer.DescId = zc_Container_Count()
--                 AND tmpMIContainer.MovementId IN ( 6248443 ,10253265 , 10252827, 9909118, 9909106)
                 )
      -- Для скорости - отдельно, здесь по MovementId
    , tmpMIContainer_m AS (SELECT tmpMov.ContainerId_main AS ContainerId_main
                                , MIContainer.*
                           FROM tmpMov
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.MovementId = tmpMov.MovementId
                                                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                          )
      -- разобрали суммы - данные по MovementId
    , tmpOut AS (SELECT MIContainer.ContainerId_main      AS ContainerId_main
                      , MovementLinkObject_From.ObjectId  AS FromId
                      --, MIContainer.MovementId -- !!!отладка
                      , 0 AS MovementId -- !!!отладка
                      , SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.DescId = zc_Container_Count() THEN  1 * MIContainer.Amount ELSE 0 END) AS IncomeCount
                      , SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.DescId = zc_Container_Count() THEN -1 * MIContainer.Amount ELSE 0 END) AS OutCount
                        -- Сумма приход
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()
                                   AND COALESCE (MIContainer.Amount,0) < 0
                                   AND View_Account.AccountDirectionId = zc_Enum_AccountDirection_70100() -- Кредиторы + поставщики
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS IncomeSumm
                        -- Сумма расход на ЗП (т.е. сотрудник заправлялся в счет ЗП)
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()
                                   AND (View_Account.AccountDirectionId = zc_Enum_AccountDirection_70500() -- Кредиторы     + Сотрудники + ???Заработная плата???
                                       )
                                       THEN MIContainer.Amount
                                  ELSE 0
                             END) AS outSumm_ZP
                        -- Сумма расход на ЗП (т.е. сотрудник заправлялся в счет ЗП)
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()
                                   AND (-- View_ProfitLoss.ProfitLossId                  = 9342                                 -- "Содержание филиалов" + "услуги полученные"
                                        OL_ProfitLoss_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_21400() -- Общефирменные + услуги полученные
                                       )
                                       THEN MIContainer.Amount
                                  ELSE 0
                             END) AS outSumm_ZP_pl
                        -- Сумма расход - затраты (затраты предприятия)
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()
                                   AND (-- View_ProfitLoss.ProfitLossId = 568166                                                -- "Содержание филиалов" + "ГСМ"
                                        OL_ProfitLoss_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_20400() -- Общефирменные + ГСМ
                                       )
                                       THEN MIContainer.Amount
                                  ELSE 0
                             END) AS outSumm_Zatraty
                        -- Сумма расход - на учредителя (т.е. учредителю меньше потом выплатят)
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()
                                   AND View_Account.AccountDirectionId = zc_Enum_AccountDirection_100400() -- Собственный капитал + Расчеты с участниками
                                       THEN MIContainer.Amount
                                  ELSE 0
                             END) AS outSumm_Kompensaciya

                        -- Сумма расход - на юр лицо (т.е. юр лицо компенсирует эти затраты)
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()
                                   AND View_Account.AccountDirectionId = zc_Enum_AccountDirection_30200() -- Дебиторы + наши компании
                                       THEN MIContainer.Amount
                                  ELSE 0
                             END) AS outSumm_Juridical

                        -- Сумма = Товар в пути
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()
                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                   AND View_Account.AccountGroupId = zc_Enum_AccountGroup_110000() -- Транзит
                                       THEN MIContainer.Amount
                                  ELSE 0
                             END) AS outSumm_virt

                 FROM tmpMIContainer_m AS MIContainer
                      LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = MIContainer.AccountId
                      LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                    ON CLO_ProfitLoss.ContainerId = MIContainer.ContainerId
                                                   AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                      LEFT JOIN lfSelect_Object_ProfitLoss() AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = CLO_ProfitLoss.ObjectId
                      LEFT JOIN ObjectLink AS OL_ProfitLoss_InfoMoneyDestination
                                           ON OL_ProfitLoss_InfoMoneyDestination.ObjectId = CLO_ProfitLoss.ObjectId
                                          AND OL_ProfitLoss_InfoMoneyDestination.DescId = zc_ObjectLink_ProfitLoss_InfoMoneyDestination()
                      -- поставщик
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = MIContainer.MovementId
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                  AND MIContainer.MovementDescId = zc_Movement_Income()
                                                  AND inIsPartner = TRUE
                 GROUP BY MIContainer.ContainerId_main
                        , MovementLinkObject_From.ObjectId
                        -- , MIContainer.MovementId -- !!!отладка
                 )
      -- расход по путевым - данные по ContainerId
    , tmpTransport AS (SELECT tmpMIContainer.ContainerId_main
                            , SUM (CASE WHEN tmpMIContainer.DescId = zc_Container_Count() THEN -1 * tmpMIContainer.Amount ELSE 0 END) AS outCount_Transport
                            , SUM (CASE WHEN tmpMIContainer.DescId = zc_Container_Summ() AND tmpMIContainer.AccountId_Analyzer = zc_Enum_Account_100301() THEN -1 * tmpMIContainer.Amount ELSE 0 END) AS outSumm_Transport
                              -- Сумма затраты в Расходы будущих периодов
                            , SUM (CASE WHEN tmpMIContainer.DescId = zc_Container_Summ() AND COALESCE (tmpMIContainer.AccountId_Analyzer, 0) <> zc_Enum_Account_100301() THEN -1 * tmpMIContainer.Amount ELSE 0 END) AS outSumm_Income
                       FROM tmpMIContainer
                       WHERE tmpMIContainer.OperDate BETWEEN inStartDate AND inEndDate
                         AND tmpMIContainer.MovementDescId = zc_Movement_Transport()
                       GROUP BY tmpMIContainer.ContainerId_main
                      )
      -- остатки кол-во / сумма
    , tmpRemains AS (SELECT tmp.ContainerId_main
                          , tmp.ObjectId
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmp.StartAmount ELSE 0 END)  AS StartAmount
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmp.EndAmount ELSE 0 END)    AS EndAmount
                          , SUM (CASE WHEN DescId = zc_Container_Summ()  THEN tmp.StartAmount ELSE 0 END)  AS StartSumm
                          , SUM (CASE WHEN DescId = zc_Container_Summ()  THEN tmp.EndAmount ELSE 0 END)    AS EndSumm
                     FROM (SELECT tmpContainer.ContainerId_main
                                , tmpContainer.ObjectId
                                , tmpContainer.DescId
                                , tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0))                                                            AS StartAmount
                                , tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount
                           FROM tmpContainer
                                LEFT JOIN tmpMIContainer AS MIContainer
                                                         ON MIContainer.ContainerId = tmpContainer.Id
                           GROUP BY tmpContainer.Id, tmpContainer.ContainerId_main, tmpContainer.ObjectId, tmpContainer.DescId, tmpContainer.Amount
                          ) AS tmp
                     GROUP BY tmp.ContainerId_main
                            , tmp.ObjectId
                    )

      -- собрали остатки и движение - по ContainerId + по MovementId
    , tmpData AS (SELECT tmp.ContainerId
                       , tmp.ObjectId
                       , tmp.FromId
                       , SUM (tmp.StartAmount)  AS StartAmount
                       , SUM (tmp.EndAmount)    AS EndAmount
                       , SUM (tmp.StartSumm)    AS StartSumm
                       , SUM (tmp.EndSumm)      AS EndSumm
                       , SUM (tmp.InAmount)     AS InAmount
                       , SUM (tmp.OutAmount)    AS OutAmount
                       , SUM (tmp.InSumm)       AS InSumm
                       , SUM (tmp.outSumm_Income)       AS outSumm_Income
                       , SUM (tmp.outSumm_ZP)           AS outSumm_ZP
                       , SUM (tmp.outSumm_ZP_pl)        AS outSumm_ZP_pl
                       , SUM (tmp.outSumm_Zatraty)      AS outSumm_Zatraty
                       , SUM (tmp.outSumm_Kompensaciya) AS outSumm_Kompensaciya
                       , SUM (tmp.outSumm_Juridical)    AS outSumm_Juridical
                       , SUM (tmp.outSumm_virt)         AS outSumm_virt
                       , SUM (tmp.outSumm_Transport)    AS outSumm_Transport
                       , tmp.MovementId
                  FROM (--остатки
                        SELECT tmpRemains.ContainerId_main AS ContainerId
                             , tmpRemains.ObjectId
                             , tmpRemains.StartAmount
                             , tmpRemains.EndAmount
                             -- , tmpRemains.StartSumm - COALESCE (tmpOut.outSumm_virt, 0) AS StartSumm
                             , tmpRemains.StartSumm AS StartSumm
                             , tmpRemains.EndSumm

                             , COALESCE (tmpOut.FromId, 0)                  AS FromId
                             , COALESCE (tmpOut.MovementId, 0)              AS MovementId
                             , COALESCE (tmpOut.IncomeCount, 0)             AS InAmount
                             , COALESCE (tmpOut.OutCount, 0) + COALESCE (tmpTransport.outCount_Transport, 0) AS OutAmount
                             -- , COALESCE (tmpOut.IncomeSumm, 0)              AS InSumm
                             , COALESCE (tmpOut.IncomeSumm, 0) - COALESCE (tmpOut.outSumm_virt, 0) AS InSumm
                             , COALESCE (tmpTransport.outSumm_Income, 0)    AS outSumm_Income
                             , COALESCE (tmpOut.outSumm_ZP, 0)              AS outSumm_ZP
                             , COALESCE (tmpOut.outSumm_ZP_pl, 0)           AS outSumm_ZP_pl
                             , COALESCE (tmpOut.outSumm_Zatraty, 0)         AS outSumm_Zatraty
                             , COALESCE (tmpOut.outSumm_Kompensaciya, 0)    AS outSumm_Kompensaciya
                             , COALESCE (tmpOut.outSumm_Juridical, 0)       AS outSumm_Juridical
                             , COALESCE (tmpOut.outSumm_virt, 0)            AS outSumm_virt
                             , COALESCE (tmpTransport.outSumm_Transport, 0) AS outSumm_Transport
                        FROM tmpRemains
                             LEFT JOIN tmpOut       ON tmpOut.ContainerId_main       = tmpRemains.ContainerId_main
                             LEFT JOIN tmpTransport ON tmpTransport.ContainerId_main = tmpRemains.ContainerId_main
                       ) AS tmp
                  GROUP BY tmp.ContainerId
                         , tmp.ObjectId
                         , tmp.FromId
                         , tmp.MovementId
                  )
      -- добавляются свойства ContainerLinkObject
    , tmpDataAll AS (SELECT tmpData.ObjectId
                          , tmpData.FromId
                          , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Car.ObjectId ELSE 0 END  AS CarId
                          , CASE WHEN inIsCar = TRUE THEN COALESCE (ContainerLinkObject_Unit.ObjectId, ContainerLinkObject_Juridical.ObjectId) ELSE 0 END AS PersonalId
                          , SUM (tmpData.StartAmount)  AS StartAmount
                          , SUM (tmpData.EndAmount)    AS EndAmount
                          , SUM (tmpData.StartSumm)    AS StartSumm
                          , SUM (tmpData.EndSumm)      AS EndSumm
                          , SUM (tmpData.InAmount)     AS InAmount
                          , SUM (tmpData.OutAmount)    AS OutAmount
                          , SUM (tmpData.InSumm)       AS InSumm
                          , SUM (tmpData.outSumm_Income)       AS outSumm_Income
                          , SUM (tmpData.outSumm_ZP)           AS outSumm_ZP
                          , SUM (tmpData.outSumm_ZP_pl)        AS outSumm_ZP_pl
                          , SUM (tmpData.outSumm_Zatraty)      AS outSumm_Zatraty
                          , SUM (tmpData.outSumm_Kompensaciya) AS outSumm_Kompensaciya
                          , SUM (tmpData.outSumm_Juridical)    AS outSumm_Juridical
                          , SUM (tmpData.outSumm_virt)         AS outSumm_virt
                          , SUM (tmpData.outSumm_Transport)    AS outSumm_Transport
                          , tmpData.MovementId
                     FROM tmpData
                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                                        ON ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                                       AND ContainerLinkObject_Car.ContainerId = tmpData.ContainerId

                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                        ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                       AND ContainerLinkObject_Unit.ContainerId = tmpData.ContainerId

                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                        ON ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                       AND ContainerLinkObject_Juridical.ContainerId = tmpData.ContainerId
                                                       AND 1=0

                          LEFT JOIN tmpCar      ON tmpCar.CarId           = ContainerLinkObject_Car.ObjectId
                          LEFT JOIN tmpPersonal ON tmpPersonal.PersonalId = ContainerLinkObject_Unit.ObjectId

                     WHERE (ContainerLinkObject_Car.ObjectId = inCarId OR inCarId = 0)
                       AND ((COALESCE (tmpCar.BranchId, tmpPersonal.BranchId,0) = inBranchId OR inBranchId = 0) OR (inBranchId = zc_Branch_Basis() AND COALESCE (tmpCar.BranchId, tmpPersonal.BranchId,0) = 0))
                     GROUP BY tmpData.ObjectId
                            , tmpData.FromId
                            , tmpData.MovementId
                            , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Car.ObjectId ELSE 0 END
                            , CASE WHEN inIsCar = TRUE THEN COALESCE (ContainerLinkObject_Unit.ObjectId, ContainerLinkObject_Juridical.ObjectId) ELSE 0 END
                     HAVING SUM (tmpData.StartAmount)  <> 0
                         OR SUM (tmpData.EndAmount)    <> 0
                         OR SUM (tmpData.StartSumm)    <> 0
                         OR SUM (tmpData.EndSumm)      <> 0
                         OR SUM (tmpData.InAmount)     <> 0
                         OR SUM (tmpData.OutAmount)    <> 0
                         OR SUM (tmpData.InSumm)       <> 0
                         OR SUM (tmpData.outSumm_Income)   <> 0
                         OR SUM (tmpData.outSumm_ZP)       <> 0
                         OR SUM (tmpData.outSumm_ZP_pl)    <> 0
                         OR SUM (tmpData.outSumm_Zatraty)  <> 0
                         OR SUM (tmpData.outSumm_Kompensaciya) <> 0
                         OR SUM (tmpData.outSumm_Juridical)    <> 0
                         OR SUM (tmpData.outSumm_virt)         <> 0
                         OR SUM (tmpData.outSumm_Transport)    <> 0
                     )

       -- результат
        SELECT (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , tmpData.CarId             AS CarId
             , Object_Car.ObjectCode     AS CarCode
             , Object_Car.ValueData      AS CarName
             -- , tmpData.MovementId :: TVarChar AS CarName

             , tmpData.ObjectId          AS FuelId
             , Object_Fuel.ObjectCode    AS FuelCode
             , Object_Fuel.ValueData     AS FuelName

             , Object_Branch.Id          AS BranchId
             , Object_Branch.ValueData   AS BranchName

             , tmpData.FromId            AS FromId
             , Object_From.ValueData     AS FromName

             , COALESCE (tmpData.PersonalId, ObjectLink_Car_PersonalDriver.ChildObjectId) :: Integer AS PersonalId
             , Object_Personal.ValueData   AS PersonalName

             , tmpData.StartAmount           ::TFloat
             , tmpData.InAmount              ::TFloat
             , tmpData.OutAmount             ::TFloat
             , tmpData.EndAmount             ::TFloat
             , tmpData.StartSumm             ::TFloat
             , tmpData.InSumm                ::TFloat
             , (COALESCE (tmpData.outSumm_Income, 0)
              + COALESCE (tmpData.outSumm_ZP, 0)           + COALESCE (tmpData.outSumm_Zatraty, 0)
              + COALESCE (tmpData.outSumm_ZP_pl, 0)
              + COALESCE (tmpData.outSumm_Kompensaciya, 0) + COALESCE (tmpData.outSumm_Juridical, 0)
              + COALESCE (tmpData.outSumm_Transport, 0)
               ) ::TFloat AS OutSumm
             , tmpData.EndSumm               ::TFloat
             , tmpData.outSumm_Income        ::TFloat
             , tmpData.outSumm_ZP            ::TFloat
             , (1 * tmpData.outSumm_ZP_pl)   ::TFloat
             , tmpData.outSumm_Zatraty       ::TFloat
             , tmpData.outSumm_Kompensaciya  ::TFloat
             , tmpData.outSumm_Juridical     ::TFloat
             , tmpData.outSumm_virt          ::TFloat
             , tmpData.outSumm_Transport     ::TFloat

        FROM tmpDataAll AS tmpData
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = tmpData.ObjectId
             LEFT JOIN Object AS Object_Car  ON Object_Car.Id  = tmpData.CarId

             LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                  ON ObjectLink_CardFuel_Juridical.ObjectId = tmpData.FromId
                                 AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
             LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE (ObjectLink_CardFuel_Juridical.ChildObjectId, tmpData.FromId)

             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                  ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                  ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
             LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

             LEFT JOIN tmpCar      ON tmpCar.CarId           = tmpData.CarId
             LEFT JOIN tmpPersonal ON tmpPersonal.PersonalId = tmpData.PersonalId

             LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver
                                  ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_PersonalDriver.DescId   = zc_ObjectLink_Car_PersonalDriver()

             LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = COALESCE (tmpCar.BranchId, tmpPersonal.BranchId)
             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = COALESCE (tmpData.PersonalId, ObjectLink_Car_PersonalDriver.ChildObjectId)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.08.18         *
*/

-- тест
-- SELECT * FROM gpReport_TransportFuel (inStartDate:= '01.06.2019', inEndDate:= '01.06.2019', inFuelId:= 0, inCarId:= 0, inBranchId:= 0, inIsCar:= FALSE, inIsPartner:= FALSE, inSession:= zfCalc_UserAdmin());