CREATE OR REPLACE FUNCTION zc_objectBlob_Program_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Program_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Program(), 'zc_objectBlob_Program_Data','Данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_Program_Data');

CREATE OR REPLACE FUNCTION zc_objectBlob_form_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_Form(), 'zc_objectBlob_form_Data','Данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_Data');


CREATE OR REPLACE FUNCTION zc_objectBlob_UserFormSettings_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_object_UserFormSettings(), 'zc_objectBlob_UserFormSettings_Data','Пользовательские данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data');

CREATE OR REPLACE FUNCTION zc_ObjectBlob_ImportSettings_Query() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportSettings_Query'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_ImportSettings(), 'zc_ObjectBlob_ImportSettings_Query','Запрос' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_ObjectBlob_ImportSettings_Query');


CREATE OR REPLACE FUNCTION zc_objectblob_goodsdocument_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsdocument_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_goodsdocument(), 'zc_objectblob_goodsdocument_data','Документ' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsdocument_data');

CREATE OR REPLACE FUNCTION zc_objectblob_goodsPhoto_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsPhoto_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
   SELECT zc_Object_goodsPhoto(), 'zc_objectblob_goodsPhoto_data','фото' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectblob_goodsPhoto_data');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.20                                        * 
*/
