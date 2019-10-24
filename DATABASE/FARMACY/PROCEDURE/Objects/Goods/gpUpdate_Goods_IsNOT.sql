-- Function: gpUpdate_Object_Goods_IsHOT()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isNOT(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isNOT(
    IN inId        Integer   ,    -- ���� ������� <�����>
    IN inisNOT     Boolean   ,    -- ���-�������������� �������
    IN inSession   TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   --
   vbUserId := lpGetUserBySession (inSession);

   -- ��������� ��-��
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_NOT(), inId, inisNOT);

   outisNOT:=
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.10.19         * 
*/