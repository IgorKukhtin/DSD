-- Function: gpUpdate_Goods_isSP()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSP(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSP(
    IN inId                Integer   ,    -- ���� ������� <�����>
    IN inisSP              Boolean   ,    -- ��������� � ���. �������
   OUT outisSP             Boolean   ,
    IN inSession           TVarChar       -- ������� ������������
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
   outisSP:= NOT inisSP;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), inId, outisSP);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 19.12.16         *

*/