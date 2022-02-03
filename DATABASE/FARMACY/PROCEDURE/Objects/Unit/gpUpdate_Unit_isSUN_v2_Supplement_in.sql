-- Function: gpUpdate_Unit_isSUN_v2_Supplement_in()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_v2_Supplement_in(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_v2_Supplement_in(
    IN inId                         Integer   ,    -- ���� ������� <�������������>
    IN inisSUN_v2_Supplement_in     Boolean   ,    -- �������� �� ���
   OUT outisSUN_v2_Supplement_in    Boolean   ,
    IN inSession                    TVarChar       -- ������� ������������
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
   outisSUN_v2_Supplement_in:= NOT inisSUN_v2_Supplement_in;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2_Supplement_in(), inId, outisSUN_v2_Supplement_in);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.12.20                                                       *
*/