-- ������� - ������ �����������

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_Report_OrderClient
TRUNCATE TABLE _bi_Table_Report_OrderClient;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_Report_OrderClient')))
      THEN
           -- DROP TABLE _bi_Table_Report_OrderClient
           --
           CREATE TABLE _bi_Table_Report_OrderClient (
              Id              BIGSERIAL NOT NULL,
              -- Id ���������
              MovementId     Integer,
              -- ��� ���������
              MovementDescId Integer,
              -- ���� ����������
              OperDate       TDateTime,
              -- ���� �����
              OperDate_sklad TDateTime,
              -- ���� ������
              OperDate_order TDateTime,
              -- � ���������
              InvNumber      Integer,

              -- ��. ����
              JuridicalId    Integer,
              -- ����������
              PartnerId      Integer,

              -- �� ������ ����������
              InfoMoneyId    Integer,
              -- ����� ������
              PaidKindId     Integer,
              -- ������
              BranchId       Integer,
              -- �������
              ContractId     Integer,

              -- �����
              GoodsId        Integer,
              -- ��� ������
              GoodsKindId    Integer,

              -- �������� �����
              MovementId_promo    Integer,


              -- ��� ����� �����
              Amount         TFloat,
              -- ��.
              Amount_sh      TFloat,

              -- ��� �����
              AmountFirst      TFloat,
              -- ��.
              AmountFirst_sh   TFloat,

              -- ��� �������
              AmountSecond      TFloat,
              -- ��.
              AmountSecond_sh   TFloat,

              -- ����� - ����� �����
              Amount_promo      TFloat,
              -- ��.
              Amount_promo_sh   TFloat,


              -- ����� � ��� ����� �����
              Summ             TFloat,
              -- ����� - ����� � ��� �����
              Summ_promo       TFloat,

              --
              CONSTRAINT pk_bi_Table_Report_OrderClient PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_Report_OrderClient_OperDate ON _bi_Table_Report_OrderClient (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_OrderClient TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_OrderClient TO project;

      END IF;

END;
$$;
