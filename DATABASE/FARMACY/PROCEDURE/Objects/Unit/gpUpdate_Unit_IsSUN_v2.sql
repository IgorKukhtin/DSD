-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_v2 (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_v2 (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_v2(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisSUN_v2            Boolean   ,    -- �������� �� ���
   OUT outisSUN_v2           Boolean   ,
    IN inDescName            TVarChar  ,    -- 
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
   outisSUN_v2:= NOT inisSUN_v2;

   PERFORM lpInsertUpdate_ObjectBoolean (ObjectBooleanDesc.Id, inId, outisSUN_v2)
   FROM ObjectBooleanDesc
   WHERE ObjectBooleanDesc.Code = inDescName;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.19         *
*/
--zc_ObjectBoolean_Unit_SUN_v2()