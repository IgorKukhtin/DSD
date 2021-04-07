-- Function: gpUpdate_Unit_isGoodsUKTZEDRRO()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isGoodsUKTZEDRRO(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isGoodsUKTZEDRRO(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisGoodsUKTZEDRRO        Boolean   ,    -- ������ �� ������ ����, ���� ���� ������� �� ������
   OUT outisGoodsUKTZEDRRO       Boolean   ,
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
   outisGoodsUKTZEDRRO:= NOT inisGoodsUKTZEDRRO;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_GoodsUKTZEDRRO(), inId, outisGoodsUKTZEDRRO);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.03.21                                                       *
*/