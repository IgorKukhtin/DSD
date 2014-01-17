-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalSold (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Fuel(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет  
    IN inInfoMoneyId      Integer,    -- Управленческая статья  
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    -- филиал
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (CarModelName TVarChar, CarId Integer, CarCode Integer, CarName TVarChar
             , FuelCode Integer, FuelName TVarChar, KindId Integer
             , BranchId Integer, BranchName TVarChar
             , StartAmount TFloat, IncomeAmount TFloat, RateAmount TFloat, EndAmount TFloat
             , StartSumm TFloat, IncomeSumm TFloat, RateSumm TFloat, EndSumm TFloat
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  RETURN QUERY  
     SELECT * 
     FROM 

     (         SELECT Container.Id AS ContainerId, Container.ObjectId, CLO_Juridical.ObjectId AS JuridicalId, CLO_InfoMoney.ObjectId AS InfoMoneyId,
                     Container.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount,
                     SUM (CASE WHEN MIContainer.OperDate <= '2014-01-01'::TDateTime THEN CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount1,
                     SUM (CASE WHEN MIContainer.OperDate <= '2014-01-01'::TDateTime THEN CASE WHEN Movement.DescId in (zc_Movement_Cash(), zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount2,
                     SUM (CASE WHEN MIContainer.OperDate <= '2014-01-01'::TDateTime THEN CASE WHEN Movement.DescId in (zc_Movement_Service()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount3,
                     SUM (CASE WHEN MIContainer.OperDate <= '2014-01-01'::TDateTime THEN CASE WHEN Movement.DescId not in (zc_Movement_Service(), zc_Movement_Sale(), zc_Movement_Cash(), zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS OutComeAmount4,
                     Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > '2014-01-01'::TDateTime THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                FROM ContainerLinkObject AS CLO_Juridical 
                JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney 
                  ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                                  
           LEFT JOIN MovementItemContainer AS MIContainer 
                  ON MIContainer.Containerid = Container.Id
           LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                 --AND MIContainer.OperDate >= inStartDate
               WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() --AND Object_InfoMoney_View.InfoMoneyDestinationId = 0
            GROUP BY Container.Id, MIContainer.Containerid, Container.ObjectId, JuridicalId, CLO_InfoMoney.ObjectId) AS Operation
           LEFT JOIN ContainerLinkObject AS CLO_Contract 
                  ON CLO_Contract.ContainerId = Operation.ContainerId AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = CLO_Contract.ObjectId         
           LEFT JOIN ContainerLinkObject AS CLO_PaidKind 
                  ON CLO_PaidKind.ContainerId = Operation.ContainerId AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CLO_PaidKind.ObjectId         
                JOIN Object AS Object_Account ON Object_Account.Id = Operation.ObjectId
                JOIN Object AS Object_Juridical ON Object_Juridical.Id = Operation.JuridicalId   
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = Operation.InfoMoneyId         
           
           WHERE (StartAmount <> 0 OR EndAmount <> 0 OR OutComeAmount1 <> 0 OR OutComeAmount2 <> 0 OR OutComeAmount3 <> 0 OR OutComeAmount4 <> 0);
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Fuel (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
                                                                
