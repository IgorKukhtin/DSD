DO $$
BEGIN
     -- ��������� ����:
     -- zc_Enum_Role_Admin
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= 'Role Admin', inEnumName:= 'zc_Enum_Role_Admin');

     -- !!! ������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_UnComplete(), inName:= '�� ��������', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Complete(),   inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Complete(),   inName:= '��������',    inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Erased(),     inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Erased(),     inName:= '������',      inEnumName:= 'zc_Enum_Status_Erased');


     -- !!! ���� �������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_Excel(),  inDescId:= zc_Object_FileTypeKind(), inCode:= 1, inName:= 'Excel', inEnumName:= 'zc_Enum_FileTypeKind_Excel');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_DBF(), inDescId:= zc_Object_FileTypeKind(), inCode:= 2, inName:= 'DBF', inEnumName:= 'zc_Enum_FileTypeKind_DBF');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_MMO(), inDescId:= zc_Object_FileTypeKind(), inCode:= 3, inName:= 'MMO', inEnumName:= 'zc_Enum_FileTypeKind_MMO');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_ODBC(), inDescId:= zc_Object_FileTypeKind(), inCode:= 4, inName:= 'ODBC', inEnumName:= 'zc_Enum_FileTypeKind_ODBC');

    
     -- !!! ����� ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_FirstForm(),  inDescId:= zc_Object_PaidKind(), inCode:= 1, inName:= '��', inEnumName:= 'zc_Enum_PaidKind_FirstForm');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_SecondForm(), inDescId:= zc_Object_PaidKind(), inCode:= 2, inName:= '���', inEnumName:= 'zc_Enum_PaidKind_SecondForm');



END $$;




DO $$
DECLARE vbId integer;
DECLARE vbUserId integer;
BEGIN
   -- !!!������ �������� �������� ���������� ������ ��� �� ��������� �������� ����!!!
   vbUserId:=      (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData ILIKE '�����');

   IF COALESCE (vbUserId, 0) = 0
   THEN
       -- ������� - Admin
       vbUserId := lpInsertUpdate_Object (0, zc_Object_User(), 0, '�����');
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), vbUserId, '�����');
   END IF;

   -- ��� Admin
   IF NOT EXISTS(SELECT 1
                 FROM Object
                      JOIN ObjectLink AS UserRole_Role
                                      ON UserRole_Role.descId = zc_ObjectLink_UserRole_Role()
                                     AND UserRole_Role.childObjectId = zc_Enum_Role_Admin()
                                     AND UserRole_Role.ObjectId = Object.Id
                      JOIN ObjectLink AS UserRole_User
                                      ON UserRole_User.descId = zc_ObjectLink_UserRole_User()
                                     AND UserRole_User.childObjectId = vbUserId
                                     AND UserRole_User.ObjectId = Object.Id
                 WHERE Object.descId = zc_Object_UserRole()
                )
   THEN
       -- ��������� ������������ � �����
       vbId := lpInsertUpdate_Object (0, zc_Object_UserRole(), 0, '');
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), vbId, zc_Enum_Role_Admin());
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), vbId, vbUserId);

   END IF;

   
END $$;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.01.22                                        *
*/
