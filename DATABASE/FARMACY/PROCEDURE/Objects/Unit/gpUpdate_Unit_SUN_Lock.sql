-- Function: gpUpdate_Unit_SUN_Lock()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SUN_Lock(Integer, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SUN_Lock(
    IN inId             Integer   ,    -- ���� ������� <�������������>
    IN inisV1           Boolean    ,    --
    IN inisV2           Boolean    ,    --
    IN inisV4           Boolean    ,    --
    IN inv1_Lock      TVarChar    ,    --
    IN inv2_Lock      TVarChar    ,    --
    IN inv4_Lock      TVarChar    ,    --
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE (inisV1, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_SUN_v1_Lock(), inId, inv1_Lock);
   END IF;
   
   IF COALESCE (inisV2, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_SUN_v2_Lock(), inId, inv2_Lock);
   END IF;
   
   IF COALESCE (inisV4, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_SUN_v4_Lock(), inId, inv4_Lock);
   END IF;
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.05.20         *
*/