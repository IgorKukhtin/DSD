DO $$
BEGIN
     -- ��������� ����:
     -- zc_Enum_Role_Admin
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= '���� ��������������', inEnumName:= 'zc_Enum_Role_Admin');

     -- ���� � �������� ����
     -- actReturnInMovement + actReport_SaleReturnIn + actReport_GoodsMI_Account + actReport_CollationByClient + actReport_ClientDebt + actReport_Goods_RemainsCurrent
     PERFORM lpInsertUpdate_Object (ioId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 2)
                                  , inDescId    := zc_Object_Role()
                                  , inObjectCode:= 2
                                  , inValueData := '���� � �������� ����'
                                   );
     -- ���� � �������� (�� ��)
     -- actSaleMovement
     PERFORM lpInsertUpdate_Object (ioId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 3)
                                  , inDescId    := zc_Object_Role()
                                  , inObjectCode:= 3
                                  , inValueData := '���� � �������� (�� ��)'
                                   );
     -- ���� � �������� ��
     -- actSaleTwoMovement
     PERFORM lpInsertUpdate_Object (ioId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 4)
                                  , inDescId    := zc_Object_Role()
                                  , inObjectCode:= 4
                                  , inValueData := '���� � �������� ��'
                                   );

     -- !!! ������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_UnComplete(), inName:= '�� ��������', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Complete(),   inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Complete(),   inName:= '��������',    inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Erased(),     inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Erased(),     inName:= '������',      inEnumName:= 'zc_Enum_Status_Erased');

END $$;


DO $$
DECLARE vbId integer;
DECLARE vbUserId integer;
DECLARE vbUserId_load integer;
BEGIN
   -- !!!������ �������� �������� ���������� ������ ��� �� ��������� �������� ����!!!
   vbUserId:=      (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����');
   vbUserId_load:= (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�������� Sybase');

   IF COALESCE (vbUserId, 0) = 0
   THEN
       -- ������� - �����
       vbUserId := lpInsertUpdate_Object (0, zc_Object_User(), 0, '�����');
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), vbUserId, '�����');
   END IF;
   /*IF COALESCE (vbUserId_load, 0) = 0
   THEN
       -- ������� - �������� Sybase
       vbUserId_load := lpInsertUpdate_Object (0, zc_Object_User(), 0, '�������� Sybase');
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), vbUserId_load, '�����');
       --
       EXECUTE ('CREATE OR REPLACE FUNCTION zc_User_Sybase() RETURNS Integer AS $BODY$BEGIN RETURN (' || vbUserId_load :: TvarChar || '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
   END IF;*/

   -- ��� ������
   IF NOT EXISTS(SELECT 1
                 FROM Object
                      JOIN ObjectLink AS UserRole_Role
                                      ON UserRole_Role.descId = zc_ObjectLink_UserRole_Role()
                                     AND UserRole_Role.childObjectId = zc_Enum_Role_Admin()
                                     AND UserRole_Role.ObjectId = Object.Id
                      JOIN ObjectLink AS UserRole_User
                                      ON UserRole_User.descId = zc_ObjectLink_UserRole_User()
                                     AND UserRole_User.childObjectId = vbUserId
                                     AND UserRole_User.ObjectId = Object.Id
                 WHERE Object.descId = zc_Object_UserRole()
                )
   THEN
       -- ��������� ������������ � �����
       vbId := lpInsertUpdate_Object (0, zc_Object_UserRole(), 0, '');
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), vbId, zc_Enum_Role_Admin());
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), vbId, vbUserId);

   END IF;

   -- ��� �������� Sybase
   IF NOT EXISTS(SELECT 1
                 FROM Object
                      JOIN ObjectLink AS UserRole_Role
                                      ON UserRole_Role.descId = zc_ObjectLink_UserRole_Role()
                                     AND UserRole_Role.childObjectId = zc_Enum_Role_Admin()
                                     AND UserRole_Role.ObjectId = Object.Id
                      JOIN ObjectLink AS UserRole_User
                                      ON UserRole_User.descId = zc_ObjectLink_UserRole_User()
                                     AND UserRole_User.childObjectId = vbUserId_load
                                     AND UserRole_User.ObjectId = Object.Id
                 WHERE Object.descId = zc_Object_UserRole()
                )
   THEN
       -- ��������� ������������ � �����
       vbId := lpInsertUpdate_Object (0, zc_Object_UserRole(), 0, '');
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), vbId, zc_Enum_Role_Admin());
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), vbId, vbUserId_load);

   END IF;

END $$;

DO $$
BEGIN
     -- !!! ���� �������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_Excel(),  inDescId:= zc_Object_FileTypeKind(), inCode:= 1, inName:= 'Excel', inEnumName:= 'zc_Enum_FileTypeKind_Excel');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_DBF(), inDescId:= zc_Object_FileTypeKind(), inCode:= 2, inName:= 'DBF', inEnumName:= 'zc_Enum_FileTypeKind_DBF');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_MMO(), inDescId:= zc_Object_FileTypeKind(), inCode:= 3, inName:= 'MMO', inEnumName:= 'zc_Enum_FileTypeKind_MMO');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_ODBC(), inDescId:= zc_Object_FileTypeKind(), inCode:= 4, inName:= 'ODBC', inEnumName:= 'zc_Enum_FileTypeKind_ODBC');

END $$;




--�������� �� ������ ��������
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

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_IncomeRemains() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_IncomeRemains() ;
    -- ������� ��� �������� ������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0),
                                                       inCode          := COALESCE(vbImportTypeCode,0) ::Integer,
                                                       inName          := '�������� ��������� �� ������� �� �����������' ::TVarChar,
                                                       inProcedureName := 'gpInsert_Movement_Income_Load' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_IncomeRemains');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0) ::Integer,
                                                              inCode         := COALESCE(vbImportSettingCode,0) ::Integer,
                                                              inName         := '�������� ��������� �� ������� �� �����������'::TVarChar,
                                                              inJuridicalId  := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel()::Integer,
                                                              inImportTypeId := vbImportTypeId ::Integer,
                                                              inEmailId      := NULL::Integer,
                                                              inStartRow     := 2 ::Integer,
                                                              inHDR          := False ::Boolean ,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TBlob,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0 ::TFloat,
                                                              inIsMultiLoad  := False ::Boolean ,
                                                              inSession      := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_IncomeRemains');
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
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 3,
                                                                inName          := 'inUnitName',
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
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCurrencyName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 2,
                                                                inName          := 'inCurrencyName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBrandName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 4,
                                                                inName          := 'inBrandName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�������� �����',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPeriodName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 5,
                                                                inName          := 'inPeriodName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�����',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inLabelName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 6,
                                                                inName          := 'inLabelName',
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

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 7,
                                                                inName          := 'inGoodsName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�������',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCompositionName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 8,
                                                                inName          := 'inCompositionName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsSizeName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 9,
                                                                inName          := 'inGoodsSizeName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 10,
                                                                inName          := 'inOperPrice',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '��.����',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperPriceList';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 11,
                                                                inName          := 'inOperPriceList',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '���� ������.',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inRemains';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 12,
                                                                inName          := 'inRemains',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '�������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_IncomeRemains Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TIncomeForm;zc_Object_ImportSetting_IncomeRemains';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey;

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TIncomeForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;

    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_IncomeRemains()::TBlob, inSession := ''::TVarChar);
END $$;




--�������� �� ������ ��������
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

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_IncomeJournal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_IncomeJournal() ;
    -- ������� ��� �������� ������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0),
                                                       inCode          := COALESCE(vbImportTypeCode,0) ::Integer,
                                                       inName          := '�������� ��������' ::TVarChar,
                                                       inProcedureName := 'gpInsert_Movement_IncomeAll_Load' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_IncomeJournal');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0) ::Integer,
                                                              inCode         := COALESCE(vbImportSettingCode,0) ::Integer,
                                                              inName         := '�������� ��������'::TVarChar,
                                                              inJuridicalId  := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel()::Integer,
                                                              inImportTypeId := vbImportTypeId ::Integer,
                                                              inEmailId      := NULL::Integer,
                                                              inStartRow     := 2 ::Integer,
                                                              inHDR          := False ::Boolean ,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TBlob,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0 ::TFloat,
                                                              inIsMultiLoad  := False ::Boolean ,
                                                              inSession      := vbUserId::TVarChar);

    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_IncomeJournal');
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
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 2,
                                                                inName          := 'inObjectCode',
                                                                inParamType     := 'ftInteger',
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
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPeriodName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 3,
                                                                inName          := 'inPeriodName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�����',
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

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBrandName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 4,
                                                                inName          := 'inBrandName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�������� �����',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsGroupName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 5,
                                                                inName          := 'inGoodsGroupName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '������ ������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inLabelName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 6,
                                                                inName          := 'inLabelName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '��������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCompositionName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 7,
                                                                inName          := 'inCompositionName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsInfoName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 8,
                                                                inName          := 'inGoodsInfoName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�������� ������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 9,
                                                                inName          := 'inOperPrice',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '��.����',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperPriceList';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 10,
                                                                inName          := 'inOperPriceList',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '���� �������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'O',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 11,
                                                                inName          := 'inAmount',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '���-�� ������',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_IncomeJournal Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TIncomeJournalForm;zc_Object_ImportSetting_IncomeJournal';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey;

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TIncomeJournalForm","DescName":"zc_Object_ImportSettings_IncomeJournal"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;

    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_IncomeJournal()::TBlob, inSession := ''::TVarChar);
END $$;


--�������� �� ������ ����� �����
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

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_CurrencyJournal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_CurrencyJournal() ;
    -- ������� ��� �������� ������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0),
                                                       inCode          := COALESCE(vbImportTypeCode,0) ::Integer,
                                                       inName          := '�������� ����� �����' ::TVarChar,
                                                       inProcedureName := 'gpInsert_Movement_CurrencyAll_Load' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_CurrencyJournal');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0) ::Integer,
                                                              inCode         := COALESCE(vbImportSettingCode,0) ::Integer,
                                                              inName         := '�������� ����� �����'::TVarChar,
                                                              inJuridicalId  := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel()::Integer,
                                                              inImportTypeId := vbImportTypeId ::Integer,
                                                              inEmailId      := NULL::Integer,
                                                              inStartRow     := 3 ::Integer,
                                                              inHDR          := False ::Boolean ,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TBlob,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0 ::TFloat,
                                                              inIsMultiLoad  := False ::Boolean ,
                                                              inSession      := vbUserId::TVarChar);

    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_CurrencyJournal');
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
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);


     vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 2,
                                                                inName          := 'inAmount',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '����',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_CurrencyJournal Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TCurrencyJournalForm;zc_Object_ImportSetting_CurrencyJournal';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey;

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TCurrencyJournalForm","DescName":"zc_Object_ImportSettings_CurrencyJournal"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;

    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_CurrencyJournal()::TBlob, inSession := ''::TVarChar);
END $$;




--�������� �� ������ �����������
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

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_SendJournal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_SendJournal() ;
    -- ������� ��� �������� ������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0),
                                                       inCode          := COALESCE(vbImportTypeCode,0) ::Integer,
                                                       inName          := '�������� �����������' ::TVarChar,
                                                       inProcedureName := 'gpInsert_Movement_SendAll_Load' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_SendJournal');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0) ::Integer,
                                                              inCode         := COALESCE(vbImportSettingCode,0) ::Integer,
                                                              inName         := '�������� �����������'::TVarChar,
                                                              inJuridicalId  := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel()::Integer,
                                                              inImportTypeId := vbImportTypeId ::Integer,
                                                              inEmailId      := NULL::Integer,
                                                              inStartRow     := 2 ::Integer,
                                                              inHDR          := False ::Boolean ,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TBlob,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0 ::TFloat,
                                                              inIsMultiLoad  := False ::Boolean ,
                                                              inSession      := vbUserId::TVarChar);

    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_SendJournal');

    -- ��������� �����

    -- 1 - inInvNumber
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inInvNumber';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 1,
                                                                inName          := 'inInvNumber',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '� ���������',
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


    -- 2 - inOperDate
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 2,
                                                                inName          := 'inOperDate',
                                                                inParamType     := 'ftDateTime',
                                                                inUserParamName := '���� ���������',
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


    -- 3 - inObjectCode
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 3,
                                                                inName          := 'inObjectCode',
                                                                inParamType     := 'ftInteger',
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
                                                      inConvertFormatInExcel := FALSE,
                                                      inSession           := vbUserId::TVarChar);


    -- 4 - inAmount
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 4,
                                                                inName          := 'inAmount',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '���-��',
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

    -- 5 - inPrice
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 5,
                                                                inName          := 'inPrice',
                                                                inParamType     := 'ftFloat',
                                                                inUserParamName := '����',
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
    DECLARE vbImportSetting_SendJournal Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TSendJournalForm;zc_Object_ImportSetting_SendJournal';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey;

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TSendJournalForm","DescName":"zc_Object_ImportSettings_SendJournal"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;

    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_SendJournal()::TBlob, inSession := ''::TVarChar);
END $$;






--�������� �� ������ �������� ������� ���
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

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Labels() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Labels() ;
    -- ������� ��� �������� ������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0),
                                                       inCode          := COALESCE(vbImportTypeCode,0) ::Integer,
                                                       inName          := '�������� �������� ��������' ::TVarChar,
                                                       inProcedureName := 'gpInsertUpdate_Object_Label_Load' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Labels');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0) ::Integer,
                                                              inCode         := COALESCE(vbImportSettingCode,0) ::Integer,
                                                              inName         := '�������� �������� ��������'::TVarChar,
                                                              inJuridicalId  := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel()::Integer,
                                                              inImportTypeId := vbImportTypeId ::Integer,
                                                              inEmailId      := NULL::Integer,
                                                              inStartRow     := 2 ::Integer,
                                                              inHDR          := False ::Boolean ,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TBlob,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0 ::TFloat,
                                                              inIsMultiLoad  := False ::Boolean ,
                                                              inSession      := vbUserId::TVarChar);

    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Labels');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 1,
                                                                inName          := 'inName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�������� �������',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName_Ukr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 2,
                                                                inName          := 'inName_Ukr',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '�������� ������� ���.',
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

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Labels Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TLabelsForm;zc_Object_ImportSetting_Labels';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey;

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TLabelsForm","DescName":"zc_Object_ImportSettings_Labels"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;

    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Labels()::TBlob, inSession := ''::TVarChar);
END $$;





--�������� �� ������ �������� ��� - ������ ������
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

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Composition() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Composition() ;
    -- ������� ��� �������� ������
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0),
                                                       inCode          := COALESCE(vbImportTypeCode,0) ::Integer,
                                                       inName          := '�������� ���. �������� ������� �������' ::TVarChar,
                                                       inProcedureName := 'gpUpdate_Object_Composition_Load' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Composition');
    --������ ��������� ��������
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0) ::Integer,
                                                              inCode         := COALESCE(vbImportSettingCode,0) ::Integer,
                                                              inName         := '�������� ���. �������� ������� �������'::TVarChar,
                                                              inJuridicalId  := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel()::Integer,
                                                              inImportTypeId := vbImportTypeId ::Integer,
                                                              inEmailId      := NULL::Integer,
                                                              inStartRow     := 2 ::Integer,
                                                              inHDR          := False ::Boolean ,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TBlob,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0 ::TFloat,
                                                              inIsMultiLoad  := False ::Boolean ,
                                                              inSession      := vbUserId::TVarChar);

    --������� Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Composition');
    --��������� �����
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 1,
                                                                inName          := 'inName',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '������ ������',
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
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName_Ukr';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0),
                                                                inParamNumber   := 2,
                                                                inName          := 'inName_Ukr',
                                                                inParamType     := 'ftString',
                                                                inUserParamName := '������ ������ ���.',
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

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Composition Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TCompositionForm;zc_Object_ImportSetting_Composition';

    -- ��������� ���� �������
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey;

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TCompositionForm","DescName":"zc_Object_ImportSettings_Composition"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;

    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Composition()::TBlob, inSession := ''::TVarChar);
END $$;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.08.20         * add �������� �������� ��� - ������ ������
 10.02.20         * add �������� ����� �����
                        �������� �����������
 20.01.20         * add �������� ��������
 28.03.19         * add �������� �� ������ ��������
 ******
*/