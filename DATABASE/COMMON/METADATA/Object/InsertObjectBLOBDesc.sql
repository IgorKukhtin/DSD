INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
SELECT zc_object_Form(), 'zc_objectBlob_form_Data','Данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_Data');

INSERT INTO ObjectBLOBDesc (DescId, Code ,itemname)
SELECT zc_object_UserFormSettings(), 'zc_objectBlob_UserFormSettings_Data','Пользовательские данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.07.13         что-то у меня не получается перенести на новую схему 
 28.06.13                                        * НОВАЯ СХЕМА
*/
