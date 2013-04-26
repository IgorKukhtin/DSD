INSERT INTO ObjectBLOBDesc (id, DescId, Code ,itemname)
SELECT zc_objectBlob_form_Data(), zc_object_Form(), 'FormData','Данные формы' WHERE NOT EXISTS (SELECT * FROM ObjectBlobDesc WHERE Id = zc_objectBlob_form_Data());



