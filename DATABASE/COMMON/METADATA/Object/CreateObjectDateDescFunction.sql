--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_StartTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_StartTo', '����/����� ������ �������� � ����-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartTo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_EndTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_EndTo', '����/����� ���������� �������� � ����-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndTo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_StartFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_StartFrom', '����/����� ������ ��������� �� ����-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartFrom');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_EndFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_EndFrom', '����/����� ���������� ��������� �� ����-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndFrom');

--
CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_In', '���� �������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Out', '���� ���������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Send', '���� �������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Send');


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

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_End_Parent_old() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End_Parent_old'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectDate_Receipt_End_Parent_old', '���� �� (�������)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End_Parent_old');



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

CREATE OR REPLACE FUNCTION zc_ObjectDate_Juridical_VatPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_VatPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectDate_Juridical_VatPrice', '� ����� ���� ����� ������� ���� � ��� (���������)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_VatPrice');

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

--
CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Birthday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Birthday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Birthday', '�������, ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Birthday');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children1', '������� 1, ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children1');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children2', '������� 2, ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children2');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children3', '������� 3, ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children3');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children4', '������� 4, ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children4');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children5', '������� 5, ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children5');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_PSP_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_PSP_Start', '�������, ���� �������� �' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_PSP_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_PSP_End', '�������, ���� �������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Dekret_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Dekret_Start', '������ c' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Dekret_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Dekret_End', '������ ��' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_End');

--
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

CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsReportSaleInf_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsReportSaleInf(), 'zc_ObjectDate_GoodsReportSaleInf_Start', '��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsReportSaleInf_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsReportSaleInf(), 'zc_ObjectDate_GoodsReportSaleInf_End', '�������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_ReCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_ReCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Protocol_ReCalc', '����/����� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_ReCalc');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_In', '���� ������� �� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_UKTZED_new', '���� � ������� ��������� ����� ��� ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UKTZED_new');

CREATE OR REPLACE FUNCTION zc_Object_ReportBonus_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_Object_ReportBonus_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportBonus(), 'zc_Object_ReportBonus_Month', '����� ���������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_Object_ReportBonus_Month');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractGoods_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractGoods(), 'zc_ObjectDate_ContractGoods_Start', '���� �������� ���� � ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractGoods_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractGoods(), 'zc_ObjectDate_ContractGoods_End', '���� �������� ���� �� ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractPriceList_StartDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_StartDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractPriceList(), 'zc_ObjectDate_ContractPriceList_StartDate', '���� �������� c ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_StartDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractPriceList_EndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_EndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractPriceList(), 'zc_ObjectDate_ContractPriceList_EndDate', '���� �������� �� ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_EndDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_JuridicalDefermentPayment_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalDefermentPayment(), 'zc_ObjectDate_JuridicalDefermentPayment_OperDate', '���� ��������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_JuridicalDefermentPayment_OperDateIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDateIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalDefermentPayment(), 'zc_ObjectDate_JuridicalDefermentPayment_OperDateIn', '���� ���������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDateIn');


CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsGroup_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsGroup_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsGroup(), 'zc_ObjectDate_GoodsGroup_UKTZED_new', '���� � ������� ��������� ����� ��� ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsGroup_UKTZED_new');

 
 CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsByGoodsKind_End_old() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_End_old'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectDate_GoodsByGoodsKind_End_old', '���� �� (�������)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_End_old');
 
 CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsByGoodsKind_GoodsSub() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_GoodsSub'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectDate_GoodsByGoodsKind_GoodsSub', '����, � ������� ����������� �������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_GoodsSub');


 

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
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_StartDateMCSAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_StartDateMCSAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_StartDateMCSAuto', '���� � ������� ��������� ������������ ����������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_StartDateMCSAuto');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_EndDateMCSAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_EndDateMCSAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_EndDateMCSAuto', '���� ��������� �������� ������������� ����������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_EndDateMCSAuto');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_CheckPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_CheckPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_CheckPrice', '����/����� ����� �������� �� ����� - � ���������� ������� ��������� ��� (��/���)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_CheckPrice');




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

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_Create() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Create'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_Create', '���� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Create');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_Close() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Close'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_Close', '���� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Close');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_TaxUnitStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_TaxUnitStart', '����� ������ ������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_TaxUnitEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_TaxUnitEnd', '����� ���������� ������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SP', '���� ������ ������ �� ���.��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_StartSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_StartSP', '����� ������ ������ �� ���.�������� ' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartSP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_EndSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_EndSP', '����� ���������� ������ �� ���.��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndSP');


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

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_LastPriceOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPriceOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_LastPriceOld', '���� ������. ���� ������� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPriceOld');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_PairSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_PairSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_PairSun', '���� � ������� �����. � ����������� ��� ���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_PairSun');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_BUH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_BUH', '���� �� ������� ��������� �������� ������(����.)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_BUH');


CREATE OR REPLACE FUNCTION zc_ObjectDate_User_UpdateMobileFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_UpdateMobileFrom', '����/����� �������� ������������� � ���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileFrom');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_UpdateMobileTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_UpdateMobileTo', '����/����� �������� ������������� �� ��������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileTo');


CREATE OR REPLACE FUNCTION zc_ObjectDate_User_FarmacyCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_FarmacyCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_FarmacyCash', '����/����� ����� � ��������� ��� ������� � ������� �������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_FarmacyCash');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_In', '���� �������� �� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_GUID', '����/����� ��������� ������������� UUID-������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_GUID');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_SMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_SMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_SMS', '����/����� �������� SMS ��� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_SMS');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MemberSP_HappyDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MemberSP_HappyDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MemberSP(), 'zc_ObjectDate_MemberSP_HappyDate', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MemberSP_HappyDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceChange_DateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceChange_DateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectDate_PriceChange_DateChange', '����, ����� ��������� ���� ��� % �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceChange_DateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_RepriceUnitSheduler_DataStartLast() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_RepriceUnitSheduler_DataStartLast'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectDate_RepriceUnitSheduler_DataStartLast', '����� ��������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_RepriceUnitSheduler_DataStartLast');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays', '���� ������ ����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_EndHolidays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_EndHolidays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_EndHolidays', '��������� ���� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_EndHolidays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_DateRun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_DateRun', '���� ���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRun');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_DateRunSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRunSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_DateRunSun', '���� ���������� ��������� �� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRunSun');


CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_SendPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_SendPlan', '����� ��������� ���������(����/�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendPlan');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_SendReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_SendReal', '����� ������� ������ �������� (����/�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendReal');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CashRegister_TimePUSHFinal1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashRegister(), 'zc_ObjectDate_CashRegister_TimePUSHFinal1', '����� ������� PUSH ��������� � ���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal1');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CashRegister_TimePUSHFinal2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashRegister(), 'zc_ObjectDate_CashRegister_TimePUSHFinal2', '����� ������� PUSH ��������� � ���������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal2');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Route_StartRunPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_StartRunPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectDate_Route_StartRunPlan', '����� ������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_StartRunPlan');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Route_EndRunPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_EndRunPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectDate_Route_EndRunPlan', '����� ����������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_EndRunPlan');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PartionGoods_Cat_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Cat_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectDate_PartionGoods_Cat_5', '���� �������� � 5 ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Cat_5');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_MondayStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_MondayStart', '���. -  ����. ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_MondayEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_MondayEnd', '���. -  ����. ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SaturdayStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SaturdayStart', '������� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SaturdayEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SaturdayEnd', '������� ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SundayStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SundayStart', '����������� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SundayEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SundayEnd', '����������� ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PlanIventory_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PlanIventory(), 'zc_ObjectDate_PlanIventory_OperDate', '���� ��������������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PlanIventory_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PlanIventory(), 'zc_ObjectDate_PlanIventory_DateEnd', '���� ��������������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PlanIventory_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PlanIventory(), 'zc_ObjectDate_PlanIventory_DateStart', '���� ��������������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Buyer_DateBirth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Buyer_DateBirth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Buyer(), 'zc_ObjectDate_Buyer_DateBirth', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Buyer_DateBirth');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractCondition_StartDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_StartDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractCondition(), 'zc_ObjectDate_ContractCondition_StartDate', '�������� �' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_StartDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractCondition_EndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_EndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractCondition(), 'zc_ObjectDate_ContractCondition_EndDate', '�������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_EndDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CashSettings_DateBanSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashSettings_DateBanSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectDate_CashSettings_DateBanSUN', '���� ������� ������ �� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashSettings_DateBanSUN');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_PUSH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_PUSH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_PUSH', '���� ���������� ��������� PUSH � �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_PUSH');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_FirstCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FirstCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_FirstCheck', '������ ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FirstCheck');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Hardware_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Hardware_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Hardware(), 'zc_ObjectDate_Hardware_Update', '���� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Hardware_Update');

CREATE OR REPLACE FUNCTION zc_ObjectDate_FinalSUAProtocol_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectDate_FinalSUAProtocol_OperDate', '���� � ����� ������������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_FinalSUAProtocol_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Hardware_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectDate_FinalSUAProtocol_DateStart', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_FinalSUAProtocol_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectDate_FinalSUAProtocol_DateEnd', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_AutoSUA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_AutoSUA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_AutoSUA', '���� ��������������� ������� �� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_AutoSUA');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_DateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_DateChange', '���� ��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DateChange');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_FixDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_FixDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_FixDateChange', '���� ��������� ������������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_FixDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_PercentMarkupDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_PercentMarkupDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_PercentMarkupDateChange', '���� ��������� % �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_PercentMarkupDateChange');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_CorrectMinAmount_Date() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectMinAmount_Date'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectMinAmount(), 'zc_ObjectDate_CorrectMinAmount_Date', '���� ������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectMinAmount_Date');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_CheckoutTesting_DateUpdate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CheckoutTesting_DateUpdate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CheckoutTesting(), 'zc_ObjectDate_CheckoutTesting_DateUpdate', '���� � ����� ���������� �� ����� � �������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CheckoutTesting_DateUpdate');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_ZReportLog_Date() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ZReportLog_Date'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ZReportLog(), 'zc_ObjectDate_ZReportLog_Date', '���� Z ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ZReportLog_Date');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_StartDateUnPlanned() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_StartDateUnPlanned'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_StartDateUnPlanned', '���� ������ ��� ������������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_StartDateUnPlanned');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_EndDateUnPlanned() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_EndDateUnPlanned'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_EndDateUnPlanned', '���� ��������� ��� ������������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_EndDateUnPlanned');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_UpdateMinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateMinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_UpdateMinimumLot', '���� (����. ���. ������)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateMinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_UpdateisPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateisPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_UpdateisPromo', '���� (����. �����)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateisPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CorrectWagesPercentage_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectWagesPercentage(), 'zc_ObjectDate_CorrectWagesPercentage_DateStart', '���� ������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CorrectWagesPercentage_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectWagesPercentage(), 'zc_ObjectDate_CorrectWagesPercentage_DateEnd', '���� ��������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_Exam() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Exam'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_Exam', '����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Exam');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SurchargeWages_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SurchargeWages(), 'zc_ObjectDate_SurchargeWages_DateStart', '���� ������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SurchargeWages_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SurchargeWages(), 'zc_ObjectDate_SurchargeWages_DateEnd', '���� ��������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PickUpLogsAndDBF_DateLoaded() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PickUpLogsAndDBF_DateLoaded'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PickUpLogsAndDBF(), 'zc_ObjectDate_PickUpLogsAndDBF_DateLoaded', '���� � ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PickUpLogsAndDBF_DateLoaded');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ConditionsKeep_ColdSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ConditionsKeep_ColdSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ConditionsKeep(), 'zc_ObjectDate_ConditionsKeep_ColdSUN', '����� ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ConditionsKeep_ColdSUN');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_DiscontSiteStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_DiscontSiteStart', '���� ������ ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_DiscontSiteEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_DiscontSiteEnd', '���� ��������� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_DiscontStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_DiscontStart', '���� ������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_DiscontEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_DiscontEnd', '���� ��������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ExchangeRates_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ExchangeRates_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ExchangeRates(), 'zc_ObjectDate_ExchangeRates_OperDate', '���� ������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ExchangeRates_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_KeyExpireDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_KeyExpireDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_KeyExpireDate', '���� ��������� ����� �������� ��������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_KeyExpireDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MCRequest_DateUpdate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateUpdate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequest(), 'zc_ObjectDate_MCRequest_DateUpdate', '���� ���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateUpdate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MCRequest_DateDone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateDone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequest(), 'zc_ObjectDate_MCRequest_DateDone', '���� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateDone');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SetDateRRO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SetDateRRO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SetDateRRO', '���� ��������� ������� �� ���' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SetDateRRO');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_PersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_PersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_PersonalService', '����/����� ����� �������������� ���������� �� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_PersonalService');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_User_InternshipConfirmation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_PersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_InternshipConfirmation', '���� ������������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_InternshipConfirmation');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_User_InternshipCompleted() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_InternshipCompleted'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_InternshipCompleted', '���� �������� ���������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_InternshipCompleted');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_PartionDateWages_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionDateWages_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateWages(), 'zc_ObjectDate_PartionDateWages_DateStart', '���� ������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionDateWages_DateStart');


/*-------------------------------------------------------------------------------
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 09.11.23         * zc_ObjectDate_Goods_UKTZED_new
 19.04.23         * zc_ObjectDate_Personal_Send
 29.03.23         * zc_ObjectDate_GoodsGroup_UKTZED_new
 18.01.23                                                                                     * zc_ObjectDate_PartionDateWages_DateStart
 26.09.22                                                                                     * zc_ObjectDate_User_InternshipConfirmation, zc_ObjectDate_User_InternshipCompleted
 06.09.22         * zc_ObjectDate_Unit_PersonalService
 05.09.22                                                                                     * zc_ObjectDate_Unit_SetDateRRO
 01.09.22         * zc_ObjectDate_JuridicalDefermentPayment_OperDateIn
 20.05.22                                                                                     * zc_ObjectDate_MCRequest_DateUpdate, zc_ObjectDate_MCRequest_DateDone
 17.03.22                                                                                     * zc_ObjectDate_User_KeyExpireDate
 24.02.22                                                                                     * zc_ObjectDate_ExchangeRates_OperDate
 15.02.22                                                                                     * zc_ObjectDate_PriceSite_DiscontStart, zc_ObjectDate_PriceSite_DiscontEnd
 15.02.22                                                                                     * zc_ObjectDate_Goods_DiscontSiteStart, zc_ObjectDate_Goods_DiscontSiteEnd
 20.01.22                                                                                     * zc_ObjectDate_PickUpLogsAndDBF_DateLoaded
 25.11.21                                                                                     * zc_ObjectDate_SurchargeWages_...
 07.10.21                                                                                     * zc_ObjectDate_Unit_Exam
 24.09.21                                                                                     * zc_ObjectDate_CorrectWagesPercentage_Date... 
 15.09.21                                                                                     * zc_ObjectDate_Goods_Update... 
 09.09.21                                                                                     * zc_ObjectDate_Maker_StartDateUnPlanned, zc_ObjectDate_Maker_EndDateUnPlanned
 30.07.21                                                                                     * zc_ObjectDate_ZReportLog_Date
 25.06.21                                                                                     * zc_ObjectDate_CheckoutTesting_DateUpdate
 22.06.21                                                                                     * zc_ObjectDate_CorrectMinAmount_Date
 27.04.21                                                                                     * zc_ObjectDate_PriceSite_...
 27.05.21         * zc_ObjectDate_ContractPriceList_StartDate
                    zc_ObjectDate_ContractPriceList_EndDate
 19.05.21                                                                                     * zc_ObjectDate_Unit_AutoSUA
 13.05.21         * zc_ObjectDate_User_GUID
 24.03.21                                                                                     * zc_ObjectDate_FinalSUAProtocol_...
 04.02.21                                                                                     * zc_ObjectDate_Hardware_Update
 06.11.20         * zc_ObjectDate_ContractGoods_Start
                    zc_ObjectDate_ContractGoods_End
 30.09.20                                                                                     * zc_ObjectDate_Unit_FirstCheck
 25.09.20         * zc_Object_ReportBonus_Month
 04.06.20                                                                                     * zc_ObjectDate_User_PUSH
 07.05.20                                                                                     * zc_ObjectDate_Buyer_DateBirth
 06.05.20         * zc_ObjectDate_Juridical_VatPrice
 24.03.20         * zc_ObjectDate_ContractCondition_StartDate
                    zc_ObjectDate_ContractCondition_EndDate
 10.02.20                                                                                     * zc_ObjectDate_Buyer_DateBirth
 29.01.20         * zc_ObjectDate_PlanIventory_DateEnd
                    zc_ObjectDate_PlanIventory_DateStart
                    zc_ObjectDate_PlanIventory_OperDate
 10.12.19                                                                                     * zc_ObjectFloat_RecalcMCSSheduler_DateRunSun 
 28.10.19                                                                                     * ������ ������
 14.08.19                                                                                     * zc_ObjectDate_PartionGoods_Cat_5
 06.04.19         * zc_ObjectDate_Route_StartRunPlan
                    zc_ObjectDate_Route_EndRunPlan
 20.03.19         * zc_ObjectDate_Unit_SP
                    zc_ObjectDate_Unit_StartSP
                    zc_ObjectDate_Unit_EndSP
 04.03.19                                                                                     * zc_ObjectFloat_CashRegister_TimePUSHFinal ...
 15.02.19         * zc_ObjectDate_Unit_TaxUnitStart
                    zc_ObjectDate_Unit_TaxUnitEnd
 12.02.19                                                                                     * zc_ObjectFloat_RecalcMCSSheduler_DateRun
 11.01.19         * zc_ObjectDate_Maker_SendPlan
                    zc_ObjectDate_Maker_SendReal
 25.12.18                                                                                     * zzc_ObjectFloat_RecalcMCSSheduler_
 22.10.18                                                                                     * zc_ObjectDate_RepriceUnitSheduler_DataStartLast 
 18.10.18         * zc_ObjectDate_Goods_In
 16,10,18         * zc_ObjectDate_Protocol_ReCalc
 16.08.18         * zc_ObjectDate_PriceChange_DateChange
 20.06.18         * zc_ObjectDate_ReplServer_...
 14.05.18                                                                                     * zc_ObjectFloat_Unit_NormOfManDays, zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan
                                                                                                zc_ObjectFloat_UnitCategory_PremiumImplPlan, zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan 
 18.01.18         * zc_ObjectDate_MemberSP_HappyDate
 02.11.17         * zc_ObjectDate_GoodsReportSaleInf_Start
                    zc_ObjectDate_GoodsReportSaleInf_End
 15.09.17         * zc_ObjectDate_Unit_Create
                    zc_ObjectDate_Unit_Close
 16.08.17         * zc_ObjectDate_Goods_LastPriceOld
 09.06.17         * zc_ObjectDate_Price_StartDateMCSAuto
                    zc_ObjectDate_Price_EndDateMCSAuto
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
