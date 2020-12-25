-- Function: gpUpdate_Unit_isSUN_Supplement_out()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_Supplement_out(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_Supplement_out(
    IN inId                       Integer   ,    -- ���� ������� <�������������>
    IN inisSUN_Supplement_out     Boolean   ,    -- �������� �� ���
   OUT outisSUN_Supplement_out    Boolean   ,
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
   outisSUN_Supplement_out:= NOT inisSUN_Supplement_out;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_Supplement_out(), inId, outisSUN_Supplement_out);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.12.20                                                       *
*/