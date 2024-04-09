-- Function: gpReport_Fuel()

DROP FUNCTION IF EXISTS gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Fuel(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inFuelId        Integer,    -- топливо  
    IN inCarId         Integer,    -- машина
    IN inBranchId      Integer,    -- филиал
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (CarModelName TVarChar, CarId Integer, CarCode Integer, CarName TVarChar
             , FuelCode Integer, FuelName TVarChar, KindId Integer
             , BranchId Integer, BranchName TVarChar
             , StartAmount TFloat, IncomeAmount TFloat, RateAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, IncomeSumm TFloat, RateSumm TFloat, EndSumm TFloat
             )
AS
$BODY$
  DECLARE vb_Kind_Fuel integer;
  DECLARE vb_Kind_Money integer;
  DECLARE vb_Kind_Ticket integer;
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

  vb_Kind_Fuel   := 1;
  vb_Kind_Money  := 2;
  vb_Kind_Ticket := 3;

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  RETURN QUERY  
           -- Получили все нужные нам контейнеры по талонам, топливу и деньгам, в разрезе авто и топлива
           -- Еще и ограничили их по топливу и авто
           
           
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

       , TicketFuel AS (SELECT Container.Id, 
                              Container.DescId, 
                              Container.Amount, 
                              Container.ObjectId AS ObjectId, 
                              tmpMemberCar.CarId -- здесь талоны в разрезе авто
                       FROM Container
                            JOIN ObjectLink AS ObjectLink_TicketFuel_Goods
                                            ON ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
                                           AND ObjectLink_TicketFuel_Goods.ChildObjectId = Container.ObjectId 
                                           AND (ObjectLink_TicketFuel_Goods.ObjectId = inFuelId OR inFuelId = 0) 
                            JOIN ContainerLinkObject AS ContainerLinkObject_Member
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
      , Fuel AS (SELECT Container.Id, 
                        Container.DescId, 
                        Container.Amount, 
                        Container.ObjectId AS ObjectId, 
                        ContainerLinkObject_Car.ObjectId AS CarId-- здесь топливо в разрезе авто
                 FROM Container 
                      JOIN Object AS Object_Fuel
                                  ON Object_Fuel.DescId = zc_Object_Fuel()
                                 AND Object_Fuel.Id = Container.ObjectId 
                                 AND (Object_Fuel.Id = inFuelId OR inFuelId = 0) 
                      JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                               ON ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                              AND ContainerLinkObject_Car.ContainerId = Container.Id
                                              --AND (ContainerLinkObject_Car.ObjectId = inCarId OR inCarId = 0)
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
                             JOIN Fuel ON Container.ParentId = Fuel.id
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
                                                       ON Container.Id = ContainerId AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car() 
                                                      AND COALESCE(ContainerLinkObject_Car.ObjectId, 0) <> 0
                                                      --AND (ContainerLinkObject_Car.ObjectId = inCarId OR inCarId = 0)
                              INNER JOIN tmpCar ON tmpCar.CarId = ContainerLinkObject_Car.ObjectId
                      )
      -- Конец. Получили все нужные нам контейнеры

      , tmpMIContainer AS (SELECT * 
                           FROM MovementItemContainer AS MIContainer 
                           WHERE MIContainer.Containerid IN (SELECT tmpContainer.Id FROM tmpContainer)--tmpRemains
                             AND MIContainer.OperDate >= inStartDate
                           ) 
                         
      , tmpReport AS (SELECT tmpContainer.Id, tmpContainer.CarId, tmpContainer.ObjectId, tmpContainer.DescId, tmpContainer.KindId
                           , tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount
                           , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeAmount
                           , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN - MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount
                           , tmpContainer.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                      FROM tmpContainer
                           LEFT JOIN tmpMIContainer AS MIContainer 
                                                    ON MIContainer.Containerid = tmpContainer.Id
                                                   AND MIContainer.OperDate >= inStartDate
                      GROUP BY tmpContainer.Amount, tmpContainer.Id, tmpContainer.CarId, tmpContainer.ObjectId, tmpContainer.DescId, tmpContainer.KindId
                      )
      , tmpReportGroup AS (SELECT Report.CarId, Report.ObjectId, Report.KindId
                                , SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.StartAmount ELSE 0 END)   AS StartCount
                                , SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.IncomeAmount ELSE 0 END)  AS IncomeCount
                                , SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.OutcomeAmount ELSE 0 END) AS OutcomeCount
                                , SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.EndAmount ELSE 0 END)     AS EndCount
                                , SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.StartAmount ELSE 0 END)    AS StartSumm
                                , SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.IncomeAmount ELSE 0 END)   AS IncomeSumm
                                , SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.OutcomeAmount ELSE 0 END)  AS OutcomeSumm
                                , SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.EndAmount ELSE 0 END)      AS EndSumm
                           FROM tmpReport AS Report
                           WHERE Report.StartAmount<>0 OR Report.IncomeAmount<>0 OR Report.OutcomeAmount<>0 OR Report.EndAmount<>0
                           GROUP BY Report.CarId, Report.ObjectId, Report.KindId
                           )
        
        -- Добавили строковые данные. 
        SELECT (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , Object_Car.Id             AS CarId
             , Object_Car.ObjectCode     AS CarCode 
             , Object_Car.ValueData      AS CarName
             , Object.ObjectCode         AS FuelCode
             , CASE WHEN Report.KindId =  vb_Kind_Money THEN CAST ('Денежные средства' AS TVarChar)
                   ELSE Object.ValueData          
              END AS FuelName 
             , Report.KindId

             , Object_Branch.Id          AS BranchId
             , Object_Branch.ValueData   AS BranchName

             , StartCount::TFloat, IncomeCount::TFloat, OutcomeCount::TFloat, EndCount::TFloat
             , Report.StartSumm::TFloat, Report.IncomeSumm::TFloat, Report.OutcomeSumm::TFloat
             , Report.EndSumm::TFloat
               
        FROM tmpReportGroup AS Report
             LEFT JOIN Object ON Object.Id = Report.ObjectId
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = Report.CarId
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                  ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
             LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
             
             LEFT JOIN tmpCar ON tmpCar.CarId = Report.CarId
             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpCar.BranchId   
    ;
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.08.18         * оптимизация
 10.02.14         * изменение условий ограничения филиала inBranchId 
 15.01.14                        * 
 21.12.13                                        * Personal -> Member
 11.12.13         * add inBranchId              
 30.11.13                        * Изменил подход к формированию
 29.11.13                        * Ошибка с датой. Добавил талоны
 28.11.13                                        * add CarModelName
 14.11.13                        * add Денежные Средства
 11.11.13                        * 
 05.10.13         *
*/

-- тест
-- SELECT * FROM gpReport_Fuel  (inStartDate :=('01.06.2018')::TDateTime , inEndDate := ('08.06.2018')::TDateTime , inFuelId := 0 , inCarId := 8697 , inBranchId := 0 ,  inSession := '5');
                                                                
