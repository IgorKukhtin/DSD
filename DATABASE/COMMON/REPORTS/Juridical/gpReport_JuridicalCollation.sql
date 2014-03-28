-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inJuridicalId      Integer,    -- Юридическое лицо  
    IN inContractId       Integer,    -- Договор
    IN inAccountId        Integer,    -- Счет 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementSumm TFloat, 
               Debet TFloat, 
               Kredit TFloat, 
               OperDate TDateTime, 
               InvNumber TVarChar, 
               AccountCode Integer,
               AccountName TVarChar,
               ContractName TVarChar,
               InfoMoneyGroupCode Integer,
               InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationCode Integer,
               InfoMoneyDestinationName TVarChar,
               InfoMoneyCode Integer,
               InfoMoneyName TVarChar,
               MovementId Integer, 
               ItemName TVarChar)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток и движение. 
     -- Главная задача - выбор контейнера. Выбираем контейнеры по группе счетов 20400 для топлива и 30500 для денежных средств
  RETURN QUERY  
  WITH Object_Account_View AS (SELECT Object_Account_View.AccountCode, Object_Account_View.AccountName_all, Object_Account_View.AccountId FROM Object_Account_View)
  SELECT 
          Operation.MovementSumm::TFloat,
          (CASE WHEN Operation.MovementSumm > 0 THEN Operation.MovementSumm ELSE 0 END)::TFloat AS Debet,
          (CASE WHEN Operation.MovementSumm > 0 THEN 0 ELSE - Operation.MovementSumm END)::TFloat AS Kredit,
          Movement.OperDate,
          Movement.InvNumber, 
          Object_Account_View.AccountCode,
          Object_Account_View.AccountName_all AS AccountName,
          Contract.ValueData        AS ContractName,
          Object_InfoMoney_View.InfoMoneyGroupCode,
          Object_InfoMoney_View.InfoMoneyGroupName,
          Object_InfoMoney_View.InfoMoneyDestinationCode,
          Object_InfoMoney_View.InfoMoneyDestinationName,
          Object_InfoMoney_View.InfoMoneyCode,
          Object_InfoMoney_View.InfoMoneyName,
          Movement.Id               AS MovementId, 
          MovementDesc.ItemName
    FROM (SELECT 
           CLO_Contract.ObjectId AS ContractId, 
           CLO_InfoMoney.ObjectId AS InfoMoneyId, 
           MIContainer.MovementId, 
           Container.ObjectId AS AccountId, 
           SUM(MIContainer.Amount) AS MovementSumm
      FROM ContainerLinkObject AS CLO_Juridical 
      JOIN Container ON Container.Id = CLO_Juridical.ContainerId
      JOIN MovementItemContainer AS MIContainer 
        ON MIContainer.Containerid = Container.Id
 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
        ON CLO_InfoMoney.ContainerId = Container.Id
       AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()  
 LEFT JOIN ContainerLinkObject AS CLO_Contract
        ON CLO_Contract.ContainerId = Container.Id
       AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()  
       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
    WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0 
      AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
      AND (Container.ObjectId = inAccountId OR inAccountId = 0)
      AND (CLO_Contract.ObjectId = inContractId OR inContractId = 0)
  GROUP BY ContractId, AccountId, MIContainer.MovementId, InfoMoneyId
    HAVING SUM(MIContainer.Amount) <> 0) AS Operation
      LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
      JOIN Object AS Contract ON Contract.Id = Operation.ContractId
      JOIN Movement ON Movement.Id = Operation.MovementId
      JOIN MovementDesc ON Movement.DescId = MovementDesc.Id;
                                  
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.14                        * 
 18.02.14                        * add WITH для ускорения запроса. 
 25.01.14                        * 
 15.01.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
