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