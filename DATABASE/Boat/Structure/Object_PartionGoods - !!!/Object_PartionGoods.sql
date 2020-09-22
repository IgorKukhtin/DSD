/*
  �������� 
    - ������� Object_PartionGoods (o������)
    - ������
    - ��������
*/
--drop TABLE Object_PartionGoods

/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PartionGoods(
   MovementItemId      Integer NOT NULL PRIMARY KEY, 
   MovementId          Integer NOT NULL,
   MovementDescId      Integer NOT NULL,
   FromId              Integer ,
   UnitId              Integer ,
   OperDate            TDateTime,
   GoodsId             Integer ,
   Amount              TFloat  NOT NULL,
   CurrencyId          Integer ,
   OperPrice	       TFloat  NOT NULL,
   CountForPrice       TFloat  NOT NULL DEFAULT 1,
   OperPriceList       TFloat  NOT NULL,
   GoodsGroupId        Integer ,
   MeasureId           Integer ,
   isErased            Boolean NOT NULL DEFAULT FALSE,
   isArc               Boolean NOT NULL DEFAULT FALSE
  );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_PartionGoods_MovementItemId ON Object_PartionGoods (MovementItemId);
CREATE INDEX idx_Object_PartionGoods_MovementId	 ON Object_PartionGoods (MovementId);
CREATE INDEX idx_Object_PartionGoods_FromId  ON Object_PartionGoods (FromId);
CREATE INDEX idx_Object_PartionGoods_UnitId  ON Object_PartionGoods (UnitId);
CREATE INDEX idx_Object_PartionGoods_GoodsId ON Object_PartionGoods (GoodsId);

/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
               ������� �.�.   ������ �.�.   ���������� �.�.
24.08.20                                         *
*/
