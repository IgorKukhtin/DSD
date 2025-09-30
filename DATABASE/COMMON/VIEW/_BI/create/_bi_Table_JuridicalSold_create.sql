-- ������� - ������� �� �� �����

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_JuridicalSold
TRUNCATE TABLE _bi_Table_JuridicalSold;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_JuridicalSold')))
      THEN
           -- DROP TABLE _bi_Table_JuridicalSold
           --
           CREATE TABLE _bi_Table_JuridicalSold (
              Id             BIGSERIAL NOT NULL,
              -- ����
              OperDate       TDateTime,
              --
              ContainerId    Integer,
              -- ��.�.
              JuridicalId    Integer,
              -- ����������
              PartnerId      Integer,
              -- ������
              BranchId       Integer,
              -- �������
              ContractId     Integer,
              -- ��
              PaidKindId     Integer,
              -- �� ������
              InfoMoneyId    Integer,
              -- ����
              AccountId      Integer,

              -- ��������� ���� ����������
              StartSumm       TFloat,
              -- �������� ���� ����������
              EndSumm         TFloat,
              -- Debet
              DebetSumm       TFloat,
              -- Kredit
              KreditSumm      TFloat,

              -- ������� (���� ��� ��. ������)
              SaleRealSumm_total      TFloat,
              -- ������� �� ���. (���� ��� ��. ������)
              ReturnInRealSumm_total  TFloat,
              -- ������� (���� � ��. ������)
              SaleRealSumm            TFloat,
              -- ������� �� ���. (���� � ��. ������)
              ReturnInRealSumm        TFloat,
              -- ������ (+)���� (-)����.
              MoneySumm               TFloat,
              -- ����. ���� (+)����� (-)����.
              PriceCorrectiveSumm     TFloat,
              -- ��-����� (+)���.����. (-)���.����.
              SendDebtSumm            TFloat,
              -- �������
              OthSumm                 TFloat,
              --
              CONSTRAINT pk_bi_Table_JuridicalSold PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_JuridicalSold_OperDate ON _bi_Table_JuridicalSold (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO project;

      END IF;

END;
$$;
