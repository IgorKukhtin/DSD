-- Function: gpUpdate_Goods_inSupplementSUN2_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN2_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN2_Revert(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisSupplementSUN2        Boolean  ,    -- ���������� ���1
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
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN2(), inGoodsMainId, not inisSupplementSUN2);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isSupplementSUN2 = not inisSupplementSUN2
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inSupplementSUN2_Revert', text_var1::TVarChar, vbUserId);
   END;
   

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.20                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_inSupplementSUN2_Revert(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');