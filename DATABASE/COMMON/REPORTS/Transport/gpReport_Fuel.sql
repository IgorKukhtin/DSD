-- Function: gpReport_Fuel()

DROP FUNCTION IF EXISTS gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, TVarChar);
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
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  vb_Kind_Fuel   := 1;
  vb_Kind_Money  := 2;
  vb_Kind_Ticket := 3;

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  RETURN QUERY  
           -- Получили все нужные нам контейнеры по талонам, топливу и деньгам, в разрезе авто и топлива
           -- Еще и ограничили их по топливу и авто
        WITH tmpContainer AS (
                              WITH 
                              TicketFuel AS (SELECT Container.Id, 
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
                                                             FROM ObjectLink AS ObjectLink_Car_PersonalDriver
                                                                  LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                                       ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Car_PersonalDriver.ChildObjectId
                                                                                      AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                              WHERE ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                                                               AND (ObjectLink_Car_PersonalDriver.ObjectId = inCarId OR inCarId = 0)
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
                                                                    AND (ContainerLinkObject_Car.ObjectId = inCarId OR inCarId = 0)
                                      )
                                     -- Конец WITH. Начало запроса
        
                          SELECT Container.Id, Container.DescId, Container.Amount, TicketFuel.ObjectId, TicketFuel.CarId, vb_Kind_Ticket as KindId -- здесь талоны деньги
                          FROM Container 
                               JOIN TicketFuel ON Container.ParentId = TicketFuel.id
                               JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                                                       AND Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_20500()
                                                       AND Object_Account_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400()
                       UNION All 
                          SELECT TicketFuel.Id, TicketFuel.DescId, TicketFuel.Amount, TicketFuel.ObjectId, TicketFuel.CarId, vb_Kind_Ticket as KindId -- здесь талоны кол-во
                          FROM TicketFuel       
                       UNION ALL 
                         SELECT Container.Id, Container.DescId, Container.Amount, Fuel.ObjectId, Fuel.CarId, vb_Kind_Fuel as KindId -- здесь топливо деньги
                         FROM Container 
                              JOIN Fuel ON Container.ParentId = Fuel.id
                              JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                                                      AND Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_20000()
                                                      AND Object_Account_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400()
                      UNION All 
                         SELECT Fuel.Id, Fuel.DescId, Fuel.Amount, Fuel.ObjectId, Fuel.CarId, vb_Kind_Fuel as KindId -- здесь топливо кол-во
                         FROM Fuel                            
                      UNION ALL
                         SELECT Container.Id, Container.DescId, Container.Amount, 0  AS ObjectId, ContainerLinkObject_Car.ObjectId AS CarId,  vb_Kind_Money as KindId -- деньги
                         FROM Container 
                              JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                                                      AND Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_30500()
                                                      AND Object_Account_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400()
                                -- Ограничили по авто, если надо
                              JOIN ContainerLinkObject AS ContainerLinkObject_Car 
                                                       ON Container.iD = ContainerId AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car() 
                                                      AND COALESCE(ContainerLinkObject_Car.ObjectId, 0) <> 0
                                                      AND (ContainerLinkObject_Car.ObjectId = inCarId OR inCarId = 0)
                      )
                              -- Конец. Получили все нужные нам контейнеры

    -- Добавили строковые данные. 
    SELECT Object_CarModel.ValueData AS CarModelName,
           Object_Car.Id             AS CarId,
           Object_Car.ObjectCode     AS CarCode,  
           Object_Car.ValueData      AS CarName,
           Object.ObjectCode         AS FuelCode,
           CASE WHEN Report.KindId =  vb_Kind_Money THEN 'Денежные средства'::TVarChar
                ELSE Object.ValueData          
           END AS FuelName, 
           Report.KindId,
           
           ViewObject_Unit.BranchId,
           ViewObject_Unit.BranchName,
           
           StartCount::TFloat, IncomeCount::TFloat, OutcomeCount::TFloat, EndCount::TFloat,
           Report.StartSumm::TFloat, Report.IncomeSumm::TFloat, Report.OutcomeSumm::TFloat
           , Report.EndSumm::TFloat
           
    FROM
        -- Получили оборотку, развернутую на количество и сумму, cгруппированную по топливу и автомобилю
       (SELECT Report.CarId, Report.ObjectId, Report.KindId,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.StartAmount ELSE 0 END) AS StartCount,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.IncomeAmount ELSE 0 END) AS IncomeCount,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.OutcomeAmount ELSE 0 END) AS OutcomeCount,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN Report.EndAmount ELSE 0 END) AS EndCount,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.StartAmount ELSE 0 END) AS StartSumm,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.IncomeAmount ELSE 0 END) AS IncomeSumm,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.OutcomeAmount ELSE 0 END) AS OutcomeSumm,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN Report.EndAmount ELSE 0 END) AS EndSumm
          FROM
              -- Получаем оборотку по контейнерам. 
              (SELECT tmpContainer.Id, tmpContainer.CarId, tmpContainer.ObjectId, tmpContainer.DescId, tmpContainer.KindId,
                     tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeAmount,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN - MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount,
                     tmpContainer.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                FROM tmpContainer
           LEFT JOIN MovementItemContainer AS MIContainer 
                  ON MIContainer.Containerid = tmpContainer.Id
                 AND MIContainer.OperDate >= inStartDate
            GROUP BY tmpContainer.Amount, tmpContainer.Id, tmpContainer.CarId, tmpContainer.ObjectId, tmpContainer.DescId, tmpContainer.KindId) AS Report
                -- Конец. Получаем оборотку по контейнерам.

          WHERE Report.StartAmount<>0 OR Report.IncomeAmount<>0 OR Report.OutcomeAmount<>0 OR Report.EndAmount<>0
          GROUP BY Report.CarId, Report.ObjectId, Report.KindId) AS Report
          -- Конец. Получили оборотку, развернутую на количество и сумму, сгруппированную по топливу и автомобилю

             LEFT JOIN Object ON Object.Id = Report.ObjectId
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = Report.CarId
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
             
             -- Ограничили по Филиалу, если надо
             LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
             LEFT JOIN Object_Unit_View AS ViewObject_Unit ON ViewObject_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
                                                    -- AND (ViewObject_Unit.BranchId = inBranchId OR inBranchId = 0)
          WHERE COALESCE (ViewObject_Unit.BranchId, 0) = inBranchId 
             OR inBranchId = 0 
             OR (inBranchId = zc_Branch_Basis() AND COALESCE (ViewObject_Unit.BranchId, 0) = 0)    
    ;
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
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
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
