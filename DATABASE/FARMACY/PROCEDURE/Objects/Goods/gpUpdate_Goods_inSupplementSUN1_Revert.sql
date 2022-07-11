-- Function: gpUpdate_Goods_inSupplementSUN1_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN1_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN1_Revert(
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

   -- ��������� �������� <���������� ���1>
   PERFORM gpUpdate_Goods_inSupplementSUN1 (inGoodsMainId, not inisSupplementSUN1, inSession);
   -- ��������� �������� <���������� ���1 ���������>
   PERFORM gpUpdate_Goods_inSupplementMarkSUN1_Revert (inGoodsMainId, inisSupplementSUN1, inSession);
   

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.20                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_inSupplementSUN1_Revert(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');