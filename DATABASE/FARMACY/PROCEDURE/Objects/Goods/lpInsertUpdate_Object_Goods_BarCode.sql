-- Function: lpInsertUpdate_Object_Goods_BarCode()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_BarCode(Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_BarCode(
    IN inGoodsMainId             Integer   ,    -- ���� ������� <�����>
    IN inBarCodeID               Integer   ,    -- Id ��������� �������� 
    IN inBarCode                 TVarChar  ,    -- ��������
    IN inUserId                  Integer        -- 
)
RETURNS VOID AS
$BODY$
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   -- ��������� � ������� �������
   BEGIN
    
     IF EXISTS(SELECT 1 FROM Object_Goods_BarCode 
               WHERE Object_Goods_BarCode.GoodsMainId = inGoodsMainId
               AND Object_Goods_BarCode.BarCodeId = inBarCodeID)
     THEN 
       UPDATE Object_Goods_BarCode SET BarCode = inBarCode
       WHERE Object_Goods_BarCode.GoodsMainId = inGoodsMainId
         AND Object_Goods_BarCode.BarCodeId = inBarCodeID;  
     ELSE
       INSERT INTO Object_Goods_BarCode (GoodsMainId, BarCodeId, BarCode)
       VALUES (inGoodsMainId, inBarCodeID, inBarCode);        
     END IF;
     
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_BarCode', text_var1::TVarChar, vbUserId);
   END;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 18.10.19                                                      * 

*/

-- ����
