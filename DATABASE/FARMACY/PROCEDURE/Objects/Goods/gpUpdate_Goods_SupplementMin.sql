-- Function: gpUpdate_Goods_SupplementMin()

DROP FUNCTION IF EXISTS gpUpdate_Goods_SupplementMin(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_SupplementMin(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inSupplementMin           Integer  ,    -- ���������� ���1
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
   
   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_SupplementMin(), inGoodsMainId, inSupplementMin);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET SupplementMin = inSupplementMin
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_SupplementMin', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.10.21                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_SupplementMin(inGoodsMainId := 39513 , inSupplementMin := 100,  inSession := '3');