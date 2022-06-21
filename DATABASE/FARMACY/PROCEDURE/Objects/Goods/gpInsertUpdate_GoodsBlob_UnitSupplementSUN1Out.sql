-- Function: gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out()

DROP FUNCTION IF EXISTS gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(
    IN inGoodsMainId               Integer   ,   -- ���� ������� <�����>
    IN inUnitSupplementSUN1OutId   Integer  ,    -- ������������� ��� �������� �� ���������� ���1
    IN inSession                   TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbUnit    TBlob;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   vbUnit := (SELECT Object_Goods_Blob.UnitSupplementSUN1Out
              FROM Object_Goods_Blob  
              WHERE Object_Goods_Blob.Id = inGoodsMainId); 
              
   IF COALESCE (vbUnit, '') <> ''
   THEN
     IF ','||vbUnit||',' NOT ILIKE '%,'||inUnitSupplementSUN1OutId::TBlob||',%'
     THEN
       vbUnit := vbUnit||','||inUnitSupplementSUN1OutId::TBlob;
     END IF;
   ELSE 
     vbUnit := inUnitSupplementSUN1OutId::TBlob;
   END IF;
      
    -- ��������� � ������� �������
   BEGIN
     IF EXISTS (SELECT Object_Goods_Blob.Id
                FROM Object_Goods_Blob  
                WHERE Object_Goods_Blob.Id = inGoodsMainId)
     THEN
       UPDATE Object_Goods_Blob SET UnitSupplementSUN1Out = vbUnit
       WHERE Object_Goods_Blob.Id = inGoodsMainId;  
     ELSE
       INSERT INTO Object_Goods_Blob (Id, UnitSupplementSUN1Out)
       VALUES(inGoodsMainId, vbUnit);       
     END IF;
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.06.22                                                       *  

*/

-- ����
-- select * from gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId := 2389216 , inUnitSupplementSUN1Out := 377610 ,  inSession := '3');