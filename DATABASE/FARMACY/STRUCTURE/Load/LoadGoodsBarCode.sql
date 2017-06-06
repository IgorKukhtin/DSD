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
  GoodsBarCodeId   Integer,
  GoodsJuridicalId Integer,
  JuridicalId      Integer,
  Code             Integer,   -- ��� ��� ������
  Name             TVarChar,  -- �������� ������
  ProducerName     TVarChar,  -- �������������
  GoodsCode        TVarChar,  -- ��� ������ ����������
  BarCode          TVarChar,  -- �����-���
  JuridicalName    TVarChar,  -- ���������
  ErrorText        TVarChar,
  CONSTRAINT pk_LoadGoodsBarCode PRIMARY KEY (Id)
);

CREATE UNIQUE INDEX idx_LoadGoodsBarCode_Code ON LoadGoodsBarCode (Code);

/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.  �������� �.�.
 05.06.17                                          * 
*/
