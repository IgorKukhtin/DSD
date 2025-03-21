 ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReplServer_CountTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectFloat_ReplServer_CountTo', '���-�� ������� � ��������� ������ ��� �������� � ����-Child' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountTo');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReplServer_CountFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectFloat_ReplServer_CountFrom', '���-�� ������� � ��������� ������ ��� ��������� �� ����-Child' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReplServer_CountFrom');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Volume() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Volume'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Volume', '�����, �3.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Volume');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Weight', '��� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Height', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Length', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_Width', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Box_NPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_NPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Box(), 'zc_ObjectFloat_Box_NPP', 'NPP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Box_NPP');


--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCodeBox_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCodeBox(), 'zc_ObjectFloat_BarCodeBox_Weight', '������ ��� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCodeBox_Print() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Print'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCodeBox(), 'zc_ObjectFloat_BarCodeBox_Print', '���-�� ��� ������ �/�' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Print');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CardFuel_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalGroup(), 'zc_ObjectFloat_CardFuel_Limit', '�����, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_Limit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CardFuel_LimitFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_LimitFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CardFuel(), 'zc_ObjectFloat_CardFuel_LimitFuel', '�����, �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_LimitFuel');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_ChangePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_ChangePrice', zc_Object_Contract(), '������ � ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_ChangePercent', zc_Object_Contract(), '(-)% ������ (+)% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Term() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Term'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_Term', zc_Object_Contract(), '������ �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Term');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractCondition_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractCondition_Value', zc_Object_ContractCondition(), '������� �������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractCondition_PercentRetBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_PercentRetBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractCondition_PercentRetBonus', zc_Object_ContractCondition(), '������� �������� % �������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_PercentRetBonus');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_DocumentCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DocumentCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_DocumentCount', zc_Object_Contract(), '���������� ��������� �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DocumentCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_Percent', '% ������������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_DayTaxSummary() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DayTaxSummary'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_DayTaxSummary', '���-�� ���� ��� ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_DayTaxSummary');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_PercentSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_PercentSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_PercentSP', zc_Object_Contract(), '% ������ (��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_PercentSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectFloat_Contract_OrderSumm', '����������� ����� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_OrderSumm');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractGoods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractGoods_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractGoods_Price', zc_Object_ContractGoods(), '����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractGoods_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Fuel_Ratio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Fuel(), 'zc_ObjectFloat_Fuel_Ratio', '����������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_AmountIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_AmountIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_AmountIn', '���-�� ����. �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_AmountIn');
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PriceIn', '���� ����. �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceIn');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Site() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Site'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Site', '���� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Site');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_MinimumLot', '����������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PercentMarkup', '% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentMarkup');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Price', '���� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_ReferCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_ReferCode', '��� ����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferCode');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_ReferPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_ReferPrice', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ReferPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Weight', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_WeightTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_WeightTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_WeightTare', '��� ������/����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_WeightTare');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountForWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountForWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_CountForWeight', '���-�� ��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountForWeight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountReceipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountReceipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_CountReceipt', '���-�� ������ ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountReceipt');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_Amount', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_BoxCount', '���������� � �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_BoxCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_AmountDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_AmountDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_AmountDoc', '���������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_AmountDoc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_WeightOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_WeightOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_WeightOnBox', '���������� ��. � ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_WeightOnBox');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_CountOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_CountOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_CountOnBox', '���������� ��. � ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_CountOnBox');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_Percent', '' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_DayTaxSummary() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_DayTaxSummary'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_DayTaxSummary', '���-�� ���� ��� ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_DayTaxSummary');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_OrderSumm', '����������� ����� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_OrderSumm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_SummOrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_SummOrderFinance', '����� �� ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderFinance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_SummOrderMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_SummOrderMin', '����������� ����� � ������ >= ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_SummOrderMin');



CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginCategoryItem_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginCategoryItem(), 'zc_ObjectFloat_MarginCategoryItem_MinPrice', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginCategoryItem_MarginPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MarginPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginCategoryItem(), 'zc_ObjectFloat_MarginCategoryItem_MarginPercent', '% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategoryItem_MarginPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginCategory_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategory_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginCategory(), 'zc_ObjectFloat_MarginCategory_Percent', '% ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginCategory_Percent');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent1', '����. % ��� 1-��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent2', '����. % ��� 2-��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent3', '����. % ��� 3-��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent4', '����. % ��� 4-��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent5', '����. % ��� 5-��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent6', '����. % ��� 6-��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarginReportItem_Percent7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarginReportItem(), 'zc_ObjectFloat_MarginReportItem_Percent7', '����. % ��� 7-��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarginReportItem_Percent7');




CREATE OR REPLACE FUNCTION zc_ObjectFloat_ModelServiceItemMaster_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc', zc_Object_ModelServiceItemMaster(), '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ModelServiceItemMaster_Ratio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_Ratio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ModelServiceItemMaster_Ratio', zc_Object_ModelServiceItemMaster(), '����������� ��� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_Ratio');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionGoods_Price', zc_Object_PartionGoods(), '����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalGroup_WorkHours() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalGroup_WorkHours'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalGroup(), 'zc_ObjectFloat_PersonalGroup_WorkHours', '���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalGroup_WorkHours');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MajorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MajorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MinorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MinorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionMovement_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovement_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_PartionMovement(), 'zc_ObjectFloat_PartionMovement_MovementId', '���� ��������� ������ �� ��������� � ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovement_MovementId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionMovementItem_MovementItemId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovementItem_MovementItemId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_PartionMovementItem(), 'zc_ObjectFloat_PartionMovementItem_MovementItemId', '���� �������� �������������� ����� � ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovementItem_MovementItemId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_PrepareDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_PrepareDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_PrepareDayCount', '�� ������� ���� ����������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_PrepareDayCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_DocumentDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DocumentDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_DocumentDayCount', '����� ������� ���� ����������� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DocumentDayCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_GPSN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_GPSN', 'GPS ���������� ����� �������� (������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_GPSE() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSE'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_GPSE', 'GPS ���������� ����� �������� (�������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_GPSE');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_Category() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_Category'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_Category', '��������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_Category');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_Personal', '����������� - % �� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_Personal');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_PersonalTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_PersonalTrade'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_PersonalTrade', '�� - % �� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_PersonalTrade');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_MemberSaler1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_MemberSaler1', '��������-1 - % �� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_TaxSale_MemberSaler2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_TaxSale_MemberSaler2', '��������-2 - % �� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_TaxSale_MemberSaler2');


--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceList_VATPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceList_VATPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceList(), 'zc_ObjectFloat_PriceList_VATPercent', '% ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceList_VATPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuel_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuel(), 'zc_ObjectFloat_RateFuel_Amount', '���-�� ����� �� 100 ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuel_AmountColdHour() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdHour'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuel(), 'zc_ObjectFloat_RateFuel_AmountColdHour', '�����, ���-�� ����� � ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdHour');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuel_AmountColdDistance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdDistance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuel(), 'zc_ObjectFloat_RateFuel_AmountColdDistance', '�����, ���-�� ����� �� 100 ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuel_AmountColdDistance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RateFuelKind_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuelKind_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RateFuelKind(), 'zc_ObjectFloat_RateFuelKind_Tax', '% ���. ������� � ����� � �������/������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RateFuelKind_Tax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptChild_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptChild_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectFloat_ReceiptChild_Value', '������������ �������� - ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptChild_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_Value', '�������� (����������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_ValueCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValueCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_ValueCost', '�������� ������(����������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValueCost');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxExit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxExit', ' % ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxExitCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExitCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxExitCheck', ' % ������ (�������� ��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExitCheck');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLoss', ' % ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLoss');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionValue', '���������� � ������ (���������� � ������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionCount', '����������� ���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_WeightPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_WeightPackage', '��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TotalWeightMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeightMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TotalWeightMain', '����� ��� ��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeightMain');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TotalWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TotalWeight', '����� ��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TotalWeight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLossCEH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossCEH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLossCEH', ' ������(���)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossCEH');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLossTRM() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossTRM'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLossTRM', '% ������ (��������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossTRM');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxLossVPR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossVPR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxLossVPR', '% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxLossVPR');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_RealDelicShp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_RealDelicShp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_RealDelicShp', '��� ����� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_RealDelicShp');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_ValuePF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValuePF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_ValuePF', '***��� �/� (��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValuePF');




CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_HoursPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_HoursPlan', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_HoursDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_HoursDay', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursDay');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_PersonalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_PersonalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_PersonalCount', '���. �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_PersonalCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffListCost_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListCost_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StaffListCost_Price', zc_Object_StaffListCost(), '�������� ���./��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListCost_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffListSumm_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListSumm_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StaffListSumm_Value', zc_Object_StaffListSumm(), '�����, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListSumm_Value');

-- CREATE OR REPLACE FUNCTION zc_ObjectFloat_Document_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Document_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
--  SELECT 'zc_ObjectFloat_Document_MovementId', zc_Object_Document(), '������ �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Document_MovementId');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff1', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff2', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff3', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff4', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff5', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff6', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff7', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff8', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff9', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff10', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff10');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff11', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff11');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_Koeff12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_Koeff12', zc_Object_OrderType(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_Koeff12');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_TermProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_TermProduction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_TermProduction', zc_Object_OrderType(), '���� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_TermProduction');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_NormInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_NormInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_NormInDays', zc_Object_OrderType(), '����� � ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_NormInDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderType_StartProductionInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_StartProductionInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderType_StartProductionInDays', zc_Object_OrderType(), '����� ������� ���� ����� ������ ���������� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderType_StartProductionInDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackage', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackage');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightTotal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightTotal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightTotal', '��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightTotal');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount', '% ������ ��� ���-��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker', '��� 1-��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightMin', '����������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightMax', '������������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightMax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Height', ' ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Length', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Width', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormInDays', '���� �������� � ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormInDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WmsCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WmsCode', '��� ��� - Integer' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCode');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum', '� ������ �� ������ ��� - Integer' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh', '������� ��� ��������� ������ "�������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom', '������� ��� ��������� ������ "�����������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves', '������� ��� ��������� ������ "�������������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh', '% ���������� ��������� ������ "�������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom', '% ���������� ��������� ������ "�����������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves', '% ���������� ��������� ������ "�������������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_DaysQ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_DaysQ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_DaysQ', '��������� ���� ������ � ������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_DaysQ');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormRem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormRem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormRem', '����������� �������, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormRem');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormOut', ' ����������� ����������� � �����, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormOut');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_NormPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_NormPack', '����� ������������ (� ��/���)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_NormPack');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_PackLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_PackLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_PackLimit', '����������� � ���� � ������ �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_PackLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob', '��� 1-��� ������ (��� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob');


--

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Quality_NumberPrint() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Quality(), 'zc_ObjectFloat_Quality_NumberPrint', '����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Limit', '�����, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Limit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_LimitDistance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_LimitDistance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_LimitDistance', '�����, ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_LimitDistance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Summer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Summer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Summer', '�����, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Summer');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Winter() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Winter'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Winter', '�����, �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Winter');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_Reparation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Reparation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectFloat_Member_Reparation', '�����, �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_Reparation');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Member_ScalePSW() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_ScalePSW'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(),'zc_ObjectFloat_Member_ScalePSW', '������ ��� ������������� � Scale' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Member_ScalePSW');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Founder_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Founder_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Founder(), 'zc_ObjectFloat_Founder_Limit', '�����, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Founder_Limit');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_Time() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectFloat_ImportSettings_Time', '������������� �������� ����� � �������� �������, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RateSumma() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSumma'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RateSumma', '����� ����������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSumma');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RatePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RatePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RatePrice', '������ ���/�� (������������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RatePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RateSummaAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RateSummaAdd', '����� ������� (������������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaAdd');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_RateSummaExp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaExp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_RateSummaExp', '����� ��������������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_RateSummaExp');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Route_TimePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_TimePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectFloat_Route_TimePrice', '������ ���/� (����������������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Route_TimePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SignInternal_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SignInternal(), 'zc_ObjectFloat_SignInternal_MovementDesc', '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SignInternal_ObjectDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_ObjectDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SignInternal(), 'zc_ObjectFloat_SignInternal_ObjectDesc', '��� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SignInternal_ObjectDesc');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_Monthly() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_Monthly'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_Monthly', '����������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_Monthly');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_PocketMinutes() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketMinutes'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_PocketMinutes', '���������� ����� � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketMinutes');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_PocketSMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketSMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_PocketSMS', '���������� ��� � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketSMS');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_PocketInet() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketInet'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_PocketInet', '���������� �� ��������� � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_PocketInet');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_CostSMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostSMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_CostSMS', '��������� ��� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostSMS');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_CostInet() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostInet'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_CostInet', '��������� 1 �� ��������� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostInet');



CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileTariff_CostMinutes() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostMinutes'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileTariff(), 'zc_ObjectFloat_MobileTariff_CostMinutes', '��������� 1 ������ ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileTariff_CostMinutes');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileEmployee_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileEmployee(), 'zc_ObjectFloat_MobileEmployee_Limit', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Limit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileEmployee_Dutylimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Dutylimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileEmployee(), 'zc_ObjectFloat_MobileEmployee_Dutylimit', '��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Dutylimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileEmployee_Navigator() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Navigator'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MobileEmployee(), 'zc_ObjectFloat_MobileEmployee_Navigator', '������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileEmployee_Navigator');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListSale_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListSale(), 'zc_ObjectFloat_GoodsListSale_Amount', '���-�� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_Amount');
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListSale_AmountChoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_AmountChoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListSale(), 'zc_ObjectFloat_GoodsListSale_AmountChoice', '���-�� � ���������� ��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListSale_AmountChoice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListIncome_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectFloat_GoodsListIncome_Amount', '���-��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_Amount');
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsListIncome_AmountChoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_AmountChoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectFloat_GoodsListIncome_AmountChoice', '���-�� ��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsListIncome_AmountChoice');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsTag_ColorReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsTag(), 'zc_ObjectFloat_GoodsTag_ColorReport', '���� ������ � "����� �� ��������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsTag_ColorBgReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorBgReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsTag(), 'zc_ObjectFloat_GoodsTag_ColorBgReport', '���� ���� � "������ �� ��������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsTag_ColorBgReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TradeMark_ColorReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TradeMark(), 'zc_ObjectFloat_TradeMark_ColorReport', '���� ������ � "����� �� ��������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TradeMark_ColorBgReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorBgReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TradeMark(), 'zc_ObjectFloat_TradeMark_ColorBgReport', '���� ���� � "������ �� ��������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TradeMark_ColorBgReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_OperDateDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_OperDateDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_OperDateDiff', zc_Object_MobileConst(), '�� ������� ���� ����� ��������� ��� ������� � ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_OperDateDiff');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_ReturnDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_ReturnDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_ReturnDayCount', zc_Object_MobileConst(), '������� ���� ����������� �������� �� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_ReturnDayCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_CriticalOverDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalOverDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_CriticalOverDays', zc_Object_MobileConst(), '���������� ���� ���������, ����� �������� ������������ ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalOverDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MobileConst_CriticalDebtSum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalDebtSum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MobileConst_CriticalDebtSum', zc_Object_MobileConst(), '����� �����, ����� �������� ������������ ������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MobileConst_CriticalDebtSum');

-- Sticker
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value1', zc_Object_Sticker(), '�������� �� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value2', zc_Object_Sticker(), '����� �� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value3', zc_Object_Sticker(), '���� �� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value4', zc_Object_Sticker(), '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value5', zc_Object_Sticker(), '���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value6', zc_Object_Sticker(), '� ��� ������� (����)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value7', zc_Object_Sticker(), '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Sticker_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Sticker_Value8', zc_Object_Sticker(), '��� ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Sticker_Value8');

-- StickerFile
CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width1', zc_Object_StickerFile(), '������ 1-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width2', zc_Object_StickerFile(), '������ 2-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width3', zc_Object_StickerFile(), '������ 3-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width4', zc_Object_StickerFile(), '������ 4-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width5', zc_Object_StickerFile(), '������ 5-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width6', zc_Object_StickerFile(), '������ 6-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width7', zc_Object_StickerFile(), '������ 7-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width8', zc_Object_StickerFile(), '������ 8-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width9', zc_Object_StickerFile(), '������ 9-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width10', zc_Object_StickerFile(), '������ 10-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level1', zc_Object_StickerFile(), '������ Level1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level2', zc_Object_StickerFile(), '������ Level2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left1', zc_Object_StickerFile(), '������� �������� ����� ��� 1-�� ������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left2', zc_Object_StickerFile(), '������� �������� ����� ��� ���������, ������� �� 2-��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width1_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width1_70_70', zc_Object_StickerFile(), '������ 1-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width1_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width2_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width2_70_70', zc_Object_StickerFile(), '������ 2-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width2_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width3_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width3_70_70', zc_Object_StickerFile(), '������ 3-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width3_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width4_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width4_70_70', zc_Object_StickerFile(), '������ 4-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width4_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width5_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width5_70_70', zc_Object_StickerFile(), '������ 5-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width5_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width6_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width6_70_70', zc_Object_StickerFile(), '������ 6-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width6_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width7_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width7_70_70', zc_Object_StickerFile(), '������ 7-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width7_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width8_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width8_70_70', zc_Object_StickerFile(), '������ 8-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width8_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width9_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width9_70_70', zc_Object_StickerFile(), '������ 9-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width9_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Width10_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Width10_70_70', zc_Object_StickerFile(), '������ 10-�� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Width10_70_70');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level1_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level1_70_70', zc_Object_StickerFile(), '������ Level1 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level1_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Level2_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Level2_70_70', zc_Object_StickerFile(), '������ Level2 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Level2_70_70');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left1_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left1_70_70', zc_Object_StickerFile(), '������� �������� ����� ��� 1-�� ������� ������ 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left1_70_70');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerFile_Left2_70_70() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2_70_70'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerFile_Left2_70_70', zc_Object_StickerFile(), '������� �������� ����� ��� ���������, ������� �� 2-�� 70*70' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerFile_Left2_70_70');



-- StickerProperty
CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value1', zc_Object_StickerProperty(), '�������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value2', zc_Object_StickerProperty(), '�������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value3', zc_Object_StickerProperty(), '� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value4', zc_Object_StickerProperty(), '� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value5', zc_Object_StickerProperty(), '������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value6', zc_Object_StickerProperty(), '���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value7', zc_Object_StickerProperty(), '% ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value8', zc_Object_StickerProperty(), ' � �� - ������ ���� ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value9', zc_Object_StickerProperty(), '� ���� - ������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value10', zc_Object_StickerProperty(), '������� �� - ������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value10');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StickerProperty_Value11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StickerProperty_Value11', zc_Object_StickerProperty(), '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StickerProperty_Value11');

-- GoodsReportSale
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount1', zc_Object_GoodsReportSale(), '���-�� � ���������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount2', zc_Object_GoodsReportSale(), '���-�� � ���������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount3', zc_Object_GoodsReportSale(), '���-�� � ���������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount4', zc_Object_GoodsReportSale(), '���-�� � ���������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount5', zc_Object_GoodsReportSale(), '���-�� � ���������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount6', zc_Object_GoodsReportSale(), '���-�� � ���������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Amount7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Amount7', zc_Object_GoodsReportSale(), '���-�� � ���������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Amount7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo1', zc_Object_GoodsReportSale(), '���-�� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo2', zc_Object_GoodsReportSale(), '���-�� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo3', zc_Object_GoodsReportSale(), '���-�� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo4', zc_Object_GoodsReportSale(), '���-�� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo5', zc_Object_GoodsReportSale(), '���-�� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo6', zc_Object_GoodsReportSale(), '���-�� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Promo7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Promo7', zc_Object_GoodsReportSale(), '���-�� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Promo7');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch1', zc_Object_GoodsReportSale(), '���-�� � ����������� �� ���� ������ ������ �� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch2', zc_Object_GoodsReportSale(), '���-�� � ����������� �� ���� ������ ������ �� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch3', zc_Object_GoodsReportSale(), '���-�� � ����������� �� ���� ������ ������ �� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch4', zc_Object_GoodsReportSale(), '���-�� � ����������� �� ���� ������ ������ �� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch5', zc_Object_GoodsReportSale(), '���-�� � ����������� �� ���� ������ ������ �� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch6', zc_Object_GoodsReportSale(), '���-�� � ����������� �� ���� ������ ������ �� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Branch7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Branch7', zc_Object_GoodsReportSale(), '���-�� � ����������� �� ���� ������ ������ �� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Branch7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order1', zc_Object_GoodsReportSale(), '���-�� � ������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order2', zc_Object_GoodsReportSale(), '���-�� � ������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order3', zc_Object_GoodsReportSale(), '���-�� � ������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order4', zc_Object_GoodsReportSale(), '���-�� � ������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order5', zc_Object_GoodsReportSale(), '���-�� � ������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order6', zc_Object_GoodsReportSale(), '���-�� � ������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_Order7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_Order7', zc_Object_GoodsReportSale(), '���-�� � ������� ��� ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_Order7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo1', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo2', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo3', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo4', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo5', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo6', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderPromo7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderPromo7', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderPromo7');
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch1', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch2', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch3', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch4', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch5', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch6', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_OrderBranch7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_OrderBranch7', zc_Object_GoodsReportSale(), '���-�� � ������� ������ ������ �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_OrderBranch7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSaleInf_Week() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSaleInf_Week'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSaleInf_Week', zc_Object_GoodsReportSaleInf(), '���-�� ������ � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSaleInf_Week');


--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan1', zc_Object_GoodsReportSale(), '���-�� ���� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan2', zc_Object_GoodsReportSale(), '���-�� ���� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan3', zc_Object_GoodsReportSale(), '���-�� ���� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan4', zc_Object_GoodsReportSale(), '���-�� ���� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan5', zc_Object_GoodsReportSale(), '���-�� ���� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan6', zc_Object_GoodsReportSale(), '���-�� ���� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoPlan7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoPlan7', zc_Object_GoodsReportSale(), '���-�� ���� � ���������� ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoPlan7');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1', zc_Object_GoodsReportSale(), '���-�� ���� � ������� �� ������ ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2', zc_Object_GoodsReportSale(), '���-�� ���� � ������� �� ������ ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3', zc_Object_GoodsReportSale(), '���-�� ���� � ������� �� ������ ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4', zc_Object_GoodsReportSale(), '���-�� ���� � ������� �� ������ ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5', zc_Object_GoodsReportSale(), '���-�� ���� � ������� �� ������ ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6', zc_Object_GoodsReportSale(), '���-�� ���� � ������� �� ������ ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7', zc_Object_GoodsReportSale(), '���-�� ���� � ������� �� ������ ������ ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_WorkTimeKind_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_WorkTimeKind_Tax', zc_Object_WorkTimeKind(), '% ��������� ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Tax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_WorkTimeKind_Summ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_WorkTimeKind_Summ', zc_Object_WorkTimeKind(), '����� � ��� �� ���� ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_WorkTimeKind_Summ');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_StartRemainsRep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsRep'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_StartRemainsRep', zc_Object_ReportCollation(), '���. ������ �� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsRep');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_EndRemainsRep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsRep'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_EndRemainsRep', zc_Object_ReportCollation(), '���. ������ �� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsRep');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_StartRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_StartRemains', zc_Object_ReportCollation(), '���. ������ �� ������ �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemains');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_EndRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_EndRemains', zc_Object_ReportCollation(), '���. ������ �� ������ �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemains');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_StartRemainsCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_StartRemainsCalc', zc_Object_ReportCollation(), '���. ������ �� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_StartRemainsCalc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportCollation_EndRemainsCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ReportCollation_EndRemainsCalc', zc_Object_ReportCollation(), '���. ������ �� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportCollation_EndRemainsCalc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance', zc_Object_JuridicalOrderFinance(), '����� �� ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_KoeffHoursWork() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_KoeffHoursWork'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_KoeffHoursWork', zc_Object_Car(), '�����. ��� ������ ������� ����� �� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_KoeffHoursWork');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_PartnerMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_PartnerMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_PartnerMin', zc_Object_Car(), '���-�� ����� �� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_PartnerMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Length', zc_Object_Car(), '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Width', zc_Object_Car(), '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Height', zc_Object_Car(), '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Weight', zc_Object_Car(), '��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Car_Year() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Year'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Car_Year', zc_Object_Car(), '��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Car_Year');

--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Length', zc_Object_CarExternal(), '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Width', zc_Object_CarExternal(), '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Height', zc_Object_CarExternal(), '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Weight', zc_Object_CarExternal(), '��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CarExternal_Year() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Year'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CarExternal_Year', zc_Object_CarExternal(), '��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CarExternal_Year');

--

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_Compensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_Compensation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_Compensation', zc_Object_PersonalServiceList(), '� ����� ������ ����������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_Compensation');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond', zc_Object_PersonalServiceList(), '����� ��� �������� ��������� ���� 2�.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_SummAvance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_SummAvance', zc_Object_PersonalServiceList(), '����� �����(����)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvance');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_SummAvanceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvanceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_SummAvanceMax', zc_Object_PersonalServiceList(), '���� ����� �����(����)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_SummAvanceMax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalServiceList_HourAvance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_HourAvance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PersonalServiceList_HourAvance', zc_Object_PersonalServiceList(), '���-�� ����� ��� �����(����)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalServiceList_HourAvance');



CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberMinus_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MemberMinus_TotalSumm', zc_Object_MemberMinus(), '����� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_TotalSumm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberMinus_Summ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MemberMinus_Summ', zc_Object_MemberMinus(), '����� � ��������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Summ');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberMinus_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_MemberMinus_Tax', zc_Object_MemberMinus(), '% ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberMinus_Tax');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderPeriodKind_Week() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderPeriodKind_Week'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderPeriodKind_Week', zc_Object_WorkTimeKind(), '���-�� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderPeriodKind_Week');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Reason_PeriodDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Reason_PeriodDays', zc_Object_Reason(), '������ � ��. �� "���� ��������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Reason_PeriodTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Reason_PeriodTax', zc_Object_Reason(), '������ � % �� "���� ��������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Reason_PeriodTax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalDefermentPayment_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalDefermentPayment_Amount', zc_Object_JuridicalDefermentPayment(), '����� ��������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalDefermentPayment_AmountIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_AmountIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalDefermentPayment_AmountIn', zc_Object_JuridicalDefermentPayment(), '����� ���������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalDefermentPayment_AmountIn');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ObjectCode_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ObjectCode_Basis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ObjectCode_Basis', zc_Object_Goods(), '��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ObjectCode_Basis');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_OperDate', zc_Object_OrderCarInfo(), '���� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_OperDatePartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDatePartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_OperDatePartner', zc_Object_OrderCarInfo(), '���� �������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_OperDatePartner');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_Days() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Days'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_Days', zc_Object_OrderCarInfo(), '��������� � ���� ��� ����/����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Days');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_Hour() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Hour'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_Hour', zc_Object_OrderCarInfo(), '����, ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Hour');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OrderCarInfo_Min() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Min'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_OrderCarInfo_Min', zc_Object_OrderCarInfo(), '������, ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OrderCarInfo_Min');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Level() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Level'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Level', zc_Object_PartionCell(), ' ������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Level');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Length', zc_Object_PartionCell(), ' ����� ������, ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Width', zc_Object_PartionCell(), ' ������ ������, ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_Height', zc_Object_PartionCell(), ' ������ ������, ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_BoxCount', zc_Object_PartionCell(), ' ���-�� ������ �2 (����� � ������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_BoxCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_RowBoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowBoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_RowBoxCount', zc_Object_PartionCell(), ' ���-�� ������ � ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowBoxCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_RowWidth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowWidth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_RowWidth', zc_Object_PartionCell(), ' ���-�� ����� (�������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowWidth');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionCell_RowHeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowHeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PartionCell_RowHeight', zc_Object_PartionCell(), ' ���-�� ����� (������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionCell_RowHeight');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsGroupProperty_ColorReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsGroupProperty_ColorReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsGroupProperty(), 'zc_ObjectFloat_GoodsGroupProperty_ColorReport', '���� ������ � "����� �� ��������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsGroupProperty_ColorReport');

    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Bank_SummMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Bank_SummMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_Bank_SummMax', '����������� �� ������������ ����� ��� ���� - �2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Bank_SummMax');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ChoiceCell_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_ChoiceCell_BoxCount', '���-�� ������ �2 (����� � ������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_BoxCount');
        
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ChoiceCell_NPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_NPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_ChoiceCell_NPP', '� �/� ��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ChoiceCell_NPP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsNormDiff_ValuePF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValuePF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_GoodsNormDiff_ValuePF', '����� ���������� �/� (��), ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValuePF');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsNormDiff_ValueGP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValueGP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Bank(), 'zc_ObjectFloat_GoodsNormDiff_ValueGP', '����� ���������� ��, ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsNormDiff_ValueGP');






 
--!!! ������

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_Deferment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Deferment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_Deferment', zc_Object_Contract(), '�������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_Deferment');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_TotalSumm', zc_Object_Contract(), '����� ���. ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_TotalSumm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_StartRow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ImportSettings_StartRow', zc_Object_ImportSettings(), '������ ������ �������� ��� Excel' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettings_Bonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_Bonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalSettings_Bonus', zc_Object_JuridicalSettings(), '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_Bonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettings_PriceLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_PriceLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_JuridicalSettings_PriceLimit', zc_Object_JuridicalSettings(), '���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettings_PriceLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_NDSKind_NDS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_NDSKind_NDS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_NDSKind_NDS', zc_Object_NDSKind(), '�������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_NDSKind_NDS');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettings_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettings_MinPrice', zc_Object_PriceGroupSettings(), '��������� ���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettings_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettings_Percent', zc_Object_PriceGroupSettings(), '% ��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettings_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice', zc_Object_PriceGroupSettingsTOP(), '��������� ���� ������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceGroupSettingsTOP_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_PriceGroupSettingsTOP_Percent', zc_Object_PriceGroupSettingsTOP(), '% ��� �������� ������  ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceGroupSettingsTOP_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ServiceDate_Year() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Year'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ServiceDate(), 'zc_ObjectFloat_ServiceDate_Year', '���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Year');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ServiceDate_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ServiceDate(), 'zc_ObjectFloat_ServiceDate_Month', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ServiceDate_Month');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Quality_NumberPrint() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Quality(), 'zc_ObjectFloat_Quality_NumberPrint', '����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Quality_NumberPrint');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_StartPosInt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosInt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_StartPosInt', '����� ����� ���� � ����� ����(��������� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosInt');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_EndPosInt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosInt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_EndPosInt', '����� ����� ���� � ����� ����(��������� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosInt');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_StartPosFrac() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosFrac'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_StartPosFrac', '������� ����� ���� � ����� ����(��������� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosFrac');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_EndPosFrac() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosFrac'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_EndPosFrac', '������� ����� ���� � ����� ����(��������� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosFrac');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_StartPosIdent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosIdent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_StartPosIdent', '������������� ������(��������� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_StartPosIdent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_EndPosIdent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosIdent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_EndPosIdent', '������������� ������(��������� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_EndPosIdent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsProperty_TaxDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_TaxDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsProperty(), 'zc_ObjectFloat_GoodsProperty_TaxDoc', '% ���������� ��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsProperty_TaxDoc');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_Value', '�������� ���� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValue', '����������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValueSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValueSun', '����������� �������� ����� ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueSun');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_PercentMarkup', '% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_PercentMarkup');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValueOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValueOld', '��� - �������� ������� �������� �� ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueOld');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Price_MCSValueMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectFloat_Price_MCSValueMin', '����������� ����������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Price_MCSValueMin');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportSoldParams_PlanAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportSoldParams_PlanAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportSoldParams(), 'zc_ObjectFloat_ReportSoldParams_PlanAmount', '����� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportSoldParams_PlanAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReportPromoParams_PlanAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportPromoParams_PlanAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportPromoParams(), 'zc_ObjectFloat_ReportPromoParams_PlanAmount', '����� ����� �� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReportPromoParams_PlanAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_PayOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_PayOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_PayOrder', '������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_PayOrder');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_ConditionalPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ConditionalPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_ConditionalPercent', '���.������� �� ������, %' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ConditionalPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Position_TaxService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Position_TaxService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Position(), 'zc_ObjectFloat_Position_TaxService', '% �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Position_TaxService');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_TaxService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_TaxService', '% �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxService');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_TaxServiceNigth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxServiceNigth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_TaxServiceNigth', '% �� ������� � ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_TaxServiceNigth');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_FarmacyCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_FarmacyCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_FarmacyCash', '���-�� ������ � ������������� � FarmacyCash' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_FarmacyCash');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ���.����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period1', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period2', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period3', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period4', zc_Object_Unit(), '���-�� ���� ��� ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period5', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period6', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Period7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Period7', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Period7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_WeekId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_WeekId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_WeekId', zc_Object_Unit(), '���� ������ ��� ������� ��������� �� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_WeekId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun1', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��� ���  ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun2', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��� ���  ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun3', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��� ���  ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun4', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��� ���  ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun5', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��� ���  ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun6', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��� ���  ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PeriodSun7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_PeriodSun7', zc_Object_Unit(), '���-�� ���� ��� ������� ��� ��� ���  ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PeriodSun7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun1', zc_Object_Unit(), '��������� ����� ��� ��� ���  � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun2', zc_Object_Unit(), '��������� ����� ��� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun3', zc_Object_Unit(), '��������� ����� ��� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun4', zc_Object_Unit(), '��������� ����� ��� ��� ��� � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun5', zc_Object_Unit(), '��������� ����� ��� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun6', zc_Object_Unit(), '��������� ����� ��� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DaySun7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_DaySun7', zc_Object_Unit(), '��������� ����� ��� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DaySun7');

 CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day', zc_Object_Unit(), '��������� ����� ��� ��� � ���� ���. ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day1', zc_Object_Unit(), '��������� ����� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day2', zc_Object_Unit(), '��������� ����� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day3', zc_Object_Unit(), '��������� ����� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day4', zc_Object_Unit(), '��������� ����� ��� ��� � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day5', zc_Object_Unit(), '��������� ����� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day6', zc_Object_Unit(), '��������� ����� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Day7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Day7', zc_Object_Unit(), '��������� ����� ��� ��� � ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Day7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_SunIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SunIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_SunIncome', zc_Object_Unit(), '���-�� ���� ������ �� ����. (��������� ���)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SunIncome');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Sun_v2Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v2Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Sun_v2Income', zc_Object_Unit(), '���-�� ���� ������ �� ����. (��������� ���-2)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v2Income');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Sun_v4Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v4Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_Sun_v4Income', zc_Object_Unit(), '���-�� ���� ������ �� ����. (��������� ���-2-��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Sun_v4Income');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_v1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_v1', zc_Object_Unit(), '���-�� ���� ��� HammerTime ���-1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_v2', zc_Object_Unit(), '���-�� ���� ��� HammerTime ���-2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_All'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_All', zc_Object_Unit(), '���-�� ���� ��� HammerTime ��� ���� ��� �� ���� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_All');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_HT_SUN_v1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Unit_HT_SUN_v1', zc_Object_Unit(), '���-�� ���� ��� HammerTime ���-1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_HT_SUN_v1');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_PeriodUse() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_PeriodUse', '������ ������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_Production() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_Production'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_Production', '������������������, ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_Production');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_KW() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_KW'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_KW', '������������ �������� KW' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_KW');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OverSettings_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_OverSettings(), 'zc_ObjectFloat_OverSettings_MinPrice', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_OverSettings_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_OverSettings(), 'zc_ObjectFloat_OverSettings_MinimumLot', '��������� (���.����������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_OverSettings_MinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PriceSP', '����� ������������ �� �������� ���������� ������ (15)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_GroupSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_GroupSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_GroupSP', '����� �������-����� � � ��� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_GroupSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_CountSP', 'ʳ������ ������� ���������� ������ � ��������� �������� (6)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountSP');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceOptSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceOptSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_PriceOptSP', '������-�������� ���� �� �������� (11)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceOptSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PriceRetSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceRetSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_PriceRetSP', '�������� ���� �� �������� (12)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PriceRetSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DailyNormSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyNormSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_DailyNormSP', '������ ���� ���������� ������, ������������� ���� (13)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyNormSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DailyCompensationSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyCompensationSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_DailyCompensationSP', '����� ������������ ������ ���� ���������� ������ (14)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DailyCompensationSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PaymentSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PaymentSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_Goods(),'zc_ObjectFloat_Goods_PaymentSP', '���� ������� �� �������� (16)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PaymentSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_ColSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ColSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_ColSP', '� �.�.(1)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_ColSP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_CountPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_CountPrice', '���-�� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_CountPrice');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v3', '��������� �� �-���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v1', '��������� �� ��� v1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v2', '��������� �� ��� v2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_v4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_v4', '��������� �� ��� v2-��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_v4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_LimitSUN_T1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_LimitSUN_T1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_LimitSUN_T1', '�������, ��� ������� ������ ��� ���-2 � ���-2-�� �������� �1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_LimitSUN_T1');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_User_BillNumberMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_BillNumberMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(),'zc_ObjectFloat_User_BillNumberMobile', '����������� � � ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_BillNumberMobile');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SPKind_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SPKind_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SPKind(),'zc_ObjectFloat_SPKind_Tax', '% ������ �� ����� (��� ���.�������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SPKind_Tax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyBox_WeightOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_WeightOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyBox(), 'zc_ObjectFloat_GoodsPropertyBox_WeightOnBox', '���������� ��. � ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_WeightOnBox');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyBox_CountOnBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_CountOnBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyBox(), 'zc_ObjectFloat_GoodsPropertyBox_CountOnBox', '���������� ��. � ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyBox_CountOnBox');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Maker_CashBack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_CashBack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectFloat_Maker_CashBack', '����� Cash Back ��� ������ �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_CashBack');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Overdraft_Summa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Overdraft_Summa'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Overdraft(), 'zc_ObjectFloat_Overdraft_Summa', '����� ��������� ��� ������ �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Overdraft_Summa');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_Value', '��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_FixValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_FixValue', '��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_PercentMarkup', '��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_PercentMarkup');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_FixPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_FixPercent', '������������� % ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_FixDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_FixDiscount', '������������� ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_FixDiscount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceChange_Multiplicity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Multiplicity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectFloat_PriceChange_Multiplicity', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceChange_Multiplicity');


  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_PercentDifference() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentDifference'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_PercentDifference', '% ������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentDifference');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax', '������. � % �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin', '������. � % �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin');

  CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax', '�����. � % �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin', '�����. � % �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DocumentTaxKind_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DocumentTaxKind_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DocumentTaxKind(), 'zc_ObjectFloat_DocumentTaxKind_Price', '����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DocumentTaxKind_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_Week() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_Week'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_Week', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_Week');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettingsItem_Bonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_Bonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettingsItem(), 'zc_ObjectFloat_JuridicalSettingsItem_Bonus', '% �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_Bonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalSettingsItem_PriceLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_PriceLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalSettingsItem(), 'zc_ObjectFloat_JuridicalSettingsItem_PriceLimit', '% �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalSettingsItem_PriceLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Maker_Day() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Day'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectFloat_Maker_Day', '������������� �������� � ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Day');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Maker_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectFloat_Maker_Month', '������������� �������� � �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Maker_Month');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GlobalConst_SiteDiscount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GlobalConst_SiteDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GlobalConst(), 'zc_ObjectFloat_GlobalConst_SiteDiscount', ' % ������ ��� ����� ' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GlobalConst_SiteDiscount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_NormOfManDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_NormOfManDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_NormOfManDays', '����� ������������ � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_NormOfManDays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffInSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffInSUN', '����������� ������� ������/������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffOutSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffOutSUN', '����������� ������� ������/������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffOutSUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffOutSUN_v3', '����. ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffOutSUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_KoeffInSUN_v3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN_v3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_KoeffInSUN_v3', '����. ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_KoeffInSUN_v3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_T1_SUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_T1_SUN_v2', '���-�� ���� ��� T1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_T2_SUN_v2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T2_SUN_v2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_T2_SUN_v2', '���-�� ���� ��� T2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T2_SUN_v2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_T1_SUN_v4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_T1_SUN_v4', '���-�� ���� ��� T1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_T1_SUN_v4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_LimitSUN_N() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_LimitSUN_N'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_LimitSUN_N', '�������, ��� ������� �������� ���-1 � ���-2 � ���-2-�� �������� �1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_LimitSUN_N');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan', '% ������ �� ������������ ������������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_PremiumImplPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PremiumImplPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_PremiumImplPlan', '% ������ �� ���������� ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PremiumImplPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan', '����������� % ����������� ���������� ������������ ����� ��� ��������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsCategory_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsCategory_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsCategory(), 'zc_ObjectFloat_GoodsCategory_Value', '���-��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsCategory_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TaxUnit_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TaxUnit(), 'zc_ObjectFloat_TaxUnit_Price', '���� �...' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_TaxUnit_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_TaxUnit(), 'zc_ObjectFloat_TaxUnit_Value', '% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_TaxUnit_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_MarginPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_MarginPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_MarginPercent', '% ������� ��� ����� �������� < 6 ���.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_MarginPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_SummSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_SummSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_SummSUN', '�����, ��� ������� ���������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_SummSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_LimitSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_LimitSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_LimitSUN', '����� ��� ������� (����������� ���)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_LimitSUN');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_ShareFromPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_ShareFromPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_ShareFromPrice', '������ ���������� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_ShareFromPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_RoundWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_RoundWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_RoundWeight', '���-�� ������ ��� ���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_RoundWeight');
 
 
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CreditLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CreditLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CreditLimit', '��������� ����� �� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CreditLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionDateKind_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateKind(), 'zc_ObjectFloat_PartionDateKind_Month', '���-�� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Month');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionDateKind_Day() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Day'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateKind(), 'zc_ObjectFloat_PartionDateKind_Day', '���-�� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateKind_Day');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RetailCostCredit_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RetailCostCredit(), 'zc_ObjectFloat_RetailCostCredit_MinPrice', '��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RetailCostCredit_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_RetailCostCredit(), 'zc_ObjectFloat_RetailCostCredit_Percent', '% ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_RetailCostCredit_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_Value', '% ������ � ������ ��� ���� �� 1 �� 6 ���.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_ValueMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_ValueMin', '% ������ � ������ ��� ���� �� 0 �� 1 ���.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueMin');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_MovementId', '������ ��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_MovementId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MaxOrderAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_MaxOrderAmount', '������������ ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MaxOrderAmountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_MaxOrderAmountSecond', '������������ ����� ������ ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MaxOrderAmountSecond');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CreditLimitJuridical_CreditLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CreditLimitJuridical_CreditLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CreditLimitJuridical(), 'zc_ObjectFloat_CreditLimitJuridical_CreditLimit', '��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CreditLimitJuridical_CreditLimit');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_PriceWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_PriceWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_PriceWithVAT', '���� ������� � ���.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_PriceWithVAT');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollType_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollType(), 'zc_ObjectFloat_PayrollType_Percent', '������� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollType_MinAccrualAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_MinAccrualAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollType(), 'zc_ObjectFloat_PayrollType_MinAccrualAmount', '��� ����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollType_MinAccrualAmount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_LabReceiptChild_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_LabReceiptChild_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_LabReceiptChild(), 'zc_ObjectFloat_LabReceiptChild_Value', '��������(����� ��� ������������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_LabReceiptChild_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Latitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Latitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Latitude', '�������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Latitude');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Longitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Longitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Longitude', '�������������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Longitude');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CodeRazom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeRazom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CodeRazom', '��� � ������� "�����"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeRazom');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MorionCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MorionCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MorionCode', '��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MorionCode');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_CommentTR_DifferenceSum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CommentTR_DifferenceSum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentTR(), 'zc_ObjectFloat_CommentTR_DifferenceSum', '���������� ������� � �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CommentTR_DifferenceSum');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MoneyBoxSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MoneyBoxSun', '������� �� ����������� ���1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSun');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MoneyBoxSunUsed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSunUsed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MoneyBoxSunUsed', '������������� ������� �� ����������� ���1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MoneyBoxSunUsed');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff1', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff2', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff3', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff4', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff4');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff5', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff6', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff6');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff7', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff7');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff8', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff8');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff9', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff9');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff10', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff10');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff11', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff11');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SeasonalityCoefficient_Koeff12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_SeasonalityCoefficient_Koeff12', zc_Object_SeasonalityCoefficient(), '����������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SeasonalityCoefficient_Koeff12');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity', zc_Object_CashRegister(), '����������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_Fund() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_Fund'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_Fund', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_Fund');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_FundUsed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_FundUsed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_FundUsed', '������������� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_FundUsed');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_OccupancySUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_OccupancySUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_OccupancySUN', '������������� ��������� �� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_OccupancySUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DriverSun_ChatIDSendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DriverSun_ChatIDSendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DriverSun(), 'zc_ObjectFloat_DriverSun_ChatIDSendVIP', '��� ID ��� �������� ��������� � Telegram �� ������������ VIP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DriverSun_ChatIDSendVIP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_SummaFormSendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaFormSendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_SummaFormSendVIP', '����� �� ������� ������� ����� ��� ������������ ����������� VIP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaFormSendVIP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP', '����� ����������� �� ������� �������� ������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_DeySupplSun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DeySupplSun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_DeySupplSun1', '��� ������ � ���������� ���1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_DeySupplSun1');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_MonthSupplSun1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MonthSupplSun1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_MonthSupplSun1', '���������� ������� ����� � ���������� ���1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_MonthSupplSun1');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CodeMedicard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeMedicard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CodeMedicard', '��� � ������� "Medicard"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeMedicard');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionGoods_ValueLess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueLess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectFloat_PartionGoods_ValueLess', '% ������ � ������ ��� ���� �� 1 �� 3 ���.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionGoods_ValueLess');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionHouseholdInventory_MovementItemId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionHouseholdInventory_MovementItemId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionHouseholdInventory(), 'zc_ObjectFloat_PartionHouseholdInventory_MovementItemId', '���� �������� ������� �������������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionHouseholdInventory_MovementItemId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_HouseholdInventory_CountForPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_HouseholdInventory_CountForPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_HouseholdInventory(), 'zc_ObjectFloat_HouseholdInventory_CountForPrice', '�������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_HouseholdInventory_CountForPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_SerialNumberTabletki() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberTabletki'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_SerialNumberTabletki', '�������� ����� �� ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberTabletki');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_JuridicalPriorities_Priorities() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalPriorities_Priorities'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalPriorities(), 'zc_ObjectFloat_JuridicalPriorities_Priorities', '% ���������� - ��������� ��������� + �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_JuridicalPriorities_Priorities');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DaySaleForSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DaySaleForSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DaySaleForSUN', '���������� ���� ��� �������� <�������/������� �� ���� ���>' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DaySaleForSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKind_DaysForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_DaysForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_DiffKind_DaysForSale', '���� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_DaysForSale');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_MaxPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_MaxPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_MaxPrice', '����������� ���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_MaxPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ConditionsKeep_RelatedProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ConditionsKeep_RelatedProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ConditionsKeep(), 'zc_ObjectFloat_ConditionsKeep_RelatedProduct', '������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ConditionsKeep_RelatedProduct');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AttemptsSub() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AttemptsSub'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AttemptsSub', '���������� ������� �� �������� ����� ����� ��� ����������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AttemptsSub');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_PercentSAUA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PercentSAUA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_PercentSAUA', '������� ���������� ����� � ����� ��� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_PercentSAUA');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SummaWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SummaWages', '����������� �������� �� 1 ������� ������� � ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWages');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PercentWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PercentWages', '% �� ������� � ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWages');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SummaWagesStore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWagesStore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SummaWagesStore', '����������� �������� �� 1 ������� ������� � �������� ��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SummaWagesStore');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PercentWagesStore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWagesStore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PercentWagesStore', '% �� ������� � �������� ��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PercentWagesStore');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_CodeOrangeCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeOrangeCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_CodeOrangeCard', '��� � ������� "����� ����"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_CodeOrangeCard');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_KoeffSUN_Supplementv1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_Supplementv1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(),'zc_ObjectFloat_Goods_KoeffSUN_Supplementv1', '��������� �� ���������� ���1' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_KoeffSUN_Supplementv1');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_ShareFromPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_ShareFromPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(),'zc_ObjectFloat_Unit_ShareFromPrice', '������ ���������� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_ShareFromPrice');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DayNonCommoditySUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayNonCommoditySUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DayNonCommoditySUN', '���������� ���� ��� �������� ����������� "���������� ���"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayNonCommoditySUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_SerialNumberMypharmacy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberMypharmacy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_SerialNumberMypharmacy', '�������� ����� �� ����� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_SerialNumberMypharmacy');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_UpperLimitPromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_UpperLimitPromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_UpperLimitPromoBonus', '������� ������ ��������� (������ ������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_UpperLimitPromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_LowerLimitPromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LowerLimitPromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_LowerLimitPromoBonus', '������ ������ ��������� (������ ������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LowerLimitPromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MinPercentPromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPercentPromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MinPercentPromoBonus', '����������� ������� (������ ������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPercentPromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartnerMedical_LikiDniproId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartnerMedical_LikiDniproId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartnerMedical(), 'zc_ObjectFloat_PartnerMedical_LikiDniproId', 'Id ������������ ���������� � ������� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartnerMedical_LikiDniproId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MedicSP_LikiDniproId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MedicSP_LikiDniproId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MedicSP(), 'zc_ObjectFloat_MedicSP_LikiDniproId', 'Id ����� � ������� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MedicSP_LikiDniproId');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MemberSP_LikiDniproId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberSP_LikiDniproId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MemberSP(), 'zc_ObjectFloat_MemberSP_LikiDniproId', 'Id �������� � ������� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MemberSP_LikiDniproId');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiscountExternalSupplier_SupplierID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiscountExternalSupplier_SupplierID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiscountExternalSupplier(), 'zc_ObjectFloat_DiscountExternalSupplier_SupplierID', 'ID - ���������� � �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiscountExternalSupplier_SupplierID');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Multiplicity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Multiplicity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Multiplicity', '��������� ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Multiplicity');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Juridical_ExpirationDateMonth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ExpirationDateMonth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectFloat_Juridical_ExpirationDateMonth', '����� � ���������� ����� �� ������ ����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Juridical_ExpirationDateMonth');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_Threshold() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_Threshold'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_Threshold', '����� ����������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_Threshold');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_DaysStock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_DaysStock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_DaysStock', '���� ������ � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_DaysStock');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_CountPharmacies() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_CountPharmacies'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_CountPharmacies', '���. ���-�� ����� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_CountPharmacies');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter', '������. �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter');
  
  CREATE OR REPLACE FUNCTION c() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayCompensDiscount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DayCompensDiscount', '���� �� ����������� �� ���������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DayCompensDiscount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS', '����� ������������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCS');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains', '����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemains');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge', '����� ������������ ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdMCSLarge');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge', '����� ������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_FinalSUAProtocol_ThresholdRemainsLarge');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_Value', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_Value');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_PercentMarkup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_PercentMarkup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_PercentMarkup', '������������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_PercentMarkup');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarketingDiscount_Multiplicity() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_Multiplicity'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarketingDiscount(), 'zc_ObjectFloat_MarketingDiscount_Multiplicity', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_Multiplicity');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MarketingDiscount_FixValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_FixValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MarketingDiscount(), 'zc_ObjectFloat_MarketingDiscount_FixValue', '������������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MarketingDiscount_FixValue');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AssortmentGeograph() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentGeograph'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AssortmentGeograph', '����� ���������� �� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentGeograph');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AssortmentSales() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentSales'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AssortmentSales', '����� ���������� �� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AssortmentSales');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_CustomerThreshold() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CustomerThreshold'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_CustomerThreshold', '����� ������������ ��� ������ ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CustomerThreshold');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptLevel_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptLevel_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptLevel(), 'zc_ObjectFloat_ReceiptLevel_MovementDesc', '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptLevel_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CorrectMinAmount_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectMinAmount_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectMinAmount(), 'zc_ObjectFloat_CorrectMinAmount_Amount', '����� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectMinAmount_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PairSunAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PairSunAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PairSunAmount', '���������� �������� ������ � ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PairSunAmount');

  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_ZReportLog_SummaCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ZReportLog(), 'zc_ObjectFloat_ZReportLog_SummaCash', '������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCash');
  
  CREATE OR REPLACE FUNCTION zc_ObjectFloat_ZReportLog_SummaCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ZReportLog(), 'zc_ObjectFloat_ZReportLog_SummaCard', '������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ZReportLog_SummaCard');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PriceCorrectionDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceCorrectionDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PriceCorrectionDay', '������ ���� ��� ������� ��������� ���� �� ������ �����/������� ������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceCorrectionDay');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollTypeVIP_PercentPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollTypeVIP(), 'zc_ObjectFloat_PayrollTypeVIP_PercentPhone', '������� �� �������, ������� ��������� � �����.������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentPhone');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollTypeVIP_PercentOther() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentOther'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollTypeVIP(), 'zc_ObjectFloat_PayrollTypeVIP_PercentOther', '������� �� ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_PercentOther');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_DiscountProcent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountProcent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_DiscountProcent', '������� ������ �� ���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountProcent');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_PromoBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PromoBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_PromoBonus', '����� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_PromoBonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CorrectWagesPercentage_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectWagesPercentage_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectWagesPercentage(), 'zc_ObjectFloat_CorrectWagesPercentage_Percent', '������� �� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CorrectWagesPercentage_Percent');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_NumberPlates() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_NumberPlates'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_NumberPlates', '���-�� ������� � ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_NumberPlates');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_QtyPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_QtyPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_QtyPackage', '���-�� � ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_QtyPackage');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PriceSamples() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceSamples'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PriceSamples', '����� ���� ������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceSamples');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Samples21() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples21'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Samples21', '������ ������� ��� 2.1 (�� 90-200 ����)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples21');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Samples22() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples22'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Samples22', '������ ������� ��� 2.2 (�� 50-90 ����)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples22');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Samples3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Samples3', '������ ������� ��� 3 (�� 0 �� 50 ����)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Samples3');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_Cat_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Cat_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_Cat_5', '������ ��� 5 �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_Cat_5');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_DiscountWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_DiscountWithVAT', '������������� ������ � ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithVAT');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCode_DiscountWithoutVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithoutVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCode(), 'zc_ObjectFloat_BarCode_DiscountWithoutVAT', '������������� ������ ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCode_DiscountWithoutVAT');
    
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SupplementMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SupplementMin', '��������� � ���������� ��� �� ����� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMin');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_SupplementMinPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMinPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_SupplementMinPP', '��������� � ���������� ��� ��� �������� ������� �� ����� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_SupplementMinPP');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PercentIC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentIC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PercentIC', '������� �� ������� ��������� ��������� ��� �/� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentIC');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_SurchargeWages_Summa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SurchargeWages_Summa'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_SurchargeWages(), 'zc_ObjectFloat_SurchargeWages_Summa', '����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_SurchargeWages_Summa');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PercentUntilNextSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentUntilNextSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PercentUntilNextSUN', '������� ��� ��������� ������� "�������/������� �� ���� ���"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PercentUntilNextSUN');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Left() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Left'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Left', '��������� ������������ ������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Left');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Top() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Top'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Top', '��������� ������������ �������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Top');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Width() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Width'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Width', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Width');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_Height', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DiscontAmountSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontAmountSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_DiscontAmountSite', '����� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontAmountSite');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_DiscontPercentSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontPercentSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_DiscontPercentSite', '������� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_DiscontPercentSite');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_DiscontAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_DiscontAmount', '����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontAmount');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceSite_DiscontPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectFloat_PriceSite_DiscontPercent', '������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceSite_DiscontPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKind_Packages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_Packages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKind(), 'zc_ObjectFloat_DiffKind_Packages', '������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKind_Packages');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ExchangeRates_Exchange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ExchangeRates_Exchange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ExchangeRates(), 'zc_ObjectFloat_ExchangeRates_Exchange', '����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ExchangeRates_Exchange');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_TurnoverMoreSUN2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_TurnoverMoreSUN2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_TurnoverMoreSUN2', '������ ������ �� ������� ����� ��� ������������� ��� 2' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_TurnoverMoreSUN2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DeySupplOutSUN2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplOutSUN2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DeySupplOutSUN2', '������� ���� ��� ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplOutSUN2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DeySupplInSUN2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplInSUN2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DeySupplInSUN2', '������� ���� ��� ����� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeySupplInSUN2');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKindPrice_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKindPrice(), 'zc_ObjectFloat_DiffKindPrice_MinPrice', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_MinPrice');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKindPrice_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKindPrice(), 'zc_ObjectFloat_DiffKindPrice_Amount', '���������� �������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_DiffKindPrice_Summa() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Summa'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_DiffKindPrice(), 'zc_ObjectFloat_DiffKindPrice_Summa', '������������ ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_DiffKindPrice_Summa');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MCRequestItem_MinPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MinPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequestList(), 'zc_ObjectFloat_MCRequestItem_MinPrice', '����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MinPrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MCRequestItem_MarginPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequestList(), 'zc_ObjectFloat_MCRequestItem_MarginPercent', '% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_MCRequestItem_MarginPercentOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercentOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequestList(), 'zc_ObjectFloat_MCRequestItem_MarginPercentOld', '% ������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_MCRequestItem_MarginPercentOld');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_ExpressVIPConfirm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_ExpressVIPConfirm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_ExpressVIPConfirm', '����� ��� �������� ������������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_ExpressVIPConfirm');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_PriceFormSendVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceFormSendVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_PriceFormSendVIP', '���� �� ������� ������� ����� ��� ������������ ����������� VIP' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_PriceFormSendVIP');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MinPriceSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPriceSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MinPriceSale', '����������� ���� ������ ��� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MinPriceSale');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_DeviationsPrice1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeviationsPrice1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_DeviationsPrice1303', '������� ���������� �� ��������� ���� ��� ������� �� 1303' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_DeviationsPrice1303');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BuyerForSite_Bonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_Bonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_BuyerForSite_Bonus', '������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_Bonus');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BuyerForSite_BonusAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_BuyerForSite_BonusAdd', '�������� � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdd');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_BuyerForSite_BonusAdded() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdded'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_BuyerForSite_BonusAdded', '��������� � ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BuyerForSite_BonusAdded');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_MultiplicityDiscontSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MultiplicityDiscontSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BuyerForSite(), 'zc_ObjectFloat_Goods_MultiplicityDiscontSite', '��������� ��� ������� �� ����� �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_MultiplicityDiscontSite');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_User_InternshipConfirmation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_InternshipConfirmation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectFloat_User_InternshipConfirmation', '������������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_User_InternshipConfirmation');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_NormNewMobileOrders() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_NormNewMobileOrders'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_NormNewMobileOrders', '	����� �� ����� ������� ���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_NormNewMobileOrders');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_LimitCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LimitCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_LimitCash', '����������� ��� ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_LimitCash');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AddMarkupTabletki() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AddMarkupTabletki'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AddMarkupTabletki', '��� ������� �� �������� �� ��� �� ������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AddMarkupTabletki');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PayrollTypeVIP_Rate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_Rate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PayrollTypeVIP(), 'zc_ObjectFloat_PayrollTypeVIP_Rate', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PayrollTypeVIP_Rate');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_FixedPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_FixedPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_FixedPercent', '������������� ������� ���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_FixedPercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionDateWages_Percent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateWages_Percent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateWages(), 'zc_ObjectFloat_PartionDateWages_Percent', '����������� ����������� ��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionDateWages_Percent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MobMessSum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessSum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MobMessSum', '��������� �� �������� ������ �� ���������� �� ����� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessSum');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_MobMessCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_MobMessCount', '��������� �� �������� ������ �� ���������� ����� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_MobMessCount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_AccountSalesDE_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_AccountSalesDE_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_AccountSalesDE(), 'zc_ObjectFloat_AccountSalesDE_Amount', '����� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_AccountSalesDE_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_Count() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_Count'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_Count', '���� ��� ���. ����. ���������� ����������� ��� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_Count');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine', '���� ��� ���. ����. ���������� ����������� ��� ���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine', '���� ��� ���. ����. ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward', '���� ��� ���. ����. ���������� ����������� ��� ���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward', '���� ��� ���. ����. ����������� ������� ���������� ����� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_CourseReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CourseReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_CourseReport', '���� ��� "����� ������� �� ������������� ��� ����������"' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_CourseReport');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CashSettings_SmashSumSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SmashSumSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectFloat_CashSettings_SmashSumSend', '�������� ����������� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CashSettings_SmashSumSend');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
 21.03.25         * zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob
 11.03.24         * zc_ObjectFloat_Bank_SummMax
 16.02.24         * zc_ObjectFloat_GoodsByGoodsKind_PackLimit
 27.12.23         * zc_ObjectFloat_PartionCell_...
 27.12.23                                                                                      * zc_ObjectFloat_CashSettings_SmashSumSend
 24.10.23                                                                                      * zc_ObjectFloat_CashSettings_CourseReport
 13.10.23                                                                                      * zc_ObjectFloat_CashSettings_Cat_5
 11.07.23                                                                                      * zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward
 10.07.23                                                                                      * zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward
 13.06.23                                                                                      * zc_ObjectFloat_CashSettings_AntiTOPMP_...
 21.03.23                                                                                      * zc_ObjectFloat_AccountSalesDE_Amount
 14.03.23         * zc_ObjectFloat_PersonalServiceList_SummAvance
                    zc_ObjectFloat_PersonalServiceList_SummAvanceMax
                    zc_ObjectFloat_PersonalServiceList_HourAvance
 02.02.23                                                                                      * zc_ObjectFloat_CashSettings_MobMessSum, zc_ObjectFloat_CashSettings_MobMessCount
 18.01.23                                                                                      * zc_ObjectFloat_PartionDateWages_Percent
 17.01.23                                                                                      * zc_ObjectFloat_CashSettings_FixedPercent
 12.01.23                                                                                      * zc_ObjectFloat_PayrollTypeVIP_Rate
 02.01.23                                                                                      * zc_ObjectFloat_CashSettings_AddMarkupTabletki
 25.11.22                                                                                      * zc_ObjectFloat_CashSettings_LimitCash
 13.10.22                                                                                      * zc_ObjectFloat_CashSettings_NormNewMobileOrders
 26.09.22                                                                                      * zc_ObjectFloat_User_InternshipConfirmation
 21.09.22                                                                                      * zc_ObjectFloat_Goods_MultiplicityDiscontSite
 20.09.22                                                                                      * zc_ObjectFloat_BuyerForSite_Bonus, zc_ObjectFloat_BuyerForSite_BonusAdd, zc_ObjectFloat_BuyerForSite_BonusAdded
 01.09.22         * zc_ObjectFloat_JuridicalDefermentPayment_AmountIn
 12.07.22         * zc_ObjectFloat_OrderCarInfo_...
 04.07.22                                                                                      * zc_ObjectFloat_CashSettings_DeviationsPrice1303
 20.06.22                                                                                      * zc_ObjectFloat_CashSettings_MinPriceSale
 15.06.22                                                                                      * zc_ObjectFloat_CashSettings_PriceFormSendVIP
 07.06.22                                                                                      * zc_ObjectFloat_CashSettings_ExpressVIPConfirm
 20.05.22                                                                                      * zc_ObjectFloat_DiffKindPrice_Price, zc_ObjectFloat_DiffKindPrice_Amount, zc_ObjectFloat_MCRequestItem_MinPrice, zc_ObjectFloat_MCRequestItem_MarginPercent, zc_ObjectFloat_MCRequestItem_MarginPercentOld
 27.04.22         * zc_ObjectFloat_ObjectCode_Basis
 08.04.22                                                                                      * zc_ObjectFloat_CashSettings_DeySupplOutSUN2, zc_ObjectFloat_CashSettings_DeySupplInSUN2 
 15.03.22                                                                                      * zc_ObjectFloat_CashSettings_TurnoverMoreSUN2 
 24.02.22                                                                                      * zc_ObjectFloat_ExchangeRates_Exchange 
 16.02.22                                                                                      * zc_ObjectFloat_DiffKind_Packages 
 15.02.22                                                                                      * zc_ObjectFloat_PriceSite_DiscontAmount, zc_ObjectFloat_PriceSite_DiscontPercent
 15.02.22                                                                                      * zc_ObjectFloat_Goods_DiscontAmountSite, zc_ObjectFloat_Goods_DiscontPercentSite
 11.02.22                                                                                      * c_ObjectFloat_Unit_...
 22.12.21         * zc_ObjectFloat_MemberMinus_Tax
 02.12.21                                                                                      * zc_ObjectFloat_CashSettings_PercentUntilNextSUN
 25.11.21                                                                                      * zc_ObjectFloat_SurchargeWages_Summa
 25.11.21                                                                                      * zc_ObjectFloat_CashSettings_PercentIC
 18.11.21         * zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond
 10.11.21                                                                                      * zc_ObjectFloat_Goods_SupplementMinPP
 02.11.21         * zc_ObjectFloat_Car_Weight
                    zc_ObjectFloat_Car_Year 
 29.10.21                                                                                      * zc_ObjectFloat_Goods_SupplementMin
 27.10.21                                                                                      * zc_ObjectFloat_BarCode_DiscountWithVAT, zc_ObjectFloat_BarCode_DiscountWithoutVAT
 18.10.21                                                                                      * zc_ObjectFloat_CashSettings_Samples...
 29.09.21                                                                                      * zc_ObjectFloat_Goods_NumberPlates, zc_ObjectFloat_Goods_QtyPackage
 24.09.21                                                                                      * zc_ObjectFloat_CorrectWagesPercentage_Percent
 16.09.21                                                                                      * zc_ObjectFloat_Goods_PromoBonus
 15.09.21                                                                                      * zc_ObjectFloat_BarCode_DiscountProcent
 14.09.21                                                                                      * zc_ObjectFloat_PayrollTypeVIP_Percent...
 10.09.21                                                                                      * zc_ObjectFloat_CashSettings_PriceCorrectionDay
 30.07.21                                                                                      * zc_ObjectFloat_ZReportLog_Summa...
 27.07.21                                                                                      * zc_ObjectFloat_CashSettings_CustomerThreshold
 01.07.21                                                                                      * zc_ObjectFloat_Goods_PairSunAmount
 24.06.21         * zc_ObjectFloat_Reason_PeriodDays
                    zc_ObjectFloat_Reason_PeriodTax
 22.06.21                                                                                      * zc_ObjectFloat_CorrectMinAmount_Amount
 14.06.21         * zc_ObjectFloat_ReceiptLevel_MovementDesc
 08.06.21         * zc_ObjectFloat_OrderPeriodKind_Week
 07.06.21                                                                                      * zc_ObjectFloat_CashSettings_Assortment...
 29.04.21         * zc_ObjectFloat_Partner_Category
 27.04.21                                                                                      * zc_ObjectFloat_MarketingDiscount_...
 27.04.21         * zc_ObjectFloat_Car_PartnerMin
 14.04.21                                                                                      * zc_ObjectFloat_CashSettings_DayCompensDiscount
 25.03.21         * zc_ObjectFloat_GoodsByGoodsKind_NormRem
                    zc_ObjectFloat_GoodsByGoodsKind_NormOut
 23.03.21                                                                                      * zc_ObjectFloat_FinalSUAProtocol_...
 18.03.21                                                                                      * zc_ObjectFloat_Juridical_ExpirationDateMonth
 17.03.21                                                                                      * zc_ObjectFloat_Goods_Multiplicity
 11.03.21                                                                                      * zc_ObjectFloat_DiscountExternalSupplier_SupplierID
 01.03.21                                                                                      * zc_ObjectFloat_PartnerMedical_LikiDniproId
 19.02.21         * zc_ObjectFloat_GoodsByGoodsKind_DaysQ
 18.02.21                                                                                      * zc_ObjectFloat_CashSettings_UpperLimitPromoBonus, zc_ObjectFloat_CashSettings_LowerLimitPromoBonus
 09.02.21                                                                                      * zc_ObjectFloat_Unit_SerialNumberMypharmacy
 05.02.21                                                                                      * zc_ObjectFloat_CashSettings_DayNonCommoditySUN
 09.12.20                                                                                      * zc_ObjectFloat_Unit_ShareFromPrice
 05.12.20                                                                                      * zc_ObjectFloat_Goods_KoeffSUN_Supplementv1
 20.11.20                                                                                      * zc_ObjectFloat_Juridical_CodeOrangeCard
 17.11.20         * zc_ObjectFloat_Asset_KW
 29.10.20                                                                                      * zc_ObjectFloat_Goods_SummaWages, zc_ObjectFloat_Goods_PercentWages
 26.10.20                                                                                      * zc_ObjectFloat_Unit_PercentSAUA
 21.10.20                                                                                      * zc_ObjectFloat_CashSettings_AttemptsSub
 14.10.20                                                                                      * zc_ObjectFloat_ConditionsKeep_RelatedProduct
 07.09.20                                                                                      * zc_ObjectFloat_BarCode_MaxPrice
 24.09.20                                                                                      * zc_ObjectFloat_DiffKind_DaysForSale
 15.09.20                                                                                      * zc_ObjectFloat_CashSettings_DaySaleForSUN
 04.09.20         * zc_ObjectFloat_MemberMinus_TotalSumm
                    zc_ObjectFloat_MemberMinus_Summ
 22.08.20                                                                                      * zc_ObjectFloat_JuridicalPriorities_Priorities
 21.07.20                                                                                      * zc_ObjectFloat_Unit_SerialNumberTabletki
 14.07.20                                                                                      * zc_ObjectFloat_HouseholdInventory_CountForPrice
 09.07.20                                                                                      * zc_ObjectFloat_PartionHouseholdInventory_MovementItemId
 06.07.20                                                                                      * zc_ObjectFloat_PartionGoods_ValueLess
 22.06.20                                                                                      * zc_ObjectFloat_Unit_HT_SUN_All
 10.06.20                                                                                      * zc_ObjectFloat_Juridical_CodeMedicard
 09.06.20                                                                                      * zc_ObjectFloat_Unit_DeySupplSun1, zc_ObjectFloat_Unit_MonthSupplSun1
 04.06.20         * zc_ObjectFloat_WorkTimeKind_Summ
 02.06.20                                                                                      * zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP
 27.05.20                                                                                      * zc_ObjectFloat_CashSettings_SummaFormSendVIP
 28.05.20         * zc_ObjectFloat_ContractCondition_PercentRetBonus
 26.05.20                                                                                      * zc_ObjectFloat_DriverSun_ChatIDSendVIP
 19.05.20         * zc_ObjectFloat_Unit_LimitSUN_N
 16.05.20         * zc_ObjectFloat_Goods_LimitSUN_T1
 15.05.20         * zc_ObjectFloat_Unit_HT_SUN_v1
                    zc_ObjectFloat_Unit_HT_SUN_v2
                    zc_ObjectFloat_Unit_HT_SUN_v4
 12.05.20         * zc_ObjectFloat_Unit_Sun_v2Income
                    zc_ObjectFloat_Unit_Sun_v4Income
                  * zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh
                    zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves
                    zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom
                    zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves
                    zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom
                    zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh
 11.05.20         * zc_ObjectFloat_Goods_KoeffSUN_v1/v2/v4
 04.05.20         * zc_ObjectFloat_BarCodeBox_Print
 29.04.20         * zc_ObjectFloat_Asset_Production
                    zc_ObjectFloat_Goods_CountReceipt
 28.04.20                                                                                      * zc_ObjectFloat_Retail_OccupancySUN
 23.04.20                                                                                      * zc_ObjectFloat_Retail_Fund, zc_ObjectFloat_Retail_FundUsed
 08.04.20                                                                                      * zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity
 05.04.20                                                                                      * zc_ObjectFloat_SeasonalityCoefficient_Koeff1..12
 31.03.20         * zc_ObjectFloat_Unit_KoeffOutSUN_v3
                    zc_ObjectFloat_Unit_KoeffInSUN_v3
                    zc_ObjectFloat_Goods_KoeffSUN_v3
 19.03.20                                                                                      * zc_ObjectFloat_Unit_MoneyBoxSunUsed
 13.03.20                                                                                      * zc_ObjectFloat_Unit_MoneyBoxSun
 11.03.20                                                                                      * zc_ObjectFloat_CommentTR_DifferenceSum
 27.01.20         * zc_ObjectFloat_PersonalServiceList_Compensation
 21.12.19                                                                                      * zc_ObjectFloat_Price_MCSValueSun
 17.12.19         * zc_ObjectFloat_Unit_SunIncome
 13.12.19                                                                                      * zc_ObjectFloat_Unit_MorionCode
 11.12.19                                                                                      * zc_ObjectFloat_Retail_LimitSUN
 10.12.19                                                                                      * zc_ObjectFloat_Unit_... for Sun
 04.12.19                                                                                      * zc_ObjectFloat_PriceChange_FixDiscount
 03.12.19                                                                                      * zc_ObjectFloat_MaxOrderAmountSecond
 19.11.19                                                                                      * zc_ObjectFloat_Juridical_CodeRazom
 29.10.19         * zc_ObjectFloat_Car_KoeffHoursWork
 28.10.19                                                                                      * zc_ObjectFloat_Unit_Latitude, zc_ObjectFloat_Unit_Longitude
 25.10.19                                                                                      * zc_ObjectFloat_Retail_ShareFromPrice
 23.10.19         * zc_ObjectFloat_Goods_CountForWeight
 16.10.19         * zc_ObjectFloat_LabReceiptChild_Value
 09.10.19         * zc_ObjectFloat_Goods_WeightTare
 26.08.19         * zc_ObjectFloat_Unit_KoeffInSUN, zc_ObjectFloat_Unit_KoeffOutSUN
 22.08.19                                                                                      * zc_ObjectFloat_PayrollType_Percent, zc_ObjectFloat_PayrollType_MinAccrualAmount
 06.08.19         * zc_ObjectFloat_JuridicalOrderFinance_SummOrderFinance
 05.08.19         * zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum
 23.07.19         * zc_ObjectFloat_Retail_SummSUN
 15.07.19                                                                                      * zc_ObjectFloat_PartionDateKind_Day
 21.06.19                                                                                      * zc_ObjectFloat_PartionGoods_PriceWithVAT
 07.06.19                                                                                      * zc_ObjectFloat_CreditLimitJuridical_CreditLimit
 05.06.19                                                                                      * zc_ObjectFloat_MaxOrderAmount
 23.04.19         * zc_ObjectFloat_RetailCostCredit_MinPrice
                    zc_ObjectFloat_RetailCostCredit_Percent
 19.04.19         * zc_ObjectFloat_PartionDateKind_Month
 10.04.19         * zc_ObjectFloat_GoodsPropertyValue_WeightOnBox
                    zc_ObjectFloat_GoodsPropertyValue_CountOnBox
 10.04.19                                                                                      * zc_ObjectFloat_Juridical_CreditLimit
 03.04.19         * zc_ObjectFloat_GoodsByGoodsKind_WmsCode
 25.03.19         * zc_ObjectFloat_Retail_MarginPercent
 13.03.19         * zc_ObjectFloat_PriceChange_Multiplicity
                    zc_ObjectFloat_GoodsByGoodsKind_NormInDays
 17.02.19         * zc_ObjectFloat_TaxUnit_Price
                    zc_ObjectFloat_TaxUnit_Value
 11.02.19         * zc_ObjectFloat_GoodsCategory_Value
 07.02.19         * zc_ObjectFloat_PriceChange_FixPercent
 29.01.19         * zc_ObjectFloat_Route_RateSummaExp
 18.01.19         * zc_ObjectFloat_Maker_Day
                    zc_ObjectFloat_Maker_Month
 13.01.19         * zc_ObjectFloat_JuridicalSettingsItem_Bonus
                    zc_ObjectFloat_JuridicalSettingsItem_PriceLimit
 21.12.18                                                                                     * zc_ObjectFloat_RecalcMCSSheduler_Week ...
 14,12,18         * zc_ObjectFloat_DocumentTaxKind_Price
 22.10.18                                                                                     * zc_ObjectFloat_RepriceUnitSheduler_ ...
 14.10.18         *zc_ObjectFloat_ReportCollation_...
 27.08.18                                                                                     * zc_ObjectFloat_Overdraft_Summa
 20.08.18         * zc_ObjectFloat_Contract_TotalSumm
 16.08.18         * zc_ObjectFloat_PriceChange_Value
                    zc_ObjectFloat_PriceChange_FixValue
                    zc_ObjectFloat_PriceChange_PercentMarkup
 09.08.18                                                                                     * zc_ObjectFloat_Maker_CashBack, zc_ObjectFloat_Bank_Overdraft
 24.06.18         * zc_ObjectFloat_Box_...
                    zc_ObjectFloat_GoodsPropertyBox_...
 22.06.18         * zc_ObjectFloat_GoodsByGoodsKind_...
 20.06.18         * zc_ObjectFloat_ReplServer_CountTo
                    zc_ObjectFloat_ReplServer_CountFrom
 18.02.18         * zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker
 05.12.17         * zc_ObjectFloat_WorkTimeKind_Tax
 02.11.17         * zc_ObjectFloat_GoodsReportSale_..........
                    zc_ObjectFloat_GoodsReportSaleInf_Week
 23.10.17         * zc_ObjectFloat_Sticker_Value1/2/3/4/5
 20.10.17         * zc_ObjectFloat_Member_ScalePSW
 08.08.17         * zc_ObjectFloat_Contract_OrderSumm
 22.06.17         * zc_ObjectFloat_GoodsProperty_TaxDoc
                    zc_ObjectFloat_GoodsPropertyValue_AmountDoc
 09.06.17         * zc_ObjectFloat_Price_MCSValueOld
 23.05.17         * zc_ObjectFloat_SPKind_Tax
 21.04.17         * add zc_ObjectFloat_Goods_CountPrice
 04.04.17         *
 30.03.17         * zc_ObjectFloat_GoodsListIncome_Amount
                    zc_ObjectFloat_GoodsListIncome_AmountChoice
 03.03.17         * zc_ObjectFloat_Contract_DayTaxSummary
 19.12.16         * zc_ObjectFloat_Goods_PriceSP
                    zc_ObjectFloat_Goods_GroupSP
 19.10.16         * zc_ObjectFloat_GoodsListSale_Amount
 23.09.16         * zc_ObjectFloat_MobileTariff_CostMinutes
 27.08.16         * zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice
                    zc_ObjectFloat_PriceGroupSettingsTOP_Percent
 19.07.16         * zc_ObjectFloat_OverSettings_MinimumLot
                  , zc_ObjectFloat_OverSettings_MinPrice
 13.07.16         * zc_ObjectFloat_Asset_PeriodUse
 13.03.16         * zc_ObjectFloat_Unit_FarmacyCash
 03.03.16         * zc_ObjectFloat_ImportSettings_Time
 27.09.15                                                                       *zc_ObjectFloat_ReportSoldParams_PlanAmount
 17.09.15         * add zc_ObjectFloat_GoodsPropertyValue_BoxCount
 16.07.15         * add zc_ObjectFloat_Juridical_DayTaxSummary
 01.04.15                                        * add zc_ObjectFloat_Quality_NumberPrint
 11.03.15         * add zc_ObjectFloat_OrderType_ ...
 05.02.15         * add zc_ObjectFloat_ContractGoods_Price
 09.10.14                                                        * add zc_ObjectFloat_Box_Volume� zc_ObjectFloat_Box_Weight
 09.09.14                      	                 * add zc_ObjectFloat_ServiceDate...
 26.07.14                      	                 * add zc_ObjectFloat_PartionGoods_Price
 21.07.14                      	                 * add zc_ObjectFloat_Contract_DocumentCount
 11.02.14                      	                 * del 10.02.14 :)
 11.02.14                      			                * add zc_ObjectFloat_Document_MovementId

 30.11.13                                        * add _StaffList_HoursDay
 30.10.13         * add zc_ObjectFloat_StaffListSumm_Value
 30.10.13         * del zc_ObjectFloat_StaffList_FundPayMonth, zc_ObjectFloat_StaffList_FundPayTurn
 19.10.13         * add zc_ObjectFloat_StaffListCost_Price, _ModelServiceItemMaster_MovementDesc, _ModelServiceItemMaster_Ratio

 19.10.13                                        * add zc_ObjectFloat_Contract_ChangePrice and zc_ObjectFloat_Contract_ChangePercent
 18.10.13         * add _StaffList_FundPayMonth, _StaffList_FundPayTurn
 17.10.13         * add _StaffList_HoursPlan, _StaffList_PersonalCount
 16.10.13                                        * add   zc_ObjectFloat_CardFuel_Limit
 29.09.13         * add   zc_ObjectFloat_PersonalGroup_WorkHours
 27.09.13         * add   zc_ObjectFloat_RateFuelKind_Tax
 24.09.13         * add  _Fuel_Ratio, _RateFuel_AmountColdHour, _RateFuel_Amount, _RateFuel_AmountColdDistance
 07.09.13                                        * add zc_ObjectFloat_PriceList_VATPercent
 15.08.13                         *  ������� ��� �� InsertUpdateObjectFloat
 29.07.13         * add zc_ObjectFloat_Partner_PrepareDayCount, zc_ObjectFloat_Partner_DocumentDayCount
 28.06.13                                        * ����� �����
*/
