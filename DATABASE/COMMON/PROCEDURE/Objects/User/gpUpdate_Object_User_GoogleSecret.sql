-- Function: gpUpdate_Object_User_GoogleSecret()

 DROP FUNCTION IF EXISTS gpUpdate_Object_User_GoogleSecret (TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User_GoogleSecret(
    IN inGoogleSecret   TVarChar,      -- ������ ����������
    IN inSession        TVarChar       -- ������ ������������
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
  vbUserId:= lpGetUserBySession (inSession);


  PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_SMS(), vbUserId, inGoogleSecret);

  -- C�������� ��������
  PERFORM lpInsert_ObjectProtocol (inObjectId:= vbUserId, inUserId:= vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.12.22                                                       *              
*/

-- ����
-- SELECT * FROM gpUpdate_Object_User_GoogleSecret ('', '378f6845-ef70-4e5b-aeb9-45d91bd5e82e')
