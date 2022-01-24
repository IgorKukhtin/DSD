-- DROP TABLE DefermentPaymentOLAPTable;

/*-------------------------------------------------------------------------------*/
CREATE TABLE DefermentPaymentOLAPTable

(
               Id BIGSERIAL NOT NULL PRIMARY KEY
             , ContainerId Integer
             , AccountId Integer
             , JuridicalId Integer
             , PartnerId Integer
             , BranchId Integer
             , PaidKindId Integer
             , ContractId Integer
             , StartContractDate TDateTime -- начальная дата для расчета отсрочки
             , OperDate TDateTime          -- дата
             , DebtRemains TFloat          -- долг начальный на дату
             , SaleSumm TFloat             -- Сумма продаж за период
           --, Remains TFloat              -- просроченный долг
  )
WITH (
  OIDS=FALSE
);

ALTER TABLE DefermentPaymentOLAPTable
  OWNER TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO project;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.22                                        *
*/
