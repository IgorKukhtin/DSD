-- Function: gpUpdate_Object_User()

DROP FUNCTION IF EXISTS gpUpdate_Object_User (Integer, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User(
    IN inId          Integer   ,    -- ���� ������� <������������> 
    IN inSign        TVarChar  ,    -- ����������� �������
    IN inSeal        TVarChar  ,    -- ����������� ������
    IN inKey         TVarChar  ,    -- ���������� ���� 
    IN inSession     TVarChar       -- ������ ������������
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
   vbUserId:= lpGetUserBySession (inSession);


   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Sign(), inId, inSign);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Seal(), inId, inSeal);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Key(), inId, inKey);
  
   -- C�������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_User ('2')