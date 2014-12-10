-- �������� <������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PeriodCloseAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PeriodCloseAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PeriodCloseTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PeriodCloseTax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceProduction' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceAdmin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceAdmin' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceSbit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceSbit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceMarketing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceMarketing' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceSB() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceSB' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceFirstForm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceFirstForm' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashOfficialDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashOfficialDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentBread() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentBread' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- zc_Enum_Process_AccessKey_PeriodCloseAll
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= '�������� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseAll');
 -- zc_Enum_Process_AccessKey_PeriodCloseTax
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseTax()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1002
                                   , inName:= '�������� ������ �����+������������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseTax');

 -- zc_Object_Goods, ��� ���������� �������������� ���������� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= '��������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportAll');

 -- zc_Object_Branch, �� ������� �������������� ��������� � ����������� ��� ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= '��������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDnepr');

 -- zc_Object_Branch, �� ������� �������������� ��������� � ����������� ��� ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 3
                                   , inName:= '��������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKiev');

 -- ������ ���, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 4
                                   , inName:= '��������� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKrRog');
 -- ��������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 5
                                   , inName:= '��������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportNikolaev');
 -- �������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 6
                                   , inName:= '��������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKharkov');
 -- ��������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 7
                                   , inName:= '��������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportCherkassi');
                                   
 -- ������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 8
                                   , inName:= '��������� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDoneck');
 -- ���������, ����������� � ������������ - ���������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 9
                                   , inName:= '��������� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportZaporozhye');



 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashDnepr');

 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKiev');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashZaporozhye');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashOfficialDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� �����-�� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashOfficialDnepr');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKharkov');
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= '����� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKrRog');

                                   
 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= '������ ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceDnepr');

 -- �� ������� �������������� ��������� ��� �����
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 32
                                   , inName:= '������ ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKiev');



 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= '��������� �������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentAll');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= '��������� �������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentDnepr');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentBread()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 43
                                   , inName:= '��������� �������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentBread');
                                   
 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 44
                                   , inName:= '��������� �������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKiev');

 -- �� ������� �������������� ��������� ��� �������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 45
                                   , inName:= '��������� �������� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentZaporozhye');


 -- ALL, ��� ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= '����������� ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideAll');

 -- �����, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 102
                                   , inName:= '����������� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDnepr');
 -- ����, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 103
                                   , inName:= '����������� ���� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKiev');
 -- ������ ���, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 104
                                   , inName:= '����������� ������ ��� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKrRog');
 -- ��������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 105
                                   , inName:= '����������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideNikolaev');
 -- �������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 106
                                   , inName:= '����������� ������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKharkov');
 -- ��������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 107
                                   , inName:= '����������� �������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCherkassi');

 -- ������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 108
                                   , inName:= '����������� ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDoneck');
 -- ���������, ����������� � ������������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 109
                                   , inName:= '����������� ��������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideZaporozhye');

 -- �� ������������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 201
                                   , inName:= '�� ������������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceProduction');
 -- �� �����, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 202
                                   , inName:= '�� ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceAdmin');
 -- �� ������������ �����, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 203
                                   , inName:= '�� ������������ ����� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSbit');
 -- �� ����� ����������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 204
                                   , inName:= '�� ����� ���������� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceMarketing');
 -- �� ��, ������, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSB()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 205
                                   , inName:= '�� ��, ������ (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSB');
 -- �� �������� ��, ����������� � ������������ + ����������
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 206
                                   , inName:= '�� �������� �� (������ ���������)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceFirstForm');


/*
 -- ������� ���� 
 PERFORM gpInsertUpdate_Object_RoleProcess2 (ioId        := tmpData.RoleRightId
                                           , inRoleId    := tmpRole.RoleId
                                           , inProcessId := tmpProcess.ProcessId
                                           , inSession   := zfCalc_UserAdmin())
 -- AccessKey  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Right_Branch_Dnepr() AS ProcessId
           ) AS tmpProcess ON 1=1
      -- ������� ��� ������������ �����
      LEFT JOIN (SELECT ObjectLink_RoleRight_Role.ObjectId         AS RoleRightId
                      , ObjectLink_RoleRight_Role.ChildObjectId    AS RoleId
                      , ObjectLink_RoleRight_Process.ChildObjectId AS ProcessId
                 FROM ObjectLink AS ObjectLink_RoleRight_Role
                      JOIN ObjectLink AS ObjectLink_RoleRight_Process ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                                                     AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                 WHERE ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                ) AS tmpData ON tmpData.RoleId    = tmpRole.RoleId
                            AND tmpData.ProcessId = tmpProcess.ProcessId
 WHERE tmpData.RoleId IS NULL
 ;
*/
 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.11.14                                        * add zc_Enum_Process_AccessKey_DocumentAll
 23.09.14                                        * add zc_Enum_Process_AccessKey_PeriodClose...
 17.09.14                                        * add zc_Enum_Process_AccessKey_PersonalServiceFirstForm
 10.09.14                                        * add zc_Enum_Process_AccessKey_PersonalService...
 08.09.14                                        * add zc_Enum_Process_AccessKey_Guide...
 07.04.14                                        * add zc_Enum_Process_AccessKey_DocumentBread
 10.02.14                                        * add zc_Enum_Process_AccessKey_Document...
 28.12.13                                        * add zc_Enum_Process_AccessKey_Service...
 26.12.13                                        * add zc_Enum_Process_AccessKey_Cash...
 14.12.13                                        * add zc_Enum_Process_AccessKey_GuideAll
 07.12.13                                        *
*/

/*
-- !!!update AccessKeyId!!!
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKiev() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 14686  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKiev();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKharkov() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279790  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKharkov();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKrRog() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279788  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKrRog();
*/