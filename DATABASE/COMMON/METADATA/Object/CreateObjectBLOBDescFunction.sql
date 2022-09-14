CREATE OR REPLACE FUNCTION zc_ObjectBlob_ContractDocument_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ContractDocument_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_ContractDocument(), 'zc_ObjectBlob_ContractDocument_Data','����-����� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ContractDocument_Data');

CREATE OR REPLACE FUNCTION zc_objectBlob_form_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Form(), 'zc_objectBlob_form_Data','������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_Data');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_ImportExportLink_Text() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportExportLink_Text'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_ImportExportLink(), 'zc_ObjectBlob_ImportExportLink_Text','������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportExportLink_Text');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_ImportSettings_Query() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportSettings_Query'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_ImportSettings(), 'zc_ObjectBlob_ImportSettings_Query','������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportSettings_Query');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_Member_EMailSign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_Member_EMailSign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBlobDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectBlob_Member_EMailSign', zc_object_Member(), '������� E-mail' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_Member_EMailSign');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_Member_Photo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_Member_Photo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBlobDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectBlob_Member_Photo', zc_object_Member(), '����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_Member_Photo');


CREATE OR REPLACE FUNCTION zc_objectBlob_Program_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Program_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Program(), 'zc_objectBlob_Program_Data','������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Program_Data');

CREATE OR REPLACE FUNCTION zc_objectBlob_UserFormSettings_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_UserFormSettings(), 'zc_objectBlob_UserFormSettings_Data','���������������� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data');

CREATE OR REPLACE FUNCTION zc_objectBlob_Goods_Description() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Goods_Description'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Goods(), 'zc_objectBlob_Goods_Description','�������� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Goods_Description');

CREATE OR REPLACE FUNCTION zc_objectBlob_Goods_Site() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Goods_Site'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Goods(), 'zc_objectBlob_Goods_Site','�������� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Goods_Site');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_RouteMember_Description() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_RouteMember_Description'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_RouteMember(), 'zc_ObjectBlob_RouteMember_Description','�������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_RouteMember_Description');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_PhotoMobile_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_PhotoMobile_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_PhotoMobile(), 'zc_ObjectBlob_PhotoMobile_Data','�������� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_PhotoMobile_Data');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_Sticker_Info() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_Sticker_Info'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Sticker(), 'zc_ObjectBlob_Sticker_Info','������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_Sticker_Info');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_User_Helsi_Key() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_User_Helsi_Key'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_User(), 'zc_ObjectBlob_User_Helsi_Key','�������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_User_Helsi_Key');

CREATE OR REPLACE FUNCTION zc_objectBlob_FinalSUAProtocol_Recipient() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_FinalSUAProtocol_Recipient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_FinalSUAProtocol(), 'zc_objectBlob_FinalSUAProtocol_Recipient','������ ����������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_FinalSUAProtocol_Recipient');
   
CREATE OR REPLACE FUNCTION zc_objectBlob_FinalSUAProtocol_Assortment() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_FinalSUAProtocol_Assortment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_FinalSUAProtocol(), 'zc_objectBlob_FinalSUAProtocol_Assortment','������ ������������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_FinalSUAProtocol_Assortment');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_StickerHeader_Info() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_StickerHeader_Info'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_StickerHeader(), 'zc_ObjectBlob_StickerHeader_Info','���������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_StickerHeader_Info');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_InternetRepair_Notes() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_InternetRepair_Notes'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_InternetRepair(), 'zc_ObjectBlob_InternetRepair_Notes','�������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_InternetRepair_Notes');


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.   ������ �.�.
 12.09.22                                                                         * zc_ObjectBlob_InternetRepair_Notes
 08.08.22          * zc_ObjectBlob_StickerHeader_Info
 27.03.21                                                                         * zc_objectBlob_FinalSUAProtocol_Recipient, zc_objectBlob_FinalSUAProtocol_Assortment
 27.04.19                                                                         * zc_ObjectBlob_User_Helsi_Key
 23.10.17          * zc_ObjectBlob_Sticker_Info
 26.03.17         * add zc_ObjectBlob_PhotoMobile_Data
 16.01.16         * add zc_ObjectBlob_RouteMember_Description
 27.10.15                                                         * + zc_objectBlob_Goods_Description
 10.07.13         * ����� �����              
 28.06.13                                        * ����� �����
*/
