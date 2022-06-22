-- Function: gpDelete_GoodsBlob_UnitSupplementSUN1Out()

DROP FUNCTION IF EXISTS gpDelete_GoodsBlob_UnitSupplementSUN1Out(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_GoodsBlob_UnitSupplementSUN1Out(
    IN inGoodsMainId               Integer   ,   -- ���� ������� <�����>
    IN inUnitSupplementSUN1OutId   Integer  ,    -- ������������� ��� �������� �� ���������� ���1
    IN inSession                   TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbUnit    TBlob;
   DECLARE vbUnitNEW TBlob;
   DECLARE text_var1 text;
   DECLARE vbIndex Integer;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   vbUnit := (SELECT Object_Goods_Blob.UnitSupplementSUN1Out
              FROM Object_Goods_Blob  
              WHERE Object_Goods_Blob.Id = inGoodsMainId); 
              
   IF COALESCE (vbUnit, '') = ''
   THEN
     RETURN;
   END IF;

   IF ','||vbUnit||',' NOT ILIKE '%,'||inUnitSupplementSUN1OutId::TBlob||',%'
   THEN
     RETURN;
   END IF;

   vbUnitNEW := Null;
      
   IF vbUnit <> inUnitSupplementSUN1OutId::TBlob
   THEN
     -- ������ �������������
     vbIndex := 1;
     WHILE SPLIT_PART (vbUnit, ',', vbIndex) <> '' LOOP
       -- ���������
       IF SPLIT_PART (vbUnit, ',', vbIndex) <> inUnitSupplementSUN1OutId::TBlob
       THEN
         IF COALESCE (vbUnitNEW, '') = ''
         THEN
           vbUnitNEW := SPLIT_PART (vbUnit, ',', vbIndex);
         ELSE
           vbUnitNEW := vbUnitNEW||','||SPLIT_PART (vbUnit, ',', vbIndex);         
         END IF;
       END IF;  
       -- ������ ����������
       vbIndex := vbIndex + 1;
     END LOOP;
   END IF;
      
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Blob SET UnitSupplementSUN1Out = vbUnitNEW
     WHERE Object_Goods_Blob.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpDelete_GoodsBlob_UnitSupplementSUN1Out', text_var1::TVarChar, vbUserId);
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
-- select * from gpDelete_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId := 2389216 , inUnitSupplementSUN1Out := 377610 ,  inSession := '3');