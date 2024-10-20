-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisSUN               Boolean   ,    -- �������� �� ���
   OUT outisSUN              Boolean   ,
   OUT outisSUA              Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisSUN:= NOT inisSUN;
   outisSUA:= outisSUN;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN(), inId, outisSUN);
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUA(), inId, outisSUN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.19         *
*/