-- Function: gpUpdate_Goods_inInvisibleSUN_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inInvisibleSUN_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inInvisibleSUN_Revert(
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

   -- ��������� �������� <��������� ��� ����������� �� ���>
   PERFORM gpUpdate_Goods_inInvisibleSUN (inGoodsMainId, not inisInvisibleSUN, inSession);
   

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.05.20                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_inInvisibleSUN_Revert(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');