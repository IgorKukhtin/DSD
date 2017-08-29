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
