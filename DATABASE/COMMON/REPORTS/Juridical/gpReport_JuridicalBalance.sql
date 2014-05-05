-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalBalance(
    IN inOperDate         TDateTime , -- 
    IN inJuridicalId      Integer,    -- Юридическое лицо  
    IN inContractId       Integer,    -- Договор
    IN inAccountId        Integer,    -- Счет 
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
                LEFT JOIN ContainerLinkObject AS CLO_Contract 
                                              ON CLO_Contract.containerid = Container.Id
                                             AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                LEFT JOIN MovementItemContainer AS MIContainer
                                                ON MIContainer.Containerid = Container.Id
                                               AND MIContainer.OperDate >= inOperDate
                LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId
            WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
              AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
              AND (Container.ObjectId = inAccountId OR inAccountId = 0)
              AND (tmpContract.ContractId > 0 OR inContractId = 0)
            GROUP BY Container.Amount, Container.Id
           ) AS Balance;
            
     -- захардкодил
     OurFirm  := '"ООО" Алан';        

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalBalance (TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.05.14                                        * all
 26.03.14                        * 
 18.02.14                        * 
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
