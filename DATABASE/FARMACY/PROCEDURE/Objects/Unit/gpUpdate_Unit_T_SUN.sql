-- Function: gpUpdate_Unit_T_SUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_T_SUN(Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_T_SUN(
    IN inId             Integer   ,    -- ���� ������� <�������������>
    IN inisT1_SUN_v2    Boolean    ,    --
    IN inisT2_SUN_v2    Boolean    ,    --
    IN inisT1_SUN_v4    Boolean    ,    --
    IN inT1_SUN_v2      TFloat    ,    --
    IN inT2_SUN_v2      TFloat    ,    --
    IN inT1_SUN_v4      TFloat    ,    --
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

   IF COALESCE (inisT1_SUN_v2, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T1_SUN_v2(), inId, inT1_SUN_v2);
   END IF;
   
   IF COALESCE (inisT2_SUN_v2, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T2_SUN_v2(), inId, inT2_SUN_v2);
   END IF;
   
   IF COALESCE (inisT1_SUN_v4, FALSE) = TRUE
   THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T1_SUN_v4(), inId, inT1_SUN_v4);
   END IF;
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.04.20         *
*/