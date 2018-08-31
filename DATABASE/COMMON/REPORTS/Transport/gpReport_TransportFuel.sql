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
             , MemberId Integer, MemberName TVarChar
             , StartAmount TFloat, InAmount TFloat, OutAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, InSumm TFloat, OutSumm TFloat, EndSumm TFloat
             --, IncomeSumm            TFloat
             , outSumm_ZP            TFloat
             , outSumm_Zatraty       TFloat
             , outSumm_Kompensaciya  TFloat
             , outSumm_Transport     TFloat
             )
AS
$BODY$
  DECLARE vb_Kind_Fuel integer;
  DECLARE vb_Kind_Money integer;
  DECLARE vb_Kind_Ticket integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());

      vb_Kind_Fuel   := 1;
      vb_Kind_Money  := 2;
      vb_Kind_Ticket := 3;

      RETURN QUERY 
      WITH
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

      , Fuel AS (SELECT Container.Id, 
                        Container.DescId, 
                        Container.Amount, 
                        Container.ObjectId AS ObjectId
                 FROM Container 
                      INNER JOIN Object AS Object_Fuel
                                        ON Object_Fuel.DescId = zc_Object_Fuel()
                                       AND Object_Fuel.Id = Container.ObjectId 
                                       AND (Object_Fuel.Id = inFuelId OR inFuelId = 0) 
                )
      , tmpAccount AS (SELECT *
                       FROM Object_Account_View
                       WHERE Object_Account_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400()
                       )

      , tmpContainer AS (SELECT Container.Id, Container.DescId, Container.Amount, Fuel.ObjectId--, Fuel.CarId -- здесь топливо деньги
                         FROM Container 
                              JOIN Fuel ON Container.ParentId = Fuel.Id
                       UNION All 
                         SELECT Fuel.Id, Fuel.DescId, Fuel.Amount, Fuel.ObjectId--, Fuel.CarId -- здесь топливо кол-во
                         FROM Fuel                            
                      )
     -- Для ускорения выбираю отдельно MovementItemContainer для tmpContainer
    , tmpMIContainer AS (SELECT * 
                         FROM MovementItemContainer AS MIContainer 
                         WHERE MIContainer.Containerid IN (SELECT tmpContainer.Id FROM tmpContainer)
                           AND MIContainer.OperDate >= inStartDate
                         )
    -- все документы, участвующие в движении
    , tmpMov AS (SELECT tmpMIContainer.ContainerId
                      , tmpContainer.ObjectId
                      , tmpMIContainer.MovementId
                 FROM tmpContainer
                      INNER JOIN tmpMIContainer ON tmpMIContainer.ContainerId = tmpContainer.Id
                                               AND tmpMIContainer.OperDate <= inEndDate
                 WHERE tmpContainer.DescId = zc_Container_Summ() 
                 )
     -- MovementItemContainer для документов движения для получения сумм расхода в разрезе
    , tmpOutContainer AS (SELECT tmpMov.ContainerId AS ContainerId_main
                               , tmpMov.ObjectId    AS ObjectId_main
                               , MIContainer.*
                         FROM tmpMov
                              LEFT JOIN MovementItemContainer AS MIContainer 
                                                              ON MIContainer.MovementId = tmpMov.MovementId
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                             AND MIContainer.DescId = zc_Container_Summ()
                          )
    -- сумм расхода в разрезе
    , tmpOut AS (SELECT MIContainer.ContainerId_main AS ContainerId
                      , MIContainer.ObjectId_main    AS ObjectId
                      --, MIContainer.MovementId
                      , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ() AND View_Account.AccountDirectionId = zc_Enum_AccountDirection_70100()
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

                      , SUM (CASE WHEN MIContainer.MovementId = zc_Movement_Transport()
                                  THEN MIContainer.Amount ELSE 0 END) AS outSumm_Transport

                 FROM tmpOutContainer AS MIContainer 
                      LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = MIContainer.AccountId 
                      LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss 
                                                    ON CLO_ProfitLoss.ContainerId = MIContainer.ContainerId
                                                   AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                      LEFT JOIN lfSelect_Object_ProfitLoss() AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = CLO_ProfitLoss.ObjectId 
                      LEFT JOIN ObjectLink AS OL_ProfitLoss_InfoMoneyDestination 
                                           ON OL_ProfitLoss_InfoMoneyDestination.ObjectId = CLO_ProfitLoss.ObjectId
                                          AND OL_ProfitLoss_InfoMoneyDestination.DescId = zc_ObjectLink_ProfitLoss_InfoMoneyDestination()
                 GROUP BY MIContainer.ContainerId_main
                        , MIContainer.ObjectId_main   --MIContainer.MovementId,
                 
                 )
    -- расход по путевым
    , tmpTransport AS (SELECT tmpContainer.Id AS ContainerId
                            , tmpContainer.ObjectId
                            , SUM (COALESCE (tmp.Amount, 0) * (-1)) AS outSumm_Transport
                       FROM tmpContainer
                            LEFT JOIN (SELECT MIContainer.* 
                                       FROM MovementItemContainer AS MIContainer 
                                       WHERE MIContainer.ContainerId IN (SELECT tmpContainer.Id FROM tmpContainer)
                                         AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                         AND MIContainer.MovementDescId = zc_Movement_Transport()
                                         AND MIContainer.DescId = zc_Container_Summ()
                                       ) AS tmp ON tmp.ContainerId = tmpContainer.Id 
                       WHERE tmpContainer.DescId = zc_Container_Summ()
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

     -- движение за период кол-во / сумма приход / расход
    , tmpMotion AS (SELECT tmp.ContainerId
                         , tmp.ObjectId
                         , tmp.FromId
                         , SUM (tmp.InAmount)     AS InAmount
                         , SUM (tmp.OutAmount)    AS OutAmount
                         , SUM (tmp.InSumm)       AS InSumm
                         , SUM (tmp.OutSumm)      AS OutSumm

                    FROM (SELECT tmpContainer.Id AS ContainerId
                               , tmpContainer.ObjectId

                               , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                      THEN ObjectLink_CardFuel_Juridical.ChildObjectId --MovementLinkObject_From.ObjectId
                                      ELSE 0
                                 END AS FromId

                               , SUM (CASE WHEN MIContainer.DescId = zc_Container_Count() AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END)   AS InAmount
                               , SUM (CASE WHEN MIContainer.DescId = zc_Container_Count() AND MIContainer.Amount < 0 THEN - MIContainer.Amount ELSE 0 END) AS OutAmount
                               , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()  AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END)   AS InSumm
                               , SUM (CASE WHEN MIContainer.DescId = zc_Container_Summ()  AND MIContainer.Amount < 0 THEN - MIContainer.Amount ELSE 0 END) AS OutSumm

                          FROM tmpContainer
                               LEFT JOIN tmpMIContainer AS MIContainer 
                                                        ON MIContainer.Containerid = tmpContainer.Id
                                                       AND MIContainer.OperDate <= inEndDate

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = MIContainer.MovementId
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                           AND MIContainer.MovementDescId = zc_Movement_Income()
                                                           AND inIsPartner = TRUE
                               LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                                    ON ObjectLink_CardFuel_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                   AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                          GROUP BY tmpContainer.Id, tmpContainer.ObjectId, tmpContainer.DescId
                                 , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                        THEN ObjectLink_CardFuel_Juridical.ChildObjectId --MovementLinkObject_From.ObjectId
                                        ELSE 0
                                   END
                          ) AS tmp
                    GROUP BY tmp.ContainerId
                           , tmp.ObjectId
                           , tmp.FromId
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
                        -- движение приход, расход кол-во
                        SELECT tmp.ContainerId
                             , tmp.ObjectId
                             , COALESCE (tmp.FromId, 0) AS FromId 
                             , 0 AS StartAmount
                             , 0 AS EndAmount
                             , 0 AS StartSumm
                             , 0 AS EndSumm
                             , tmp.InAmount
                             , tmp.OutAmount
                             , tmp.InSumm
                             , tmp.OutSumm
                             , 0 AS outSumm_ZP
                             , 0 AS outSumm_Zatraty
                             , 0 AS outSumm_Kompensaciya
                             , 0 AS outSumm_Transport
                        FROM tmpMotion AS tmp   
                      UNION ALL
                        -- расход зп., компенс, затрат.
                        SELECT tmp.ContainerId
                             , tmp.ObjectId
                             , 0 AS FromId 
                             , 0 AS StartAmount
                             , 0 AS EndAmount
                             , 0 AS StartSumm
                             , 0 AS EndSumm
                             , 0 AS InAmount
                             , 0 AS OutAmount
                             , 0 AS InSumm
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
                             , 0 AS OutAmount
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
                          , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Car.ObjectId ELSE 0 END    AS CarId
                          , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Member.ObjectId ELSE 0 END AS MemberId
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

                          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Member
                                                        ON ContainerLinkObject_Member.DescId = zc_ContainerLinkObject_Member()
                                                       AND ContainerLinkObject_Member.ContainerId = tmpData.ContainerId
                     GROUP BY tmpData.ObjectId
                            , tmpData.FromId
                            , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Car.ObjectId ELSE 0 END 
                            , CASE WHEN inIsCar = TRUE THEN ContainerLinkObject_Member.ObjectId ELSE 0 END
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

             , Object_Member.Id          AS MemberId
             , Object_Member.ValueData   AS MemberName
              
             , tmpData.StartAmount     ::TFloat
             , tmpData.InAmount        ::TFloat
             , tmpData.OutAmount       ::TFloat
             , tmpData.EndAmount       ::TFloat
             , tmpData.StartSumm       ::TFloat
             , tmpData.InSumm          ::TFloat
             , tmpData.OutSumm         ::TFloat
             , tmpData.EndSumm         ::TFloat
             , tmpData.outSumm_ZP            ::TFloat
             , tmpData.outSumm_Zatraty       ::TFloat
             , tmpData.outSumm_Kompensaciya  ::TFloat
             , tmpData.outSumm_Transport     ::TFloat
              
        FROM tmpDataAll AS tmpData
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = tmpData.ObjectId
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpData.CarId
             LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
             LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.MemberId
             
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel 
                                  ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
             
             LEFT JOIN tmpCar ON tmpCar.CarId = tmpData.CarId
             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpCar.BranchId
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
--select * from gpReport_TransportFuel(inStartDate := ('01.06.2018')::TDateTime , inEndDate := ('01.06.2018')::TDateTime , inFuelId:=0, inCarId := 0, inBranchId := 0 , inIsCar:= False :: Boolean, inIsPartner := False ::Boolean , inSession := '5');
