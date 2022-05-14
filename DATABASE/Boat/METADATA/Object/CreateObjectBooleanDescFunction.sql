CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Goods_Arc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Arc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectBoolean_Goods_Arc', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Goods_Arc');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ReceiptProdModel_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptProdModel_Main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptProdModel(), 'zc_ObjectBoolean_ReceiptProdModel_Main', '������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptProdModel_Main');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ReceiptGoods_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptGoods_Main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptGoods(), 'zc_ObjectBoolean_ReceiptGoods_Main', '������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ReceiptGoods_Main');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_ProdColorItems_ProdOptions() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ProdColorItems_ProdOptions'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdColorItems(), 'zc_ObjectBoolean_ProdColorItems_ProdOptions', '�������� ��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ProdColorItems_ProdOptions');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Product_BasicConf() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Product_BasicConf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Product(), 'zc_ObjectBoolean_Product_BasicConf', '�������� ��� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Product_BasicConf');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Product_ProdColorPattern() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Product_ProdColorPattern'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Product(), 'zc_ObjectBoolean_Product_ProdColorPattern', '�������� ��� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Product_ProdColorPattern');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Account_onComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_onComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Account(), 'zc_ObjectBoolean_Account_onComplete', '������ ��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_onComplete');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Check() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Check'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptProdModelChild(), 'zc_ObjectBoolean_Check', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Check');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.03.21         * zc_ObjectBoolean_Account_onComplete
 01.12.20         *
 11.11.20         * 
 28.08.20                                        * 
*/
