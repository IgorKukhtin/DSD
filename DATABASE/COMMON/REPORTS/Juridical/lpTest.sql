
DROP FUNCTION IF EXISTS lpTest (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpTest (Integer);

CREATE OR REPLACE FUNCTION lpTest(
    IN inJuridicalId      Integer   --
)
RETURNS TABLE (JuridicalId Integer
             , ContractId Integer
             , AccountId Integer
             , PaymentDate TDateTime  -- дата посл. оплаты
             , PaymentAmount TFloat   -- сумма посл. оплаты
              )
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY

     SELECT tmp.JuridicalId
          , tmp.ContractId
          , tmp.AccountId
          , tmp.OperDate     :: TDateTime AS PaymentDate
          , SUM (tmp.Amount) :: TFloat   AS PaymentAmount
     FROM (SELECT MIContainer.OperDate
                , CLO_Juridical.ObjectId AS JuridicalId
                , CLO_Contract.ObjectId  AS ContractId
                , Container.ObjectId     AS AccountId
                , (MIContainer.Amount * (-1)) AS Amount
                , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId, Container.ObjectId) AS OperDate_max
           FROM ContainerLinkObject AS CLO_Juridical
                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                INNER JOIN MovementItemContainer AS MIContainer 
                                                 ON MIContainer.Containerid = Container.Id              --      
                                                AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                AND MIContainer.Amount <> 0
    
                Left JOIN ContainerLinkObject AS CLO_Contract
                                               ON CLO_Contract.ContainerId = Container.Id
                                              AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                             -- AND CLO_Contract.ObjectId = inContractId --997979 --
    
           WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
             AND CLO_Juridical.ObjectId = inJuridicalId --997978
            -- AND (Container.ObjectId = inAccountId OR inAccountId = 0)
           ) AS tmp
     WHERE tmp.OperDate = tmp.OperDate_max
     GROUP BY tmp.OperDate
            , tmp.JuridicalId
            , tmp.ContractId
            , tmp.AccountId
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.21         *
*/

-- тест
-- 
SELECT * FROM lpTest (inJuridicalId:= 997978);
