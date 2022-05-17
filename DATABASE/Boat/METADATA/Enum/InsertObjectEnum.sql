DO $$
BEGIN
     -- Добавляем роли:
     -- zc_Enum_Role_Admin
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= 'Role Admin', inEnumName:= 'zc_Enum_Role_Admin');

     -- !!! Статусы документов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_UnComplete(), inName:= 'Не проведен', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Complete(),   inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Complete(),   inName:= 'Проведен',    inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Erased(),     inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Erased(),     inName:= 'Удален',      inEnumName:= 'zc_Enum_Status_Erased');


     -- !!! Типы импорта
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_Excel(),  inDescId:= zc_Object_FileTypeKind(), inCode:= 1, inName:= 'Excel', inEnumName:= 'zc_Enum_FileTypeKind_Excel');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_DBF(), inDescId:= zc_Object_FileTypeKind(), inCode:= 2, inName:= 'DBF', inEnumName:= 'zc_Enum_FileTypeKind_DBF');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_MMO(), inDescId:= zc_Object_FileTypeKind(), inCode:= 3, inName:= 'MMO', inEnumName:= 'zc_Enum_FileTypeKind_MMO');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_ODBC(), inDescId:= zc_Object_FileTypeKind(), inCode:= 4, inName:= 'ODBC', inEnumName:= 'zc_Enum_FileTypeKind_ODBC');

     -- !!! Типы НДС
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_TaxKind_Basis(), inDescId:= zc_Object_TaxKind(), inCode:= 1, inName:= 'Базовый', inEnumName:= 'zc_Enum_TaxKind_Basis');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_TaxKind_Other(), inDescId:= zc_Object_TaxKind(), inCode:= 2, inName:= 'Другой', inEnumName:= 'zc_Enum_TaxKind_Other');
     -- PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_TaxKind_Basis(), 16);
     --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_TaxKind_(), 5);


     -- !!! Виды Boat Structure
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ProdColorKind_Hypalon(), inDescId:= zc_Object_ProdColorKind(), inCode:= 1, inName:= 'Hypalon', inEnumName:= 'zc_Enum_ProdColorKind_Hypalon');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ProdColorKind_Seat()   , inDescId:= zc_Object_ProdColorKind(), inCode:= 2, inName:= 'Seat'   , inEnumName:= 'zc_Enum_ProdColorKind_Seat');
     -- PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), zc_Enum_ProdColorKind_Hypalon(), 'zc_Enum_ProdColorKind_Hypalon');
     --PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), zc_Enum_ProdColorKind_Seat(), 'zc_Enum_ProdColorKind_Seat');

     
     -- !!! формы оплаты
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_FirstForm(),  inDescId:= zc_Object_PaidKind(), inCode:= 1, inName:= 'БН', inEnumName:= 'zc_Enum_PaidKind_FirstForm');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_SecondForm(), inDescId:= zc_Object_PaidKind(), inCode:= 2, inName:= 'Нал', inEnumName:= 'zc_Enum_PaidKind_SecondForm');

    
     -- !!! Типы аналитик для проводок
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SummIn(),   inDescId:= zc_Object_AnalyzerId(), inCode:= 1, inName:= 'Сумма с/с',    inEnumName:= 'zc_Enum_AnalyzerId_SummIn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SummCost(), inDescId:= zc_Object_AnalyzerId(), inCode:= 2, inName:= 'Сумма затрат', inEnumName:= 'zc_Enum_AnalyzerId_SummCost');


END $$;




DO $$
DECLARE vbId integer;
DECLARE vbUserId integer;
BEGIN
   -- !!!Нельзя вставить штатными средствами потому что не сработает проверка прав!!!
   vbUserId:=      (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData ILIKE 'Админ');

   IF COALESCE (vbUserId, 0) = 0
   THEN
       -- Создаем - Admin
       vbUserId := lpInsertUpdate_Object (0, zc_Object_User(), 0, 'Админ');
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), vbUserId, 'Админ');
   END IF;

   -- для Admin
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
       -- Соединяем пользователя с ролью
       vbId := lpInsertUpdate_Object (0, zc_Object_UserRole(), 0, '');
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), vbId, zc_Enum_Role_Admin());
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), vbId, vbUserId);

   END IF;

   
END $$;


--Загрузчик Лодок (всех справочников)
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Boat1() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Boat1() ;
    -- Создаем Тип загрузки 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка справочник Boat', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Boat_From_Excel', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Boat1');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка справочник Boat',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Boat1');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDateStart';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inDateStart', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Начало производства',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDateBegin';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inDateBegin', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Ввод в эксплуатацию',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDateSale';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inDateSale', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Продажа',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4,
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString',                        --ftInteger
                                                                inUserParamName := 'Артикл',
                                                                inImportTypeId  := vbImportTypeId,
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBrandName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inBrandName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Торг.Марка', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProdModelName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inProdModelName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Модель назв.', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCIN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inCIN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'CIN', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
                                                      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inprodEngineName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inprodEngineName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Мотор назв.', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPower';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inPower', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Мощность', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEngineNum';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inEngineNum', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер мотора', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
                                                      
                                                          vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inHours';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inHours', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Обслуживание,ч', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inHypalon1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inHypalon1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Цвет1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
                                                      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inHypalon2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inHypalon2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Цвет2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);      
                                                      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inHypalon3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 14, 
                                                                inName          := 'inHypalon3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Цвет3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'O',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);                                                

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inHypalon4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 15, 
                                                                inName          := 'inHypalon4', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Цвет4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'P',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inHypalon5';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 16, 
                                                                inName          := 'inHypalon5', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Цвет5', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);

    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Q',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFiberglassHull';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 17, 
                                                                inName          := 'inFiberglassHull', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Корпус', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'R',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFiberglassDeck';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 18, 
                                                                inName          := 'inFiberglassDeck', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Палуба', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'S',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);                                                 
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFiberglassSteeringConsole';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 19, 
                                                                inName          := 'inFiberglassSteeringConsole', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Консоль рулевого управления', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'T',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUpholstery1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 20, 
                                                                inName          := 'inUpholstery1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Обивка1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'U',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUpholstery2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 21, 
                                                                inName          := 'inUpholstery2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Обивка2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'V',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUpholstery3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 22, 
                                                                inName          := 'inUpholstery3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Обивка3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'W',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUpholstery4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 23, 
                                                                inName          := 'inUpholstery4', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Обивка4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'X',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStitchingColor';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 24, 
                                                                inName          := 'inStitchingColor', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Цвет строчки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Y',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStitchingType';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 25, 
                                                                inName          := 'inStitchingType', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Тип строчки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Z',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inColor1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 26, 
                                                                inName          := 'inColor1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Color1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AA',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inColor2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 27, 
                                                                inName          := 'inColor2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Color2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AB',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inColor3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 28, 
                                                                inName          := 'inColor3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Color3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AC',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inColor4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 29, 
                                                                inName          := 'inColor4', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Color4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AD',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inColor5';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 30, 
                                                                inName          := 'inColor5', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Color5', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AE',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 31, 
                                                                inName          := 'inOptionName1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AG',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 32, 
                                                                inName          := 'inOptionPartnumber1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AH',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 33, 
                                                                inName          := 'inOptionPrice1', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AI',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


---
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 34, 
                                                                inName          := 'inOptionName2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AJ',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 35, 
                                                                inName          := 'inOptionPartnumber2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AK',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 36, 
                                                                inName          := 'inOptionPrice2', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AL',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
---
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 37, 
                                                                inName          := 'inOptionName3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AM',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 38, 
                                                                inName          := 'inOptionPartnumber3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AN',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 39, 
                                                                inName          := 'inOptionPrice3', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AO',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 40, 
                                                                inName          := 'inOptionName4', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AP',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 41, 
                                                                inName          := 'inOptionPartnumber4', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AQ',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 42, 
                                                                inName          := 'inOptionPrice4', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AR',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


---
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName5';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 43, 
                                                                inName          := 'inOptionName5', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-5', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AS',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber5';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 44, 
                                                                inName          := 'inOptionPartnumber5', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-5', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AT',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice5';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 45, 
                                                                inName          := 'inOptionPrice5', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-5', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AU',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

---
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName6';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 46, 
                                                                inName          := 'inOptionName6', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-6', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AV',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber6';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 47, 
                                                                inName          := 'inOptionPartnumber6', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-6', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AW',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice6';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 48, 
                                                                inName          := 'inOptionPrice6', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-6', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AX',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


---
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName7';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 49, 
                                                                inName          := 'inOptionName7', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-7', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AY',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber7';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 50, 
                                                                inName          := 'inOptionPartnumber7', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-7', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AZ',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice7';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 51, 
                                                                inName          := 'inOptionPrice7', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-7', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BA',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

---
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionName8';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 52, 
                                                                inName          := 'inOptionName8', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Опция-8', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BB',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPartnumber8';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 53, 
                                                                inName          := 'inOptionPartnumber8', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер детали-8', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BC',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOptionPrice8';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 54, 
                                                                inName          := 'inOptionPrice8', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена опции-8', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BD',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


---------
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inLength';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 55, 
                                                                inName          := 'inLength', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Длина', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BF',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBeam';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 56, 
                                                                inName          := 'inBeam', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Ширина', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BG',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inHeight';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 57, 
                                                                inName          := 'inHeight', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Высота', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BH',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);



    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inWeight';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 58, 
                                                                inName          := 'inWeight', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Вес', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BI',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFuel';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 59, 
                                                                inName          := 'inFuel', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Запас топлива', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BJ',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inSpeed';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 60, 
                                                                inName          := 'inSpeed', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Скорость', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BK',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inSeating';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 61, 
                                                                inName          := 'inSeating', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Сиденья', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BL',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
       
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Boat Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TBoat1Form;zc_Object_ImportSetting_Boat1';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TBoat1Form","DescName":"zc_Object_ImportSettings_Boat1"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Boat1()::TBlob, inSession := ''::TVarChar);
END $$;



--Загрузчик Групп товаров
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_GoodsGroup() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_GoodsGroup() ;
    -- Создаем Тип загрузки 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка справочник Группы комплектующих', 
                                                       inProcedureName := 'gpInsertUpdate_Object_GoodsGroup_From_Excel', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_GoodsGroup');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка справочник Группы комплектующих',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_GoodsGroup');

    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCode', 
                                                                inParamType     := 'ftInteger',
                                                                inUserParamName := 'Код группы',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название группы', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);       
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Boat Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsGroupForm;zc_Object_ImportSetting_GoodsGroup';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsGroupForm","DescName":"zc_Object_ImportSettings_GoodsGroup"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_GoodsGroup()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик ПАРТНЕРОВ
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Partner() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Partner() ;
    -- Создаем Тип загрузки 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка справочник Поставщики', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Partner_From_Excel', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Partner');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка справочник Поставщики',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Partner');

    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCode', 
                                                                inParamType     := 'ftInteger',
                                                                inUserParamName := 'Код',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inName2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название +', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inName3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название группы', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inStreet';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inStreet', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Улица', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inShortName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inShortName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Краткое обозначение страны', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCity';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inCity', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Город', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFax';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inFax', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Факс', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPhone';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inPhone', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Телефон', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMobile';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inMobile', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Мобильный', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inIBAN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inIBAN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Р/счет', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Q',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBankName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inBankName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Банк', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'P',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMember';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inMember', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Контанктное лицо', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AD',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name ILIKE 'inWWW';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 14, 
                                                                inName          := 'inWWW', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Сайт', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AF',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEmail';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 15, 
                                                                inName          := 'inEmail', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Email', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AG',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCodeDB';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 16, 
                                                                inName          := 'inCodeDB', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Наш код в их базе', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AJ',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPLZ';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 17, 
                                                                inName          := 'inPLZ', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Почт.индекс', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Boat Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPartnerForm;zc_Object_ImportSetting_Partner';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPartnerForm","DescName":"zc_Object_ImportSettings_Partner"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Partner()::TBlob, inSession := ''::TVarChar);
END $$;





--Загрузчик Артикулов
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods() ;
    -- Создаем Тип загрузки 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка справочник Комплектующие', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Goods_From_Excel', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка справочник Комплектующие',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods');

    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString',   --ftInteger
                                                                inUserParamName := 'Артикул',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticleVergl';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inArticleVergl', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Артикул (альтернативный)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMatchcode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inMatchcode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код соответствия', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AD',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEAN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inEAN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'EAN код', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AE',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inASIN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inASIN',
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'ASIN код', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'CP',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFeeNumber';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inFeeNumber', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '№ таможенной пошлины', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BY',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsTag';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inGoodsTag', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Категотия', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProdColor';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inProdColor', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Цвет', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsSize';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inGoodsSize', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Размер', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsGroupCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inGoodsGroupCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код группы товара', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AB',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inPartnerCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код партнера', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AC',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inObjectCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код артикула', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AF',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsType';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 14, 
                                                                inName          := 'inGoodsType', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Тип детали', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AS',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inTaxKind';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 15, 
                                                                inName          := 'inTaxKind', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Вид НДС', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AT',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDiscountPartner';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 16, 
                                                                inName          := 'inDiscountPartner', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа скидки у партнера', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AR',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inComment1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 17, 
                                                                inName          := 'inComment1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Примечание 1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AX',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inComment2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 18, 
                                                                inName          := 'inComment2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Примечание 2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AY',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inModelEtiketen';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 19, 
                                                                inName          := 'inModelEtiketen', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Модель этикетки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AA',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name ILIKE 'inIsArc';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 20, 
                                                                inName          := 'inIsArc', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Архив', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BJ',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
------
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEKPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 21, 
                                                                inName          := 'inEKPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Закупочная цена без ндс', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEmpfPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 22, 
                                                                inName          := 'inEmpfPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Рекомендуемая цена без ндс', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'R',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMin';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 23, 
                                                                inName          := 'inMin', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Мин кол-во на складе', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AJ',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inRefer';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 24, 
                                                                inName          := 'inRefer', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Рекомендов кол-во закупки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'AN',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 25, 
                                                                inName          := 'inPrice1', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Розничная цена без ндс', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 26, 
                                                                inName          := 'inPrice2', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Розничная цена 2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Boat Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsForm;zc_Object_ImportSetting_Goods';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsForm","DescName":"zc_Object_ImportSettings_Goods"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик Статьи InfoMoney
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_InfoMoney() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_InfoMoney() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка справочник УП Статьи, назначение, группы', 
                                                       inProcedureName := 'gpInsertUpdate_Object_InfoMoney_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_InfoMoney');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка справочник УП Статьи, назначение, группы',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_InfoMoney');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код статьи',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inUnitCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код Подразделения',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inInfoMoneyName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inInfoMoneyName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Статья УП',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inInfoMoneyDestinationName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inInfoMoneyDestinationName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Аналитика - назначение',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inInfoMoneyGroupName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inInfoMoneyGroupName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа УпСт', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TInfoMoneyForm;zc_Object_ImportSetting_InfoMoney';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TInfoMoneyForm","DescName":"zc_Object_ImportSettings_InfoMoney"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_InfoMoney()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик Приходов
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_IncomeJournal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_IncomeJournal() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка документы Приход от Поставщика', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_Income_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_IncomeJournal');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка документы Приход от Поставщика',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_IncomeJournal');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прихода',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код комплектующего',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Article',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название комплектующего',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartNumber';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inPartNumber', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := '№ по техпаспорту', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена без НДС', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Количество', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEmpfPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inEmpfPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена рекомендованная без НДС', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperPriceList';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inOperPriceList', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена продажи', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TIncomeJournalForm;zc_Object_ImportSetting_IncomeJournal';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TIncomeJournalForm","DescName":"zc_Object_ImportSettings_IncomeJournal"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_IncomeJournal()::TBlob, inSession := ''::TVarChar);
END $$;

----
--Загрузчик Приходов S/N
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_IncomeSNJournal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_IncomeSNJournal() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка документы S/N Приход от Поставщика', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_IncomeSN_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_IncomeSNJournal');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка документы S/N Приход от Поставщика',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_IncomeSNJournal');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прихода',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Article',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartNumber';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPartNumber', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код поставщика (соответствия)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена без НДС', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'BH',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TIncomeJournalForm;zc_Object_ImportSetting_IncomeSNJournal';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TIncomeJournalForm","DescName":"zc_Object_ImportSettings_IncomeSNJournal"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_IncomeSNJournal()::TBlob, inSession := ''::TVarChar);
END $$;
------

--Загрузчик Счетов Account
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Account() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Account() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка справочник Счета, назначений, групп', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Account_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Account');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка справочник Счета, назначений, групп',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Account');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код статьи',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAccountName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inAccountName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Счет',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAccountDirectionName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inAccountDirectionName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Счет назначение',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAccountGroupName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inAccountGroupName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Счет группа', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TAccountForm;zc_Object_ImportSetting_Account';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TAccountForm","DescName":"zc_Object_ImportSettings_Account"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Account()::TBlob, inSession := ''::TVarChar);
END $$;





--загрузка Справочник <Шаблон сборка Модели> Child
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_ReceiptProdModelChild() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_ReceiptProdModelChild() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка комплектующих для справочника <Шаблон сборка Модели>', 
                                                       inProcedureName := 'gpInsert_Object_ReceiptProdModelChild_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_ReceiptProdModelChild');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка комплектующих для справочника <Шаблон сборка Модели>',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_ReceiptProdModelChild');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inReceiptProdModelId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inReceiptProdModelId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Шаблон',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inReceiptLevelId_top';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inReceiptLevelId_top', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Level',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код комплектующего',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Article',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Назначение комплектующего',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

     vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Количество', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TReceiptProdModelChildForm;zc_Object_ImportSetting_ReceiptProdModelChild';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TReceiptProdModelChildForm","DescName":"zc_Object_ImportSettings_ReceiptProdModelChild"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_ReceiptProdModelChild()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик Прайс листов
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListSkiDooJournal() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListSkiDooJournal() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Прайс лист от Поставщика SkiDoo', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_PriceListSkiDoo_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListSkiDooJournal');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Прайс лист от Поставщика SkiDoo',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListSkiDooJournal');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прихода',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Article',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Комплектующие', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasureName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inMeasureName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Ед.изм.', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasureParentName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inMeasureParentName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Ед.изм.(упаковки)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDiscountPartnerName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inDiscountPartnerName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа скидки у поставщика', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasureMult';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inMeasureMult', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Вложенность', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEmpfPriceParent';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inEmpfPriceParent', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'EmpfPriceParent', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceParent';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inPriceParent', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'PriceParent', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Amount', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListSkiDooJournalForm;zc_Object_ImportSetting_PriceListSkiDooJournal';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListSkiDooJournalForm","DescName":"zc_Object_ImportSettings_PriceListSkiDooJournal"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListSkiDooJournal()::TBlob, inSession := ''::TVarChar);
END $$;




--Загрузчик Прайс листов Osculati
--Загрузчик Прайс листов
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListOsculati() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListOsculati() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Прайс лист от Поставщика Osculati', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_PriceListOsculati_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListOsculati');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Прайс лист от Поставщика Osculati',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListOsculati');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прихода',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Article',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Комплектующие', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasureName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inMeasureName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Ед.изм.', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'O',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFeeNumber';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inFeeNumber', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'номер таможенной пошлины', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'W',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

       vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasureMult';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inMeasureMult', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Вложенность', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEmpfPriceParent';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inEmpfPriceParent', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Рекомендованная цена без ндс (упаковки)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'U',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceParent';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inPriceParent', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена без ндс (упаковки)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена без ндс', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'P',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinCount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inMinCount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'min кол-во закупки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinCountMult';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inMinCountMult', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'рекомендуемое кол-во закупки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'V',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inWeightParent';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inWeightParent', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'WeightParent', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'X',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar); 
     
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inisOutlet';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 14, 
                                                                inName          := 'inisOutlet', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Outlet', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);     
                                                      

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName_ita';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 15, 
                                                                inName          := 'inGoodsName_ita', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Перевод товар ITA', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName_eng';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 16, 
                                                                inName          := 'inGoodsName_eng', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Перевод товар ENG', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName_fra';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 17, 
                                                                inName          := 'inGoodsName_fra', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Перевод товар FRA', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasure_ita';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 18, 
                                                                inName          := 'inMeasure_ita', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Перевод ед.изм. ITA', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasureParentName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 19, 
                                                                inName          := 'inMeasureParentName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Ед.изм (упаковки)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDiscountPartnerName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 20, 
                                                                inName          := 'inDiscountPartnerName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа скидки у поставщика', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'R',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEAN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 21, 
                                                                inName          := 'inEAN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код EAN', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'S',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCatalogPage';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 22, 
                                                                inName          := 'inCatalogPage', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'CatalogPage', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'T',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


                                       
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListOsculatiForm;zc_Object_ImportSetting_PriceListOsculati';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListOsculatiForm","DescName":"zc_Object_ImportSettings_PriceListOsculati"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListOsculati()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик Прайс листов Gotthardt
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListGotthardt() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListGotthardt() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Прайс лист от Поставщика Gotthardt', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_PriceListGotthardt_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListGotthardt');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Прайс лист от Поставщика Gotthardt',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListGotthardt');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прихода',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Article',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Комплектующие', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMeasureName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inMeasureName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Ед.изм.', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена без ндс', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinCount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inMinCount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'min кол-во закупки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinCountMult';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inMinCountMult', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'рекомендуемое кол-во закупки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
      

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inEAN';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inEAN', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код EAN', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
                                       
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListGotthardtForm;zc_Object_ImportSetting_PriceListGotthardt';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListGotthardtForm","DescName":"zc_Object_ImportSettings_PriceListGotthardt"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListGotthardt()::TBlob, inSession := ''::TVarChar);
END $$;




--Загрузчик Прайс листов Uflex1
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListUflex1() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListUflex1() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Прайс лист UFLEX-1', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_PriceListUflex1_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListUflex1');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Прайс лист UFLEX-1',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 7,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListUflex1');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прайса',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Part No.(Article)',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName_fra';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsName_fra', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Description', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBrandName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inBrandName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Brand', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inModelName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inModelName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Model', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCategory1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inCategory1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Category 1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCategory2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inCategory2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Category 2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAccess';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inAccess', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Access/Spares', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
                             
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCatalogueSection';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inCatalogueSection', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Catalogue Section', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCatalogPage';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inCatalogPage', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Pages', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена за ед.', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'O',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 14, 
                                                                inName          := 'inAmount2', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Унитарная цена', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListUflex1Form;zc_Object_ImportSetting_PriceListUflex1';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListUflex1Form","DescName":"zc_Object_ImportSettings_PriceListUflex1"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListUflex1()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик Прайс листов Uflex2
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListUflex2() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListUflex2() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Прайс лист UFLEX-2', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_PriceListUflex2_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListUflex2');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Прайс лист UFLEX-2',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 11,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListUflex2');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прайса',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Part No.(Article)',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Description (Название)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inModelName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inModelName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Model', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена за ед.(Euro)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListUflex2Form;zc_Object_ImportSetting_PriceListUflex2';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListUflex2Form","DescName":"zc_Object_ImportSettings_PriceListUflex2"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListUflex2()::TBlob, inSession := ''::TVarChar);
END $$;




--Загрузчик  ReceiptGoods  Шаблон сборка УЗЛОВ (новые товары)
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_ReceiptGoods() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_ReceiptGoods() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Шаблон сборка УЗЛОВ (новые товары)', 
                                                       inProcedureName := 'gpInsertUpdate_Object_ReceiptGoods_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_ReceiptGoods');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Шаблон сборка УЗЛОВ (новые товары)',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_ReceiptGoods');

    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Артикул-результат',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название-результат', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGroupName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inGroupName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа-результат', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle_child';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inArticle_child', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Артикул-комплект/узел', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName_child';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsName_child', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название-комплект/узел', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGroupName_child';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inGroupName_child', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа-комплект/узел', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Количество', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TReceiptGoodsForm;zc_Object_ImportSetting_ReceiptGoods';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TReceiptGoodsForm","DescName":"zc_Object_ImportSettings_ReceiptGoods"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_ReceiptGoods()::TBlob, inSession := ''::TVarChar);
END $$;




--Загрузчик Прайс листов Uflex1
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListGoodsArticle() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListGoodsArticle() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Прайс лист c GoodsArticle', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_PriceListGoodsArticle_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListGoodsArticle');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Прайс лист c GoodsArticle',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListGoodsArticle');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прайса',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Article',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsArticle1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsArticle1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'inGoodsArticle 1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsArticle2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inGoodsArticle2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'GoodsArticle 2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsArticle3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inGoodsArticle3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'GoodsArticle 3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsArticle4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inGoodsArticle4', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'GoodsArticle 4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inFeet';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inFeet', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Feet', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMetres';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inMetres', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Metres', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Price', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);


END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListGoodsArticleForm;zc_Object_ImportSetting_PriceListGoodsArticle';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListGoodsArticleForm","DescName":"zc_Object_ImportSettings_PriceListGoodsArticle"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListGoodsArticle()::TBlob, inSession := ''::TVarChar);
END $$;



--Загрузчик Справочник <Статьи отчета о прибылях и убытках> ProfitLoss
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_ProfitLoss() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_ProfitLoss() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка справочник Статьи отчета о прибылях и убытках, назначений, групп', 
                                                       inProcedureName := 'gpInsertUpdate_Object_ProfitLoss_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_ProfitLoss');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка справочник Статьи отчета о прибылях и убытках, назначений, групп',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_ProfitLoss');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProfitLossCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inProfitLossCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код статьи',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProfitLossName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inProfitLossName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'статья',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProfitLossDirectionName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inProfitLossDirectionName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'статья назначение',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProfitLossGroupName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inProfitLossGroupName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'статья группа', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TProfitLossForm;zc_Object_ImportSetting_ProfitLoss';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TProfitLossForm","DescName":"zc_Object_ImportSettings_ProfitLoss"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_ProfitLoss()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик Прайс листов ASG EMEA
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PriceListASGEMEA() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PriceListASGEMEA() ;
    -- Создаем 
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка Прайс лист ASG EMEA', 
                                                       inProcedureName := 'gpInsertUpdate_Movement_PriceListASGEMEA_Load', 
                                                       inJSONParamName := '' ::TVarChar,
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PriceListASGEMEA');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка Прайс лист ASG EMEA',
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
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PriceListASGEMEA');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inOperDate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inOperDate', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата прайса',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMovementId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inMovementId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор Документа',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPartnerId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inArticle';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inArticle', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Part No.(Article)',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Description (Название)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGroupName1';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inGroupName1', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа 1', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGroupName2';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inGroupName2', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа 2', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'O',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGroupName3';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inGroupName3', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа 3', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'P',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGroupName4';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inGroupName4', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа 4', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);


    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Q',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);
                                                      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDiscountPartnerName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inDiscountPartnerName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Группа скидки у поставщика', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinCount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inMinCount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'min кол-во закупки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinCountMult';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inMinCountMult', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'рекомендуемое кол-во закупки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена за ед.(Euro)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inConvertFormatInExcel := FALSE ::Boolean,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceListASGEMEAForm;zc_Object_ImportSetting_PriceListASGEMEA';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceListASGEMEAForm","DescName":"zc_Object_ImportSettings_PriceListASGEMEA"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PriceListASGEMEA()::TBlob, inSession := ''::TVarChar);
END $$;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.22         * Загрузчик прайс ASG EMEA
 10.04.22         * PriceListGoodsArticle
 04.04.22         * Загрузчик Прайс листов Uflex1
                    Загрузчик Шаблон сборка УЗЛОВ (новые товары)
 02.03.22         * Загрузчик Прайс листов Gotthardt
 20.02.22         * загрузка Прайс Листа SkiDoo
 03.03.21         * загрузка Счетов
 25.02.21         * загрузка приходов
 02.02.21         * Загрузчик Статьи InfoMoney
 15.11.20         * загрузка Артикулов
 09.11.20         * загрузка групп товаров
 11.10.20         *
 24.08.20                                        *
*/
