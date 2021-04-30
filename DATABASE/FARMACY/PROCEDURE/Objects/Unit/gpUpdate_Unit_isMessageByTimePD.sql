-- Function: gpUpdate_Unit_isMessageByTimePD()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isMessageByTimePD(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isMessageByTimePD(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisMessageByTimePD       Boolean   ,    -- ��������� � ����� �� ������
   OUT outisMessageByTimePD      Boolean   ,
    IN inSession                 TVarChar       -- ������� ������������
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
   outisMessageByTimePD:= NOT inisMessageByTimePD;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_MessageByTimePD(), inId, outisMessageByTimePD);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.04.21                                                       *
*/