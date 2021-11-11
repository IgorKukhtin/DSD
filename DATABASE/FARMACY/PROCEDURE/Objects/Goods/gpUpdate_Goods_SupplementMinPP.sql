-- Function: gpUpdate_Goods_SupplementMinPP()

DROP FUNCTION IF EXISTS gpUpdate_Goods_SupplementMinPP(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_SupplementMinPP(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inSupplementMinPP           Integer  ,    -- ���������� ���1
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
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_SupplementMinPP(), inGoodsMainId, inSupplementMinPP);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET SupplementMinPP = inSupplementMinPP
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_SupplementMinPP', text_var1::TVarChar, vbUserId);
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
--select * from gpUpdate_Goods_SupplementMinPP(inGoodsMainId := 39513 , inSupplementMinPP := 100,  inSession := '3');