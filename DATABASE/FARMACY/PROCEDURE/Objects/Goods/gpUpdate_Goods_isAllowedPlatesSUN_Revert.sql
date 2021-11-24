-- Function: gpUpdate_Goods_isAllowedPlatesSUN_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isAllowedPlatesSUN_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isAllowedPlatesSUN_Revert(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisAllowedPlatesSUN          Boolean  ,    -- ��������� ��� ����������� �� ���
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
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_AllowedPlatesSUN(), inGoodsMainId, not inisAllowedPlatesSUN);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isAllowedPlatesSUN = not inisAllowedPlatesSUN
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isAllowedPlatesSUN', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.11.21                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_isAllowedPlatesSUN_Revert(inGoodsMainId := 39513 , inisAllowedPlatesSUN := '',  inSession := '3');