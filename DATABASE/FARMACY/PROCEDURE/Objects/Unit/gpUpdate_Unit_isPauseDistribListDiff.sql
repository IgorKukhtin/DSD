-- Function: gpUpdate_Unit_isPauseDistribListDiff()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isPauseDistribListDiff(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isPauseDistribListDiff(
    IN inId                         Integer   ,    -- ���� ������� <�������������>
    IN inisPauseDistribListDiff     Boolean   ,    -- ��������� ����� ��� �������� ������� �� ����
    IN inSession                    TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PauseDistribListDiff(), inId, not inisPauseDistribListDiff);
   
   IF COALESCE (inisPauseDistribListDiff, FALSE) = FALSE
   THEN
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_RequestDistribListDiff(), inId, False);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.07.21                                                       *
*/