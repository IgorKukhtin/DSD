-- Function: gpUpdate_Unit_isOutUKTZED_SUN1()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isOutUKTZED_SUN1(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isOutUKTZED_SUN1(
    IN inId                       Integer   ,    -- ���� ������� <�������������>
    IN inisOutUKTZED_SUN1         Boolean   ,    -- �������� �� ���
   OUT outisOutUKTZED_SUN1        Boolean   ,
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
   outisOutUKTZED_SUN1:= NOT inisOutUKTZED_SUN1;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_OutUKTZED_SUN1(), inId, outisOutUKTZED_SUN1);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.01.21                                                       *
*/