-- Function: gpUpdate_Unit_SetDateRRO()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetDateRRO(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetDateRRO(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inSetDateRRO          TDateTime ,    -- ��������������� ��	
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SetDateRRO(), inId, inSetDateRRO);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.09.22                                                       *
*/