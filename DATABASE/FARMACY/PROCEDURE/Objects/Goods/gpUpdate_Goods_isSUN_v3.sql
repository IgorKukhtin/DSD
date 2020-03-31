-- Function: gpUpdate_Goods_isSUN_v3()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSUN_v3(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSUN_v3(
    IN inId               Integer   ,    -- ���� ������� <�����>
    IN inisSUN_v3         Boolean   ,    -- �������� �� �-���
   OUT outisSUN_v3        Boolean   ,    -- �������� �� �-���
    IN inSession          TVarChar       -- ������� ������������
)
RETURNS BOOLEAN AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   --
   vbUserId := lpGetUserBySession (inSession);
   
   outisSUN_v3 := inisSUN_v3;

   -- ��������� ��-��
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SUN_v3(), inId, inisSUN_v3);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Retail SET isSUN_v3 = inisSUN_v3
     WHERE Object_Goods_Retail.GoodsMainId IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isSUN_v3', text_var1::TVarChar, vbUserId);
   END;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.03.20         *
*/