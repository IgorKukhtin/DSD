-- Function: gpUpdate_Object_Account_PrintDetail (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Account_PrintDetail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Account_PrintDetail(
    IN inId                     Integer,    -- ���� ������� <����>
    IN inIsPrintDetail          Boolean,    -- �������� ����������� ��� ������
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE (inId,0) = 0
   THEN
       RETURN;
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Account_PrintDetail(), inId, inIsPrintDetail);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.01.19         *
*/
