INSERT INTO ObjectBLOBDesc (id, DescId, Code ,itemname)
SELECT zc_objectBlob_form_Data(), zc_object_Form(), 'FormData','Данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Id = zc_objectBlob_form_Data());

INSERT INTO ObjectBLOBDesc (id, DescId, Code ,itemname)
SELECT zc_ObjectBlob_UserFormSettings_Data(), zc_object_UserFormSettings(), 'UserFormSettings_Data','Пользовательские данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Id = zc_objectBlob_UserFormSettings_Data());


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13                                        * НОВАЯ СХЕМА
*/
