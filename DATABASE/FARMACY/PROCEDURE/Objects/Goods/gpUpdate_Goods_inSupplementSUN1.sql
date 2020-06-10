-- Function: gpUpdate_Goods_inSupplementSUN1()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN1(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN1(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisSupplementSUN1        Boolean  ,    -- ���������� ���1
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
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1(), inGoodsMainId, inisSupplementSUN1);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isSupplementSUN1 = inisSupplementSUN1
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inSupplementSUN1', text_var1::TVarChar, vbUserId);
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
--select * from gpUpdate_Goods_inSupplementSUN1(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');