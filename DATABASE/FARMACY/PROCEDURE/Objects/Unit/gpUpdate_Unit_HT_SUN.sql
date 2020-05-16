-- Function: gpUpdate_Unit_HT_SUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_HT_SUN(Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_HT_SUN(
    IN inId             Integer   ,    -- ���� ������� <>
    IN inis_v1          Boolean   ,    --
    IN inis_v2          Boolean   ,    --
    IN inis_v4          Boolean   ,    --
    IN inHT_SUN_v1      TFloat    ,    --
    IN inHT_SUN_v2      TFloat    ,    --
    IN inHT_SUN_v4      TFloat    ,    --
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE text_var1    text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE (inis_v1, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_HT_SUN_v1(), inId, inHT_SUN_v1);
   END IF;
   
   IF COALESCE (inis_v2, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_HT_SUN_v2(), inId, inHT_SUN_v2);
   END IF;
   
   IF COALESCE (inis_v4, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_HT_SUN_v4(), inId, inHT_SUN_v4);
   END IF;
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.05.20         *
*/