-- ��������� �������
DO $$
BEGIN

   -- ��� ���� ���� ��� �������, �� Enum, �� �����
   IF NOT EXISTS (SELECT * FROM Object WHERE DescId = zc_Object_RateFuelKind())
   THEN
       PERFORM lpInsertUpdate_Object (0, zc_Object_RateFuelKind(), 1, '����');
   END IF;

   -- ��������� ����:
   -- zc_Enum_Role_Admin
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= '���� ��������������', inEnumName:= 'zc_Enum_Role_Admin');
   -- zc_Enum_Role_Transport
   IF EXISTS (SELECT * FROM Object WHERE DescId = zc_Object_Role() AND ValueData = '���������-���� ����������')
   THEN
       PERFORM lpUpdate_Object_Enum_byCode (inCode   := (SELECT ObjectCode FROM Object WHERE DescId = zc_Object_Role() AND ValueData = '���������-���� ����������')
                                          , inDescId := zc_Object_Role()
                                          , inEnumName:= 'zc_Enum_Role_Transport');
   ELSE
       PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Transport(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Transport'), inName:= '���������-���� ����������', inEnumName:= 'zc_Enum_Role_Transport');
   END IF;
   -- zc_Enum_Role_Bread
   IF EXISTS (SELECT * FROM Object WHERE DescId = zc_Object_Role() AND ValueData = '����')
   THEN
       PERFORM lpUpdate_Object_Enum_byCode (inCode   := (SELECT ObjectCode FROM Object WHERE DescId = zc_Object_Role() AND ValueData = '����')
                                          , inDescId := zc_Object_Role()
                                          , inEnumName:= 'zc_Enum_Role_Bread');
   ELSE
       PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Bread(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Bread'), inName:= '����', inEnumName:= 'zc_Enum_Role_Bread');
   END IF;
   -- zc_Enum_Role_1107
   IF EXISTS (SELECT * FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 1107)
   THEN
       PERFORM lpUpdate_Object_Enum_byCode (inCode   := 1107
                                          , inDescId := zc_Object_Role()
                                          , inEnumName:= 'zc_Enum_Role_1107');
   ELSE
       PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_1107(), inDescId:= zc_Object_Role(), inCode:= 1107, inName:= '���� + ����', inEnumName:= 'zc_Enum_Role_1107');
   END IF;
   -- zc_Enum_Role_CashReplace
   IF EXISTS (SELECT * FROM Object WHERE DescId = zc_Object_Role() AND ValueData = '����� ����� - ���������� �����')
   THEN
       PERFORM lpUpdate_Object_Enum_byCode (inCode   := (SELECT ObjectCode FROM Object WHERE DescId = zc_Object_Role() AND ValueData = '����� ����� - ���������� �����')
                                          , inDescId := zc_Object_Role()
                                          , inEnumName:= 'zc_Enum_Role_CashReplace');
   ELSE
       RAISE EXCEPTION '!!!������� <zc_Enum_Role_CashReplace> ������ ��� ���� Project!!!, ����� ����� ��������� ������� ����';
       -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_CashReplace(), inDescId:= zc_Object_Role(), inCode:= 56, inName:= '����� ����� - ���������� �����', inEnumName:= 'zc_Enum_Role_CashReplace');
   END IF;

END $$;

DO $$
BEGIN

   -- CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectParam()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
   -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_ConnectParam(),       inDescId:= zc_Object_GlobalConst(), inCode:= 3,  inName:= '', inEnumName:= 'zc_Enum_GlobalConst_ConnectParam');
   -- CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_ConnectReportParam()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_GlobalConst_ConnectReportParam' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
   -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_ConnectReportParam(), inDescId:= zc_Object_GlobalConst(), inCode:= 33, inName:= '', inEnumName:= 'zc_Enum_GlobalConst_ConnectReportParam');

   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_BankAccountDate(),  inDescId:= zc_Object_GlobalConst(), inCode:= 1, inName:= '���������� ������� ��������� ��: ', inEnumName:= 'zc_Enum_GlobalConst_BankAccountDate');

   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_IntegerDate(),  inDescId:= zc_Object_GlobalConst(), inCode:= 2, inName:= '������������ ������ Integer', inEnumName:= 'zc_Enum_GlobalConst_IntegerDate');

   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_CashDate(),  inDescId:= zc_Object_GlobalConst(), inCode:= 3, inName:= '������������ ������ �� �����', inEnumName:= 'zc_Enum_GlobalConst_CashDate');

   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_PeriodClosePlan(),  inDescId:= zc_Object_GlobalConst(), inCode:= 4, inName:= '���� �������� ������� :', inEnumName:= 'zc_Enum_GlobalConst_PeriodClosePlan');

   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_MedocTaxDate(),  inDescId:= zc_Object_GlobalConst(), inCode:= 101, inName:= '������������ ������ �����', inEnumName:= 'zc_Enum_GlobalConst_MedocTaxDate');
   
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_EndDateOlapSR(),  inDescId:= zc_Object_GlobalConst(), inCode:= 111, inName:= '�� ����� ���� ������������ ������������ ������ ���� �������/�������', inEnumName:= 'zc_Enum_GlobalConst_EndDateOlapSR');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_ProtocolDateOlapSR(),  inDescId:= zc_Object_GlobalConst(), inCode:= 112, inName:= '���� ������������ ������ ���� �������/�������', inEnumName:= 'zc_Enum_GlobalConst_ProtocolDateOlapSR');

END $$;

/*
DO $$
DECLARE ioId integer;
BEGIN

   IF NOT EXISTS(SELECT * FROM OBJECT
   JOIN ObjectLink AS RoleRight_Role
     ON RoleRight_Role.descid = zc_ObjectLink_RoleRight_Role()
    AND RoleRight_Role.childobjectid = zc_Enum_Role_Admin()
    AND RoleRight_Role.objectid = OBJECT.id

   JOIN ObjectLink AS RoleRight_Process
     ON RoleRight_Process.descid = zc_ObjectLink_RoleRight_Process()
    AND RoleRight_Process.childobjectid = zc_Enum_Process_InsertUpdate_Object_User()
    AND RoleRight_Process.objectid = OBJECT.id
  WHERE OBJECT.descid = zc_Object_RoleRight()) THEN
     -- ������� ����� ���� ��������������
     ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Role(), ioId, zc_Enum_Role_Admin());
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Process(), ioId, zc_Enum_Process_InsertUpdate_Object_User());
   END IF;

END $$;
*/
DO $$
DECLARE ioId integer;
DECLARE UserId integer;
BEGIN
   -- ������ �������� �������� ���������� ������ ��� �� ��������� �������� ����!!!
   SELECT Id INTO UserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';

   IF COALESCE(UserId, 0) = 0 THEN
     -- ������� ��������������
     UserId := lpInsertUpdate_Object(0, zc_Object_User(), 0, '�����');

     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), UserId, '�����');
   END IF;

   IF NOT EXISTS(SELECT * FROM OBJECT

     JOIN ObjectLink AS UserRole_Role
       ON UserRole_Role.descid = zc_ObjectLink_UserRole_Role()
      AND UserRole_Role.childobjectid = zc_Enum_Role_Admin()
      AND UserRole_Role.objectid = OBJECT.id

     JOIN ObjectLink AS UserRole_User
       ON UserRole_User.descid = zc_ObjectLink_UserRole_User()
      AND UserRole_User.childobjectid = UserId
      AND UserRole_User.objectid = OBJECT.id
  WHERE OBJECT.descid = zc_Object_UserRole()) THEN

     -- ��������� ������������ � �����
     ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_Role(), ioId, zc_Enum_Role_Admin());

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_User(), ioId, UserId);
   END IF;
END $$;


DO $$
BEGIN

     -- !!! ������
     IF zc_Enum_Currency_Basis() IS NULL
     THEN IF EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_Currency() AND ObjectCode = 980)
          THEN PERFORM lpUpdate_Object_Enum_byCode (inCode:= 980,  inDescId:= zc_Object_Currency(), inEnumName:= 'zc_Enum_Currency_Basis');
          -- ELSE PERFORM lpInsertUpdate_Object_Enum (inId:=zc_Enum_Currency_Basis(),  inDescId:= zc_Object_Currency(), inCode:= 980, inName:= '���', inEnumName:= 'zc_Enum_Currency_Basis');
          END IF;
     END IF;
     
     -- !!! ���� ���������� - !!! �������� ����������� ��������� ������������!!!
     IF EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND ObjectCode = 1) AND NOT EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_CuterWeight())
     THEN
         PERFORM lpUpdate_Object_Enum_byCode (inCode:= COALESCE ((SELECT ObjectCode FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_CuterWeight()), 1), inDescId:= zc_Object_DocumentKind(), inEnumName:= 'zc_Enum_DocumentKind_CuterWeight');
     END IF;
     -- !!! ���� ���������� - !!! �������� ����������� ��������� ������������!!!
     IF EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND ObjectCode = 3) AND NOT EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_PackDiff())
     THEN
         PERFORM lpUpdate_Object_Enum_byCode (inCode:= COALESCE ((SELECT ObjectCode FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_PackDiff()), 3), inDescId:= zc_Object_DocumentKind(), inEnumName:= 'zc_Enum_DocumentKind_PackDiff');
     END IF;
     -- !!! ���� ���������� - !!! �������� ����������� ��������� ������������!!!
     IF EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND ObjectCode = 4) AND NOT EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_RealWeight())
     THEN
         PERFORM lpUpdate_Object_Enum_byCode (inCode:= COALESCE ((SELECT ObjectCode FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_RealWeight()), 4), inDescId:= zc_Object_DocumentKind(), inEnumName:= 'zc_Enum_DocumentKind_RealWeight');
     END IF;
     -- !!! ���� ���������� - !!! �������� ����������� ��������� ������������!!!
     IF EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND ObjectCode = 5) AND NOT EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_RealDelicShp())
     THEN
         PERFORM lpUpdate_Object_Enum_byCode (inCode:= COALESCE ((SELECT ObjectCode FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_RealDelicShp()), 5), inDescId:= zc_Object_DocumentKind(), inEnumName:= 'zc_Enum_DocumentKind_RealDelicShp');
     END IF;
     -- !!! ���� ���������� - !!! �������� ����������� ��������� ������������!!!
     IF EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND ObjectCode = 6) AND NOT EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_RealDelicMsg())
     THEN
         PERFORM lpUpdate_Object_Enum_byCode (inCode:= COALESCE ((SELECT ObjectCode FROM Object WHERE DescId = zc_Object_DocumentKind() AND Id = zc_Enum_DocumentKind_RealDelicMsg()), 6), inDescId:= zc_Object_DocumentKind(), inEnumName:= 'zc_Enum_DocumentKind_RealDelicMsg');
     END IF;


     -- !!! ���� �������� ��� ��������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_10400(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 101, inName:= '���-��, ����������, � ����������', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_10400');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_10500(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 102, inName:= '���-��, ����������, ������ �� ���', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_10500');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 103, inName:= '���-��, ����������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_40200');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10400(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 111, inName:= '����� �/�, ����������, � ����������', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10400');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10500(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 112, inName:= '����� �/�, ����������, ������ �� ���', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10500');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 113, inName:= '����� �/�, ����������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_40200');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10100(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 121, inName:= '�����, ����������, � ���������� (�� ������� �����)', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10100');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 122, inName:= '�����, ����������, ������� � �������� ������', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10200');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10250(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 123, inName:= '�����, ����������, ������ �����', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10250');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10300(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 124, inName:= '�����, ����������, ������ ��������������', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10300');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInCount_10800(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 201, inName:= '���-��, �������, �� ����������', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInCount_10800');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInCount_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 202, inName:= '���-��, �������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInCount_40200');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInSumm_10800(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 211, inName:= '����� �/�, �������, �� ���������� ', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInSumm_10800');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInSumm_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 212, inName:= '����� �/�, �������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInSumm_40200');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInSumm_10700(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 221, inName:= '�����, �������, �� ���������� (�� ������� �����)', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInSumm_10700');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInSumm_10200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 222, inName:= '�����, �������, ������� � �������� ������', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInSumm_10200');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInSumm_10300(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 223, inName:= '�����, �������, ������ ��������������', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInSumm_10300');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_LossCount_10900(), inDescId:= zc_Object_AnalyzerId(), inCode:= 301, inName:= '���-��, ���������� ��������� ��� ����������/����������� �� ����', inEnumName:= 'zc_Enum_AnalyzerId_LossCount_10900');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_LossSumm_10900(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 302, inName:= '����� �/�, ���������� ��������� ��� ����������/����������� �� ����', inEnumName:= 'zc_Enum_AnalyzerId_LossSumm_10900');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_LossCount_20200(), inDescId:= zc_Object_AnalyzerId(), inCode:= 303, inName:= '���-��, �������� ��� ����������/����������� �� ����', inEnumName:= 'zc_Enum_AnalyzerId_LossCount_20200');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_LossSumm_20200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 304, inName:= '����� �/�, �������� ��� ����������/����������� �� ����', inEnumName:= 'zc_Enum_AnalyzerId_LossSumm_20200');

     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Cash_PersonalAvance(),     inDescId:= zc_Object_AnalyzerId(), inCode:= 1001, inName:= '������� ���������� - �����', inEnumName:= 'zc_Enum_AnalyzerId_Cash_PersonalAvance');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Cash_PersonalService(),    inDescId:= zc_Object_AnalyzerId(), inCode:= 1002, inName:= '������� ���������� - �� ���������', inEnumName:= 'zc_Enum_AnalyzerId_Cash_PersonalService');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Cash_PersonalCardSecond(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1003, inName:= '������� ���������� - �� ��������� ����� �� 2�.', inEnumName:= 'zc_Enum_AnalyzerId_Cash_PersonalCardSecond');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ProfitLoss(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1011, inName:= '�� ��� ��������� � ����, ����� �������� � ��������', inEnumName:= 'zc_Enum_AnalyzerId_ProfitLoss');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Income_Packer(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1021, inName:= '� ������� ���� �������������� ��� �������� �������� �� ������������', inEnumName:= 'zc_Enum_AnalyzerId_Income_Packer');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReWork(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1031, inName:= '� �������� ����� ������� �� ������������ ���� � ������� �����������', inEnumName:= 'zc_Enum_AnalyzerId_ReWork');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Count_40200(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1041, inName:= '���-��, ������ �� ����. + ������� ����., ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_Count_40200');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SummIn_110101() , inDescId:= zc_Object_AnalyzerId(), inCode:= 1051, inName:= '�����, �� ������ ������������ ����, ������ �������', inEnumName:= 'zc_Enum_AnalyzerId_SummIn_110101');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SummOut_110101(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1052, inName:= '�����, �� ������ ������������ ����, ������ �������', inEnumName:= 'zc_Enum_AnalyzerId_SummOut_110101');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SummIn_80401() , inDescId:= zc_Object_AnalyzerId(), inCode:= 1053, inName:= '�����, �� ������ ������������ ����, ������ ����. ���. ��������', inEnumName:= 'zc_Enum_AnalyzerId_SummIn_80401');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SummOut_80401(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1054, inName:= '�����, �� ������ ������������ ����, ������ ����. ���. ��������', inEnumName:= 'zc_Enum_AnalyzerId_SummOut_80401');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SendCount_in(),    inDescId:= zc_Object_AnalyzerId(), inCode:= 1101, inName:= '���-��, ����������� �� ���� or �����������, ������',         inEnumName:= 'zc_Enum_AnalyzerId_SendCount_in');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SendCount_10500(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1102, inName:= '���-��, ����������� �� ���� or �����������, ������ �� ���',  inEnumName:= 'zc_Enum_AnalyzerId_SendCount_10500');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SendCount_40200(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1103, inName:= '���-��, ����������� �� ���� or �����������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_SendCount_40200');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SendSumm_in(),    inDescId:= zc_Object_AnalyzerId(), inCode:= 1111, inName:= '����� �/�, ����������� �� ���� or �����������, ������',         inEnumName:= 'zc_Enum_AnalyzerId_SendSumm_in');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SendSumm_10500(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1112, inName:= '����� �/�, ����������� �� ���� or �����������, ������ �� ���',  inEnumName:= 'zc_Enum_AnalyzerId_SendSumm_10500');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SendSumm_40200(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1113, inName:= '����� �/�, ����������� �� ���� or �����������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_SendSumm_40200');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Transport_Add(),     inDescId:= zc_Object_AnalyzerId(), inCode:= 1201, inName:= '����� ��������������� �� ������� ����',                     inEnumName:= 'zc_Enum_AnalyzerId_Transport_Add');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Transport_AddLong(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1202, inName:= '����� ������������ (���� ���������������) �� ������� ����', inEnumName:= 'zc_Enum_AnalyzerId_Transport_AddLong');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_Transport_Taxi(),    inDescId:= zc_Object_AnalyzerId(), inCode:= 1203, inName:= '����� �� ����� �� ������� ����',                            inEnumName:= 'zc_Enum_AnalyzerId_Transport_Taxi');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_PersonalService_Nalog(),    inDescId:= zc_Object_AnalyzerId(), inCode:= 1301, inName:= '����� ������ - ��������� � ��',                      inEnumName:= 'zc_Enum_AnalyzerId_PersonalService_Nalog');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_PersonalService_NalogRet(), inDescId:= zc_Object_AnalyzerId(), inCode:= 1302, inName:= '����� ������ - ���������� � ��',                     inEnumName:= 'zc_Enum_AnalyzerId_PersonalService_NalogRet');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_MobileBills_Personal(),     inDescId:= zc_Object_AnalyzerId(), inCode:= 1303, inName:= '����� ��������� ����� - ��������� � ��',             inEnumName:= 'zc_Enum_AnalyzerId_MobileBills_Personal');
     --
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_TareReturning(), inDescId:= zc_Object_AnalyzerId(), inCode:= 2001, inName:= '���-��, ���������� ����', inEnumName:= 'zc_Enum_AnalyzerId_TareReturning');
     
     -- !!! ����� ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_FirstForm(),  inDescId:= zc_Object_PaidKind(), inCode:= 1, inName:= '��', inEnumName:= 'zc_Enum_PaidKind_FirstForm');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_SecondForm(), inDescId:= zc_Object_PaidKind(), inCode:= 2, inName:= '���', inEnumName:= 'zc_Enum_PaidKind_SecondForm');

     -- !!! ���� �������� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_CashRegisterKind_FP3141(),  inDescId:= zc_Object_CashRegisterKind(), inCode:= 1, inName:= 'Datecs FP 3141', inEnumName:= 'zc_Enum_CashRegisterKind_FP3141');

     -- !!! ������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_UnComplete(), inName:= '�� ��������', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Complete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Complete(), inName:= '��������', inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Erased(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Erased(), inName:= '������', inEnumName:= 'zc_Enum_Status_Erased');

     -- !!! ������� ���������� EDI
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_ORDERS(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_ORDERS(), inName:= '�����', inEnumName:= 'zc_Enum_EDIStatus_ORDERS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_DESADV(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_DESADV(), inName:= '���������', inEnumName:= 'zc_Enum_EDIStatus_DESADV');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_COMDOC(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_COMDOC(), inName:= '��������', inEnumName:= 'zc_Enum_EDIStatus_COMDOC');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_DECLAR(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_DECLAR(), inName:= '���������', inEnumName:= 'zc_Enum_EDIStatus_DECLAR');
    
     -- !!! ��� ��������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_CreateOrder()  , inDescId:= zc_Object_ContactPersonKind(), inCode:= 1, inName:= '������������ �������'          , inEnumName:= 'zc_Enum_ContactPersonKind_CreateOrder');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_CheckDocument(), inDescId:= zc_Object_ContactPersonKind(), inCode:= 2, inName:= '�������� ����������'           , inEnumName:= 'zc_Enum_ContactPersonKind_CheckDocument');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_AktSverki()    , inDescId:= zc_Object_ContactPersonKind(), inCode:= 3, inName:= '���� ������ � ���������� �����', inEnumName:= 'zc_Enum_ContactPersonKind_AktSverki');

     -- !!! ���� ������ ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_Movement(), inDescId:= zc_Object_PrintKind(), inCode:= 1, inName:= '���������', inEnumName:= 'zc_Enum_PrintKind_Movement');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_Account(), inDescId:= zc_Object_PrintKind(), inCode:= 2, inName:= '����', inEnumName:= 'zc_Enum_PrintKind_Account');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_Transport(), inDescId:= zc_Object_PrintKind(), inCode:= 3, inName:= '���', inEnumName:= 'zc_Enum_PrintKind_Transport');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_Quality(), inDescId:= zc_Object_PrintKind(), inCode:= 4, inName:= '������������', inEnumName:= 'zc_Enum_PrintKind_Quality');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_Pack(), inDescId:= zc_Object_PrintKind(), inCode:= 5, inName:= '�����������', inEnumName:= 'zc_Enum_PrintKind_Pack');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_Spec(), inDescId:= zc_Object_PrintKind(), inCode:= 6, inName:= '������������', inEnumName:= 'zc_Enum_PrintKind_Spec');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_Tax(), inDescId:= zc_Object_PrintKind(), inCode:= 7, inName:= '���������', inEnumName:= 'zc_Enum_PrintKind_Tax');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PrintKind_TransportBill(), inDescId:= zc_Object_PrintKind(), inCode:= 8, inName:= '������������', inEnumName:= 'zc_Enum_PrintKind_TransportBill');

     -- !!! ���� ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Active(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= '��������', inEnumName:= 'zc_Enum_AccountKind_Active');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Passive(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= '���������', inEnumName:= 'zc_Enum_AccountKind_Passive');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_All(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= '�������/���������', inEnumName:= 'zc_Enum_AccountKind_All');

     -- !!! ���� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_RouteKind_Internal(), inDescId:= zc_Object_RouteKind(), inCode:= 1, inName:= '�����', inEnumName:= 'zc_Enum_RouteKind_Internal');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_RouteKind_External(), inDescId:= zc_Object_RouteKind(), inCode:= 2, inName:= '��������', inEnumName:= 'zc_Enum_RouteKind_External');

     -- !!! ���� �������� �������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Work(),      inDescId:= zc_Object_WorkTimeKind(), inCode:= 1, inName:= '������� ����'  , inEnumName:= 'zc_Enum_WorkTimeKind_Work');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Holiday(),   inDescId:= zc_Object_WorkTimeKind(), inCode:= 2, inName:= '������'        , inEnumName:= 'zc_Enum_WorkTimeKind_Holiday');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Hospital(),  inDescId:= zc_Object_WorkTimeKind(), inCode:= 3, inName:= '����������'    , inEnumName:= 'zc_Enum_WorkTimeKind_Hospital');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Skip(),      inDescId:= zc_Object_WorkTimeKind(), inCode:= 4, inName:= '������'        , inEnumName:= 'zc_Enum_WorkTimeKind_Skip');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Trainee50(), inDescId:= zc_Object_WorkTimeKind(), inCode:= 5, inName:= '������50%'     , inEnumName:= 'zc_Enum_WorkTimeKind_Trainee50');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Trainee(),   inDescId:= zc_Object_WorkTimeKind(), inCode:= 6, inName:= '������'        , inEnumName:= 'zc_Enum_WorkTimeKind_Trainee');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Quit(),      inDescId:= zc_Object_WorkTimeKind(), inCode:= 7, inName:= '����������'    , inEnumName:= 'zc_Enum_WorkTimeKind_Quit');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Trial(),     inDescId:= zc_Object_WorkTimeKind(), inCode:= 8, inName:= '������� �����' , inEnumName:= 'zc_Enum_WorkTimeKind_Trial');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_DayOff(),    inDescId:= zc_Object_WorkTimeKind(), inCode:= 9, inName:= '��������'      , inEnumName:= 'zc_Enum_WorkTimeKind_DayOff');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Trip(),      inDescId:= zc_Object_WorkTimeKind(), inCode:= 15, inName:= '������������' , inEnumName:= 'zc_Enum_WorkTimeKind_Trip');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 13, inDescId:= zc_Object_WorkTimeKind(), inEnumName:= 'zc_Enum_WorkTimeKind_WorkD');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 14, inDescId:= zc_Object_WorkTimeKind(), inEnumName:= 'zc_Enum_WorkTimeKind_WorkN');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 17, inDescId:= zc_Object_WorkTimeKind(), inEnumName:= 'zc_Enum_WorkTimeKind_Audit');


     -- !!! ���� ������������ ���������� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Tax(),      		 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 1, inName:= '���������',                                                   inEnumName:= 'zc_Enum_DocumentTaxKind_Tax');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(),  inDescId:= zc_Object_DocumentTaxKind(), inCode:= 2, inName:= '������� ��������� �� ��.�.(����������)',                      inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), inDescId:= zc_Object_DocumentTaxKind(), inCode:= 3, inName:= '������� ��������� �� ��.�.(����������-��������)',             inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), 	 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 4, inName:= '������� ��������� �� �.�.(����������)',                       inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR(), 	 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 5, inName:= '������� ��������� �� �.�.(����������-��������)',              inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Corrective(), 	 		inDescId:= zc_Object_DocumentTaxKind(), inCode:= 6, inName:= '�������������',                                        inEnumName:= 'zc_Enum_DocumentTaxKind_Corrective');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR(),  inDescId:= zc_Object_DocumentTaxKind(), inCode:= 7, inName:= '������� ������������� �� ��.�.(��������)' ,            inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), inDescId:= zc_Object_DocumentTaxKind(), inCode:= 8, inName:= '������� ������������� �� ��.�.(����������-��������)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(),    inDescId:= zc_Object_DocumentTaxKind(), inCode:= 9, inName:= '������� ������������� �� �.�.(��������)' ,             inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR(),   inDescId:= zc_Object_DocumentTaxKind(), inCode:= 10, inName:= '������� ������������� �� �.�.(����������-��������)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectivePrice(),                 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 11, inName:= '�������������� ����',                              inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectivePrice');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical(), inDescId:= zc_Object_DocumentTaxKind(), inCode:= 12, inName:= '������� ������������� ���� �� ��.�.',              inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectivePriceSummaryPartner(),   inDescId:= zc_Object_DocumentTaxKind(), inCode:= 13, inName:= '������� ������������� ���� �� �����������', inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectivePriceSummaryPartner');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Prepay(),                          inDescId:= zc_Object_DocumentTaxKind(), inCode:= 14, inName:= '����������',                inEnumName:= 'zc_Enum_DocumentTaxKind_Prepay');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Goods(),                           inDescId:= zc_Object_DocumentTaxKind(), inCode:= 15, inName:= '���� ������������',        inEnumName:= 'zc_Enum_DocumentTaxKind_Goods');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Change(),                          inDescId:= zc_Object_DocumentTaxKind(), inCode:= 16, inName:= '�������� ����������������', inEnumName:= 'zc_Enum_DocumentTaxKind_Change');

     -- !!! ���� ������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_DaySheetWorkTime(),        inDescId:= zc_Object_ModelServiceKind(), inCode:= 1, inName:= '�� ���� ������'               , inEnumName:= 'zc_Enum_ModelServiceKind_DaySheetWorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_MonthSheetWorkTime(),      inDescId:= zc_Object_ModelServiceKind(), inCode:= 2, inName:= '�� ����� ������'              , inEnumName:= 'zc_Enum_ModelServiceKind_MonthSheetWorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_SatSheetWorkTime(),        inDescId:= zc_Object_ModelServiceKind(), inCode:= 3, inName:= '�� �������� ������'           , inEnumName:= 'zc_Enum_ModelServiceKind_SatSheetWorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_DayHoursSheetWorkTime(),   inDescId:= zc_Object_ModelServiceKind(), inCode:= 4, inName:= '�� ���� + �� ����� ������'    , inEnumName:= 'zc_Enum_ModelServiceKind_DayHoursSheetWorkTime');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_MonthFundPay(),       inDescId:= zc_Object_ModelServiceKind(), inCode:= 4, inName:= '�� ����� ����/�������'  , inEnumName:= 'zc_Enum_ModelServiceKind_MonthFundPay');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_TurnFundPay(),        inDescId:= zc_Object_ModelServiceKind(), inCode:= 5, inName:= '�� 1 ����� ����/�������', inEnumName:= 'zc_Enum_ModelServiceKind_TurnFundPay');
     -- SELECT lpInsertUpdate_ObjectString (inDescId:= zc_ObjectString_ModelServiceKind_Comment(), inObjectId:= zc_Enum_ModelServiceKind_DayHoursSheetWorkTime(), inValueData:= '�������� ��� ������ �������������� ��� ������� ��� � ���� ���������� ���������� ��� ��� �� ������ �� ���� ��������������� �����');

     -- !!! ���� ������ ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InWeight(),  inDescId:= zc_Object_SelectKind(), inCode:= 1, inName:= '���-�� ������ � ���������� � ���', inEnumName:= 'zc_Enum_SelectKind_InWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_OutWeight(), inDescId:= zc_Object_SelectKind(), inCode:= 2, inName:= '���-�� ������ � ���������� � ���', inEnumName:= 'zc_Enum_SelectKind_OutWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InAmount(),  inDescId:= zc_Object_SelectKind(), inCode:= 3, inName:= '���-�� ������',                    inEnumName:= 'zc_Enum_SelectKind_InAmount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_OutAmount(), inDescId:= zc_Object_SelectKind(), inCode:= 4, inName:= '���-�� ������',                    inEnumName:= 'zc_Enum_SelectKind_OutAmount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InPack(),    inDescId:= zc_Object_SelectKind(), inCode:= 5, inName:= '���-�� �������� ������ (������)',  inEnumName:= 'zc_Enum_SelectKind_InPack');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InHead(),    inDescId:= zc_Object_SelectKind(), inCode:= 6, inName:= '���-�� ����� ������',              inEnumName:= 'zc_Enum_SelectKind_InHead');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_OutHead(),   inDescId:= zc_Object_SelectKind(), inCode:= 7, inName:= '���-�� ����� ������',              inEnumName:= 'zc_Enum_SelectKind_OutHead');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_MI_Master(),      inDescId:= zc_Object_SelectKind(), inCode:= 8,  inName:= '���-�� ��� �� ���������� �����.',   inEnumName:= 'zc_Enum_SelectKind_MI_Master');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_MI_MasterSh(),    inDescId:= zc_Object_SelectKind(), inCode:= 14, inName:= '���-�� ���� �� ���������� ������.', inEnumName:= 'zc_Enum_SelectKind_MI_MasterSh');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_MI_MasterCount(), inDescId:= zc_Object_SelectKind(), inCode:= 9,  inName:= '���-�� ����� �� ���������� �����.', inEnumName:= 'zc_Enum_SelectKind_MI_MasterCount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_MovementCount(),  inDescId:= zc_Object_SelectKind(), inCode:= 10, inName:= '���-�� ���������� �����.',          inEnumName:= 'zc_Enum_SelectKind_MovementCount');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_MovementTransportHours(), inDescId:= zc_Object_SelectKind(), inCode:= 11, inName:= '��������� - ������� ����� �� �������� �����', inEnumName:= 'zc_Enum_SelectKind_MovementTransportHours');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_MovementReestrWeight(),   inDescId:= zc_Object_SelectKind(), inCode:= 12, inName:= '��������� - ���-�� ��� (������)',             inEnumName:= 'zc_Enum_SelectKind_MovementReestrWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_MovementReestrDoc(),      inDescId:= zc_Object_SelectKind(), inCode:= 13, inName:= '��������� - ���-�� ���������� (������)',      inEnumName:= 'zc_Enum_SelectKind_MovementReestrDoc');

     -- !!! ���� ���� ��� �������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_MonthDay(),        inDescId:= zc_Object_StaffListSummKind(), inCode:= 1, inName:= '���� �� ����� (�� ����)'                                  , inEnumName:= 'zc_Enum_StaffListSummKind_MonthDay');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Month(),           inDescId:= zc_Object_StaffListSummKind(), inCode:= 2, inName:= '���� �� �����'                                            , inEnumName:= 'zc_Enum_StaffListSummKind_Month');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Day(),             inDescId:= zc_Object_StaffListSummKind(), inCode:= 3, inName:= '������� �� 1 ���� �� ����'                                , inEnumName:= 'zc_Enum_StaffListSummKind_Day');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Personal(),        inDescId:= zc_Object_StaffListSummKind(), inCode:= 4, inName:= '������� �� 1 ���� �� ��������'                            , inEnumName:= 'zc_Enum_StaffListSummKind_Personal');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursPlan(),       inDescId:= zc_Object_StaffListSummKind(), inCode:= 5, inName:= '���� �� ����� ���� ����� (����������) � ����� �� ��������', inEnumName:= 'zc_Enum_StaffListSummKind_HoursPlan');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursDay(),        inDescId:= zc_Object_StaffListSummKind(), inCode:= 6, inName:= '���� �� ���� ����� (���������) � ����� �� ��������'       , inEnumName:= 'zc_Enum_StaffListSummKind_HoursDay');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursPlanConst(),  inDescId:= zc_Object_StaffListSummKind(), inCode:= 7, inName:= '���� ���������� ��� ���� ����� � ����� �� ��������'       , inEnumName:= 'zc_Enum_StaffListSummKind_HoursPlanConst');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursDayConst(),   inDescId:= zc_Object_StaffListSummKind(), inCode:= 7, inName:= '(�� ������������).���� ���������� ��� ���� ����� � ������� ��� �� ��������' , inEnumName:= 'zc_Enum_StaffListSummKind_HoursDayConst');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_WorkHours(),       inDescId:= zc_Object_StaffListSummKind(), inCode:= 11,inName:= '(�� ������������).���������� ������� ����� � ����'                          , inEnumName:= 'zc_Enum_StaffListSummKind_WorkHours');


     -- !!! ��������� ��������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Signed(), inDescId:= zc_Object_ContractStateKind(), inCode:= 1, inName:= '��������' , inEnumName:= 'zc_Enum_ContractStateKind_Signed');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_UnSigned(), inDescId:= zc_Object_ContractStateKind(), inCode:= 2, inName:= '�� ��������' , inEnumName:= 'zc_Enum_ContractStateKind_UnSigned');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Close(), inDescId:= zc_Object_ContractStateKind(), inCode:= 3, inName:= '��������' , inEnumName:= 'zc_Enum_ContractStateKind_Close');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Partner(), inDescId:= zc_Object_ContractStateKind(), inCode:= 4, inName:= '� �����������' , inEnumName:= 'zc_Enum_ContractStateKind_Partner');
     
     -- !!! ���� ������� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_ChangePercent()         , inDescId:= zc_Object_ContractConditionKind(), inCode:= 1,   inName:= '(-)% ������ (+)% �������'               , inEnumName:= 'zc_Enum_ContractConditionKind_ChangePercent');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_ChangePercentPartner()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 101, inName:= '% ������� ��������� (������ ����������)', inEnumName:= 'zc_Enum_ContractConditionKind_ChangePercentPartner');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_ChangePrice()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 2,   inName:= '������ � ���� ���'                      , inEnumName:= 'zc_Enum_ContractConditionKind_ChangePrice');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayDayCalendar()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 3,  inName:= '�������� � ����������� ����'               , inEnumName:= 'zc_Enum_ContractConditionKind_DelayDayCalendar');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayDayBank()          , inDescId:= zc_Object_ContractConditionKind(), inCode:= 4,  inName:= '�������� � ���������� ����'                , inEnumName:= 'zc_Enum_ContractConditionKind_DelayDayBank');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayCreditLimit()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 5,  inName:= '�������� �������� ������'                  , inEnumName:= 'zc_Enum_ContractConditionKind_DelayCreditLimit');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayPrepay()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 6,  inName:= '����������'                                , inEnumName:= 'zc_Enum_ContractConditionKind_DelayPrepay');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercent()         , inDescId:= zc_Object_ContractConditionKind(), inCode:= 11,  inName:= '% �� �������'                      , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercent');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditLimit()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 12,  inName:= '����� �������'                     , inEnumName:= 'zc_Enum_ContractConditionKind_CreditLimit');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercentService()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 13,  inName:= '% �� ������/������������ �������'  , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercentService');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercentReceived() , inDescId:= zc_Object_ContractConditionKind(), inCode:= 14,  inName:= '% �� ����� �� �������'             , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercentReceived');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentSale()             , inDescId:= zc_Object_ContractConditionKind(), inCode:= 21, inName:= '% ������ �� ��������'         , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentSale');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentSaleReturn()       , inDescId:= zc_Object_ContractConditionKind(), inCode:= 22, inName:= '% ������ �� ��������-�������' , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentSaleReturn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentAccount()          , inDescId:= zc_Object_ContractConditionKind(), inCode:= 23, inName:= '% ������ �� ������'           , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentAccount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 23, inName:= '% ������ �� ������'           , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusMonthlyPayment()          , inDescId:= zc_Object_ContractConditionKind(), inCode:= 24, inName:= '����� - ����������� ������'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusMonthlyPayment');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv()       , inDescId:= zc_Object_ContractConditionKind(), inCode:= 25, inName:= '������� - ����������� ������'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT()          , inDescId:= zc_Object_ContractConditionKind(), inCode:= 26, inName:= '������ �����,��� ���������� ����� ������ (�� ����� � ���)'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT()          , inDescId:= zc_Object_ContractConditionKind(), inCode:= 27, inName:= '������ �����,��� ���������� ����� ������ (�� ����� ��� ���)' , inEnumName:= 'zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusYearlyPayment()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 28, inName:= '������� ������'               , inEnumName:= 'zc_Enum_ContractConditionKind_BonusYearlyPayment');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_LimitReturn()                  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 29, inName:= '����������� �� ���������'     , inEnumName:= 'zc_Enum_ContractConditionKind_LimitReturn');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentIncome()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 30, inName:= '����� ������, ������ �� ��'         , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentIncome');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentIncomeReturn(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 31, inName:= '����� ������-�������, ������ �� ��' , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentIncomeReturn');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime1()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 101, inName:= '������ �� ����� (��� ����������� � �������������), ���/�'  , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime1');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime2()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 102, inName:= '������ �� ����� (� ������������ ��� ������������), ���/�'  , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime2');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime3()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 103, inName:= '������ �� ����� (��� ����������� ��� ������������), ���/�' , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime3');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime4()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 104, inName:= '������ �� ����� (� ������������ � �������������), ���/�'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime4');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime5()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 105, inName:= '������ �� ����� (�������� � ������������), ���/�'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime5');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime6()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 106, inName:= '������ �� ����� (�������� ��� �����������), ���/�'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime6');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime7()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 107, inName:= '������ �� ����� (����� ���������� � ������������), ���/�'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime7');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime8()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 108, inName:= '������ �� ����� (����� ���������� ��� �����������), ���/�'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime8');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportDistance()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 115, inName:= '������ �� ������, ���/��'         , inEnumName:= 'zc_Enum_ContractConditionKind_TransportDistance');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportDistanceInt() , inDescId:= zc_Object_ContractConditionKind(), inCode:= 116, inName:= '������ �� ������, ���/�� �����'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportDistanceInt');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportDistanceExt() , inDescId:= zc_Object_ContractConditionKind(), inCode:= 117, inName:= '������ �� ������, ���/�� ��������', inEnumName:= 'zc_Enum_ContractConditionKind_TransportDistanceExt');
     
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportOneTrip()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 118, inName:= '������ �� ������� � ���� �������, ���',       inEnumName:= 'zc_Enum_ContractConditionKind_TransportOneTrip');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportOneTrip10(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 119, inName:= '������ �� ������� 10�., ���' ,                inEnumName:= 'zc_Enum_ContractConditionKind_TransportOneTrip10');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportOneTrip20(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 120, inName:= '������ �� ������� 20�., ���' ,                inEnumName:= 'zc_Enum_ContractConditionKind_TransportOneTrip20');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportRoundTrip(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 122, inName:= '������ �� ������� � ��� �������, ���',        inEnumName:= 'zc_Enum_ContractConditionKind_TransportRoundTrip');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportOneDay(),    inDescId:= zc_Object_ContractConditionKind(), inCode:= 123, inName:= '������ �� ������� � ����, ���',               inEnumName:= 'zc_Enum_ContractConditionKind_TransportOneDay');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportOneDayCon(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 124, inName:= '������ �� ������� � ���� + �����������, ���', inEnumName:= 'zc_Enum_ContractConditionKind_TransportOneDayCon');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportPoint()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 131, inName:= '������ �� �����, ���',                        inEnumName:= 'zc_Enum_ContractConditionKind_TransportPoint');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportWeight()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 132, inName:= '������ �� �����, ���/��',                     inEnumName:= 'zc_Enum_ContractConditionKind_TransportWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportForward()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 133, inName:= '������� �� �����������, ���/�����',           inEnumName:= 'zc_Enum_ContractConditionKind_TransportForward');
     

     -- !!! ���� ����������� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractTermKind_Long(), inDescId:= zc_Object_ContractTermKind(), inCode:= 1, inName:= '����������' , inEnumName:= 'zc_Enum_ContractTermKind_Long');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractTermKind_Month(), inDescId:= zc_Object_ContractTermKind(), inCode:= 2, inName:= '�� ������ � �������' , inEnumName:= 'zc_Enum_ContractTermKind_Month');
   

     -- !!! ���� ��������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReceiptKind_Complete(),  inDescId:= zc_Object_ReceiptKind(), inCode:= 1, inName:= '����������', inEnumName:= 'zc_Enum_ReceiptKind_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReceiptKind_Separate(), inDescId:= zc_Object_ReceiptKind(), inCode:= 2, inName:= '����������',  inEnumName:= 'zc_Enum_ReceiptKind_Separate');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReceiptKind_CompleteEtalon(), inDescId:= zc_Object_ReceiptKind(), inCode:= 3, inName:= '���������� (���������)',inEnumName:= 'zc_Enum_ReceiptKind_CompleteEtalon');


     -- !!!
     -- !!! ���� �������
     -- !!!
     -- PERFORM lpUpdate_Object_Enum_byCode (inCode:= 1,  inDescId:= zc_Object_GoodsKind(), inEnumName:= 'zc_Enum_GoodsKind_Main');

     -- !!!
     -- !!! ������: 1-������� �������������� ������
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_10000');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_20000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_30000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_40000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_50000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 51000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_51000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_60000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_70000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_80000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 90000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_90000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 100000, inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_100000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110000, inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_110000');

     -- !!!
     -- !!! ������: 2-������� �������������� ������
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_10100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_10200');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20500,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20600,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20700,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20700');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20800,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20800');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20900,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20900');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30150,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30150');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30500,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30600,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30700,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_30700');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40500,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40600,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40700,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40700');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40800,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_40800');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_50100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_50200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_50300');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_60100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_60200');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70500,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70700,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70700');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70800,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70800');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70900,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_70900');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 71000,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_71000');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_80100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_80200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_80400');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 90100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_90100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 90200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_90200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 90300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_90300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 90400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_90400');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 100400,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_100400');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_110300');

     -- !!!
     -- !!! ������: �������������� ����� (1+2+3 �������)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10101, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_10101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10201, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_10201');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20901, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_20901');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30101, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30151, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30151');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30201, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30202, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30203, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30203');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30204, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30204');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30205, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30205');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40101, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40102, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40201, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40202, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40301, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40301');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40302, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40302');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_40303(),  inDescId:= zc_Object_Account(), inCode:= 40303, inName:= '��������� ���� ��������', inEnumName:= 'zc_Enum_Account_40303');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40303, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40303');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40401, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40401');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_40501(),  inDescId:= zc_Object_Account(), inCode:= 40501, inName:= '����� ��', inEnumName:= 'zc_Enum_Account_40501');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40501, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40501');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40601, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40601');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40701, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40701');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40801, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_40801');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50401, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_50401');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 51101, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_51101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 51201, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_51201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60301, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_60301');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 100301, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_100301');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 100401, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_100401');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110101, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110102, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110111, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110111');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110112, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110112');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110121, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110121');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110122, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110122');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110131, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110131');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110132, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110132');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110151, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110151');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110152, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110152');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110153, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110153');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110161, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110161');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110162, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110162');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110171, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110171');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110172, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110172');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110173, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110173');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110181, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110181');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110182, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110182');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110201, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110301, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110301');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110302, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110302');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 110401, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_110401');

     -- !!!
     -- !!! ��: 1-������� �������������� ������ ����������
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_10000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_20000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_30000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_40000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_50000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_60000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_70000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_80000');

     -- !!!
     -- !!! ��: 2-������� �������������� ����������
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10200');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20600, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20700, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20700');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20800, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20800');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20900, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20900');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21000, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21150, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21150');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21600, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_21600');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_30100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_30200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_30300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_30400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_30500');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40200');
     -- PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40600, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40700, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40700');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40800, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40800');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40900, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_40900');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 41000, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_41000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 41100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_41100');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_50100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_50200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_50300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_50400');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_70100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_70200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_70300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_70400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_70500');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_80300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_80500');

     -- !!!
     -- !!! ��: �������������� ������ ���������� (1+2+3 �������)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10102, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10105, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10105');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10106, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10106');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10201, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10202, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10203, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10203');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10204, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10204');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20401, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_20401');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21425, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21425');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20501, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_20501');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20601, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_20601');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20801, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_20801');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20901, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_20901');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21001, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21001');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21151, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21151');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21201, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21419, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21419');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21501, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21501');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21502, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21502');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 21505, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_21505');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_30101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30102, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_30102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30103, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_30103');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30201, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_30201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30301, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_30301');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30501, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_30501');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30503, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_30503');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40801, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_40801');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 41001, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_41001');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_50101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50102, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_50102');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50201, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_50201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50202, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_50202');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_60101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60102, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_60102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60103, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_60103');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60104, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_60104');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70102, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70103, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70103');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70104, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70104');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70201, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70202, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70203, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70203');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70204, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_70204');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80301, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_80301');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80401, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_80401');

     -- !!!
     -- !!! ����: 1-������� (������ ����)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_10000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_20000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_30000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_40000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_50000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_60000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_65000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_70000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_80000');
     
     -- !!!
     -- !!! ����: 2-������� (��������� ���� - �����������)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10400, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10500, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10700, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10700');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10800, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10800');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10900, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10900');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 11100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_11100');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_20100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_20200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_20300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20400, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_20400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20500, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_20500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20600, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_20600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20700, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_20700');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_30100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_30200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_30300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30400, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_30400');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_40100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_40200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_40300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40400, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_40400');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_50100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_50200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_50300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50400, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_50400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50500, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_50500');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_60100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_60200');
   --PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_60300');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_65100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_65200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_65300');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_70100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70110, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_70110');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_70200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_70300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70400, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_70400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70500, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_70500');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_80100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_80200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_80300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80400, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_80400');

     -- !!!
     -- !!! ����: ������ (1+2+3 �������)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10101, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10102, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10201, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10202, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10251, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10251');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10252, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10252');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10301, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10301');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10302, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10302');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10401, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10401');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10402, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10402');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10501, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10501');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10502, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10502');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10701, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10701');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10702, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10702');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10801, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10801');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10802, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10802');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10901, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10901');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10902, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10902');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 11101, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_11101');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20204, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_20204');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40208, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_40208');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50101, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_50101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50201, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_50201');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60101, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_60101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60201, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_60201');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65101, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_65101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65102, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_65102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65103, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_65103');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65201, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_65201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65202, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_65202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 65203, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_65203');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70101, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70102, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70103, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70103');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70104, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70104');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70111, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70111');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70112, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70112');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70201, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70202, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70203, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70203');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70215, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70215');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70501, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_70501');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80103, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_80103');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ProfitLoss_80105(),  inDescId:= zc_Object_ProfitLoss(), inCode:= 80105, inName:= '������� ��� �������/������� ������', inEnumName:= 'zc_Enum_ProfitLoss_80105');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80105, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_80105');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80301, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_80301');

END $$;

DO $$
BEGIN

   --- !!! ���� �������� ������� �����������
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ModelServiceKind_Comment(),  zc_Enum_ModelServiceKind_DaySheetWorkTime(),   '�������� ��� ������ �������������� ��� ������� ��� � ���� ���������� ���������� ��� ��� �� ������ �� ����');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ModelServiceKind_Comment(),  zc_Enum_ModelServiceKind_MonthSheetWorkTime(), '�������� ��� ������ �������������� ����� �� ����� � ���� ���������� ���������� ��� ���� ��� �� ������ �� �����');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ModelServiceKind_Comment(),  zc_Enum_ModelServiceKind_SatSheetWorkTime(),   '�������� ��� ������ �������������� ������ ��� ���� "�������" � ���� ���������� ���������� ��� ��� �� ������ �� ���� "�������"');

     --- !!! ���� �������� ������� �����������
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_Month(),         '1,2,3 �� �����.�� ����� ��� ����� ����� ���������(������������ � ��������� ���� ���� �� ���-�� �����) �� ���� ��� ������� � ������.');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_Day(),           '1,2,3 �� �����.�� ���� ��� ����� ����� ���������(������������ � ��������� ���� ����� �� ���-�� �����) �� ���� ��� ������� � ������.');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_Personal(),      '1,2,3 �� �����.�� ���� ��� ����� ����� ��������� ������� ��� ������� � ������.');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursPlan(),     '1-�����,2,3 �� �����.�� ����� ���������(���� ����=����/1-�����) ����� ����� ��������� �� ������� "���� �����"*"���� ����" ������� ��� ������� � ������.(�������� �����������-�������).');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursDay(),      '2-�����,1,3 �� �����.�� ����� ���������(���� ����=����/2-�����*�.��.)����� ����� ��������� �� ������� "���� �����"*"���� ����" ������� ��� ������� � ������.(�������� �����������-�������).');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursPlanConst(),'1,2,3 �� �����.�� ����� ��� ����� ����� ��������� (�������������� � ��������� ���� ����� ��������) ������� ��� ������� � ������.');
     -- PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursDayConst(), '(�� ������������).�� ����� ��� ����� ����� ��������� � ��������� ����/����_�����*�.��. ������� ��� ������� � ������.');
     -- PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_WorkHours(),     '(�� ������������).������������ ��� ������� ����� �� ���� ����� � ������� ��� �� ��������.');
     
     -- !!! ���� ���
     -- !!! ���� ���
--     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_NDSKind_Common(),  inDescId:= zc_Object_NDSKind(), inCode:= 1, inName:= '20% - ����� ���������', inEnumName:= 'zc_Enum_NDSKind_Common');
  --   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_NDSKind_Medical(), inDescId:= zc_Object_NDSKind(), inCode:= 2, inName:= '7% - �����������', inEnumName:= 'zc_Enum_NDSKind_Medical');

    -- PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_NDSKind_Common(), 20);
     --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_NDSKind_Medical(), 7);

     -- !!! ���� �������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_Excel(),  inDescId:= zc_Object_FileTypeKind(), inCode:= 1, inName:= 'Excel', inEnumName:= 'zc_Enum_FileTypeKind_Excel');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_DBF(), inDescId:= zc_Object_FileTypeKind(), inCode:= 2, inName:= 'DBF', inEnumName:= 'zc_Enum_FileTypeKind_DBF');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_MMO(), inDescId:= zc_Object_FileTypeKind(), inCode:= 3, inName:= 'MMO', inEnumName:= 'zc_Enum_FileTypeKind_MMO');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_ODBC(), inDescId:= zc_Object_FileTypeKind(), inCode:= 4, inName:= 'ODBC', inEnumName:= 'zc_Enum_FileTypeKind_ODBC');
     

     -- !!!
     -- !!! ���� ������
     -- !!!

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UnitJuridical(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 1, inName:= '����� ������������� ��� �����������', inEnumName:= 'zc_Enum_ImportExportLinkType_UnitJuridical');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UnitUnitId(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 2, inName:= '����� ������������� �� ������ �������', inEnumName:= 'zc_Enum_ImportExportLinkType_UnitUnitId');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_DefaultFileName(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 3, inName:= '��� ����� �� ���������', inEnumName:= 'zc_Enum_ImportExportLinkType_DefaultFileName');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UnitEmailSign(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 4, inName:= '������� ��� �������������', inEnumName:= 'zc_Enum_ImportExportLinkType_UnitEmailSign');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_ClientEmailSubject(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 5, inName:= '���� ������', inEnumName:= 'zc_Enum_ImportExportLinkType_ClientEmailSubject');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_OldClientLink(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 6, inName:= '����� ����������� �� ������ �������', inEnumName:= 'zc_Enum_ImportExportLinkType_OldClientLink');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UploadCompliance(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 7, inName:= '����� �������� � ������ � ������� ������� ���������� ��� ��������', inEnumName:= 'zc_Enum_ImportExportLinkType_UploadCompliance');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_QlikView(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 8, inName:= '� ����� � ������������� ��� QlikView', inEnumName:= 'zc_Enum_ImportExportLinkType_QlikView');
 
END $$;

DO $$
BEGIN
   -- ���� ����� !!!�������� �����!!!
   -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoKind_Custom(),  inDescId:= zc_Object_PromoKind(), inCode:= 1, inName:= '�������', inEnumName:= 'zc_Enum_PromoKind_Custom');
   -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoKind_Compensation(),  inDescId:= zc_Object_PromoKind(), inCode:= 2, inName:= '� ���� �������������� �������', inEnumName:= 'zc_Enum_PromoKind_Compensation');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoKind_Budget(),  inDescId:= zc_Object_PromoKind(), inCode:= 1, inName:= '� ���� �������������� �������', inEnumName:= 'zc_Enum_PromoKind_Budget');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoKind_BudgetBill(),  inDescId:= zc_Object_PromoKind(), inCode:= 2, inName:= '� ���� �������������� ������� �� ������������� �����', inEnumName:= 'zc_Enum_PromoKind_BudgetBill');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoKind_Bill(),  inDescId:= zc_Object_PromoKind(), inCode:= 3, inName:= '�� ������������� �����', inEnumName:= 'zc_Enum_PromoKind_Bill');

   -- ������� �������   
   -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConditionPromo_Discount(),  inDescId:= zc_Object_ConditionPromo(), inCode:= 1, inName:= '������', inEnumName:= 'zc_Enum_ConditionPromo_Discount');
   -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConditionPromo_BudgetBill()              , inDescId:= zc_Object_ConditionPromo(), inCode:= 3, inName:= '� ���� �������������� ������� �� ������������� �����', inEnumName:= 'zc_Enum_ConditionPromo_BudgetBill');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConditionPromo_Budget()                  , inDescId:= zc_Object_ConditionPromo(), inCode:= 1, inName:= '����������� � ���� �������������� �������'   , inEnumName:= 'zc_Enum_ConditionPromo_Budget');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConditionPromo_Bill()                    , inDescId:= zc_Object_ConditionPromo(), inCode:= 2, inName:= '����������� �� ����� �� ������ ������'       , inEnumName:= 'zc_Enum_ConditionPromo_Bill');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConditionPromo_ContractChangePercentOff(), inDescId:= zc_Object_ConditionPromo(), inCode:= 3, inName:= '��� ����� % ������ �� ��������'              , inEnumName:= 'zc_Enum_ConditionPromo_ContractChangePercentOff');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConditionPromo_BonusOff()                , inDescId:= zc_Object_ConditionPromo(), inCode:= 4, inName:= '�������������� ������ ��� ���������� �������', inEnumName:= 'zc_Enum_ConditionPromo_BonusOff');

END $$;

DO $$
BEGIN

     -- !!! ��������� ��������� ��� �����
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailTools_Host(),     inDescId:= zc_Object_EmailTools(), inCode:= 1, inName:= 'Host'                          , inEnumName:= 'zc_Enum_EmailTools_Host');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailTools_Port(),     inDescId:= zc_Object_EmailTools(), inCode:= 2, inName:= 'Port'                          , inEnumName:= 'zc_Enum_EmailTools_Port');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailTools_Mail(),     inDescId:= zc_Object_EmailTools(), inCode:= 3, inName:= '�����'                         , inEnumName:= 'zc_Enum_EmailTools_Mail');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailTools_User(),     inDescId:= zc_Object_EmailTools(), inCode:= 4, inName:= 'User'                          , inEnumName:= 'zc_Enum_EmailTools_User');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailTools_Password(), inDescId:= zc_Object_EmailTools(), inCode:= 5, inName:= 'Password'                      , inEnumName:= 'zc_Enum_EmailTools_Password');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailTools_Directory(),inDescId:= zc_Object_EmailTools(), inCode:= 6, inName:= '���������� ������������ ������', inEnumName:= 'zc_Enum_EmailTools_Directory');
    

END $$;



DO $$
BEGIN

     -- !!! ���� �������� ��� �����
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ExportKind_Mida35273055() ,  inDescId:= zc_Object_ExportKind(), inCode:= 1, inName:= '���� - ������ XML'    ,    inEnumName:= 'zc_Enum_ExportKind_Mida35273055');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ExportKind_Vez37171990()  ,  inDescId:= zc_Object_ExportKind(), inCode:= 2, inName:= '�������� - ������ CSV',    inEnumName:= 'zc_Enum_ExportKind_Vez37171990');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ExportKind_Brusn34604386(),  inDescId:= zc_Object_ExportKind(), inCode:= 3, inName:= '��������� - ������ CSV',   inEnumName:= 'zc_Enum_ExportKind_Brusn34604386');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ExportKind_Dakort39135074(), inDescId:= zc_Object_ExportKind(), inCode:= 4, inName:= '������ - ������ CSV',      inEnumName:= 'zc_Enum_ExportKind_Dakort39135074');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ExportKind_Glad2514900150(), inDescId:= zc_Object_ExportKind(), inCode:= 5, inName:= '��� ������� - ������ XML', inEnumName:= 'zc_Enum_ExportKind_Glad2514900150');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ExportKind_Avion40110917(),  inDescId:= zc_Object_ExportKind(), inCode:= 6, inName:= '����+ ��� - ������ CSV',  inEnumName:= 'zc_Enum_ExportKind_Avion40110917');

END $$;

DO $$
BEGIN
     -- !!! ���� ��������� �� �������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_PartnerOut() , inDescId:= zc_Object_ReestrKind(), inCode:= 1, inName:= '�������� �� ������'         , inEnumName:= 'zc_Enum_ReestrKind_PartnerOut');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_PartnerIn()  , inDescId:= zc_Object_ReestrKind(), inCode:= 2, inName:= '�������� �� �������'        , inEnumName:= 'zc_Enum_ReestrKind_PartnerIn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_RemakeIn()   , inDescId:= zc_Object_ReestrKind(), inCode:= 3, inName:= '�������� ��� ���������'     , inEnumName:= 'zc_Enum_ReestrKind_RemakeIn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_RemakeBuh()  , inDescId:= zc_Object_ReestrKind(), inCode:= 4, inName:= '����������� ��� �����������', inEnumName:= 'zc_Enum_ReestrKind_RemakeBuh');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_Remake()     , inDescId:= zc_Object_ReestrKind(), inCode:= 5, inName:= '�������� ���������'         , inEnumName:= 'zc_Enum_ReestrKind_Remake');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_Buh()        , inDescId:= zc_Object_ReestrKind(), inCode:= 6, inName:= '�����������'                , inEnumName:= 'zc_Enum_ReestrKind_Buh');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_TransferIn() , inDescId:= zc_Object_ReestrKind(), inCode:= 7, inName:= '������� �������'            , inEnumName:= 'zc_Enum_ReestrKind_TransferIn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_TransferOut(), inDescId:= zc_Object_ReestrKind(), inCode:= 8, inName:= '������� ���������'          , inEnumName:= 'zc_Enum_ReestrKind_TransferOut');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_Log()        , inDescId:= zc_Object_ReestrKind(), inCode:= 9, inName:= '����� ���������'            , inEnumName:= 'zc_Enum_ReestrKind_Log');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_Econom()     , inDescId:= zc_Object_ReestrKind(), inCode:= 10,inName:= '����������'                 , inEnumName:= 'zc_Enum_ReestrKind_Econom');
     
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_EconomIn()   , inDescId:= zc_Object_ReestrKind(), inCode:= 11,inName:= '���������� (� ������)'      , inEnumName:= 'zc_Enum_ReestrKind_EconomIn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_EconomOut()  , inDescId:= zc_Object_ReestrKind(), inCode:= 12,inName:= '���������� (��� ���������)' , inEnumName:= 'zc_Enum_ReestrKind_EconomOut');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_Snab()       , inDescId:= zc_Object_ReestrKind(), inCode:= 13,inName:= '��������� (� ������)'       , inEnumName:= 'zc_Enum_ReestrKind_Snab');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ReestrKind_SnabRe()     , inDescId:= zc_Object_ReestrKind(), inCode:= 14,inName:= '��������� (��� ���������)'  , inEnumName:= 'zc_Enum_ReestrKind_SnabRe');
END $$;


DO $$
BEGIN

     -- !!! ���� ����
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DayKind_Calendar() , inDescId:= zc_Object_DayKind(), inCode:= 1, inName:= '�� ���������'    , inEnumName:= 'zc_Enum_DayKind_Calendar');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DayKind_Week(   )  , inDescId:= zc_Object_DayKind(), inCode:= 2, inName:= '�� ���� ������'  , inEnumName:= 'zc_Enum_DayKind_Week');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DayKind_Period()   , inDescId:= zc_Object_DayKind(), inCode:= 3, inName:= '��������� ������', inEnumName:= 'zc_Enum_DayKind_Period');


END $$;

DO $$
BEGIN
     -- !!! ��������� ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GoodsTypeKind_Sh()  , inDescId:= zc_Object_GoodsTypeKind(), inCode:= 1, inName:= '�������'      , inEnumName:= 'zc_Enum_GoodsTypeKind_Sh');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GoodsTypeKind_Nom() , inDescId:= zc_Object_GoodsTypeKind(), inCode:= 2, inName:= '�����������'  , inEnumName:= 'zc_Enum_GoodsTypeKind_Nom');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GoodsTypeKind_Ves() , inDescId:= zc_Object_GoodsTypeKind(), inCode:= 3, inName:= '�������������', inEnumName:= 'zc_Enum_GoodsTypeKind_Ves');
END $$;

DO $$
BEGIN

     -- !!! ��������� �����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ClientKind_Retail()   , inDescId:= zc_Object_ClientKind(), inCode:= 1, inName:= '�������'           , inEnumName:= 'zc_Enum_ClientKind_Retail');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ClientKind_Partner()  , inDescId:= zc_Object_ClientKind(), inCode:= 2, inName:= '������'            , inEnumName:= 'zc_Enum_ClientKind_Partner');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ClientKind_Unit()     , inDescId:= zc_Object_ClientKind(), inCode:= 3, inName:= '������������ �����', inEnumName:= 'zc_Enum_ClientKind_Unit');


END $$;

DO $$
BEGIN
   -- !!! ��������� ����� 
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoStateKind_Start(),     inDescId:= zc_Object_PromoStateKind(), inCode:= 1, inName:= '� ������ ����� ����������', inEnumName:= 'zc_Enum_PromoStateKind_Start');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoStateKind_Head(),      inDescId:= zc_Object_PromoStateKind(), inCode:= 2, inName:= '� ������ �������� �� ����������', inEnumName:= 'zc_Enum_PromoStateKind_Head');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoStateKind_Main(),      inDescId:= zc_Object_PromoStateKind(), inCode:= 3, inName:= '� ������ �������������� ��������', inEnumName:= 'zc_Enum_PromoStateKind_Main');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoStateKind_Complete(),  inDescId:= zc_Object_PromoStateKind(), inCode:= 4, inName:= '����������', inEnumName:= 'zc_Enum_PromoStateKind_Complete');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoStateKind_Canceled(),  inDescId:= zc_Object_PromoStateKind(), inCode:= 5, inName:= '�������', inEnumName:= 'zc_Enum_PromoStateKind_Canceled');
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PromoStateKind_Return(),    inDescId:= zc_Object_PromoStateKind(), inCode:= 6, inName:= '������� ��� �����������', inEnumName:= 'zc_Enum_PromoStateKind_Return');
END $$;

/* �����������, �.�. 1 ��� �������� � ����
--�������� � �������� <��������� ���������� ��������>
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PersonalService() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PersonalService() ;
    -- ������� ��� �������� 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� �������� �� � ������ � �������� <���������� ��������>',
                                                       inProcedureName := 'gpInsertUpdate_MI_PersonalService_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PersonalService');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0)::Integer,
                                                              inCode         := COALESCE(vbImportSettingCode,0)::Integer,
                                                              inName         := '�������� �������� �� � ������ � �������� <���������� ��������>'::TVarChar,
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel() ::Integer,
                                                              inImportTypeId := vbImportTypeId ::Integer,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()) ::Integer,
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()) ::Integer,
                                                              inStartRow     := 2 ::Integer,
                                                              inHDR          := False ::Boolean ,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0 ::TFloat,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad())::Boolean,
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PersonalService');

    --��������� �����
    -- 1
    vbImportTypeItemId := 0;
    vbImportTypeItemId:= (SELECT Id FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMovementId');
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inMovementId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Id ���������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    vbImportSettingsItem := (SELECT Id FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId);
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    -- 2
    vbImportTypeItemId := 0;
    vbImportTypeItemId:= (SELECT Id FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inINN');
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inINN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    vbImportSettingsItem := (SELECT Id FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId);
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    -- 3
    vbImportTypeItemId := 0;
    vbImportTypeItemId:= (SELECT Id FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFIO');
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inFIO', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    vbImportSettingsItem := (SELECT Id FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId);
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    -- 4
    vbImportTypeItemId := 0;
    vbImportTypeItemId:= (SELECT Id FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inSummNalogRecalc');
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inSummNalogRecalc', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����� ������ - ��������� � �� ��� �������������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    vbImportSettingsItem := (SELECT Id FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId);
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
    -- 5
    vbImportTypeItemId := 0;
    vbImportTypeItemId:= (SELECT Id FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inSummCardRecalc1');
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inSummCardRecalc1', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '�����1 �� �������� (��) ��� �������������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    vbImportSettingsItem := (SELECT Id FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId);
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
                                              
    -- 6
    vbImportTypeItemId := 0;
    vbImportTypeItemId:= (SELECT Id FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inSummCardRecalc2');
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inSummCardRecalc2', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '�����2 �� �������� (��) ��� �������������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    vbImportSettingsItem := (SELECT Id FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId);
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := '0',
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_PersonalService Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPersonalServiceForm;zc_Object_ImportSetting_PersonalService';

    -- ��������� ���� �������
    vbDefaultKeyId:= (SELECT Id FROM DefaultKeys WHERE Key = vbKey);

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
       INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPersonalServiceForm","DescName":"zc_Object_ImportSetting_PersonalService"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    vbId:= (SELECT ID FROM DefaultValue  WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL);
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PersonalService()::TBlob, inSession := ''::TVarChar);

END $$;

*/
--��������� ������ ������ �� ��� �����
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MobileBillsJournal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MobileBillsJournal() ;
    -- ������� ��� �������� ������ 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ������ �� �������� �� ���.�����', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_MobileBills_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MobileBillsJournal');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ������ �� �������� �� ���.�����',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MobileBillsJournal');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := '���� ���������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inContractId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inContractId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '������������� ���������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMobileNum';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inMobileNum', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '� ��������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inTotalSum';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inTotalSum', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����� �����', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                         
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MobileBillsJournal Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TMobileBillsJournalForm;zc_Object_ImportSetting_MobileBillsJournal';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TMobileBillsJournalForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MobileBillsJournal()::TBlob, inSession := ''::TVarChar);
END $$;


-- �������� ������ �� ��������
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    vbUserId= zfCalc_UserAdmin():: Integer;

    -- ����� ImportSetting
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Sticker();
    -- ����� ImportType
    SELECT Id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Sticker();
    
    -- ������� ��� �������� ��� - ImportType
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ������ ��� ��������', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Sticker_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    -- ������� Enum - ImportType
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Sticker');

    -- ������ ��������� �������� - ImportSetting
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ������ ��� ��������',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    -- ������� Enum - ImportSetting
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Sticker');

    -- ��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '��� ��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStickerGroupName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inStickerGroupName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��� �������� (������)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);    


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStickerTypeName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inStickerTypeName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '������ ������������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);  
                                                       
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStickerTagName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inStickerTagName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ��������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);   
 
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStickerSortName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inStickerSortName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar); 
                  
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStickerNormName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inStickerNormName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�� ��� ����', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar); 

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inValue1', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '�������� �� ������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'T',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inValue2', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����� �� ������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'O',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                      

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inValue3', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���� �� ������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'P',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inValue4', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'R',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);                                                                                                    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue5';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inValue5', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Q',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inInfo';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inInfo', 
                                                                inParamType     := 'ftWideString',       -- 'ftWideString',  --ftString
                                                                inUserParamName := '������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'S',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar); 

-- + �������� ��������
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStickerSkinName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inStickerSkinName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);    

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStickerPackName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 14, 
                                                                inName          := 'inStickerPackName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��� ��������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);  
                                                       
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBarCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 15, 
                                                                inName          := 'inBarCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);   
 
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue1_pr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 16, 
                                                                inName          := 'inValue1_pr', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '��������� ���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'U',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue2_pr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 17, 
                                                                inName          := 'inValue2_pr', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '��������� ����', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'V',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue3_pr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 18, 
                                                                inName          := 'inValue3_pr', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'T���������� ���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'W',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue4_pr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 19, 
                                                                inName          := 'inValue4_pr', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'T���������� ����', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'X',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);                                                                                                    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue5_pr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 20, 
                                                                inName          := 'inValue5_pr', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���-�� �����', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Y',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inValue6_pr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 21, 
                                                                inName          := 'inValue6_pr', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Sticker Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TStickerForm;zc_Object_ImportSetting_Sticker';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TStickerForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Sticker()::TBlob, inSession := ''::TVarChar);
END $$;



--��������� �� ������ � ���� ����� ��1 � ����� ��� ���
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MemberZP1() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MemberZP1() ;
    -- ������� ��� �������� ������ 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� � ���� ����� �� (�1) � ���������� ���. ���', 
                                                       inProcedureName := 'gpInsertUpdate_Object_MemberZP1_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MemberZP1');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� � ���� ����� �� (�1) � ���������� ���. ���',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MemberZP1');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBankId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inBankId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '������������� �����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inINN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inINN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCard';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inCard', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '� ����. ����� �� (�1)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MemberZP1 Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TMemberForm;zc_Object_ImportSetting_MemberZP1';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TMemberForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MemberZP1()::TBlob, inSession := ''::TVarChar);
END $$;


--��������� �� ������ � ���� ����� ��2 � ����� ��� ���
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MemberZP2() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MemberZP2() ;
    -- ������� ��� �������� ������ 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� � ���� ����� �� (�2) � ���������� ���. ���', 
                                                       inProcedureName := 'gpInsertUpdate_Object_MemberZP2_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MemberZP2');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� � ���� ����� �� (�2) � ���������� ���. ���',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MemberZP2');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBankId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inBankId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '������������� �����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inINN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inINN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCard';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inCard', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '� ����. ����� �� (�1)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inSurName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inSurName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inFName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MemberZP2 Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TMemberForm;zc_Object_ImportSetting_MemberZP2';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TMemberForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MemberZP2()::TBlob, inSession := ''::TVarChar);
END $$;




--��������� �� ������ � ���� ����� IBAN ��1 � ����� ��� ���
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MemberIBANZP1() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MemberIBANZP1() ;
    -- ������� ��� �������� ������ 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� � ���� ����� IBAN �� (�1) � ���������� ���. ���', 
                                                       inProcedureName := 'gpInsertUpdate_Object_MemberIBANZP1_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MemberIBANZP1');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� � ���� ����� IBAN �� (�1) � ���������� ���. ���',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MemberIBANZP1');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inINN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inINN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCard';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inCard', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '� ����. ����� �� (�1)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCardIBAN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inCardIBAN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '� ����. ����� IBAN �� (�1)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MemberIBANZP1 Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TMemberForm;zc_Object_ImportSetting_MemberIBANZP1';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TMemberForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MemberIBANZP1()::TBlob, inSession := ''::TVarChar);
END $$;



--��������� �� ������ � ���� ����� IBAN ��2 � ����� ��� ���
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MemberIBANZP2() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MemberIBANZP2() ;
    -- ������� ��� �������� ������ 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� � ���� ����� IBAN �� (�2) � ���������� ���. ���', 
                                                       inProcedureName := 'gpInsertUpdate_Object_MemberIBANZP2_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MemberIBANZP2');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� � ���� ����� IBAN �� (�2) � ���������� ���. ���',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MemberIBANZP2');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inINN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inINN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCardSecond';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inCardSecond', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '� ����. ����� �� (�1)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCardIBANSecond';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inCardIBANSecond', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '� ����. ����� IBAN �� (�1)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MemberIBANZP2 Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TMemberForm;zc_Object_ImportSetting_MemberIBANZP2';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TMemberForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MemberIBANZP2()::TBlob, inSession := ''::TVarChar);
END $$;



--��������� �� ������ ��������� ���/��� ������/���. ��� ����
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods_Weight() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods_Weight() ;
    -- ������� ��� �������� ������ 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ���/��� ������/���. ��� ���� � ���������� �������', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Goods_Weight_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods_Weight');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ���/��� ������/���. ��� ���� � ���������� �������',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods_Weight');

    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
  
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inWeight';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inWeight', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Weight', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inWeightTare';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inWeightTare', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '��� ������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'c',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCountForWeight';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inCountForWeight', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���-�� ��� ����', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Goods_Weight Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsForm;zc_Object_ImportSetting_Goods_Weight';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsForm","DescName":"zc_Object_ImportSettings_Goods_Weight"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods_Weight()::TBlob, inSession := ''::TVarChar);
END $$;




--��������� ���
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListItem() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListItem() ;
    -- ������� 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ���', 
                                                       inProcedureName := 'gpInsertUpdate_Object_PriceListItem_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListItem');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ���',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListItem');
    --��������� �����
    vbImportTypeItemId := 0;

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := '����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceListId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPriceListId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '����� ����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsKindName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsKindName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceValue';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inPriceValue', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListItemForm;zc_Object_ImportSetting_PriceListItem';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListItemForm","DescName":"zc_Object_ImportSettings_PriceListItem"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListItem()::TBlob, inSession := ''::TVarChar);
END $$;


--��������� ������ ��� 
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_CashFlow() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_CashFlow() ;
    -- ������� 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ������ ��� ������/������, ����� � �� �������', 
                                                       inProcedureName := 'gpInsertUpdate_Object_CashFlow_Load', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_CashFlow');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ������ ��� ������/������, ����� � �� �������',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_CashFlow');
    --��������� �����
    vbImportTypeItemId := 0;

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCashFlowCode_in';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCashFlowCode_in', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '��� ������ ��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCashFlowName_in';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inCashFlowName_in', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '������ ��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCashFlowCode_out';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inCashFlowCode_out', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '��� ������ ��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCashFlowName_out';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inCashFlowName_out', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '������ ��� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inInfoMoneyName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inInfoMoneyName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '������ ��', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TCashFlowForm;zc_Object_ImportSetting_CashFlow';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TCashFlowForm","DescName":"zc_Object_ImportSettings_CashFlow"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_CashFlow()::TBlob, inSession := ''::TVarChar);
END $$;




--��������� ������� ���������� (�������)  - ����
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_SaleExternal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_SaleExternal() ;
    -- ������� 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ���������� <������� ���������� (�������)>', 
                                                       inProcedureName := 'gpInsertUpdate_SaleExternal_ASHAN_Load', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_SaleExternal');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ���������� <������� ���������� (�������)>',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 4,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_SaleExternal');
    --��������� �����
    vbImportTypeItemId := 0;

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := '����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inRetailId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inRetailId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '�������� ����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerExternalCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPartnerExternalCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��� ����������� ��������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerExternalName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inPartnerExternalName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ����������� ��������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount_kg';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inAmount_kg', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TSaleExternalForm;zc_Object_ImportSetting_SaleExternal';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TSaleExternalForm","DescName":"zc_Object_ImportSettings_SaleExternal"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_SaleExternal()::TBlob, inSession := ''::TVarChar);
END $$;


--��������� ������� ���������� (�������) �����
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_SaleExternalNovus() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_SaleExternalNovus() ;
    -- ������� 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ���������� <������� ���������� (�������)> �����', 
                                                       inProcedureName := 'gpInsertUpdate_SaleExternal_Novus_Load', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_SaleExternalNovus');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ���������� <������� ���������� (�������)> �����',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 3,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_SaleExternalNovus');
    --��������� �����
    vbImportTypeItemId := 0;

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := '����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inRetailId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inRetailId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '�������� ����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerExternalName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPartnerExternalName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ����������� ��������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount_kg';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inAmount_kg', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TSaleExternalNovusForm;zc_Object_ImportSetting_SaleExternalNovus';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TSaleExternalNovusForm","DescName":"zc_Object_ImportSettings_SaleExternalNovus"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_SaleExternalNovus()::TBlob, inSession := ''::TVarChar);
END $$;



--��������� ������� ���������� (�������) METRO
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_SaleExternalMetro() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_SaleExternalMetro() ;
    -- ������� 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ���������� <������� ���������� (�������)> �����', 
                                                       inProcedureName := 'gpInsertUpdate_SaleExternal_Metro_Load', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_SaleExternalMetro');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ���������� <������� ���������� (�������)> �����',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 4,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_SaleExternalMetro');
    --��������� �����
    vbImportTypeItemId := 0;

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := '����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inRetailId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inRetailId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '�������� ����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerExternalCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPartnerExternalCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��� ����������� ��������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerExternalName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inPartnerExternalName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ����������� ��������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TSaleExternalMetroForm;zc_Object_ImportSetting_SaleExternalMetro';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TSaleExternalMetroForm","DescName":"zc_Object_ImportSettings_SaleExternalMetro"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_SaleExternalMetro()::TBlob, inSession := ''::TVarChar);
END $$;

--��������� ������� ���������� (�������) ������
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_SaleExternalSilpo() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_SaleExternalSilpo() ;
    -- ������� 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ���������� <������� ���������� (�������)> ������', 
                                                       inProcedureName := 'gpInsertUpdate_SaleExternal_Silpo_Load', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_SaleExternalSilpo');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ���������� <������� ���������� (�������)> ������',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_SaleExternalSilpo');
    --��������� �����
    vbImportTypeItemId := 0;

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := '����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inRetailId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inRetailId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '�������� ����',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerExternalName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPartnerExternalName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ����������� ��������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '�������� ������',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����������', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TSaleExternalSilpoForm;zc_Object_ImportSetting_SaleExternalSilpo';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TSaleExternalSilpoForm","DescName":"zc_Object_ImportSettings_SaleExternalSilpo"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_SaleExternalSilpo()::TBlob, inSession := ''::TVarChar);
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 04.11.20          * ��������� ������� ���������� (�������) �����
                     ��������� ������� ���������� (�������) �����
                     ��������� ������� ���������� (�������) ����
 01.11.20          * ��������� ������� ���������� (�������)
 22.06.20          * �������� ������ ���
 31.03.20          *    -- !!! ��������� ����� 
 24.03.20          *
 23.10.19          *
 09.09.19          * ��������� �� ������ � ���� ����� IBAN ��1 � ����� ��� ���
                   , ��������� �� ������ � ���� ����� IBAN ��2 � ����� ��� ���
 03.12.18          * �������� �� ������ � ���� ����� ��1 � ����� ��� ���
 27.10.17          * �������� ������ �� ��������
 21.02.17          * ��������� ������ ������ �� ��� �����
 18.01.17          * �������� � �������� <��������� ���������� ��������>
 15.11.16          * zc_Enum_DayKind
 23.03.16          *
 03.03.16          *  ��������� ��������� ��� �����
                      ���� ��������� ��� �����
 23.11.15                                                                       *zc_Enum_ImportExportLinkType_UploadCompliance
 31.10.15                                                                       *zc_Enum_PromoKind_Custom, zc_Enum_PromoKind_Compensation, zc_Enum_ConditionPromo_Discount, zc_Enum_ConditionPromo_Compensation
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
 21.03.14                                        * add zc_Enum_Account_3020... and zc_Enum_InfoMoney_20...
 09.03.14                                        * add zc_Enum_Account_50401
 21.02.14                                        * add zc_Enum_ContractConditionKind_LimitReturn
 09.02.14                                                       * add ���� ������������ ���������� ���������
 30.01.14                                        * add zc_Enum_ProfitLoss_80301
 25.01.14                                        * add zc_Enum_ContractConditionKind_...
 24.01.14                                        * add zc_Enum_InfoMoneyDestination_40900
 22.12.13                                        * add zc_Enum_InfoMoneyGroup_...
 22.12.13                                        * add zc_Enum_AccountDirection_40...
 19.12.13                                        * add del zc_Enum_ContractConditionKind_...
 30.11.13                                        * add del zc_Enum_StaffListSummKind_WorkHours and zc_Enum_StaffListSummKind_HoursDayConst
 28.11.13                                        * change comment
 28.11.13                                        * add zc_Enum_WorkTimeKind_Trainee50 and zc_Enum_WorkTimeKind_Quit and zc_Enum_WorkTimeKind_Trial
 19.11.13                                        * add zc_Enum_StaffListSummKind_HoursPlanConst and zc_Enum_StaffListSummKind_HoursDayConst
 18.11.13                                        * add zc_Enum_StaffListSummKind_HoursDay
 18.11.13                                        * replace zc_Enum_StaffListSummKind_RatioHours -> zc_Enum_StaffListSummKind_HoursPlan
 18.11.13                                        * replace zc_Enum_StaffListSummKind_Turn -> zc_Enum_StaffListSummKind_Day
 18.11.13                                        * replace zc_Enum_StaffListSummKind_MasterStaffListHours -> zc_Enum_StaffListSummKind_WorkHours
 09.11.13                                        * add zc_Enum_Role_Transport
 03.11.13                                        * rename zc_Enum_ProfitLoss_40209 -> zc_Enum_ProfitLoss_40208
 01.11.13                                        * add zc_Enum_Account_110101
 30.10.13         * add ���� ���� ��� �������� ����������
 07.10.13                                        * role...
 03.10.13                                        * add zc_Enum_InfoMoney_20901, zc_Enum_InfoMoney_30101
 01.10.13         * add ���� �������� ������� (6 ��)
 30.09.13                                        * add zc_Enum_InfoMoney_21201
 29.09.13                                        * add zc_Object_RateFuelKind
 27.09.13                                        * add zc_Enum_InfoMoney_20401
 26.09.13         * del zc_Enum_RateFuelKind_Summer, zc_Enum_RateFuelKind_Winter
 24.09.13         * add zc_Enum_RateFuelKind_Summer, zc_Enum_RateFuelKind_Winter, zc_Enum_RouteKind_Internal, zc_Enum_RouteKind_External
 21.09.13                                        * add zc_Enum_InfoMoney_80401
 15.09.13                                        * add zc_Enum_AccountDirection_20900 and zc_Enum_Account_20901
 07.09.13                                        * add zc_Enum_ProfitLossDirection_1... and zc_Enum_ProfitLossDirection_7...
 01.09.13                                        * add zc_Enum_ProfitLossDirection_4...
 26.08.13                                        * add ����
 25.08.13                                        * add zc_Enum_Account_100301
 21.08.13                        * add zc_Enum_Account_40101
 20.07.13                                        * add zc_Enum_AccountDirection_20400
 18.07.13                                        * add zc_Enum_AccountDirection_20500, 20600
 02.07.13                                        * add 1-������� �������������� ������
 01.07.13                                        * add 2-������� �������������� ����������
 28.06.13                                        *
*/
