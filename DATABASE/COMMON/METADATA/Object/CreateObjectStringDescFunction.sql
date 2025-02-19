--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

-- Это универсальное свойство, может использоваться у всех объектов
CREATE OR REPLACE FUNCTION zc_ObjectString_Enum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Enum', NULL, 'Функция бизнес-логики' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum');

CREATE OR REPLACE FUNCTION zc_ObjectString_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GUID', zc_Object_ReplServer(), 'Ключ реплики' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GUID');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_Host() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Host'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_Host', zc_Object_ReplServer(), 'Сервер' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Host');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_User', zc_Object_ReplServer(), 'Пользоатель' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_User');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_Password', zc_Object_ReplServer(), 'Пароль' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Password');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_Port() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Port'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_Port', zc_Object_ReplServer(), 'Порт' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Port');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_DataBase() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_DataBase'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_DataBase', zc_Object_ReplServer(), 'База данных' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_DataBase');

--
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

CREATE OR REPLACE FUNCTION zc_ObjectString_BankAccount_CBAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_BankAccount_CBAccount', zc_Object_BankAccount(), 'Счет - для выгрузки в клиент банк' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccount');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_Car_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Car_Comment', zc_Object_Car(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Car_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Car_RegistrationCertificate', zc_object_Car(), 'Техпаспорт Автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate');

CREATE OR REPLACE FUNCTION zc_ObjectString_Car_VIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_VIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Car_VIN', zc_Object_Car(), ' 	VIN-код' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_VIN');

CREATE OR REPLACE FUNCTION zc_ObjectString_Car_EngineNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_EngineNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Car_EngineNum', zc_Object_Car(), 'Номер двигателя' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_EngineNum');


CREATE OR REPLACE FUNCTION zc_ObjectString_CarExternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CarExternal_Comment', zc_Object_CarExternal(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_CarExternal_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CarExternal_RegistrationCertificate', zc_object_CarExternal(), 'Техпаспорт Автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate');

CREATE OR REPLACE FUNCTION zc_ObjectString_CarExternal_VIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_VIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CarExternal_VIN', zc_Object_CarExternal(), ' 	VIN-код' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_VIN');


-- CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
--  SELECT 'zc_ObjectString_Contract_InvNumber', zc_Object_Contract(), 'Contract_InvNumber' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_BankAccount', zc_Object_Contract(), 'Расчетный счет (исх.платеж)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_BankAccountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_BankAccountPartner', zc_Object_Contract(), 'Расчетный счет (покупателя)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccountPartner');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_Comment', zc_Object_Contract(), 'Contract_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_InvNumberArchive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_InvNumberArchive', zc_Object_Contract(), 'Contract_InvNumberArchive' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_GLNCode', zc_Object_Contract(), 'Код GLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_PartnerCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_PartnerCode', zc_Object_Contract(), 'Код поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode');


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

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_UKTZED', zc_Object_Goods(), 'Код товару згідно з УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_UKTZED_main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_UKTZED_main', zc_Object_Goods(), 'Код товару згідно з УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_main');


CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_DKPP', zc_Object_Goods(), 'Послуги згідно з ДКПП' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_TaxImport', zc_Object_Goods(), 'Ознака імпортованого товару' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_TaxAction', zc_Object_Goods(), 'Код виду діяльності сільск-господар товаровиробника ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_RUS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_RUS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_RUS', zc_Object_Goods(), 'Название товара(русс.)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_RUS');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_BUH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_BUH', zc_Object_Goods(), 'Название товара(бухг.)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_BUH');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_Article() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_Article', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_Article' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_ArticleGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_ArticleGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_ArticleGLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_NameUkr', zc_Object_Goods(), 'Название украинское' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_CodeUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_CodeUKTZED', zc_Object_Goods(), 'Код УКТЗЭД' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_UKTZED_new', zc_Object_Goods(), 'Новый код товару згідно з УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_new');


CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_ShortName', zc_Object_Goods(), 'Название сокращенное' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Scale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Scale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Scale', zc_Object_Goods(), 'Название товара(для приложения Scale)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Scale');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Comment', zc_Object_Goods(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Comment');





-- zc_Object_GoodsPropertyValue
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCodeShort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCodeShort', zc_Object_GoodsPropertyValue(), 'Часть штрих кода (поиск при сканировании)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCode', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCodeGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCodeGLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_CodeSticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_CodeSticker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_CodeSticker', zc_Object_GoodsPropertyValue(), 'zc_ObjectString_GoodsPropertyValue_CodeSticker' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_CodeSticker');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_Quality2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_Quality2', zc_Object_GoodsPropertyValue(), 'Строк придатності (КУ)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality2');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_Quality10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_Quality10', zc_Object_GoodsPropertyValue(), 'Умови зберігання (КУ)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality10');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_Quality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_Quality', zc_Object_GoodsPropertyValue(), 'Значение ГОСТ, ДСТУ,ТУ (КУ)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_NameExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_NameExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_NameExternal', zc_Object_GoodsPropertyValue(), 'Название в базе покупателя' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_NameExternal');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_ArticleExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_ArticleExternal', zc_Object_GoodsPropertyValue(), 'Артикул в базе покупателя' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleExternal');


CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_GLNCode', zc_Object_Juridical(), 'Juridical_GLNCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_OrderSumm', zc_Object_Juridical(), 'Примечание к минимальной сумме для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_OrderTime', zc_Object_Juridical(), 'информативно - максимальное время отправки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_GUID', zc_Object_Juridical(), 'Глобальный уникальный идентификатор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID');


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

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardChild', zc_object_Member(), '№ карточного счета ЗП - алименты (удержание)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardChild');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Street() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Street'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Street', zc_object_Member(), 'Улица, номер дома, номер квартиры, адрес прописки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Street');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Street_Real() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Street_Real'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Street_Real', zc_object_Member(), 'Улица, номер дома, номер квартиры, адрес проживания' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Street_Real');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Children1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Children1', zc_object_Member(), 'Ребенок 1, ФИО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children1');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Children2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Children2', zc_object_Member(), 'Ребенок 2, ФИО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children2');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Children3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Children3', zc_object_Member(), 'Ребенок 3, ФИО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children3');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Children4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Children4', zc_object_Member(), 'Ребенок 4, ФИО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children4');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Children5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Children5', zc_object_Member(), 'Ребенок 5, ФИО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Children5');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Law() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Law'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Law', zc_object_Member(), 'Судимости' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Law');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_DriverCertificateAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_DriverCertificateAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_DriverCertificateAdd', zc_object_Member(), 'Водительское удостоверение для вождения кары и т.п.' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_DriverCertificateAdd');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_PSP_S() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_S'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_PSP_S', zc_object_Member(), 'Паспорт, серия' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_S');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_PSP_N() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_N'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_PSP_N', zc_object_Member(), 'Паспорт, номер' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_N');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_PSP_W() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_W'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_PSP_W', zc_object_Member(), 'Паспорт, кем выдан' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_W');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_PSP_D() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_D'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_PSP_D', zc_object_Member(), 'Паспорт, дата выдачи' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_PSP_D');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_GLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_GLN', zc_object_Member(), 'GLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_GLN');

-- Ф1
CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Card() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Card'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Card', zc_object_Member(), '№ карточного счета ЗП (Ф1)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Card');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardIBAN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBAN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardIBAN', zc_object_Member(), '№ карточного счета IBAN ЗП (Ф1)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBAN');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardBank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardBank', zc_object_Member(), '№ банковской карточки ЗП (Ф1)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBank');

-- Ф2 - Восток
CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardSecond', zc_object_Member(), '№ карточного счета ЗП (Ф2 - Восток)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecond');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardIBANSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBANSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardIBANSecond', zc_object_Member(), '№ карточного счета IBAN ЗП (Ф2 - Восток)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBANSecond');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardBankSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBankSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardBankSecond', zc_object_Member(), '№ банковской карточки ЗП (Ф2 - Восток)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBankSecond');

-- Ф2 - ОТП
CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardSecondTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecondTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardSecondTwo', zc_object_Member(), '№ карточного счета ЗП (Ф2 - ОТП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecondTwo');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardIBANSecondTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBANSecondTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardIBANSecondTwo', zc_object_Member(), '№ карточного счета IBAN ЗП (Ф2 - ОТП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBANSecondTwo');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardBankSecondTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBankSecondTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardBankSecondTwo', zc_object_Member(), '№ банковской карточки ЗП (Ф2 - ОТП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBankSecondTwo');

-- Ф2 - личный
CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardSecondDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecondDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardSecondDiff', zc_object_Member(), '№ карточного счета ЗП (Ф2 - личный) ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecondDiff');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardIBANSecondDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBANSecondDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardIBANSecondDiff', zc_object_Member(), '№ карточного счета IBAN ЗП (Ф2 - личный)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardIBANSecondDiff');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardBankSecondDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBankSecondDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardBankSecondDiff', zc_object_Member(), '№ банковской карточки ЗП (Ф2 - личный)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardBankSecondDiff');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Phone', zc_object_Member(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Phone');


CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Code1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Code1C'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Code1C', zc_object_Member(), 'Код 1С' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Code1C');


---
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

-- !!!временно!!!
CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_NameInteger() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_NameInteger', zc_Object_Partner(), 'Название Integer' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GLNCode', zc_Object_Partner(), 'Partner_GLNCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GLNCodeJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GLNCodeJuridical', zc_Object_Partner(), 'Partner_GLNCodeJuridical' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeJuridical');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GLNCodeRetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeRetail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GLNCodeRetail', zc_Object_Partner(), 'Partner_GLNCodeRetail' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeRetail');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GLNCodeCorporate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeCorporate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GLNCodeCorporate', zc_Object_Partner(), 'Partner_GLNCodeCorporate' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeCorporate');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Address', zc_Object_Partner(), 'Адрес точки доставки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_HouseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_HouseNumber', zc_Object_Partner(), 'Номер дома' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_CaseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_CaseNumber', zc_Object_Partner(), 'Номер корпуса' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_RoomNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_RoomNumber', zc_Object_Partner(), 'Номер квартиры' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_KATOTTG() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_KATOTTG'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_KATOTTG', zc_Object_Partner(), 'КАТОТТГ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_KATOTTG');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_ShortName', zc_Object_Partner(), 'Короткое обозначение' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Schedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Schedule', zc_Object_Partner(), 'График посещения' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Delivery() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Delivery', zc_Object_Partner(), 'График завоза' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GUID', zc_Object_Partner(), 'Глобальный уникальный идентификатор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Movement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Movement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Movement', zc_Object_Partner(), 'Примечание(для Накладной продажи)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Movement');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_BranchCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_BranchCode', zc_Object_Partner(), 'Номер филиала' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_BranchJur() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchJur'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_BranchJur', zc_Object_Partner(), 'Название юр.лица для филиала' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchJur');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Terminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Terminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Terminal', zc_Object_Partner(), 'Код терминала' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Terminal');

 
 
 

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

CREATE OR REPLACE FUNCTION zc_ObjectString_User_PasswordWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PasswordWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_PasswordWages', zc_Object_User(), 'Парль для просмотра своей зарплаты' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PasswordWages');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Sign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Sign', zc_Object_User(), 'Электронная подпись' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Seal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Seal', zc_Object_User(), 'Электронная печать' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Key() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Key', zc_Object_User(), 'Электроный Ключ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Foto', zc_Object_User(), 'Путь к фото' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_PhoneAuthent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PhoneAuthent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_PhoneAuthent', zc_Object_User(), '№ телефона для Аутентификации' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PhoneAuthent');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_GUID', zc_Object_User(), 'UUID сессии пользователя' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_GUID');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_SMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_SMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_SMS', zc_Object_User(), 'SMS для идентификации ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_SMS');

 
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
  SELECT 'zc_ObjectString_Retail_GLNCode', zc_Object_Retail(), 'Код GLN - Получатель' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Retail_GLNCodeCorporate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Retail_GLNCodeCorporate', zc_Object_Retail(), ' КодGLN - Поставщик' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate');

CREATE OR REPLACE FUNCTION zc_ObjectString_Retail_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Retail_OKPO', zc_Object_Retail(), 'ОКПО для налог. документов' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_OKPO');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsByGoodsKind_Quality1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsByGoodsKind_Quality1', zc_Object_GoodsByGoodsKind(), 'Вид оболонки, колонка 4' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality1');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsByGoodsKind_Quality11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsByGoodsKind_Quality11', zc_Object_GoodsByGoodsKind(), 'Вид пакування/стан продукції' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality11');

---zc_Object_GoodsQuality

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
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

--!!!Quality
CREATE OR REPLACE FUNCTION zc_ObjectString_Quality_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Quality_Comment', zc_Object_Quality(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Quality_MemberMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Quality_MemberMain', zc_Object_Quality(), 'Заступник директора підприємства' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain');

CREATE OR REPLACE FUNCTION zc_ObjectString_Quality_MemberTech() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Quality_MemberTech', zc_Object_Quality(), 'Технолог виробництва' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech');


CREATE OR REPLACE FUNCTION zc_ObjectString_InvNumberTax_InvNumberBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_InvNumberTax_InvNumberBranch', zc_Object_InvNumberTax(), 'Номер филиала' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch');

CREATE OR REPLACE FUNCTION zc_ObjectString_Branch_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Branch_InvNumber', zc_Object_Branch(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Branch_PlaceOf() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Branch_PlaceOf', zc_Object_Branch(), 'Місце складання' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf');

CREATE OR REPLACE FUNCTION zc_ObjectString_Branch_PersonalBookkeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PersonalBookkeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Branch_PersonalBookkeeper', zc_Object_Branch(), 'Сотрудник (бухгалтер) подписант' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PersonalBookkeeper');

CREATE OR REPLACE FUNCTION zc_ObjectString_Form_HelpFile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Form_HelpFile', zc_Object_Form(), 'Путь к файлу помощи' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Address', zc_object_Unit(), 'Адрес' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Phone', zc_object_Unit(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Comment', zc_object_Unit(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment');


CREATE OR REPLACE FUNCTION zc_ObjectString_Storage_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Storage_Address', zc_object_Storage(), 'Адрес места' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Storage_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Storage_Comment', zc_object_Storage(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Storage_Room() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Room'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Storage_Room', zc_object_Storage(), 'Кабинет' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Room');



CREATE OR REPLACE FUNCTION zc_ObjectString_SignInternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SignInternal_Comment', zc_object_SignInternal(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileEmployee_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileEmployee_Comment', zc_Object_MobileEmployee(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileTariff_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileTariff_Comment', zc_Object_MobileTariff(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileConst_MobileVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileConst_MobileVersion', zc_Object_MobileConst(), 'Версия мобильного приложения' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileConst_MobileAPKFileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileConst_MobileAPKFileName', zc_Object_MobileConst(), 'Название ".apk" файла мобильного приложения' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_SheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SheetWorkTime_Comment', zc_Object_SheetWorkTime(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_SheetWorkTime_DayOffPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SheetWorkTime_DayOffPeriod', zc_Object_SheetWorkTime(), 'Периодичность в днях' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod');

CREATE OR REPLACE FUNCTION zc_ObjectString_SheetWorkTime_DayOffWeek() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SheetWorkTime_DayOffWeek', zc_Object_SheetWorkTime(), 'Дни недели' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsListSale_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsListSale_GoodsKind', zc_Object_GoodsListSale(), 'Список всех вид товара' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsListIncome_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsListIncome_GoodsKind', zc_Object_GoodsListIncome(), 'Список всех вид товара' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_UKTZED', zc_Object_GoodsGroup(), 'Код товару згідно з УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_UKTZED_new', zc_Object_GoodsGroup(), 'Новый код товару згідно з УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED_new');


CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_DKPP', zc_Object_GoodsGroup(), 'Послуги згідно з ДКПП' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_TaxImport', zc_Object_GoodsGroup(), 'Ознака імпортованого товару' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_TaxAction', zc_Object_GoodsGroup(), 'Код виду діяльності сільск-господар товаровиробника' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction');

CREATE OR REPLACE FUNCTION zc_ObjectString_StorageLine_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StorageLine_Comment', zc_Object_StorageLine(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ArticleLoss_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ArticleLoss_Comment', zc_Object_ArticleLoss(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_StickerGroup_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerGroup_Comment', zc_Object_StickerGroup(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerType_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerType_Comment', zc_Object_StickerType(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerTag_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerTag_Comment', zc_Object_StickerTag(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerSort_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerSort_Comment', zc_Object_StickerSort(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerNorm_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerNorm_Comment', zc_Object_StickerNorm(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerFile_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerFile_Comment', zc_Object_StickerFile(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerSkin_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerSkin_Comment', zc_Object_StickerSkin(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerPack_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerPack_Comment', zc_Object_StickerPack(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Comment', zc_Object_Language(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value1', zc_Object_Language(), 'Склад:' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value2', zc_Object_Language(), 'Умови та термін зберігання:' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value3', zc_Object_Language(), 'за відносної вологості повітря від' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value4', zc_Object_Language(), 'до' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value5', zc_Object_Language(), 'за температури від' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value6', zc_Object_Language(), 'до' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value7', zc_Object_Language(), 'не більш ніж' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value8', zc_Object_Language(), 'Поживна цінність та калорійність В 100гр.продукта:' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value9', zc_Object_Language(), 'білки не менше' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value10', zc_Object_Language(), 'гр' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value11', zc_Object_Language(), 'жири не більше' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value12', zc_Object_Language(), 'гр' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value13() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value13', zc_Object_Language(), 'кКал' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value14() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value14'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value14', zc_Object_Language(), 'діб.' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value14');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value15() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value15'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value15', zc_Object_Language(), 'вуглеводи не більше:' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value15');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value16() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value16'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value16', zc_Object_Language(), 'гр' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value16');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value17() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value17'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value17', zc_Object_Language(), 'кДж' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value17');

---
CREATE OR REPLACE FUNCTION zc_ObjectString_StickerProperty_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerProperty_BarCode', zc_Object_StickerProperty(), 'Штрихкод' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSheetWorkTime_Comment', zc_Object_MemberSheetWorkTime(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberPersonalServiceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberPersonalServiceList_Comment', zc_Object_MemberPersonalServiceList(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_DocumentTaxKind_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DocumentTaxKind_Code', zc_Object_DocumentTaxKind(), 'Код причины' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Code');

CREATE OR REPLACE FUNCTION zc_ObjectString_DocumentTaxKind_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DocumentTaxKind_Goods', zc_Object_DocumentTaxKind(), 'Номенклатура' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectString_DocumentTaxKind_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DocumentTaxKind_Measure', zc_Object_DocumentTaxKind(), 'Ед.изм.' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Measure');

CREATE OR REPLACE FUNCTION zc_ObjectString_DocumentTaxKind_MeasureCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_MeasureCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DocumentTaxKind_MeasureCode', zc_Object_DocumentTaxKind(), 'Код ед.изм.' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_MeasureCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsTypeKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsTypeKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsTypeKind_ShortName', zc_object_GoodsTypeKind(), 'Короткое обозначение' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsTypeKind_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_OrderFinance_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_OrderFinance_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_OrderFinance_Comment', zc_object_OrderFinance(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_OrderFinance_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberExternal_DriverCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_DriverCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberExternal_DriverCertificate', zc_object_MemberExternal(), 'Водительское удостоверение' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_DriverCertificate');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberExternal_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberExternal_INN', zc_object_MemberExternal(), 'ИНН Физ.лица(стороннего)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_INN');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberExternal_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_GLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberExternal_GLN', zc_object_MemberExternal(), 'GLN Физ.лица(стороннего)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_GLN');


CREATE OR REPLACE FUNCTION zc_ObjectString_MemberMinus_BankAccountTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_BankAccountTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberMinus_BankAccountTo', zc_object_MemberMinus(), '№ счета получателя платежа' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_BankAccountTo');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberMinus_DetailPayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_DetailPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberMinus_DetailPayment', zc_object_MemberMinus(), 'Назначение платежа' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_DetailPayment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberMinus_ToShort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_ToShort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberMinus_ToShort', zc_object_MemberMinus(), 'Юр. лицо (сокращенное значение)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_ToShort');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberMinus_Number() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_Number'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberMinus_Number', zc_object_MemberMinus(), '№ исполнительного листа' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_Number');


CREATE OR REPLACE FUNCTION zc_ObjectString_PartnerExternal_ObjectCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerExternal_ObjectCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PartnerExternal_ObjectCode', zc_object_PartnerExternal(), 'Код внешний' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerExternal_ObjectCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_JuridicalOrderFinance_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalOrderFinance_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_JuridicalOrderFinance_Comment', zc_object_JuridicalOrderFinance(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalOrderFinance_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_PersonalServiceList_ContentType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_ContentType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PersonalServiceList_ContentType', zc_Object_PersonalServiceList(), ' Content-Type' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_ContentType');

CREATE OR REPLACE FUNCTION zc_ObjectString_PersonalServiceList_OnFlowType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_OnFlowType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PersonalServiceList_OnFlowType', zc_Object_PersonalServiceList(), 'Вид начисления в банке' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_OnFlowType');

CREATE OR REPLACE FUNCTION zc_ObjectString_FineSubject_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FineSubject_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_FineSubject_Comment', zc_Object_FineSubject(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FineSubject_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReceiptLevel_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptLevel_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReceiptLevel_Comment', zc_Object_ReceiptLevel(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptLevel_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Reason_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Reason_Comment', zc_Object_Reason(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobilePack_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobilePack_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobilePack_Comment', zc_Object_MobilePack(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobilePack_Comment');


CREATE OR REPLACE FUNCTION zc_ObjectString_SmsSettings_Login() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Login'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SmsSettings_Login', zc_Object_SmsSettings(), 'Login' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Login');

CREATE OR REPLACE FUNCTION zc_ObjectString_SmsSettings_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SmsSettings_Password', zc_Object_SmsSettings(), 'Password' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Password');

CREATE OR REPLACE FUNCTION zc_ObjectString_SmsSettings_Message() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Message'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SmsSettings_Message', zc_Object_SmsSettings(), 'Message' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Message');

CREATE OR REPLACE FUNCTION zc_ObjectString_PairDay_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PairDay_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PairDay_Comment', zc_object_PairDay(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PairDay_Comment');

/*
CREATE OR REPLACE FUNCTION zc_ObjectString_Area_TelegramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Area_TelegramId', zc_object_Area(), 'Группа получателей в рассылке Акций' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramId');

 CREATE OR REPLACE FUNCTION zc_ObjectString_Area_TelegramBotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramBotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Area_TelegramBotToken', zc_object_Area(), 'Токен отправителя телеграм бота в рассылке Акций' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramBotToken');
 */
 
CREATE OR REPLACE FUNCTION zc_ObjectString_TelegramGroup_Id() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_Id'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_TelegramGroup_Id', zc_object_Area(), 'Группа получателей в рассылке Акций' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_Id');

 CREATE OR REPLACE FUNCTION zc_ObjectString_TelegramGroup_BotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_BotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_TelegramGroup_BotToken', zc_object_TelegramGroup(), 'Токен отправителя телеграм бота в рассылке Акций' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_BotToken');


 CREATE OR REPLACE FUNCTION zc_ObjectString_MemberReport_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberReport_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberReport_Comment', zc_object_MemberReport(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberReport_Comment');


 CREATE OR REPLACE FUNCTION zc_ObjectString_PartionCell_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionCell_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PartionCell_Comment', zc_object_PartionCell(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionCell_Comment');


 CREATE OR REPLACE FUNCTION zc_ObjectString_ViewPriceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ViewPriceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ViewPriceList_Comment', zc_object_ViewPriceList(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ViewPriceList_Comment');

 CREATE OR REPLACE FUNCTION zc_ObjectString_ChoiceCell_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ChoiceCell_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ChoiceCell_Comment', zc_object_ChoiceCell(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ChoiceCell_Comment');

 CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsNormDiff_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsNormDiff_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsNormDiff_Comment', zc_object_GoodsNormDiff(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsNormDiff_Comment');
   
 CREATE OR REPLACE FUNCTION zc_ObjectString_RouteNum_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RouteNum_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_RouteNum_Comment', zc_object_RouteNum(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RouteNum_Comment');

 CREATE OR REPLACE FUNCTION zc_ObjectString_SiteTag_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SiteTag_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SiteTag_Comment', zc_object_SiteTag(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SiteTag_Comment');

 CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroupProperty_QualityINN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroupProperty_QualityINN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroupProperty_QualityINN', zc_object_GoodsGroupProperty(), 'Ідентифікаційний номер тварини від якої отримано сировину' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroupProperty_QualityINN');

 CREATE OR REPLACE FUNCTION zc_ObjectString_MessagePersonalService_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MessagePersonalService_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MessagePersonalService_Comment', zc_object_MessagePersonalService(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MessagePersonalService_Comment');

  






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
  
CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Foto', zc_Object_Goods(), 'Путь к фото' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto');
  
CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Thumb() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Thumb', zc_Object_Goods(), 'Путь к превью фото' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Phone', zc_object_Member(), 'Телефон Физ.лица ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Address', zc_object_Member(), 'Место проживания Физ.лица ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Email_ErrorTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Email_ErrorTo', zc_object_Email(), 'Кому отправлять сообщение об ошибке при загрузке данных с п/я' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo');


CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternal_URL() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_URL'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternal_URL', zc_object_DiscountExternal(), 'URL' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_URL');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternal_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternal_Service', zc_object_DiscountExternal(), 'Service' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Service');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternal_Port() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Port'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternal_Port', zc_object_DiscountExternal(), 'Port' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Port');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternalTools_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternalTools_User', zc_object_DiscountExternalTools(), 'User' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_User');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternalTools_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternalTools_Password', zc_object_DiscountExternalTools(), 'Password' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Password');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternalTools_ExternalUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_ExternalUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternalTools_ExternalUnit', zc_Object_DiscountExternalTools(), 'Подразделение проекта' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_ExternalUnit');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternalJuridical_ExternalJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical', zc_Object_DiscountExternalJuridical(), 'Юридическое лицо проекта' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Pack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Pack', zc_object_Goods(), 'Сила дії/ дозування (5)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_CodeATX() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_CodeATX', zc_object_Goods(), 'Код АТХ (7)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_ReestrSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_ReestrSP', zc_object_Goods(), '№ реєстраційного посвідчення на лікарський засіб (9)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_ReestrDateSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_ReestrDateSP', zc_object_Goods(), 'Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб(10)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_MakerSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_MakerSP', zc_object_Goods(), 'Найменування виробника, країна(8)(СП)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_ProjectMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_ProjectMobile', 'Серийный № моб устр-ва' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_MobileModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileModel', 'Модель моб устр-ва' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_MobileVesion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesion', 'Версия Андроид устр-ва' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_MobileVesionSDK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesionSDK', 'Версия SDK устр-ва' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK');
  

CREATE OR REPLACE FUNCTION zc_ObjectString_PartnerMedical_FIO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PartnerMedical_FIO', zc_object_PartnerMedical(), 'ГлавВрач' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Address', zc_object_Unit(), 'Адрес аптеки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_GLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_GLN', zc_object_Unit(), 'GLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_GLN');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_KATOTTG() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_KATOTTG'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_KATOTTG', zc_object_Unit(), 'КАТОТТГ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_KATOTTG');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_AddressEDIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AddressEDIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_AddressEDIN', zc_object_Unit(), 'Адрес для EDIN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AddressEDIN');



CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_OrderSumm', zc_Object_Contract(), 'Примечание к минимальной сумме для заказа' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_OrderTime', zc_Object_Contract(), 'информативно - максимальное время отправки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime');

CREATE OR REPLACE FUNCTION zc_ObjectString_Area_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Area_Email', zc_Object_Area(), 'На какой адрес приходит инфа по прайсам для этого региона' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email');

CREATE OR REPLACE FUNCTION zc_ObjectString_JuridicalArea_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_JuridicalArea_Email', zc_Object_JuridicalArea(), 'На какой адрес ПОСТАВЩИКА мы отправляем инфу по заказам для этого региона' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email');

CREATE OR REPLACE FUNCTION zc_ObjectString_PromoCode_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PromoCode_Comment', zc_Object_PromoCode(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Fiscal_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Fiscal_SerialNumber', zc_Object_Fiscal(), 'омер заводской' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Fiscal_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Fiscal_InvNumber', zc_Object_Fiscal(), 'номер фискальный' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportType_JSONParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportType_JSONParamName', zc_Object_ImportType(), 'Имя процедуры' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName');
  
CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSP_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSP_INN', zc_object_MemberSP(), 'ИНН пациента' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_INN');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSP_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSP_Address', zc_object_MemberSP(), 'Адрес пациента' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSP_Passport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Passport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSP_Passport', zc_object_MemberSP(), 'Серия и номер паспорта пациента' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Passport');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_OKPO', zc_Object_ClientsByBank(), 'ОКПО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_INN', zc_Object_ClientsByBank(), 'ИНН' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_Phone', zc_Object_ClientsByBank(), 'Телефоны' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_ContactPerson', zc_Object_ClientsByBank(), 'Контактное лицо' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_RegAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_RegAddress', zc_Object_ClientsByBank(), 'Адрес регистрации' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_SendingAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_SendingAddress', zc_Object_ClientsByBank(), 'Адрес отправки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_Accounting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_Accounting', zc_Object_ClientsByBank(), 'Бухгалтерия' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_PhoneAccountancy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_PhoneAccountancy', zc_Object_ClientsByBank(), 'Телефон бухгалтерии' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_Comment', zc_Object_ClientsByBank(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_SerialNumber', zc_Object_Asset(), 'Asset_SerialNumber' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashRegister_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashRegister_SerialNumber', zc_Object_CashRegister(), 'Номер заводской' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_SerialNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_HelsiEnum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_HelsiEnum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_HelsiEnum', zc_Object_HelsiEnum(), 'Параметр доступа к сайту Хелси' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_HelsiEnum');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Helsi_UserName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Helsi_UserName', zc_Object_User(), 'Имя пользователя на сайте Хелси' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserName');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Helsi_UserPassword() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserPassword'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Helsi_UserPassword', zc_Object_User(), 'Пароль пользователя на сайте Хелси' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserPassword');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Helsi_KeyPassword() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_KeyPassword'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Helsi_KeyPassword', zc_Object_User(), 'Пароль к файловому ключу' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_KeyPassword');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Helsi_PasswordEHels() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_PasswordEHels'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Helsi_PasswordEHels', zc_Object_User(), 'Пароль Е-Хелс' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_PasswordEHels');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Analog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Analog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Analog', zc_Object_Goods(), 'Перечень аналогов товара' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Analog');

CREATE OR REPLACE FUNCTION zc_ObjectString_Driver_E_Mail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Driver_E_Mail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Driver_E_Mail', zc_Object_Driver(), 'e-mail для отправки реестра перемещений' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Driver_E_Mail');
 
CREATE OR REPLACE FUNCTION zc_ObjectString_PayrollType_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollType_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PayrollType_ShortName', zc_Object_PayrollType(), 'Короткое наименование' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollType_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_CBName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_CBName', zc_Object_Juridical(), 'Полное название поставщика для клиент банка' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_CBMFO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBMFO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_CBMFO', zc_Object_Juridical(), 'МФО для клиент банка' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBMFO');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_CBAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_CBAccount', zc_Object_Juridical(), 'Расчетный счет для клиент банка' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccount');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_CBAccountOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccountOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_CBAccountOld', zc_Object_Juridical(), 'Расчетный счет старый для клиент банка' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccountOld');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_CBPurposePayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBPurposePayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_CBPurposePayment', zc_ObjectString_Juridical_CBPurposePayment(), 'Назначение платежа для клиент банка' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBPurposePayment');

CREATE OR REPLACE FUNCTION zc_ObjectString_BankAccount_CBAccountOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccountOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_BankAccount_CBAccountOld', zc_Object_BankAccount(), 'Счет старый - для выгрузки в клиент банк' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccountOld');


CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Latitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Latitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Latitude', zc_object_Unit(), 'Географическая широта' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Latitude');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Longitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Longitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Longitude', zc_object_Unit(), 'Географическая долгота' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Longitude');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_ListDaySUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_ListDaySUN', zc_object_Unit(), 'По каким дням недели по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashSettings_ShareFromPriceName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashSettings_ShareFromPriceName', zc_Object_CashSettings(), 'Перечень фраз в названиях товаров которые можно делить с любой ценой' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceName');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashSettings_ShareFromPriceCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashSettings_ShareFromPriceCode', zc_Object_CashSettings(), 'Перечень кодов товаров которые можно делить с любой ценой' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_AccessKeyYF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AccessKeyYF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_AccessKeyYF', zc_object_Unit(), 'Ключ ХО для отправки данных Юрия-Фарм' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AccessKeyYF');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_ListDaySUN_pi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN_pi'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_ListDaySUN_pi', zc_object_Unit(), 'По каким дням недели формируется СУН2-перемещ.излишков' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN_pi');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_SUN_v1_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v1_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_SUN_v1_Lock', zc_object_Unit(), 'запрет в СУН-1 для 1)подключать чек "не для НТЗ" 2)товары "закрыт код" 3)товары "убит код"' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v1_Lock');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_SUN_v2_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v2_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_SUN_v2_Lock', zc_object_Unit(), 'запрет в СУН-2 для 1)подключать чек "не для НТЗ" 2)товары "закрыт код" 3)товары "убит код"' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v2_Lock');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_SUN_v4_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v4_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_SUN_v4_Lock', zc_object_Unit(), 'запрет в СУН-2-пи для 1)подключать чек "не для НТЗ" 2)товары "закрыт код" 3)товары "убит код"' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v4_Lock');


CREATE OR REPLACE FUNCTION zc_ObjectString_Buyer_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Buyer_Name', zc_Object_Buyer(), 'Фамилия Имя Отчество' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Name');

CREATE OR REPLACE FUNCTION zc_ObjectString_Buyer_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Buyer_Phone', zc_Object_Buyer(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_Buyer_EMail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_EMail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Buyer_EMail', zc_object_Buyer(), 'Электронная почта' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_EMail');

CREATE OR REPLACE FUNCTION zc_ObjectString_Buyer_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Buyer_Address', zc_object_Buyer(), 'Место проживания' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Buyer_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Buyer_Comment', zc_object_Buyer(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Buyer_DateBirth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_DateBirth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Buyer_DateBirth', zc_object_Buyer(), 'Дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_DateBirth');

CREATE OR REPLACE FUNCTION zc_ObjectString_Buyer_Sex() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Sex'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Buyer_Sex', zc_object_Buyer(), 'Пол' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Sex');

CREATE OR REPLACE FUNCTION zc_ObjectString_DriverSun_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DriverSun_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DriverSun_Phone', zc_Object_DriverSun(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DriverSun_Phone');
 
CREATE OR REPLACE FUNCTION zc_ObjectString_CashRegister_ComputerName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ComputerName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashRegister_ComputerName', zc_Object_CashRegister(), 'Имя компютера' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ComputerName');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashRegister_BaseBoardProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_BaseBoardProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashRegister_BaseBoardProduct', zc_Object_CashRegister(), 'Материнская плата' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_BaseBoardProduct');
 
CREATE OR REPLACE FUNCTION zc_ObjectString_CashRegister_ProcessorName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ProcessorName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashRegister_ProcessorName', zc_Object_CashRegister(), 'Процессор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ProcessorName');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashRegister_DiskDriveModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_DiskDriveModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashRegister_DiskDriveModel', zc_Object_CashRegister(), 'Жесткий Диск' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_DiskDriveModel');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashRegister_TaxRate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_TaxRate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashRegister_TaxRate', zc_Object_CashRegister(), 'Налоговые ставки' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_TaxRate');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashRegister_PhysicalMemory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_PhysicalMemory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashRegister_PhysicalMemory', zc_Object_CashRegister(), 'Оперативная память' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_PhysicalMemory');
 

CREATE OR REPLACE FUNCTION zc_ObjectString_Hardware_BaseBoardProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_BaseBoardProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Hardware_BaseBoardProduct', zc_Object_Hardware(), 'Материнская плата' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_BaseBoardProduct');
 
CREATE OR REPLACE FUNCTION zc_ObjectString_Hardware_ProcessorName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ProcessorName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Hardware_ProcessorName', zc_Object_Hardware(), 'Процессор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ProcessorName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Hardware_DiskDriveModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_DiskDriveModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Hardware_DiskDriveModel', zc_Object_Hardware(), 'Жесткий Диск' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_DiskDriveModel');

CREATE OR REPLACE FUNCTION zc_ObjectString_Hardware_PhysicalMemory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_PhysicalMemory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Hardware_PhysicalMemory', zc_Object_Hardware(), 'Оперативная память' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_PhysicalMemory');
   
CREATE OR REPLACE FUNCTION zc_ObjectString_Hardware_Identifier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Identifier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Hardware_Identifier', zc_Object_Hardware(), 'Идентификатор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Identifier');

CREATE OR REPLACE FUNCTION zc_ObjectString_Hardware_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Hardware_Comment', zc_Object_Hardware(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_AnalogATC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_AnalogATC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_AnalogATC', zc_Object_Goods(), 'Перечень аналогов товара ATC' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_AnalogATC');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_ActiveSubstance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ActiveSubstance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_ActiveSubstance', zc_Object_Goods(), 'Действующее вещество' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ActiveSubstance');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternalTools_Token() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Token'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternalTools_Token', zc_Object_DiscountExternalTools(), 'API токен' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Token');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberBranch_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberBranch_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberBranch_Comment', zc_Object_MemberBranch(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberBranch_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_PromoForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PromoForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_PromoForSale', zc_object_Unit(), 'Маркетинговый контракт для заполнения врачей и покупателей' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PromoForSale');

CREATE OR REPLACE FUNCTION zc_ObjectString_BuyerForSale_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSale_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_BuyerForSale_Phone', zc_Object_BuyerForSale(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSale_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_Hardware_ComputerName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ComputerName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Hardware_ComputerName', zc_Object_Hardware(), 'Имя компьютера' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ComputerName');
 
CREATE OR REPLACE FUNCTION zc_ObjectString_Instructions_FileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Instructions_FileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Instructions_FileName', zc_Object_Instructions(), 'Имя файла' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Instructions_FileName');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_LikiDnepr_UserEmail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_UserEmail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_LikiDnepr_UserEmail', zc_Object_User(), 'E-mail провизора Е-Хелс для МИС «Каштан»' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_UserEmail');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_LikiDnepr_PasswordEHels() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_PasswordEHels'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_LikiDnepr_PasswordEHels', zc_Object_User(), 'Пароль Е-Хелс для регистрации через МИС «Каштан»' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_PasswordEHels');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberPriceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPriceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberPriceList_Comment', zc_Object_MemberPriceList(), ' 	Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPriceList_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_BuyerForSite_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSite_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_BuyerForSite_Phone', zc_Object_BuyerForSite(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSite_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_RecalcMCSSheduler_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RecalcMCSSheduler_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_RecalcMCSSheduler_Comment', zc_Object_RecalcMCSSheduler(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RecalcMCSSheduler_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Personal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Personal_Comment', zc_Object_Personal(), 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Personal_Code1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Code1C'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Personal_Code1C', zc_Object_Personal(), 'Код 1С' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Code1C');

CREATE OR REPLACE FUNCTION zc_ObjectString_PayrollTypeVIP_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollTypeVIP_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PayrollTypeVIP_ShortName', zc_Object_PayrollTypeVIP(), 'Короткое наименование' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollTypeVIP_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_PromoBonusName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_PromoBonusName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_PromoBonusName', zc_Object_Goods(), 'Наименование бонусных упаковок по акции' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_PromoBonusName');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberIC_InsuranceCardNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberIC_InsuranceCardNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberIC_InsuranceCardNumber', zc_Object_MemberIC(), 'Номер страховой карты' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberIC_InsuranceCardNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_MedicalProgramSP_ProgramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MedicalProgramSP_ProgramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MedicalProgramSP_ProgramId', zc_Object_MedicalProgramSP(), 'Идентификатор медицинской программы' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MedicalProgramSP_ProgramId');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_PharmacyManager() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManager'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_PharmacyManager', zc_object_Unit(), 'ФИО Зав. аптекой' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManager');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_PharmacyManagerPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManagerPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_PharmacyManagerPhone', zc_object_Unit(), 'Телефон Зав. аптекой' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManagerPhone');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_TokenKashtan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TokenKashtan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_TokenKashtan', zc_object_Unit(), 'Токен аптечной сети в МИС «Каштан»' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TokenKashtan');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_TelegramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TelegramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_TelegramId', zc_object_Unit(), 'ID аптеки в Telegram	' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TelegramId');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashSettings_TelegramBotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_TelegramBotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashSettings_TelegramBotToken', zc_Object_CashSettings(), 'Токен телеграм бота' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_TelegramBotToken');

CREATE OR REPLACE FUNCTION zc_ObjectString_SurchargeWages_Description() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SurchargeWages_Description'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SurchargeWages_Description', zc_Object_SurchargeWages(), 'Описание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SurchargeWages_Description');

CREATE OR REPLACE FUNCTION zc_ObjectString_Education_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Education_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Education_NameUkr', zc_Object_Education(), 'Наименование на Украинском языке' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Education_NameUkr');
  
CREATE OR REPLACE FUNCTION zc_ObjectString_Member_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_NameUkr', zc_Object_Member(), 'ФИО на Украинском языке' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_NameUkr');  

CREATE OR REPLACE FUNCTION zc_ObjectString_FormDispensing_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FormDispensing_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_FormDispensing_NameUkr', zc_Object_FormDispensing(), 'Название украинское' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FormDispensing_NameUkr');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_MakerUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_MakerUkr', zc_Object_Goods(), 'Производитель украинское название' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerUkr');


CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsWhoCan_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsWhoCan_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsWhoCan_NameUkr', zc_Object_GoodsWhoCan(), 'Название украинское' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsWhoCan_NameUkr');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsMethodAppl_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsMethodAppl_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsMethodAppl_NameUkr', zc_Object_GoodsMethodAppl(), 'Название украинское' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsMethodAppl_NameUkr');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsSignOrigin_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsSignOrigin_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsSignOrigin_NameUkr', zc_Object_GoodsSignOrigin(), 'Название украинское' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsSignOrigin_NameUkr');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Dosage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Dosage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Dosage', zc_Object_Goods(), 'Дозировка' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Dosage');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Volume() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Volume'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Volume', zc_Object_Goods(), 'Объем' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Volume');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_GoodsWhoCan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GoodsWhoCan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_GoodsWhoCan', zc_Object_Goods(), 'Кому можно' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GoodsWhoCan');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_SetDateRROList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SetDateRROList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_SetDateRROList', zc_Object_Unit(), 'Перечень дат авто установки времени на РРО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SetDateRROList');

CREATE OR REPLACE FUNCTION zc_ObjectString_InternetRepair_Provider() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Provider'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_InternetRepair_Provider', zc_Object_InternetRepair(), 'Провайдер' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Provider');

CREATE OR REPLACE FUNCTION zc_ObjectString_InternetRepair_ContractNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_ContractNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_InternetRepair_ContractNumber', zc_Object_InternetRepair(), 'Номер договора' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_ContractNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_InternetRepair_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_InternetRepair_Phone', zc_Object_InternetRepair(), 'Телефон' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_InternetRepair_WhoSignedContract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_WhoSignedContract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_InternetRepair_WhoSignedContract', zc_Object_InternetRepair(), 'Кто оформил договор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_WhoSignedContract');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Language() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Language'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Language', zc_Object_User(), 'Язык справочников кассы' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Language');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_IdSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_IdSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_IdSP', zc_Object_Goods(), 'ID лікарського засобу в СП' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_IdSP');

CREATE OR REPLACE FUNCTION zc_ObjectString_CashSettings_SendCashErrorTelId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_SendCashErrorTelId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CashSettings_SendCashErrorTelId', zc_Object_CashSettings(), 'ID в телеграм для отправки ошибок на кассах' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_SendCashErrorTelId');

CREATE OR REPLACE FUNCTION zc_ObjectString_PartionGoods_PartNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionGoods_PartNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectString_PartionGoods_PartNumber', ' Серийный номер  (№ по тех паспорту)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionGoods_PartNumber');
  
CREATE OR REPLACE FUNCTION zc_ObjectString_SubjectDoc_Short() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Short'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_Short', 'Сокращенное название' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Short');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SubjectDoc_Reason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectLink_SubjectDoc_Reason', 'Причина возврата / перемещения' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason');

CREATE OR REPLACE FUNCTION zc_ObjectString_SubjectDoc_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_MovementDesc', 'Вид документа' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_MovementDesc');

CREATE OR REPLACE FUNCTION zc_ObjectString_SubjectDoc_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_Comment', 'Примечание' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Comment');


               
CREATE OR REPLACE FUNCTION zc_ObjectString_Reason_Short() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Short'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_Reason(), 'zc_ObjectString_Reason_Short', 'Сокращенное название' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Short');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Подмогильный В.В.   Шаблий О.В.
 19.02.25         * zc_ObjectString_MessagePersonalService_Comment
 21.01.25         * zc_ObjectString_GoodsGroupProperty_QualityINN
 02.12.24         * zc_ObjectString_SiteTag_Comment
 28.10.24         * zc_ObjectString_Member_Code1C
 22.06.24         * zc_ObjectString_ViewPriceList_Comment
 15.03.24         * zc_ObjectString_Member_Phone
 26.02.24         * zc_ObjectString_Member_CardBankSecondTwo
                    zc_ObjectString_Member_CardIBANSecondTwo()
                    zc_ObjectString_Member_CardSecondTwo()
                    zc_ObjectString_Member_CardBankSecondDiff()
                    zc_ObjectString_Member_CardIBANSecondDiff() 
                    zc_ObjectString_Member_CardSecondDiff()
 27.12.23         * zc_ObjectString_PartionCell_Comment
 23.11.23         * zc_ObjectString_SubjectDoc_MovementDesc
 21.11.23         * zc_ObjectLink_SubjectDoc_Reason
 20.11.23                                                                                                         * zc_ObjectString_SubjectDoc_Short, zc_ObjectString_Reason_Short
 09.11.23         * zc_ObjectString_Goods_UKTZED_new
 17.07.23         * zc_ObjectString_Car_EngineNum
 11.07.23         * zc_ObjectString_Unit_AddressEDIN
 06.07.23                                                                                                         * zc_ObjectString_Partner_KATOTTG 
 10.05.23         * zc_ObjectString_Member_GLN
                    zc_ObjectString_MemberExternal_GLN
 29.03.23         * zc_ObjectString_GoodsGroup_UKTZED_new
 19.02.23                                                                                                         * zc_ObjectString_CashSettings_SendCashErrorTelId
 27.01.23         * zc_ObjectString_Partner_Movement
 14.11.22         * zc_ObjectString_MemberReport_Comment
 31.10.22                                                                                                         * zc_ObjectString_Goods_IdSP
 30.09.22                                                                                                         * zc_ObjectString_User_Language
 20.09.22         * zc_ObjectString_TelegramGroup_Id
                    zc_ObjectString_TelegramGroup_BotToken

 16.09.22         * zc_ObjectString_Area_TelegramId
                    zc_ObjectString_Area_TelegramBotToken
 12.09.22                                                                                                         * zc_ObjectString_InternetRepair...
 06.09.22                                                                                                         * zc_ObjectString_Unit_SetDateRROList
 20.08.22                                                                                                         * zc_ObjectString_Goods_GoodsWhoCan
 28.07.22                                                                                                         * zc_ObjectString_GoodsWhoCan_NameUkr, zc_ObjectString_GoodsMethodAppl_NameUkr
 18.07.22                                                                                                         * zc_ObjectString_FormDispensing_NameUkr, zc_ObjectString_Goods_MakerUkr
 24.06.22                                                                                                         * zc_ObjectString_Education_NameUkr, zc_ObjectString_Member_NameUkr
 22.12.21         * zc_ObjectString_MemberMinus_Number
 25.11.21                                                                                                         * zc_ObjectString_SurchargeWages_Description
 22.11.21         * zc_ObjectString_PairDay_Comment
 08.11.21                                                                                                         * zc_ObjectString_CashSettings_TelegramBotToken
 02.11.21                                                                                                         * zc_ObjectString_Unit_TelegramId
 22.10.21                                                                                                         * zc_ObjectString_Unit_TokenKashtan
 13.10.21                                                                                                         * zc_ObjectString_Unit_PharmacyManager, zc_ObjectString_Unit_PharmacyManagerPhone
 04.10.21         * zc_ObjectString_Unit_Comment
 01.10.21                                                                                                         * zc_ObjectString_MedicalProgramSP_ProgramId
 20.09.21                                                                                                         * zc_ObjectString_MemberIC_InsuranceCardNumber
 16.09.21                                                                                                         * zc_ObjectString_Goods_PromoBonusName
 14.09.21                                                                                                         * zc_ObjectString_PayrollTypeVIP_ShortName
 09.09.21         * zc_ObjectString_Member_CardBank
                    zc_ObjectString_Member_CardBankSecond
 06.08.21         * zc_ObjectString_Personal_Comment
 12.07.21         * zc_ObjectString_MobilePack_Comment
 14.06.21         * zc_ObjectString_ReceiptLevel_Comment
 13.05.21         * zc_ObjectString_User_PhoneAuthent
                    zc_ObjectString_User_GUID
 11.05.21                                                                                                         * zc_ObjectString_RecalcMCSSheduler_Comment  
 28.04.21         * zc_ObjectString_FineSubject_Comment
 20.04.21                                                                                                         * zc_ObjectString_BuyerForSite_Phone  
 18.04.21         * zc_ObjectString_MemberPriceList_Comment
 13.04.21                                                                                                         * zc_ObjectString_User_LikiDnepr_UserEmail, zc_ObjectString_User_LikiDnepr_PasswordEHels   
 18.03.21         * zc_ObjectString_PersonalServiceList_OnFlowType
                    zc_ObjectString_PersonalServiceList_ContentType
 16.02.21                                                                                                         * zc_ObjectString_Instructions_FileName  
 27.01.21                                                                                                         * zc_ObjectString_Hardware_ComputerName  
 02.11.20         * zc_ObjectString_GoodsPropertyValue_ArticleExternal
 30.10.20         * zc_ObjectString_PartnerExternal_ObjectCode
 30.10.20                                                                                                         * zc_ObjectString_Unit_PromoForSale  
 10.10.20                                                                                                         * zc_ObjectString_BuyerForSale_Phone  
 05.10.20         * zc_ObjectString_MemberBranch_Comment
 07.09.20         * zc_ObjectString_MemberExternal_INN
 04.09.20         * zc_ObjectString_MemberMinus_BankAccountTo
                    zc_ObjectString_MemberMinus_DetailPayment
 01.06.20                                                                                                         * zc_ObjectString_DiscountExternalTools_Token  
 22.05.20         * zc_ObjectString_Unit_SUN_v4_Lock
                    zc_ObjectString_Unit_SUN_v2_Lock
                    zc_ObjectString_Unit_SUN_v1_Lock
 24.04.20                                                                                                         * zc_ObjectString_Goods_ActiveSubstance, zc_ObjectString_Goods_AnalogATC
 21.04.20         * zc_ObjectString_Unit_ListDaySUN_pi
 17.04.20                                                                                                         * zc_ObjectString_Hardware_ ...
 12.04.20                                                                                                         * zc_ObjectString_Hardware_ ...
 08.03.20                                                                                                         * zc_ObjectString_CashRegister_ ...
 05.03.20                                                                                                         * zc_ObjectString_DriverSun_Phone
 25.02.20                                                                                                         * zc_ObjectString_User_Helsi_PasswordEHels
 29.01.20         * zc_ObjectString_Buyer_DateBirth
                    zc_ObjectString_Buyer_Sex
 26.12.19                                                                                                         * zc_ObjectString_Buyer_ 
 13.12.19                                                                                                         * zc_ObjectString_Unit_AccessKeyYF 
 25.11.19                                                                                                         * zc_ObjectString_CashSettings_ 
 20.11.19         * 
 29.09.19                                                                                                         * zc_ObjectString_Unit_Latitude zc_ObjectString_Unit_Longitude
 10.09.19                                                                                                         * zc_ObjectString_BankAccount_CBAccountб zc_ObjectString_BankAccount_CBAccountOld
 09.09.19         * zc_ObjectString_Member_CardIBAN
                    zc_ObjectString_Member_CardIBANSecond
 06.09.19                                                                                                         * zc_ObjectString_Juridical_CB...
 01.09.19                                                                                                         * zc_ObjectString_PayrollType_ShortName
 25.08.19                                                                                                         * zc_ObjectString_User_PasswordWages
 07.08.19                                                                                                         * zc_ObjectString_Driver_E_Mail
 29.07.19         * zc_ObjectString_OrderFinance_Comment
 14.06.19                                                                                                         * zc_ObjectString_Goods_Analog
 14.06.19         * zc_ObjectString_Language_Value15-17
 20.05.19         * zc_ObjectString_GoodsTypeKind_ShortName
 27.04.19                                                                                                         * zc_ObjectString_User_Helsi_
 24.04.19                                                                                                         * zc_ObjectString_HelsiEnum
 30.03.19         * zc_ObjectString_GoodsPropertyValue_Quality
 21.03.19         * zc_ObjectString_Goods_RUS
 29.01.19         * zc_ObjectString_Retail_OKPO
 11.10.19                                                                                                         * zc_ObjectString_CashRegister_SerialNumber
 17.12.18         * zc_ObjectString_GoodsPropertyValue_Quality2
                    zc_ObjectString_GoodsPropertyValue_Quality10
 29.11.18         * zc_ObjectString_DocumentTaxKind_Code
 28.09.18                                                                                                         * zc_ObjectString_Goods_NameUkr, zc_ObjectString_Goods_CodeUKTZED, zc_ObjectString_ClientsByBank_
 05.07.18         * zc_ObjectString_MemberPersonalServiceList_Comment
 20.06.18         * zc_ObjectString_ReplServer_...
 05.06.18         * zc_ObjectString_MemberSP_INN
                    zc_ObjectString_MemberSP_Address
                    zc_ObjectString_MemberSP_Passport
 18.04.18         * zc_ObjectString_MemberSheetWorkTime_Comment
 09.02.18                                                                                       * zc_ObjectString_ImportType_JSONParamName               
 27.12.17         * zc_ObjectString_Fiscal_InvNumber
                    zc_ObjectString_Fiscal_SerialNumber
 13.12.17         * zc_ObjectString_PromoCode_Comment
 23.10.17         * zc_ObjectString_Sticker.....
 26.09.17         * zc_ObjectString_JuridicalArea_Email
 25.09.17         * zc_ObjectString_Area_Email
 08.08.17         * zc_ObjectString_Contract_OrderSumm
                    zc_ObjectString_Contract_OrderTime
 05.07.17         * zc_ObjectString_ArticleLoss_Comment
 04.04.17         *
 30.03.17         * zc_ObjectString_GoodsListIncome_GoodsKind
 28.03.17         * zc_ObjectString_Partner_Delivery
 06.03.17         * zc_ObjectString_Unit_Address
 16.02.17         * zc_ObjectString_PartnerMedical_FIO
 06.01.17         * zc_ObjectString_Goods_UKTZED
 19.12.16         * zc_ObjectString_Goods_Pack
 28.06.16         * zc_ObjectString_Email_ErrorTo
 16.12.15                                                                      *  + zc_ObjectString_Form_HelpFile
 27.10.15                                                                      *  + zc_ObjectString_Goods_Foto,zc_ObjectString_Goods_Thumb 
 25.03.15                                        * add -- !!!временно!!! zc_ObjectString_Partner_NameInteger
 18.03.15         * add zc_ObjectString_Branch_InvNumber
 09.02.15         * add zc_ObjectString_Quality_Comment
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