-- Function: gpUpdate_Unit_isCheckUKTZED()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isCheckUKTZED(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isCheckUKTZED(
    IN inId                   Integer   ,    -- ���� ������� <�������������>
    IN inisCheckUKTZED        Boolean   ,    -- ������ �� ������ ����, ���� ���� ������� �� ������
   OUT outisCheckUKTZED       Boolean   ,
    IN inSession              TVarChar       -- ������� ������������
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
   outisCheckUKTZED:= NOT inisCheckUKTZED;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_CheckUKTZED(), inId, outisCheckUKTZED);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.01.21                                                       *
*/