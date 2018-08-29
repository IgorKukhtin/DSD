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
    IN inIsMember      Boolean   , --
    IN inIsPartner     Boolean   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (CarModelName TVarChar, CarId Integer, CarCode Integer, CarName TVarChar
             , FuelCode Integer, FuelName TVarChar, KindId Integer
             , BranchId Integer, BranchName TVarChar
             , FromId Integer, FromName TVarChar
             , MemberId Integer, MemberName TVarChar
             , StartAmount TFloat, InAmount TFloat, OutAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, InSumm TFloat, OutSumm TFloat, EndSumm TFloat
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
                UNION
                 SELECT ObjectLink_Car_Unit.ObjectId         AS CarId
                      , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                 FROM Objectlink AS ObjectLink_Unit_Branch
                      INNER JOIN ObjectLink AS ObjectLink_Car_Unit 
                                            ON ObjectLink_Car_Unit.ChildObjectId =  ObjectLink_Unit_Branch.ObjectId
                                           AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                 WHERE ObjectLink_Unit_Branch.descid = zc_Objectlink_Unit_Branch()
                     AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId OR inBranchId = 0)
                     AND COALESCE (inCarId, 0) = 0
                )

           -- Получили все нужные нам контейнеры по талонам, топливу и деньгам, в разрезе авто и топлива
           -- Еще и ограничили их по топливу и авто
    , TicketFuel AS (SELECT Container.Id
                          , Container.DescId
                          , Container.Amount
                          , Container.ObjectId AS ObjectId
                          , tmpMemberCar.CarId -- здесь талоны в разрезе авто
                     FROM Container
                          INNER JOIN ObjectLink AS ObjectLink_TicketFuel_Goods
                                                ON ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
                                               AND ObjectLink_TicketFuel_Goods.ChildObjectId = Container.ObjectId 
                                               AND (ObjectLink_TicketFuel_Goods.ObjectId = inFuelId OR inFuelId = 0) 
                          INNER JOIN ContainerLinkObject AS ContainerLinkObject_Member
                                                         ON ContainerLinkObject_Member.DescId = zc_ContainerLinkObject_Member()
                                                        AND ContainerLinkObject_Member.ContainerId = Container.Id
                          LEFT JOIN (SELECT MAX (ObjectLink_Car_PersonalDriver.ObjectId) AS CarId
                                          , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                     FROM tmpCar
                                          INNER JOIN ObjectLink AS ObjectLink_Car_PersonalDriver
                                                                ON ObjectLink_Car_PersonalDriver.ObjectId = tmpCar.CarId
                                                               AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Car_PersonalDriver.ChildObjectId
                                                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                     GROUP BY ObjectLink_Personal_Member.ChildObjectId
                                     ) AS tmpMemberCar
                                       ON tmpMemberCar.MemberId = ContainerLinkObject_Member.ObjectId
                     )
    , Fuel AS (SELECT Container.Id
                    , Container.DescId 
                    , Container.Amount
                    , Container.ObjectId AS ObjectId
                    , ContainerLinkObject_Car.ObjectId AS CarId-- здесь топливо в разрезе авто
               FROM Container 
                    INNER JOIN Object AS Object_Fuel
                                      ON Object_Fuel.DescId = zc_Object_Fuel()
                                     AND Object_Fuel.Id = Container.ObjectId 
                                     AND (Object_Fuel.Id = inFuelId OR inFuelId = 0) 
                    INNER JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                                   ON ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                                  AND ContainerLinkObject_Car.ContainerId = Container.Id
                    INNER JOIN tmpCar ON tmpCar.CarId = ContainerLinkObject_Car.ObjectId
              )
    
    , tmpAccount AS (SELECT *
                     FROM Object_Account_View
                     WHERE Object_Account_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400()
                     )
    , tmpContainer AS (SELECT Container.Id, Container.DescId, Container.Amount, TicketFuel.ObjectId, TicketFuel.CarId, vb_Kind_Ticket as KindId -- здесь талоны деньги
                       FROM Container 
                            JOIN TicketFuel ON Container.ParentId = TicketFuel.id
                            JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                                           AND tmpAccount.AccountDirectionId = zc_Enum_AccountDirection_20500()
                    UNION All 
                       SELECT TicketFuel.Id, TicketFuel.DescId, TicketFuel.Amount, TicketFuel.ObjectId, TicketFuel.CarId, vb_Kind_Ticket as KindId -- здесь талоны кол-во
                       FROM TicketFuel       
                    UNION ALL 
                      SELECT Container.Id, Container.DescId, Container.Amount, Fuel.ObjectId, Fuel.CarId, vb_Kind_Fuel as KindId -- здесь топливо деньги
                      FROM Container 
                           JOIN Fuel ON Container.ParentId = Fuel.Id
                           JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                                          AND tmpAccount.AccountGroupId = zc_Enum_AccountGroup_20000()
                   UNION All 
                      SELECT Fuel.Id, Fuel.DescId, Fuel.Amount, Fuel.ObjectId, Fuel.CarId, vb_Kind_Fuel as KindId -- здесь топливо кол-во
                      FROM Fuel                            
                   UNION ALL
                      SELECT Container.Id, Container.DescId, Container.Amount, 0  AS ObjectId, ContainerLinkObject_Car.ObjectId AS CarId,  vb_Kind_Money as KindId -- деньги
                      FROM Container 
                           JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                                          AND tmpAccount.AccountDirectionId = zc_Enum_AccountDirection_30500()
                             -- Ограничили по авто, если надо
                           JOIN ContainerLinkObject AS ContainerLinkObject_Car 
                                                    ON Container.iD = ContainerId AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car() 
                                                   AND COALESCE(ContainerLinkObject_Car.ObjectId, 0) <> 0
                                                  -- AND (ContainerLinkObject_Car.ObjectId = inCarId OR inCarId = 0)
                           INNER JOIN tmpCar ON tmpCar.CarId = ContainerLinkObject_Car.ObjectId
                   )
                   
    , tmpContainer1 AS (SELECT tmpContainer.Id
                             , tmpContainer.CarId
                             , tmpContainer.ObjectId
                             , tmpContainer.DescId
                             , tmpContainer.KindId
                             , tmpContainer.Amount
                             , CASE WHEN inIsMember = TRUE THEN CLO_Member.ObjectId ELSE 0 END AS MemberId
                        FROM tmpContainer
                             LEFT JOIN ContainerLinkObject AS CLO_Member 
                                                           ON CLO_Member.ContainerId = tmpContainer.Id
                                                          AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                        )
              -- Получаем оборотку по контейнерам. 
    , tmpData AS (SELECT tmpContainer.Id
                       , tmpContainer.CarId
                       , tmpContainer.ObjectId
                       , tmpContainer.DescId
                       , tmpContainer.KindId
                       , tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0)                                                                             AS StartAmount
                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)   AS InAmount
                       , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN - MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutAmount
                       , tmpContainer.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                  AS EndAmount
                       , CASE WHEN inIsPartner = TRUE AND MIContainer.MovementDescId = zc_Movement_Income()
                              THEN MovementLinkObject_From.ObjectId
                              ELSE 0
                         END AS FromId               -- поставщик приход
                       , tmpContainer.MemberId
                  FROM tmpContainer1 AS tmpContainer
                       LEFT JOIN MovementItemContainer AS MIContainer 
                                                       ON MIContainer.Containerid = tmpContainer.Id
                                                      AND MIContainer.OperDate >= inStartDate
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = MIContainer.MovementId
                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                  GROUP BY tmpContainer.Amount, tmpContainer.Id, tmpContainer.CarId, tmpContainer.ObjectId, tmpContainer.DescId, tmpContainer.KindId
                         , CASE WHEN inIsPartner = TRUE AND MIContainer.MovementDescId = zc_Movement_Income()
                                THEN MovementLinkObject_From.ObjectId
                                ELSE 0
                           END
                         , tmpContainer.MemberId
                  )
      -- Получили оборотку, развернутую на количество и сумму, cгруппированную по топливу и автомобилю
    , tmpDataAll AS (SELECT tmpData.CarId
                          , tmpData.ObjectId
                          , tmpData.KindId
                          , tmpData.FromId
                          , tmpData.MemberId
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmpData.StartAmount ELSE 0 END)  AS StartCount
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmpData.InAmount ELSE 0 END)     AS InCount
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmpData.OutAmount ELSE 0 END)    AS OutCount
                          , SUM (CASE WHEN DescId = zc_Container_Count() THEN tmpData.EndAmount ELSE 0 END)    AS EndCount
                          , SUM (CASE WHEN DescId = zc_Container_Summ() THEN tmpData.StartAmount ELSE 0 END)   AS StartSumm
                          , SUM (CASE WHEN DescId = zc_Container_Summ() THEN tmpData.InAmount ELSE 0 END)      AS InSumm
                          , SUM (CASE WHEN DescId = zc_Container_Summ() THEN tmpData.OutAmount ELSE 0 END)     AS OutSumm
                          , SUM (CASE WHEN DescId = zc_Container_Summ() THEN tmpData.EndAmount ELSE 0 END)     AS EndSumm
                     FROM tmpData
                     WHERE tmpData.StartAmount <> 0 
                        OR tmpData.InAmount    <> 0
                        OR tmpData.OutAmount   <> 0
                        OR tmpData.EndAmount   <> 0
                     GROUP BY tmpData.CarId
                            , tmpData.ObjectId
                            , tmpData.KindId
                            , tmpData.FromId
                            , tmpData.MemberId
                     )

       -- Добавили строковые данные. 
        SELECT Object_CarModel.ValueData AS CarModelName
             , Object_Car.Id             AS CarId
             , Object_Car.ObjectCode     AS CarCode
             , Object_Car.ValueData      AS CarName
             , Object.ObjectCode         AS FuelCode
             , CASE WHEN tmpDataAll.KindId = vb_Kind_Money THEN 'Денежные средства'::TVarChar
                    ELSE Object.ValueData          
               END                       AS FuelName
             , tmpDataAll.KindId
              
             , Object_Branch.Id          AS BranchId
             , Object_Branch.ValueData   AS BranchName

             , Object_From.Id            AS FromId
             , Object_From.ValueData     AS FromName

             , Object_Member.Id          AS MemberId
             , Object_Member.ValueData   AS MemberName
              
             , tmpDataAll.StartCount     ::TFloat
             , tmpDataAll.InCount        ::TFloat
             , tmpDataAll.OutCount       ::TFloat
             , tmpDataAll.EndCount       ::TFloat
             , tmpDataAll.StartSumm      ::TFloat
             , tmpDataAll.InSumm         ::TFloat
             , tmpDataAll.OutSumm        ::TFloat
             , tmpDataAll.EndSumm        ::TFloat
              
        FROM tmpDataAll
             LEFT JOIN Object ON Object.Id = tmpDataAll.ObjectId
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpDataAll.CarId
             LEFT JOIN Object AS Object_From ON Object_From.Id = tmpDataAll.FromId
             LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpDataAll.MemberId
             
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel 
                                  ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
             
             LEFT JOIN tmpCar ON tmpCar.CarId = tmpDataAll.CarId
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
--select * from gpReport_TransportFuel(inStartDate := ('01.06.2018')::TDateTime , inEndDate := ('01.06.2018')::TDateTime , inFuelId:=0, inCarId := 0, inBranchId := 0 , inIsMember:= False :: Boolean, inIsPartner := False ::Boolean , inSession := '5');
