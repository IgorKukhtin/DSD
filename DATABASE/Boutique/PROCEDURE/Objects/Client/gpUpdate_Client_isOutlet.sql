-- Function: gpUpdate_Client_isOutlet()

DROP FUNCTION IF EXISTS gpUpdate_Client_isOutlet(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Client_isOutlet(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisOutlet            Boolean   ,    -- ���������� �����. � ���. Outlet ��/���
   OUT outisOutlet           Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Client_isOutlet());

   -- ���������� �������
   outisOutlet:= NOT inisOutlet;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Client_Outlet(), inId, outisOutlet);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.09.19         *

*/