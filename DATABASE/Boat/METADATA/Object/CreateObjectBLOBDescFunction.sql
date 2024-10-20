CREATE OR REPLACE FUNCTION zc_objectBlob_Program_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Program_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Program(), 'zc_objectBlob_Program_Data','������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Program_Data');

CREATE OR REPLACE FUNCTION zc_objectBlob_form_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Form(), 'zc_objectBlob_form_Data','������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_Data');


CREATE OR REPLACE FUNCTION zc_objectBlob_UserFormSettings_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_UserFormSettings(), 'zc_objectBlob_UserFormSettings_Data','���������������� ������ �����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_ImportSettings_Query() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportSettings_Query'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_ImportSettings(), 'zc_ObjectBlob_ImportSettings_Query','������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportSettings_Query');


CREATE OR REPLACE FUNCTION zc_objectblob_goodsdocument_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsdocument_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_goodsdocument(), 'zc_objectblob_goodsdocument_data','��������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsdocument_data');

CREATE OR REPLACE FUNCTION zc_objectblob_goodsPhoto_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsPhoto_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_goodsPhoto(), 'zc_objectblob_goodsPhoto_data','����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsPhoto_data');

CREATE OR REPLACE FUNCTION zc_objectblob_ProdColorPatternPhoto_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_ProdColorPatternPhoto_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_ProdColorPatternPhoto(), 'zc_objectblob_ProdColorPatternPhoto_data','����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_ProdColorPatternPhoto_data');

CREATE OR REPLACE FUNCTION zc_objectblob_Productdocument_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_Productdocument_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_Productdocument(), 'zc_objectblob_Productdocument_data','��������' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_Productdocument_data');

CREATE OR REPLACE FUNCTION zc_objectblob_ProductPhoto_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_ProductPhoto_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_ProductPhoto(), 'zc_objectblob_ProductPhoto_data','����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_ProductPhoto_data');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_BankAccountPdf_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_BankAccountPdf_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_BankAccountPdf(), 'zc_ObjectBlob_BankAccountPdf_Data','����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_BankAccountPdf_Data');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_InvoicePdf_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_InvoicePdf_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_InvoicePdf(), 'zc_ObjectBlob_InvoicePdf_Data','����' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_InvoicePdf_Data');



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.02.24         * zc_ObjectBlob_InvoicePdf_Data
 12.01.24         * zc_Object_BankAccountPdf
 21.04.21         * zc_objectblob_Productdocument_data
                    zc_objectblob_ProductPhoto_data
 09.02.21         * zc_Object_ProdColorPatternPhoto
 28.08.20                                        * 
*/
