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
              -- Id ������
              ContainerId    Integer,
              -- ����
              AccountId      Integer,
              -- ��.�.
              JuridicalId    Integer,
              -- ����������
              PartnerId      Integer,
              -- �������
              ContractId     Integer,
              -- ��
              PaidKindId     Integer,
              -- �� ������
              InfoMoneyId    Integer,
              -- ������
              BranchId       Integer,
              -- ���������� ����
              PartionMovementId Integer,

              -- ��������� ���� ���������� - ���� ���
              StartSumm_a     TFloat,
              -- �������� ���� ���������� - ���� ���
              EndSumm_a       TFloat,
              -- ��������� ���� ��������� - ���� ��
              StartSumm_p     TFloat,
              -- �������� ���� ��������� - ���� ��
              EndSumm_p       TFloat,

              -- Debet
              DebetSumm       TFloat,
              -- Kredit
              KreditSumm      TFloat,

              -- ������ �� ���������� - ���� ��
              IncomeSumm_p      TFloat,
              -- ������� ���������� - ���� ��
              ReturnOutSumm_p   TFloat,

              -- ������� (���� ��� ��. ������) - ���� ���
              SaleRealSumm_total_a      TFloat,
              -- ������� �� ���. (���� ��� ��. ������) - ���� ���
              ReturnInRealSumm_total_a  TFloat,
              -- ������� (���� � ��. ������) - ���� ���
              SaleRealSumm_a            TFloat,
              -- ������� �� ���. (���� � ��. ������) - ���� ���
              ReturnInRealSumm_a        TFloat,

              -- ������ ���� ������. - ���� ���
              ServiceRealSumm_a         TFloat,
              -- ������ ���� �����. - ���� ��
              ServiceRealSumm_p         TFloat,

              -- ������ ���� - ���� ���
              MoneySumm_a               TFloat,
              -- ������ ���� - ���� ��
              MoneySumm_p               TFloat,

              -- ����. ���� - ���� ��� +
              PriceCorrectiveSumm_a     TFloat,
              -- ����. ���� - ���� ��  +
              PriceCorrectiveSumm_p     TFloat,

              -- ��-����� - ���� ��� +
              SendDebtSumm_a            TFloat,
              -- ��-����� - ���� �� +
              SendDebtSumm_p            TFloat,

              -- ������ - ���� ��� +
              OthSumm_a                 TFloat,
              -- ������ - ���� �� +
              OthSumm_p                 TFloat,

              -- ����� ��� ��������
              SaleSumm_debt             TFloat,
              --
              CONSTRAINT pk_bi_Table_JuridicalSold PRIMARY KEY (Id)
           );

          -- 1.1.
          CREATE INDEX idx_bi_Table_JuridicalSold_OperDate ON _bi_Table_JuridicalSold (OperDate
                                                                                     , ContractId
                                                                                      );
          -- 1.2.
          CREATE INDEX idx_bi_Table_JuridicalSold_OperDate_all ON _bi_Table_JuridicalSold (OperDate
                                                                                         , ContractId
                                                                                         , JuridicalId
                                                                                         , PartnerId
                                                                                         , PaidKindId
                                                                                         , InfoMoneyId
                                                                                         , BranchId
                                                                                         , AccountId
                                                                                          );
          -- 2.1.
          CREATE INDEX idx_bi_Table_JuridicalSold_ContractId  ON _bi_Table_JuridicalSold (ContractId
                                                                                        , OperDate
                                                                                         );
          -- 2.2.
          CREATE INDEX idx_bi_Table_JuridicalSold_ContractId_all ON _bi_Table_JuridicalSold (ContractId
                                                                                           , OperDate
                                                                                           , JuridicalId
                                                                                           , PartnerId
                                                                                           , PaidKindId
                                                                                           , InfoMoneyId
                                                                                           , BranchId
                                                                                           , AccountId
                                                                                          );

          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO project;

      END IF;

END;
$$;
