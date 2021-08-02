-- Function: gpUpdate_Unit_isParticipDistribListDiff()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isParticipDistribListDiff(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isParticipDistribListDiff(
    IN inId                            Integer   ,    -- ���� ������� <�������������>
    IN inisParticipDistribListDiff     Boolean   ,    -- ��������� � ������������� ������ ��� ������ ��� ����������
    IN inSession                       TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ParticipDistribListDiff(), inId, not inisParticipDistribListDiff);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.07.21                                                       *
*/