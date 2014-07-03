/*
  �������� 
    - ������� LoadMovementItem (������������� ������� ��������)
    - ������
    - ��������
*/

-- Table: Movement

-- DROP TABLE LoadMovement;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadMovementItem
(
  Id             serial    NOT NULL PRIMARY KEY,
  GoodsCode      TVarChar, -- ��� ������ ����������
  GoodsName	 TVarChar, -- ������������ ������ ����������
  GoodsId        Integer,  -- ������
  LoadMovementId Integer,  -- ������ �� �������� LoadMovement
  Amount         TFloat,   -- ����������
  PackageAmount  TFloat,   -- ���������� � ��������
  Price          TFloat,   -- ����
  Summ           TFloat,   -- �����
  ExpirationDate TDateTime,-- ���� ��������
  CONSTRAINT fk_LoadMovementItem_LoadMovementId FOREIGN KEY (LoadMovementId)  REFERENCES LoadMovement (id),
  CONSTRAINT fk_LoadMovementItem_GoodsId        FOREIGN KEY (GoodsId)         REFERENCES Object (id))
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadMovementItem
  OWNER TO postgres;
 
CREATE INDEX idx_LoadMovementItem_LoadMovementId ON LoadMovementItem(LoadMovementId);
CREATE INDEX idx_LoadMovementItem_GoodsId        ON LoadMovementItem(GoodsId); 


/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/
