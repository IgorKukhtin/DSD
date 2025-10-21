-- ������� - ����� � �������� � �������

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_ProfitLoss
TRUNCATE TABLE _bi_Table_ProfitLoss;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_ProfitLoss')))
      THEN
           -- DROP TABLE _bi_Table_ProfitLoss
           --
           CREATE TABLE _bi_Table_ProfitLoss (
              Id                  BIGSERIAL NOT NULL,
              -- Id ������        
              ContainerId_pl      Integer,
              -- ����             
              OperDate            TDateTime,
              -- Id ���������
              MovementId          Integer,
              -- ��� ���������
              MovementDescId      Integer,
              -- � ���������      
              InvNumber           Integer,
              -- ���������� ��������
              MovementId_comment  Integer,
                                  
              -- ������ ����      
              ProfitLossId        Integer,
              -- ������
              BusinessId         Integer,

              -- ������ ������ (Գ��)
              BranchId_pl         Integer,
              -- ������������� ������ (ϳ������)
              UnitId_pl           Integer,

              -- ������ ��        
              InfoMoneyId         Integer,

              -- ������������� ����� (̳��� �����)
              UnitId              Integer,
              -- ������������ (����������� ������)
              AssetId             Integer,
              -- ���������� (����������� ������, ����� �����)
              CarId               Integer,
              -- ��� ����
              MemberId            Integer,
              -- ������ �������� (������ ��������, ����������� ������)
              ArticleLossId       Integer,
              
              -- ��'��� �����������
              DirectionId         Integer,
              -- ��'��� �����������
              DestinationId       Integer,

              -- �� ���� (����� �����) - ������������
              FromId              Integer,
              -- ���� (����� �����, ����������� ������) - ������������
              ToId                Integer,

              -- �����
              GoodsId    Integer,
              -- ��� ������
              GoodsKindId         Integer,
              -- ��� ������ (������ ��� ������������ ����� ��)
              GoodsKindId_gp      Integer,

              -- ���-�� (���)
              OperCount           TFloat,
              -- ���-�� (��.)
              OperCount_sh        TFloat,
              -- �����
              OperSumm            TFloat,

              CONSTRAINT pk_bi_Table_ProfitLoss PRIMARY KEY (Id)
           );

          -- 1.1.
          CREATE INDEX idx_bi_Table_ProfitLoss_OperDate ON _bi_Table_ProfitLoss (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_ProfitLoss TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_ProfitLoss TO project;

      END IF;

END;
$$;
