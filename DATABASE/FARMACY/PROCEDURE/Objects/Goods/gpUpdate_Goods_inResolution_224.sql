-- Function: gpUpdate_Goods_inResolution_224()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inResolution_224(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inResolution_224(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisResolution_224        Boolean  ,    -- ��������� 224
    IN inSession                 TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� �������� <�������� �������� ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Resolution_224(), inGoodsMainId, inisResolution_224);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isResolution_224 = inisResolution_224
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inResolution_224', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.10.19                                                       *  
 16.08.17                                                       *

*/

-- ����
--select * from gpUpdate_Goods_inResolution_224(inGoodsMainId := 39513 , inisResolution_224 := '',  inSession := '3');