-- Function: gpUpdate_Unit_isAutospaceOS()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isAutospaceOS(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isAutospaceOS(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisAutospaceOS       Boolean   ,    -- ��������������� ��	
   OUT outisAutospaceOS      Boolean   ,    -- ��������������� ��	
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisAutospaceOS:= NOT inisAutospaceOS;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_AutospaceOS(), inId, outisAutospaceOS);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.09.22                                                       *
*/