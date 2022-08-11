-- Function: gpUpdate_Object_Goods_IsLeftTheMarket()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isLeftTheMarket(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isLeftTheMarket(
    IN inGoodsMainId       Integer   ,    -- ���� ������� <�����>
    IN inisLeftTheMarket   Boolean   ,    -- ���-�������������� �������
    IN inSession           TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   --
   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� ��-��
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_LeftTheMarket(), inGoodsMainId, inisLeftTheMarket);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isLeftTheMarket = inisLeftTheMarket
                                , DateLeftTheMarket = CASE WHEN inisLeftTheMarket = TRUE THEN CURRENT_DATE ELSE DateLeftTheMarket END
     WHERE Object_Goods_Main.ID = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isLeftTheMarket', text_var1::TVarChar, vbUserId);
   END;

   --outisLeftTheMarket:=
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.08.22                                                       *
*/