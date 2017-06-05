/*
  �������� 
    - ������� LoadGoodsBarCodeItem (������������� ������� ��������)
    - ������
    - ��������
*/

-- Table: LoadGoodsBarCodeItem

-- DROP TABLE LoadGoodsBarCodeItem;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadGoodsBarCodeItem
(
  Id                 serial NOT NULL,
  LoadGoodsBarCodeId Integer NOT NULL,
  GoodsJuridicalId   Integer,
  JuridicalId        Integer,
  UserId             Integer,
  OperDate           TDateTime,
  GoodsCode          TVarChar,  -- ��� ������ ����������
  BarCode            TVarChar,  -- �����-���
  JuridicalName      TVarChar,  -- ���������
  CONSTRAINT pk_LoadGoodsBarCodeItem PRIMARY KEY (Id),
  CONSTRAINT fk_LoadGoodsBarCodeItem_LoadGoodsBarCodeId FOREIGN KEY (LoadGoodsBarCodeId) REFERENCES LoadGoodsBarCode (Id)
);

CREATE UNIQUE INDEX idx_LoadGoodsBarCodeItem_Unique ON LoadGoodsBarCodeItem (LoadGoodsBarCodeId, JuridicalId);


/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.  �������� �.�.
 05.06.17                                          * 
*/
