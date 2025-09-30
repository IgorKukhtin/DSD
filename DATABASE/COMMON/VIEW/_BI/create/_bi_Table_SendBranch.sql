-- ������� - �������� �� �������

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_SendBranch
TRUNCATE TABLE _bi_Table_SendBranch;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_SendBranch')))
      THEN
           -- DROP TABLE _bi_Table_SendBranch
           --
           CREATE TABLE _bi_Table_SendBranch (
              Id              BIGSERIAL NOT NULL,
              -- Id ���������
              MovementId     Integer,
              -- ���� ����������
              OperDate       TDateTime,
              -- ���� �����������
              OperDate_sklad TDateTime,
              -- � ���������
              InvNumber        Integer,

              -- ������������� - ������ �� ����
              UnitId_from    Integer,
              -- ������������� - ������ ����
              UnitId_to      Integer,

              -- �����
              GoodsId        Integer,
              -- ��� ������
              GoodsKindId    Integer,

              -- �������� ������ ����������
              MovementId_order    Integer,

              -- �������� �����
              MovementId_promo Integer,

              -- ��� �����������
              Amount         TFloat,
              -- ��.
              Amount_sh      TFloat,

              -- ��� ����������
              AmountPartner      TFloat,
              -- ��.
              AmountPartner_sh   TFloat,

              -- ����� - ����������
              AmountPartner_promo      TFloat,
              -- ��.
              AmountPartner_promo_sh   TFloat,


              -- ����� � ��� ����������
              SummPartner             TFloat,
              -- ����� - ����� � ��� ����������
              SummPartner_promo       TFloat,

              --
              CONSTRAINT pk_bi_Table_SendBranch PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_SendBranch_OperDate ON _bi_Table_SendBranch (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_SendBranch TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_SendBranch TO project;

      END IF;

END;
$$;
