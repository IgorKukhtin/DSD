-- Function: gpUpdate_Unit_SUN_v2_LockSale()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SUN_v2_LockSale(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SUN_v2_LockSale(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisSUN_v2_LockSale   Boolean   ,    -- ��������� � ���������������
   OUT outisSUN_v2_LockSale  Boolean   ,
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
   outisSUN_v2_LockSale:= NOT inisSUN_v2_LockSale;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2_LockSale(), inId, outisSUN_v2_LockSale);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.05.20         *
*/