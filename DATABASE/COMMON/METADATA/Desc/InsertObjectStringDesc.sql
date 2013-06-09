INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_objectString_user_password(), zc_object_user(), 'User_Password', 'Пароль' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_objectString_user_password());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_objectString_user_login(), zc_object_user(), 'User_Login', 'Логин' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_objectString_user_login());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_objectString_Currency_InternalName(), zc_object_Currency(), 'Currency_InternalName', 'Международное наименование' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_objectString_Currency_InternalName());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_Juridical_GLNCode(), zc_object_Juridical(), 'Juridical_GLNCode', 'GLN Код' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_Juridical_GLNCode());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_Partner_GLNCode(), zc_object_Partner(), 'Partner_GLNCode', 'GLN Код' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_Partner_GLNCode());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_Bank_MFO(), zc_object_Bank(), 'Bank_MFO', 'МФО' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_Bank_MFO());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_Contract_InvNumber(), zc_Object_Contract(), 'Contract_InvNumber', 'Номер договора' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_Contract_InvNumber());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_Contract_Comment(), zc_Object_Contract(), 'Contract_Comment', 'Комментарий' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_Contract_Comment());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_GoodsPropertyValue_BarCode(), zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCode', 'Штрихкод' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_GoodsPropertyValue_BarCode());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_GoodsPropertyValue_Article(), zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_Article', 'Комментарий' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_GoodsPropertyValue_Article());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_GoodsPropertyValue_BarCodeGLN(), zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_BarCodeGLN', 'Комментарий' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_GoodsPropertyValue_BarCodeGLN());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_GoodsPropertyValue_ArticleGLN(), zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_ArticleGLN', 'Комментарий' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_GoodsPropertyValue_ArticleGLN());

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_RegistrationCertificate(), zc_object_Car(), 'RegistrationCertificate', 'Техпаспорт Автомобиля' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Id = zc_ObjectString_RegistrationCertificate());
