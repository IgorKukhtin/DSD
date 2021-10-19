-- Function: gpUpdate_Goods_inSupplementSUN1Smudge()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN1Smudge(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN1Smudge(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisSupplementSmudge      Boolean  ,    -- ���������� ���1
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
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1Smudge(), inGoodsMainId, NOT inisSupplementSmudge);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isSupplementSmudge = NOT inisSupplementSmudge
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inSupplementSUN1Smudge', text_var1::TVarChar, vbUserId);
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
--select * from gpUpdate_Goods_inSupplementSUN1Smudge(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');