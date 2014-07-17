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
  GoodsCode       TVarChar , -- ��� ������ ����������
  GoodsName	  TVarChar , -- ������������ ������ ����������
  GoodsNDS	  TVarChar, -- ��� ������
  GoodsId         Integer  , -- ������
  LoadPriceListId Integer  , -- ������ �� �����-����
  Price           TFloat   , -- ����
  ExpirationDate  TDateTime, -- ���� ��������
  CONSTRAINT fk_LoadPriceListItem_LoadMovementId FOREIGN KEY (LoadPriceListId)  REFERENCES LoadPriceList (id),
  CONSTRAINT fk_LoadPriceListItem_GoodsId        FOREIGN KEY (GoodsId)          REFERENCES Object (id))
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadPriceListItem
  OWNER TO postgres;
 
CREATE INDEX idx_LoadPriceListItem_LoadPriceListId ON LoadPriceListItem(LoadPriceListId);
CREATE INDEX idx_LoadPriceListItem_GoodsId         ON LoadPriceListItem(GoodsId); 


/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/
