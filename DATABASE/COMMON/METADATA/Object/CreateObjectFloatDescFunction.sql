--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
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
--
CREATE OR REPLACE FUNCTION zc_ObjectFloat_BarCodeBox_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_BarCodeBox(), 'zc_ObjectFloat_BarCodeBox_Weight', '������ ��� ��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_BarCodeBox_Weight');
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


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Asset_PeriodUse() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectFloat_Asset_PeriodUse', '������ ������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Asset_PeriodUse');

  
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

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Retail_ShareFromPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_ShareFromPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Retail(), 'zc_ObjectFloat_Retail_ShareFromPrice', '������ ���������� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Retail_ShareFromPrice');

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

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
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
