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
              -- ��� ��������� - _bi_Guide_MovementDesc_View
              MovementDescId      Integer,
              -- � ���������      
              InvNumber           Integer,
              -- ���������� �������� - _bi_Guide_MovementComment_View
              MovementId_comment  Integer,
                                  
              -- ������ ���� - _bi_Guide_ProfitLoss_View
              ProfitLossId        Integer,
              -- ������ - _bi_Guide_Object_View
              BusinessId         Integer,

              -- ������ ������ (Գ��) - _bi_Guide_Branch_View
              BranchId_pl         Integer,
              -- ������������� ������ (ϳ������) - _bi_Guide_Unit_View
              UnitId_pl           Integer,

              -- ������ �� - _bi_Guide_InfoMoney_View
              InfoMoneyId         Integer,

              -- ������������� ����� (̳��� �����) - _bi_Guide_Unit_View
              UnitId              Integer,
              -- ������������ (����������� ������) - _bi_Guide_Asset_View
              AssetId             Integer,
              -- ���������� (����������� ������, ����� �����) - _bi_Guide_Car_View
              CarId               Integer,
              -- ��� ���� - _bi_Guide_Member_View
              MemberId            Integer,
              -- ������ �������� (������ ��������, ����������� ������) - _bi_Guide_ArticleLoss_View
              ArticleLossId       Integer,
              
              -- ��'��� ����������� - _bi_Guide_Object_View
              DirectionId         Integer,
              -- ��'��� ����������� - _bi_Guide_Object_View
              DestinationId       Integer,

              -- �� ���� (����� �����) - ������������ - _bi_Guide_Object_View
              FromId              Integer,
              -- ���� (����� �����, ����������� ������) - ������������ - _bi_Guide_Object_View
              ToId                Integer,

              -- ����� - _bi_Guide_Goods_View
              GoodsId             Integer,
              -- ��� ������ - _bi_Guide_GoodsKind_View
              GoodsKindId         Integer,
              -- ��� ������ (������ ��� ������������ ����� ��) - _bi_Guide_GoodsKind_View
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
