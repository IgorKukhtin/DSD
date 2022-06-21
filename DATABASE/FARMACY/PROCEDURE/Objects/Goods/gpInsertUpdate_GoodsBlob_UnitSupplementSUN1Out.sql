-- Function: gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out()

DROP FUNCTION IF EXISTS gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(
    IN inGoodsMainId               Integer   ,   -- ключ объекта <Товар>
    IN inUnitSupplementSUN1OutId   Integer  ,    -- Подразделения для отправки по дополнению СУН1
    IN inSession                   TVarChar      -- текущий пользователь
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
      
    -- Сохранили в плоскую таблицй
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.06.22                                                       *  

*/

-- тест
-- select * from gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId := 2389216 , inUnitSupplementSUN1Out := 377610 ,  inSession := '3');