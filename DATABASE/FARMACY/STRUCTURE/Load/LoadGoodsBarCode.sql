/*
  �������� 
    - ������� LoadGoodsBarCode (������������� ������� ��������)
    - ������
    - ��������
*/

-- Table: LoadGoodsBarCode

-- DROP TABLE LoadGoodsBarCode;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadGoodsBarCode
(
  Id               serial NOT NULL,
  GoodsId          Integer,
  GoodsMainId      Integer,
  GoodsMorionId    Integer,
  GoodsBarCodeId   Integer,
  GoodsJuridicalId Integer,
  JuridicalId      Integer,
  Code             Integer,   -- ��� ��� ������
  Name             TVarChar,  -- �������� ������
  ProducerName     TVarChar,  -- �������������
  GoodsCode        TVarChar,  -- ��� ������ ����������
  CommonCode       Integer,   -- ��� �������
  BarCode          TVarChar,  -- �����-���
  JuridicalName    TVarChar,  -- ���������
  ErrorText        TVarChar,
  CONSTRAINT pk_LoadGoodsBarCode PRIMARY KEY (Id)
);

CREATE UNIQUE INDEX idx_LoadGoodsBarCode_Code ON LoadGoodsBarCode (Code);
CREATE UNIQUE INDEX idx_LoadGoodsBarCode_BarCode ON LoadGoodsBarCode (BarCode);

/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.  �������� �.�.
 05.06.17                                          * 
*/
