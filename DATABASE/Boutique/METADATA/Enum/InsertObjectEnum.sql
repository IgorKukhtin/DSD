DO $$
BEGIN
   -- ��������� ����:
   -- zc_Enum_Role_Admin
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= '���� ��������������', inEnumName:= 'zc_Enum_Role_Admin');
END $$;


DO $$
DECLARE vbId integer;
DECLARE vbUserId integer;
BEGIN
   -- !!!������ �������� �������� ���������� ������ ��� �� ��������� �������� ����!!!
   vbUserId:= (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����');

   IF COALESCE(vbUserId, 0) = 0
   THEN
       -- ������� - �����
       vbUserId := lpInsertUpdate_Object(0, zc_Object_User(), 0, '�����');
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), vbUserId, '�����');
   END IF;

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
       vbId := lpInsertUpdate_Object (vbId, zc_Object_UserRole(), 0, '');
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), vbId, zc_Enum_Role_Admin());
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), vbId, vbUserId);

   END IF;

END $$;


DO $$
BEGIN
     -- !!! ���� ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Active(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= '��������', inEnumName:= 'zc_Enum_AccountKind_Active');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Passive(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= '���������', inEnumName:= 'zc_Enum_AccountKind_Passive');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_All(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= '�������/���������', inEnumName:= 'zc_Enum_AccountKind_All');
END $$;

DO $$
BEGIN
 -- !!! ���� ���� ������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Var(), inDescId:= zc_Object_DiscountKind(), inCode:= 1, inName:= '�� ������������� �������' , inEnumName:= 'zc_Enum_DiscountKind_Var');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Const(), inDescId:= zc_Object_DiscountKind(), inCode:= 3, inName:= '���������� ������' , inEnumName:= 'zc_Enum_DiscountKind_Const');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Not(), inDescId:= zc_Object_DiscountKind(), inCode:= 2, inName:= '��� ������' , inEnumName:= 'zc_Enum_DiscountKind_Not');

END $$;
