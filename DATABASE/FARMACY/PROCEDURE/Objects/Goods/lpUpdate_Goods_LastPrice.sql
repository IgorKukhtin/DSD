-- Function: lpUpdate_Goods_LastPrice()

DROP FUNCTION IF EXISTS lpUpdate_Goods_LastPrice(Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Goods_LastPrice(
    IN inGoodsMainId             Integer   ,    -- ���� ������� <�����>
    IN inLastPriceDate           TDateTime ,    -- ���� �������� ������ 
    IN inUserId                  Integer        -- 
)
RETURNS VOID AS
$BODY$
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET LastPrice = inLastPriceDate
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('lpUpdate_Goods_LastPrice', text_var1::TVarChar, vbUserId);
   END;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.10.19                                                       *

*/