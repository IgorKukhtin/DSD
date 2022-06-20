-- Function: gpUpdate_Goods_UnitSupplementSUN1Out()

DROP FUNCTION IF EXISTS gpUpdate_Goods_UnitSupplementSUN1Out(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_UnitSupplementSUN1Out(
    IN inGoodsMainId               Integer   ,   -- ���� ������� <�����>
    IN inUnitSupplementSUN1OutiD   Integer  ,    -- ������������� ��� �������� �� ���������� ���1
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
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN1Out(), inGoodsMainId, inUnitSupplementSUN1OutiD);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET UnitSupplementSUN1OutId = inUnitSupplementSUN1OutiD
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_UnitSupplementSUN1Out', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.01.21                                                       *  

*/

-- ����
-- select * from gpUpdate_Goods_UnitSupplementSUN1Out(inGoodsMainId := 2389216 , inUnitSupplementSUN1Out := 377610 ,  inSession := '3');