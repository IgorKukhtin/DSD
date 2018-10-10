--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

-- ��� ������������� ��������, ����� �������������� � ���� ��������
CREATE OR REPLACE FUNCTION zc_ObjectString_Enum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Enum', NULL, '������� ������-������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum');

CREATE OR REPLACE FUNCTION zc_ObjectString_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GUID', zc_Object_ReplServer(), '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GUID');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_Host() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Host'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_Host', zc_Object_ReplServer(), '������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Host');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_User', zc_Object_ReplServer(), '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_User');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_Password', zc_Object_ReplServer(), '������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Password');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_Port() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Port'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_Port', zc_Object_ReplServer(), '����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Port');

CREATE OR REPLACE FUNCTION zc_ObjectString_ReplServer_DataBase() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_DataBase'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReplServer_DataBase', zc_Object_ReplServer(), '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_DataBase');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_Comment', zc_Object_Asset(), 'Asset_Comment' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_FullName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_FullName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_FullName', zc_Object_Asset(), 'Asset_FullName' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_FullName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Asset_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Asset_InvNumber', zc_object_Asset(), '����������� ����� �������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_InvNumber');

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


CREATE OR REPLACE FUNCTION zc_ObjectString_Car_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Car_Comment', zc_Object_Car(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Car_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Car_RegistrationCertificate', zc_object_Car(), '���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate');

CREATE OR REPLACE FUNCTION zc_ObjectString_CarExternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CarExternal_Comment', zc_Object_CarExternal(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_CarExternal_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_CarExternal_RegistrationCertificate', zc_object_CarExternal(), '���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate');


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
  SELECT 'zc_ObjectString_Contract_GLNCode', zc_Object_Contract(), '��� GLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_PartnerCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_PartnerCode', zc_Object_Contract(), '��� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode');


CREATE OR REPLACE FUNCTION zc_ObjectString_ContactPerson_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ContactPerson_Comment', zc_Object_ContactPerson(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ContactPerson_Mail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ContactPerson_Mail', zc_Object_ContactPerson(), '����������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail');

CREATE OR REPLACE FUNCTION zc_ObjectString_ContactPerson_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ContactPerson_Phone', zc_Object_ContactPerson(), '�������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone');

CREATE OR REPLACE FUNCTION zc_objectString_Currency_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_objectString_Currency_InternalName', zc_object_Currency(), 'Currency_InternalName' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName');

-- zc_Object_Goods                           

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_GroupNameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_GroupNameFull', zc_Object_Goods(), '������ �������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Maker', zc_Object_Goods(), '�������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_UKTZED', zc_Object_Goods(), '��� ������ ����� � ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_DKPP', zc_Object_Goods(), '������� ����� � ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_TaxImport', zc_Object_Goods(), '������ ������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_TaxAction', zc_Object_Goods(), '��� ���� �������� �����-�������� ��������������� ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_Article() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_Article', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_Article' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_ArticleGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_ArticleGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_ArticleGLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_NameUkr', zc_Object_Goods(), '�������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_CodeUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_CodeUKTZED', zc_Object_Goods(), '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED');

-- zc_Object_GoodsPropertyValue
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCodeShort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCodeShort', zc_Object_GoodsPropertyValue(), '����� ����� ���� (����� ��� ������������)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCode', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_BarCodeGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCodeGLN' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_CodeSticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_CodeSticker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_CodeSticker', zc_Object_GoodsPropertyValue(), 'zc_ObjectString_GoodsPropertyValue_CodeSticker' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_CodeSticker');


CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_GLNCode', zc_Object_Juridical(), 'Juridical_GLNCode' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_OrderSumm', zc_Object_Juridical(), '���������� � ����������� ����� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_OrderTime', zc_Object_Juridical(), '������������ - ������������ ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime');

CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_GUID', zc_Object_Juridical(), '���������� ���������� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID');


CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Comment', zc_object_Member(), '���������� ���.���� ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_DriverCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_DriverCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_DriverCertificate', zc_object_Member(), '������������ ������������� ���.���� ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_DriverCertificate');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_EMail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_EMail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_EMail', zc_object_Member(), '������������ ������������� ���.���� ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_EMail');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_INN', zc_object_Member(), '��� ���.���� ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_INN');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Card() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Card'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Card', zc_object_Member(), 'Ϲ ���������� ����� ��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Card');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardSecond', zc_object_Member(), '� ���������� ����� �� - ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardSecond');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_CardChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_CardChild', zc_object_Member(), '� ���������� ����� �� - �������� (���������)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_CardChild');


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

-- !!!��������!!!
CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_NameInteger() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_NameInteger', zc_Object_Partner(), '�������� Integer' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger');

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
  SELECT 'zc_ObjectString_Partner_Address', zc_Object_Partner(), '����� ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_HouseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_HouseNumber', zc_Object_Partner(), '����� ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_CaseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_CaseNumber', zc_Object_Partner(), '����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_RoomNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_RoomNumber', zc_Object_Partner(), '����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_ShortName', zc_Object_Partner(), '�������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Schedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Schedule', zc_Object_Partner(), '������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_Delivery() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_Delivery', zc_Object_Partner(), '������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GUID', zc_Object_Partner(), '���������� ���������� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID');


CREATE OR REPLACE FUNCTION zc_ObjectString_ReceiptChild_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ReceiptChild_Comment', zc_Object_ReceiptChild(), '������������ �������� - ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Receipt_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Receipt_Code', zc_Object_Receipt(), '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code');

CREATE OR REPLACE FUNCTION zc_ObjectString_Receipt_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Receipt_Comment', zc_Object_Receipt(), '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ToolsWeighing_NameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ToolsWeighing_NameFull', zc_ObjectString_ToolsWeighing_NameFull(), '������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull');

CREATE OR REPLACE FUNCTION zc_ObjectString_ToolsWeighing_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ToolsWeighing_Name', zc_ObjectString_ToolsWeighing_Name(), '��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name');

CREATE OR REPLACE FUNCTION zc_ObjectString_ToolsWeighing_NameUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ToolsWeighing_NameUser', zc_ObjectString_ToolsWeighing_NameUser(), '�������� ��� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser');

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
  SELECT 'zc_ObjectString_CityKind_ShortName', zc_Object_CityKind(), '�������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CityKind_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_StreetKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StreetKind_ShortName', zc_Object_StreetKind(), '�������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName');


--
CREATE OR REPLACE FUNCTION zc_ObjectString_User_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Password', zc_Object_User(), '������ ������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Sign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Sign', zc_Object_User(), '����������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Seal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Seal', zc_Object_User(), '����������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Key() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Key', zc_Object_User(), '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Foto', zc_Object_User(), '���� � ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto');

  
CREATE OR REPLACE FUNCTION zc_ObjectString_WorkTimeKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_WorkTimeKind_ShortName', zc_Object_WorkTimeKind(), '�������� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Measure_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Measure_InternalName', zc_Object_Measure(), '������������� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Measure_InternalCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Measure_InternalCode', zc_Object_Measure(), '������������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsPropertyValue_GroupName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsPropertyValue_GroupName', zc_Object_GoodsPropertyValue(), '�������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName');

CREATE OR REPLACE FUNCTION zc_ObjectString_Retail_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Retail_GLNCode', zc_Object_Retail(), '��� GLN - ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_Retail_GLNCodeCorporate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Retail_GLNCodeCorporate', zc_Object_Retail(), ' ���GLN - ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate');

---zc_Object_GoodsQuality

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value1', zc_Object_GoodsQuality(), '��� ��������, ������� 4' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value2', zc_Object_GoodsQuality(), '����� ���������, ������� 6' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value3', zc_Object_GoodsQuality(), '����� �����. � ���.�����.(�������), ������� 7' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value4', zc_Object_GoodsQuality(), '����� ��������� � ���.���������, ������� 8' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value5', zc_Object_GoodsQuality(), '�������� �������� - ����� ��������� ����� �������, ������� 10' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value6', zc_Object_GoodsQuality(), '�������� �������� - ����� ��������� �������� ������, ������� 11' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value7', zc_Object_GoodsQuality(), '�������� �������� - ����� ��������� ������������� ������, ������� 12' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value8', zc_Object_GoodsQuality(), '����������� ��������� � ������ �� �������������� �������� ����������, ������� 14' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value9', zc_Object_GoodsQuality(), '����������� ��������� � �������� ����������, ������� 15' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9');
CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsQuality_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsQuality_Value10', zc_Object_GoodsQuality(), '����� ���������, ������� 16' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10');

--!!!Quality
CREATE OR REPLACE FUNCTION zc_ObjectString_Quality_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Quality_Comment', zc_Object_Quality(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Quality_MemberMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Quality_MemberMain', zc_Object_Quality(), '��������� ��������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain');

CREATE OR REPLACE FUNCTION zc_ObjectString_Quality_MemberTech() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Quality_MemberTech', zc_Object_Quality(), '�������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech');


CREATE OR REPLACE FUNCTION zc_ObjectString_InvNumberTax_InvNumberBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_InvNumberTax_InvNumberBranch', zc_Object_InvNumberTax(), '����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch');

CREATE OR REPLACE FUNCTION zc_ObjectString_Branch_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Branch_InvNumber', zc_Object_Branch(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Branch_PlaceOf() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Branch_PlaceOf', zc_Object_Branch(), '̳��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf');

CREATE OR REPLACE FUNCTION zc_ObjectString_Form_HelpFile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Form_HelpFile', zc_Object_Form(), '���� � ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Address', zc_object_Unit(), '�����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Phone', zc_object_Unit(), '�������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_Storage_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Storage_Address', zc_object_Storage(), '����� �����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Storage_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Storage_Comment', zc_object_Storage(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_SignInternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SignInternal_Comment', zc_object_SignInternal(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileEmployee_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileEmployee_Comment', zc_Object_MobileEmployee(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileTariff_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileTariff_Comment', zc_Object_MobileTariff(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileConst_MobileVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileConst_MobileVersion', zc_Object_MobileConst(), '������ ���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion');

CREATE OR REPLACE FUNCTION zc_ObjectString_MobileConst_MobileAPKFileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MobileConst_MobileAPKFileName', zc_Object_MobileConst(), '�������� ".apk" ����� ���������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_SheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SheetWorkTime_Comment', zc_Object_SheetWorkTime(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_SheetWorkTime_DayOffPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SheetWorkTime_DayOffPeriod', zc_Object_SheetWorkTime(), '������������� � ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod');

CREATE OR REPLACE FUNCTION zc_ObjectString_SheetWorkTime_DayOffWeek() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_SheetWorkTime_DayOffWeek', zc_Object_SheetWorkTime(), '��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsListSale_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsListSale_GoodsKind', zc_Object_GoodsListSale(), '������ ���� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsListIncome_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsListIncome_GoodsKind', zc_Object_GoodsListIncome(), '������ ���� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_UKTZED', zc_Object_GoodsGroup(), '��� ������ ����� � ��� ���' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_DKPP', zc_Object_GoodsGroup(), '������� ����� � ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_TaxImport', zc_Object_GoodsGroup(), '������ ������������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport');

CREATE OR REPLACE FUNCTION zc_ObjectString_GoodsGroup_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_GoodsGroup_TaxAction', zc_Object_GoodsGroup(), '��� ���� �������� �����-�������� ���������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction');

CREATE OR REPLACE FUNCTION zc_ObjectString_StorageLine_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StorageLine_Comment', zc_Object_StorageLine(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_ArticleLoss_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ArticleLoss_Comment', zc_Object_ArticleLoss(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment');

--
CREATE OR REPLACE FUNCTION zc_ObjectString_StickerGroup_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerGroup_Comment', zc_Object_StickerGroup(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerType_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerType_Comment', zc_Object_StickerType(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerTag_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerTag_Comment', zc_Object_StickerTag(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerSort_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerSort_Comment', zc_Object_StickerSort(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerNorm_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerNorm_Comment', zc_Object_StickerNorm(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerFile_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerFile_Comment', zc_Object_StickerFile(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerSkin_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerSkin_Comment', zc_Object_StickerSkin(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_StickerPack_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerPack_Comment', zc_Object_StickerPack(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Comment', zc_Object_Language(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value1', zc_Object_Language(), '�����:' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value2', zc_Object_Language(), '����� �� ����� ���������:' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value3', zc_Object_Language(), '�� ������� �������� ������ ��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value4', zc_Object_Language(), '��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value5', zc_Object_Language(), '�� ����������� ��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value6', zc_Object_Language(), '��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value7', zc_Object_Language(), '�� ���� ��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value8', zc_Object_Language(), '������� ������� �� ���������� � 100��.��������:' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value9', zc_Object_Language(), '���� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value10', zc_Object_Language(), '��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value11', zc_Object_Language(), '���� �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value12', zc_Object_Language(), '��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12');

CREATE OR REPLACE FUNCTION zc_ObjectString_Language_Value13() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Language_Value13', zc_Object_Language(), '����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13');

---
CREATE OR REPLACE FUNCTION zc_ObjectString_StickerProperty_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_StickerProperty_BarCode', zc_Object_StickerProperty(), '��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSheetWorkTime_Comment', zc_Object_MemberSheetWorkTime(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberPersonalServiceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberPersonalServiceList_Comment', zc_Object_MemberPersonalServiceList(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment');


---!!! ������
CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Code', zc_Object_Goods(), '��������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportSettings_Directory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportSettings_Directory', zc_Object_ImportSettings(), '���������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportType_ProcedureName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportType_ProcedureName', zc_Object_ImportType(), '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportTypeItems_ParamType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportTypeItems_ParamType', zc_Object_ImportTypeItems(), '��� ��������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportTypeItems_UserParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportTypeItems_UserParamName', zc_Object_ImportTypeItems(), '���������������� �������� ��������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportSettingsItems_DefaultValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportSettingsItems_DefaultValue', zc_Object_ImportSettingsItems(), '�������� �� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue');
  
CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Foto', zc_Object_Goods(), '���� � ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto');
  
CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Thumb() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Thumb', zc_Object_Goods(), '���� � ������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Phone', zc_object_Member(), '������� ���.���� ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_Member_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Member_Address', zc_object_Member(), '����� ���������� ���.���� ' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Member_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Email_ErrorTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Email_ErrorTo', zc_object_Email(), '���� ���������� ��������� �� ������ ��� �������� ������ � �/�' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo');


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
  SELECT 'zc_ObjectString_DiscountExternalTools_ExternalUnit', zc_Object_DiscountExternalTools(), '������������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_ExternalUnit');

CREATE OR REPLACE FUNCTION zc_ObjectString_DiscountExternalJuridical_ExternalJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical', zc_Object_DiscountExternalJuridical(), '����������� ���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_Pack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_Pack', zc_object_Goods(), '���� 䳿/ ��������� (5)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_CodeATX() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_CodeATX', zc_object_Goods(), '��� ��� (7)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_ReestrSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_ReestrSP', zc_object_Goods(), '� ������������� ���������� �� ��������� ���� (9)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_ReestrDateSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_ReestrDateSP', zc_object_Goods(), '���� ��������� ������ 䳿 ������������� ���������� �� ��������� ����(10)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP');

CREATE OR REPLACE FUNCTION zc_ObjectString_Goods_MakerSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Goods_MakerSP', zc_object_Goods(), '������������ ���������, �����(8)(��)' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_ProjectMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_ProjectMobile', '�������� � ��� ����-��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_MobileModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileModel', '������ ��� ����-��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_MobileVesion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesion', '������ ������� ����-��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion');

CREATE OR REPLACE FUNCTION zc_ObjectString_User_MobileVesionSDK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesionSDK', '������ SDK ����-��' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK');
  

CREATE OR REPLACE FUNCTION zc_ObjectString_PartnerMedical_FIO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PartnerMedical_FIO', zc_object_PartnerMedical(), '��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO');

CREATE OR REPLACE FUNCTION zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Unit_Address', zc_object_Unit(), '����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_OrderSumm', zc_Object_Contract(), '���������� � ����������� ����� ��� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm');

CREATE OR REPLACE FUNCTION zc_ObjectString_Contract_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Contract_OrderTime', zc_Object_Contract(), '������������ - ������������ ����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime');

CREATE OR REPLACE FUNCTION zc_ObjectString_Area_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Area_Email', zc_Object_Area(), '�� ����� ����� �������� ���� �� ������� ��� ����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email');

CREATE OR REPLACE FUNCTION zc_ObjectString_JuridicalArea_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_JuridicalArea_Email', zc_Object_JuridicalArea(), '�� ����� ����� ���������� �� ���������� ���� �� ������� ��� ����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email');

CREATE OR REPLACE FUNCTION zc_ObjectString_PromoCode_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_PromoCode_Comment', zc_Object_PromoCode(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment');

CREATE OR REPLACE FUNCTION zc_ObjectString_Fiscal_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Fiscal_SerialNumber', zc_Object_Fiscal(), '���� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_Fiscal_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Fiscal_InvNumber', zc_Object_Fiscal(), '����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber');

CREATE OR REPLACE FUNCTION zc_ObjectString_ImportType_JSONParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ImportType_JSONParamName', zc_Object_ImportType(), '��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName');
  
CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSP_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSP_INN', zc_object_MemberSP(), '��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_INN');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSP_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSP_Address', zc_object_MemberSP(), '����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Address');

CREATE OR REPLACE FUNCTION zc_ObjectString_MemberSP_Passport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Passport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_MemberSP_Passport', zc_object_MemberSP(), '����� � ����� �������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSP_Passport');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_OKPO', zc_Object_ClientsByBank(), '����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_INN', zc_Object_ClientsByBank(), '���' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_Phone', zc_Object_ClientsByBank(), '��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_ContactPerson', zc_Object_ClientsByBank(), '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_RegAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_RegAddress', zc_Object_ClientsByBank(), '����� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_SendingAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_SendingAddress', zc_Object_ClientsByBank(), '����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_Accounting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_Accounting', zc_Object_ClientsByBank(), '�����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_PhoneAccountancy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_PhoneAccountancy', zc_Object_ClientsByBank(), '������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy');

CREATE OR REPLACE FUNCTION zc_ObjectString_ClientsByBank_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_ClientsByBank_Comment', zc_Object_ClientsByBank(), '����������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment');


  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������������ �.�.   ������ �.�.
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
 25.03.15                                        * add -- !!!��������!!! zc_ObjectString_Partner_NameInteger
 18.03.15         * add zc_ObjectString_Branch_InvNumber
 09.02.15         * add zc_ObjectString_Quality_Comment
 08.12.14         * add zc_ObjectString_GoodsQuality_Value1-10
 10.10.14                                                        * + zc_ObjectString_Bank_SWIFT, zc_ObjectString_Bank_IBAN, zc_ObjectString_BankAccount_BeneficiarysAccount, zc_ObjectString_BankAccount_BeneficiarysBankAccount, zc_ObjectString_BankAccount_�orrespondentAccount
 09.10.14                                                        * + zc_ObjectString_Measure_InternalName, zc_ObjectString_Measure_InternalCode, zc_ObjectString_GoodsPropertyValue_GroupName
 31.05.14         * add
 12.03.14                                                        * + zc_ObjectString_ToolsWeighing_NameFull, zc_ObjectString_ToolsWeighing_Name, zc_ObjectString_ToolsWeighing_NameUser

 11.02.14         * add Asset_ (5 �������)
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
 27.08.13         * ������� �� ����� ����� 2
 04.07.13         * ������� ����� �� ����� �����
 28.06.13                                        * ����� �����
*/