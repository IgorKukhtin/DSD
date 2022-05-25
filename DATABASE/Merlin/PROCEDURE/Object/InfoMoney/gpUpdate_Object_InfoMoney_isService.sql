-- Function: gpUpdate_Object_InfoMoney_isService()

DROP FUNCTION IF EXISTS gpUpdate_Object_InfoMoney_isService (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_InfoMoney_isService(
    IN inId                  Integer   ,  -- ���� ������� <> 
    IN inisService           Boolean   , 
   OUT outisService          Boolean   , 
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_InfoMoney_Service());
   vbUserId:= lpGetUserBySession (inSession);

   outisService:= NOT inisService;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_InfoMoney_Service(), inId, outisService);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.05.22         *
*/

-- ����
--