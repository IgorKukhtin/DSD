-- Function: gpUpdate_Unit_KoeffSUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_KoeffSUN_v3(Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_KoeffSUN_v3(
    IN inId               Integer   ,    -- ���� ������� <�������������>
    IN inKoeffInSUN       TFloat    ,    --
    IN inKoeffOutSUN      TFloat    ,    --
    IN inSession          TVarChar       -- ������� ������������
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

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffInSUN_v3(), inId, inKoeffInSUN);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffOutSUN_v3(), inId, inKoeffOutSUN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.03.20         *
*/