DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('LoadGoodsBarCode'))) 
      THEN
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
      END IF;

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('LoadGoodsBarCodeItem'))) 
      THEN
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
      END IF;

END;
$$;
