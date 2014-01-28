--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectFloat_Goods_Weight', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsPropertyValue(), 'zc_ObjectFloat_GoodsPropertyValue_Amount', '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionMovement_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovement_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_object_PartionMovement(), 'zc_ObjectFloat_PartionMovement_MovementId', '���� ��������� ������ �� ��������� � ������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovement_MovementId');  

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

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionValue', '���������� � ������ (���������� � ������)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionCount', '����������� ���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_WeightPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_WeightPackage', '��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_PrepareDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_PrepareDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_PrepareDayCount', '�� ������� ���� ����������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_PrepareDayCount');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Partner_DocumentDayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DocumentDayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectFloat_Partner_DocumentDayCount', '����� ������� ���� ����������� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Partner_DocumentDayCount');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PriceList_VATPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceList_VATPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceList(), 'zc_ObjectFloat_PriceList_VATPercent', '% ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PriceList_VATPercent');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Fuel_Ratio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Fuel(), 'zc_ObjectFloat_Fuel_Ratio', '����������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Fuel_Ratio');  

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

CREATE OR REPLACE FUNCTION zc_ObjectFloat_PersonalGroup_WorkHours() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalGroup_WorkHours'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalGroup(), 'zc_ObjectFloat_PersonalGroup_WorkHours', '���������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PersonalGroup_WorkHours'); 

CREATE OR REPLACE FUNCTION zc_ObjectFloat_CardFuel_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_PersonalGroup(), 'zc_ObjectFloat_CardFuel_Limit', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_CardFuel_Limit'); 

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_HoursPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_HoursPlan', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursPlan'); 

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_HoursDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_HoursDay', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_HoursDay'); 

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffList_PersonalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_PersonalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_StaffList(), 'zc_ObjectFloat_StaffList_PersonalCount', '���. �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffList_PersonalCount'); 

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_ChangePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_ChangePrice', zc_Object_Contract(), '������ � ����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePrice');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Contract_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Contract_ChangePercent', zc_Object_Contract(), '(-)% ������ (+)% �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Contract_ChangePercent');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ContractCondition_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ContractCondition_Value', zc_Object_ContractCondition(), '������� �������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ContractCondition_Value');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffListCost_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListCost_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StaffListCost_Price', zc_Object_StaffListCost(), '�������� ���./��.' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListCost_Price');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ModelServiceItemMaster_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc', zc_Object_ModelServiceItemMaster(), '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ModelServiceItemMaster_Ratio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_Ratio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ModelServiceItemMaster_Ratio', zc_Object_ModelServiceItemMaster(), '����������� ��� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ModelServiceItemMaster_Ratio');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MajorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MajorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MinorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MinorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_StaffListSumm_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListSumm_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_StaffListSumm_Value', zc_Object_StaffListSumm(), '�����, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_StaffListSumm_Value');


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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
