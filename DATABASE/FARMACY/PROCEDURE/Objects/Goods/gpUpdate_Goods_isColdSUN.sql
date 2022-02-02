-- Function: gpUpdate_Goods_isColdSUN()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isColdSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isColdSUN(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inisColdSUN               Boolean  ,    -- ����� ��� ���
    IN inSession                 TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� �������� <����� ��� ���>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_ColdSUN(), inGoodsMainId, not inisColdSUN);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET isColdSUN = not inisColdSUN
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isColdSUN', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.02.20                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_isColdSUN(inGoodsMainId := 39513 , inisColdSUN := '',  inSession := '3');