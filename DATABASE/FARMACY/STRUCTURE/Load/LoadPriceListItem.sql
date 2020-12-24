/*
  �������� 
    - ������� LoadPriceListItem (������������� ������� ��������)
    - ������
    - ��������
*/

-- Table: Movement

-- DROP TABLE LoadPriceListItem;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadPriceListItem
(
  Id              serial        NOT NULL PRIMARY KEY,
  CommonCode      Integer  , -- ����� ��� ������
  GoodsCode       TVarChar , -- ��� ������ ����������
  GoodsName	  TVarChar , -- ������������ ������ ����������
  GoodsNDS	  TVarChar , -- ��� ������
  GoodsId         Integer  , -- ������
  LoadPriceListId Integer  , -- ������ �� �����-����
  Price           TFloat   , -- ����
  ExpirationDate  TDateTime, -- ���� ��������
  ProducerName    TVarChar , -- �������������     
  PackCount       TVarChar , -- ���������� � ��������
  BarCode         TVarChar , -- �����-���
  GoodsNameUpper     TVarChar , -- ������������ ������ ����������
  ProducerNameUpper  TVarChar , -- �������������     
  CONSTRAINT fk_LoadPriceListItem_LoadMovementId FOREIGN KEY (LoadPriceListId)  REFERENCES LoadPriceList (id),
  CONSTRAINT fk_LoadPriceListItem_GoodsId        FOREIGN KEY (GoodsId)          REFERENCES Object (id))
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadPriceListItem
  OWNER TO postgres;
 
CREATE INDEX idx_LoadPriceListItem_LoadPriceListId ON LoadPriceListItem(LoadPriceListId);
CREATE INDEX idx_LoadPriceListItem_LoadPriceListId_GoodsCode ON LoadPriceListItem(LoadPriceListId, GoodsCode);
CREATE INDEX idx_LoadPriceListItem_LoadPriceListId_CommonCode ON LoadPriceListItem(LoadPriceListId, CommonCode);
CREATE INDEX idx_LoadPriceListItem_LoadPriceListId_BarCode ON LoadPriceListItem(LoadPriceListId, BarCode);
CREATE INDEX idx_LoadPriceListItem_GoodsId         ON LoadPriceListItem(GoodsId); 


/*

  ALTER TABLE LoadPriceListItem ADD COLUMN GoodsNameUpper     TVarChar
  ALTER TABLE LoadPriceListItem ADD COLUMN ProducerNameUpper  TVarChar

  UPDATE LoadPriceListItem SET GoodsNameUpper = zfCalc_TVarChar_Upper(GoodsName), ProducerNameUpper = zfCalc_TVarChar_Upper(ProducerName)

*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/