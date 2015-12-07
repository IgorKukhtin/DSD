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
  DECLARE DefaultKeyId Integer;
  DECLARE vbKey TVarChar;
  DECLARE vbRetailId Integer;
BEGIN
   -- ������ �������� �������� ���������� ������ ��� �� ��������� �������� ����!!!
   SELECT Id INTO UserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����';

   IF COALESCE(UserId, 0) = 0 THEN
     -- ������� ��������������
     UserId := lpInsertUpdate_Object(0, zc_Object_User(), 0, '�����');

     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), UserId, '�����');
   END IF;

   vbKey := 'zc_Object_Retail';

   -- ��������� ���� �������
   SELECT Id INTO DefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

   IF COALESCE(DefaultKeyId, 0) = 0 THEN 
      INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"DescName":"zc_Object_Retail"}') RETURNING Id INTO DefaultKeyId;
   END IF;

   -- ��������� ���� "�� �����"

   SELECT Id INTO vbRetailId FROM Object WHERE DescId = zc_Object_Retail() AND ValueData = '�� �����';

   IF COALESCE(vbRetailId, 0) = 0 THEN 
      vbRetailId := lpInsertUpdate_Object( 0, zc_Object_Retail(), 1, '�� �����');
   END IF;

   IF COALESCE(lpGet_DefaultValue('zc_Object_Retail', zc_Enum_Role_Admin()), '') = '0' THEN
      INSERT INTO DefaultValue(DefaultKeyId, UserKeyId, DefaultValue) 
                VALUES(DefaultKeyId, zc_Enum_Role_Admin(), vbRetailId);
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

     -- !!! ���������� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_Marion(),  inDescId:= zc_Object_GlobalConst(), inCode:= 1, inName:= '���� �������', inEnumName:= 'zc_Enum_GlobalConst_Marion');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_BarCode(),  inDescId:= zc_Object_GlobalConst(), inCode:= 2, inName:= '�����-����', inEnumName:= 'zc_Enum_GlobalConst_BarCode');

     -- !!! ����� ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_FirstForm(),  inDescId:= zc_Object_PaidKind(), inCode:= 1, inName:= '��', inEnumName:= 'zc_Enum_PaidKind_FirstForm');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_SecondForm(), inDescId:= zc_Object_PaidKind(), inCode:= 2, inName:= '���', inEnumName:= 'zc_Enum_PaidKind_SecondForm');

     -- !!! ���� ���
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_NDSKind_Common(),  inDescId:= zc_Object_NDSKind(), inCode:= 1, inName:= '20% - ����� ���������', inEnumName:= 'zc_Enum_NDSKind_Common');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_NDSKind_Medical(), inDescId:= zc_Object_NDSKind(), inCode:= 2, inName:= '7% - �����������', inEnumName:= 'zc_Enum_NDSKind_Medical');

     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_NDSKind_Common(), 20);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_NDSKind_Medical(), 7);

     -- !!! ���� �������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_Excel(),  inDescId:= zc_Object_FileTypeKind(), inCode:= 1, inName:= 'Excel', inEnumName:= 'zc_Enum_FileTypeKind_Excel');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_DBF(), inDescId:= zc_Object_FileTypeKind(), inCode:= 2, inName:= 'DBF', inEnumName:= 'zc_Enum_FileTypeKind_DBF');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_MMO(), inDescId:= zc_Object_FileTypeKind(), inCode:= 3, inName:= 'MMO', inEnumName:= 'zc_Enum_FileTypeKind_MMO');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_ODBC(), inDescId:= zc_Object_FileTypeKind(), inCode:= 4, inName:= 'ODBC', inEnumName:= 'zc_Enum_FileTypeKind_ODBC');

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
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_CreateOrder(), inDescId:= zc_Object_ContactPersonKind(), inCode:= 1, inName:= '������������ �������', inEnumName:= 'zc_Enum_ContactPersonKind_CreateOrder');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_CheckDocument(), inDescId:= zc_Object_ContactPersonKind(), inCode:= 2, inName:= '�������� ����������', inEnumName:= 'zc_Enum_ContactPersonKind_CheckDocument');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_AktSverki(), inDescId:= zc_Object_ContactPersonKind(), inCode:= 3, inName:= '���� ������ � ���������� �����', inEnumName:= 'zc_Enum_ContactPersonKind_AktSverki');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_ProcessOrder(), inDescId:= zc_Object_ContactPersonKind(), inCode:= 4, inName:= '��������� �������', inEnumName:= 'zc_Enum_ContactPersonKind_ProcessOrder');

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

     -- !!! ���� ������������ ���������� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Tax(),      		 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 1, inName:= '���������', inEnumName:= 'zc_Enum_DocumentTaxKind_Tax');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(),  inDescId:= zc_Object_DocumentTaxKind(), inCode:= 2, inName:= '������� ��������� �� ��.�.(����������)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), inDescId:= zc_Object_DocumentTaxKind(), inCode:= 3, inName:= '������� ��������� �� ��.�.(����������-��������)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), 	 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 4, inName:= '������� ��������� �� �.�.(����������)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR(), 	 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 5, inName:= '������� ��������� �� �.�.(����������-��������)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Corrective(), 	 		inDescId:= zc_Object_DocumentTaxKind(), inCode:= 6, inName:= '�������������', inEnumName:= 'zc_Enum_DocumentTaxKind_Corrective');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR(),  inDescId:= zc_Object_DocumentTaxKind(), inCode:= 7, inName:= '������� ������������� �� ��.�.(��������)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), inDescId:= zc_Object_DocumentTaxKind(), inCode:= 8, inName:= '������� ������������� �� ��.�.(����������-��������)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(),    inDescId:= zc_Object_DocumentTaxKind(), inCode:= 9, inName:= '������� ������������� �� �.�.(��������)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR(),   inDescId:= zc_Object_DocumentTaxKind(), inCode:= 10, inName:= '������� ������������� �� �.�.(����������-��������)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectivePrice(),              inDescId:= zc_Object_DocumentTaxKind(), inCode:= 11, inName:= '�������������� ����', inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectivePrice');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Prepay(),                       inDescId:= zc_Object_DocumentTaxKind(), inCode:= 12, inName:= '����������', inEnumName:= 'zc_Enum_DocumentTaxKind_Prepay');

     -- !!! ���� ������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_DaySheetWorkTime(),   inDescId:= zc_Object_ModelServiceKind(), inCode:= 1, inName:= '�� ���� ������'         , inEnumName:= 'zc_Enum_ModelServiceKind_DaySheetWorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_MonthSheetWorkTime(), inDescId:= zc_Object_ModelServiceKind(), inCode:= 2, inName:= '�� ����� ������'        , inEnumName:= 'zc_Enum_ModelServiceKind_MonthSheetWorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_SatSheetWorkTime(),   inDescId:= zc_Object_ModelServiceKind(), inCode:= 3, inName:= '�� �������� ������'     , inEnumName:= 'zc_Enum_ModelServiceKind_SatSheetWorkTime');
   --  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_MonthFundPay(),       inDescId:= zc_Object_ModelServiceKind(), inCode:= 4, inName:= '�� ����� ����/�������'  , inEnumName:= 'zc_Enum_ModelServiceKind_MonthFundPay');
   --  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_TurnFundPay(),        inDescId:= zc_Object_ModelServiceKind(), inCode:= 5, inName:= '�� 1 ����� ����/�������', inEnumName:= 'zc_Enum_ModelServiceKind_TurnFundPay');

     -- !!! ���� ������ ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InWeight(),  inDescId:= zc_Object_SelectKind(), inCode:= 1, inName:= '���-�� ������ � ���������� � ���', inEnumName:= 'zc_Enum_SelectKind_InWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_OutWeight(), inDescId:= zc_Object_SelectKind(), inCode:= 2, inName:= '���-�� ������ � ���������� � ���', inEnumName:= 'zc_Enum_SelectKind_OutWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InAmount(),  inDescId:= zc_Object_SelectKind(), inCode:= 3, inName:= '���-�� ������',                    inEnumName:= 'zc_Enum_SelectKind_InAmount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_OutAmount(), inDescId:= zc_Object_SelectKind(), inCode:= 4, inName:= '���-�� ������',                    inEnumName:= 'zc_Enum_SelectKind_OutAmount');

     -- !!! ���� ���� ��� �������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Month(),           inDescId:= zc_Object_StaffListSummKind(), inCode:= 1, inName:= '���� �� �����'                                           , inEnumName:= 'zc_Enum_StaffListSummKind_Month');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Day(),             inDescId:= zc_Object_StaffListSummKind(), inCode:= 2, inName:= '������� �� 1 ���� �� ����'                               , inEnumName:= 'zc_Enum_StaffListSummKind_Day');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Personal(),        inDescId:= zc_Object_StaffListSummKind(), inCode:= 3, inName:= '������� �� 1 ���� �� ��������'                           , inEnumName:= 'zc_Enum_StaffListSummKind_Personal');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursPlan(),       inDescId:= zc_Object_StaffListSummKind(), inCode:= 4, inName:= '���� �� ����� ���� ����� (����������) � ����� �� ��������', inEnumName:= 'zc_Enum_StaffListSummKind_HoursPlan');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursDay(),        inDescId:= zc_Object_StaffListSummKind(), inCode:= 5, inName:= '���� �� ���� ����� (���������) � ����� �� ��������'       , inEnumName:= 'zc_Enum_StaffListSummKind_HoursDay');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursPlanConst(),  inDescId:= zc_Object_StaffListSummKind(), inCode:= 6, inName:= '���� ���������� ��� ���� ����� � ����� �� ��������'       , inEnumName:= 'zc_Enum_StaffListSummKind_HoursPlanConst');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursDayConst(),   inDescId:= zc_Object_StaffListSummKind(), inCode:= 7, inName:= '(�� ������������).���� ���������� ��� ���� ����� � ������� ��� �� ��������' , inEnumName:= 'zc_Enum_StaffListSummKind_HoursDayConst');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_WorkHours(),       inDescId:= zc_Object_StaffListSummKind(), inCode:= 11,inName:= '(�� ������������).���������� ������� ����� � ����'                          , inEnumName:= 'zc_Enum_StaffListSummKind_WorkHours');


     -- !!! ��������� ��������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Signed(), inDescId:= zc_Object_ContractStateKind(), inCode:= 1, inName:= '��������' , inEnumName:= 'zc_Enum_ContractStateKind_Signed');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_UnSigned(), inDescId:= zc_Object_ContractStateKind(), inCode:= 2, inName:= '�� ��������' , inEnumName:= 'zc_Enum_ContractStateKind_UnSigned');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Close(), inDescId:= zc_Object_ContractStateKind(), inCode:= 3, inName:= '��������' , inEnumName:= 'zc_Enum_ContractStateKind_Close');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Partner(), inDescId:= zc_Object_ContractStateKind(), inCode:= 4, inName:= '� �����������' , inEnumName:= 'zc_Enum_ContractStateKind_Partner');
     
     -- !!! ���� ������� ���������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_ChangePercent()         , inDescId:= zc_Object_ContractConditionKind(), inCode:= 1,  inName:= '(-)% ������ (+)% �������'     , inEnumName:= 'zc_Enum_ContractConditionKind_ChangePercent');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_ChangePrice()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 2,  inName:= '������ � ����'                , inEnumName:= 'zc_Enum_ContractConditionKind_ChangePrice');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayDayCalendar()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 3,  inName:= '�������� � ����������� ����'               , inEnumName:= 'zc_Enum_ContractConditionKind_DelayDayCalendar');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayDayBank()          , inDescId:= zc_Object_ContractConditionKind(), inCode:= 4,  inName:= '�������� � ���������� ����'                , inEnumName:= 'zc_Enum_ContractConditionKind_DelayDayBank');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayCreditLimit()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 5,  inName:= '�������� �������� ������'                  , inEnumName:= 'zc_Enum_ContractConditionKind_DelayCreditLimit');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayPrepay()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 6,  inName:= '����������'                                , inEnumName:= 'zc_Enum_ContractConditionKind_DelayPrepay');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercent()         , inDescId:= zc_Object_ContractConditionKind(), inCode:= 11,  inName:= '% �� �������'                      , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercent');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditLimit()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 12,  inName:= '����� �������'                     , inEnumName:= 'zc_Enum_ContractConditionKind_CreditLimit');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercentService()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 13,  inName:= '% �� ������/������������ �������'  , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercentService');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercentReceived() , inDescId:= zc_Object_ContractConditionKind(), inCode:= 14,  inName:= '% �� ����� �� �������'             , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercentReceived');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentSale()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 21, inName:= '% ������ �� ��������'         , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentSale');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 22, inName:= '% ������ �� ��������-�������' , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentSaleReturn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentAccount()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 23, inName:= '% ������ �� ������'           , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentAccount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusMonthlyPayment()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 24, inName:= '����� - ����������� ������'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusMonthlyPayment');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 25, inName:= '������� - ����������� ������'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 26, inName:= '������ �����,��� ���������� ����� ������ (�� ����� � ���)'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 27, inName:= '������ �����,��� ���������� ����� ������ (�� ����� ��� ���)' , inEnumName:= 'zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusYearlyPayment()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 28, inName:= '������� ������'               , inEnumName:= 'zc_Enum_ContractConditionKind_BonusYearlyPayment');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_LimitReturn()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 29, inName:= '����������� �� ���������'     , inEnumName:= 'zc_Enum_ContractConditionKind_LimitReturn');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime1()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 101, inName:= '������ �� ����� (��� ����������� � �������������), ���/�'  , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime1');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime2()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 102, inName:= '������ �� ����� (� ������������ ��� ������������), ���/�'  , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime2');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime3()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 103, inName:= '������ �� ����� (��� ����������� ��� ������������), ���/�' , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime3');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime4()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 104, inName:= '������ �� ����� (� ������������ � �������������), ���/�'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime4');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportDistance() , inDescId:= zc_Object_ContractConditionKind(), inCode:= 105, inName:= '������ �� ������, ���/��'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportDistance');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportOneTrip()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 106, inName:= '������ �� ������� � ���� �������, ���'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportOneTrip');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportRoundTrip(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 107, inName:= '������ �� ������� � ��� �������, ���'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportRoundTrip');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportPoint()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 108, inName:= '������ �� �����, ���'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportPoint');

     -- !!!
     -- !!! ���� �������
     -- !!!
     -- PERFORM lpUpdate_Object_Enum_byCode (inCode:= 1,  inDescId:= zc_Object_GoodsKind(), inEnumName:= 'zc_Enum_GoodsKind_Main');



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
     
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_InfoMoneyDestination_20500(), inDescId:= zc_Object_InfoMoneyDestination(), inCode:= 20500,  inName:= '����������', inEnumName:= 'zc_Enum_InfoMoneyDestination_20500');

-- ��������� ���� �� �������� ���������!!! 
--     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_ConnectParam(),  inDescId:= zc_Object_GlobalConst(), inCode:= 3, inName:= 'http://91.210.37.210/farmacy/index.php', inEnumName:= 'zc_Enum_GlobalConst_ConnectParam');
     
END $$;

DO $$
BEGIN

-- !!!
-- !!! ������: 1-������� �������������� ������
-- !!!

-- 20000; "������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_20000(), inDescId:= zc_Object_AccountGroup(), inCode:= 20000, inName:= '������' , inEnumName:= 'zc_Enum_AccountGroup_20000');

-- 40000; "�������� ��������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_40000(), inDescId:= zc_Object_AccountGroup(), inCode:= 40000, inName:= '�������� ��������' , inEnumName:= 'zc_Enum_AccountGroup_40000');

-- 70000; "���������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_70000(), inDescId:= zc_Object_AccountGroup(), inCode:= 70000, inName:= '���������' , inEnumName:= 'zc_Enum_AccountGroup_70000');

-- 100000; "����������� �������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_100000(), inDescId:= zc_Object_AccountGroup(), inCode:= 100000, inName:= '����������� �������' , inEnumName:= 'zc_Enum_AccountGroup_100000');

-- !!!
-- !!! ������: 2-������� �������������� ������
-- !!!

-- 20000; "������"; 20100; "�����"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_20100(), inDescId:= zc_Object_AccountDirection(), inCode:= 20100, inName:= '�����' , inEnumName:= 'zc_Enum_AccountDirection_20100');
-- 20000; "������"; 20200; "������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_20200(), inDescId:= zc_Object_AccountDirection(), inCode:= 20200, inName:= '������' , inEnumName:= 'zc_Enum_AccountDirection_20200');

-- 40000; "�������� ��������"; 40100; "�����"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_40100(), inDescId:= zc_Object_AccountDirection(), inCode:= 40100, inName:= '�����' , inEnumName:= 'zc_Enum_AccountDirection_40100');
-- 40000; "�������� ��������"; 40300; "���������� ����"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_40300(), inDescId:= zc_Object_AccountDirection(), inCode:= 40300, inName:= '���������� ����' , inEnumName:= 'zc_Enum_AccountDirection_40300');

-- 70000; "���������"; 70100; "����������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_70100(), inDescId:= zc_Object_AccountDirection(), inCode:= 70100, inName:= '����������' , inEnumName:= 'zc_Enum_AccountDirection_70100');
-- 100000; "����������� �������"; 100300; "������� �������� �������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_100300(), inDescId:= zc_Object_AccountDirection(), inCode:= 100300, inName:= '������� �������� �������' , inEnumName:= 'zc_Enum_AccountDirection_100300');

-- !!!
-- !!! ������: �������������� ����� (1+2+3 �������)
-- !!!

-- 40101; "�����";
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_40101(), inDescId:= zc_Object_Account(), inCode:= 40101, inName:= '�����' , inEnumName:= 'zc_Enum_Account_40101');
-- 40301; "��������� ����";
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_40301(), inDescId:= zc_Object_Account(), inCode:= 40301, inName:= '��������� ����' , inEnumName:= 'zc_Enum_Account_40301');

-- !!!
-- !!! ��: 2-������� �������������� ����������
-- !!!

-- 10000; "�������� �����"; 10200; "�����������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_InfoMoneyDestination_10200(), inDescId:= zc_Object_InfoMoneyDestination(), inCode:= 10200, inName:= '�����������' , inEnumName:= 'zc_Enum_InfoMoneyDestination_10200');
-- 80000; "����������� ��������"; 80400; "������� �������� �������"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_InfoMoneyDestination_80400(), inDescId:= zc_Object_InfoMoneyDestination(), inCode:= 80400, inName:= '������� �������� �������' , inEnumName:= 'zc_Enum_InfoMoneyDestination_80400');

-- !!!
-- !!! ������: �������������� ����� (1+2+3 �������)
-- !!!
-- 100301; "������� �������� �������";
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_100301(), inDescId:= zc_Object_Account(), inCode:= 100301, inName:= '������� �������� �������' , inEnumName:= 'zc_Enum_Account_100301');

-- !!!
-- !!! ��� ����� 
-- !!!
-- 0. �������
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidType_Cash(),  inDescId:= zc_Object_PaidType(), inCode:= 1, inName:= '�������', inEnumName:= 'zc_Enum_PaidType_Cash');
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidType_Card(), inDescId:= zc_Object_PaidType(), inCode:= 2, inName:= '��������', inEnumName:= 'zc_Enum_PaidType_Card');

-- !!! ���� �������� ��� ��������
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_10400(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 101, inName:= '���-��, ����������, � ����������', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_10400');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_10500(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 102, inName:= '���-��, ����������, ������ �� ���', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_10500');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 103, inName:= '���-��, ����������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_40200');

     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10400(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 111, inName:= '����� �/�, ����������, � ����������', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10400');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10500(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 112, inName:= '����� �/�, ����������, ������ �� ���', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10500');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 113, inName:= '����� �/�, ����������, ������� � ����', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_40200');

     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10100(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 121, inName:= '�����, ����������, � ���������� (�� ������� �����)', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10100');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 122, inName:= '�����, ����������, ������� � �������� ������', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10200');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10300(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 123, inName:= '�����, ����������, ������ ��������������', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10300');
     
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInSumm_10300(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 223, inName:= '�����, �������, ������ ��������������', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInSumm_10300');

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
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MCS() ;
        
    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MCS() ;
    -- ������� ��� �������� ���
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ������������ ��������� ������', 
                                                       inProcedureName := 'gpInsertUpdate_Object_MCS_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MCS');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ������������ ��������� ������',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MCS');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inUnitId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '������������� �������������',
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
                                                                inParamNumber   := 2, 
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMCSValue';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inMCSValue', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '���', 
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
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MCS Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceForm;zc_Object_ImportSetting_MCS';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MCS()::TBlob, inSession := ''::TVarChar);
END $$;

--
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
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Price() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Price() ;
    -- ������� ��� �������� ���
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ��������� ���', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Price_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Price');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ��������� ���',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Price');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inUnitId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '������������� �������������',
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
                                                                inParamNumber   := 2, 
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceValue';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPriceValue', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����', 
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
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceForm;zc_Object_ImportSetting_Price';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Price()::TBlob, inSession := ''::TVarChar);
END $$;

--
--��������� ������� �� ���������
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
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Inventory() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Inventory() ;
    -- ������� ��� �������� ������� �� ���������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ������� �� ���������', 
                                                       inProcedureName := 'gpInsertUpdate_MovementItem_Inventory_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Inventory');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ������� �� ���������',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Inventory');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMovementId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inMovementId', 
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '�������', 
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����', 
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
    DECLARE vbImportSetting_Inventory Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TInventoryForm;zc_Object_ImportSetting_Inventory';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TInventoryForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Inventory()::TBlob, inSession := ''::TVarChar);
END $$;


--
--��������� ������������ ����������
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
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods_MinimumLot() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods_MinimumLot() ;
    -- ������� ��� �������� ������������ ����������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� ������������ ����������', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Goods_MinimumLot', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods_MinimumLot');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� ������������ ����������',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods_MinimumLot');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��� ������ ����������',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inObjectId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '��� ����������',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinimumLot';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inMinimumLot', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '����������� ����������', 
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
    DECLARE vbImportSetting_Goods_MinimumLot Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_MinimumLot';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
       INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsPartnerCodeForm","DescName":"zc_Object_ImportSetting_Goods_MinimumLot"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods_MinimumLot()::TBlob, inSession := ''::TVarChar);
END $$;

--
--��������� �������� <����������� � ������ ��� ����������>
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
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods_IsUpload() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods_IsUpload() ;
    -- ������� ��� �������� �������� <����������� � ������ ��� ����������>
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := '�������� �������� <����������� � ������ ��� ����������>', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Goods_IsUpload', 
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods_IsUpload');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := '�������� �������� <����������� � ������ ��� ����������>',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods_IsUpload');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '��� ������ ����������',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inObjectId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := '��� ����������',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inIsUpload';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inIsUpload', 
                                                                inParamType     := 'ftBoolean', 
                                                                inUserParamName := '������� <����������� � ������ ��� ����������>', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := 'TRUE'::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Goods_IsUpload Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_IsUpload';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
       INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsPartnerCodeForm","DescName":"zc_Object_ImportSetting_Goods_IsUpload"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods_IsUpload()::TBlob, inSession := ''::TVarChar);
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.    ��������� �.�.
 15.08.15                                                                       *��������� ������������ ����������
 28.07.15                                                                       *���������� ��� / ��� / ���������
 23.07.14                         * ����������� ��� �����
\*/
