-- Function: gpReport_Fuel()

DROP FUNCTION IF EXISTS gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Fuel(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inFuelId        Integer,    -- топливо  
    IN inCarId         Integer,    -- машина
     
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (CarId Integer, CarName TVarChar
             , FuelId Integer, FuelCode Integer, FuelName TVarChar

             , StartAmount TFloat, IncomeAmount TFloat, RateAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, IncomeSumm TFloat, RateSumm TFloat, EndSumm TFloat
             )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400. 
  RETURN QUERY  
      -- Таким нехитрым образом мы получили все нужные нам суммовые контейнеры по определенным счетам
           WITH ContainerSumm AS (SELECT Id, ParentId, DescId, Amount FROM Container WHERE Container.ObjectId IN
                          (SELECT AccountId FROM Object_Account_View
                            WHERE Object_Account_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400()
                              AND Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_20000()))

           -- Ну и теперь добавили строковые данные. 
    SELECT Object_Car.Id         AS CarId,  
           Object_Car.ValueData  AS CarName,
           Object_Fuel.Id        AS FuelId,
           Object_Fuel.Code      AS FuelCode,
           Object_Fuel.ValueData AS FuelName, 
           StartCount, IncomeCount, OutcomeCount, EndCount,
           StartSumm, IncomeSumm, OutcomeSumm, EndSumm
    FROM(
      -- Сгруппировали по топливу и автомобилю
      SELECT Report.ObjectId AS FuelId, CarLink.ObjectId as CarId,
             SUM(StartCount) AS StartCount,
             SUM(IncomeCount) AS IncomeCount,
             SUM(OutcomeCount) AS OutcomeCount,
             SUM(EndCount) AS EndCount,
             SUM(StartSumm) AS StartSumm,
             SUM(IncomeSumm) AS IncomeSumm,
             SUM(OutcomeSumm) AS OutcomeSumm,
             SUM(EndSumm) AS EndSumm
        FROM 
        -- Получили оборотку, развернутую на количество и сумму
       (SELECT KeyContainerId AS ContainerId, SUM(ObjectId) AS ObjectId ,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN StartAmount ELSE 0 END) AS StartCount,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN IncomeAmount ELSE 0 END) AS IncomeCount,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN OutcomeAmount ELSE 0 END) AS OutcomeCount,
               SUM(CASE WHEN DescId = zc_Container_Count() THEN EndAmount ELSE 0 END) AS EndCount,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN StartAmount ELSE 0 END) AS StartSumm,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN IncomeAmount ELSE 0 END) AS IncomeSumm,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN OutcomeAmount ELSE 0 END) AS OutcomeSumm,
               SUM(CASE WHEN DescId = zc_Container_Summ() THEN EndAmount ELSE 0 END) AS EndSumm
          FROM
              -- Получаем оборотку по контейнерам. 
              (SELECT KeyContainerId, ObjectId, ReportContainer.DescId, 
                     ReportContainer.Amount - SUM (MIContainer.Amount) AS StartAmount,
                     SUM (CASE WHEN MIContainer.OperDate < inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS IncomeAmount,
                     SUM (CASE WHEN MIContainer.OperDate < inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN - MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount,
                     ReportContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END) AS EndAmount

              FROM
                    -- ReportContainer. Возвращаем список суммовых и количественных контейнеров по указанному в ContainerSumm счету
                    (SELECT Id, DescId, Amount, ParentId as KeyContainerId, 0 AS ObjectId FROM ContainerSumm
              UNION SELECT Container.Id, Container.DescId, Container.Amount, Container.Id AS KeyContainerId, ObjectId
                      FROM Container, ContainerSumm
                     WHERE Container.Id = ContainerSumm.ParentId) AS ReportContainer

                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = ReportContainer.Id
                                                               AND MIContainer.OperDate >= inStartDate
                GROUP BY ReportContainer.Id, ReportContainer.DescId, ReportContainer.Amount, KeyContainerId, ObjectId) AS Report
                   WHERE StartAmount<>0 OR IncomeAmount<>0 OR OutcomeAmount<>0 OR EndAmount<>0
          GROUP BY ContainerID) AS Report
      LEFT JOIN ContainerLinkObject AS CarLink ON CarLink.ContainerId = Report.ContainerId AND CarLink.DescId = zc_ContainerLinkObject_Car()
      GROUP BY Report.ObjectId, CarLink.ObjectId) AS Report
    LEFT JOIN OBJECT AS Object_Fuel ON Object_Fuel.Id = Report.FuelId
    LEFT JOIN OBJECT AS Object_Car ON Object_Car.Id = Report.CarId;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.13                        * 
 05.10.13         *
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 