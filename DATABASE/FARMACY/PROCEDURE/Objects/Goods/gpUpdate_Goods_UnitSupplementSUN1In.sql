-- Function: gpUpdate_Goods_UnitSupplementSUN1In()

DROP FUNCTION IF EXISTS gpUpdate_Goods_UnitSupplementSUN1In(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_UnitSupplementSUN1In(
    IN inGoodsMainId               Integer   ,   -- ���� ������� <�����>
    IN inUnitSupplementSUN1InId    Integer  ,    -- ������ ���������� ��� ������ ���������� ���1
    IN inSession                   TVarChar      -- ������� ������������
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
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN1In(), inGoodsMainId, inUnitSupplementSUN1InId);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET UnitSupplementSUN1InId = inUnitSupplementSUN1InId
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_UnitSupplementSUN1In', text_var1::TVarChar, vbUserId);
   END;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.07.22                                                       *  

*/

-- ����
-- select * from gpUpdate_Goods_UnitSupplementSUN1In(inGoodsMainId := 24168 , inUnitSupplementSUN1InId := 375626 ,  inSession := '3');
-- select * from gpUpdate_Goods_UnitSupplementSUN1In(inGoodsMainId := 24168 , inUnitSupplementSUN1InId := 1529734 ,  inSession := '3');