-- Function: gpUpdate_Goods_Multiplicity()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Multiplicity(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Multiplicity(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inMultiplicity            Integer  ,    -- ���������� ���1
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
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Multiplicity(), inGoodsMainId, inMultiplicity);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET Multiplicity = inMultiplicity
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Multiplicity', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.03.21                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_Multiplicity(inGoodsMainId := 39513 , inMultiplicity := '',  inSession := '3');