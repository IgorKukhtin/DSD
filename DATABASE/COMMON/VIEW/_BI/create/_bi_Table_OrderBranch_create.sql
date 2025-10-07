-- ������� - ������ ��������

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_OrderBranch
TRUNCATE TABLE _bi_Table_OrderBranch;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_OrderBranch')))
      THEN
           -- DROP TABLE _bi_Table_OrderBranch
           --
           CREATE TABLE _bi_Table_OrderBranch (
              Id              BIGSERIAL NOT NULL,
              -- Id ���������
              MovementId     Integer,
              -- ���� ������
              OperDate       TDateTime,
              -- ���� �����
              OperDate_sklad TDateTime,
              -- ���� ������
              OperDate_order TDateTime,
              -- � ���������
              InvNumber        Integer,

              -- ������������� - ������ �� ����
              UnitId_from    Integer,
              -- ������������� - ������ ���� - �����
              UnitId_to      Integer,

              -- ����������
              Comment        TVarChar,
              Comment_car    TVarChar,

              -- �����
              GoodsId        Integer,
              -- ��� ������
              GoodsKindId    Integer,

              -- �������� �����
              MovementId_promo Integer,

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
              CONSTRAINT pk_bi_Table_OrderBranch PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_OrderBranch_OperDate ON _bi_Table_OrderBranch (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_OrderBranch TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_OrderBranch TO project;

      END IF;

END;
$$;
