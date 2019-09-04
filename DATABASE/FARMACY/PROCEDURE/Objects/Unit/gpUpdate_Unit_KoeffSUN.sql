-- Function: gpUpdate_Unit_KoeffSUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_KoeffSUN(Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_KoeffSUN(
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
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffInSUN(), inId, inKoeffInSUN);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffOutSUN(), inId, inKoeffOutSUN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.09.19         *
*/