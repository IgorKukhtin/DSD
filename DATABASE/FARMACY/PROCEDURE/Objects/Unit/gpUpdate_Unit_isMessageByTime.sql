-- Function: gpUpdate_Unit_isMessageByTime()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isMessageByTime(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isMessageByTime(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisMessageByTime         Boolean   ,    -- ��������� � ����� �� ������
   OUT outisMessageByTime        Boolean   ,
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
   outisMessageByTime:= NOT inisMessageByTime;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_MessageByTime(), inId, outisMessageByTime);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.04.21                                                       *
*/