-- Function: gpUodate_Cash_DoesNotShare()

DROP FUNCTION IF EXISTS gpUodate_Cash_DoesNotShare(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUodate_Cash_DoesNotShare(
    IN inGoodsID             Integer   ,    -- ���� ������� <�����>
    IN inDoesNotShare        BOOLEAN   ,    -- ������� ���������� ������� �������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsID, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_DoesNotShare(), inGoodsID, inDoesNotShare);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isDoesNotShare = inDoesNotShare
     WHERE Object_Goods_Main.Id IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsID);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_DoesNotShare', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsID, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUodate_Cash_DoesNotShare(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.   ������ �.�.
 09.03.19                                                                        *

*/