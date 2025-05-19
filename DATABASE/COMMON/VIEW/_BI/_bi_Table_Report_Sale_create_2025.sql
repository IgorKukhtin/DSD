-- ������� - �������/�������

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_Report_Sale_2025
TRUNCATE TABLE _bi_Table_Report_Sale_2025;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_Report_Sale_2025')))
      THEN
           -- DROP TABLE _bi_Table_Report_Sale_2025
           --
           CREATE TABLE _bi_Table_Report_Sale_2025 (
              Id              BIGSERIAL NOT NULL,
              -- Id ���������
              MovementId     Integer,
              -- ��� ���������
              MovementDescId Integer,
              -- ���� ����������
              OperDate       TDateTime,
              -- ���� �����
              OperDate_sklad TDateTime,
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


              -- �������� ������ ����������
              MovementId_order    Integer,

              -- �������� �����
              MovementId_promo    Integer,


              -- ��� ������� - �� ������
              Sale_Amount         TFloat,
              -- ��.
              Sale_Amount_sh      TFloat,

              -- ��� ������� - �� �����
              Return_Amount      TFloat,
              -- ��.
              Return_Amount_sh   TFloat,


              -- ����� - ��� �������
              AmountPartner_promo      TFloat,
              -- ��.
              AmountPartner_promo_sh   TFloat,

              -- ��� ������� � ����������
              Sale_AmountPartner       TFloat,
              -- ��.
              Sale_AmountPartner_sh    TFloat,

              -- ��� ������� � ����������
              Return_AmountPartner     TFloat,
              -- ��.
              Return_AmountPartner_sh  TFloat,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        TFloat,
              -- ��.
              Sale_Amount_10500_sh     TFloat,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        TFloat,
              -- ��.
              Sale_Amount_40200_sh     TFloat,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      TFloat,
              -- ��.
              Return_Amount_40200_sh   TFloat,


              -- ����� - ����� �������
              Sale_Summ_promo       TFloat,
              -- ����� �������
              Sale_Summ             TFloat,
              -- ����� �������
              Return_Summ           TFloat,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       TFloat,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       TFloat,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       TFloat,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     TFloat,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   TFloat,


              -- ����� �/� �������
              Sale_SummCost         TFloat,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   TFloat,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   TFloat,

              -- ����� �/� �������
              Return_SummCost       TFloat,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 TFloat,

              --
              CONSTRAINT pk_bi_Table_Report_Sale_2025 PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_Report_Sale_2025_OperDate ON _bi_Table_Report_Sale_2025 (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_Sale_2025 TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_Sale_2025 TO project;

      END IF;

END;
$$;
