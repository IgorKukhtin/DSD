-- Function: lpUpdate_Goods_MorionCode()

DROP FUNCTION IF EXISTS lpUpdate_Object_Goods_MorionCode(Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Goods_MorionCode(
    IN inGoodsMainId             Integer   ,    -- ���� ������� <�����>
    IN inMorionCode              Integer   ,    -- ������. ���� ������� �� �����
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
     IF COALESCE((SELECT MorionCode FROM Object_Goods_Main  WHERE Object_Goods_Main.Id = inGoodsMainId), 0) <> COALESCE(inMorionCode, 0)
     THEN
       UPDATE Object_Goods_Main SET MorionCode = NULLIF(inMorionCode, 0)
       WHERE Object_Goods_Main.Id = inGoodsMainId;  
     END IF;
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('lpUpdate_Object_Goods_MorionCode', text_var1::TVarChar, vbUserId);
   END;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 18.10.19                                                      * 

*/

-- ����
