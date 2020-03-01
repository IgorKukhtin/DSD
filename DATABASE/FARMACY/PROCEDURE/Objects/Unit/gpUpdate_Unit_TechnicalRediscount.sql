-- Function: gpUpdate_Unit_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpUpdate_Unit_TechnicalRediscount(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_TechnicalRediscount(
    IN inId                       Integer   ,    -- ���� ������� <�������������>
    IN inisTechnicalRediscount    Boolean   ,    -- ����������� ��������
   OUT outisTechnicalRediscount   Boolean   ,
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
   outisTechnicalRediscount:= NOT inisTechnicalRediscount;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_TechnicalRediscount(), inId, outisTechnicalRediscount);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.02.20                                                       *
*/