-- Function: gpReport_Fuel()

DROP FUNCTION IF EXISTS gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Fuel(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inFuelId        Integer,    -- топливо  
    IN inCarId         Integer,    -- машина
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (CarModelName TVarChar, CarId Integer, CarCode Integer, CarName TVarChar
             , FuelCode Integer, FuelName TVarChar
             , StartAmount TFloat, IncomeAmount TFloat, RateAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, IncomeSumm TFloat, RateSumm TFloat, EndSumm TFloat
             )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  RETURN QUERY  
           -- Получили все нужные нам суммовые контейнеры по определенным счетам
           -- Еще и ограничили их по топливу и авто
           WITH ContainerSumm AS (SELECT Id, ParentId, DescId, Amount  -- здесь топливо
                                 FROM Container 
                                WHERE Container.ObjectId IN
                                      -- Получили список счетов
                                      (SELECT AccountId FROM Object_Account_View 
                                        WHERE Object_Account_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400()
                                          AND Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_20000())

                                      -- Ограничили по топливу, если надо
                                      AND ((Container.iD IN (SELECT ContainerId FROM ContainerLinkObject 
                                       WHERE DescId = zc_ContainerLinkObject_Goods() AND ObjectId = inFuelId)) OR inFuelId = 0)
                                      -- Ограничили по авто, если надо
                                      AND ((Container.iD IN (SELECT ContainerId FROM ContainerLinkObject 
                                       WHERE DescId = zc_ContainerLinkObject_Car() AND ObjectId = inCarId)) OR inCarId = 0)

                                UNION -- а ниже денежные средства
                               SELECT Container.Id, Container.ParentId, Container.DescId, Container.Amount 
                                 FROM Container 
                               -- Ограничили по авто, если надо
                               JOIN  ContainerLinkObject 
                               ON Container.iD = ContainerId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Car() 
                                  AND COALESCE(ContainerLinkObject.ObjectId, 0) <> 0
                                  AND (ContainerLinkObject.ObjectId = inCarId OR inCarId = 0)
                               WHERE Container.ObjectId IN
                                      -- Получили список счетов
                                      (SELECT  AccountId FROM Object_account_view
                                         WHERE AccountDirectionId = zc_Enum_AccountDirection_30500()
                                           AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400())
                                    )
               -- Конец. Получили все нужные нам суммовые контейнеры

    -- Добавили строковые данные. 
    SELECT Object_CarModel.ValueData AS CarModelName,
           Object_Car.Id             AS CarId,  
           Object_Car.ObjectCode     AS CarCode,  
           Object_Car.ValueData      AS CarName,
           Object_Fuel.ObjectCode    AS FuelCode,
           Object_Fuel.ValueData     AS FuelName, 
           StartCount::TFloat, IncomeCount::TFloat, OutcomeCount::TFloat, EndCount::TFloat,
           Report.StartSumm::TFloat, Report.IncomeSumm::TFloat, Report.OutcomeSumm::TFloat, Report.EndSumm::TFloat
    FROM(
      -- Сгруппировали по топливу и автомобилю
      SELECT Report.ObjectId AS FuelId, CarLink.ObjectId as CarId,
             SUM(StartCount) AS StartCount,
             SUM(IncomeCount) AS IncomeCount,
             SUM(OutcomeCount) AS OutcomeCount,
             SUM(EndCount) AS EndCount,
             SUM(Report.StartSumm) AS StartSumm,
             SUM(Report.IncomeSumm) AS IncomeSumm,
             SUM(Report.OutcomeSumm) AS OutcomeSumm,
             SUM(Report.EndSumm) AS EndSumm
        FROM 
        -- Получили оборотку, развернутую на количество и сумму
       (SELECT KeyContainerId AS ContainerId, SUM(ObjectId) AS ObjectId ,
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
              (SELECT KeyContainerId, ObjectId, ReportContainer.DescId, 
                     ReportContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount,
                     SUM (CASE WHEN MIContainer.OperDate < inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeAmount,
                     SUM (CASE WHEN MIContainer.OperDate < inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN - MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount,
                     ReportContainer.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount

              FROM
                    -- ReportContainer. Возвращаем список суммовых и количественных контейнеров по указанному в ContainerSumm счету
                    (SELECT Id, DescId, Amount, COALESCE(ParentId, Id) as KeyContainerId, 0 AS ObjectId 
                      FROM ContainerSumm
              UNION SELECT Container.Id, Container.DescId, Container.Amount, Container.Id AS KeyContainerId, ObjectId
                      FROM Container, ContainerSumm
                     WHERE Container.Id = ContainerSumm.ParentId) AS ReportContainer

                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = ReportContainer.Id
                                                               AND MIContainer.OperDate > inStartDate
                GROUP BY ReportContainer.Id, ReportContainer.DescId, ReportContainer.Amount, KeyContainerId, ObjectId) AS Report
                -- Конец. Получаем оборотку по контейнерам.

          WHERE Report.StartAmount<>0 OR Report.IncomeAmount<>0 OR Report.OutcomeAmount<>0 OR Report.EndAmount<>0
          GROUP BY ContainerID) AS Report
          -- Конец. Получили оборотку, развернутую на количество и сумму

      LEFT JOIN ContainerLinkObject AS CarLink ON CarLink.ContainerId = Report.ContainerId AND CarLink.DescId = zc_ContainerLinkObject_Car()
      GROUP BY Report.ObjectId, CarLink.ObjectId) AS Report
      -- Конец. Сгруппировали по топливу и автомобилю

             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = Report.FuelId
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = Report.CarId
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
    ;
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.11.13                                        * restore CarId
 28.11.13                                        * add CarModelName
 14.11.13                        * add Денежные Средства
 11.11.13                        * 
 05.10.13         *
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 