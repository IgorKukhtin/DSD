-- Function: gpUpdate_Goods_inInvisibleSUN()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inInvisibleSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inInvisibleSUN(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisInvisibleSUN          Boolean  ,    -- ��������� ��� ����������� �� ���
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
   
   -- ��������� �������� <��������� ��� ����������� �� ���>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_InvisibleSUN(), inGoodsMainId, inisInvisibleSUN);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isInvisibleSUN = inisInvisibleSUN
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inInvisibleSUN', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.05.20                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_inInvisibleSUN(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');