--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_In', '���� �������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Out', '���� ���������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PartionGoods_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectDate_PartionGoods_Value', '���� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Value');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReceiptChild_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_ReceiptChild_Start', '��������� ���� ������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReceiptChild_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_ReceiptChild_End', '�������� ���� ������������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectDate_Receipt_Start', '��������� ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_Receipt_End', '�������� ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End');


CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_Signing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Signing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_Signing', '���� ���������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Signing');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_Start', '���� � ������� ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Start');
CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_End', '���� �� ������� ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_End');
CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_Document() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Document'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_Document', '���� ���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Document');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Calendar_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Calendar_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Calendar_Value', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GlobalConst_ActualBankStatement');

CREATE OR REPLACE FUNCTION zc_ObjectDate_GlobalConst_ActualBankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GlobalConst_ActualBankStatement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GlobalConst(), 'zc_ObjectDate_GlobalConst_ActualBankStatement', '���� ������������ ���������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GlobalConst_ActualBankStatement');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Partner_StartPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_StartPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectDate_Partner_StartPromo', '���� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_StartPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Partner_EndPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_EndPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectDate_Partner_EndPromo', '���� ��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_EndPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Juridical_StartPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_StartPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectDate_Juridical_StartPromo', '���� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_StartPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Juridical_EndPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_EndPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectDate_Juridical_EndPromo', '���� ��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_EndPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Asset_Release() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Asset_Release'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectDate_Asset_Release', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Asset_Release');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Protocol_Insert', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Protocol_Update', '���� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update');

CREATE OR REPLACE FUNCTION zc_ObjectDate_InvNumberTax_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_InvNumberTax_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_InvNumberTax(), 'zc_ObjectDate_InvNumberTax_Value', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_InvNumberTax_Value');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ServiceDate_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ServiceDate_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ServiceDate(), 'zc_ObjectDate_ServiceDate_Value', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ServiceDate_Value');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_StartPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_StartPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_StartPromo', '���� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_StartPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_EndPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_EndPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_EndPromo', '���� ��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_EndPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MedocLoadInfo_Period() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_Period'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MedocLoadInfo(), 'zc_ObjectDate_MedocLoadInfo_Period', '������ �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_Period');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MedocLoadInfo_LoadDateTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_LoadDateTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MedocLoadInfo(), 'zc_ObjectDate_MedocLoadInfo_LoadDateTime', '���� �������� ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_LoadDateTime');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_StartSummer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_StartSummer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_StartSummer', '��������� ���� ��� ����� ���� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_StartSummer');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_EndSummer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_EndSummer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_EndSummer', '�������� ���� ��� ����� ���� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_EndSummer');


CREATE OR REPLACE FUNCTION zc_ObjectDate_ImportSettings_StartTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_StartTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectDate_ImportSettings_StartTime', '����� ������ �������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_StartTime');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ImportSettings_EndTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_EndTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectDate_ImportSettings_EndTime', '����� ��������� �������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_EndTime');

--
CREATE OR REPLACE FUNCTION zc_ObjectDate_SheetWorkTime_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SheetWorkTime(), 'zc_ObjectDate_SheetWorkTime_Start', '����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SheetWorkTime_Work() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Work'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SheetWorkTime(), 'zc_ObjectDate_SheetWorkTime_Work', '���������� ������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Work');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SheetWorkTime_DayOffPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_DayOffPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SheetWorkTime(), 'zc_ObjectDate_SheetWorkTime_DayOffPeriod', '������� � ������ ����� ������ �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_DayOffPeriod');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_Start', '���. ���� ������� ���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_End', '���. ���� ������� ���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_Insert', '���� �������� ���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_Buh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Buh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_Buh', '���� (����� � �����������)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Buh');

CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsListIncome_Last() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsListIncome_Last'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectDate_GoodsListIncome_Last', '��������� ���� ���.' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsListIncome_Last');


--!!!FARMACY

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_DateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_DateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_DateChange', '���� ��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_DateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_MCSDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_MCSDateChange', '���� ��������� ������������ ��������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_MCSIsCloseDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSIsCloseDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_MCSIsCloseDateChange', '���� ��������� �������� "����� ���"' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSIsCloseDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_MCSNotRecalcDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSNotRecalcDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_MCSNotRecalcDateChange', '���� ��������� �������� "������������ ����"' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSNotRecalcDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_FixDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_FixDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_FixDateChange', '���� ��������� �������� "������������� ����"' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_FixDateChange');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportSoldParams_PlanDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportSoldParams_PlanDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportSoldParams(), 'zc_ObjectDate_ReportSoldParams_PlanDate', '����� ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportSoldParams_PlanDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportPromoParams_PlanDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportPromoParams_PlanDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportPromoParams(), 'zc_ObjectDate_ReportPromoParams_PlanDate', '����� ����� �� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportPromoParams_PlanDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_StartServiceNigth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartServiceNigth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_StartServiceNigth', '����� ������ ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartServiceNigth');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_EndServiceNigth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndServiceNigth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_EndServiceNigth', '����� ���������� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndServiceNigth');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_FarmacyCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FarmacyCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_FarmacyCash', '����/����� ���������� ������ � FarmacyCash' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FarmacyCash');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_TOPDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_TOPDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_TOPDateChange', '���� ��������� ���-�������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_TOPDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_PercentMarkupDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_PercentMarkupDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_PercentMarkupDateChange', '���� ��������� % �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_PercentMarkupDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_ReestrSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_ReestrSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_ReestrSP', '���� ��������� ������ 䳿 ������������� ���������� �� ��������� ����(���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_ReestrSP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_InsertSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_InsertSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Protocol_InsertSP', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_InsertSP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_LastPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_LastPrice', '���� �������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPrice');

/*-------------------------------------------------------------------------------
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 14.04.17         * zc_ObjectDate_GoodsListIncome_Last
 04.04.17         * zc_ObjectDate_Goods_ReestrSP
 13.06.16         * add zc_ObjectDate_Unit_FarmacyCash
 03.03.16         *
 14.01.16         * add zc_ObjectDate_Member_StartSummer, zc_ObjectDate_Member_EndSummer
 22.12.15                                                                       *zc_ObjectDate_Price_MCSIsCloseDateChange,zc_ObjectDate_Price_MCSNotRecalcDateChange,zc_ObjectDate_Price_FixDateChange
 27.09.15                                                                       *zc_ObjectDate_ReportSoldParams_PlanDate
 12.02.15         * add zc_ObjectDate_Contract_StartPromo
                        zc_ObjectDate_Contract_EndPromo
 04.09.14                                                        *
 21.07.14                      	                 * add zc_ObjectDate_Contract_Document
 01.05.14                      	                 * add zc_ObjectDate_InvNumberTax_Value
 25.02.14                                        * add zc_ObjectDate_Protocol_...
 12.01.14          * add zc_ObjectDate_Partner_StartPromo, zc_ObjectDate_Partner_EndPromo
                         zc_ObjectDate_Juridical_EndPromo, zc_ObjectDate_Juridical_EndPromo
 25.09.13          * del Car_StartDateRate, Car_EndDateRate
 19.07.13          * rename zc_ObjectDate_
 01.07.13          *
*/
