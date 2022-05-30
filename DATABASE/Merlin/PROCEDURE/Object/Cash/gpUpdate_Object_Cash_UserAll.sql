-- Function: gpUpdate_Object_Cash_UserAll()

DROP FUNCTION IF EXISTS gpUpdate_Object_Cash_UserAll (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Cash_UserAll(
    IN inId                  Integer   ,  -- ���� ������� <> 
    IN inisUserAll           Boolean   , 
   OUT outisUserAll          Boolean   , 
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Cash_UserAll());
   --vbUserId:= lpGetUserBySession (inSession);

   outisUserAll:= NOT inisUserAll;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Cash_UserAll(), inId, outisUserAll);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.22         *
*/

-- ����
--