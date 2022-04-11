-- Function: gpUpdate_Unit_SUN_NotSoldIn()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SUN_NotSoldIn(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SUN_NotSoldIn(
    IN inId                Integer   ,    -- ���� ������� <�������������>
    IN inisSUN_NotSoldIn   Boolean   ,    -- �������� �� ���
   OUT outisSUN_NotSoldIn  Boolean   ,
    IN inSession           TVarChar       -- ������� ������������
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
   outisSUN_NotSoldIn:= NOT inisSUN_NotSoldIn;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_NotSoldIn(), inId, outisSUN_NotSoldIn);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.04.22                                                       *
*/