-- Function: gpUpdate_Object_PersonalServiceList_User()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_User (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_User(
    IN inId             Integer   ,     -- ���� ������� <> 
    IN inisUser         Boolean   ,     -- 
   OUT outisUser        Boolean   ,     --
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_PersonalServiceList_User());


   IF -- ���� ���� ����������� - ������ ����������� ��������� ��
      EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657326)
      -- + ���� ���� ����������� - ������ � ��������� ��������� ����� ��
   OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
   THEN
       RAISE EXCEPTION '������.1.��� ����.';
   END IF;

   -- IF inisUser = TRUE THEN RAISE EXCEPTION '������.2.��� ����.'; END IF;

   -- ������ ���������-���� (����������) + �� �������� ���
   IF NOT EXISTS (SELECT 1 FROM Constant_User_LevelMax01_View WHERE Constant_User_LevelMax01_View.UserId = vbUserId)
   THEN
       RAISE EXCEPTION '������.3.��� ����.';
   END IF;

   -- �������� ��������
   outisUser:= Not inisUser;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_User(), inId, outisUser);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.07.24         *
*/

-- ����
--