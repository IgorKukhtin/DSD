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
             , FuelCode Integer, FuelName TVarChar
             , BranchId Integer, BranchName TVarChar
             , FromId Integer, FromName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , StartAmount TFloat, InAmount TFloat, OutAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, InSumm TFloat, OutSumm TFloat, EndSumm TFloat
             , outSumm_ZP            TFloat
             , outSumm_Zatraty       TFloat
             , outSumm_Kompensaciya  TFloat
             , outSumm_Transport     TFloat
             )
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());

      RETURN QUERY 
      WITH
         -- авто, согласно вх. параметров, все / выбранный / ограничннные филиалом
         tmpCar AS (SELECT tmp.CarId
                         , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                    FROM (SELECT inCarId AS CarId) AS tmp
                         LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                              ON ObjectLink_Car_Unit.ObjectId = tmp.CarId
                                             AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch 
                                              ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                             AND ObjectLink_Unit_Branch.DescId = zc_Objectlink_Unit_Branch()
                    WHERE COALESCE (inCarId, 0) <> 0
                        AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId OR inBranchId = 0 OR (inBranchId = zc_Branch_Basis() AND COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) = 0)) 
                   UNION
                    SELECT ObjectLink_Car_Unit.ObjectId         AS CarId
                         , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                    FROM Object AS Object_Car
                         LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                              ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id    --ObjectLink_Unit_Branch.ObjectId
                                             AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                         LEFT JOIN Objectlink AS ObjectLink_Unit_Branch
                                              ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                             AND ObjectLink_Unit_Branch.descid = zc_Objectlink_Unit_Branch()
                    WHERE Object_Car.DescId = zc_Object_Car()
                      AND COALESCE (inCarId, 0) = 0
                      AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId OR inBranchId = 0 OR (inBranchId = zc_Branch_Basis() AND COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) = 0))
                    )
      , tmpPersonal AS (SELECT Object_Personal.Id        AS PersonalId
                             , Object_Branch.Id          AS BranchId
                             , Object_Branch.ValueData   AS BranchName
                        FROM Object AS Object_Personal
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                  ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                  ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                                 AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
                        WHERE Object_Personal.DescId = zc_Object_Personal()
                          AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId OR inBranchId = 0 OR (inBranchId = zc_Branch_Basis() AND COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) = 0))
                       )

      -- товарам у которых есть ObjectLink_Goods_Fuel
      , tmpGoodsFuel AS (-- по топливу
                         SELECT DISTINCT
                                ObjectLink_Goods_Fuel.ObjectId      AS GoodsId
                              , ObjectLink_Goods_Fuel.ChildObjectId AS FuelId
                         FROM ObjectLink AS ObjectLink_Goods_Fuel
                         WHERE ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                           AND COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 
                           AND (ObjectLink_Goods_Fuel.ChildObjectId = inFuelId OR inFuelId = 0)

                         )
      , Fuel AS (-- по топливу
                 SELECT Container.Id, 
                        Container.DescId, 
                        Container.Amount, 
                        Container.ObjectId AS ObjectId
                 FROM Container 
                      INNER JOIN Object AS Object_Fuel
                                        ON Object_Fuel.DescId = zc_Object_Fuel()
                                       AND Object_Fuel.Id = Container.ObjectId 
                                       AND (Object_Fuel.Id = inFuelId OR inFuelId = 0)
                UNION
                 -- по товарам
                 SELECT Container.Id, 
                        Container.DescId, 
                        Container.Amount, 
                        tmpGoodsFuel.FuelId  AS ObjectId
                 FROM Container
                      INNER JOIN tmpGoodsFuel ON tmpGoodsFuel.GoodsId = Container.ObjectId 
                )

      , tmpContainer AS (SELECT Container.Id, Container.DescId, Container.Amount, Fuel.ObjectId--, Fuel.CarId -- здесь топливо деньги для получения сумм остатков
                         FROM Container 
                              JOIN Fuel ON Container.ParentId = Fuel.Id
                       UNION All 
                         SELECT Fuel.Id, Fuel.DescId, Fuel.Amount, Fuel.ObjectId--, Fuel.CarId -- здесь топливо кол-во
                         FROM Fuel                            
                      )
     -- Для ускорения выбираю отдельно MovementItemContainer для tmpContainer
    , tmpMIContainer AS (SELECT * 
                         FROM MovementItemContainer AS MIContainer 
                         WHERE MIContainer.Containerid IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                           AND MIContainer.OperDate >= inStartDate
                         )
    -- все документы прихода, участвующие в движении
    , tmpMov AS (SELECT tmpMIContainer.ContainerId
                      , tmpContainer.ObjectId
                      , tmpMIContainer.MovementId
                 FROM tmpContainer
                      INNER JOIN tmpMIContainer ON tmpMIContainer.ContainerId = tmpContainer.Id
                                               AND tmpMIContainer.OperDate <= inEndDate
                                               AND tmpMIContainer.MovementDescId = zc_Movement_Income()
                 WHERE tmpContainer.DescId = zc_Container_Count() 
                 )
     -- MovementItemContainer для документов движения для получения сумм прихода / расхода
    , tmpOutContainer AS (SELECT tmpMov.ContainerId AS ContainerId_main
                               , tmpMov.ObjectId    AS ObjectId_main
                               , MIContainer.*
                         FROM tmpMov
                              LEFT JOIN MovementItemContainer AS MIContainer 
                                                              ON MIContainer.MovementId = tmpMov.MovementId
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                          )
    -- суммы прихода / расхода
    , tmpOut AS (SELECT MIContainer.ContainerId_main AS ContainerId
                      , MIContainer.ObjectId_main    AS ObjectId
                      , ObjectLink_CardFuel_Juridical.ChildObjectId  AS FromId  --MovementLinkObject_From.ObjectId
                      --, MIContainer.MovementId
                      , SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.DescId = 1 THEN MIContainer.Amount ELSE 0 END)      AS IncomeCount
                      , SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.DescId = 1 THEN -1 * MIContainer.Amount ELSE 0 END) AS OutCount
                       
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ() AND  COALESCE (MIContainer.Amount,0) < 0 and View_Account.AccountDirectionId = zc_Enum_AccountDirection_70100()
                                  THEN -1 * MIContainer.Amount ELSE 0 END) AS IncomeSumm
                               
                      , SUM (CASE WHEN (View_ProfitLoss.ProfitLossId = 9342 -- "Содержание филиалов" + "услуги полученные"
                                          OR View_Account.AccountDirectionId = zc_Enum_AccountDirection_70500()
                                        )
                                       AND MIContainer.DescId = zc_Container_Summ() THEN MIContainer.Amount ELSE 0 END ) AS outSumm_ZP
                      
                      , SUM (CASE WHEN (OL_ProfitLoss_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_20400()
                                        OR View_ProfitLoss.ProfitLossId = 568166 -- "Содержание филиалов" + "ГСМ"
                                       )
                                       AND MIContainer.DescId = zc_Container_Summ() THEN MIContainer.Amount ELSE 0 END) AS outSumm_Zatraty
                      
                      , SUM (CASE WHEN View_Account.AccountDirectionId = zc_Enum_AccountDirection_100400() AND MIContainer.DescId = zc_Container_Summ()
                                  THEN MIContainer.Amount ELSE 0 END) AS outSumm_Kompensaciya

                 FROM tmpOutContainer AS MIContainer 
                      LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = MIContainer.AccountId 
                      LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss 
                                                    ON CLO_ProfitLoss.ContainerId = MIContainer.ContainerId
                                                   AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
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
                      LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                           ON ObjectLink_CardFuel_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                          AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                                                   
                 GROUP BY MIContainer.ContainerId_main
                        , MIContainer.ObjectId_main
                        , ObjectLink_CardFuel_Juridical.ChildObjectId
                 
                 )
    -- расход по путевым
    , tmpTransport AS (SELECT tmpContainer.Id AS ContainerId
                            , tmpContainer.ObjectId
                            , SUM (CASE WHEN tmpContainer.DescId = zc_Container_Count() THEN COALESCE (tmp.Amount, 0) * (-1) ELSE 0 END) AS outCount_Transport
                            , SUM (CASE WHEN tmpContainer.DescId = zc_Container_Summ() THEN COALESCE (tmp.Amount, 0)  * (-1) ELSE 0 END) AS outSumm_Transport
                       FROM tmpContainer
                            LEFT JOIN (SELECT MIContainer.* 
                                       FROM MovementItemContainer AS MIContainer 
                                       WHERE MIContainer.ContainerId IN (SELECT tmpContainer.Id FROM tmpContainer)
                                         AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                         AND MIContainer.MovementDescId = zc_Movement_Transport()
                                         --AND MIContainer.DescId = zc_Container_Summ()
                                       ) AS tmp ON tmp.ContainerId = tmpContainer.Id 
                       --WHERE tmpContainer.DescId = zc_Container_Summ()
                       GROUP BY tmpContainer.Id
                              , tmpContainer.ObjectId
                       )
                       
    -- остатки кол-во / сумма
    , tmpRemains AS (SELECT tmp.ContainerId
                          , tmp.ObjectId
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmp.StartAmount ELSE 0 END)  AS StartAmount
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmp.EndAmount ELSE 0 END)    AS EndAmount
                          , SUM (CASE WHEN DescId = zc_Container_Summ() THEN tmp.StartAmount ELSE 0 END)   AS StartSumm
                          , SUM (CASE WHEN DescId = zc_Container_Summ() THEN tmp.EndAmount ELSE 0 END)     AS EndSumm
                     FROM (SELECT tmpContainer.Id AS ContainerId
                                , tmpContainer.ObjectId
                                , tmpContainer.DescId
                                , tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0))                                                            AS StartAmount
                                , tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount
                           FROM tmpContainer
                                LEFT JOIN tmpMIContainer AS MIContainer 
                                                         ON MIContainer.Containerid = tmpContainer.Id
                           GROUP BY tmpContainer.Amount, tmpContainer.Id, tmpContainer.ObjectId, tmpContainer.DescId
                           ) AS tmp
                     GROUP BY tmp.ContainerId
                            , tmp.ObjectId
                     )

     -- соединили остатки и движение и все остальное
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
                       , SUM (tmp.OutSumm)      AS OutSumm
                       , SUM (tmp.outSumm_ZP)           AS outSumm_ZP
                       , SUM (tmp.outSumm_Zatraty)      AS outSumm_Zatraty
                       , SUM (tmp.outSumm_Kompensaciya) AS outSumm_Kompensaciya
                       , SUM (tmp.outSumm_Transport)    AS outSumm_Transport
                  FROM (--остатки
                        SELECT tmp.ContainerId
                             , tmp.ObjectId
                             , 0 AS FromId
                             , tmp.StartAmount
                             , tmp.EndAmount
                             , tmp.StartSumm
                             , tmp.EndSumm
                             , 0 AS InAmount
                             , 0 AS OutAmount
                             , 0 AS InSumm
                             , 0 AS OutSumm
                             , 0 AS outSumm_ZP
                             , 0 AS outSumm_Zatraty
                             , 0 AS outSumm_Kompensaciya
                             , 0 AS outSumm_Transport
                        FROM tmpRemains AS tmp
                      UNION ALL
                        -- расход зп., компенс, затрат., приход
                        SELECT tmp.ContainerId
                             , tmp.ObjectId
                             , COALESCE (tmp.FromId, 0) AS FromId 
                             , 0 AS StartAmount
                             , 0 AS EndAmount
                             , 0 AS StartSumm
                             , 0 AS EndSumm
                             , tmp.IncomeCount AS InAmount
                             , tmp.OutCount    AS OutAmount
                             , tmp.IncomeSumm  AS InSumm
                             , 0 AS OutSumm
                             , tmp.outSumm_ZP
                             , tmp.outSumm_Zatraty
                             , tmp.outSumm_Kompensaciya
                             , 0 AS outSumm_Transport
                        FROM tmpOut AS tmp  
                      UNION ALL
                        -- расход пут. лист
                        SELECT tmp.ContainerId
                             , tmp.ObjectId
                             , 0 AS FromId 
                             , 0 AS StartAmount
                             , 0 AS EndAmount
                             , 0 AS StartSumm
                             , 0 AS EndSumm
                             , 0 AS InAmount
                             , tmp.outCount_Transport AS OutAmount
                             , 0 AS InSumm
                             , 0 AS OutSumm
                             , 0 AS outSumm_ZP
                             , 0 AS outSumm_Zatraty
                             , 0 AS outSumm_Kompensaciya
                             , tmp.outSumm_Transport
                        FROM tmpTransport AS tmp 
                        ) AS tmp
                  GROUP BY tmp.ContainerId
                         , tmp.ObjectId
                         , tmp.FromId
                  )
    -- привязываю по контейнерам свойства
    , tmpDataAll AS (SELECT tmpData.ObjectId
                          , tmpData.FromId
                          , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Car.ObjectId ELSE 0 END  AS CarId
                          , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Unit.ObjectId ELSE 0 END AS PersonalId
                          , SUM (tmpData.StartAmount)  AS StartAmount
                          , SUM (tmpData.EndAmount)    AS EndAmount
                          , SUM (tmpData.StartSumm)    AS StartSumm
                          , SUM (tmpData.EndSumm)      AS EndSumm
                          , SUM (tmpData.InAmount)     AS InAmount
                          , SUM (tmpData.OutAmount)    AS OutAmount
                          , SUM (tmpData.InSumm)       AS InSumm
                          , SUM (tmpData.OutSumm)      AS OutSumm
                          , SUM (tmpData.outSumm_ZP)           AS outSumm_ZP
                          , SUM (tmpData.outSumm_Zatraty)      AS outSumm_Zatraty
                          , SUM (tmpData.outSumm_Kompensaciya) AS outSumm_Kompensaciya
                          , SUM (tmpData.outSumm_Transport)    AS outSumm_Transport
                     FROM tmpData
                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                                        ON ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                                       AND ContainerLinkObject_Car.ContainerId = tmpData.ContainerId

                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                        ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                       AND ContainerLinkObject_Unit.ContainerId = tmpData.ContainerId

                          LEFT JOIN tmpCar ON tmpCar.CarId = ContainerLinkObject_Car.ObjectId
                          LEFT JOIN tmpPersonal ON tmpPersonal.PersonalId = ContainerLinkObject_Unit.ObjectId

                     WHERE (ContainerLinkObject_Car.ObjectId = inCarId OR inCarId = 0) 
                       AND ((COALESCE (tmpCar.BranchId, tmpPersonal.BranchId,0) = inBranchId OR inBranchId = 0) OR (inBranchId = zc_Branch_Basis() AND COALESCE (tmpCar.BranchId, tmpPersonal.BranchId,0) = 0))
                     GROUP BY tmpData.ObjectId
                            , tmpData.FromId
                            , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Car.ObjectId ELSE 0 END 
                            , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Unit.ObjectId ELSE 0 END
                     HAVING SUM (tmpData.StartAmount)  <> 0
                         OR SUM (tmpData.EndAmount)    <> 0
                         OR SUM (tmpData.StartSumm)    <> 0
                         OR SUM (tmpData.EndSumm)      <> 0
                         OR SUM (tmpData.InAmount)     <> 0
                         OR SUM (tmpData.OutAmount)    <> 0
                         OR SUM (tmpData.InSumm)       <> 0
                         OR SUM (tmpData.OutSumm)      <> 0
                         OR SUM (tmpData.outSumm_ZP)       <> 0
                         OR SUM (tmpData.outSumm_Zatraty)  <> 0
                         OR SUM (tmpData.outSumm_Kompensaciya) <> 0
                         OR SUM (tmpData.outSumm_Transport)    <> 0
                     )

       -- результат 
        SELECT Object_CarModel.ValueData AS CarModelName
             , Object_Car.Id             AS CarId
             , Object_Car.ObjectCode     AS CarCode
             , Object_Car.ValueData      AS CarName
             , Object_Fuel.ObjectCode    AS FuelCode
             , Object_Fuel.ValueData     AS FuelName
              
             , Object_Branch.Id          AS BranchId
             , Object_Branch.ValueData   AS BranchName

             , Object_From.Id            AS FromId
             , Object_From.ValueData     AS FromName

             , Object_Personal.Id          AS PersonalId
             , Object_Personal.ValueData   AS PersonalName
              
             , tmpData.StartAmount           ::TFloat
             , tmpData.InAmount              ::TFloat
             , tmpData.OutAmount             ::TFloat
             , tmpData.EndAmount             ::TFloat
             , tmpData.StartSumm             ::TFloat
             , tmpData.InSumm                ::TFloat
             , tmpData.OutSumm               ::TFloat
             , tmpData.EndSumm               ::TFloat
             , tmpData.outSumm_ZP            ::TFloat
             , tmpData.outSumm_Zatraty       ::TFloat
             , tmpData.outSumm_Kompensaciya  ::TFloat
             , tmpData.outSumm_Transport     ::TFloat
              
        FROM tmpDataAll AS tmpData
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = tmpData.ObjectId
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpData.CarId
             LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
             
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel 
                                  ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
             
             LEFT JOIN tmpCar ON tmpCar.CarId = tmpData.CarId
             LEFT JOIN tmpPersonal ON tmpPersonal.PersonalId = tmpData.PersonalId
             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = COALESCE (tmpCar.BranchId, tmpPersonal.BranchId)
             
             LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver 
                                  ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                                 
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
-- select * from gpReport_TransportFuel(inStartDate := ('01.06.2018')::TDateTime , inEndDate := ('01.06.2018')::TDateTime , inFuelId:=0, inCarId := 0, inBranchId := 0 , inIsCar:= False :: Boolean, inIsPartner := False ::Boolean , inSession := '5');
