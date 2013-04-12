INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
VALUES (zc_objectString_user_password(), zc_object_user(), 'User_Password', 'Пароль');

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
VALUES (zc_objectString_user_login(), zc_object_user(), 'User_Login', 'Логин');

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
VALUES (zc_objectString_Currency_InternalName(), zc_object_Currency(), 'Currency_InternalName', 'Международное наименование');

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
VALUES (zc_ObjectString_Juridical_GLNCode(), zc_object_Juridical(), 'Juridical_GLNCode', 'GLN Код');

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
VALUES (zc_ObjectString_Partner_GLNCode(), zc_object_Partner(), 'Partner_GLNCode', 'GLN Код');

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
VALUES (zc_ObjectString_Bank_MFO(), zc_object_Bank(), 'Bank_MFO', 'МФО');

INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
VALUES (zc_ObjectString_Contract_InvNumber(), zc_Object_Contract(), 'Contract_InvNumber', 'Номер договора');


INSERT INTO ObjectStringDesc (id, DescId, Code, itemname)
SELECT zc_ObjectString_Contract_Comment(), zc_Object_Contract(), 'Contract_Comment', 'Комментарий'; -- WHERE NOT EXISTS (SELECT FROM ObjectStringDesc WHERE Id = zc_ObjectString_Contract_Comment()) ;

