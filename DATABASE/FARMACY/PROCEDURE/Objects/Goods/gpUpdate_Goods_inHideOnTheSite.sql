-- Function: gpUpdate_Goods_inHideOnTheSite()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inHideOnTheSite(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inHideOnTheSite(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisHideOnTheSite         Boolean  ,    -- �������� �� ����� ��� � ������� � � ���������
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
   
   -- ��������� �������� <�������� �� ����� ��� � ������� � � ���������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_HideOnTheSite(), inGoodsMainId, inisHideOnTheSite);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isHideOnTheSite = inisHideOnTheSite
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inHideOnTheSite', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.11.21                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_inHideOnTheSite(inGoodsMainId := 39513 , inisHideOnTheSite := '',  inSession := '3');gpUpdate_Goods_inHideOnTheSite