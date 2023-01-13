-- Function: gpUpdate_Object_User_GoogleSecret_null()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_GoogleSecret_null (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User_GoogleSecret_null(
    IN inUserId   Integer,       --
    IN inSession  TVarChar       -- ������ ������������
)
  RETURNS Void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
  vbUserId:= lpGetUserBySession (inSession);


  PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_SMS(), inUserId, '');

  -- C�������� ��������
  PERFORM lpInsert_ObjectProtocol (inObjectId:= inUserId, inUserId:= vbUserId);

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
-- SELECT * FROM gpUpdate_Object_User_GoogleSecret_null ('5', '5')