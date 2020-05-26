-- Function: gpUpdate_Unit_LimitSUN_N()

DROP FUNCTION IF EXISTS gpUpdate_Unit_LimitSUN_N(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_LimitSUN_N(
    IN inId             Integer   ,    -- ���� ������� <�������������>
    IN inLimitSUN_N     TFloat    ,    --
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

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_LimitSUN_N(), inId, inLimitSUN_N);
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.05.20         *
*/