--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

-- Это универсальное свойство, может использоваться у всех объектов
CREATE OR REPLACE FUNCTION zc_ObjectString_Enum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Enum', NULL, 'Функция бизнес-логики' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum');


CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_Comment', zc_Object_Asset(), 'Asset_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_FullName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_FullName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_FullName', zc_Object_Asset(), 'Asset_FullName' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_FullName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_InvNumber', zc_object_Asset(), 'Инвентарный номер Основных средств' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_InvNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_PassportNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_PassportNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_PassportNumber', zc_Object_Asset(), 'Asset_PassportNumber' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_PassportNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_SerialNumber', zc_Object_Asset(), 'Asset_SerialNumber' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Bank_MFO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_MFO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Bank_MFO', zc_object_Bank(), 'Bank_MFO' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_MFO');

CREATE OR REPLACE FUNCTION zc_ObjectString_Bank_SWIFT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_SWIFT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Bank_SWIFT', zc_object_Bank(), 'Bank_SWIFT' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_SWIFT');

CREATE OR REPLACE FUNCTION zc_ObjectString_Bank_IBAN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_IBAN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Bank_IBAN', zc_object_Bank(), 'Bank_IBAN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_IBAN');

CREATE OR REPLACE FUNCTION zc_ObjectString_BankAccount_CorrespondentAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CorrespondentAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_BankAccount_CorrespondentAccount', zc_Object_BankAccount(), 'BankAccount_CorrespondentAccount' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CorrespondentAccount');

CREATE OR REPLACE FUNCTION zc_ObjectString_BankAccount_BeneficiarysBankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysBankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_BankAccount_BeneficiarysBankAccount', zc_Object_BankAccount(), 'BankAccount_BeneficiarysBankAccount' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysBankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectString_BankAccount_BeneficiarysAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_BankAccount_BeneficiarysAccount', zc_Object_BankAccount(), 'BankAccount_BeneficiarysAccount' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysAccount');



CREATE OR REPLACE FUNCTION zc_ObjectString_Car_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Car_RegistrationCertificate', zc_object_Car(), 'Техпаспорт Автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate');

-- CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
--  SELECT 'zc_ObjectString_Contract_InvNumber', zc_Object_Contract(), 'Contract_InvNumber' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_BankAccount', zc_Object_Contract(), 'Contract_BankAccount' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_Comment', zc_Object_Contract(), 'Contract_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_InvNumberArchive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_InvNumberArchive', zc_Object_Contract(), 'Contract_InvNumberArchive' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_GLNCode', zc_Object_Contract(), 'Код GLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode');


CREATE OR REPLACE FUNCTION zc_ObjectString_ContactPerson_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ContactPerson_Comment', zc_Object_ContactPerson(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ContactPerson_Mail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ContactPerson_Mail', zc_Object_ContactPerson(), 'Электронная почта' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail');

CREATE OR REPLACE FUNCTION zc_ObjectString_ContactPerson_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ContactPerson_Phone', zc_Object_ContactPerson(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone');

CREATE OR REPLACE FUNCTION zc_objectString_Currency_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_objectString_Currency_InternalName', zc_object_Currency(), 'Currency_InternalName' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName');

-- zc_Object_Goods                           

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_GroupNameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_GroupNameFull', zc_Object_Goods(), 'Полное название группы' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Maker', zc_Object_Goods(), 'Производитель' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_Article() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_Article', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_Article' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_ArticleGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_ArticleGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_ArticleGLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN');

-- zc_Object_GoodsPropertyValue
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCode', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCodeGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCodeGLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN');


CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_GLNCode', zc_object_Juridical(), 'Juridical_GLNCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Comment', zc_object_Member(), 'Примечание Физ.лица ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_DriverCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_DriverCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_DriverCertificate', zc_object_Member(), 'Водительское удостоверение Физ.лица ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_DriverCertificate');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_EMail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_EMail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_EMail', zc_object_Member(), 'Водительское удостоверение Физ.лица ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_EMail');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_INN', zc_object_Member(), 'ИНН Физ.лица ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_INN');

CREATE OR REPLACE FUNCTION zc_ObjectString_ModelService_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelService_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ModelService_Comment', zc_Object_ModelService(), 'ModelService_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelService_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ModelServiceItemMaster_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemMaster_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ModelServiceItemMaster_Comment', zc_Object_ModelServiceItemMaster(), 'ModelServiceItemMaster_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemMaster_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ModelServiceItemChild_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemChild_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ModelServiceItemChild_Comment', zc_Object_ModelServiceItemChild(), 'ModelServiceItemChild_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemChild_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ModelServiceKind_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceKind_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ModelServiceKind_Comment', zc_Object_ModelServiceKind(), 'ModelServiceKind_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceKind_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GLNCode', zc_object_Partner(), 'Partner_GLNCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Address', zc_object_Partner(), 'Адрес точки доставки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_HouseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_HouseNumber', zc_object_Partner(), 'Номер дома' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_CaseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_CaseNumber', zc_object_Partner(), 'Номер корпуса' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_RoomNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_RoomNumber', zc_object_Partner(), 'Номер квартиры' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_ShortName', zc_object_Partner(), 'Короткое обозначение' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReceiptChild_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReceiptChild_Comment', zc_Object_ReceiptChild(), 'Составляющие рецептур - Значение' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Receipt_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Receipt_Code', zc_Object_Receipt(), 'Код рецептуры' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code');

CREATE OR REPLACE FUNCTION zc_ObjectString_Receipt_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Receipt_Comment', zc_Object_Receipt(), 'Комментарий' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ToolsWeighing_NameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ToolsWeighing_NameFull', zc_ObjectString_ToolsWeighing_NameFull(), 'Полное название' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull');

CREATE OR REPLACE FUNCTION zc_ObjectString_ToolsWeighing_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ToolsWeighing_Name', zc_ObjectString_ToolsWeighing_Name(), 'Название' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name');

CREATE OR REPLACE FUNCTION zc_ObjectString_ToolsWeighing_NameUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ToolsWeighing_NameUser', zc_ObjectString_ToolsWeighing_NameUser(), 'Название для пользователя' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser');

CREATE OR REPLACE FUNCTION zc_ObjectString_StaffList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StaffList_Comment', zc_Object_StaffList(), 'StaffList_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffList_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StaffListCost_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListCost_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StaffListCost_Comment', zc_Object_StaffListCost(), 'StaffListCost_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListCost_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StaffListSumm_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSumm_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StaffListSumm_Comment', zc_Object_StaffListSumm(), 'ModelServiceItemChild_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSumm_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StaffListSummKind_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSummKind_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StaffListSummKind_Comment', zc_Object_StaffListSummKind(), 'StaffListSummKind_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSummKind_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Street_PostalCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Street_PostalCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Street_PostalCode', zc_Object_Street(), 'Street_PostalCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Street_PostalCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_CityKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CityKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CityKind_ShortName', zc_Object_CityKind(), 'Короткое обозначение' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CityKind_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_StreetKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StreetKind_ShortName', zc_Object_StreetKind(), 'Короткое обозначение' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName');


--
CREATE OR REPLACE FUNCTION zc_ObjectString_User_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Password', zc_Object_User(), 'Пароль пользователя' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password');

CREATE OR REPLACE FUNCTION zc_ObjectString_WorkTimeKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_WorkTimeKind_ShortName', zc_Object_WorkTimeKind(), 'Короткое наименование' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Measure_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Measure_InternalName', zc_Object_Measure(), 'Международное наименование' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Measure_InternalCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Measure_InternalCode', zc_Object_Measure(), 'Международный код' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_GroupName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_GroupName', zc_Object_GoodsPropertyValue(), 'Название группы' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Retail_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Retail_GLNCode', zc_Object_Retail(), 'Код GLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode');

---zc_Object_GoodsQuality

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value1', zc_Object_GoodsQuality(), 'Вид оболонки, колонка 4' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value2', zc_Object_GoodsQuality(), 'Термін зберігання, колонка 6' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value3', zc_Object_GoodsQuality(), 'Термін зберіг. в газ.серед.(флаупак), колонка 7' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value4', zc_Object_GoodsQuality(), 'Термін зберігання в газ.середовищ, колонка 8' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value5', zc_Object_GoodsQuality(), 'Вакуумна упаковка - Термін зберігання цілим виробом, колонка 10' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value6', zc_Object_GoodsQuality(), 'Вакуумна упаковка - Термін зберігання порційна нарізка, колонка 11' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value7', zc_Object_GoodsQuality(), 'Вакуумна упаковка - Термін зберігання серверувальна нарізка, колонка 12' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value8', zc_Object_GoodsQuality(), 'Температура зберігання в вакуумі та модифікованому газовому середовищі, колонка 14' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value9', zc_Object_GoodsQuality(), 'Температура зберігання в газовому середовищі, колонка 15' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value10', zc_Object_GoodsQuality(), 'Умови зберігання, колонка 16' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10');



---!!! Аптека
CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Code', zc_Object_Goods(), 'Строковый код' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportSettings_Directory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportSettings_Directory', zc_Object_ImportSettings(), 'Директория загрузки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportType_ProcedureName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportType_ProcedureName', zc_Object_ImportType(), 'Имя процедуры' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportTypeItems_ParamType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportTypeItems_ParamType', zc_Object_ImportTypeItems(), 'Тип параметра процедуры' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportTypeItems_UserParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportTypeItems_UserParamName', zc_Object_ImportTypeItems(), 'Пользовательское название параметра процедуры' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportSettingsItems_DefaultValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportSettingsItems_DefaultValue', zc_Object_ImportSettingsItems(), 'Значения по умолчанию' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.12.14         * add zc_ObjectString_GoodsQuality_Value1-10
 10.10.14                                                        * + zc_ObjectString_Bank_SWIFT, zc_ObjectString_Bank_IBAN, zc_ObjectString_BankAccount_BeneficiarysAccount, zc_ObjectString_BankAccount_BeneficiarysBankAccount, zc_ObjectString_BankAccount_СorrespondentAccount
 09.10.14                                                        * + zc_ObjectString_Measure_InternalName, zc_ObjectString_Measure_InternalCode, zc_ObjectString_GoodsPropertyValue_GroupName
 31.05.14         * add
 12.03.14                                                        * + zc_ObjectString_ToolsWeighing_NameFull, zc_ObjectString_ToolsWeighing_Name, zc_ObjectString_ToolsWeighing_NameUser

 11.02.14         * add Asset_ (5 свойств)
 13.01.14                                        * add zc_ObjectString_Goods_GroupNameFull
 06.01.14                                        * add zc_ObjectString_Partner_Address
 21.11.13         * add zc_ObjectString_ModelServiceKind_Comment, zc_ObjectString_StaffListSummKind_Comment
 30.10.13         * add zc_ObjectString_StaffListSumm_Comment
 19.10.13         * add zc_ObjectString_ModelService_Comment,
                        zc_ObjectString_StaffListCost_Comment
                        zc_ObjectString_ModelServiceItemMaster_Comment
                        zc_ObjectString_ModelServiceItemChild_Comment

 19.10.13                                        * del zc_ObjectString_Contract_InvNumber()
 18.10.13         * add zc_ObjectString_StaffList_Comment
 01.10.13         * add zc_ObjectString_WorkTimeKind_ShortName
 27.08.13         * перевод на Новую Схему 2
 04.07.13         * перевод всего на новую схему
 28.06.13                                        * НОВАЯ СХЕМА
*/