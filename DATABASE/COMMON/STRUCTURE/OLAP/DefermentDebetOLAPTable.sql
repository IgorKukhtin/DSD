-- DROP TABLE DefermentDebetOLAPTable;

/*-------------------------------------------------------------------------------*/
CREATE TABLE DefermentDebetOLAPTable

(
               Id BIGSERIAL NOT NULL PRIMARY KEY 
             , AccountId Integer, JuridicalId Integer
             , PartnerId Integer
             , BranchId Integer
             , PaidKindId Integer
             , ContractId Integer
             , StartContractDate TDateTime, OperDate TDateTime
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat
             , Remains TFloat
 , AmountProductionOut TFloat
  )
WITH (
  OIDS=FALSE
);

ALTER TABLE DefermentDebetOLAPTable
  OWNER TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO project;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.19                                        * all
*/



