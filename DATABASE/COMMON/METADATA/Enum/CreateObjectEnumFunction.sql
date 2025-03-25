-- !!!                     
-- !!! ����
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_Role_Admin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Admin' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_Transport() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Transport' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_Bread() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Bread' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_1107() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_1107' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Role_CashReplace() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_CashReplace' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� �������� ��� ��������
-- !!!

-- ���-��, ����������, � ���������� 
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleCount_10400()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleCount_10400' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ���-��, ����������, ������ �� ���
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleCount_10500() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleCount_10500' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ���-��, ����������, ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleCount_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleCount_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ����� �/�, ����������, � ����������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10400()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10400' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ����� �/�, ����������, ������ �� ���
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10500() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10500' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ����� �/�, ����������, ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �����, ����������, � ����������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10100()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10100' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �����, ����������, ������� � �������� ������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �����, ����������, ������ �����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10250() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10250' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �����, ����������, ������ ��������������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SaleSumm_10300() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SaleSumm_10300' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ���-��, �������, �� ����������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInCount_10800() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInCount_10800' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ���-��, �������, ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInCount_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInCount_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ����� �/�, �������, �� ����������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInSumm_10800() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInSumm_10800' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ����� �/�, �������, ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInSumm_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInSumm_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �����, �������, �� ����������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInSumm_10700() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInSumm_10700' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �����, �������, ������� � �������� ������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInSumm_10200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInSumm_10200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �����, �������, ������ ��������������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReturnInSumm_10300() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReturnInSumm_10300' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- ���-��, ���������� ��������� ��� ����������/����������� �� ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_LossCount_10900() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_LossCount_10900' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ����� �/�, ���������� ��������� ��� ����������/����������� �� ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_LossSumm_10900() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_LossSumm_10900' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ���-��, �������� ��� ����������/����������� �� ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_LossCount_20200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_LossCount_20200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ����� �/�, �������� ��� ����������/����������� �� ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_LossSumm_20200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_LossSumm_20200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- ������� ���������� - �����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Cash_PersonalAvance() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Cash_PersonalAvance' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ������� ���������� - �� ���������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Cash_PersonalService() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Cash_PersonalService' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ������� ���������� - �� ��������� ����� �� 2�.
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Cash_PersonalCardSecond() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Cash_PersonalCardSecond' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--
-- �� ��� ��������� � ����, ����� �������� � �������� 
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ProfitLoss() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ProfitLoss' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--
-- � ������� ���� �������������� ��� �������� �������� �� ������������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Income_Packer() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Income_Packer' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--
-- � �������� ����� ������� �� ������������ ���� � ������� "�����������" 
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_ReWork() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_ReWork' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--
-- ���-��, ������ �� ����. + ������� ����., ������� � ����, ���� ������� ��� ������� �� �������� � ������ ������ 40200... 
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Count_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Count_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �����, �� ������ ������������ ����, ������ �������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SummIn_110101()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SummIn_110101' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �����, �� ������ ������������ ����, ������ �������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SummOut_110101() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SummOut_110101' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �����, �� ������ ������������ ����, ������ ����. ���. ��������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SummIn_80401()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SummIn_80401' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �����, �� ������ ������������ ����, ������ ����. ���. ��������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SummOut_80401() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SummOut_80401' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ���-��, ����������� �� ���� or �����������, ������ 
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SendCount_in()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SendCount_in' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ���-��, ����������� �� ���� or �����������, ������ �� ���
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SendCount_10500() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SendCount_10500' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ���-��, ����������� �� ���� or �����������, ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SendCount_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SendCount_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ����� �/�, ����������� �� ���� or �����������, ������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SendSumm_in()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SendSumm_in' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ����� �/�, ����������� �� ���� or �����������, ������ �� ���
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SendSumm_10500() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SendSumm_10500' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ����� �/�, ����������� �� ���� or �����������, ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_SendSumm_40200() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_SendSumm_40200' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �� ������� ���� - ����� ���������������
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Transport_Add()     RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Transport_Add'     AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �� ������� ���� - ����� ������������ (���� ���������������)
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Transport_AddLong() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Transport_AddLong' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �� ������� ���� - ����� �� �����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_Transport_Taxi()    RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_Transport_Taxi'    AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �� ���������� �������� - ����� ������ - ��������� � ��
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_PersonalService_Nalog() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_PersonalService_Nalog' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �� ���������� �������� - ����� ������ - ���������� � ��
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_PersonalService_NalogRet() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_PersonalService_NalogRet' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- �� ���������� �������� - <����� �� (����������) - 2�>
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_PersonalService_SummDiff() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_PersonalService_SummDiff' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--  �� ������� �� ��������� ����� - ����� ��������� ����� - ��������� � �� 
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_MobileBills_Personal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_MobileBills_Personal' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ���-��, ���������� ����
CREATE OR REPLACE FUNCTION zc_Enum_AnalyzerId_TareReturning()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AnalyzerId_TareReturning' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� �����
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_FirstForm()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_FirstForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_SecondForm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_SecondForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_FirstForm_pav()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_FirstForm_pav' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� �������� ���������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_CashRegisterKind_FP3141()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CashRegisterKind_FP3141' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���������� ���������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_BankAccountDate()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_BankAccountDate' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_IntegerDate() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_IntegerDate' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_CashDate()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_CashDate' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_MedocTaxDate() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_MedocTaxDate' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_PeriodClosePlan()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_PeriodClosePlan' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_EndDateOlapSR()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_EndDateOlapSR' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ProtocolDateOlapSR()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ProtocolDateOlapSR' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_StartDate_Auto_PrimeCost()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_StartDate_Auto_PrimeCost' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_StartTime0_Auto_PrimeCost()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_StartTime0_Auto_PrimeCost' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_StartTime1_Auto_PrimeCost()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_StartTime1_Auto_PrimeCost' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_StartTime2_Auto_PrimeCost()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_StartTime2_Auto_PrimeCost' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_StartTime3_Auto_PrimeCost()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_StartTime3_Auto_PrimeCost' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_Currency_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Currency_Basis' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ���� ���
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_NDSKind_Common()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_NDSKind_Common' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_NDSKind_Medical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_NDSKind_Medical' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� �������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_Excel()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_Excel' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_DBF() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_DBF' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_MMO() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_MMO' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_ODBC() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_ODBC' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_Excel_OLE() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_Excel_OLE' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_CSV_OLE() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_CSV_OLE' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_FileTypeKind_CSV_OLE_UTF8() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_FileTypeKind_CSV_OLE_UTF8' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UnitJuridical()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UnitJuridical' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UnitUnitId()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UnitUnitId' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_DefaultFileName()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_DefaultFileName' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UnitEmailSign()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UnitEmailSign' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_ClientEmailSubject()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_ClientEmailSubject' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_OldClientLink()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_OldClientLink' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_UploadCompliance()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_UploadCompliance' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportExportLinkType_QlikView()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportExportLinkType_QlikView' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ������� ����������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (1); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (2); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StatusCode_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (3); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_UnComplete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Erased' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ������� ���������� EDI
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_ORDERS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_ORDERS' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_DESADV() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_DESADV' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_COMDOC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_COMDOC' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_DECLAR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_DECLAR' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EDIStatus_INVOICE_NP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EDIStatus_INVOICE_NP' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ��� ��������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_CreateOrder()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_CreateOrder'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_CheckDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_CheckDocument' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContactPersonKind_AktSverki()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContactPersonKind_AktSverki'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������ ���������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_Movement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_Movement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_Account' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_Quality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_Quality' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_Pack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_Pack' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_Spec() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_Spec' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_Tax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PrintKind_TransportBill() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PrintKind_TransportBill' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������������ ���������� ���������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Tax()                   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Tax'                   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerS'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Corrective()                   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Corrective'                   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectivePrice()                 RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectivePrice'                 AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_CorrectivePriceSummaryPartner()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_CorrectivePriceSummaryPartner'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Prepay()                          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Prepay'                          AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Goods()                           RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Goods'                           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_Change()                          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_Change'                          AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_ChangePercent()                   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_ChangePercent'                   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentTaxKind_ChangeErr()                       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentTaxKind_ChangeErr'                       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ���� �������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_GoodsKind_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GoodsKind_Main' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Active() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Active' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Passive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Passive' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_All' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ���������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_RouteKind_Internal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_RouteKind_Internal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_RouteKind_External() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_RouteKind_External' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� �������� �������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Work()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Work'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Holiday()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Holiday'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Hospital()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Hospital'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Skip()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Skip'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Trainee()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Trainee'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Trainee50() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Trainee50' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Quit()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Quit'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Trial()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Trial'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_DayOff()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_DayOff'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkD()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkD'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkN()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkN'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Trip()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Trip'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Audit()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Audit'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_WorkDayOff()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_WorkDayOff'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_HolidayNoZp()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_HolidayNoZp'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_HospitalDoc()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_HospitalDoc'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_RemoteAccess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_RemoteAccess' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Medicday()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Medicday'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Inventory()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Inventory'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������ ����������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_DaySheetWorkTime()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_DaySheetWorkTime'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_MonthSheetWorkTime()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_MonthSheetWorkTime'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_MonthTotalSheet()         RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_MonthTotalSheet'         AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_SatSheetWorkTime()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_SatSheetWorkTime'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_DayHoursSheetWorkTime()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_DayHoursSheetWorkTime'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_MonthFundPay()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_MonthFundPay'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_ModelServiceKind_TurnFundPay()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ModelServiceKind_TurnFundPay'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������ ������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_InWeight()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_InWeight'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_OutWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_OutWeight' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_InAmount()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_InAmount'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_OutAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_OutAmount' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_InPack()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_InPack'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_InHead()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_InHead'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_OutHead()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_OutHead'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_InAmountForm()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_InAmountForm'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_OutAmountForm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_OutAmountForm' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MovementCount()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MovementCount'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MI_MasterCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MI_MasterCount' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MI_Master()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MI_Master'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MI_MasterSh()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MI_MasterSh'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MovementCount_Ware()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MovementCount_Ware'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MI_MasterCount_Ware()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MI_MasterCount_Ware'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MI_Master_Ware()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MI_Master_Ware'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MovementCount_WareIn()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MovementCount_WareIn'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MI_Master_WareIn()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MI_Master_WareIn'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MI_Master_WareOut()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MI_Master_WareOut'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MovementTransportHours() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MovementTransportHours' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MovementReestrWeight()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MovementReestrWeight'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MovementReestrDoc()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MovementReestrDoc'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_SelectKind_MovementReestrPartner()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_SelectKind_MovementReestrPartner'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ���� ��� �������� ����������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_MonthDay()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_MonthDay'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_Month()           RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_Month'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_Day()             RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_Day'             AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_Personal()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_Personal'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursPlan()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursPlan'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursDay()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursDay'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursPlanConst()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursPlanConst'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_HoursDayConst()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_HoursDayConst'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_StaffListSummKind_WorkHours()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_StaffListSummKind_WorkHours'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ��������� ��������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_Signed()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_Signed'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_UnSigned() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_UnSigned' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_Close() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_Close' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractStateKind_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractStateKind_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ������� ���������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_ChangePercent()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_ChangePercent'          AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_ChangePercentPartner()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_ChangePercentPartner'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_ChangePrice()            RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_ChangePrice'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayDayCalendar()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayDayCalendar'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayDayBank()           RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayDayBank'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayCreditLimit()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayCreditLimit'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_DelayPrepay()            RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_DelayPrepay'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditPercent()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditPercent'          AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditLimit()            RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditLimit'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditPercentService()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditPercentService'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_CreditPercentReceived()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_CreditPercentReceived'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentSale()             RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentSale'              AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentSaleReturn()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentSaleReturn'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentAccount()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentAccount'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusMonthlyPayment()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusMonthlyPayment'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT()          RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT'           AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusYearlyPayment()           RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusYearlyPayment'            AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_LimitReturn()                  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_LimitReturn'                   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentIncome()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentIncome'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentIncomeReturn()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentIncomeReturn'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentSalePart()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentSalePart'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusPercentIncomeReturnS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusPercentIncomeReturnS' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime1()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime1'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime2()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime2'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime3()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime3'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime4()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime4'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime5()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime5'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime6()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime6'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime7()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime7'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportTime8()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportTime8'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportDistance()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportDistance'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportDistanceInt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportDistanceInt' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportDistanceExt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportDistanceExt' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportOneTrip()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportOneTrip'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportOneTrip05()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportOneTrip05'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportOneTrip10()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportOneTrip10'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportOneTrip20()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportOneTrip20'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportRoundTrip() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportRoundTrip' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportPoint()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportPoint'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportWeight()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportWeight'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportForward()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportForward'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportSumm()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportSumm'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportOneDay()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportOneDay'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_TransportOneDayCon() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_TransportOneDayCon' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ContractConditionKind_BonusBrutto()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractConditionKind_BonusBrutto'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ����������� ���������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ContractTermKind_Long()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractTermKind_Long'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ContractTermKind_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ContractTermKind_Month' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ���� ��������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ReceiptKind_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReceiptKind_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReceiptKind_Separate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReceiptKind_Separate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReceiptKind_CompleteEtalon() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReceiptKind_CompleteEtalon' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ���������� - !!! �������� ����������� ��������� ������������!!!
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_DocumentKind_CuterWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentKind_CuterWeight' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentKind_PackDiff()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentKind_PackDiff'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentKind_RealWeight()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentKind_RealWeight'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentKind_RealDelicShp()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentKind_RealDelicShp'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentKind_RealDelicMsg()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentKind_RealDelicMsg'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentKind_LakTo()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentKind_LakTo'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DocumentKind_LakFrom()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DocumentKind_LakFrom'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ������: 1-������� �������������� ������
-- !!!
-- 10000; "����������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_10000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_10000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_20000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_20000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_30000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_30000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_40000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_40000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������� ������� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_50000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_50000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 51000; "������������� ���������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_51000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_51000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "������� ������� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_60000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_60000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_70000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_70000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "������������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_80000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_80000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "������� � ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_90000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_90000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 100000; "����������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_100000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_100000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110000; "�������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_110000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_110000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ������: 2-������� �������������� ������
-- !!!
-- 10000; "����������� ������"; 10100; "���������������� ��"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_10100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_10100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "����������� ������"; 10200; "���������������� ��"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_10200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_10200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "������"; 20100; "�� ������� ��"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20200; "�� �������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20300; "�� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20400; "�� ������������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20500; "���������� (��)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20600; "���������� (�����������)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20700; "�� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20800; "�� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "������"; 20900; "��������� ����"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30000; "��������"; 30100; "����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"; 30150; "���������� ���"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30150() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30150' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"; 30200; "���� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"; 30300; "������ ���������������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"; 30400; "������ ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"; 30500; "���������� (����������� ����)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"; 30600; "���������� (���������� ������)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "��������"; 30700; "������� ����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40000; "�������� ��������"; 40100; "�����"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"; 40200; "����� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"; 40300; "���������� ����"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"; 40400; "��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"; 40500; "����� ��"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"; 40600; "����� ����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"; 40700; "�������/������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "�������� ��������"; 40800; "�������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_40800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_40800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50000; "������� ������� ��������"; 50100; "����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_50100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_50100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������� ������� ��������"; 50200; "���"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_50200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_50200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������� ������� ��������"; 50300; "��������� �� �������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_50300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_50300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- 60000; "������� ������� ��������"; 60100; "���������� (�����������)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_60100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_60100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "������� ������� ��������"; 60200; "�� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_60200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_60200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70000; "���������"; 70100; "����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 70200; "��������� �� �������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 70300; "��������� �� ����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 70400; "������������ ������
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 70500; "����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 70700; "���������������� ��
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 70800; "���������������� ��
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 70900; "���
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "���������"; 71000; "������� ��������
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_71000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_71000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80000; "������������"; 80100; "������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_80100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_80100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "������������"; 80200; "������ �������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_80200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_80200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "������������"; 80400; "�������� �� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_80400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_80400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 90000; "������� � ��������"; 90100; "��������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "������� � ��������"; 90200; "��������� ������� (������)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "������� � ��������"; 90300; "��������� ������� �� ��"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "������� � ��������"; 90400; "������ � ������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 100000; "����������� �������"; 100400; "������� � �����������"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_100400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_100400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 110000; "�������"; 110300; "��������� ����"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_110300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_110300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ������: �������������� ����� (1+2+3 �������)
-- !!!
-- 10101 ���������������� �� + �������� ��������*****
CREATE OR REPLACE FUNCTION zc_Enum_Account_10101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_10101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10201 ���������������� �� + �������� ��������*****
CREATE OR REPLACE FUNCTION zc_Enum_Account_10201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_10201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20901; "��������� ����";
CREATE OR REPLACE FUNCTION zc_Enum_Account_20901() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_20901' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30101; "����������" + "���������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30151; "���������� ���" + "���������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30151() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30151' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30201; "���� ��������" + "����";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30202; "���� ��������" + "����";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30203; "���� ��������" + "�����";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30203() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30203' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30204; "���� ��������" + "�������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30204() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30204' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30204; "���� ��������" + "�������-���������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30205() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30205' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30510; "���������� (����������� ����)" + "�����";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30510() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30510' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30514; "���������� (����������� ����)" + "���������� (����������� ����)";
CREATE OR REPLACE FUNCTION zc_Enum_Account_30514() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_30514' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40101; "�����";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40102; "����� � ������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40201; "����� ��������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40202; "����� �������� � ������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40301; "��������� ����";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40302; "���������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40302() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40302' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40303; "��������� ���� � ������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40303' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40401; "��������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40501; "����� ��";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40601; "����� ��";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40601() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40601' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40701; "�������/������� ������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40701() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40701' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40801; "�������� �������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_40801() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40801' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50401; "������� ������� ��������" + "������ �� ����������" + "���������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_50401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_50401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 51101; "������������� ���������" + "������ �� ����������" + "���������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_51101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_51101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 51201; "������������� ���������" + "��������� � ���������" + "���������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_51201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_51201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60301; ������� ������� �������� + ������ �� �����������
CREATE OR REPLACE FUNCTION zc_Enum_Account_60301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_60301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 100301; "������� �������� �������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_100301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_100301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 100401; "����������� �������"; + ������� � �����������
CREATE OR REPLACE FUNCTION zc_Enum_Account_100401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_100401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 100402; "����������� �������"; + ������� � ����������� + �����������������, ������, �������
CREATE OR REPLACE FUNCTION zc_Enum_Account_100402() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_100402' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 100501; "������� �����������";
CREATE OR REPLACE FUNCTION zc_Enum_Account_100501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_100501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 110101; "�������"; + ����� � ���� + ������� + ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110111; "�������"; + ����� � ���� + ������� + ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110111() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110111' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110112() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110112' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110121; "�������"; + ����� � ���� + ������ �� ������ + ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110121() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110121' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110122() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110122' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110131; "�������"; + ����� � ���� + ������� � ������� + ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110131() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110131' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110132() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110132' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 110151; "�������"; + ������� � ���� + ������� + ������� � ���� + ������ � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110151() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110151' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110152() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110152' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110153() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110153' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110161; "�������"; + ������� � ���� + ������� + ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110161() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110161' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110162() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110162' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110171; "�������"; + ������� � ���� + ������ �� ������ + ������� � ���� + ������ � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110171() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110171' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110172() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110172' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110173() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110173' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110171; "�������"; + ������� � ���� + ������� � ������� + ������� � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110181() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110181' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Account_110182() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110182' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 110201; "�������"; + ������ � ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110301; "�������"; + ��������� ���� + ��������� ����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110302; "�������"; + ��������� ���� + ��������
CREATE OR REPLACE FUNCTION zc_Enum_Account_110302() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110302' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 110401; "�������"; + ����������� �����
CREATE OR REPLACE FUNCTION zc_Enum_Account_110401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_110401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ��: 1-������� �������������� ������ ����������
-- !!!
-- 10000; "�������� �����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_10000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_10000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_20000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_20000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_30000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_30000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_40000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_40000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������� � ��������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_50000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_50000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "���������� �����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_60000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_60000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "����������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_70000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_70000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "����������� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyGroup_80000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyGroup_80000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ��: 2-������� �������������� ����������
-- !!!
-- 10000; "�������� �����"; 10100; "������ �����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_10100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_10100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "�������� �����"; 10200; "������ �����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_10200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_10200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "�������������"; 20100; "�������� � �������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20200; "������ ���"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20300; "����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20400; "���"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20500; "��������� ����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20600; "������ ���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20700; "������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20800; "����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 20900; "����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 21000; "�����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 21100; "�������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 21100; "�������-���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21150() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21150' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "�������������"; 21200; "����������������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 21300; "������������� ������������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 21400; "������ ����������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 21500; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������"; 21600; "������������ ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30000; "������"; 30100; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "������"; 30200; "������ �����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "������"; 30300; "�����������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "������"; 30400; "������ ���������������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "������"; 30500; "������ ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40000; "���������� ������������"; 40100; "������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40200; "������ �������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40300; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40400; "�������� �� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40500; "�����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40600; "��������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40700; "����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40800; "���������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 40900; "���������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_40900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_40900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 41000; "�������/������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_41000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_41000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 41100; "���������� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_41100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_41100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 41200; "�������� � �/��."
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_41200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_41200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "���������� ������������"; 41300; "������ ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_41300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_41300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50000; "������� � ��������"; 50100; "��������� ������� �� ��"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������� � ��������"; 50200; "��������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������� � ��������"; 50300; "��������� ������� (������)"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������� � ��������"; 50400; "������ � ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70000; "����������"; 70100; ����������� ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_70100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_70100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "����������"; 70200; ����������� ������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_70200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_70200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "����������"; 70300; ������������ ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_70300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_70300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "����������"; 70400; ����������� �������������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_70400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_70400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "����������"; 70500; "���"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_70500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_70500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80000; "����������� ��������"; 80300; "������� � �����������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_80300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_80300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "����������� ��������"; 80500; "������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_80500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_80500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "����������� ��������"; 80600; "�����������������, ������, �������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_80600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_80600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ��: �������������� ������ ���������� (1+2+3 �������)
-- !!!
-- 10101; �������� ����� + ������ ����� + ����� ���
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10102; �������� ����� + ������ ����� + �������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10105; �������� ����� + ������ ����� + ������ ������ �����
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10105() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10105' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10106; �������� ����� + ������ ����� + ���
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10106() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10106' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10201; �������� ����� + ������ ����� + ������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10202; �������� ����� + ������ ����� + ��������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10203; �������� ����� + ������ ����� + ��������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10203() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10203' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10204; �������� ����� + ������ ����� + ������ �����
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_10204() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_10204' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20101; �������� � �������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20103; �������� � ������� + ����
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20202; ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20205; ������ ���
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20205() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20205' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20401; "���";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 21421; "������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21421() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21421' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21425; "����������� ��������� ��������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21425() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21425' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20501; ������������� + "��������� ����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20601; ������������� + "������ ���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20601() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20601' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20801; "����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20801() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20801' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20901; "����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20901() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20901' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21001; "�����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21001() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21001' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21101; "�������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21151; "�������-���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21151() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21151' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 21201; "����������������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21419; "������ �� �������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21419() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21419' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 21501; "������ �� ���������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21502; "������ �� ������ �����";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21502() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21502' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21505; "������ - ����������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21505() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21505' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21512; "������������� ������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21512() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21512' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30101; "������� ���������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_30101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_30101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30102; "�������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_30102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_30102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30103; "����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_30103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_30103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30201; "������ �����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_30201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_30201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30301; "�����������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_30301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_30301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30501; "������ ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_30501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_30501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30503; "������ �� �����������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_30503() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_30503' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40501; "�����"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_40501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_40501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40801; "���������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_40801() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_40801' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 41001; "�������/������� ������"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_41001() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_41001' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50101; ��������� ������� �� �� - ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_50101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_50101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50102; ��������� ������� �� �� - ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_50102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_50102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50201; ����� �� �������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_50201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_50201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50202; ���
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_50202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_50202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 60101 ���������� ����� + ���������� �����
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_60101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_60101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60102 ���������� ����� + ��������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_60102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_60102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60103 ���������� ����� + ���. �������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_60103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_60103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60104 ���������� ����� + ��������� ������. ��.�.
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_60104() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_60104' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70101 ����������� ���������� + ���� � ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70102 ����������� ���������� + ���������������� ������������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70103 ����������� ���������� + �������� ������������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70104 ����������� ���������� + ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70104() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70104' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70201 ����������� ������ + ���� � ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70202 ����������� ������ + ���������������� ������������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70203 ����������� ������ + �������� ������������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70203() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70203' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70204 ����������� ������ + ����������
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_70204() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_70204' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80301; ����������� �������� + ������� � ����������� + **�.�.
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_80301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_80301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80401; "������� �������� �������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_80401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_80401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80502; ����������� ������� - ������ - "������� �����������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_80502() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_80502' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80601; ����������� ������� - �����������������, ������, ������� - "������� �����������";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_80601() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_80601' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ����: 1-������� (������ ����)
-- !!!
-- 10000; "��������� �������� ������������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_10000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_10000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "�������������������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_20000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_20000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "���������������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_30000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_30000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "������� �� ����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_40000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_40000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_50000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_50000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "������� ������������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_60000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_60000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 65000; "����������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_65000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_65000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "�������������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_70000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_70000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 75000; "���������� ������������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_75000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_75000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "������� � �������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_80000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_80000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ����: 2-������� (��������� ���� - �����������)
-- !!!
-- 10100; "����� ����������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10200; "������ �� ���"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10300; "������ �� ������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10400; "������ ��������������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10500; "������������� ����������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10700; "����� ���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10800; "������������� ���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10900; "���������� ���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_10900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_10900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 11100; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_11100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_11100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20100; "���������� ������������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_20100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_20100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20200; "���������� �������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20300; "���������� ����������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_20300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_20300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20400; "���������� �����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_20400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_20400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20500; "������ ������ (��������+��������������)"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_20500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_20500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20600; "��������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_20600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_20600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20700; "������������ ������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_20700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_20700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30100; ���������������� ������� + ���������� �����
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_30100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_30100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30200; ���������������� ������� + ���������� ����������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_30200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_30200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30300; ���������������� ������� + ���������� ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_30300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_30300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30400; ���������������� ������� + ������������ ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_30400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_30400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40100; "���������� ����������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_40100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_40100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40200; "���������� ��������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_40200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_40200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40300; "�������������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_40300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_40300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40400; "������ ������ (��������+��������������)"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_40400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_40400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50100; ����� �� �������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_50100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_50100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50200; ���
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_50200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_50200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50300; ��������� ������� (������)
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_50300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_50300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50400; ��������� ������� �� ��
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_50400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_50400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50500; ������ � ������*
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_50500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_50500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 60100; ������� ������������ + ���������������� ��
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_60100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_60100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60200; ������� ������������ + ���������������� ��
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_60200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_60200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60300; ������� ������������ + ���
-- CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_60300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_60300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 65100; ����������� ������� + ���������������� ��
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_65100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_65100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 65200; ����������� ������� + ���������������� ��
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_65200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_65200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 65300; ����������� ������� + ���                                                                                                                                                            
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_65300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_65300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70100; ���������� ����� ���������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_70100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_70100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70110; �������� �� ����� ��������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_70110() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_70110' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70200; ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_70200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_70200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70300; ���������� (���������, �����)
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_70300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_70300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70400; �������� ������������ �������������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_70400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_70400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70500; �������� ������������� �� ��
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_70500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_70500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 75100; ���������� ������������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_75100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_75100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 75300; �������� ����������� �������������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_75300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_75300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 75500; ������(�������)
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_75500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_75500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80100; ������� � ������� + ���������� ������������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_80100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_80100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80200; ������� � ������� + ������(�������)
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_80200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_80200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80300; ������� � ������� + �������� ����������� �������������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_80300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_80300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80400; ������� � ������� + ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossDirection_80400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossDirection_80400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ����: ������ (1+2+3 �������)
-- !!!
-- 10000; "��������� �������� ������������" 10100; "����� ����������" 10101; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10100; "����� ����������" 10102; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 10200; "������� � �������� ������" 10201; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10200; "������� � �������� ������" 10202; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 10200; "������ �����" 10251; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10251() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10251' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10200; "������ �����" 10252; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10252() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10252' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 10300; "������ ��������������" 10301; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10300; "������ ��������������" 10301; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10302() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10302' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 10400; ������������� ���������� 10401; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10400; ������������� ���������� 10402; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10402() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10402' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 10500; "������ �� ���" 10501; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10500; "������ �� ���" 10502; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10502() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10502' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 10700; "����� ���������" 10701; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10701() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10701' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10700; "����� ���������" 10702; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10702() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10702' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10800; "������������� ���������" 10801; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10801() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10801' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10800; "������������� ���������" 10802; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10802() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10802' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 10900; "���������� ���������" 10901; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10901() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10901' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "��������� �������� ������������" 10900; "���������� ���������" 10902; "����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10902() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10902' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "��������� �������� ������������" 11100; "���������" 11101; "���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_11101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_11101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "�������������������� �������" 20200; "���������� �������" 20204; "������ ���������"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_20204() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_20204' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40000; "������� �� ����" 40200; "���������� ��������" 40208; "������� � ����"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_40208() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_40208' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50000; ������ 50100; ����� �� ������� 50101; ����� �� �������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_50101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_50101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; ������ 50200; ����� �� ������� 50201; ����� �� �������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_50201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_50201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 60000; ������� ������������ 60100; ���������������� �� 60101; �������� ��������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_60101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_60101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; ������� ������������ 60200; ���������������� �� 60201; �������� ��������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_60201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_60201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 65000; ����������� ������� 65100; ���������������� �� 65101; �������� ��������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_65101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_65101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_65102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_65102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_65103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_65103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 65000; ����������� ������� 65200; ���������������� �� 65201; �������� ��������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_65201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_65201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_65202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_65202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_65203() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_65203' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70000; �������������� ������� 70100; ���������� ����� ��������� 70101; ���� 
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70100; ���������� ����� ��������� 70102; �����
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70100; ���������� ����� ��������� 70103; �������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70100; ���������� ����� ��������� 70104; �������-���������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70104() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70104' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70110; �������� �� ����� �������� 70111; ���� 
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70111() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70111' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70110; �������� �� ����� �������� 70112; �����
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70112() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70112' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70000; �������������� ������� 70200; ������ 70201; ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70200; ������ 70202; ������ ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70200; ������ 70203; ������� �����������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70203() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70203' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; �������������� ������� 70200; ������ 70215; ������ �� �����������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70215() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70215' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70000; �������������� ������� 70500; �������� ������������� �� �� 70501; �������� ������������� �� ��
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_70501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_70501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 75000; ���������� ������������  75100; ���������� ������������ 75103; �������� �������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_75103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_75103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 75000; ���������� ������������  75100; ���������� ������������ 75105; ������� ��� �������/������� ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_75105() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_75105' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80000; ������� � �������  80100; ���������� ������������ 80103; �������� �������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_80103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_80103' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; ������� � �������  80100; ���������� ������������ 80105; ������� ��� �������/������� ������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_80105() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_80105' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 80000; ������� � �������  80300; �������� ����������� ������������� 80301; ���������
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_80301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_80301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ���� �����: �������
-- CREATE OR REPLACE FUNCTION zc_Enum_PromoKind_Custom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoKind_Custom' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ���� �����: � ���� ������������� �������
-- CREATE OR REPLACE FUNCTION zc_Enum_PromoKind_Compensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoKind_Compensation' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoKind_Budget() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoKind_Budget' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoKind_BudgetBill() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoKind_BudgetBill' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoKind_Bill() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoKind_Bill' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- ������� ������� � �����: %, ���.������
-- CREATE OR REPLACE FUNCTION zc_Enum_ConditionPromo_Discount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConditionPromo_Discount' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ������� ������� � �����: %, ����������� �� ����. ������� �� �����
-- CREATE OR REPLACE FUNCTION zc_Enum_ConditionPromo_BudgetBill() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConditionPromo_BudgetBill' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- ������� ������� � �����: 
CREATE OR REPLACE FUNCTION zc_Enum_ConditionPromo_Budget() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConditionPromo_Budget' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ConditionPromo_Bill() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConditionPromo_Bill' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ConditionPromo_ContractChangePercentOff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConditionPromo_ContractChangePercentOff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ConditionPromo_BonusOff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ConditionPromo_BonusOff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ��������� �����
-- !!!
 CREATE OR REPLACE FUNCTION zc_Enum_PromoStateKind_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoStateKind_Start' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoStateKind_StartSign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoStateKind_StartSign' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoStateKind_Head() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoStateKind_Head' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoStateKind_Main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoStateKind_Main' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoStateKind_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoStateKind_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoStateKind_Canceled() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoStateKind_Canceled' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoStateKind_Return() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoStateKind_Return' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ��������� �����-���������
-- !!!
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Start()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Start' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Canceled() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Canceled' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Return()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Return' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Complete_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Complete_1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Complete_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Complete_2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Complete_3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Complete_3' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Complete_4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Complete_4' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Complete_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Complete_5' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Complete_6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Complete_6' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 CREATE OR REPLACE FUNCTION zc_Enum_PromoTradeStateKind_Complete_7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PromoTradeStateKind_Complete_7' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ��������� ��������� ��� �����
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_EmailTools_Host()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailTools_Host' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailTools_Port() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailTools_Port' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailTools_Mail()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailTools_Mail' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailTools_User() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailTools_User' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailTools_Password()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailTools_Password' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_EmailTools_Directory() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_EmailTools_Directory' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� �������� ��� �����
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Mida35273055()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Mida35273055' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Vez37171990() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Vez37171990' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Brusn34604386() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Brusn34604386' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Dakort39135074() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Dakort39135074' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Glad2514900150() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Glad2514900150' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Avion40110917() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Avion40110917' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Logistik41750857() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Logistik41750857' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Nedavn2244900110() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Nedavn2244900110' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_PersonalService() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_PersonalService' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ExportKind_Tavr31929492() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ExportKind_Tavr31929492' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!!  ���� ��������� �� �������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_PartnerOut()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_PartnerOut'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_PartnerIn()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_PartnerIn'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_RemakeIn()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_RemakeIn'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_RemakeBuh()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_RemakeBuh'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_Remake()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_Remake'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_Buh()         RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_Buh'         AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_TransferIn()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_TransferIn'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_TransferOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_TransferOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_Log()         RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_Log'         AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_Econom()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_Econom'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_EconomIn()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_EconomIn'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_EconomOut()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_EconomOut'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_Snab()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_Snab'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_SnabRe()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_SnabRe'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_Double()      RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_Double'      AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_Scan()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_Scan'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_ReestrKind_InBuh()       RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReestrKind_InBuh'       AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ���� ����
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_DayKind_Calendar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DayKind_Calendar' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DayKind_Week() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DayKind_Week' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_DayKind_Period() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_DayKind_Period' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� � �������� <��������� ���������� ��������>
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ������ ������ �� ��� ����� MobileBillsJournal
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MobileBillsJournal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MobileBillsJournal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MobileBillsJournal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MobileBillsJournal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ������ �� ��������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Sticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Sticker' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Sticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Sticker' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� � ���� ����� �� (�1) � ���������� ���. ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MemberZP1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MemberZP1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MemberZP1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MemberZP1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� � ���� ����� �� (�2) � ���������� ���. ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MemberZP2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MemberZP2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MemberZP2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MemberZP2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-------
--�������� � ���� ����� IBAN �� (�1) � ���������� ���. ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MemberIBANZP1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MemberIBANZP1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MemberIBANZP1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MemberIBANZP1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� � ���� ����� IBAN �� (�2) � ���������� ���. ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MemberIBANZP2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MemberIBANZP2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MemberIBANZP2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MemberIBANZP2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� �������� � ���������� ���. ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MemberPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MemberPhone' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MemberPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MemberPhone' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;




----��������� �� ������ ��������� ���/��� ������/���. ��� ����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_Weight' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_Weight' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

----������� ������� � ��������� ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_Group() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_Group' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_Group() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_Group' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

----������� ������� � ��������� ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Receipt_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Receipt_ReceiptCost' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Receipt_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Receipt_ReceiptCost' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ��������� ������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_GoodsTypeKind_Sh()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GoodsTypeKind_Sh'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GoodsTypeKind_Nom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GoodsTypeKind_Nom' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_GoodsTypeKind_Ves() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GoodsTypeKind_Ves' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ��������� �����������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ClientKind_Retail()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ClientKind_Retail'  AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ClientKind_Partner() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ClientKind_Partner' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ClientKind_Unit()    RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ClientKind_Unit'    AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PriceListItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PriceListItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ������ ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_CashFlow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_CashFlow' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_CashFlow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_CashFlow' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� ������� ���������� (�������) 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_SaleExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_SaleExternal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_SaleExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_SaleExternal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--�������� ������� ���������� (�������) �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_SaleExternalNovus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_SaleExternalNovus' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_SaleExternalNovus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_SaleExternalNovus' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--�������� ������� ���������� (�������) �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_SaleExternalMetro() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_SaleExternalMetro' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_SaleExternalMetro() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_SaleExternalMetro' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--�������� ������� ���������� (�������) ����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_SaleExternalFora() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_SaleExternalFora' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_SaleExternalFora() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_SaleExternalFora' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--�������� ������� ���������� (�������) ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_SaleExternalSilpo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_SaleExternalSilpo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_SaleExternalSilpo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_SaleExternalSilpo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ������� ���������� (�������) �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_SaleExternalVarus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_SaleExternalVarus' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_SaleExternalVarus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_SaleExternalVarus' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ��������� ��
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PartnerCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PartnerCategory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PartnerCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PartnerCategory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� �������� ��������� � ����
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_PSLExportKind_XML()   RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PSLExportKind_XML'   AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PSLExportKind_iBank() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PSLExportKind_iBank' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ���� ���������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ReturnKind_Defect() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReturnKind_Defect' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReturnKind_Utilization() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReturnKind_Utilization' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ��� ������� ������������
-- !!!

CREATE OR REPLACE FUNCTION zc_Enum_OrderPeriodKind_Month()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_OrderPeriodKind_Month' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_OrderPeriodKind_Week_2() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_OrderPeriodKind_Week_2' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!!
-- !!! ���� ��������
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_ReturnDescKind_Return()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReturnDescKind_Return' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReturnDescKind_Loss() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReturnDescKind_Loss' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ReturnDescKind_Diff() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ReturnDescKind_Diff' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- �������� �����.������ �� ������. ����� � �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_OrderType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_OrderType' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_OrderType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_OrderType' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� ��������� �� �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalServiceMM() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalServiceMM' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalServiceMM() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalServiceMM' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �� �������� ���������� �� �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalServiceSummService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalServiceSummService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalServiceSummService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalServiceSummService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �� �������� ���������� ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalServiceSummAvance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalServiceSummAvance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalServiceSummAvance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalServiceSummAvance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �� �������� ���������� ����������� 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalServiceCompensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalServiceCompensation' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalServiceCompensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalServiceCompensation' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� � �������� <��������� ���������� ��������>   zc_MIFloat_SummMinusExtRecalc  ��������� ������. ��.�. (����)
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalServiceSMER() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalServiceSMER' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalServiceSMER() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalServiceSMER' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� ������� �� �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalServiceFine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalServiceFine' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalServiceFine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalServiceFine' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



--�������� ����� (��������. �� ���.- ������) �  ��� �.(�����. ��������. �� ���.- ������) �� �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsByGoodsKind_Br() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsByGoodsKind_Br' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsByGoodsKind_Br() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsByGoodsKind_Br' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� ���������� �� ������ �� �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PersonalTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PersonalTransport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PersonalTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PersonalTransport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� mic_2022_11_03 �� �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_mic_2022_11_03() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_mic_2022_11_03' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_mic_2022_11_03() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_mic_2022_11_03' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� ������������� ������������� (���������� ��) - ���, �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_LossPersonal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_LossPersonal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_LossPersonal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_LossPersonal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� �������� ����������� �� ��
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsByGoodsKind_PK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsByGoodsKind_PK' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsByGoodsKind_PK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsByGoodsKind_PK' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� ����� ������ (�����)
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsByGoodsKind_GoodsKindNew() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsByGoodsKind_GoodsKindNew' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsByGoodsKind_GoodsKindNew() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsByGoodsKind_GoodsKindNew' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� � ������ ����������� - "������ �� ��� �����" 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_ProductionPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_ProductionPeresort' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_ProductionPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_ProductionPeresort' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!!
-- !!! ������ ��������� �����
-- !!!
CREATE OR REPLACE FUNCTION zc_Enum_CardFuelKind_Active() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CardFuelKind_Active' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_CardFuelKind_Reserve() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CardFuelKind_Reserve' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_CardFuelKind_Locked() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CardFuelKind_Locked' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_CardFuelKind_Lost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CardFuelKind_Lost' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_CardFuelKind_Damaged () RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_CardFuelKind_Damaged ' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- �� �������� ��� �����������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Send' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Send' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �� �������� ��� �����������2
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Send2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Send2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Send2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Send2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- �������� ����� ��������  �������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_BUH' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_BUH' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ��������  "�������� ��"
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PeresortAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PeresortAsset' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PeresortAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PeresortAsset' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ��������  "�������� ������������ ��"
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PeresortEquipment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PeresortEquipment' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PeresortEquipment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PeresortEquipment' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ��������  "�������� ���� ��"
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PeresortCar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PeresortCar' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PeresortCar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PeresortCar' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ���������   TContractForm;zc_Object_ImportSetting_Contract
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Contract' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Contract' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� ������� �������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_ContractPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_ContractPriceList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_ContractPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_ContractPriceList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ������� ������� 2 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_ContractPriceListNew() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_ContractPriceListNew' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_ContractPriceListNew() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_ContractPriceListNew' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



--��������  GoodsUKTZED
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsUKTZED' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsUKTZED' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--��������  GoodsUKTZED2 2 (�� ���� ������)
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsUKTZED2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsUKTZED2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsUKTZED2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsUKTZED2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� GoodsGroupUKTZED
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsGroupUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsGroupUKTZED' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsGroupUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsGroupUKTZED' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� GoodsGroupUKTZED  2 �� ����. ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsGroupUKTZED2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsGroupUKTZED2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsGroupUKTZED2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsGroupUKTZED2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


 --��������  ��������� ��� �����������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_SubjectDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_SubjectDoc' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_SubjectDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_SubjectDoc' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


----��������� �� ������  ������������� ������������� 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_GGProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_GGProperty' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_GGProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_GGProperty' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

----��������� �� ������ ������ �������� (������ �����)
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PartionCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PartionCell' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PartionCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PartionCell' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


----��������� �� ������ ������ �������� (������ �����)  + �����
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PartionCell_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PartionCell_BoxCount' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PartionCell_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PartionCell_BoxCount' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



----��������� �� ������ �������� ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_Name' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_Name' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

----��������� �� ������ �������� ������ Scale
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_ScaleName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_ScaleName' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_ScaleName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_ScaleName' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� � ����� �� (�1) � ���������� ���. ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MemberCardF1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MemberCardF1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MemberCardF1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MemberCardF1' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� � ����� �� (�12) � ���������� ���. ���
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_MemberCardF2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_MemberCardF2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_MemberCardF2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_MemberCardF2' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� ����������� ��������� ������+��� ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsByGoodsKindPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsByGoodsKindPeresort' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsByGoodsKindPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsByGoodsKindPeresort' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--��������  �������� �� �� csv - PRIVAT
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_BankStatement_csv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_BankStatement_csv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_BankStatement_csv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_BankStatement_csv' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--��������  �������� �� �� csv - VOSTOK
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_BankStatement_csv_Vostok() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_BankStatement_csv_Vostok' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_BankStatement_csv_Vostok() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_BankStatement_csv_Vostok' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--��������  �������� ����� ������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_ChoiceCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_ChoiceCell' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_ChoiceCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_ChoiceCell' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--��������  ���� ����������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsNormDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsNormDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsNormDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsNormDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ������������� ������ ����������� + ����� � �������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_Direction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_Direction' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_Direction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_Direction' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

--�������� ������ ���������� ����� � �������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_Goods_GroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_Goods_GroupStat' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_Goods_GroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_Goods_GroupStat' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� PromoTrade �� ����� 
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_PromoTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_PromoTrade' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_PromoTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_PromoTrade' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� �������� ��� ������� ������� - ���������
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_GoodsPropertyValue_GoodsBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_GoodsPropertyValue_GoodsBox' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_GoodsPropertyValue_GoodsBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_GoodsPropertyValue_GoodsBox' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--�������� ContractGoodsMovement �� �����    --  �������� <������ � ��������� (������������)>
CREATE OR REPLACE FUNCTION zc_Enum_ImportType_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportType_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_ImportSetting_ContractGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ImportSetting_ContractGoods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 14.11.24         * �������� ContractGoodsMovement
 24.07.24         * �������� GoodsNormDiff
 26.06.24         * �������� �� �� csv
 25.06.24         * �������� ����������� ��������� ������+��� ������
 31.01.24         * �������� � ����� �1 � �2
 22.01.24         * ��������� �� ������ �������� ������ Scale
 17.01.24         * ��������� �� ������ �������� ������
 28.12.23         * ��������� �� ������ ������ �������� (������ �����)
 19.12.23         * �������� ������������� ������������� 
 23.11.23         * ��������  ��������� ��� ����������� 
 16.11.23         * �������� zc_Enum_ImportType_GoodsUKTZED2
                             zc_Enum_ImportType_GoodsGroupUKTZED2
 13.11.23         * �������� GoodsUKTZED, �������� GoodsGroupUKTZED
 10.10.23         * �������� ������� �������
 23.08.23         * �������� ���������
 19.07.23         * �������� ��������  "�������� ���� ��"
 18.07.23         * �������� ��������  "�������� ������������ ��"
 19.05.23         * �������� ��������  "�������� ��" 
 26.04.23         * �������� ����� ��������  �������
 24.04.23         * �������� 
 17.01.23         * �������� ������� (���������� ��)
 20.12.22         * -- �������� ����� ������ (�����)
 21.11.22         * zc_Enum_ExportKind_Tavr31929492
 03.11.22         * �������� mic_2022_11_03 �� �����
 01.09.22         * �������� ���������� �� ������ 
 07.06.22         * zc_Enum_ImportType_GoodsByGoodsKind_Br
 06.06.22         * add zc_Enum_ImportType_PersonalServiceSMER
 28.12.21         *
 22.12.21         * zc_Enum_ImportType_PersonalServiceMM
 18.10.21         * OrderType
 01.07.21         * zc_Enum_ReturnDescKind_....
 08.06.21         * zc_Enum_OrderPeriodKind
 07.04.21         * 
 18.03.21         * zc_Enum_PSLExportKind_...
 03.03.20         * add zc_Enum_ImportType_SaleExternalVarus
                        zc_Enum_ImportSetting_SaleExternalVarus
 16.11.20         * add zc_Enum_ImportType_SaleExternalSilpo
                        zc_Enum_ImportSetting_SaleExternalSilpo
 01.11.20         *
 22.06.20         *
 24.03.20         *
 23.10.19         *
 14.05.19         *
 03.12.18         * 
 27.10.17         * �������� ������ �� ��������
 20.02.17         * �������� ������ ������ �� ��� ����� MobileBillsJournal
 18.01.17         * �������� � �������� <��������� ���������� ��������>
 15.11.16         * zc_Enum_DayKind
 23.03.16         * 
 03.03.16         * ���� ��������� ��� �����, 
                    ��������� ��������� ��� �����
 23.11.15                                                                      *zc_Enum_ImportExportLinkType_UploadCompliance
 31.10.15                                                                      *zc_Enum_PromoKind_Custom, zc_Enum_PromoKind_Compensation, zc_Enum_ConditionPromo_Discount, zc_Enum_ConditionPromo_Compensation
 13.11.14                                        * add zc_Enum_Currency_Basis
 30.08.14                                        * add zc_Enum_InfoMoney_60101
 23.08.14                                        * add ��
 04.08.14                                        * del zc_Enum_AccountDirection_70600 ���������� (������������)
 02.08.14                                        * add zc_Enum_AccountDirection_20...
 19.07.14                                        * change zc_Enum_Account_40302
 19.07.14                                        * del zc_Enum_AccountDirection_40500 and zc_Enum_Account_40501
 13.06.14                                        * add zc_Enum_Role_1107
 21.05.14                                        * add zc_Enum_DocumentTaxKind_Prepay
 21.05.14                                        * add zc_Enum_ContractConditionKind_DelayPrepay
 13.05.14                                        * add zc_Enum_ProfitLossDirection_70110 and zc_Enum_ProfitLoss_70111 and zc_Enum_ProfitLoss_70112
 07.05.14                                        * add zc_Enum_Role_Bread
 06.05.14                                        * add zc_Enum_InfoMoney_21419
 05.05.14                                        * del zc_Enum_ContractConditionKind_DelayDayCalendarSale and zc_Enum_ContractConditionKind_DelayDayBankSale
 04.05.14                                        * add zc_Enum_Account_40401 and zc_Enum_Account_40501
 04.05.14                                        * change zc_Enum_AccountDirection_40500
 30.04.14                                        * add zc_Enum_DocumentTaxKind_CorrectivePrice
 21.04.14                                        * add zc_Enum_ContractConditionKind_DelayCreditLimit
 19.04.14                                        * add zc_Enum_Account_110...
 17.04.14                                        * add zc_Enum_AccountGroup_110000
 16.04.14                                        * add zc_Enum_InfoMoney_30201
 08.04.14                                        * add zc_Enum_GoodsKind_Main
 04.04.14                                        * add �������-���������
 21.03.14                                        * add zc_Enum_Account_3020... and zc_Enum_InfoMoney_20...
 09.03.14                                        * add zc_Enum_Account_50401
 21.02.14					 * add zc_Enum_ContractConditionKind_LimitReturn
 09.02.14							* add ���� ������������ ���������� ���������
 30.01.14                                        * add zc_Enum_ProfitLoss_80301
 25.01.14                                        * add zc_Enum_ContractConditionKind_...
 24.01.14                                        * add zc_Enum_InfoMoneyDestination_40900
 22.12.13                                        * add zc_Enum_InfoMoneyGroup_...
 22.12.13                                        * add zc_Enum_AccountDirection_40...
 19.12.13                                        * add del zc_Enum_ContractConditionKind_...
 30.11.13                                        * add del zc_Enum_StaffListSummKind_WorkHours and zc_Enum_StaffListSummKind_HoursDayConst
 28.11.13                                        * add zc_Enum_WorkTimeKind_Trainee50 and zc_Enum_WorkTimeKind_Quit and zc_Enum_WorkTimeKind_Trial
 19.11.13                                        * add zc_Enum_StaffListSummKind_HoursPlanConst and zc_Enum_StaffListSummKind_HoursDayConst
 18.11.13                                        * add zc_Enum_StaffListSummKind_HoursDay
 18.11.13                                        * replace zc_Enum_StaffListSummKind_RatioHours -> zc_Enum_StaffListSummKind_HoursPlan
 18.11.13                                        * replace zc_Enum_StaffListSummKind_Turn -> zc_Enum_StaffListSummKind_Day
 18.11.13                                        * replace zc_Enum_StaffListSummKind_MasterStaffListHours -> zc_Enum_StaffListSummKind_WorkHours
 16.11.13         * add zc_Object_ContractConditionKind
 09.11.13                                        * add zc_Enum_Role_Transport
 03.11.13                                        * rename zc_Enum_ProfitLoss_40209 -> zc_Enum_ProfitLoss_40208
 31.10.13                                        * add zc_Enum_Account_110101
 30.10.13         * add ���� ���� ��� �������� ����������
 03.10.13                                        * add zc_Enum_InfoMoney_20901, zc_Enum_InfoMoney_30101
 01.10.13         * add  ���� �������� �������
 30.09.13                                        * add zc_Enum_InfoMoney_21201
 27.09.13                                        * add zc_Enum_InfoMoney_20401
 26.09.13         * del zc_Enum_RateFuelKind_Summer, zc_Enum_RateFuelKind_Winter
 25.09.13         * add zc_Enum_RateFuelKind_Summer, zc_Enum_RateFuelKind_Winter, zc_Enum_RouteKind_Internal, zc_Enum_RouteKind_External
 21.09.13                                        * add zc_Enum_InfoMoney_80401
 15.09.13                                        * add zc_Enum_AccountDirection_20900 and zc_Enum_Account_20901
 08.09.13                                        * add zc_Enum_ProfitLoss_1...
 07.09.13                                        * add zc_Enum_ProfitLossDirection_1... and zc_Enum_ProfitLossDirection_7...
 01.09.13                                        * add zc_Enum_ProfitLossDirection_4...
 26.08.13                                        * add ����
 25.08.13                                        * add zc_Enum_Account_100301
 21.08.13                        * add zc_Enum_Account_40101
 20.07.13                                        * add zc_Enum_AccountDirection_20200, 20400
 18.07.13                                        * add zc_Enum_AccountDirection_20500, 20600
 03.07.13                                        * add 2-������� �������������� ������
 02.07.13                                        * add 1-������� �������������� ������
 01.07.13                                        * add 2-������� �������������� ����������
 28.06.13                                        *
*/
