-- DROP TABLE DefermentDebtOLAPTable;

/*-------------------------------------------------------------------------------*/
CREATE TABLE DefermentDebtOLAPTable

(
               Id BIGSERIAL NOT NULL PRIMARY KEY
             , AccountId Integer, JuridicalId Integer
             , PartnerId Integer
             , BranchId Integer
             , PaidKindId Integer
             , ContractId Integer
             , StartContractDate TDateTime -- ��������� ���� ��� ������� ��������
             , OperDate TDateTime          -- ����
             , DebtRemains TFloat          -- ���� ��������� �� ����
             , SaleSumm TFloat             -- ����� ������ �� ������
           --, Remains TFloat              -- ������������ ����
  )
WITH (
  OIDS=FALSE
);

ALTER TABLE DefermentDebtOLAPTable
  OWNER TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO project;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.22                                        *
*/
