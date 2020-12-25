-- Function: gpUpdate_Unit_isSUN_Supplement_in()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_Supplement_in(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_Supplement_in(
    IN inId                       Integer   ,    -- ���� ������� <�������������>
    IN inisSUN_Supplement_in     Boolean   ,    -- �������� �� ���
   OUT outisSUN_Supplement_in    Boolean   ,
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
   outisSUN_Supplement_in:= NOT inisSUN_Supplement_in;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_Supplement_in(), inId, outisSUN_Supplement_in);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.12.20                                                       *
*/