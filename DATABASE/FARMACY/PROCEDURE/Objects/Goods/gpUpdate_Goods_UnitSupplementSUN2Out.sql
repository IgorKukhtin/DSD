-- Function: gpUpdate_Goods_UnitSupplementSUN2Out()

DROP FUNCTION IF EXISTS gpUpdate_Goods_UnitSupplementSUN2Out(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_UnitSupplementSUN2Out(
    IN inGoodsMainId               Integer   ,   -- ���� ������� <�����>
    IN inUnitSupplementSUN2OutiD   Integer  ,    -- ������������� ��� �������� �� ���������� ���1
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
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN2Out(), inGoodsMainId, inUnitSupplementSUN2OutiD);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET UnitSupplementSUN2OutId = inUnitSupplementSUN2OutiD
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_UnitSupplementSUN2Out', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.01.21                                                       *  

*/

-- ����
-- select * from gpUpdate_Goods_UnitSupplementSUN2Out(inGoodsMainId := 2389216 , inUnitSupplementSUN2Out := 377610 ,  inSession := '3');