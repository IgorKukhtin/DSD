DO $$
BEGIN
     -- ��������� ����:
     -- zc_Enum_Role_Admin
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= '���� ��������������', inEnumName:= 'zc_Enum_Role_Admin');
     
     -- ���� � �������� ����
     -- actReturnInMovement + actReport_SaleReturnIn + actReport_GoodsMI_Account + actReport_CollationByClient + actReport_ClientDebt + actReport_Goods_RemainsCurrent
     PERFORM lpInsertUpdate_Object (ioId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 2)
                                  , inDescId    := zc_Object_Role()
                                  , inObjectCode:= 2
                                  , inValueData := '���� � �������� ����'
                                   );
     -- ���� � �������� (�� ��)
     -- actSaleMovement
     PERFORM lpInsertUpdate_Object (ioId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 3)
                                  , inDescId    := zc_Object_Role()
                                  , inObjectCode:= 3
                                  , inValueData := '���� � �������� (�� ��)'
                                   );
     -- ���� � �������� ��
     -- actSaleTwoMovement
     PERFORM lpInsertUpdate_Object (ioId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode = 4)
                                  , inDescId    := zc_Object_Role()
                                  , inObjectCode:= 4
                                  , inValueData := '���� � �������� ��'
                                   );

     -- !!! ������� ����������
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_UnComplete(), inName:= '�� ��������', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Complete(),   inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Complete(),   inName:= '��������',    inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Erased(),     inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Erased(),     inName:= '������',      inEnumName:= 'zc_Enum_Status_Erased');

END $$;


DO $$
DECLARE vbId integer;
DECLARE vbUserId integer;
DECLARE vbUserId_load integer;
BEGIN
   -- !!!������ �������� �������� ���������� ������ ��� �� ��������� �������� ����!!!
   vbUserId:=      (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�����');
   vbUserId_load:= (SELECT Id FROM Object WHERE DescId = zc_Object_User() AND ValueData = '�������� Sybase');

   IF COALESCE (vbUserId, 0) = 0
   THEN
       -- ������� - �����
       vbUserId := lpInsertUpdate_Object (0, zc_Object_User(), 0, '�����');
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), vbUserId, '�����');
   END IF;
   IF COALESCE (vbUserId_load, 0) = 0
   THEN
       -- ������� - �������� Sybase
       vbUserId_load := lpInsertUpdate_Object (0, zc_Object_User(), 0, '�������� Sybase');
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), vbUserId_load, '�����');
       --
       EXECUTE ('CREATE OR REPLACE FUNCTION zc_User_Sybase() RETURNS Integer AS $BODY$BEGIN RETURN (' || vbUserId_load :: TvarChar || '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
   END IF;

   -- ��� ������
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

   -- ��� �������� Sybase
   IF NOT EXISTS(SELECT 1
                 FROM Object
                      JOIN ObjectLink AS UserRole_Role
                                      ON UserRole_Role.descId = zc_ObjectLink_UserRole_Role()
                                     AND UserRole_Role.childObjectId = zc_Enum_Role_Admin()
                                     AND UserRole_Role.ObjectId = Object.Id
                      JOIN ObjectLink AS UserRole_User
                                      ON UserRole_User.descId = zc_ObjectLink_UserRole_User()
                                     AND UserRole_User.childObjectId = vbUserId_load
                                     AND UserRole_User.ObjectId = Object.Id
                 WHERE Object.descId = zc_Object_UserRole()
                )
   THEN
       -- ��������� ������������ � �����
       vbId := lpInsertUpdate_Object (0, zc_Object_UserRole(), 0, '');
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), vbId, zc_Enum_Role_Admin());
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), vbId, vbUserId_load);

   END IF;

END $$;
