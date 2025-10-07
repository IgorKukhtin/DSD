-- ������� - ����� �������� �� �� �����

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_JuridicalDebt
TRUNCATE TABLE _bi_Table_JuridicalDebt;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_JuridicalDebt')))
      THEN
           -- DROP TABLE _bi_Table_JuridicalDebt
           --
           CREATE TABLE _bi_Table_JuridicalDebt (
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

              -- ��������� ���� ����������
              StartSumm        TFloat,
              -- ��������� ���� ���������� � ���������
              StartSumm_debt   TFloat,
              -- �������
              SaleSumm         TFloat,

              -- ������������ ���� �� 1-7 ����
              Summ_debt_7     TFloat,
              -- ������������ ���� �� 8-14 ����
              Summ_debt_14     TFloat,
              -- ������������ ���� �� 15-21 ����
              Summ_debt_21     TFloat,
              -- ������������ ���� �� 22-28 ����
              Summ_debt_28     TFloat,
              -- ������������ ���� �� 29 � ����� ����
              Summ_debt_28_add TFloat,

              -- ��������� ���� ������������� �����
              StartDate_debt   TDateTime,
              -- ���� ��������
              DayCount         Integer,
              -- ������� ��������
              ConditionKindId  Integer,

              CONSTRAINT pk_bi_Table_JuridicalDebt PRIMARY KEY (Id)
           );

          -- 1.1.
          CREATE INDEX idx_bi_Table_JuridicalDebt_OperDate ON _bi_Table_JuridicalDebt (OperDate
                                                                                     , ContractId
                                                                                      );

          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalDebt TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalDebt TO project;

      END IF;

END;
$$;
