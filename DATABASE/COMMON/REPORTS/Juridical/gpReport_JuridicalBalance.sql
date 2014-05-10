-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalBalance(
    IN inOperDate         TDateTime , -- 
    IN inJuridicalId      Integer,    -- Юридическое лицо  
    IN inContractId       Integer,    -- Договор
    IN inAccountId        Integer,    -- Счет 
    IN inPaidKindId       Integer   , --
    IN inInfoMoneyId      Integer,    -- Управленческая статья  
   OUT StartBalance       TFloat, 
   OUT OurFirm            TVarChar,
    IN inSession          TVarChar    -- сессия пользователя
)
AS
$BODY$
  
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Один запрос, который считает остаток
     WITH tmpContract AS (SELECT COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                          FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                          WHERE View_Contract_ContractKey.ContractId = inContractId)
     SELECT SUM (Amount) INTO StartBalance
     FROM (SELECT  Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
           FROM ContainerLinkObject AS CLO_Juridical
                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
               LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                             ON CLO_InfoMoney.ContainerId = Container.Id
                                            AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()  
                LEFT JOIN ContainerLinkObject AS CLO_Contract
                                              ON CLO_Contract.containerid = Container.Id
                                             AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                              ON CLO_PaidKind.ContainerId = Container.Id
                                             AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                LEFT JOIN MovementItemContainer AS MIContainer
                                                ON MIContainer.Containerid = Container.Id
                                               AND MIContainer.OperDate >= inOperDate
                LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId
            WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
              AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
              AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
              AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
              AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
              AND (tmpContract.ContractId > 0 OR COALESCE (inContractId, 0) = 0)
            GROUP BY Container.Amount, Container.Id
           ) AS Balance;
            
     -- захардкодил
     OurFirm  := '"ООО" Алан';        

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.14                                        * add inInfoMoneyId
 05.05.14                                        * add inPaidKindId
 05.05.14                                        * all
 26.03.14                        * 
 18.02.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalBalance (inOperDate:= '01.01.2013', inJuridicalId:= 0, inContractId:= 0, inAccountId:= 0, inPaidKindId:= 0, inInfoMoneyId:= 0, inSession:= zfCalc_UserAdmin()); 
