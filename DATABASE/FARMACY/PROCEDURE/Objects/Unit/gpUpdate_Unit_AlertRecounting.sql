-- Function: gpUpdate_Unit_AlertRecounting()

DROP FUNCTION IF EXISTS gpUpdate_Unit_AlertRecounting(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_AlertRecounting(
    IN inId                       Integer   ,    -- ���� ������� <�������������>
    IN inisAlertRecounting    Boolean   ,    -- ����������� ��������
   OUT outisAlertRecounting   Boolean   ,
    IN inSession                  TVarChar       -- ������� ������������
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
   outisAlertRecounting:= NOT inisAlertRecounting;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_AlertRecounting(), inId, outisAlertRecounting);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.04.20                                                       *
*/