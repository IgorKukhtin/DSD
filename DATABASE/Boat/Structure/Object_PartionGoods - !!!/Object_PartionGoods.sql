/*
  �������� 
    - ������� Object_PartionGoods (o������)
    - ������
    - ��������
*/
-- drop TABLE Object_PartionGoods

/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PartionGoods(
   MovementItemId      Integer NOT NULL PRIMARY KEY, 
   MovementId          Integer NOT NULL,
   MovementDescId      Integer NOT NULL, -- ��� ���������: ������ ��� ������������-������������
   FromId              Integer ,         -- ��������� ��� ������������� (����� ������)
   UnitId              Integer ,         -- ������������� (���� ������)
   OperDate            TDateTime,        -- ����
   ObjectId            Integer NOT NULL,         -- ������������� ��� �����
   Amount              TFloat  NOT NULL, -- ���-�� ������
   EKPrice	       TFloat  NOT NULL, -- ���� ��. ��� ���
   CountForPrice       TFloat  NOT NULL DEFAULT 1, -- ��� ���� ��. ��� ���
   EmpfPrice	       TFloat  NOT NULL, -- ���� ��������. ��� ���
   OperPriceList       TFloat  NOT NULL, -- ���� �� ������ ��� ���
   GoodsGroupId        Integer,
   GoodsTagId          Integer,
   GoodsTypeId         Integer, 
   GoodsSizeId         Integer, 
   ProdColorId         Integer, 
   MeasureId           Integer,
   TaxKindId           Integer NOT NULL, 
   TaxValue            TFloat  NOT NULL, 
   isErased            Boolean NOT NULL DEFAULT FALSE,
   isArc               Boolean NOT NULL DEFAULT FALSE
  );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_PartionGoods_MovementItemId ON Object_PartionGoods (MovementItemId);
CREATE INDEX idx_Object_PartionGoods_MovementId	    ON Object_PartionGoods (MovementId);
CREATE INDEX idx_Object_PartionGoods_MovementDescId ON Object_PartionGoods (MovementDescId);
CREATE INDEX idx_Object_PartionGoods_FromId   ON Object_PartionGoods (FromId);
CREATE INDEX idx_Object_PartionGoods_UnitId   ON Object_PartionGoods (UnitId);
CREATE INDEX idx_Object_PartionGoods_ObjectId ON Object_PartionGoods (ObjectId);

/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
               ������� �.�.   ������ �.�.   ���������� �.�.
01.03.21                                         *
*/
